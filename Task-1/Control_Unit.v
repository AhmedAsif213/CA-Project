module Control_Unit
(
    input [6:0] Opcode,
    output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,
    output reg [1:0] ALUOp 
);
    always @ (*)
        begin
            case (Opcode)
            7'b0110011: //R type
             begin
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                ALUSrc = 0;
                RegWrite = 1;
                ALUOp = 2'b10;
             end
            7'b0000011: //ld
             begin
                Branch = 0;
                MemRead = 1;
                MemtoReg = 1;
                MemWrite = 0;
                ALUSrc = 1;
                RegWrite = 1;
                ALUOp = 2'b00;
             end
            7'b0010011: //addi
               begin
                Branch = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                MemWrite = 1'b0;
                ALUSrc = 1'b1;
                RegWrite = 1'b1;
                ALUOp = 2'b00;
              end
             7'b0100011: //S type
              begin
                Branch = 0;
                MemRead = 0;
                MemtoReg = 1'bX;
                MemWrite = 1;
                ALUSrc = 1;
                RegWrite = 0;
                ALUOp = 2'b00;
               end
            7'b1100011: //SB
             begin
            Branch = 1;
            MemRead = 0;
            MemtoReg = 1'bX;
            MemWrite = 0;
            ALUSrc = 0;
            RegWrite = 0;
            ALUOp = 2'b01;
             end
        endcase
    end
endmodule

