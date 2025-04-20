`timescale 1ns / 1ps

module ID_EX(
    input clk,
    input [63:0] pc_wire,
    input [63:0] readdata1,
    input [63:0] readdata2,
    input [63:0] immgen_val,
    input [3:0] funct_in,
    input [4:0] rd_in,
    input MemtoReg,
    input RegWrite,
    input Branch,
    input MemWrite,
    input MemRead,
    input ALUsrc,
    input [1:0] ALU_op,
    
    output reg [63:0] pc_wire_store,
    output reg [63:0] readdata1_store,
    output reg [63:0] readdata2_store,
    output reg [63:0] immgen_val_store,
    output reg [3:0] funct_in_store,
    output reg [4:0] rd_in_store,
    output reg MemtoReg_store,
    output reg RegWrite_store,
    output reg Branch_store,
    output reg MemWrite_store,
    output reg MemRead_store,
    output reg ALUsrc_store,
    output reg [1:0] ALU_op_store
    );
    
    always @(negedge clk) 
    begin
    pc_wire_store = pc_wire;
    readdata1_store = readdata1;
    readdata2_store = readdata2;
    immgen_val_store = immgen_val;
    funct_in_store = funct_in;
    rd_in_store = rd_in;
    RegWrite_store = RegWrite;
    MemtoReg_store = MemtoReg;
    Branch_store = Branch;
    MemWrite_store = MemWrite;
    MemRead_store = MemRead;
    ALUsrc_store = ALUsrc;
    ALU_op_store = ALU_op;
    end
    
endmodule
