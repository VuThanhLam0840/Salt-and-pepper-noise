`timescale 1ns/1ps
`include "parameter.v" 	
module tb_median_filter;

    reg clk, rst, start;
    wire [2:0] State;
    wire [9:0] Row_o;
    wire [9:0] Col_o;
    wire [7:0] D0, D1, D2, D3, D4, D5, D6, D7, D8;
    wire done;

    // DUT
    top #(
        .INFILE(`INPUTFILENAME),
        .OUTFILE(`OUTPUTFILENAME)
    ) u_top (
        .clk(clk), .rst(rst), .start(start),
        .State(State), .Row_o(Row_o), .Col_o(Col_o),
        .D0(D0), .D1(D1), .D2(D2), .D3(D3), .D4(D4),
        .D5(D5), .D6(D6), .D7(D7), .D8(D8), .done(done)
    );

    // Clock
    initial begin 
        clk = 0;
        forever #1 clk = ~clk;
    end

    // Test
    initial begin
        rst = 1;
        start = 0;
        #5 rst = 0;
        #2 start = 1;
        #2 start = 0;
    end

   
    

   

endmodule
