module Fourth_Pipe(
		/*CLK*/
		input wire CLK,

		/*Write Data*/
		input wire [31:0] WriteData4,
		input wire [4:0] Write_addr4,

		/*control*/
		input wire RegWrite4,

		output reg [31:0] WriteData5,
		output reg [4:0] Write_addr5,
		output reg [4:0] RegWrite5

	);

always @(posedge CLK)
begin
	WriteData5 <= WriteData4;
	Write_addr5 <= Write_addr4;
	RegWrite5 <= RegWrite4;
end


endmodule