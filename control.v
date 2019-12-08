module control(alu_op, overflow, r_type, addi, sw, lw, bne, blt, j, jal, bex, setx, jr, isNotEqual,
	ctrl_writeEnable_1, aluinb_sel, br_en, dmem_en, need_wb, j_mux_sel, wb_mux_sel, read_rstatus,
	rd_mux_sel, rstatus_mux_sel);

input r_type, addi, sw, lw, bne, blt, j, jal, bex, setx, jr, isNotEqual, overflow;
input [4:0] alu_op;
output ctrl_writeEnable_1, aluinb_sel, br_en, dmem_en, read_rstatus;
output [1:0] j_mux_sel, wb_mux_sel, rd_mux_sel, rstatus_mux_sel;
output need_wb;

wire need_imm, need_br, need_j;
//ctrl_writeEnable
assign need_wb = r_type | addi | lw | jal | setx;
assign ctrl_writeEnable_1 = (need_wb) ? 1'b1 : 1'b0;


//aluinb_sel
assign need_imm = addi | lw | sw;
assign aluinb_sel = (need_imm) ? 1'b1 : 1'b0;

//br_en
assign br_en = bne | blt;

//dmem_en
assign dmem_en = sw;

//j_mux_sel
assign need_j = j | jal | (bex&isNotEqual);
assign j_mux_sel[0] = (need_j) ? 1'b1 : 1'b0; //select pc+1 / jump target
assign j_mux_sel[1] = (jr) ? 1'b1 : 1'b0;  //jr

//wb_mux_sel
//jal - 00
//lw  - 01
//alu - 10
//setx | overflow - 11
assign wb_mux_sel[1] = r_type | addi | setx | overflow;
assign wb_mux_sel[0] = lw | setx | overflow;


//bex
assign read_rstatus = bex;

wire add, sub, add_sub, sub_setx ;
assign sub = (alu_op[4] & alu_op[3] & alu_op[2] & alu_op[1] & (~alu_op[0]));
assign add = (alu_op) ? 1'b0 : 1'b1;

//rd_mux_sel
//00 - rd
//01 - 30
//10 - 31
assign rd_mux_sel[1] = (jal) ? 1'b1 : 1'b0;
assign rd_mux_sel[0] = setx;

//rstatus_mux_sel
//1 - 00
//2 - 01
//3 - 10
//setx_target - 11
assign add_sub = add | sub;
assign sub_setx = addi | setx;
assign rstatus_mux_sel[1] = sub_setx;
assign rstatus_mux_sel[0] = ~add_sub;


endmodule
