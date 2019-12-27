module Second_Pipe(
		/*CLK*/
		input wire CLK,

		/*register*/
		input wire [4:0] ReadReg_addr12,
		input wire [4:0] ReadReg_addr22,
		input wire [4:0] WriteReg_addr2,
		input wire [31:0] Imm2,
		input wire [31:0] ReadData12,
		input wire [31:0] ReadData22,


		/*PC and Control*/
		input wire [31:0] Next_PC2,
  		input wire JtoPC2,
  		input wire Branch2,
  		input wire RegWrite2,
  		input wire ALUSrc2,
  		input wire MemWrite2,
  		input wire MemRead2,
  		input wire MemtoReg2,
  		input wire [3:0] ALUOp2,


  		output reg [4:0] ReadReg_addr13,
  		output reg [4:0] ReadReg_addr23,
  		output reg [4:0] WriteReg_addr3,
  		output reg [31:0] Imm3,
  		output reg [31:0] ReadData13,
  		output reg [31:0] ReadData23,

  		output reg [31:0] Next_PC3,
  		output reg JtoPC3,
  		output reg Branch3,
  		output reg RegWrite3,
  		output reg ALUSrc3,
  		output reg MemWrite3,
  		output reg MemRead3,
  		output reg MemtoReg3,
  		output reg [3:0] ALUOp3
	);

always @(posedge CLK)
begin
	ReadReg_addr13 <= ReadReg_addr12;
	ReadReg_addr23 <= ReadReg_addr22;
	WriteReg_addr3 <= WriteReg_addr2;
	Imm3 <= Imm2;
	ReadData13 <= ReadData12;
	ReadData23 <= ReadData22;
	Next_PC3 <= Next_PC2;
	JtoPC3 <= JtoPC2;
	Branch3 <= Branch2;
	RegWrite3 <= RegWrite2;
	ALUSrc3 <= ALUSrc2;
	MemWrite3 <= MemWrite2;
	MemRead3 <= MemRead2;
	MemtoReg3 <= MemtoReg2;
	ALUOp3 <= ALUOp2;
end

endmodule