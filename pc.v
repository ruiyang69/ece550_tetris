module pc(q, d, clk, en, clr);
   
   //Inputs
   input  clk, en, clr;
	input [31:0] d;
   
   //Internal wire
   wire clr;

   //Output
   output [31:0] q;
   
   //Register
   reg [31:0] q;

   //Intialize q to 0
   initial
   begin
       q = 32'b0;
   end
	
   always @(posedge clk or posedge clr) begin
       //If clear is high, set q to 0
       if (clr) begin
           q <= 32'b0;
       //If enable is high, set q to the value of d
       end else if (en) begin
           q <= d;
       end
   end
endmodule
