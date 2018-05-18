//#####Bubble sort######//
//data_sort_o is the final output on last=1
//data_o has value of lowest element for each iteration and is valid when wr_en=1
//data_o can be use to write data into a RAM or can be simply used for debugging purpose 




module bubble_sort(
input clk,
input rst_n,
input [63:0] data,
input en,
output logic [7:0] data_o,
output logic [63:0] data_sort_o,  
output logic wr_en, 
output logic last
);

logic [7:0]L,H;//low and high indices
logic [7:0]L_nxt,H_nxt;

logic [1:0] state;
logic [1:0] state_nxt;

logic last_nxt;
logic wr_en_nxt;
logic [63:0] data_o_nxt;

logic [7:0] A_nxt;
logic [7:0] A;

logic [7:0] B_nxt;
logic [7:0] B;


logic en_reg;

logic [7:0] _max_nxt;
logic [7:0] _max_;

logic [63:0] data_in;
logic [63:0] data_in_reg;
logic [63:0] data_reg;
logic [63:0] data_reg0,data_reg1;

logic rdy_nxt;
logic rdy;





assign data_sort_o=data_in_reg;
assign state_nxt[0]=(B_nxt>=A_nxt);
assign state_nxt[1]=B_nxt<A_nxt;

assign last_nxt=(_max_nxt==1);
assign rdy_nxt=en_reg?1'b0:(last)?1'b1:rdy;

always@(*) begin
  data_in=data_in_reg;
  H_nxt=H;
  L_nxt=L;
  wr_en_nxt=1'b0;
  data_o_nxt=data_o;
  _max_nxt=_max_;
  if(H!=_max_) begin
    case(state)
    2'b01:begin
            H_nxt=H+1'b1; L_nxt=L;   
          end
    2'b10:begin
            L_nxt=H;H_nxt=H+1'b1;
          end
    endcase
  end
  else begin// Lower element found for this round
            H_nxt=1'b1;L_nxt=0;_max_nxt=_max_-1;
            wr_en_nxt=1'b1;
      case(state)
      2'b01:begin //swap
              data_o_nxt=A;
              case(H)
              'd0:data_in[7:0]=A;
              'd1:data_in[15:8]=A;
              'd2:data_in[23:16]=A; 
              'd3:data_in[31:24]=A;
              'd4:data_in[39:32]=A;
              'd5:data_in[47:40]=A;
              'd6:data_in[55:48]=A;
              'd7:data_in[63:56]=A;
              endcase
              case(L)
               'd0:data_in[7:0]=B;              
               'd1:data_in[15:8]=B;
               'd2:data_in[23:16]=B;
               'd3:data_in[31:24]=B;
               'd4:data_in[39:32]=B;
               'd5:data_in[47:40]=B;
               'd6:data_in[55:48]=B;
               'd7:data_in[63:56]=B;
              endcase
            end
        2'b10: begin
              data_in=data_in_reg;
                data_o_nxt= B;              
              end
       endcase
        
       end
end

//update A_nxt, B_nxt
always@(*) begin
  case(L_nxt)
    'd0:A_nxt=data_in[7:0];
    'd1:A_nxt=data_in[15:8];
    'd2:A_nxt=data_in[23:16]; 
    'd3:A_nxt=data_in[31:24];
    'd4:A_nxt=data_in[39:32];
    'd5:A_nxt=data_in[47:40];
    'd6:A_nxt=data_in[55:48];
    'd7:A_nxt=data_in[63:56];
  endcase
  case(H_nxt) 
     'd0:B_nxt=data_in[7:0];    
     'd1:B_nxt=data_in[15:8];
     'd2:B_nxt=data_in[23:16];
     'd3:B_nxt=data_in[31:24];
     'd4:B_nxt=data_in[39:32];
     'd5:B_nxt=data_in[47:40];
     'd6:B_nxt=data_in[55:48];
     'd7:B_nxt=data_in[63:56];
  endcase


end


always@(posedge clk or  negedge rst_n) begin
  if(!rst_n) begin
    last<=1'b1;
    state<=2'd0;
    data_reg0<=64'd0;
    data_reg1<=64'd0;
    data_o<=64'd0;  
    H<=8'd1;
    L<=8'd0;
    _max_<=8'd7;
    A<=8'h0;
    B<=8'h0;
    wr_en<=1'b0;
    en_reg<=1'b0;
    rdy<=1'b1;
  end
  else begin
    en_reg<=en;
    rdy<=rdy_nxt;
    last<=rdy_nxt?last:last_nxt;
    data_reg0<=data;
    data_reg1<=data_reg0;
    data_o<=rdy?data_o:data_o_nxt;//using reg rdy instead of rdy_nxt to get second lowest element output
    wr_en<=(en_reg|rdy)?1'b0:wr_en_nxt;

    state<=en_reg?2'd0:state_nxt;
    H<=(en_reg)?8'd1:(rdy_nxt)?H:H_nxt;
    L<=(en_reg)?8'd0:(rdy_nxt)?L:L_nxt; 
    _max_<=(en_reg)?'d7:(rdy_nxt)?_max_:_max_nxt;
    
    A<=(rdy_nxt)?A:A_nxt;
    B<=(rdy_nxt)?B:B_nxt;
    
    data_in_reg<=(en_reg)?data_reg0:data_in;
  end 

end


endmodule
