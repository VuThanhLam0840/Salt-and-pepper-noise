module median9(
    input  wire [7:0] a0,a1,a2,a3,a4,a5,a6,a7,a8,
    output wire [7:0] median
);

    reg [7:0] x[0:8];

    task sort2;
        inout [7:0] p, q;
        reg [7:0] t;
        begin
            if (p > q) begin
                t = p; p = q; q = t;
            end
        end
    endtask

    always @(*) begin
        x[0]=a0; x[1]=a1; x[2]=a2;
        x[3]=a3; x[4]=a4; x[5]=a5;
        x[6]=a6; x[7]=a7; x[8]=a8;

        sort2(x[1],x[2]);
        sort2(x[4],x[5]);
        sort2(x[7],x[8]);

        sort2(x[0],x[1]);
        sort2(x[3],x[4]);
        sort2(x[6],x[7]);

        sort2(x[1],x[2]);
        sort2(x[4],x[5]);
        sort2(x[7],x[8]);

        sort2(x[0],x[3]);
        sort2(x[5],x[8]);
        sort2(x[4],x[7]);

        sort2(x[3],x[6]);
        sort2(x[1],x[4]);
        sort2(x[2],x[5]);

        sort2(x[4],x[7]);
        sort2(x[4],x[2]);
        sort2(x[6],x[4]);
        sort2(x[4],x[2]);
    end

    assign median = x[4];
endmodule
