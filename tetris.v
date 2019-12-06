module tetris(iVGA_CLK, up,left, down, right, ref_x, ref_y, stop, hit, shape, change_shape, start_over, clear, fall_down_clk, ADDR);

input iVGA_CLK, up,left, down,right, stop, hit, clear;
input [31:0] shape;
input [18:0] ADDR;
output reg [9:0] ref_x, ref_y;
output reg change_shape, start_over, fall_down_clk;

reg [31:0] count;
reg [4:0] speed_init;
reg [4:0] block_size;
reg [9:0] hori_size;
reg [9:0] vert_size;
//reg change;

initial begin
	ref_x = 280;
	ref_y = 0;
	count = 0;
	speed_init = 5'd1;
	change_shape = 0;
	block_size = 5'd20;
	hori_size = 10'd480;
	vert_size = 10'd480;
	start_over = 0;
	fall_down_clk = 0;
//	change = 0;
end

always @(posedge ADDR) begin
	if(!up) change_shape <= 1;
	else if(change_shape == 1) change_shape <=0;
end

always @(posedge iVGA_CLK)
begin
	count <= count+1;
	if (count >= 23'd3500000) begin
		count <= 0;
//		change_shape <= 0;
		
		fall_down_clk <= !fall_down_clk;
		if(stop == 1 || start_over==1) begin
			ref_x <= 280;
			ref_y <= 0;
			start_over <= 0;
		end
		
		else begin
			if(clear == 1) begin
				speed_init = speed_init + 1;
			end
			
			case(shape)
			4'd1: begin //long hori rectangle
				if( ref_y < (vert_size - block_size)) ref_y <= ref_y + speed_init*block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - block_size)) ref_y <= ref_y + block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 4*block_size)) ref_x <= ref_x + block_size;
				end
			end
			
			4'd2: begin //long vert rec
				if( ref_y < (vert_size - 4*block_size)) ref_y <= ref_y + speed_init*block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 4*block_size)) ref_y <= ref_y + block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - block_size)) ref_x <= ref_x + block_size;
				end
			
			end

			4'd3: begin 
				if( ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + speed_init*block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= 2*block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 2*block_size)) ref_x <= ref_x + block_size;
				end
			end
			
			4'd4: begin
				if( ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + speed_init*block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 2*block_size)) ref_x <= ref_x + block_size;
				end
			end
			
			4'd5: begin
				if( ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + speed_init*block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 3*block_size)) ref_x <= ref_x + block_size;
				end
			end
			4'd6: begin
				if( ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + speed_init*block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= 2*block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - block_size)) ref_x <= ref_x + block_size;
				end
			end
		
			4'd7: begin
				if( ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + speed_init*block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 2*block_size)) ref_x <= ref_x + block_size;
				end
			end
			
			4'd8: begin
				if( ref_y < (vert_size - block_size)) ref_y <= ref_y + speed_init*block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 3*block_size)) ref_x <= ref_x + block_size;
				end
			end
			
			4'd9: begin
				if( ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + speed_init*block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 2*block_size)) ref_x <= ref_x + block_size;
				end
			end
			
			4'd10: begin
				if( ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + speed_init*block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= 3*block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - block_size)) ref_x <= ref_x + block_size;
				end
			end
		
			4'd11: begin
				if( ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + speed_init*block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 2*block_size)) ref_x <= ref_x + block_size;
				end
			end
		
			4'd12: begin
				if( ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + speed_init*block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= 2*block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 2*block_size)) ref_x <= ref_x + block_size;
				end
			end
			
			4'd13: begin
				if( ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + speed_init*block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= 2*block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - block_size)) ref_x <= ref_x + block_size;
				end
			end
			
			4'd14: begin
				if( ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + speed_init*block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 3*block_size)) ref_x <= ref_x + block_size;
				end
			end
		
			default: //square
			begin
				if( ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + speed_init*block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 2*block_size)) ref_x <= ref_x + block_size;
				end
			end
			endcase
		end

	end
	
end



endmodule
