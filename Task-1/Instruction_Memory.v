module Instruction_Memory
(
    input [63:0] Inst_Address,
    output [31:0] Instruction
);

reg [7:0] memory [131:0];

initial 
begin
   
//initializing array of length 3 with different values
//the binary values are assigned on basis of instruction format it is of 32-bit

//  addi x5, x0, 2
//opcode: 0010011, rd: 00101 (5), funct3: 000, rs1: 00000 (0), immediate: 000000000010 (2)
    memory[0] = 8'b10010011; 
    memory[1] = 8'b00000010; 
    memory[2] = 8'b00100000;
    memory[3] = 8'b00000000;

//  sd x5, 0x100 (x0)
//opcode: 0100011, rs2: 00101 (5), rs1: 00000 (0), immediate: 0001 0000 0000 (0x100), funct3: 011
    memory[4] = 8'b00100011;
    memory[5] = 8'b00110010; 
    memory[6] = 8'b01010000;
    memory[7] = 8'b00000000;

//  addi x5, x0, 48
// opcode: 0010011, rd: 00101 (5), funct3: 000, rs1: 00000 (0), immediate: 000000110000 (48)
    memory[8] = 8'b10010011;
    memory[9] = 8'b00000010;
    memory[10] = 8'b00000000;
    memory[11] = 8'b00000011;

//  sd x5, 0x104(x0)
// opcode: 0100011, rs2: 00101 (5), rs1: 00000 (0), immediate: 0001 0000 0100 (0x104), funct3: 011
    memory[12] = 8'b00100011;
    memory[13] = 8'b00110110;
    memory[14] = 8'b01010000;
    memory[15] = 8'b00000000;

//  addi x5, x0, 24
// opcode: 0010011, rd: 00101 (5), funct3: 000, rs1: 00000 (0), immediate: 000000011000 (24)
    memory[16] = 8'b10010011;
    memory[17] = 8'b00000010;
    memory[18] = 8'b10000000;
    memory[19] = 8'b00000001;

//  sd x5, 0x108(x0)
// opcode: 0100011, rs2: 00101 (5), rs1: 00000 (0), immediate: 0000 0010 1000 (0x108), funct3: 011
    memory[20] = 8'b00100011;
    memory[21] = 8'b00111010;
    memory[22] = 8'b01010000;
    memory[23] = 8'b00000000;

//initalising list
//  addi x10, x0, 0x100
// opcode: 0010011, rd: 01010 (10), funct3: 000, rs1: 00000 (0), immediate: 0001 0000 0000 (0x100)
    memory[24] = 8'b00010011;
    memory[25] = 8'b00000101;
    memory[26] = 8'b01000000;
    memory[27] = 8'b00000000;

//iniatlising the list to size of 3
//  addi x11, x0, 3
// opcode: 0010011, rd: 01011 (11), funct3: 000, rs1: 00000 (0), immediate: 0000 0000 0011 (3)
    memory[28] = 8'b10010011;
    memory[29] = 8'b00000101;
    memory[30] = 8'b00110000;
    memory[31] = 8'b00000000;
    
//Bubble Sorting starts from here
//  bne x10, x0, ELSE
    memory[32] = 8'b01100011;
    memory[33] = 8'b00010110;
    memory[34] = 8'b00000101;
    memory[35] = 8'b00000000;
    
//  bne x11, x0, ELSE
    memory[36] = 8'b01100011;
    memory[37] = 8'b10010100;
    memory[38] = 8'b00000101;
    memory[39] = 8'b00000000;
    
//BUBBLE1:
//  beq x0, x0, EXIT1
    memory[40] = 8'b01100011;
    memory[41] = 8'b00001100;
    memory[42] = 8'b00000000;
    memory[43] = 8'b00000100;
    
// ELSE: addi x18, x0, 0 
//initialising loop counter integer i
    memory[44] = 8'b00010011;
    memory[45] = 8'b00001001;
    memory[46] = 8'b00000000;
    memory[47] = 8'b00000000;
    
// BUBBLE1: beq x18, x11, EXIT1
    memory[48] = 8'b01100011;
    memory[49] = 8'b00000110;
    memory[50] = 8'b10111001;
    memory[51] = 8'b00000100;
    
//initialising j to i for inner loop
//  add x19, 0, x18 
    memory[52] = 8'b10110011;
    memory[53] = 8'b00001001;
    memory[54] = 8'b00100000;
    memory[55] = 8'b00000001;
    
