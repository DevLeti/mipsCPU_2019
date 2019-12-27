module MIPS(
	input CLK
	 );

reg [31:0] PC1;


/*** 1 - *IM* ***/
wire [31:0] Input_PC;

wire [31:0] Instr1;
wire [31:0] Branch_addr4;
wire [31:0] Jump_addr4;

// control
wire RegDst1;
wire RegWrite1;
wire ALUSrc1;
wire MemRead1;
wire MemWrite1;
wire MemtoReg1;
wire JtoPC1;
wire Branch1;
wire [3:0] ALUOp1;

/*** 2 - *ID* ***/
wire [4:0] ReadReg_addr12;
wire [4:0] ReadReg_addr22;
wire [4:0] WriteReg_addr2;
wire [31:0] Imm2;
wire [31:0] ReadData12;
wire [31:0] ReadData22;


wire [31:0] Next_PC2;
wire [31:0] Instr2;

// control
wire RegDst2;
wire RegWrite2;
wire ALUSrc2;
wire MemRead2;
wire MemWrite2;
wire MemtoReg2;
wire JtoPC2;
wire Branch2;
wire [3:0] ALUOp2;

/*** 3 - *EX* ***/
wire [31:0] Next_PC3;
wire [31:0] Imm3;
wire [31:0] ReadData13;
wire [31:0] ReadData23;
wire [31:0] Branch_addr3;
wire [31:0] Jump_addr3;
wire [31:0] WriteReg_addr3;
wire [31:0] ALUResult3;
wire [4:0] ReadReg_addr13;
wire [4:0] ReadReg_addr23;

// ALU FLAG
wire Zero3;

// Select Source
wire PCSrc3;

// control
wire RegWrite3;
wire ALUSrc3;
wire MemRead3;
wire MemWrite3;
wire MemtoReg3;
wire JtoPC3;
wire Branch3;
wire [3:0] ALUOp3;

/*** 4 - *MEM* ***/
wire [31:0] ALUResult4;
wire [31:0] Imm4;
wire [4:0] WriteReg_addr4;
wire [31:0] Mem_ReadData4;
wire [31:0] WriteData4;

// Select Source
wire PCSrc4;

// control
wire RegWrite4;
wire MemRead4; 
wire MemWrite4; 
wire MemtoReg4; 
wire JtoPC4;
wire Branch4;

/*** 5 - *WB* ***/
wire [4:0] WriteReg_addr5;
wire [31:0] WriteData5;

//control
wire RegWrite5;


/*** STALL ***/
wire Stall;

/************/
/***ASSIGN***/
/************/

// IF
assign Input_PC = PC1 + 32'd4;

// ID
assign ReadReg_addr12 = Instr2[25:21];
assign ReadReg_addr22 = Instr2[20:16];
assign WriteReg_addr2 = (RegDst2) ? Instr2[15:11] : Instr2[20:16];
assign Imm2 = (Instr2[15] == 1) ? { 16'b1111_1111_1111_1111, Instr2[15:0]} : { 16'b_0000_0000_0000_0000, Instr2[15:0]}; //Sign Extend

