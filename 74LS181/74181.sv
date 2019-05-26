module ALU_74181(
    input logic[3:0] a,                 // Operand Inputs (Active HIGH)
    input logic[3:0] b,                 // Operand Inputs (Active HIGH)
    input logic[3:0] select,            // Function Select Inputs
    input bit mode_control,             // Mode Control Input
    input bit carry_in,                 // Carry Input (Active LOW)
    output logic[3:0] function_output,  // Function Outputs (Active HIGH)
    output bit comparator_output,       // Comparator Output
    output bit carry_generate,          // Carry Generate Output (Active HIGH)
    output bit carry_propagate,         // Carry Propagate Output (Active HIGH)
    output bit carry_out                // Carry Output (Active LOW)
);

    logic[4:0] temp_output;
    bit carry_temp;

    always_comb
        begin
            carry_temp = ~carry_in;

            if(mode_control) 
                begin
                    case(select)
                        4'b0000: temp_output = ~a;
                        4'b0001: temp_output = ~a | ~b;
                        4'b0010: temp_output = ~a & b;
                        4'b0011: temp_output = 0;
                        4'b0100: temp_output = ~(a & b);
                        4'b0101: temp_output = ~b;
                        4'b0110: temp_output = a ^ b;
                        4'b0111: temp_output = a & ~b;
                        4'b1000: temp_output = ~a | b;
                        4'b1001: temp_output = ~a ^ ~b;
                        4'b1010: temp_output = b;
                        4'b1011: temp_output = a & b;
                        4'b1100: temp_output = 1;
                        4'b1101: temp_output = a | ~b;
                        4'b1110: temp_output = a | b;
                        4'b1111: temp_output = a;
                    endcase
                end 
            else 
                begin
                    case(select)
                        4'b0000: temp_output = a + carry_temp;
                        4'b0001: temp_output = (a | b) + carry_temp;
                        4'b0010: temp_output = (a | ~b) + carry_temp ;
                        4'b0011: temp_output = -1 + carry_temp;
                        4'b0100: temp_output = a + (a & ~b) + carry_temp;
                        4'b0101: temp_output = (a | b) + (a & ~b) + carry_temp;
                        4'b0110: temp_output = a - b - 1 + carry_temp;
                        4'b0111: temp_output = (a & b) -1 + carry_temp;
                        4'b1000: temp_output = a + (a & b) + carry_temp;
                        4'b1001: temp_output = a + b + carry_temp;
                        4'b1010: temp_output = (a | ~b) + (a & b) + carry_temp;
                        4'b1011: temp_output = (a & b) -1 + carry_temp;
                        4'b1100: temp_output = a + a + carry_temp;
                        4'b1101: temp_output = (a | b) + a + carry_temp;
                        4'b1110: temp_output = (a | ~b) + a + carry_temp;
                        4'b1111: temp_output = a - 1 + carry_temp;
                    endcase
                end
        end
    
    assign function_output = temp_output[3:0];
    assign carry_out = ~(temp_output[4] & ~mode_control);
    assign carry_propagate = (~carry_out | (&function_output | ~|function_output)) & ~mode_control;
    assign carry_generate = ~carry_out;
    assign comparator_output = &(~function_output);
    
endmodule