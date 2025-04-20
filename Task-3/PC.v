module PC
(
    input clk, reset, PCWrite, //PCWrite is a signal 
    input [63:0] PC_In,
    output reg [63:0] PC_Out
);

reg reset_force; // variable to force 0th value after reset

initial 
PC_Out <= 64'd0;


always @(posedge clk or posedge reset) begin
    if (reset || reset_force) begin
        PC_Out = 64'd0;
        reset_force <= 0;
        end
//PC Write is useful when stalling pipeline since we want the processor to temporarily stop fetching instruction
    else if (!PCWrite) begin //if the PCWrite is 0 then it won't let PC Counter to update and it is useful to implement stalls
        PC_Out = PC_Out;
    end
    else
    PC_Out = PC_In;

end

always @(negedge reset) reset_force <= 1;

endmodule // Program_Counter