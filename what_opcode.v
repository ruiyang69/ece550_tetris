module what_opcode(opcode, r_type, addi, sw, lw, bne, blt, j, jal, bex, setx, jr);

input [4:0] opcode;
output r_type; //R
output addi, sw, lw, bne, blt; //I
output j, jal, bex, setx;  //J I
output jr; //J I I

wire bit_0, bit_1, bit_2, bit_3, bit_4;
assign bit_0 = opcode[0];
assign bit_1 = opcode[1];
assign bit_2 = opcode[2];
assign bit_3 = opcode[3];
assign bit_4 = opcode[4];


//r type instruction all have opcode = 00000
assign r_type = ((bit_0 | bit_1 | bit_2 | bit_3 | bit_4) == 0) ? 1'b1 : 1'b0;

//i type, addi, sw, lw, bne, blt
assign addi = (~bit_4 & ~bit_3 & bit_2 & ~bit_1 & bit_0);//addi 00101
assign sw = (~bit_4 & ~bit_3 & bit_2 & bit_1 & bit_0); //sw 00111
assign lw = (~bit_4 & bit_3 & ~bit_2 & ~bit_1 & ~bit_0); //lw 01000
assign bne = (~bit_4 & ~bit_3 & ~bit_2 & bit_1 & ~bit_0); //bne 00010
assign blt = (~bit_4 & ~bit_3 & bit_2 & bit_1 & ~bit_0);  //blt 00110


//j_i type
assign j = (~bit_4 & ~bit_3 & ~bit_2 & ~bit_1 & bit_0); //j 00001
assign jal = (~bit_4 & ~bit_3 & ~bit_2 & bit_1 & bit_0); //jal 00011
assign bex = (bit_4 & ~bit_3 & bit_2 & bit_1 & ~bit_0);  //bex 10110
assign setx = (bit_4 & ~bit_3 & bit_2 & ~bit_1 & bit_0); //setx 10101

//j_i_i type
assign jr = (~bit_4 & ~bit_3 & bit_2 & ~bit_1 & ~bit_0);  //jr 00100

endmodule
