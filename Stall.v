module Stall(
	/*CLK*/
	input wire CLK,

	/*control for write*/
	input wire RegWrite2,

	input wire [4:0] WriteReg_addr2,
	input wire [4:0] Read1,
	input wire [4:0] Read2,

	input wire Branch2,
	input wire JtoPC2,


	output reg Stall


	);

always @(posedge CLK)
begin
	if(RegWrite2 && ((WriteReg_addr2 == Read1)||(WriteReg_addr2 == Read2)))
		Stall <= 1'b1;
	else if(Branch2 == 1)
		Stall <= 1'b1;
	else if(JtoPC2 == 1)
		Stall <= 1'b1;
end

initial
begin
	Stall <= 0;
end

endmodule