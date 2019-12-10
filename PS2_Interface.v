module PS2_Interface(inclock, resetn, ps2_clock, ps2_data, ps2_key_data, ps2_key_pressed, last_data_received, up_kb, down_kb, left_kb, right_kb, space_kb);

	input 			inclock, resetn;
	inout 			ps2_clock, ps2_data;
	output 			ps2_key_pressed;
	output 	[7:0] 	ps2_key_data;
	output 	[7:0] 	last_data_received;

	// Internal Registers
	reg			[7:0]	last_data_received;	
	output reg up_kb, down_kb, left_kb, right_kb, space_kb;
	reg [31:0] count;
	
	initial begin
		count <= 0;
	end
	
	always @(posedge inclock)
	begin
		if (resetn == 1'b0)
			last_data_received <= 8'h00;
		else if (ps2_key_pressed == 1'b1) begin
			last_data_received <= ps2_key_data;
			
			if (ps2_key_data == 8'h75) begin
				up_kb <= 0;
			end
			else if (ps2_key_data == 8'h72) begin
				down_kb <= 0;
			end
			else if (ps2_key_data == 8'h74) begin
				right_kb <= 0;
			end
			else if (ps2_key_data == 8'h6B) begin
				left_kb <= 0;
			end
			else if (ps2_key_data == 8'h29) begin
				space_kb <= 0;
			end
			
		end
		
		count <= count + 1;
		if (count >= 32'd9500000) begin
			count <= 0;
			up_kb <= 1;
			down_kb <= 1;
			left_kb <= 1;
			right_kb <= 1;
			space_kb <= 1;
		end
		
	end
	
	PS2_Controller PS2 (.CLOCK_50 			(inclock),
						.reset 				(~resetn),
						.PS2_CLK			(ps2_clock),
						.PS2_DAT			(ps2_data),		
						.received_data		(ps2_key_data),
						.received_data_en	(ps2_key_pressed)
						);

endmodule
