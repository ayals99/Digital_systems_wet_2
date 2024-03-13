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
    //defining our states
    typedef enum {idle_st, A1B1, A2B1, A3B1, A4B1, A1B2, A2B2, A3B2, A4B2} sm_type;kfdasd

    


// End of your code

endmodule
