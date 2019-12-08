module color_mux(iVGA_CLK, ref_x, ref_y, ADDR, sel, stop, hit, shape, change_shape, start_over, clear, fall_down_clk);

//inputs outputs
input [9:0] ref_x, ref_y;
input [18:0] ADDR;
input iVGA_CLK, change_shape, start_over, fall_down_clk;

output reg sel, stop, hit, clear;
input [31:0] shape;


//local variable
reg [31:0] xl, xr, yu, yd, x, y, print_x, print_y, mat_x, mat_y;
reg [31:0] cor_1, cor_2, cor_3, cor_4, exc_1, exc_2;
reg [31:0] cor_stop_1, cor_stop_2, cor_stop_3, cor_stop_4; 
reg [31:0] cor_hit_left_1, cor_hit_left_2, cor_hit_left_3, cor_hit_left_4;
reg [31:0] cor_hit_right_1, cor_hit_right_2, cor_hit_right_3, cor_hit_right_4, print_cor;

reg [767:0] exist;
reg [31:0] count;
reg [31:0] score;
reg [31:0] block_size, hori_size, vert_size;

//reg clock_by_2;

//initial block
initial begin
	exist = 768'b0;
	stop = 0;
	hit = 0;
	score = 0;
	//clock_by_2 = 0;
	block_size = 32'd20;
	hori_size = 32'd480;
	vert_size = 32'd480;
	clear = 0;
end

//clock divider
//always @(posedge iVGA_CLK) begin
//	count <= count + 1;
//	if(count >= 32'd3500000) begin
//		count <= 0;
//		clock_by_2 = !clock_by_2;
//	end
//	
//end

