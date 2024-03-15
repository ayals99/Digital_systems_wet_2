// 32X32 Multiplier arithmetic unit template
module mult32x32_fast_arith (
    input logic clk,             // Clock
    input logic reset,           // Reset
    input logic [31:0] a,        // Input a
    input logic [31:0] b,        // Input b
    input logic [1:0] a_sel,     // Select one byte from A
    input logic b_sel,           // Select one 2-byte word from B
    input logic [2:0] shift_sel, // Select output from shifters
    input logic upd_prod,        // Update the product register
    input logic clr_prod,        // Clear the product register
    output logic a_msb_is_0,     // Indicates MSB of operand A is 0
    output logic b_msw_is_0,     // Indicates MSW of operand B is 0
    output logic [63:0] product  // Miltiplication product
);

// Put your code here
// ------------------
    // Internal signals in the arith unit
    logic [7:0] selected_byte_a;
    logic [15:0] selected_half_b;
    //A24-bit size for the partial product
    logic [23:0] partial_product_24bit;
    //A temporary value where we put the ouput of the shifts
    logic [63:0] accumulator;

    always_comb begin
        //Determines the value of a_msb_is_0 and b_msw_is_0
        a_msb_is_0 = ~(a[31:24] != 8'b0);
        b_msw_is_0 = ~(b[31:16] != 16'b0);

        //Multiplexers 
        case (a_sel)
            2'b00: selected_byte_a = a[7:0];
            2'b01: selected_byte_a = a[15:8];
            2'b10: selected_byte_a = a[23:16];
            2'b11: selected_byte_a = a[31:24];
        endcase

        //select the half of b depending on the input in b_sel
        selected_half_b = b_sel ? b[31:16] : b[15:0];

        //preform the 16X8 multiplication, and store it the 24-bit pratial product vect
        partial_product_24bit = selected_half_b * selected_byte_a;

        //shift the pratial product depending of the shift_sel input
        case (shift_sel)
            3'b000: accumulator = partial_product_24bit;
            3'b001: accumulator = partial_product_24bit << 8;
            3'b010: accumulator = partial_product_24bit << 16;
            3'b011: accumulator = partial_product_24bit << 24;
            3'b100: accumulator = partial_product_24bit << 32;
            3'b101:accumulator = partial_product_24bit << 40;
            default: accumulator = 0;
        endcase
    end  

    always_ff @(posedge clk, posedge reset) begin
        if (reset || clr_prod) begin
            product <= 64'b0;
        end 
        else if (clr_prod) begin
            product <= 64'b0;        
        end
        else if (upd_prod) begin
        product <= product + accumulator;
        end
    end 
// End of your code
endmodule
