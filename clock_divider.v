module clock_divider(clock, clock_dmem, clock_processor, clock_regfile);

input clock;
output clock_dmem, clock_processor, clock_regfile;

reg clock_dmem, clock_processor, clock_regfile;
reg [31:0] processor_counter;

initial begin
	processor_counter <= 0;
	clock_dmem <= 0;
	clock_processor <= 0;
	clock_regfile <= 0;
end


always @(posedge clock) begin
	clock_dmem <= ~clock_dmem;
	processor_counter <= processor_counter + 1;
	
	if(processor_counter >= 1) begin
		processor_counter <= 0;
		clock_processor <= ~clock_processor;
		clock_regfile <= ~clock_regfile;
	end
	else begin
		clock_processor <= clock_processor;
		clock_regfile <= clock_regfile;
	end
	
end

endmodule
