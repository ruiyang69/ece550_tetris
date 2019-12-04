module tetris(iVGA_CLK, up,left, down, right, ref_x, ref_y, stop, hit, shape, change_shape, start_over);

input iVGA_CLK, up,left, down,right, stop, hit;
input [2:0] shape;
output reg [9:0] ref_x, ref_y;
output reg change_shape, start_over;

reg [31:0] count;
reg [4:0] speed_init;
reg [4:0] block_size;
reg [9:0] hori_size;
reg [9:0] vert_size;

initial begin
	ref_x = 280;
	ref_y = 0;
	count = 0;
	speed_init = 5'd5;
	change_shape = 0;
	block_size = 5'd20;
	hori_size = 10'd480;
	vert_size = 10'd480;
	start_over = 0;
end

always @(posedge iVGA_CLK)
begin
	count <= count+1;
	if (count >= 23'd3500000) begin
		count <= 0;
		
		if(stop == 1 || start_over==1) begin
			ref_x <= 280;
			ref_y <= 0;
			start_over <= 0;
		end
		
		else begin
			
			case(shape)
			3'd1: begin //long hori rectangle
				if( ref_y < (vert_size - block_size)) ref_y <= ref_y + speed_init;
			
				if(!up) begin
					start_over <= 1;
				end
				else if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - block_size)) ref_y <= ref_y + block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - 4*block_size)) ref_x <= ref_x + block_size;
				end
			end
			
			3'd2: begin //long vert rec
				if( ref_y < (vert_size - 4*block_size)) ref_y <= ref_y + speed_init;
			
				if(!up) begin
					start_over <= 1;
				end
				else if(!left && !hit) begin
					if(ref_x >= block_size) ref_x <= ref_x - block_size;
				end
				else if(!down && !stop) begin
					if(ref_y < (vert_size - 4*block_size)) ref_y <= ref_y + block_size;
				end
				else if(!right && !hit) begin
					if(ref_x < (hori_size - block_size)) ref_x <= ref_x + block_size;
				end
			
			end
		
		
			default: //square
			begin
				if( ref_y < (vert_size - 2*block_size)) ref_y <= ref_y + speed_init;
			
				if(!up) begin
					start_over <= 1;
				end
				else if(!left && !hit) begin
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
