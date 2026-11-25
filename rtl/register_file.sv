`timescale 1ns/1ps
module register_file (
    input  logic clk, we,
    input  logic [1:0] a_address, b_address, w_address,
    input  logic [7:0] w_data,
    output logic [7:0] a, b);

    logic [7:0] regs [3:0];

    assign a = regs[a_address];
    assign b = regs[b_address];

    always_ff @(posedge clk) begin
        if (we)
            regs[w_address] <= w_data;
    end
endmodule