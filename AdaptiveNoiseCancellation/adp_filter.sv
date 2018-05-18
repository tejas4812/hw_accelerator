//#####Adaptive Filter######//
//Module act as  noise cancellation device.
//It takes the reference noise signal, filters it and subtracts it from the received noise information signal
//Weights of the filters are adapted based on the input noise sample 
//#########################//


module adp_filter(
input clk,
input rst_n,
input [7:0] xin,
input [7:0] yin,
input vld,
output logic [7:0] eo,
output logic vldo,
output logic rdy   
);
parameter _2U_=2*0.1; 


logic vld_reg0;
logic vld_reg1;
logic [7:0] xin_reg;
logic [7:0] x_0;
logic [7:0] x_1;
logic [7:0] x_2;
logic [7:0] x_3;

logic [7:0] w_0_nxt;
logic [7:0]  w_0;
logic [7:0] w_1_nxt;
logic [7:0]  w_1;
logic [7:0] w_2_nxt;
logic [7:0]  w_2;
logic [7:0] w_3_nxt;
logic [7:0]  w_3;


logic [14:0] xw_0_nxt;
logic [14:0] xw_0;
logic [14:0] xw_1_nxt;
logic [14:0] xw_1;
logic [14:0] xw_2_nxt;
logic [14:0] xw_2;
logic [14:0] xw_3_nxt;
logic [14:0] xw_3;

logic [15:0] zpre_0_nxt; 
logic [15:0] zpre_1_nxt; 
logic [16:0] z_nxt;
logic [16:0] z;

logic [15:0] e_um_nxt;
logic [7:0] e_nxt;


logic [7:0] yin_reg;
logic [7:0] y;



assign e_um_nxt=e_nxt*_2U_;

assign w_0_nxt=w_0+x_0[7]?-e_um_nxt:e_um_nxt; 
assign w_1_nxt=w_1+x_1[7]?-e_um_nxt:e_um_nxt;
assign w_2_nxt=w_2+x_2[7]?-e_um_nxt:e_um_nxt;
assign w_3_nxt=w_3+x_3[7]?-e_um_nxt:e_um_nxt;

assign xw_0_nxt=x_0*w_0;
assign xw_1_nxt=x_1*w_1;
assign xw_2_nxt=x_2*w_2;
assign xw_3_nxt=x_3*w_3;
 
assign zpre_0_nxt=xw_0+xw_1;
assign zpre_1_nxt=xw_2+xw_3;
 
assign z_nxt= zpre_0_nxt+zpre_1_nxt;
 
assign e_nxt=y-((z[16:8]+1'b1)>>1);

//flop data
always@(posedge clk or  negedge rst_n) begin
  if(!rst_n) begin
    rdy<=1'b1;
    y<=8'h0;
    x_0<=8'h0;
    x_1<=8'h0;
    x_2<=8'h0;
    x_3<=8'h0;
    w_0<=8'h0;
    w_1<=8'h0;
    w_2<=8'h0;
    w_3<=8'h0;
    eo<=8'h0;
  end
  else begin
    rdy<=~vld_reg0;//rdy acts as a backpressure
    vldo<=vld_reg1;
    y<=(vld_reg0)?yin_reg:y;// noisy input
    x_0<=(vld_reg0)?xin_reg:x_0;//ref signal
    x_1<=(vld_reg0)?x_0:x_1;//ref signal
    x_2<=(vld_reg0)?x_1:x_2;//ref signal
    x_3<=(vld_reg0)?x_2:x_3;//ref signal
    w_0<=(vld_reg0)?w_0_nxt:w_0;//weights
    w_1<=(vld_reg0)?w_1_nxt:w_1;//weights
    w_2<=(vld_reg0)?w_2_nxt:w_2;//weights
    w_3<=(vld_reg0)?w_3_nxt:w_3;//weights
    xw_0<=xw_0_nxt;//x*w filter tap value
    xw_1<=xw_1_nxt;//x*w filter tap value
    xw_2<=xw_2_nxt;//x*w filter tap value
    xw_3<=xw_3_nxt;//x*w filter tap value
    z<=z_nxt;//filter output
    eo<=e_nxt;// final error or clean signal
  end 
end

//flop input
always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    vld_reg0<=1'b0;
    vld_reg1<=1'b0;
    xin_reg<=8'h0;
    yin_reg<=8'h0;
  end
  else begin
    vld_reg0<=vld;
    vld_reg1<=vld_reg0;
    xin_reg<=xin;
    yin_reg<=yin;
  end
end

endmodule
