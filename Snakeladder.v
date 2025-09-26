module Snakeladder(
    input clk,        
    input rst_full,    
    input btn_cycle,  
    input btn_roll,    
    output reg [7:0] row,  
    output reg [7:0] col,  
    output reg [6:0] hex0,
    output reg [5:0] player_pos
);
     
    // Button Debouncing  
    reg btn_cycle_prev, btn_roll_prev;
    wire btn_cycle_edge, btn_roll_edge;
   
    assign btn_cycle_edge = btn_cycle & ~btn_cycle_prev;
    assign btn_roll_edge  = btn_roll  & ~btn_roll_prev;
   
    always @(posedge clk) begin
        btn_cycle_prev <= btn_cycle;
        btn_roll_prev  <= btn_roll;
    end

    // Dice Value Counter
    reg [2:0] dice_value = 3'b001;  
   
    always @(posedge clk or posedge rst_full) begin
        if (rst_full)
            dice_value <= 3'b001;  
        else if (btn_cycle_edge) begin
            if (dice_value == 3'b110)
                dice_value <= 3'b001;  
            else
                dice_value <= dice_value + 1;  
        end
    end

   
    reg [5:0] new_pos;  
   reg [6:0] temp_sum;
   
always @(posedge clk or posedge rst_full) begin
    if (rst_full)
        player_pos <= 6'd0;
    else if (btn_roll_edge) begin
        temp_sum = player_pos + dice_value;
        if (temp_sum > 6'd63)
            new_pos = player_pos;
        else
            new_pos = temp_sum[5:0];
       
       
        if ((new_pos == 6'd9) || (new_pos == 6'd24) || (new_pos == 6'd18) || (new_pos == 6'd59))
            player_pos <= snake_ladder(new_pos);
        else
            player_pos <= new_pos;
    end
end


    // Snake & Ladder Function
    function [5:0] snake_ladder;
        input [5:0] pos;
        begin
            case (pos)
                6'd9: snake_ladder = 6'd31; // Ladder: position 10 jumps to 32
                6'd24: snake_ladder = 6'd6;  // Snake: position 25 falls to 7
                6'd18: snake_ladder = 6'd49; // Ladder: position 19 jumps to 50
                6'd59: snake_ladder = 6'd4; // Snake: position 60 falls to 5
                default: snake_ladder = pos;
            endcase
        end
    endfunction

    // Derive Player's LED Matrix Coordinates
    reg [2:0] player_row;
    reg [2:0] player_col;
    always @(*) begin
        player_row = player_pos[5:3];  // Upper 3 bits: row
        player_col = player_pos[2:0];  // Lower 3 bits: column
    end

    // LED Matrix Refresh and Scanning Logic
    reg [15:0] refresh_counter;
    reg [2:0] row_index;
    always @(posedge clk or posedge rst_full) begin
        if (rst_full) begin
            refresh_counter <= 16'd0;
            row_index <= 3'd0;
        end else begin
            refresh_counter <= refresh_counter + 1;
            if (refresh_counter >= 16'd50000) begin
                refresh_counter <= 16'd0;
                row_index <= row_index + 1;
            end
        end
    end

    // Blink Logic for Player Position
    reg blink;
    reg [24:0] blink_counter;
    localparam BLINK_THRESHOLD = 25000000;
   
    always @(posedge clk or posedge rst_full) begin
        if (rst_full) begin
            blink_counter <= 0;
            blink <= 1'b1;
        end else begin
            if (blink_counter == BLINK_THRESHOLD - 1) begin
                blink_counter <= 0;
                blink <= ~blink;
            end else begin
                blink_counter <= blink_counter + 1;
            end
        end
    end

    //  ROM for Static Board
    reg [7:0] rom [0:7];
    initial begin
        rom[0] = 8'b01010000;
        rom[1] = 8'b00000010;
        rom[2] = 8'b00000100;
        rom[3] = 8'b10000001;
        rom[4] = 8'b00000000;
        rom[5] = 8'b00000000;
        rom[6] = 8'b00000010;
        rom[7] = 8'b00001000;
    end

    // Blinking and static rom integrating.
    reg [7:0] rom_data;
    always @(*) begin
        rom_data = rom[row_index];
    end

    reg [7:0] final_data;
    always @(*) begin
        if (row_index == player_row)
            final_data = rom_data | ((blink) ? (8'b00000001 << player_col) : 8'b00000000);
        else
            final_data = rom_data;
    end

    // LED Matrix Output Generation
    always @(*) begin
        reg [7:0] row_temp;
        row_temp = 8'hFF;
        row_temp[row_index] = 1'b0;
        row = row_temp;
        col = final_data;
    end

   
    always @(*) begin
        case (dice_value)
            3'b001: hex0 = 7'b1111001;
            3'b010: hex0 = 7'b0100100;
            3'b011: hex0 = 7'b0110000;
            3'b100: hex0 = 7'b0011001;
            3'b101: hex0 = 7'b0010010;
            3'b110: hex0 = 7'b0000010;
            default: hex0 = 7'b1000000;
        endcase
    end

endmodule
