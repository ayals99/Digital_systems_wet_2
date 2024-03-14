// 32X32 Multiplier FSM
module mult32x32_fast_fsm (
    input logic clk,              // Clock
    input logic reset,            // Reset
    input logic start,            // Start signal
    input logic a_msb_is_0,       // Indicates MSB of operand A is 0
    input logic b_msw_is_0,       // Indicates MSW of operand B is 0
    output logic busy,            // Multiplier busy indication
    output logic [1:0] a_sel,     // Select one byte from A
    output logic b_sel,           // Select one 2-byte word from B
    output logic [2:0] shift_sel, // Select output from shifters
    output logic upd_prod,        // Update the product register
    output logic clr_prod         // Clear the product register
);

// Put your code here
// ------------------
typedef enum  {idle_st, A1B1, A2B1, A3B1, A4B1, A1B2, A2B2, A3B2, A4B2} sm_type;

sm_type current_state;
sm_type next_state;

always_ff @(posedge clk, posedge reset) begin
    if (reset == 1'b1) begin
        current_state <= idle_st;        
    end
    else begin
        current_state <= next_state;
    end
    
end




// End of your code

endmodule
