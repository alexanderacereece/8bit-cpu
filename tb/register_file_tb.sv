`timescale 1ns/1ps
module register_file_tb;
    logic we;
    logic [1:0] a_address, b_address, w_address;
    logic [7:0] w_data;
    
    logic [7:0] a, b;

    // Set up a 10ns clock.
    logic clk = 0;
    always #5 clk = ~clk;

    register_file dut (
        .clk(clk),
        .we(we),
        .a_address(a_address),
        .b_address(b_address),
        .w_address(w_address),
        .w_data(w_data),
        .a(a),
        .b(b)
    );

    task write (
        input [1:0] t_address,
        input [7:0] t_data
    );
        begin
            w_address = t_address;
            w_data = t_data;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;
        end
    endtask

    task read_check (
        input [1:0] t_a_address, t_b_address,
        input [7:0] exp_a, exp_b
    );
        begin
            a_address = t_a_address;
            b_address = t_b_address;
            #1;
            if (a !== exp_a || b !== exp_b)
                $display("FAIL: a_address=%b b_address=%b -> a=%0d b=%0d. Expected a=%0d b=%0d",
                a_address, b_address, a, b, exp_a, exp_b);
            else
                $display("PASS: a_address=%b b_address=%b -> a=%0d b=%0d",
                a_address, b_address, a, b);
        end
    endtask

    initial begin
        $dumpfile("register_file.vcd");
        $dumpvars(0, register_file_tb);
        // Dump each reg for GTKWave.
        $dumpvars(0, register_file_tb.dut.regs[0]);
        $dumpvars(0, register_file_tb.dut.regs[1]);
        $dumpvars(0, register_file_tb.dut.regs[2]);
        $dumpvars(0, register_file_tb.dut.regs[3]);

        we = 0;

        //    addr   data
        write(2'b00, 13);
        write(2'b01, 2);
        write(2'b10, 7);
        write(2'b11, -18);

        //         a_addr b_addr a   b
        read_check(2'b00, 2'b01, 13, 2);
        read_check(2'b10, 2'b11, 7, -18);
        
        write(2'b00, 0);
        write(2'b11, 15);

        read_check(2'b00, 2'b00, 0, 0);
        read_check(2'b11, 2'b11, 15, 15);
        read_check(2'b10, 2'b01, 7, 2);

        $finish;
    end
endmodule