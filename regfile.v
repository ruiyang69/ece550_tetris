module regfile(
	clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA,
	data_readRegB, change_shape, shape_out
);
	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
	
	input change_shape;
	output [31:0] data_readRegA, data_readRegB, shape_out;

	wire [31:0] change_shape_32;
	assign change_shape_32 = {31'b0, change_shape};
	
	reg[31:0] registers[31:0];
	
initial begin
	registers[1] = 32'd3;
	registers[2] = 32'd0;
	registers[3] = 32'd6;
	registers[4] = 32'd10;
	registers[5] = 32'd12;
	registers[6] = 32'd14;
end
	
	
	always @(posedge clock or posedge ctrl_reset)
	begin
		if(ctrl_reset)
			begin
				integer i;
				for(i = 0; i < 32; i = i + 1)
					begin
						registers[i] = 32'd0;
					end
			end
		else begin
			if(ctrl_writeEnable && ctrl_writeReg != 5'd0) begin
				registers[ctrl_writeReg] = data_writeReg;
			end
			registers[2] = change_shape_32;
		end
	end
	
	assign data_readRegA = registers[ctrl_readRegA];
	assign data_readRegB = registers[ctrl_readRegB];
	assign shape_out = registers[1];
	
endmodule