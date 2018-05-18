`timescale 1ns/1ps
module bin_search_tb();
  logic clk;
  logic rst_n;
  logic [63:0] data;
  logic en;
  logic [7:0] X;

  logic [7:0] out;
  logic rdy;
  logic valid;  

always #5 clk=~clk;

initial begin
  clk=0;
  rst_n=0;
  en=1'b0;
  #10
  @(posedge clk)
  rst_n=1;
  #20
  @(posedge clk)
  data={8'd20,8'd30,8'd40,8'd50,8'd60,8'd70,8'd80,8'd90};
  en=1'b1;
  X=8'd30;
  @(posedge clk)
  en=1'b0;
 wait(!rdy);
 wait(rdy);
 @(posedge clk) 
 @(posedge clk)
  data={8'd20,8'd30,8'd40,8'd50,8'd60,8'd70,8'd80,8'd90};
  en=1'b1;
  X=8'd70;
  @(posedge clk)
  en=1'b0;

  repeat(10) @(posedge clk);

  #10
  $finish(2);
end

bin_search bin_search_i(
.clk(clk),
.rst_n(rst_n),
.data(data),//64 bits
.en(en),
.X(X),// 8 bits
.out(out),//O 8 bits
.rdy(rdy), //O
.valid(valid) //O 
);


endmodule
