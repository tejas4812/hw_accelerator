//#####Datat compressor testbench#####/
//din -> uncompressed data
//do  -> compressed(skip a character instead repeat the previous one) output

`timescale 1ns/1ps
module data_compress_tb();
  logic clk,rst_n;
  logic [7:0] data[3:0];
  logic [7:0] din;
  logic hold;
  logic den;
  logic [7:0] dout;
  logic vldo;
  logic rdy; 

 always #5 clk=~clk;

 initial begin
    clk=0;rst_n=0;
    data={8'h8F,8'h2F,8'h0F,8'h3F};
    #10
    den=0;
    hold=0;
    din=8'h0;
    @(posedge clk)
    rst_n=1;
    @(posedge clk)
    //Sample0
    @(posedge clk);
      #1
      din=data[0];
      den=1'b1;
      hold=1'b0;
    //Sample1
    @(posedge clk);
      #1
      din=data[1];
      den=1'b1;
      hold=1'b0;
     //Sample2
    @(posedge clk);
      #1
      din=data[2];
      den=1'b1;
      hold=1'b1;
     //Sample3
    @(posedge clk);
      #1
      din=data[3];
      den=1'b1;
      hold=1'b0;
    
      @(posedge clk); 
        #1
        den=1'b0;
    repeat(10) @(posedge clk);
    $finish(2);    
 end

 data_compress data_compress_i(
    .clk(clk),
    .rst_n(rst_n),
    .din(din),//8bits  
    .den(den),
    .hold(hold),
    .dout(dout),//O //8 bits
    .vldo(vldo),//O
    .rdy(rdy)//O 
   );


endmodule

