module Third_Pipe(
		/*CLK*/
		input wire CLK,

		/*Values*/
		input wire [31:0] Imm3,
		input wire [31:0] Branch_addr3,
		input wire [31:0] Jump_addr3,
		input wire [4:0] Wreg_addr3,
		input wire [31:0] ALUResult3,

		/*Controls*/
		input wire PCSrc3,
	    input wire JtoPC3,
  		input wire Branch3,
  		input wire RegWrite3,
  		input wire MemWrite3,
  		input wire MemRead3,
  		input wire MemtoReg3,


  		/*Outputs*/
  		output reg [31:0] Imm4,
  		output reg [31:0] Branch_addr1,
  		output reg [31:0] Jump_addr1,
  		output reg [4:0] Wreg_addr4,
  		output reg [31:0] ALUResult4,

  		output reg PCSrc4,
  		output reg JtoPC4,
  		output reg Branch4,
  		output reg RegWrite4,
  		output reg MemWrite4,
  		output reg MemRead4,
  		output reg MemtoReg4
	);

always @(posedge CLK)
begin
	Imm4 <= Imm3;
	Branch_addr1 <= Branch_addr3;
	Jump_addr1 <= Jump_addr3;
	Wreg_addr4 <= Wreg_addr3;
	ALUResult4 <= ALUResult3;
	PCSrc4 <= PCSrc3;
	JtoPC4 <= JtoPC3;
	Branch4 <= Branch3;
	RegWrite4 <= RegWrite3;
	MemWrite4 <= MemWrite3;
	MemRead4 <= MemRead3;
	MemtoReg4 <= MemtoReg3;
end
endmodule