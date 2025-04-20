//`timescale 1ns / 1ps
module Branch(
    input Branch, //signal which tells if branching logic is enabled
    input ZERO, //tells wether previous result was ZERO
    input Isgreater, //tells wether one operand is greater or not
    input [3:0] funct, //used to determine specific branching condition
    output reg switch_branch
    );
    
    always @(*) begin
        if(Branch) begin
            case({funct[2:0]})
                3'b000: switch_branch = ZERO ? 1:0; //checks if the result of last operation was equal to zero, if ZERO is 1 then it is set to 1
                3'b001: switch_branch = ZERO ? 0:1; //if last operation was not ZERO then swithc_branch set to 1 to perform branching
                3'b101: switch_branch = Isgreater ? 1:0; //
            endcase
          end
        else
           switch_branch=0;
     end
endmodule
