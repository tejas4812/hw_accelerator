//#####full handshake testbench#####/

`timescale 1ns/1ps
module full_hk_tb();
  logic clk,rst_n;
  logic vld;
  
  logic wr_vld;
  logic rd_ack;


 always #5 clk=~clk;

 initial begin
    clk=0;rst_n=0;
    #10
    rst_n=1;
    vld=0;
    @(posedge clk)
    vld=1;
    repeat(5) begin
      @(posedge clk)
      vld=0;    
      @(posedge clk);
      vld=1;
    end
    repeat(10) @(posedge clk);
    $finish(2);    
 end

 full_hk_wclk full_hk_wclk_i(
    .clk(clk),
    .rst_n(rst_n),
    .wr_vld(wr_vld),//O
    .rd_ack(rd_ack),
    .vld(vld) 
   );

  full_hk_rclk full_hk_rclk_i(
    .clk(clk),
    .rst_n(rst_n),
    .wr_vld(wr_vld),
    .rd_ack(rd_ack) //O
   );


endmodule