// EX
assign Jump_addr3 = {Next_PC3 , {Imm3[25:0], 2'b00}};
assign Branch_addr3 = Next_PC3 + {Imm3[29:0], 2'b00};
assign PCSrc3 = (ALUOp3 == 4'b1001 & Zero3) & Branch3;

// MEM
assign WriteData4 = (MemtoReg4) ? Mem_ReadData4 : ALUResult4;


/************/
/*****PC*****/
/************/

always @(posedge CLK)
begin
	if(Stall)
		PC1 <= Input_PC - 32'd4;
	else if(JtoPC4)
		PC1 <= Jump_addr4;
	else if (PCSrc4)
		PC1 <= Branch_addr4;
	else
		PC1 <= Input_PC;

	//PC <= (JToPC) ? Jump_addr : ((PCSrc) ? (Branch_addr + Next_PC) : Next_PC);
end

initial
begin
	PC1 = 32'd0 - 32'd4;
end

/************/
/***MODULE***/
/************/

Instruction_Mem Instr_mem(PC1[8:2], Instr1); // Asynchronous module.

Register Reg(CLK, RegWrite5, ReadReg_addr12, ReadReg_addr22, WriteReg_addr5, WriteData5, ReadData12, ReadData22); // Synchronous module.

Control control(Instr1[31:26], Instr1[25:20], RegDst1, RegWrite1, ALUSrc1, MemWrite1, MemRead1, MemtoReg1, JtoPC1, Branch1, ALUOp1); // Asynchronous module.

ALU alu(ALUOp3, ReadData13, ReadData23, ALUResult3, Zero3); // Asynchronous module.

Data_Mem DM(CLK, MemWrite4, MemRead4, ALUResult4, Imm4, Mem_ReadData4); // Synchronous module.

/************/
/**PIPELINE**/
/************/
First_Pipe pipe1(CLK, Instr1, Input_PC, RegDst1, RegWrite1, ALUSrc1, MemRead1, MemWrite1, MemtoReg1, JtoPC1, Branch1, ALUOp1, Instr2, Next_PC2, RegDst2, RegWrite2, ALUSrc2, MemRead2, MemWrite2, MemtoReg2, JtoPC2, Branch2, ALUOp2);
Second_Pipe pipe2(CLK, ReadReg_addr12, ReadReg_addr22, WriteReg_addr2, Imm2, ReadData12, ReadData22, Next_PC2, JtoPC2, Branch2, RegWrite2, ALUSrc2, MemWrite2, MemRead2, MemtoReg2, ALUOp2, ReadReg_addr13, ReadReg_addr23, WriteReg_addr3, Imm3, ReadData13, ReadData23, Next_PC3, JtoPC3, Branch3, RegWrite3, ALUSrc3, MemWrite3, MemRead3, MemtoReg3, ALUOp3);
Third_Pipe pipe3(CLK, Imm3, Branch_addr3, Jump_addr3, WriteReg_addr3, ALUResult3, PCSrc3, JtoPC3, Branch3, RegWrite3, MemWrite3, MemRead3, MemtoReg3, Imm4, Branch_addr4, Jump_addr4, WriteReg_addr4, ALUResult4, PCSrc4, JtoPC4, Branch4, RegWrite4, MemWrite4, MemRead4, MemtoReg4);
Fourth_Pipe pipe4(CLK, WriteData4, WriteReg_addr4, RegWrite4, WriteData5, WriteReg_addr5, RegWrite5);


/************/
/****STALL***/
/************/

Stall staller(CLK, RegWrite2, WriteReg_addr2, ReadReg_addr12, ReadReg_addr22, Branch2, JtoPC2, Stall);

/*
// IM
wire [31:0] Next_PC, Instr, Branch_addr;
reg [31:0] PC;

// Control
wire RegDst, RegWrite; // control signal
wire ALUSrc, MemWrite, MemRead, MemToReg; // control signal
wire [3:0] ALUOp;
wire PCSrc, JToPC, Branch; // mux control signal
wire [5:0] Opcode, Funct;

// Register
wire [31:0] Jump_addr;
wire [4:0] Read1, Read2, Reg_Write_addr;
wire [31:0] Branch_or_offset;
wire [31:0] Reg_Write_data, Read_data1, Read_data2;

// ALU
wire [31:0] ALU_B, ALU_result, Lw_Sw_offset;
wire zero;

// DM
wire [31:0] Read_or_Write_addr;
wire [31:0] DM_Write_data, DM_Read_data;

assign Next_PC = PC + 32'd4;
assign Branch_addr = {Branch_or_offset[29:0], 2'b00};
assign PCSrc = (Branch && zero);

assign Opcode = Instr[31:26];
assign Funct = Instr[5:0];

assign Jump_addr = {Next_PC[31:28], {Instr[25:0], 2'b00}};
assign Read1 = Instr[25:21];
assign Read2 = Instr[20:16];
assign Reg_Write_addr = (RegDst) ? Instr[15:11] : Instr[20:16];
assign Branch_or_offset = (Instr[15] == 1) ? {16'hFFFF, Instr[15:0]} : {16'h0000, Instr[15:0]}; // sign extend.

assign Lw_Sw_offset = (Branch_or_offset[31] == 1) ? {2'b11, Branch_or_offset[31:2]} : {2'b00, Branch_or_offset[31:2]};
// if instruction is lw or sw, divide the offset by 4.
assign ALU_B = (Opcode == 6'b100011 || Opcode == 6'b101011) ? Lw_Sw_offset : ((ALUSrc) ? Branch_or_offset : Read_data2);
// if instruction is lw or sw, ALU_B is Lw_Sw_offset.

assign DM_Write_data = Read_data2;
assign Read_or_Write_addr = ALU_result;
assign Reg_Write_data = (MemToReg) ? DM_Read_data : ALU_result;

*/

/*
	[8:0]         [8:2]
0	000 0000 00   000 0000 => 0
4	000 0001 00   000 0001 => 1
8	000 0010 00   000 0010 => 2
12	000 0011 00   000 0011 => 3
16	000 0100 00   000 0100 => 4
20	000 0101 00   000 0101 => 5
24	000 0110 00   000 0110 => 6
28	000 0111 00   000 0111 => 7

*/


/*
always @(posedge CLK)
begin
	PC <= (JToPC) ? Jump_addr : ((PCSrc) ? (Branch_addr + Next_PC) : Next_PC);
end

initial
begin
	PC = 32'd0 - 32'd4;
end
*/
endmodule
