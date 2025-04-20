`timescale 1ns / 1ps

module IF_ID
(
    input clk,
    input [63:0] pc_wire,
    input [31:0] inst,
    output reg [63:0] pc_store,
    output reg [31:0] inst_store
);
    
    always @ (negedge clk) begin
        pc_store = pc_wire;
        inst_store = inst;
        end
        
endmodule
