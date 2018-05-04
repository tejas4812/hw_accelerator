module bin_search(
input clk,
input rst_n,
input [63:0] data,
input en,
input [7:0] X,
output logic [7:0] out,
output logic rdy,
output logic valid 
);

logic [7:0]S,E;//start and end indices
logic [7:0]S_nxt,E_nxt;
logic [7:0] M_nxt;
logic [7:0] M;

logic [2:0] state;
logic [2:0] state_nxt;

logic rdy_nxt;
logic valid_nxt;
logic [7:0] out_nxt;

logic [7:0] A_nxt;
logic [7:0] A;

logic [63:0] data_reg;
logic en_reg;
logic [7:0] X_reg;

logic state_en;


assign M_nxt= (S+E)>>1; 

//Assume decreasing order of input sequence array
assign state_nxt[0]=(!rdy)?(A_nxt==X_reg):3'd0;
assign state_nxt[1]=(!rdy)?(A_nxt>X_reg):3'd0;
assign state_nxt[2]=(!rdy)?(A_nxt<X_reg):3'd0;


always@(*) begin
  rdy_nxt=rdy;
  if(en_reg) begin
    rdy_nxt<=1'b0;
  end
  else if((S==E)|| state[0]) begin
    rdy_nxt<=1'b1;
  end
end


always@(*) begin
  out_nxt=0;
  S_nxt=en_reg?8'd0:S;
  E_nxt=en_reg?8'd7:E;
  valid_nxt=1'b0;
  if(state_en) begin
  case(1'b1)
    state[0]: begin
                if(rdy_nxt)begin
                  out_nxt=M;
                  valid_nxt=1'b1;
                end
              end 
    state[1]: begin
                S_nxt=M+1;//A<X
              end 
    state[2]: begin
                E_nxt=M-1; //less=A>X
              end
    default: begin end 
  endcase
  end
end

always@(*) begin
 A_nxt=A; 
 case(M_nxt) 
 8'd0: A_nxt= data_reg[7:0];
 8'd1: A_nxt= data_reg[15:8];
 8'd2: A_nxt= data_reg[23:16];
 8'd3: A_nxt= data_reg[31:24];
 8'd4: A_nxt= data_reg[39:32];
 8'd5: A_nxt= data_reg[47:40];
 8'd6: A_nxt= data_reg[55:48];
 8'd7: A_nxt= data_reg[63:56];
 endcase 
end


always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    state<=3'h0;  
    A<=8'd0;
    X_reg<=8'd0;
    M<=8'd255;
    S<=8'd0;
    E<=8'd7;
    rdy<=1'b1;
    out<=8'd0; 
    valid<=1'b0;
    data_reg<=63'd0;
    en_reg<=1'b0;
  end
  else begin
    state<=state_nxt;
    A<=A_nxt;
    X_reg<=en?X:X_reg;
    M<=M_nxt;
    S<=S_nxt;
    E<=E_nxt;
    rdy<=rdy_nxt;
    out<=out_nxt;
    valid<=valid_nxt;
    data_reg<=data;
    en_reg<=en;  
  end
end

always@(posedge clk or negedge rst_n) begin
  if(rst_n) begin
    state_en<=1'b1;
  end
  else begin
    state_en<=~state_en & ( |state);
  end

end
endmodule
