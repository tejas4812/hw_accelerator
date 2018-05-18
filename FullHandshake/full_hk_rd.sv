//#####full hk read######//


module full_hk_rclk(
input clk,
input rst_n,
input wr_vld,
output logic rd_ack  
);

logic wr_vld_rclk;
logic rd_ack_nxt;

always@(*) begin
  if(wr_vld_rclk) rd_ack_nxt=1'b1;
  else if(~wr_vld_rclk) rd_ack_nxt=1'b0;  
end

//flop rd_ack_reg
always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    rd_ack <=8'h0;
    end
  else begin
     rd_ack<=rd_ack_nxt;
   end
end

//flop wr_vld data-Input
always@(posedge clk or  negedge rst_n) begin
  if(!rst_n) begin
      wr_vld_rclk<=8'h0;
      end
  else begin
      wr_vld_rclk<=wr_vld;
      end 
end

endmodule

