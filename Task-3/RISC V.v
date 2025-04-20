module RISC_V
(
    clk, reset,
    element1,element2,element3, forwardA, forwardB
);
input clk,reset;
output wire [63:0] element1,element2,element3;
output wire [1:0] forwardA, forwardB;
wire [63:0] PC_to_INSTMEM;
wire [31:0] INSTMEM_to_IF_ID;
wire [6:0] CONTROL_IN; 
wire[4:0] rd;
wire [2:0] funct3;
wire [6:0] funct7;
wire [4:0] rs1, rs2;
wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
wire Is_Greater;
wire [1:0] ALUOp;
wire [63:0] mux_to_reg;
wire [63:0] mux_to_pc_in;
wire [3:0] ALU_C_Operation;
wire [63:0] ReadData1, ReadData2;
wire [63:0] imm_data;



wire [63:0] fixed_4 = 64'd4;
wire [63:0] PC_plus_4_to_mux;

wire [63:0] alu_mux;

wire [63:0] alu_result;
wire zero;

wire [63:0] imm_to_adder;
wire [63:0] imm_adder_to_mux;

wire [63:0] DM_Read_Data;

wire pc_mux_sel_wire;
wire PCWrite;


wire ID_EX_Branch, ID_EX_MemRead, ID_EX_MemtoReg,
ID_EX_MemWrite, ID_EX_ALUSrc, ID_EX_RegWrite;

//ID_EX WIRES
wire [63:0] ID_EX_PC_addr, ID_EX_ReadData1, ID_EX_ReadData2,
            ID_EX_imm_data;
wire [3:0] ID_EX_funct_in;
wire [4:0] ID_EX_rd, ID_EX_rs1, ID_EX_rs2;
wire [1:0] ID_EX_ALUOp;

assign imm_to_adder = ID_EX_imm_data<< 1;


//EX_MEM WIRES
wire EX_MEM_Branch, EX_MEM_MemRead, EX_MEM_MemtoReg,
EX_MEM_MemWrite, EX_MEM_RegWrite; 
wire EX_MEM_zero, EX_MEM_Is_Greater;
wire [63:0] EX_MEM_PC_plus_imm, EX_MEM_alu_result,
    EX_MEM_ReadData2;
wire [3:0] EX_MEM_funct_in;
wire [4:0] EX_MEM_rd;
wire NOP_Check;

//MEM_WB WIRES
wire MEM_WB_MemtoReg, MEM_WB_RegWrite;
wire [63:0] MEM_WB_DM_Read_Data, MEM_WB_alu_result;
wire [4:0] MEM_WB_rd;


MUX pcsrcmux
(
    EX_MEM_PC_plus_imm,   //value when sel is 1
    PC_plus_4_to_mux,
    pc_mux_sel_wire,
    mux_to_pc_in
);

PC PC (
    clk,
    reset,
    PCWrite,
    mux_to_pc_in,
    PC_to_INSTMEM
);

Adder pcadder
(
    PC_to_INSTMEM,
    fixed_4,
    PC_plus_4_to_mux
);

Instruction_Memory insmem
(
    PC_to_INSTMEM,
    INSTMEM_to_IF_ID
);

wire [63:0] IF_ID_PC_addr;
wire [31:0] IF_ID_IM_to_parse;
wire IF_ID_Write;


IF_ID IFIDreg
(
    .clk(clk),
    .Flush(NOP_Check),
    .IFID_Write(IF_ID_Write),
    .PC_addr(PC_to_INSTMEM),
    .Instruc(INSTMEM_to_IF_ID),
    .PC_store(IF_ID_PC_addr),
    .Instr_store(IF_ID_IM_to_parse)
);
//IF_ID HERE

wire control_mux_sel;

Hazard_Detection hazarddetectionunit
(
    ID_EX_rd,
    rs1,
    rs2,
    ID_EX_MemRead,
    control_mux_sel,
    IF_ID_Write,
    PCWrite
);



InstructionParser insparser
(
    IF_ID_IM_to_parse,
    CONTROL_IN,
    rd,
    funct3,
    rs1,
    rs2,
    funct7
);

wire [3:0] funct_in;
assign funct_in = {IF_ID_IM_to_parse[30],IF_ID_IM_to_parse[14:12]};
//assign [63:0] nop_to_mux = 64'd0;

Control_Unit cunit
(
    CONTROL_IN,
    Branch, 
    MemRead, 
    MemtoReg,
    MemWrite, 
    ALUSrc,
    RegWrite,
    ALUOp
);

Register_File registerfile
(
    clk,
    reset,
    MEM_WB_RegWrite,
    mux_to_reg,
    rs1,
    rs2,
    MEM_WB_rd,
    ReadData1,
    ReadData2
);


ImmGen immgen
(
    IF_ID_IM_to_parse,
    imm_data
);

wire MemtoReg_ID_EXin, RegWrite_ID_EXin, Branch_ID_EXin, MemWrite_ID_EXin, MemRead_ID_EXin, ALUSrc_ID_EXin;

assign MemtoReg_ID_EXin = control_mux_sel ? MemtoReg : 0;
assign RegWrite_ID_EXin = control_mux_sel ? RegWrite : 0;
assign Branch_ID_EXin = control_mux_sel ? Branch : 0;
assign MemWrite_ID_EXin = control_mux_sel ? MemWrite : 0;
assign MemRead_ID_EXin = control_mux_sel ? MemRead : 0;
assign ALUSrc_ID_EXin = control_mux_sel ? ALUSrc : 0;
wire [1:0] ALUop_ID_EXin;
assign ALUop_ID_EXin = control_mux_sel ? ALUOp : 2'b00;


