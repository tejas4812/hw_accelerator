//#####data compressor######//


module data_compress(
input clk,
input rst_n,
input [7:0] din,
input den,
input hold,
output logic [7:0] dout,
output logic vldo,
output logic rdy   
);

logic [7:0] din_reg;
logic hold_reg;
logic den_reg;

logic [7:0] dout_nxt;
logic vldo;


assign dout_nxt=(hold_reg)?dout:(den_reg)?din_reg:dout;
assign vldo_nxt=(hold_reg|den_reg)?1'b1:1'b0;

//flop data
always@(posedge clk or  negedge rst_n) begin
  if(!rst_n) begin
      dout<=8'h0;
      vldo<=1'b0;
      end
  else begin
      dout<=dout_nxt;
      vldo<=vldo_nxt;
      end 
end

//flop input
always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
     din_reg<=8'h0;
     hold_reg<=1'b0;
     den_reg<=1'b0; 
    end
  else begin
     din_reg<=din;
     hold_reg<=hold;
     den_reg<=den;   
   end
end

endmodule

