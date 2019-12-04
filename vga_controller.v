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
							 x_cor,
							 y_cor,
							 stop,
							 hit,
							 shape,
							 change_shape,
							 reset_ack
							 );

	
input iRST_n;
input iVGA_CLK;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;

input [9:0] x_cor, y_cor;

//recitation 6 inputs & variables
input up, left, down, right, change_shape, reset_ack;  
output stop, hit;
output [2:0] shape;

reg [9:0] ref_x;
reg [9:0] ref_y;


always @(iVGA_CLK) begin
	if (cBLANK_n == 1) begin
		ref_x <= x_cor;
		ref_y <= y_cor;
	end
	else begin
		ref_x <= ref_x;
		ref_y <= ref_y;
	end
	
end


///////// ////                     
reg [18:0] ADDR;
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
	.reset_ack(reset_ack)
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
 	















