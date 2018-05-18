//#####cdc_handshake######//


module cdc_hk(
input wclk,
input rclk,
input wr_rst_n,
input rd_rst_n,
input  wr_vld,
output logic wr_rdy,
output logic rd_vld,
input rd_rdy
);

logic wr_flag,rd_flag;
logic wr_vld_nxt;

logic wr_flag_rclk_reg0; 
logic wr_flag_rclk_reg1;
logic rd_flag_wclk_reg0;
logic rd_flag_wclk_reg1;

//wr domain
assign wr_rdy=(wr_flag==rd_flag_wclk_reg1);


always@(posedge wclk or wr_rst_n) begin
  if(!wr_rst_n) begin
    wr_flag<=1'b0;
  end
  else if(wr_vld & wr_rdy) begin
    wr_flag<=~wr_flag;     
  end
end

always@(posedge wclk or wr_rst_n) begin
  if(!wr_rst_n) begin
    rd_flag_wclk_reg0<=1'b0;
    rd_flag_wclk_reg1<=1'b0; 
  end
    rd_flag_wclk_reg0<=rd_flag;
    rd_flag_wclk_reg1<=rd_flag_wclk_reg0;
end


//rd domain
assign rd_vld=(wr_flag_rclk_reg1^rd_flag);

always@(posedge rclk or rd_rst_n) begin
  if(!rd_rst_n) begin
    rd_flag<=1'b0; 
  end
  else if(rd_vld & rd_rdy) rd_flag<=~rd_flag;
end

always@(posedge rclk or rd_rst_n) begin
  if(!rd_rst_n) begin
    wr_flag_rclk_reg0<=1'b0;
    wr_flag_rclk_reg1<=1'b0; 
  end
    wr_flag_rclk_reg0<=wr_flag;
    wr_flag_rclk_reg1<=wr_flag_rclk_reg0;
end


endmodule

