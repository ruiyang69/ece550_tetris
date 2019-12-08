module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
							 up,
							 left,
							 down,
							 right,
							 ref_x,
							 ref_y,
							 stop,
							 hit,
							 shape,
							 change_shape,
							 start_over,
							 clear,
							 fall_down_clk,
							 ADDR
							 );

	
input iRST_n;
input iVGA_CLK, fall_down_clk;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;


//recitation 6 inputs & variables
input up, left, down, right, change_shape, start_over;  
output stop, hit, clear;
input [31:0] shape;

input [9:0] ref_x;
input [9:0] ref_y;


///////// ////                     
output reg [18:0] ADDR;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;
////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));
////
////Addresss generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end
//////////////////////////
//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;
img_data	img_data_inst (
	.address ( ADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);
	
/////////////////////////
//////Add switch-input logic here
wire sel;
color_mux color_mux(
	.iVGA_CLK(iVGA_CLK),
	.ref_x(ref_x),
	.ref_y(ref_y),
	.ADDR(ADDR),
	.sel(sel),
	.stop(stop),
	.hit(hit),
	.shape(shape),
	.change_shape(change_shape),
	.start_over(start_over),
	.clear(clear),
	.fall_down_clk(fall_down_clk)
	);
	
//////Color table output
img_index	img_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw)
	);	
//////
//////latch valid data at falling edge;
always@(posedge VGA_CLK_n)  begin
	if(sel == 0)	bgr_data <= bgr_data_raw;
	else bgr_data <= 24'h0a0b0c;
end
 

assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0];

///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule
 	















