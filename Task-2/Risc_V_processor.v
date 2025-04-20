module Risc_V_pipelined_processor(
  input clk,reset,
  output [4:0] rd_out, rs1_out, rs2_out,
  output [63:0] ReadData1_out, ReadData2_out, ID_EX_ReadData1, ID_EX_ReadData2,
  output [4:0] ID_EX_rd,
  output [63:0] EX_MEM_ReadData2,
  output [4:0] EX_MEM_rd,
  output [63:0] MEM_WB_Read_Data,
  output [4:0] MEM_WB_rd
  );

wire [63:0] pc_to_inst_mem;
wire [31:0] inst_mem_to_IF_ID; //output of instruction memory goes to IF/ID stage
wire [6:0] control_in; //opcode
wire [2:0] funct3_out;
wire [6:0] funct7_out;
wire Branch,MemRead,MemtoReg, MemWrite,ALUsrc,RegWrite;
wire Is_greater_out;
wire [1:0] ALU_op;
wire [63:0] mux_to_reg; //output of last MUX after MEM/WB stage
wire [63:0] mux_to_pc_in; //output of first MUX
wire [3:0] ALU_Control_oper;
wire [63:0] Readdata1,Readdata2;
wire [63:0] imm_Data;
wire [63:0] fixed_4 = 64'd4; //value 4 assigned so we can add it to PC instruction
wire [63:0] pc_add_4_to_mux; //the result of PC+4 in adder
wire [63:0] alu_mux_out;
wire [63:0] alu_result_out;
wire zero;
wire [63:0] immd_to_addr;
wire [63:0] immd_addr_to_mux;
wire [63:0] DataM_read_data;
wire pc_mux_sel;
wire ID_EX_Branch, ID_EX_MemRead, ID_EX_MemtoReg, ID_EX_Memwrite, ID_EX_ALUsrc,  ID_EX_Regwrite;

//ID_EX WIRES WE WILL USE INSIDE 

wire [63:0] ID_EX_Pcaddr, ID_EX_immdata;
wire [3:0] ID_EX_funct;
wire [1:0] ID_EX_ALUop;

assign immd_to_addr = ID_EX_immdata << 1;

//EX_MEM WIRES WE WILL USE INSIDE

wire EX_MEM_Branch, EX_MEM_MemRead, EX_MEM_MemtoReg, EX_MEM_Memwrite,EX_MEM_Regwrite;
wire EX_MEM_zero, EX_MEM_Is_greater;
wire [63:0] EX_Mem_pc_add_immd, EX_MEM_alu_result;
wire [3:0] EX_MEM_funct;

//MEM_WB WIRES WE WILL USE INSIDE
wire MEM_WB_MemtoReg, MEM_WB_RegWrite; // MEM/WB RegWrite
wire [63:0] IF_ID_pc_addr; //output of PC address from IF/ID
wire [31:0] IF_ID_Immd_to_parse; //output of instruction which will be parsed to rs1,rs2,rd
wire [3:0] funct;
wire [63:0] pc_plus_immd_to_EX_MEM;
wire [63:0] MEMWB_alu_result;

MUX mux1(EX_Mem_pc_add_immd,pc_add_4_to_mux,pc_mux_sel,mux_to_pc_in);

Program_Counter pc(clk,reset,mux_to_pc_in,pc_to_inst_mem);

//it adds PC+4
Adder pc_addr (pc_to_inst_mem,fixed_4,pc_add_4_to_mux);

//pc address passed to fetch instruction memory address
Instruction_Memory im (pc_to_inst_mem,inst_mem_to_IF_ID);

IF_ID if_id (clk,pc_to_inst_mem,inst_mem_to_IF_ID,IF_ID_pc_addr,IF_ID_Immd_to_parse);

//the instruction will here be divided 
InstructionParser ip (IF_ID_Immd_to_parse,control_in,rd_out,funct3,rs1_out,rs2_out,funct7);

//finding the Instruction [30, 14-12]
assign funct = {IF_ID_Immd_to_parse[30],IF_ID_Immd_to_parse[14:12]};

//it handles control signals
Control_Unit cu (control_in,Branch,MemRead,MemtoReg, MemWrite,ALUsrc,RegWrite,ALU_op);

RegisterFile rf (clk,reset,MEM_WB_RegWrite,mux_to_reg,rs1_out,rs2_out,MEM_WB_rd,ReadData1_out, ReadData2_out);

//converts 32 bit to 64 bit
Immediate_gen ig (IF_ID_Immd_to_parse,imm_Data);

ID_EX id_ex(clk,IF_ID_pc_addr,ReadData1_out, ReadData2_out,imm_Data,funct,rd_out,RegWrite,MemtoReg,Branch,MemWrite,MemRead,ALUsrc,ALU_op,
            ID_EX_Pcaddr,ID_EX_ReadData1, ID_EX_ReadData2,ID_EX_immdata,ID_EX_funct,ID_EX_rd,ID_EX_Regwrite,ID_EX_MemtoReg,ID_EX_Branch,ID_EX_Memwrite,ID_EX_MemRead,ID_EX_ALUsrc,ID_EX_ALUop);

ALU_Control alu (ID_EX_ALUop,ID_EX_funct,ALU_Control_oper);

MUX mux_alu (ID_EX_immdata,ID_EX_ReadData2,ID_EX_ALUsrc,alu_mux_out);

ALU_64_Bit aluhak (ID_EX_ReadData1,alu_mux_out,ALU_Control_oper,alu_result_out,zero,Is_greater_out);

Adder immins(ID_EX_Pcaddr,immd_to_addr,pc_plus_immd_to_EX_MEM);
//left
EX_MEM ex_mem(clk,ID_EX_Regwrite,ID_EX_MemtoReg,ID_EX_Branch,zero,Is_greater_out,ID_EX_Memwrite,ID_EX_MemRead,pc_plus_immd_to_EX_MEM,alu_result_out,ID_EX_ReadData2,ID_EX_funct,ID_EX_rd
                ,EX_MEM_Regwrite,EX_MEM_MemtoReg,EX_MEM_Branch,EX_MEM_zero,EX_MEM_Is_greater,EX_MEM_Memwrite, EX_MEM_MemRead, EX_Mem_pc_add_immd,EX_MEM_alu_result,EX_MEM_ReadData2,EX_MEM_funct,EX_MEM_rd);
                
Branch bc (EX_MEM_Branch,EX_MEM_zero,EX_MEM_Is_greater,EX_MEM_funct,pc_mux_sel);

Data_Memory dm (EX_MEM_alu_result,EX_MEM_ReadData2,clk,EX_MEM_Memwrite,EX_MEM_MemRead,DataM_read_data);

MEM_WB mem_wb(clk,EX_MEM_Regwrite,EX_MEM_MemtoReg,DataM_read_data,EX_MEM_alu_result,EX_MEM_rd,
                MEM_WB_RegWrite,MEM_WB_MemtoReg,MEM_WB_Read_Data,MEMWB_alu_result,MEM_WB_rd);
                
MUX m2(MEM_WB_Read_Data,MEMWB_alu_result, MEM_WB_MemtoReg,mux_to_reg);

endmodule