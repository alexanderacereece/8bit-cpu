module ALU (
    input [7:0] a, b,
    input [2:0] alu_op,
    input cin,
    output [7:0] result,
    output negative, zero, carry,
    output reg overflow); // Overflow is a reg because its assignment varies per alu_op.

    reg [8:0] full_result;

    always @(*) begin
        overflow = 1'b0;
        case (alu_op)
            3'b000: begin
                full_result = {1'b0, a} + {1'b0, b};
                overflow = (~a[7] & ~b[7] & full_result[7]) | (a[7] & b[7] & ~full_result[7]);
            end
            3'b001: begin
                full_result = {1'b0, a} + {1'b0, ~b} + 1'b1;
                overflow = (~a[7] & b[7] & full_result[7]) | (a[7] & ~b[7] & ~full_result[7]);
            end
            default: full_result = 9'd0;
        endcase
    end

    assign result = full_result[7:0];

    assign negative = result[7];
    assign zero = ~|result;
    assign carry = full_result[8];
    // Overflow was assigned in the alu_op case.
endmodule