//shape and cordinates calc
always @(posedge ADDR) begin
	mat_x = ref_x/block_size;
	mat_y = ref_y/block_size;
	exc_1 = 0;
	exc_2 = 0;
	
	case(shape) 
		4'd0: begin  //square
			xl = ref_x;
			xr = ref_x + block_size*2;
			yu = ref_y;
			yd = ref_y + block_size*2;
			
			cor_1 = mat_y * 32 + mat_x; //top left
			cor_2 = mat_y * 32 + mat_x + 1; //top right
			cor_3 = (mat_y + 1) * 32 + mat_x;  //bottom left
			cor_4 = (mat_y + 1) * 32 + mat_x + 1; //bottom right
			
			cor_stop_1 = (mat_y + 2) * 32 + mat_x;  //next hit
			cor_stop_2 = (mat_y + 2) * 32 + mat_x + 1;
			cor_stop_3 = 0;
			cor_stop_4 = 0;
			
			cor_hit_left_1 = cor_1 - 1;
			cor_hit_left_2 = cor_3 - 1;
			cor_hit_left_3 = 0;
			cor_hit_left_4 = 0;
			cor_hit_right_1 = cor_2 + 1;
			cor_hit_right_2 = cor_4 + 1;
			cor_hit_right_3 = 0;
			cor_hit_right_4 = 0;
		end
	
		4'd1: begin  //long hori rectangle
			xl = ref_x;
			xr = ref_x + 4*block_size;
			yu = ref_y;
			yd = ref_y + block_size;
			cor_1 = mat_y * 32 + mat_x;
			cor_2 = mat_y * 32 + mat_x + 1;
			cor_3 = mat_y * 32 + mat_x + 2;
			cor_4 = mat_y * 32 + mat_x + 3;
			cor_stop_1 = (mat_y + 1) * 32 + mat_x;  //next hit
			cor_stop_2 = (mat_y + 1) * 32 + mat_x + 1;
			cor_stop_3 = (mat_y + 1) * 32 + mat_x + 2;
			cor_stop_4 = (mat_y + 1) * 32 + mat_x + 3;
			
			cor_hit_left_1 = cor_1 - 1;
			cor_hit_left_2 = 0;
			cor_hit_left_3 = 0;
			cor_hit_left_4 = 0;
			cor_hit_right_1 = cor_4 + 1;
			cor_hit_right_2 = 0;
			cor_hit_right_3 = 0;
			cor_hit_right_4 = 0;	
		end
		
		4'd2: begin  //long vert rectangle
			xl = ref_x;
			xr = ref_x + block_size;
			yu = ref_y;
			yd = ref_y + 4*block_size;
			cor_1 = mat_y * 32 + mat_x;
			cor_2 = (mat_y+1) * 32 + mat_x;
			cor_3 = (mat_y+2) * 32 + mat_x;
			cor_4 = (mat_y+3) * 32 + mat_x;
			cor_stop_1 = 0;  //next hit
			cor_stop_2 = 0;
			cor_stop_3 = 0;
			cor_stop_4 = (mat_y + 4) * 32 + mat_x;
			
			cor_hit_left_1 = cor_1 - 1;
			cor_hit_left_2 = cor_2 - 1;
			cor_hit_left_3 = cor_3 - 1;
			cor_hit_left_4 = cor_4 - 1;
			cor_hit_right_1 = cor_1 + 1;
			cor_hit_right_2 = cor_2 + 1;
			cor_hit_right_3 = cor_3 + 1;
			cor_hit_right_4 = cor_4 + 1;
		
		end
		
		4'd3: begin  // one up center, three down a row
			xl = ref_x - block_size;
			xr = ref_x + 2*block_size;
			yu = ref_y;
			yd = ref_y + 2*block_size;
			cor_1 = mat_y * 32 + mat_x;
			cor_2 = (mat_y+1) * 32 + mat_x - 1;
			cor_3 = (mat_y+1) * 32 + mat_x;
			cor_4 = (mat_y+1) * 32 + mat_x + 1;
			exc_1 = cor_1 - 1;
			exc_2 = cor_1 + 1;
			
			cor_stop_1 = 0; 
			cor_stop_2 = (mat_y+2) * 32 + mat_x - 1;
			cor_stop_3 = (mat_y+2) * 32 + mat_x;
			cor_stop_4 = (mat_y+2) * 32 + mat_x + 1;
			
			cor_hit_left_1 = cor_1 - 1;
			cor_hit_left_2 = cor_2 - 1;
			cor_hit_left_3 = 0;
			cor_hit_left_4 = 0;
			cor_hit_right_1 = cor_1 + 1;
			cor_hit_right_2 = 0;
			cor_hit_right_3 = 0;
			cor_hit_right_4 = cor_4 + 1;
		end
		
		4'd4: begin
			xl = ref_x;
			xr = ref_x + 2*block_size;
			yu = ref_y;
			yd = ref_y + 3*block_size;
			cor_1 = mat_y * 32 + mat_x;
			cor_2 = (mat_y+1) * 32 + mat_x;
			cor_3 = (mat_y+1) * 32 + mat_x + 1;
			cor_4 = (mat_y+2) * 32 + mat_x;
			exc_1 = cor_1 + 1;
			exc_2 = cor_4 + 1;
			
			cor_stop_1 = 0; 
			cor_stop_2 = 0;
			cor_stop_3 = (mat_y+2) * 32 + mat_x + 1;
			cor_stop_4 = (mat_y+3) * 32 + mat_x;
			
			cor_hit_left_1 = cor_1 - 1;
			cor_hit_left_2 = cor_2 - 1;
			cor_hit_left_3 = 0;
			cor_hit_left_4 = cor_4 - 1;
			cor_hit_right_1 = cor_1 + 1;
			cor_hit_right_2 = 0;
			cor_hit_right_3 = cor_3 + 1;
			cor_hit_right_4 = cor_4 + 1;
		end
		
		4'd5: begin
			xl = ref_x;
			xr = ref_x + 3*block_size;
			yu = ref_y;
			yd = ref_y + 2*block_size;
			cor_1 = mat_y * 32 + mat_x;
			cor_2 = cor_1 + 1;
			cor_3 = cor_2 + 1;
			cor_4 = (mat_y+1) * 32 + mat_x + 1;
			exc_1 = cor_4 - 1;
			exc_2 = cor_4 + 1;
			
			cor_stop_1 = exc_1; 
			cor_stop_2 = 0;
			cor_stop_3 = exc_2;
			cor_stop_4 = (mat_y+2) * 32 + mat_x + 1;
			
			cor_hit_left_1 = cor_1 - 1;
			cor_hit_left_2 = 0;
			cor_hit_left_3 = 0;
			cor_hit_left_4 = cor_4 - 1;
			cor_hit_right_1 = 0;
			cor_hit_right_2 = 0;
			cor_hit_right_3 = cor_3 + 1;
			cor_hit_right_4 = cor_4 + 1;
		end
		
		4'd6: begin
			xl = ref_x - block_size;
			xr = ref_x + block_size;
			yu = ref_y;
			yd = ref_y + 3*block_size;
			cor_1 = mat_y * 32 + mat_x;
			cor_2 = (mat_y+1)*32 + mat_x - 1;
			cor_3 = cor_2 + 1;
			cor_4 = (mat_y+2) * 32 + mat_x;
			exc_1 = cor_1 - 1;
			exc_2 = cor_4 - 1;
			
			cor_stop_1 = 0; 
			cor_stop_2 = exc_2;
			cor_stop_3 = 0;
			cor_stop_4 = (mat_y+3)*32 + mat_x;
			
			cor_hit_left_1 = cor_1 - 1;
			cor_hit_left_2 = cor_2 - 1;
			cor_hit_left_3 = 0;
			cor_hit_left_4 = cor_4 - 1;
			
			cor_hit_right_1 = cor_1 + 1;
			cor_hit_right_2 = 0;
			cor_hit_right_3 = cor_3 + 1;
			cor_hit_right_4 = cor_4 + 1;
		end
		
		4'd7: begin
			xl = ref_x;
			xr = ref_x + 2*block_size;
			yu = ref_y;
			yd = ref_y + 3*block_size;
			cor_1 = mat_y * 32 + mat_x;
			cor_2 = (mat_y+1)*32 + mat_x;
			cor_3 = (mat_y+2)*32 + mat_x;
			cor_4 = cor_3 + 1;
			exc_1 = cor_1 + 1;
			exc_2 = cor_2 + 1;
			
			cor_stop_1 = 0; 
			cor_stop_2 = 0;
			cor_stop_3 = (mat_y+3)*32 + mat_x;
			cor_stop_4 = cor_stop_3 + 1;
			
			cor_hit_left_1 = cor_1 - 1;
			cor_hit_left_2 = cor_2 - 1;
			cor_hit_left_3 = cor_3 - 1;
			cor_hit_left_4 = 0;
			
			cor_hit_right_1 = cor_1 + 1;
			cor_hit_right_2 = cor_2 + 1;
			cor_hit_right_3 = 0;
			cor_hit_right_4 = cor_4 + 1;
		end
		
		4'd8: begin
			xl = ref_x;
			xr = ref_x + 3*block_size;
			yu = ref_y;
			yd = ref_y + 2*block_size;
			cor_1 = mat_y * 32 + mat_x;
			cor_2 = cor_1 + 1;
			cor_3 = cor_2 + 1;
			cor_4 = (mat_y+1) * 32 + mat_x;
			
			exc_1 = cor_4 + 1;
			exc_2 = cor_4 + 2;
			
			cor_stop_1 = 0; 
			cor_stop_2 = cor_4 + 1;
			cor_stop_3 = cor_4 + 2;
			cor_stop_4 = (mat_y+2) * 32 + mat_x;
			
			cor_hit_left_1 = cor_1 - 1;
			cor_hit_left_2 = 0;
			cor_hit_left_3 = 0;
			cor_hit_left_4 = cor_4 - 1;
			
			cor_hit_right_1 = 0;
			cor_hit_right_2 = 0;
			cor_hit_right_3 = cor_3 + 1;
			cor_hit_right_4 = cor_4 + 1;
		end
		
		4'd9: begin
			xl = ref_x;
			xr = ref_x + 2*block_size;
			yu = ref_y;
			yd = ref_y + 3*block_size;
			cor_1 = mat_y * 32 + mat_x;
			cor_2 = cor_1 + 1;
			cor_3 = (mat_y+1)*32 + mat_x + 1;
			cor_4 = (mat_y+2)*32 + mat_x + 1;
			
			exc_1 = cor_3 - 1;
			exc_2 = cor_4 - 1;
			
			cor_stop_1 = cor_3 - 1; 
			cor_stop_2 = 0;
			cor_stop_3 = 0;
			cor_stop_4 = (mat_y+3) * 32 + mat_x + 1;
			
			cor_hit_left_1 = cor_1 - 1;
			cor_hit_left_2 = cor_3 - 1;
			cor_hit_left_3 = 0;
			cor_hit_left_4 = cor_4 - 1;
			
			cor_hit_right_1 = 0;
			cor_hit_right_2 = cor_2 + 1;
			cor_hit_right_3 = cor_3 + 1;
			cor_hit_right_4 = cor_4 + 1;
		end
		
		4'd10: begin
			xl = ref_x - 2*block_size;
			xr = ref_x + block_size;
			yu = ref_y;
			yd = ref_y + 2*block_size;
			cor_1 = mat_y * 32 + mat_x;
			cor_2 = (mat_y+1)*32 + mat_x - 2;
			cor_3 = cor_2 + 1;
			cor_4 = cor_3 + 1;
			
			exc_1 = cor_1 - 2;
			exc_2 = cor_1 - 1;
			
			cor_stop_1 = 0; 
			cor_stop_2 = (mat_y+2)*32 + mat_x - 2;
			cor_stop_3 = (mat_y+2)*32 + mat_x - 1;
			cor_stop_4 = (mat_y+2)*32 + mat_x;
			
			cor_hit_left_1 = cor_1 - 1;
			cor_hit_left_2 = cor_2 - 1;
			cor_hit_left_3 = 0;
			cor_hit_left_4 = 0;
			
			cor_hit_right_1 = cor_1 + 1;
			cor_hit_right_2 = 0;
			cor_hit_right_3 = 0;
			cor_hit_right_4 = cor_4 + 1;
		end
		
		4'd11: begin
			xl = ref_x;
			xr = ref_x + 2*block_size;
			yu = ref_y;
			yd = ref_y + 3*block_size;
			cor_1 = mat_y * 32 + mat_x;
			cor_2 = (mat_y+1)*32 + mat_x;
			cor_3 = cor_2 + 1;
			cor_4 = (mat_y+2)*32 + mat_x + 1;
			
			exc_1 = cor_1 + 1;
			exc_2 = cor_4 - 1;
			
			cor_stop_1 = 0; 
			cor_stop_2 = cor_4 - 1;
			cor_stop_3 = 0;
			cor_stop_4 = (mat_y+3)*32 + mat_x + 1;
			
			cor_hit_left_1 = cor_1 - 1;
			cor_hit_left_2 = cor_2 - 1;
			cor_hit_left_3 = 0;
			cor_hit_left_4 = cor_4 - 1;
			
			cor_hit_right_1 = cor_1 + 1;
			cor_hit_right_2 = 0;
			cor_hit_right_3 = cor_3 + 1;
			cor_hit_right_4 = cor_4 + 1;
		end
		
		4'd12: begin
			xl = ref_x - block_size;
			xr = ref_x + 2*block_size;
			yu = ref_y;
			yd = ref_y + 2*block_size;
			cor_1 = mat_y * 32 + mat_x;
			cor_2 = cor_1 + 1;
			cor_3 = (mat_y+1)*32 + mat_x - 1;
			cor_4 = cor_3 + 1;
			
			exc_1 = cor_1 - 1;
			exc_2 = cor_4 + 1;
			
			cor_stop_1 = 0; 
			cor_stop_2 = cor_4 + 1;
			cor_stop_3 = (mat_y+2)*32 + mat_x - 1;
			cor_stop_4 = (mat_y+2)*32 + mat_x;
			
			cor_hit_left_1 = cor_1 - 1;
			cor_hit_left_2 = 0;
			cor_hit_left_3 = cor_3 - 1;
			cor_hit_left_4 = 0;
			
			cor_hit_right_1 = 0;
			cor_hit_right_2 = cor_2 + 1;
			cor_hit_right_3 = 0;
			cor_hit_right_4 = cor_4 + 1;
		end
		
		4'd13: begin
			xl = ref_x - block_size;
			xr = ref_x + block_size;
			yu = ref_y;
			yd = ref_y + 3*block_size;
			
			cor_1 = mat_y * 32 + mat_x;
			cor_2 = (mat_y+1) * 32 + mat_x - 1;
			cor_3 = cor_2 + 1;
			cor_4 = (mat_y+2) * 32 + mat_x - 1;
			
			exc_1 = cor_1 - 1;
			exc_2 = cor_4 + 1;
			
			cor_stop_1 = 0; 
			cor_stop_2 = 0;
			cor_stop_3 = cor_4 + 1;
			cor_stop_4 = (mat_y+3) * 32 + mat_x - 1;
			
			cor_hit_left_1 = cor_1 - 1;
			cor_hit_left_2 = cor_2 - 1;
			cor_hit_left_3 = 0;
			cor_hit_left_4 = cor_4 - 1;
			
			cor_hit_right_1 = cor_1 + 1;
			cor_hit_right_2 = 0;
			cor_hit_right_3 = cor_3 + 1;
			cor_hit_right_4 = cor_4 + 1;
		end
		
		default: begin //shape 14
			xl = ref_x;
			xr = ref_x + 3*block_size;
			yu = ref_y;
			yd = ref_y + 2*block_size;
			
			cor_1 = mat_y * 32 + mat_x;
			cor_2 = cor_1 + 1;
			cor_3 = (mat_y+1) * 32 + mat_x + 1;
			cor_4 = cor_3 + 1;
			
			exc_1 = cor_2 + 1;
			exc_2 = cor_3 - 1;
			
			cor_stop_1 = cor_3 - 1; 
			cor_stop_2 = 0;
			cor_stop_3 = (mat_y+2) * 32 + mat_x + 1;
			cor_stop_4 = (mat_y+2) * 32 + mat_x + 2;
			
			cor_hit_left_1 = cor_1 - 1;
			cor_hit_left_2 = 0;
			cor_hit_left_3 = cor_3 - 1;
			cor_hit_left_4 = 0;
			
			cor_hit_right_1 = 0;
			cor_hit_right_2 = cor_2 + 1;
			cor_hit_right_3 = 0;
			cor_hit_right_4 = cor_4 + 1;
		end
	
	endcase
