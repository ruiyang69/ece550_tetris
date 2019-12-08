module two_to_one_mux(sel, a, b, f);

input sel;
input [31:0] a,b;
output [31:0] f;

assign f = (sel) ? b : a;

endmodule