// BUBBLE2: beq x19, x11, EXIT2 
    memory[56] = 8'b01100011;
    memory[57] = 8'b10001110;
    memory[58] = 8'b10111001;
    memory[59] = 8'b00000010;
    
//calculating offset for i
//  slli x5, x18, 2
    memory[60] = 8'b10010011;
    memory[61] = 8'b00010010;
    memory[62] = 8'b00111001;
    memory[63] = 8'b00000000;
    
//calculating offset for j
//  slli x6, x19, 2
    memory[64] = 8'b00010011;
    memory[65] = 8'b10010011;
    memory[66] = 8'b00111001;
    memory[67] = 8'b00000000;
    
//getting actual memory address for a[i]
//  add x5, x5, x10
    memory[68] = 8'b10110011;
    memory[69] = 8'b10000010;
    memory[70] = 8'b10100010;
    memory[71] = 8'b00000000;
    
//getting actual memory address for a[j]    
//  add x6, x6, x10
    memory[72] = 8'b00110011;
    memory[73] = 8'b00000011;
    memory[74] = 8'b10100011;
    memory[75] = 8'b00000000;
    
//  ld x28, 0(x5)
    memory[76] = 8'b00000011;
    memory[77] = 8'b10111110;
    memory[78] = 8'b00000010;
    memory[79] = 8'b00000000;
    
//  ld x29, 0(x6)
    memory[80] = 8'b10000011;
    memory[81] = 8'b00111110;
    memory[82] = 8'b00000011;
    memory[83] = 8'b00000000;
    
//If a[i] >= a[j], skip the swap.
//  bge x28, x29, 24
//opcode: 1100011, imm[4:1|11]: 11000 (24), funct3: 101, rs1: 11100 (28), rs2:11101 (29), imm[12|10:5]: 0000000 (0)
    memory[84] = 8'b01100011;
    memory[85] = 8'b01011100;
    memory[86] = 8'b11011110;
    memory[87] = 8'b00000001;
    
//SWAPPING HAPPENS HERE
//  add x30, x0, x28 
//temp = a[i]
    memory[88] = 8'b00110011;
    memory[89] = 8'b00001111;
    memory[90] = 8'b11000000;
    memory[91] = 8'b00000001;
    
//  add x28, x0, x29
//a[i] = a[j]
    memory[92] = 8'b00110011;
    memory[93] = 8'b00001110;
    memory[94] = 8'b11010000;
    memory[95] = 8'b00000001;
    
//  add x29, x0, x30
//a[j] = temp
    memory[96] = 8'b10110011;
    memory[97] = 8'b00001110;
    memory[98] = 8'b11100000;
    memory[99] = 8'b00000001;
    
//  sd x28, 0(x5)
    memory[100] =8'b00100011;
    memory[101] =8'b10110000;
    memory[102] =8'b11000010;
    memory[103] =8'b00000001;
    
//  sd x29, 0(x6)
//opcode: 0100011, imm[4:0]: 000000, funct3: 011, rs1:00110 (6), rs2: 11101 (29), imm[11:5]: 0000000
    memory[104] =8'b00100011;
    memory[105] =8'b00110000;
    memory[106] =8'b11010011;
    memory[107] =8'b00000001;
    
// BUBBLE2_CONTD: addi, x19, x19 , 1
//incrementing j
    memory[108] =8'b10010011;
    memory[109] =8'b10001001;
    memory[110] =8'b00011001;
    memory[111] =8'b00000000;
    
//  beq x0, x0, BUBBLE2
    memory[112] =8'b11100011;
    memory[113] =8'b00000100;
    memory[114] =8'b00000000;
    memory[115] =8'b11111100;
    
//EXIT2: addi x18, x18, 1
//incrementing i
    memory[116] =8'b00010011; 
    memory[117] =8'b00001001;
    memory[118] =8'b00011001;
    memory[119] =8'b00000000;

//  beq x0, x0, BUBBLE1
    memory[120] =8'b11100011;
    memory[121] =8'b00001100;
    memory[122] =8'b00000000;
    memory[123] =8'b11111010;
    
//  beq x0, x0, 4
    memory[124] =8'b01100011;
    memory[125] =8'b00000010;   
    memory[126] =8'b00000000;
    memory[127] =8'b00000000;
    
//  addi x0, x0, 0 
    memory[128] =8'b00010011;
    memory[129] =8'b00000000;
    memory[130] =8'b00000000;
    memory[131] =8'b00000000;


end

assign Instruction = {memory[Inst_Address+3], memory[Inst_Address+2],
       memory[Inst_Address+1], memory[Inst_Address]}; 

endmodule 

