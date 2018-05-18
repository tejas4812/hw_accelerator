//#####full handshake write######//


module full_hk_wclk(
input clk,
input rst_n,
output logic wr_vld,
input rd_ack,
input vld //valid from previous wr_clk domain block  
);

logic rd_ack_wclk;
logic rd_ack_wclk_reg;

logic wr_vld_nxt;


always@(*) begin
  if(~rd_ack_wclk & ~wr_vld) wr_vld_nxt=vld;
  else if (rd_ack_wclk & wr_vld) wr_vld_nxt=1'b0;
  else wr_vld_nxt=wr_vld; 
end

//flop wr_vld
always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    wr_vld <=8'h0;
    end
  else begin
     wr_vld<=wr_vld_nxt;
   end
end

//flop rd_ack data -Input
always@(posedge clk or  negedge rst_n) begin
  if(!rst_n) begin
      rd_ack_wclk<=8'h0;
      rd_ack_wclk_reg<=8'h0;
      end
  else begin
      rd_ack_wclk<=rd_ack;
      rd_ack_wclk_reg<=rd_ack_wclk;
      end 
end

endmodule

