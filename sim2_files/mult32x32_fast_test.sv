// 32X32 Multiplier test template
module mult32x32_fast_test;

    logic clk;            // Clock
    logic reset;          // Reset
    logic start;          // Start signal
    logic [31:0] a;       // Input a
    logic [31:0] b;       // Input b
    logic busy;           // Multiplier busy indication
    logic [63:0] product; // Miltiplication product

// Put your code here
// ------------------
    mult32x32_fast uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .a(a),
        .b(b),
        .busy(busy),
        .product(product)
    );
        always begin
            #5;
            clk = ~clk;
        end 

    initial begin
        // Initialize signals
        clk = 1'b0;
        reset = 1'b1;
        start = 1'b0;
        a = 0;
        b = 0;    

        #40;
        reset = 1'b0;
        a = 32'd208622142;
        b = 32'd316088970;

        #10;
        start = 1'b1;

        #10;
        start = 1'b0;

        #50;        
        //We're now done with the first test
        //In this itiration a_msb_is_0 and b_msw_is_0 should be true

        a = { {16{1'b0}}, a[15:0] };
		b = { {16{1'b0}}, b[15:0] };

		#10
		start = 1'b1;

		#10
		start = 1'b0;

    end

// End of your code

endmodule
