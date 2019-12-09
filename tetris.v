module tetris(iVGA_CLK, up,left, down, right, ref_x, ref_y, stop, hit, 
	shape, change_shape, start_over, clear, ADDR, score);

input iVGA_CLK, up,left, down,right, stop, hit, clear, start_over;
input [31:0] shape, score;
input [18:0] ADDR;
output reg [9:0] ref_x, ref_y;
output reg change_shape;

reg [31:0] count, count_1;
reg [4:0] block_size;
reg [9:0] hori_size;
reg [9:0] vert_size;
reg [31:0] limit_1, limit_2, comp_value;
//reg change;

initial begin
	ref_x = 280;
	ref_y = 0;
	count = 0;
	count_1 = 0;
	change_shape = 0;
	block_size = 5'd20;
	hori_size = 10'd480;
	vert_size = 10'd480;
	limit_1 = 32'd4500000;
	limit_2 = 32'd3000000;
	comp_value = limit_1;
end



always @(posedge ADDR) begin
	if(!up) begin
		count_1 <= count_1 + 1;
	end	
	
	if(count_1 >= 2000000)
	begin
		change_shape <= 1;
		count_1 <= 0;
	end
	else if(change_shape == 1) change_shape <=0;
	
end

always @(posedge iVGA_CLK)
begin
	if(score >= 32'd4) comp_value = limit_2;
	else comp_value = limit_1;
end


always @(posedge iVGA_CLK)
begin
	count <= count+1;
	if(stop == 1 || start_over==1) begin
			ref_x <= 280;
			ref_y <= 0;
		end
		
		
	if (count >= comp_value) begin
		count <= 0;
		
		begin
			case(shape)
			4'd1: begin //long hori rectangle
				if( ref_y < (vert_size - block_size)) ref_y <= ref_y + block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - block_size)) ref_y <= ref_y + 2*block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 4*block_size)) ref_x <= ref_x + block_size;
				end
			end
			
			4'd2: begin //long vert rec
				if( ref_y < (vert_size - 4*block_size)) ref_y <= ref_y + block_size;
			
				if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 4*block_size)) ref_y <= ref_y + 2*block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - block_size)) ref_x <= ref_x + block_size;
				end
			
			end

			4'd3: begin 
				if( ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= 2*block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + 2*block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 2*block_size)) ref_x <= ref_x + block_size;
				end
			end
			
			4'd4: begin
				if( ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + 2*block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 2*block_size)) ref_x <= ref_x + block_size;
				end
			end
			
			4'd5: begin
				if( ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + 2*block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 3*block_size)) ref_x <= ref_x + block_size;
				end
			end
			4'd6: begin
				if( ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= 2*block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + 2*block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - block_size)) ref_x <= ref_x + block_size;
				end
			end
		
			4'd7: begin
				if( ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + 2*block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 2*block_size)) ref_x <= ref_x + block_size;
				end
			end
			
			4'd8: begin
				if( ref_y < (vert_size - block_size)) ref_y <= ref_y + block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + 2*block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 3*block_size)) ref_x <= ref_x + block_size;
				end
			end
			
			4'd9: begin
				if( ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + 2*block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 2*block_size)) ref_x <= ref_x + block_size;
				end
			end
			
			4'd10: begin
				if( ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= 3*block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + 2*block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - block_size)) ref_x <= ref_x + block_size;
				end
			end
		
			4'd11: begin
				if( ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + 2*block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 2*block_size)) ref_x <= ref_x + block_size;
				end
			end
		
			4'd12: begin
				if( ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= 2*block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + 2*block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 2*block_size)) ref_x <= ref_x + block_size;
				end
			end
			
			4'd13: begin
				if( ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= 2*block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 3*block_size)) ref_y <= ref_y + 2*block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - block_size)) ref_x <= ref_x + block_size;
				end
			end
			
			4'd14: begin
				if( ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + 2*block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 3*block_size)) ref_x <= ref_x + block_size;
				end
			end
		
			default: //square
			begin
				if( ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + block_size;
			
//				if(!up) begin
//					change_shape <= 1;
//				end
//				else 
				if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + 2*block_size;
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
