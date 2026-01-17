`include "parameter.v" 	
module datapath #(
    parameter   WIDTH = 430, 
                HEIGHT = 554,
                INFILE = "pic_input.txt",
                OUTFILE = "pic_output.txt"
)(
    input wire [1:0]  Col_ctrl, Row_ctrl, median_ctrl, data_ctrl, enable_wr,
    input wire clk,
    output wire  Row_done,Col_done,
    output [9:0] Row_o, 
    output [9:0] Col_o,
    output [7:0] D0,D1,D2,D3,D4,D5,D6,D7,D8
);

    parameter sizeOfLengthReal = 238220; 		// image data  430*554 = 238220

    reg [7 : 0]   total_memory [0 : sizeOfLengthReal-1];
    reg [7:0] tmp_mem [0 : sizeOfLengthReal-1];
    initial begin
    $readmemh(INFILE,total_memory,0,sizeOfLengthReal-1); // read file from INFILE
    $readmemh(INFILE,tmp_mem,0,sizeOfLengthReal-1);
    end


    reg [9:0] Row;
    reg [9:0] Col;
    wire [9:0] Row_in;
    wire [9:0] Col_in;

    reg [7:0] arr [0:8];
    wire [7:0] arr_in[0:8];

    mux4to1_10 a0
    (
        .a(Row),
        .b(10'd0),
        .c(Row + 10'd1),
        .d(10'd0),
        .sel(Row_ctrl),
        .out(Row_in)
    );

    mux4to1_10 a1(
        .a(Col),
        .b(10'd0),
        .c(Col + 10'd1),
        .d(10'd0),
        .sel(Col_ctrl),
        .out(Col_in)
    );

    mux4to1_8 a2(
        .a(arr[0]),
        .b(total_memory[Row * WIDTH + Col]),
        .c(8'd0),
        .d(8'd0),
        .sel(data_ctrl),
        .out(arr_in[0])
    );

    mux4to1_8 a3(
        .a(arr[1]),
        .b(total_memory[Row * WIDTH + Col + 1]),
        .c(8'd0),
        .d(8'd0),
        .sel(data_ctrl),
        .out(arr_in[1])
    );

      mux4to1_8 a4(
        .a(arr[2]),
        .b(total_memory[Row * WIDTH + Col + 2]),
        .c(8'd0),
        .d(8'd0),
        .sel(data_ctrl),
        .out(arr_in[2])
    );

    
      mux4to1_8 a5(
        .a(arr[3]),
        .b(total_memory[Row * WIDTH + Col + WIDTH]),
        .c(8'd0),
        .d(8'd0),
        .sel(data_ctrl),
        .out(arr_in[3])
    );
    wire [7:0] median;
    median9 a7 (
        .a0(arr[0]),
        .a1(arr[1]),
        .a2(arr[2]),
        .a3(arr[3]),
        .a4(arr[4]),
        .a5(arr[5]),
        .a6(arr[6]),
        .a7(arr[7]),
        .a8(arr[8]),
        .median(median)
    );


     mux4to1_8 a6(
        .a(arr[4]),
        .b(total_memory[Row * WIDTH + Col + WIDTH + 1]),
        .c(median),
        .d(8'd0),
        .sel(median_ctrl),
        .out(arr_in[4])
    );
      mux4to1_8 a9(
        .a(arr[5]),
        .b(total_memory[Row * WIDTH + Col + WIDTH + 2]),
        .c(8'd0),
        .d(8'd0),
        .sel(data_ctrl),
        .out(arr_in[5])
    );
      mux4to1_8 a8(
        .a(arr[6]),
        .b(total_memory[Row * WIDTH + Col + WIDTH*2]),
        .c(8'd0),
        .d(8'd0),
        .sel(data_ctrl),
        .out(arr_in[6])
    );
       mux4to1_8 a10(
        .a(arr[7]),
        .b(total_memory[Row * WIDTH + Col + WIDTH*2 + 1]),
        .c(8'd0),
        .d(8'd0),
        .sel(data_ctrl),
        .out(arr_in[7])
    );

      mux4to1_8 a11(
        .a(arr[8]),
        .b(total_memory[Row * WIDTH + Col + WIDTH*2 + 2]),
        .c(8'd0),
        .d(8'd0),
        .sel(data_ctrl),
        .out(arr_in[8])
    );




    assign Row_done = (Row ==(HEIGHT - 3)) ? 1 : 0;
    assign Col_done = (Col == (WIDTH - 3 )) ? 1 : 0;

   /* integer infile, outfile;
    initial begin
        outfile = $fopen(OUTFILE, "w");
    end*/



    always @(posedge clk) begin
        if (enable_wr) begin
            tmp_mem[Row * WIDTH + Col + WIDTH + 1] <= median;
        end
    end
    
 
    always @(posedge clk) begin
        if (Row_done && Col_done ) begin
            $writememh(OUTFILE,tmp_mem,0,sizeOfLengthReal-1);
        end
    end
  
    always @(posedge clk) begin
        Row <= Row_in;
        Col <= Col_in;
        arr[0] <= arr_in[0];
        arr[1] <= arr_in[1];
        arr[2] <= arr_in[2];
        arr[3] <= arr_in[3];
        arr[4] <= arr_in[4];
        arr[5] <= arr_in[5];
        arr[6] <= arr_in[6];
        arr[7] <= arr_in[7];
        arr[8] <= arr_in[8];
    end

    // Assign outputs
    assign Row_o = Row;
    assign Col_o = Col;
    assign D0 = arr[0];
    assign D1 = arr[1];
    assign D2 = arr[2];
    assign D3 = arr[3];
    assign D4 = arr[4];
    assign D5 = arr[5];
    assign D6 = arr[6];
    assign D7 = arr[7];
    assign D8 = arr[8];


endmodule
