/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
//	 ,
//	 //test signals
//	 rstatus_mux_sel_test,
//	 rstatus_mux_out_test,
//	 rd_mux_out_test,
//	 rd_mux_sel_test,
//	 overflow_test,
//	 isNotEqual_test,
//	 isLessThan_test,
//	 bne_test,
//	 blt_test,
//	 br_mux_sel_test,
//	 imm_test,
//	 pc_in_test,
//	 pc_out_test,
//	 alu_ina_test,
//	 alu_inb_test,
//	 aluinb_out_test,
//	 alu_out_test
	 
);
	 

    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */
	 wire [4:0] opcode, alu_op, shamt;
	 wire [16:0] imm;
	 wire [26:0] j_target;
	 wire [31:0] j_target_32;
	 assign opcode = q_imem[31:27];
	 assign alu_op = (addi | sw |lw) ? 5'b0 : q_imem[6:2];
	 assign shamt = q_imem[11:7];
	 assign imm = q_imem[16:0];
	 assign j_target = q_imem[26:0];
	 assign j_target_32 = (j_target[26]) ? ({{5{1'b1}}, j_target}) : ({{5{1'b0}}, j_target}); 
	 wire overflow, isNotEqual, isLessThan;
	 
	 //pc
	 wire [31:0] pc_in, pc_plus1_out;
	 wire [31:0] pc_out;
	 assign address_imem = pc_out[11:0];
	
	 pc pc(.q(pc_out), .d(pc_in), .clk(clock), .clr(reset), .en(1'b1));
	 //adder_32 pc_alu(.a(pc_out), .b(32'd1), .f(pc_plus1_out));	
	 alu pc_alu(.data_operandA(pc_out), .data_operandB(32'b1), .ctrl_ALUopcode(5'b0),
			.ctrl_shiftamt(0), .data_result(pc_plus1_out), .isNotEqual(), 
			.isLessThan(), .overflow());
	
	
//control logic
wire r_type, addi, sw, lw, j, jal, bex, setx, jr;
wire  bne, blt, br_mux_sel;
wire aluinb_sel, br_en, dmem_en, read_rstatus, need_wb;
wire [31:0] wb_data, rstatus_1, rstatus_2, rstatus_3, rstatus_mux_out;
wire [1:0] j_mux_sel, wb_mux_sel, rd_mux_sel, rstatus_mux_sel;
wire [4:0] rd_mux_out, rs, rt, rd, ra, rstatus;
wire [31:0] true_aluinb_out, aluinb_out, alu_out;
wire [31:0] br_alu_out, br_addr;
wire br_sel_en, ctrl_writeEnable_1;
wire [31:0] imm_sext;
	 
	 
	 
	 //test signals
//	 output [1:0] rstatus_mux_sel_test, rd_mux_sel_test;
//	 output [4:0] rd_mux_out_test;
//	 output [31:0] rstatus_mux_out_test, pc_in_test, pc_out_test, imm_test, alu_out_test;
//	 output [31:0] aluinb_out_test, alu_ina_test, alu_inb_test;
//	 output  overflow_test, isNotEqual_test, isLessThan_test, bne_test, blt_test, br_mux_sel_test;
//	 
//	 assign overflow_test = overflow;
//	 assign isNotEqual_test = isNotEqual;
//	 assign isLessThan_test = isLessThan;
//	 assign bne_test = bne;
//	 assign blt_test = blt;
//	 assign br_mux_sel_test = br_mux_sel;
//	 assign rstatus_mux_sel_test = rstatus_mux_sel;
//	 assign rstatus_mux_out_test = rstatus_mux_out;
//	 assign rd_mux_out_test = rd_mux_out;
//	 assign rd_mux_sel_test = rd_mux_sel;
//	 assign pc_in_test = pc_in;
//	 assign pc_out_test = pc_out;
//	 assign imm_test = imm_sext;
//	 assign aluinb_out_test = aluinb_out;
//	 assign alu_out_test = alu_out;

	 //end test
	 

//check what instruction we are dealing with	 
what_opcode wo(.opcode(opcode), .r_type(r_type), .addi(addi), .sw(sw), .lw(lw), 
	.bne(bne), .blt(blt), .j(j), .jal(jal), .bex(bex), .setx(setx), .jr(jr));
	
	

control control(alu_op, overflow, r_type, addi, sw, lw, bne, blt, j, jal, bex, setx, jr, isNotEqual,
	ctrl_writeEnable, aluinb_sel, br_en, dmem_en, need_wb, j_mux_sel, wb_mux_sel, read_rstatus, 
	rd_mux_sel, rstatus_mux_sel);


assign ctrl_writeReg =  (jal) ? 5'd31: (overflow ? 5'd30 : rd);

//regfile
assign rd = q_imem[26:22];
assign rs = (bex) ? rstatus : q_imem[21:17];
assign rt = q_imem[16:12];
assign ra = 5'd31;
assign rstatus = 5'd30;

assign ctrl_readRegA = (br_en | jr) ? rd : rs;
assign ctrl_readRegB = sw ? rd : (br_en ? rs : rt);


four_to_one_mux_5_bit rd_mux(.sel(rd_mux_sel), .a(rd), .b(rstatus), .c(ra), .d(), .f(rd_mux_out));


//sign extend
assign imm_sext = (imm[16]) ? ({{15{1'b1}},imm}):({{15{1'b0}},imm}); 
//bex: rstatus != 0
assign true_aluinb_out = (bex) ? 32'b0 : aluinb_out;  

//alu b input mux
two_to_one_mux aluinb(aluinb_sel, data_readRegB, imm_sext, aluinb_out);

alu alu( .data_operandA(data_readRegA), .data_operandB(true_aluinb_out), .ctrl_ALUopcode(alu_op),
			.ctrl_shiftamt(shamt), .data_result(alu_out), .isNotEqual(isNotEqual), 
			.isLessThan(isLessThan), .overflow(overflow));
			
//br and j
//adder_32 br_alu(.a(pc_plus1_out), .b(imm_sext), .f(br_alu_out)); //calculate br addr
alu br_alu(.data_operandA(pc_plus1_out), .data_operandB(imm_sext), .ctrl_ALUopcode(5'b0),
			  .ctrl_shiftamt(0), .data_result(br_alu_out), .isNotEqual(), 
			  .isLessThan(), .overflow());

assign br_sel_en = (bne & isNotEqual) | (blt & isLessThan);
assign br_mux_sel = br_en & br_sel_en;

two_to_one_mux br_mux(br_mux_sel, pc_plus1_out, br_alu_out, br_addr);
four_to_one_mux j_mux(.sel(j_mux_sel), .a(br_addr), .b(j_target_32), .c(data_readRegA), .d(), .f(pc_in));

	
//dmem
assign address_dmem = alu_out[11:0];
//data to be written to dmem
assign data = data_readRegB; 
//dmem write enable
assign wren = dmem_en;  


//wb

assign rstatus_1 = 32'd1;
assign rstatus_2 = 32'd2;
assign rstatus_3 = 32'd3;


//rstatus write-in data if overflow
four_to_one_mux rstatus_mux(.sel(rstatus_mux_sel), .a(rstatus_1), .b(rstatus_2), .c(rstatus_3), .d(j_target_32),
							.f(rstatus_mux_out));

four_to_one_mux wb_mux(.sel(wb_mux_sel), .a(pc_plus1_out), .b(q_dmem), .c(alu_out), .d(rstatus_mux_out), 
							.f(data_writeReg));


endmodule
