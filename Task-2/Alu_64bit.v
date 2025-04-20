
module ALU_64_Bit
(
    input [63:0]a, b,
    input [3:0] ALUOp,
    output reg [63:0] Result,
    output reg ZERO,
    output reg Is_greater
    );
    
    localparam [3:0]
    AND = 4'b0000,
    OR = 4'b0001,
    ADD = 4'b0010,
    SUB = 4'b0110,
    NOR = 4'b1100;

   always @ (ALUOp, a, b)
      begin
        case (ALUOp)
        AND: Result = a & b;
        OR: Result = a | b;
        ADD: Result = a + b;
        SUB: Result = a - b;
        NOR: Result = ~(a | b);
        //LESSTHAN: Result = ( a < b )? 0:1;
        4'b0111: Result = a << b;
        endcase
      if (Result ==64'd0)
        ZERO=1'b1;
      else
        ZERO=1'b0;
      
      Is_greater= (a > b) ? 1'b1 : 1'b0;
      end
  
endmodule