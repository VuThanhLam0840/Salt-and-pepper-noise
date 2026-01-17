module controller
(
    input wire clk, rst, start, Col_done,Row_done,
    output reg [1:0] Col_ctrl, Row_ctrl, median_ctrl, data_ctrl, enable_wr,
    output reg [2:0] State
);
    localparam  Idle = 3'd0,
                Load = 3'd1,
                Update_median = 3'd5,
                Write = 3'd2,
                Inc_col = 3'd3,
                Inc_row = 3'd4;
    reg [2:0] cur_state,n_state;

    // reg
    always @(posedge clk or posedge rst)
    begin
        if(rst)
            cur_state <= Idle;
        else
            cur_state <= n_state;
    end


    //Next_state update
    always @(*)
    begin
        case(cur_state)
            Idle : n_state = (start) ? Load : Idle;
            Load : n_state = Update_median ;
            Update_median : n_state = Write;
            Write : begin
                if(Col_done && Row_done)
                    n_state = Idle;
                else if(Col_done)
                    n_state = Inc_row;
                else 
                    n_state = Inc_col;
            end
            Inc_col : n_state = Load;
            Inc_row : n_state = Load;
            default : n_state = Idle;
        endcase
    end

    always @(*)
    begin
        State = cur_state;
        Row_ctrl = 2'd0;
        Col_ctrl = 2'd0;
        data_ctrl = 2'd0;
        median_ctrl = 2'd0;
        enable_wr = 2'd0;
       // update_memory = 2'd0;
        case(cur_state)
            Idle : begin
                Row_ctrl = 2'd1;
                Col_ctrl= 2'd1;
            end
            Load : begin
                data_ctrl = 2'd1; //load
                median_ctrl = 2'd1;// load
            end
            Update_median : begin
                median_ctrl = 2'd2;//Change
                
            end
            Write : begin
                enable_wr = 2'd1 ; // cho phep ghi vo memory
            end
            Inc_col : begin
                Col_ctrl = 2'd2 ; // increase 1
            end
            Inc_row : begin
                Row_ctrl = 2'd2 ; // increase 1
                Col_ctrl = 2'd1; // reload 0
            end 
        endcase
    end


endmodule
