module First_Pipe(
		/*CLK*/
		input wire CLK,

		/*IM data, PC*/
		input wire [31:0] Input_data,
		input wire [31:0] Input_PC,

		/*Control*/
	  	input wire RegDst1,
	  	input wire RegWrite1,
	  	input wire ALUSrc1,
	  	input wire MemRead1,
	  	input wire MemWrite1,
	  	input wire MemtoReg1,
		input wire JtoPC1,
	  	input wire Branch1,
	  	input wire [3:0] ALUOp1,


	  	output reg [31:0] Output_data,
	  	output reg [31:0] Output_PC,

	  	output reg RegDst2,
	  	output reg RegWrite2,
	  	output reg ALUSrc2,
	  	output reg MemRead2,
	  	output reg MemWrite2,
	  	output reg MemtoReg2,
	  	output reg JtoPC2,
	  	output reg Branch2,
	  	output reg [3:0] ALUOp2
	);

always @(posedge CLK)
begin
	Output_data <= Input_data;
	Output_PC <= Input_PC;
	RegDst2 <= RegDst1;
	RegWrite2 <= RegWrite1;
	ALUSrc2 <= ALUSrc1;
	MemRead2 <= MemRead1;
	MemWrite2 <= MemWrite1;
	MemtoReg2 <= MemtoReg1;
	JtoPC2 <= JtoPC1;
	Branch2 <= Branch1;
	ALUOp2 <= ALUOp1;
end

endmodule