`include "parameter.v" 	
module top #(
    parameter   WIDTH = 430, 
                HEIGHT = 554,
                INFILE = "pic_input.txt",
                OUTFILE = "pic_output.txt"
)(
    input wire clk,
    input wire rst,
    input wire start,
    output wire [2:0] State,
    output wire [9:0] Row_o,
    output wire [9:0] Col_o,
    output wire [7:0] D0, D1, D2, D3, D4, D5, D6, D7, D8,
    output wire done
);

    // ========== INTERNAL SIGNALS ==========
    wire [1:0] Col_ctrl;
    wire [1:0] Row_ctrl;
    wire [1:0] median_ctrl;
    wire [1:0] data_ctrl;
    wire [1:0] enable_wr;
    
    wire Col_done;
    wire Row_done;
    
    // Done signal
    assign done = (State == 3'd0) && (Row_done && Col_done);

    // ========== CONTROLLER INSTANCE ==========
    controller u_controller (
        .clk(clk),
        .rst(rst),
        .start(start),
        .Col_done(Col_done),
        .Row_done(Row_done),
        .Col_ctrl(Col_ctrl),
        .Row_ctrl(Row_ctrl),
        .median_ctrl(median_ctrl),
        .data_ctrl(data_ctrl),
        .enable_wr(enable_wr),
        .State(State)
    );

    // ========== DATAPATH INSTANCE ==========
    datapath #(
        .WIDTH(WIDTH),
        .HEIGHT(HEIGHT),
        .INFILE(INFILE),
        .OUTFILE(OUTFILE)
    ) u_datapath (
        .clk(clk),
        .Col_ctrl(Col_ctrl),
        .Row_ctrl(Row_ctrl),
        .median_ctrl(median_ctrl),
        .data_ctrl(data_ctrl),
        .enable_wr(enable_wr),
        .Row_o(Row_o),
        .Col_o(Col_o),
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .D4(D4),
        .D5(D5),
        .D6(D6),
        .D7(D7),
        .D8(D8),
        .Row_done(Row_done),
        .Col_done(Col_done)
    );
    
 

endmodule