end
	
		integer i, j, k;
//stop logic
always @(posedge ADDR) begin
		if(exist[cor_stop_1]!=0 || exist[cor_stop_2]!=0 || 
				exist[cor_stop_3]!=0 || exist[cor_stop_4]!=0) 
		begin
			stop = 1'b1;
			exist[cor_1] = 1'b1;
			exist[cor_2] = 1'b1;
			exist[cor_3] = 1'b1;
			exist[cor_4] = 1'b1;
		end
		else if(yd >= (vert_size - 1)) begin 
			stop = 1'b1;
			exist[cor_1] = 1'b1;
			exist[cor_2] = 1'b1;
			exist[cor_3] = 1'b1;
			exist[cor_4] = 1'b1;
		end
		else begin
			stop = 0;
		end

		if(stop == 1'b1) begin
			for(i=10; i<24; i=i+1) begin
				if((exist[i*32] & exist[i*32+1] & exist[i*32+2] & exist[i*32+3] &
					exist[i*32+4] & exist[i*32+5] & exist[i*32+6] & exist[i*32+7] &
					exist[i*32+8] & exist[i*32+9] & exist[i*32+10] & exist[i*32+11] &
					exist[i*32+12] & exist[i*32+13] & exist[i*32+14] & exist[i*32+15] &
					exist[i*32+16] & exist[i*32+17] & exist[i*32+18] & exist[i*32+19] &
					exist[i*32+20] & exist[i*32+21] & exist[i*32+22] & exist[i*32+23] ) == 1)
					begin
						clear = 1;
					end
				else clear = 0;
			end
		end
		if(clear == 1) begin
			score = score + 1;
			stop = 0;
			for(i=23; i>9; i=i-1) begin
				for(j=0; j<24; j=j+1) begin
					exist[i*32+j] = exist[(i-1)*32 + j];
				end
			end
		end
		
		if(start_over == 1) begin
			exist = 768'b0;
			score = 0;
		end
		
		case (score) 
			32'd0: begin
				exist[2*32 + 27] = 1'b1;
				exist[2*32 + 28] = 1'b1;
				exist[2*32 + 29] = 1'b1;
				exist[2*32 + 30] = 1'b1;
				
				exist[3*32 + 27] = 1'b1;
				exist[3*32 + 30] = 1'b1;
				
				exist[4*32 + 27] = 1'b1;
				exist[4*32 + 28] = 1'b0;
				exist[4*32 + 29] = 1'b0;
				exist[4*32 + 30] = 1'b1;
				
				exist[5*32 + 27] = 1'b1;
				exist[5*32 + 30] = 1'b1;
				
				exist[6*32 + 27] = 1'b1;
				exist[6*32 + 28] = 1'b1;
				exist[6*32 + 29] = 1'b1;
				exist[6*32 + 30] = 1'b1;
			end
			
			32'd1: begin
				exist[2*32 + 27] = 1'b1;
				exist[2*32 + 28] = 1'b0;
				exist[2*32 + 29] = 1'b0;
				exist[2*32 + 30] = 1'b0;
				
				exist[3*32 + 27] = 1'b1;
				exist[3*32 + 30] = 1'b0;
				
				exist[4*32 + 27] = 1'b1;
				exist[4*32 + 28] = 1'b0;
				exist[4*32 + 29] = 1'b0;
				exist[4*32 + 30] = 1'b0;
				
				exist[5*32 + 27] = 1'b1;
				exist[5*32 + 30] = 1'b0;
				
				exist[6*32 + 27] = 1'b1;
				exist[6*32 + 28] = 1'b0;
				exist[6*32 + 29] = 1'b0;
				exist[6*32 + 30] = 1'b0;
			end
			
			32'd2: begin
				exist[2*32 + 27] = 1'b1;
				exist[2*32 + 28] = 1'b1;
				exist[2*32 + 29] = 1'b1;
				exist[2*32 + 30] = 1'b1;
				
				exist[3*32 + 27] = 1'b0;
				exist[3*32 + 30] = 1'b1;
				
				exist[4*32 + 27] = 1'b1;
				exist[4*32 + 28] = 1'b1;
				exist[4*32 + 29] = 1'b1;
				exist[4*32 + 30] = 1'b1;
				
				exist[5*32 + 27] = 1'b1;
				exist[5*32 + 30] = 1'b0;
				
				exist[6*32 + 27] = 1'b1;
				exist[6*32 + 28] = 1'b1;
				exist[6*32 + 29] = 1'b1;
				exist[6*32 + 30] = 1'b1;
			end
			
			32'd3: begin
				exist[2*32 + 27] = 1'b1;
				exist[2*32 + 28] = 1'b1;
				exist[2*32 + 29] = 1'b1;
				exist[2*32 + 30] = 1'b1;
				
				exist[3*32 + 27] = 1'b0;
				exist[3*32 + 30] = 1'b1;
				
				exist[4*32 + 27] = 1'b1;
				exist[4*32 + 28] = 1'b1;
				exist[4*32 + 29] = 1'b1;
				exist[4*32 + 30] = 1'b1;
				
				exist[5*32 + 27] = 1'b0;
				exist[5*32 + 30] = 1'b1;
				
				exist[6*32 + 27] = 1'b1;
				exist[6*32 + 28] = 1'b1;
				exist[6*32 + 29] = 1'b1;
				exist[6*32 + 30] = 1'b1;
			end
			
			32'd4: begin
				exist[2*32 + 27] = 1'b1;
				exist[2*32 + 28] = 1'b0;
				exist[2*32 + 29] = 1'b0;
				exist[2*32 + 30] = 1'b1;
				
				exist[3*32 + 27] = 1'b1;
				exist[3*32 + 30] = 1'b1;
				
				exist[4*32 + 27] = 1'b1;
				exist[4*32 + 28] = 1'b1;
				exist[4*32 + 29] = 1'b1;
				exist[4*32 + 30] = 1'b1;
				
				exist[5*32 + 27] = 1'b0;
				exist[5*32 + 30] = 1'b1;
				
				exist[6*32 + 27] = 1'b0;
				exist[6*32 + 28] = 1'b0;
				exist[6*32 + 29] = 1'b0;
				exist[6*32 + 30] = 1'b1;
			end
			
			32'd5: begin
				exist[2*32 + 27] = 1'b1;
				exist[2*32 + 28] = 1'b1;
				exist[2*32 + 29] = 1'b1;
				exist[2*32 + 30] = 1'b1;
				
				exist[3*32 + 27] = 1'b1;
				exist[3*32 + 30] = 1'b0;
				
				exist[4*32 + 27] = 1'b1;
				exist[4*32 + 28] = 1'b1;
				exist[4*32 + 29] = 1'b1;
				exist[4*32 + 30] = 1'b1;
				
				exist[5*32 + 27] = 1'b0;
				exist[5*32 + 30] = 1'b1;
				
				exist[6*32 + 27] = 1'b1;
				exist[6*32 + 28] = 1'b1;
				exist[6*32 + 29] = 1'b1;
				exist[6*32 + 30] = 1'b1;
			end
			
			32'd6: begin
				exist[2*32 + 27] = 1'b1;
				exist[2*32 + 28] = 1'b1;
				exist[2*32 + 29] = 1'b1;
				exist[2*32 + 30] = 1'b1;
				
				exist[3*32 + 27] = 1'b1;
				exist[3*32 + 30] = 1'b0;
				
				exist[4*32 + 27] = 1'b1;
				exist[4*32 + 28] = 1'b1;
				exist[4*32 + 29] = 1'b1;
				exist[4*32 + 30] = 1'b1;
				
				exist[5*32 + 27] = 1'b1;
				exist[5*32 + 30] = 1'b1;
				
				exist[6*32 + 27] = 1'b1;
				exist[6*32 + 28] = 1'b1;
				exist[6*32 + 29] = 1'b1;
				exist[6*32 + 30] = 1'b1;
			end
			
			32'd7: begin
				exist[2*32 + 27] = 1'b1;
				exist[2*32 + 28] = 1'b1;
				exist[2*32 + 29] = 1'b1;
				exist[2*32 + 30] = 1'b1;
				
				exist[3*32 + 27] = 1'b0;
				exist[3*32 + 30] = 1'b1;
				
				exist[4*32 + 27] = 1'b0;
				exist[4*32 + 28] = 1'b0;
				exist[4*32 + 29] = 1'b0;
				exist[4*32 + 30] = 1'b1;
				
				exist[5*32 + 27] = 1'b0;
				exist[5*32 + 30] = 1'b1;
				
				exist[6*32 + 27] = 1'b0;
				exist[6*32 + 28] = 1'b0;
				exist[6*32 + 29] = 1'b0;
				exist[6*32 + 30] = 1'b1;
			end
			
			32'd8: begin
				exist[2*32 + 27] = 1'b1;
				exist[2*32 + 28] = 1'b1;
				exist[2*32 + 29] = 1'b1;
				exist[2*32 + 30] = 1'b1;
				
				exist[3*32 + 27] = 1'b1;
				exist[3*32 + 30] = 1'b1;
				
				exist[4*32 + 27] = 1'b1;
				exist[4*32 + 28] = 1'b1;
				exist[4*32 + 29] = 1'b1;
				exist[4*32 + 30] = 1'b1;
				
				exist[5*32 + 27] = 1'b1;
				exist[5*32 + 30] = 1'b1;
				
				exist[6*32 + 27] = 1'b1;
				exist[6*32 + 28] = 1'b1;
				exist[6*32 + 29] = 1'b1;
				exist[6*32 + 30] = 1'b1;
			end
			
			default: begin
				exist[2*32 + 27] = 1'b1;
				exist[2*32 + 28] = 1'b1;
				exist[2*32 + 29] = 1'b1;
				exist[2*32 + 30] = 1'b1;
				
				exist[3*32 + 27] = 1'b1;
				exist[3*32 + 30] = 1'b1;
				
				exist[4*32 + 27] = 1'b1;
				exist[4*32 + 28] = 1'b1;
				exist[4*32 + 29] = 1'b1;
				exist[4*32 + 30] = 1'b1;
				
				exist[5*32 + 27] = 1'b0;
				exist[5*32 + 30] = 1'b1;
				
				exist[6*32 + 27] = 1'b1;
				exist[6*32 + 28] = 1'b1;
				exist[6*32 + 29] = 1'b1;
				exist[6*32 + 30] = 1'b1;	
			end
		endcase
end

//hit logic
always @(posedge ADDR) begin
	if ((exist[cor_hit_left_1]!=0) || (exist[cor_hit_left_2]!=0) ||
			(exist[cor_hit_left_3]!=0) || (exist[cor_hit_left_4]!=0))
	begin 
		hit = 1;
	end
	
	else if((exist[cor_hit_right_1]!=0) || (exist[cor_hit_right_2]!=0) ||
		 (exist[cor_hit_right_3]!=0) || (exist[cor_hit_right_4]!=0)) 
	begin
		hit = 1;
	end
	
	else hit = 0;	
end



//shape change logic
//always @(posedge ADDR) begin
//	if(ref_x == 10'd280 && ref_y == 0) begin
//			case(shape)
//				4'd0: shape = 4'd1;
//				4'd1: shape = 4'd2;
//				4'd2: shape = 4'd3;
//				4'd3: shape = 4'd4;
//				4'd4: shape = 4'd5;
//				4'd5: shape = 4'd6;
//				4'd6: shape = 4'd7;
//				4'd7: shape = 4'd8;
//				4'd8: shape = 4'd9;
//				4'd9: shape = 4'd10;
//				4'd10: shape = 4'd11;
//				4'd11: shape = 4'd12;
//				4'd12: shape = 4'd13;
//				4'd13: shape = 4'd14;
//				4'd14: shape = 4'd0;
//				default: shape = 4'd0;
//			endcase
//	end
//	else if (change_shape == 1) begin
//		case(shape)
//			4'd0: shape = 4'd0;
//			4'd1: shape = 4'd2;
//			4'd2: shape = 4'd1;
//			4'd3: shape = 4'd4;
//			4'd4: shape = 4'd5;
//			4'd5: shape = 4'd6;
//			4'd6: shape = 4'd3;
//			4'd7: shape = 4'd8;
//			4'd8: shape = 4'd9;
//			4'd9: shape = 4'd10;
//			4'd10: shape = 4'd7;
//			4'd11: shape = 4'd12;
//			4'd12: shape = 4'd11;
//			4'd13: shape = 4'd14;
//			4'd14: shape = 4'd13;
//			default: shape = shape;
//		endcase
//	end
//end



//display logic
always @(ADDR) begin
	x = ADDR%640;
	y = ADDR/640;
	print_x = x/20;
	print_y = y/20;
	print_cor = print_y * 32 + print_x; //display blocks or background
	
	if (exist[print_cor] != 1'b0) sel = 1;
	else if(x>xl && x<xr && y>yu && y<yd && print_cor!=exc_1 && print_cor!=exc_2) sel = 1; //current block ref points
	else if(x > 480 && x < 500) sel = 1;
	else sel = 0;
end

endmodule
