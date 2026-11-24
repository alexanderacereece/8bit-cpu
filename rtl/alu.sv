`timescale 1ns/1ps
module alu (
    input  logic [7:0] a, b,
    input  logic [2:0] alu_op,
    input  logic cin,
    output logic [7:0] result,
    output logic negative, zero, carry,
    output logic overflow); // Overflow is assigned per alu_op in always_comb.

    logic [8:0] full_result;

    always_comb begin
        // Default assignments.
        full_result = 9'd0;
        overflow = 1'b0;
        // Individual operations.
        case (alu_op)
            3'b000: begin
                full_result = {1'b0, a} + {1'b0, b};
                overflow = (~a[7] & ~b[7] & full_result[7]) | (a[7] & b[7] & ~full_result[7]);
            end
            3'b001: begin
                full_result = {1'b0, a} + {1'b0, ~b} + 1'b1;
                overflow = (~a[7] & b[7] & full_result[7]) | (a[7] & ~b[7] & ~full_result[7]);
            end
            3'b010: begin
                full_result = {1'b0, a} & {1'b0, b};
                overflow = 1'b0;
            end
            3'b011: begin
                full_result = {1'b0, a} | {1'b0, b};
                overflow = 1'b0;
            end
            3'b100: begin
                full_result = {1'b0, a} + {1'b0, b} + cin;
                overflow = (~a[7] & ~b[7] & full_result[7]) | (a[7] & b[7] & ~full_result[7]);
            end
            3'b101: begin
                full_result = {1'b0, a} ^ {1'b0, b};
                overflow = 1'b0;
            end
            default: begin
                full_result = 9'd0;
                overflow = 1'b0;
            end
        endcase
    end

    assign result = full_result[7:0];

    assign negative = result[7];
    assign zero = ~|result;
    assign carry = full_result[8];
    // Overflow was assigned in the alu_op case.
endmodule
