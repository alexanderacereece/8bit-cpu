`timescale 1ns/1ps
module alu_tb;

    logic [7:0] a, b;
    logic [2:0] alu_op;
    logic cin;

    logic [7:0] result;
    logic negative, zero, carry, overflow;

    // Connect the ALU to the testbench.
    alu dut (
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
        input t_cin,
        input [7:0] exp_result,
        input exp_n, exp_z, exp_c, exp_v
    );
        begin
            // Drive inputs.
            alu_op = t_alu_op;
            a = t_a;
            b = t_b;
            cin = t_cin;
            #1; // Settle logic.
            // Compare real results with expected values.
            if (exp_result !== result || exp_n !== negative || exp_z !== zero || exp_c !== carry || exp_v !== overflow)
                $display("FAIL: a=%0d b=%0d cin=%0b alu_op=%b -> result=%0d NZCV=%b%b%b%b. Expected result=%0d NZCV=%b%b%b%b",
                a, b, cin, alu_op, result, negative, zero, carry, overflow,
                exp_result, exp_n, exp_z, exp_c, exp_v);
            else
                $display("PASS: a=%0d b=%0d alu_op=%b", a, b, alu_op);
        end
    endtask

    // Test the module.
    initial begin
        // Record signals.
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);

        //    alu_op  a    b     cin  result N  Z  C  V
        check(3'b000, 50,  50,   0,   100,   0, 0, 0, 0);
        check(3'b000, 100, 100,  1,   200,   1, 0, 0, 1);
        check(3'b000, 0,   17,   0,   17,    0, 0, 0, 0);
        check(3'b000, 20,  -25,  1,   -5,    1, 0, 0, 0);
        check(3'b000, 250, 50,   0,   44,    0, 0, 1, 0);
        check(3'b000, 128, 128,  1,   0,     0, 1, 1, 1);

        check(3'b001, 5,   7,    0,   -2,    1, 0, 0, 0);
        check(3'b001, 40,  2,    1,   38,    0, 0, 1, 0);
        check(3'b001, 128, 128,  0,   0,     0, 1, 1, 0);
        check(3'b001, 100, -100, 1,   200,   1, 0, 0, 1);

        check(3'b010, 13,  13,   0,   13,    0, 0, 0, 0);
        check(3'b010, 255, 51,   1,   51,    0, 0, 0, 0);
        check(3'b010, 102, 72,   0,   64,    0, 0, 0, 0);
        check(3'b010, 170, 85,   0,   0,     0, 1, 0, 0);
        
        check(3'b011, 64,  1,    0,   65,    0, 0, 0, 0);
        check(3'b011, 6,   4,    1,   6,     0, 0, 0, 0);
        check(3'b011, 128, 1,    0,   129,   1, 0, 0, 0);
        
        check(3'b100, 50,  50,   1,   101,   0, 0, 0, 0);
        check(3'b100, 100, 100,  1,   201,   1, 0, 0, 1);
        check(3'b100, 0,   17,   0,   17,    0, 0, 0, 0);
        check(3'b100, 20,  -25,  1,   -4,    1, 0, 0, 0);
        check(3'b100, 250, 50,   0,   44,    0, 0, 1, 0);
        check(3'b100, 128, 127,  1,   0,     0, 1, 1, 0);
        check(3'b100, 127, 0,    1,   128,   1, 0, 0, 1);

        check(3'b101, 33,  33,   0,   0,     0, 1, 0, 0);
        check(3'b101, 170, 85,   0,   255,   1, 0, 0, 0);
        check(3'b101, 16,  19,   1,   3,     0, 0, 0, 0);

        check(3'b110, 50,  23,   0,   0,     0, 1, 0, 0);
        check(3'b111, 24,  69,   1,   0,     0, 1, 0, 0);

        $finish;
    end
endmodule
