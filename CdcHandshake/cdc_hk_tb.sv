//#####cdc handshake testbench#####/

`timescale 1ns/1ps
module cdc_hk_tb();
  logic wclk,rclk,wr_rst_n,rd_rst_n;
  logic wr_vld;
  
  logic rd_rdy;

 always #2 wclk=~wclk;
 always #5 rclk=~rclk;

//wr domain
 initial begin
    wclk=0;wr_rst_n=0;
    #10
    wr_rst_n=1;
    wr_vld=0;
    @(posedge wclk)
    wr_vld=1;
    repeat(5) begin
      @(posedge wclk)
      wr_vld=0;    
      @(posedge wclk);
      wr_vld=1;
    end
    repeat(10) @(posedge wclk);
    $finish(2);    
 end

//rd domain
 initial begin
    rclk=0;rd_rst_n=0;
    #10
    rd_rst_n=1;
    rd_rdy=1;
    @(posedge rclk)
    rd_rdy=1;
    repeat(5) begin
      @(posedge rclk)
      rd_rdy=1;    
      @(posedge rclk);
      rd_rdy=1;
    end
    repeat(10) @(posedge rclk);
 end


 cdc_hk cdc_hk_i(
    .wclk(wclk),
    .rclk(rclk),
    .wr_rst_n(wr_rst_n),
    .rd_rst_n(rd_rst_n),
    .wr_vld(wr_vld),
    .wr_rdy(wr_rdy),//O
    .rd_vld(rd_vld),//O
    .rd_rdy(rd_rdy) 
   );

endmodule



