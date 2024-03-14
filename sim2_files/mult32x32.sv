// 32X32 Iterative Multiplier template
module mult32x32 (
    input logic clk,            // Clock
    input logic reset,          // Reset
    input logic start,          // Start signal
    input logic [31:0] a,       // Input a
    input logic [31:0] b,       // Input b
    output logic busy,          // Multiplier busy indication
    output logic [63:0] product // Miltiplication product
);

// Put your code here
// ------------------

// inner wires
logic [1:0] a_sel;
logic b_sel, upd_prod, clr_prod;      
logic [2:0] shift_sel;

// creating an instance of the fsm:
mult32x32_fsm  our_fsm(
    .clk(clk),               // Clock
    .reset(reset),           // Reset
    .start(start),           // Start
    .busy(busy),             // Busy
    .a_sel(a_sel),           // Select one byte from A
    .b_sel(b_sel),           // Select one 2-byte word from B
    .shift_sel(shift_sel),   // Select output from shifters
    .upd_prod(upd_prod),     // Update the product register
    .clr_prod(clr_prod)      // Clears the product register  
);

// creating an instance of the 
mult32x32_arith our_arith (
    .clk(clk),               // Clock
    .reset(reset),           // Reset
    .a(a),                   // Input a
    .b(b),                   // Input b
    .a_sel(a_sel),           // Select one byte from A
    .b_sel(b_sel),           // Select one 2-byte word from B
    .shift_sel(shift_sel),   // Select output from shifters
    .upd_prod(upd_prod),     // Update the product register
    .clr_prod(clr_prod),     // Clears the product register  
    .product(product)        // Exits the products
);

// End of your code

endmodule