ID_EX ID_EX1
(
    .clk(clk),
    .Flush(NOP_Check),
    .PC_addr(IF_ID_PC_addr),
    .read_data1(ReadData1),
    .read_data2(ReadData2),
    .imm_val(imm_data),
    .funct_in(funct_in),
    .rd_in(rd),
    .rs1_in(rs1),
    .rs2_in(rs2),
    .RegWrite(RegWrite_ID_EXin),
    .MemtoReg(MemtoReg_ID_EXin),
    .Branch(Branch_ID_EXin),
    .MemWrite(MemWrite_ID_EXin),
    .MemRead(MemRead_ID_EXin),
    .ALUSrc(ALUSrc_ID_EXin),
    .ALU_op(ALUop_ID_EXin),

    .PC_addr_store(ID_EX_PC_addr),
    .read_data1_store(ID_EX_ReadData1),
    .read_data2_store(ID_EX_ReadData2),
    .imm_val_store(ID_EX_imm_data),
    .funct_in_store(ID_EX_funct_in),
    .rd_in_store(ID_EX_rd),
    .rs1_in_store(ID_EX_rs1),
    .rs2_in_store(ID_EX_rs2),
    .RegWrite_store(ID_EX_RegWrite),
    .MemtoReg_store(ID_EX_MemtoReg),
    .Branch_store(ID_EX_Branch),
    .MemWrite_store(ID_EX_MemWrite),
    .MemRead_store(ID_EX_MemRead),
    .ALUSrc_store(ID_EX_ALUSrc),
    .ALU_op_store(ID_EX_ALUOp)

);
// ID/EX HERE

ALU_Control ALU_Control1
(
    ID_EX_ALUOp,
    ID_EX_funct_in,
    ALU_C_Operation
);

//wire [1:0] forwardA, forwardB;

wire [63:0] triplemux_to_a, triplemux_to_b;

MUX ALU_mux
(
    ID_EX_imm_data,
    triplemux_to_b,
    ID_EX_ALUSrc,
    alu_mux
);



MUX3to1 mux_for_a
(
    ID_EX_ReadData1,
    mux_to_reg,
    EX_MEM_alu_result,
    forwardA,
    triplemux_to_a  
);

MUX3to1 mux_for_b
(
    ID_EX_ReadData2,
    mux_to_reg,
    EX_MEM_alu_result,
    forwardB,
    triplemux_to_b  
);

ALU_64bit ALU64
(
    triplemux_to_a,
    alu_mux, 
    ALU_C_Operation,
    alu_result,
    zero,
    Is_Greater
);



Forwarding_Unit Fwd_unit
(
    EX_MEM_rd,
    MEM_WB_rd,
    ID_EX_rs1,
    ID_EX_rs2,
    EX_MEM_RegWrite,
    EX_MEM_MemtoReg,
    MEM_WB_RegWrite,
    forwardA,
    forwardB
);


wire [63:0] pc_add_imm_to_EX_MEM;

Adder PC_plus_imm
(
    ID_EX_PC_addr,
    imm_to_adder,
    pc_add_imm_to_EX_MEM
);

EX_MEM EX_MEM1
(
    .clk(clk),
    .Flush(NOP_Check),
    .RegWrite(ID_EX_RegWrite),
    .MemtoReg(ID_EX_MemtoReg),
    .Branch(ID_EX_Branch),
    .Zero(zero),
    .Is_Greater(Is_Greater),
    .MemWrite(ID_EX_MemWrite),
    .MemRead(ID_EX_MemRead),
    .PCplusimm(pc_add_imm_to_EX_MEM),
    .ALU_result(alu_result),
    .WriteData(triplemux_to_b),
    .funct_in(ID_EX_funct_in),
    .rd(ID_EX_rd),

    .RegWrite_store(EX_MEM_RegWrite),
    .MemtoReg_store(EX_MEM_MemtoReg),
    .Branch_store(EX_MEM_Branch),
    .Zero_store(EX_MEM_zero),
    .Is_Greater_store(EX_MEM_Is_Greater),
    .MemWrite_store(EX_MEM_MemWrite),
    .MemRead_store(EX_MEM_MemRead),
    .PCplusimm_store(EX_MEM_PC_plus_imm),
    .ALU_result_store(EX_MEM_alu_result),
    .WriteData_store(EX_MEM_ReadData2),
    .funct_in_store(EX_MEM_funct_in),
    .rd_store(EX_MEM_rd)
);

// EX/MEM HERE


Branch_Control Branch_Control
(
    .Branch(EX_MEM_Branch),
    .Flush(NOP_Check),
    .Zero(EX_MEM_zero),
    .Is_Greater(EX_MEM_Is_Greater),
    .funct(EX_MEM_funct_in),
    .switch_branch(pc_mux_sel_wire)
);


Data_Memory dm
(
	EX_MEM_alu_result,
	EX_MEM_ReadData2,
	clk,EX_MEM_MemWrite,EX_MEM_MemRead,
	DM_Read_Data, 
    element1,
    element2,
    element3
);



MEM_WB MEM_WB1
(
    .clk(clk),
    .RegWrite(EX_MEM_RegWrite),
    .MemtoReg(EX_MEM_MemtoReg),
    .ReadData(DM_Read_Data),
    .ALU_result(EX_MEM_alu_result),
    .rd(EX_MEM_rd),

    .RegWrite_store(MEM_WB_RegWrite),
    .MemtoReg_store(MEM_WB_MemtoReg),
    .ReadData_store(MEM_WB_DM_Read_Data),
    .ALU_result_store(MEM_WB_alu_result),
    .rd_store(MEM_WB_rd)
);

// MEM/WB HERE

MUX mux2
(
    MEM_WB_DM_Read_Data,
    MEM_WB_alu_result,
    MEM_WB_MemtoReg,
    mux_to_reg
);


endmodule // RISC_V_Processor