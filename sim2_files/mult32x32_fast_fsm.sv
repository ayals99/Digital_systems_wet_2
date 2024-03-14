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

always_comb begin
    //initializing default values
    next_state = current_state;
    busy = 1'b1;
    a_sel = 2'b00;
    b_sel = 1'b0;
    shift_sel = 3'b000;
    upd_prod = 1'b1;
    clr_prod = 1'b0;

    case (current_state)
        idle_st: begin
            busy = 1'b0;
            upd_prod = 1'b0;
            if (start) begin
                next_state = A1B1;
                clr_prod = 1'b1;
            end
        end

        //Computing the first state
        A1B1: begin
            next_state = A2B1;
            a_sel = 2'b00;
            b_sel = 1'b0;
        end

        //Computing the second state
        A2B1: begin
            next_state = A3B1;
            a_sel = 2'b01;
            shift_sel = 3'b001;
        end

        //Computing the third state
        //if both new inputs are true after the current caculation we go back to the idle_st
        //if a_msb is true only then we move to state A1B2
        //otherwise we contiue normally
        A3B1: begin
            a_sel = 2'b10;
            shift_sel = 3'b010;
            if (a_msb_is_0) begin
                if (b_msw_is_0) begin
                    next_state = idle_st;
                end
                else begin
                    next_state = A1B2;
                end
            end
            else begin
                next_state = A4B1;
            end        
        end
        
        //computing the fourth state
        //if we got to here it means the a_msb is false which means we only need to check b_msw
        //if m_msw is true we skip to the idle_st otherwise we go to the next state
        A4B1: begin   
            a_sel = 2'b11;
            shift_sel = 3'b011;
            if (b_msw_is_0) begin
                next_state = idle_st;
            end
            else begin
                next_state = A1B2;
            end
        end


        A1B2: begin
            next_state = A2B2;
            a_sel = 2'b00;
            b_sel = 1'b1;
            shift_sel = 3'b010;
        end

        A2B2: begin
            next_state = A3B2;
            a_sel = 2'b01;
            b_sel = 1'b1;
            shift_sel = 3'b011;
        end

        //computing the seventh state
        //if we got here it means that b_msw is false so we shppuld check only a_msb
        //if a_msb is true then we skip the final state and move to idle_st
        //otherwise we continue to the final state before idle
        A3B2: begin
            a_sel = 2'b10;
            b_sel = 1'b1;
            shift_sel = 3'b100; 
            if (a_msb_is_0) begin 
                next_state = idle_st;
            end
            else begin
                next_state = A4B2;            
            end
        end

        A4B2: begin
            next_state = idle_st;
            a_sel = 2'b11;
            b_sel = 1'b1;
            shift_sel = 3'b101;
        end  

    endcase
end
// End of your code
endmodule
