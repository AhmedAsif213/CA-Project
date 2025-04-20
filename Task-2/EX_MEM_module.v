`timescale 1ns / 1ps

module EX_MEM
(
    input clk,
    input RegWrite, MemtoReg,
    input Branch, Zero, MemWrite, MemRead, Is_Greater,
    input [63:0] sum, ALU_result, Readdata2,
    input [3:0] funct_in,
    input [4:0] rd,

    output reg RegWrite_store, MemtoReg_store,
    output reg Branch_store, Zero_store, MemWrite_store, MemRead_store, Is_Greater_store,
    output reg [63:0] sum_store, ALU_result_store, WriteData,
    output reg [3:0] funct_in_store,
    output reg [4:0] rd_store
);

always @(negedge clk) begin
    RegWrite_store = RegWrite;
    MemtoReg_store = MemtoReg;
    Branch_store = Branch;
    Zero_store = Zero;
    Is_Greater_store = Is_Greater;
    MemWrite_store = MemWrite;
    MemRead_store = MemRead;
    sum_store = sum;
    ALU_result_store = ALU_result;
    WriteData = Readdata2;
    funct_in_store = funct_in;
    rd_store = rd;
end

endmodule
