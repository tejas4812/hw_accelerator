//#####Adaptive Filter testbench#####/
//data -> noisy received data. A reference noise, generated independently
//eo -> filtered output

`timescale 1ns/1ps
module adp_filter_tb();
  logic clk,rst_n;
  logic [7:0] data;
  logic vld;
  logic [7:0] e_o;
  logic vldo;
  logic [7:0] ref_sg;
  logic [7:0] noise_pre[4]; 
  logic rdy; 

 always #5 clk=~clk;

 initial begin
    clk=0;rst_n=0;
    noise_pre={8'h8F,8'h2F,8'h8F,8'h2F};
    #10
    vld=0;
    @(posedge clk)
    rst_n=1;
    @(posedge clk)
     //Sample0
    wait(rdy);
      #1
      data=8'd25+noise_pre[0];
      ref_sg=noise_pre[0];
      vld=1'b1;
    @(posedge clk);
      #1
      vld=1'b0;
    //Sample1
    @(posedge clk);
    wait(rdy);
      #1
      data=8'd25+noise_pre[1];
      vld=1'b1;
      ref_sg=noise_pre[1];
    @(posedge clk);
      #1
      vld=1'b0;
     //Sample2
    @(posedge clk);
    wait(rdy);
      #1
      data=8'd25+noise_pre[2];
      vld=1'b1;
      ref_sg=noise_pre[2];
    @(posedge clk);
      #1
      vld=1'b0;
     //Sample3
    @(posedge clk);
    wait(rdy);
      #1
      data=8'd25+noise_pre[3];
      vld=1'b1;
      ref_sg=noise_pre[3];
    @(posedge clk); 
      #1
      vld=1'b0;
    //-------pushing Zeros--------//
    repeat(10)
    begin 
      //Sample4
      @(posedge clk);
      wait(rdy);
        #1
        data=8'd25+noise_pre[0];
        vld=1'b1;
        ref_sg=noise_pre[0];
      @(posedge clk); 
        #1
        vld=1'b0;

      //Sample5
      @(posedge clk);
      wait(rdy);
        #1
        data=8'd25+noise_pre[1];
        vld=1'b1;
        ref_sg=noise_pre[1];
      @(posedge clk); 
        #1
        vld=1'b0;

      //Sample6
      @(posedge clk);
      wait(rdy);
        #1
        data=8'd25+noise_pre[2];
        vld=1'b1;
        ref_sg=noise_pre[2];
      @(posedge clk); 
        #1
        vld=1'b0;

      //Sample7
      @(posedge clk);
      wait(rdy);
        #1
        data=8'd25+noise_pre[3];
        vld=1'b1;
        ref_sg=noise_pre[3];
      @(posedge clk); 
        #1
        vld=1'b0;
    end
/*
  //-------pushing Zeros--------//
    //Sample4
    @(posedge clk);
    wait(rdy);
      #1
      data=8'd25;
      vld=1'b1;
      ref_sg=8'h0;//noise_pre[0];
    @(posedge clk); 
      #1
      vld=1'b0;

    //Sample5
    @(posedge clk);
    wait(rdy);
      #1
      data=8'd25;
      vld=1'b1;
      ref_sg=8'h0;//noise_pre[1];
    @(posedge clk); 
      #1
      vld=1'b0;

    //Sample6
    @(posedge clk);
    wait(rdy);
      #1
      data=8'd0;
      vld=1'b1;
      ref_sg=8'h0;//noise_pre[2];
    @(posedge clk); 
      #1
      vld=1'b0;

    //Sample7
    @(posedge clk);
    wait(rdy);
      #1
      data=8'd0;
      vld=1'b1;
      ref_sg=8'h0;//noise_pre[3];
    @(posedge clk); 
      #1
      vld=1'b0;

  //-------pushing Zeros--------//
    //Sample4
    @(posedge clk);
    wait(rdy);
      #1
      data=8'h0;
      vld=1'b1;
      ref_sg=8'h0;//noise_pre[0];
    @(posedge clk); 
      #1
      vld=1'b0;

    //Sample5
    @(posedge clk);
    wait(rdy);
      #1
      data=8'h0;
      vld=1'b1;
      ref_sg=8'h0;//noise_pre[1];
    @(posedge clk); 
      #1
      vld=1'b0;

    //Sample6
    @(posedge clk);
    wait(rdy);
      #1
      data=8'd0;
      vld=1'b1;
      ref_sg=8'h0;//noise_pre[2];
    @(posedge clk); 
      #1
      vld=1'b0;

    //Sample7
    @(posedge clk);
    wait(rdy);
      #1
      data=8'd0;
      vld=1'b1;
      ref_sg=8'h0;//noise_pre[3];
    @(posedge clk); 
      #1
      vld=1'b0;
*/

    repeat(10) @(posedge clk);
    $finish(2);    
 end

   adp_filter adp_filter_i(
    .clk(clk),
    .rst_n(rst_n),
    .xin(ref_sg),//8bits  
    .yin(data),//8bits
    .vld(vld),
    .eo(eo),//O //8 bits
    .vldo(vldo),//O
    .rdy(rdy) 
   );


endmodule


