module four_to_one_mux(sel, a, b, c, d, f);

input [1:0] sel;
input [31:0] a, b, c, d;
output [31:0] f;

wire [31:0] a_or_b, c_or_d;
assign a_or_b = (sel[0]) ? b : a;
assign c_or_d = (sel[0]) ? d : c;
assign f = (sel[1]) ? c_or_d : a_or_b;

endmodule

