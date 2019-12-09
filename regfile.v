module regfile(
	clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA,
	data_readRegB, change_shape, shape_out, stop, score, clear, start_over
);
	input clock, ctrl_writeEnable, ctrl_reset, clear, start_over;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
	
	input change_shape, stop;
	output [31:0] data_readRegA, data_readRegB, shape_out;
	output reg [31:0] score;

	wire [31:0] change_shape_32, stop_32, clear_32;
	assign change_shape_32 = {31'b0, change_shape};
	assign stop_32 = {31'b0, stop};
	assign clear_32 = {31'b0, clear};
	
	reg[31:0] registers[31:0];
	reg[31:0] prime;
	
	initial begin
		prime = 32'd3989;
		score = 0;
	end
	
	always @(posedge clock)
	begin
		prime = prime + 1;
//		if(ctrl_reset)
//			begin
//				integer i;
//				for(i = 0; i < 32; i = i + 1)
//					begin
//						registers[i] = 32'd0;
//					end
//			end
//		else begin
//			if(ctrl_writeEnable && ctrl_writeReg != 5'd0) begin
//				registers[ctrl_writeReg] = data_writeReg;
//			end
		
			registers[2] = change_shape_32;
			registers[3] = clear_32;
			registers[11] = stop_32;
	
			if(registers[11] != 0) begin
				registers[1] = registers[1] ^ prime;
				registers[1] = registers[1] % 12;
			end
			if(registers[3] != 0) begin
				score = score + 1;
			end
			
			if(registers[1] == 32'd2 && registers[2]!=0) begin
				registers[1] = 1;
			end
			else if(registers[1]==32'd6 && registers[2]!=0) begin
				registers[1] = 32'd3;
			end
			else if(registers[1]==32'd10 && registers[2]!=0) begin
				registers[1] = 32'd7;
			end
			else if(registers[1]==32'd12 && registers[2]!=0) begin
				registers[1] = 32'd11;
			end
			else if(registers[1]>=32'd14 && registers[2]!=0) begin
				registers[1] = 32'd13;
			end
			else if(registers[2] != 0) begin
				registers[1] = registers[1] + 1;
			end
			
			if(start_over == 1) begin
				score = 0;
				registers[2] = 0;
				registers[3] = 0;
				registers[11] = 0;
			end
			
	end
	
	assign data_readRegA = registers[ctrl_readRegA];
	assign data_readRegB = registers[ctrl_readRegB];
	assign shape_out = registers[1];
	
endmodule