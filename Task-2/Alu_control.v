module ALU_Control
(
    input [1:0] ALUOp,
    input [3:0] Funct,
    output reg [3:0] Operation
);
        always @ (*)
            begin
            case(ALUOp)
                2'b00: //slli case
                begin
                case({Funct[2:0]})
                    3'b001: 
                    begin
                    Operation= 4'b0111;  //Slli
                    end
                    default:
                    begin
                    Operation= 4'b0010; //Add
                    end
                 endcase
                 end
               2'b01: //branch case 
                  begin
                   case ({Funct[2:0]})
                   3'b000:
                       begin
                       Operation= 4'b0110; //BEQ
                       end
                   3'b001:
                       begin
                       Operation = 4'b0110; //BNE
                       end
                   3'b101:
                       begin
                       Operation=4'b0110; //BGE
                       end
                    endcase
                   end
                    
            2'b10: // check of and or add sub case
            begin
            case(Funct)
                4'b0000: 
                    begin
                    Operation = 4'b0010; //add
                    end
                4'b1000:
                    begin 
                    Operation = 4'b0110; //sub
                    end
                4'b0111: 
                    begin
                    Operation = 4'b0000; //and
                    end
                4'b0110: 
                    begin
                    Operation = 4'b0001; //or
                    end
            endcase
            end
      endcase
   end
endmodule