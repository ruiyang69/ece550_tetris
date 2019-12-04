module color_mux(iVGA_CLK, ref_x, ref_y, ADDR, sel, stop, hit, shape, change_shape, reset_ack);

//inputs outputs
input [9:0] ref_x, ref_y;
input [18:0] ADDR;
input iVGA_CLK, change_shape, reset_ack;

output reg sel, stop, hit;
output reg [2:0] shape;


//local variable
reg [31:0] xl, xr, yu, yd, x, y, print_x, print_y, mat_x, mat_y;
reg [31:0] cor_1, cor_2, cor_3, cor_4;
reg [31:0] cor_stop_1, cor_stop_2, cor_stop_3, cor_stop_4; 
reg [31:0] cor_hit_left_1, cor_hit_left_2, cor_hit_left_3, cor_hit_left_4;
reg [31:0] cor_hit_right_1, cor_hit_right_2, cor_hit_right_3, cor_hit_right_4, print_cor;

reg [767:0] exist;
reg [31:0] count;
reg [31:0] score;
reg [31:0] block_size, hori_size, vert_size;

reg clock_by_2;

//initial block
initial begin
	exist = 768'b0;
	stop = 0;
	hit = 0;
	score = 0;
	shape = 3'd0;
	clock_by_2 = 0;
	block_size = 32'd20;
	hori_size = 32'd640;
	vert_size = 32'd480;
end

//clock divider
always @(posedge iVGA_CLK) begin
	count <= count + 1;
	if(count >= 100) begin
		count <= 0;
		clock_by_2 = !clock_by_2;
	end
	
end

//shape and cordinates calc
always @(posedge iVGA_CLK) begin
	x = ADDR%hori_size;
	y = ADDR/hori_size;
	print_x = x/block_size;
	print_y = y/block_size;
	print_cor = print_y * 32 + print_x; //display blocks or background
	mat_x = ref_x/block_size;
	mat_y = ref_y/block_size;
	
	case(shape) 
		3'd0: begin  //square
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
	
		3'd1: begin  //long hori rectangle
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
		
		3'd2: begin  //long vert rectangle
			xl = ref_x;
			xr = ref_x + block_size;
			yu = ref_y;
			yd = ref_y + 4*block_size;
			cor_1 = mat_y * 16 + mat_x;
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
		
		3'd3:;
		
		3'd4:;
		
		default:;
	
	endcase
end
	
		integer i, j;
//stop logic
always @(posedge iVGA_CLK) begin
		if(exist[cor_stop_1]!=0 || exist[cor_stop_2]!=0 || 
				exist[cor_stop_3]!=0 || exist[cor_stop_4]!=0) 
		begin
			stop <= 1'b1;
			exist[cor_1] <= 1'b1;
			exist[cor_2] <= 1'b1;
			exist[cor_3] <= 1'b1;
			exist[cor_4] <= 1'b1;
		end
		else if(yd >= (vert_size - 1)) begin 
			stop <= 1'b1;
			exist[cor_1] <= 1'b1;
			exist[cor_2] <= 1'b1;
			exist[cor_3] <= 1'b1;
			exist[cor_4] <= 1'b1;
		end
		else begin
			stop <= 0;
		end

		if(stop == 1'b1) begin
			for(i=10; i<24; i=i+1) begin
				if((exist[i*32] & exist[i*32+1] & exist[i*32+2] & exist[i*32+3] &
					exist[i*32+4] & exist[i*32+5] & exist[i*32+6] & exist[i*32+7] &
					exist[i*32+8] & exist[i*32+9] & exist[i*32+10] & exist[i*32+11] &
					exist[i*32+12] & exist[i*32+13] & exist[i*32+14] & exist[i*32+15] &
					exist[i*32+16] & exist[i*32+17] & exist[i*32+18] & exist[i*32+19] &
					exist[i*32+20] & exist[i*32+21] & exist[i*32+22] & exist[i*32+23] &
					exist[i*32+24] & exist[i*32+25] & exist[i*32+26] & exist[i*32+27] &
					exist[i*32+28] & exist[i*32+29] & exist[i*32+30] & exist[i*32+31]) == 1)
					begin
						for(j=0; j<32; j=j+1) begin
							exist[i*32+j] <= 1'b0;
						end
					end
				end
		end
end

//hit logic
always @(posedge iVGA_CLK) begin
	if ((ref_x<block_size) || (exist[cor_hit_left_1]!=0) || (exist[cor_hit_left_2]!=0) ||
			(exist[cor_hit_left_3]!=0) || (exist[cor_hit_left_4]!=0))
	begin 
		hit = 1;
	end
	
	else if((ref_y > (hori_size -1)) || (exist[cor_hit_right_1]!=0) || (exist[cor_hit_right_2]!=0) ||
		 (exist[cor_hit_right_3]!=0) || (exist[cor_hit_right_4]!=0)) 
	begin
		hit = 1;
	end
	
	else hit = 0;	
end

//display logic
always @(ADDR) begin
	if (exist[print_cor] != 1'b0) sel <= 1;
	//else if(exist[print_cor] == 1'b0) sel <= 0;
	else if(x> xl && x<xr && y >yu && y<yd) sel <= 1; //current block ref points
	else sel <= 0;
end

//shape change logic
always @(posedge clock_by_2) begin
	if(ref_x == 10'd280 && ref_y == 0) begin
			case(shape)
				3'd0: shape = 3'd1;
				3'd1: shape = 3'd2;
				3'd2: shape = 3'd0;
				default: shape = 3'd0;
			endcase
	end
end


endmodule
