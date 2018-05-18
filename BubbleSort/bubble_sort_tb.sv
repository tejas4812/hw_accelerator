//#####Bubble sort testbench#####/
//data is the unsorted input array
//data_sort_o is the sorted output array

`timescale 1ns/1ps
module bubble_sort_tb();
  logic clk,rst_n;
  logic [63:0] data;
  logic en;
  logic [7:0] data_o;
  logic [63:0] data_sort_o;
  logic wr_en;
  logic last;

always #5 clk=~clk;

  initial begin
    clk=0;rst_n=0;
    #10
    en=0;
    @(posedge clk)
    rst_n=1;
    @(posedge clk)
    data={8'd25, 8'd10, 8'd40, 8'd45,8'd60,8'd20,8'd3,8'd200};
    en=1'b1;
    @(posedge clk)
    en=1'b0;
    wait(!last);
    wait(last);

    repeat(10) @(posedge clk);
    $finish(2);    
  end

  bubble_sort bubble_sort_i(
    .clk(clk),
    .rst_n(rst_n),
    .data(data),//64 bits
    .en(en),
    .data_o(data_o),//O //7 bits
    .data_sort_o(data_sort_o),//O //64 bits  
    .wr_en(wr_en),//O 
    .last(last) //O
  );


endmodule


