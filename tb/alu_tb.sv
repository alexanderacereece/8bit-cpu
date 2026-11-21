`timescale 1ns/1ps
module alu_tb;

    logic [7:0] a, b;
    logic [2:0] alu_op;
    logic cin;

    logic [7:0] result;
    logic negative, zero, carry, overflow;

    // Connect the ALU to the testbench.
    ALU dut (
        .a(a),
        .b(b),
        .alu_op(alu_op),
        .cin(cin),
        .result(result),
        .negative(negative),
        .zero(zero),
        .carry(carry),
        .overflow(overflow)
    );

    // Set up the check function.
    task check(
        input [2:0] t_alu_op,
        input [7:0] t_a, t_b,
        input [7:0] exp_result,
        input exp_n, exp_z, exp_c, exp_v
    );
        begin
            // Drive inputs.
            alu_op = t_alu_op;
            a = t_a;
            b = t_b;
            #1; // Settle logic.
            // Compare real results with expected values.
            if (exp_result !== result || exp_n !== negative || exp_z !== zero || exp_c !== carry || exp_v !== overflow)
                $display("FAIL: a=%d b=%d alu_op=%b -> result=%d NZCV=%b%b%b%b", a, b, alu_op, result, negative, zero, carry, overflow);
            else
                $display("PASS");
        end
    endtask

    // Test the module.
    initial begin
        // Record signals.
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);

        cin = 0; // Temporary until applicable tests are made.

        //    alu_op  a   b   result N  Z  C  V
        check(3'b000, 50, 50, 100,   0, 0, 0, 0);

        $finish;
    end

endmodule