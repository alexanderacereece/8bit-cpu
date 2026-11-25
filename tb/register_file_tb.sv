`timescale 1ns/1ps
module register_file_tb (
    logic clk, we,
    logic [1:0] a_address, b_address, w_address
    logic [7:0] w_data
    
    logic [7:0] a, b);

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

endmodule