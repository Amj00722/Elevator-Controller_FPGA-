// Door Controller Module
// File: door_controller.v

module door_controller(
    input wire clk,
    input wire rst,
    input wire floor_reached,
    input wire moving_up,
    input wire moving_down,
    output reg door_open
);

    // Blink counter for door opening animation
    reg [25:0] blink_counter;
    parameter BLINK_PERIOD = 26'd2500000; // 0.05 sec at 50MHz (fast blink)
    
    // Door state timer
    reg [25:0] door_timer;
    parameter DOOR_OPEN_TIME = 26'd25000000; // 0.5 sec door stays open at 50MHz
    
    reg door_state; // 0=closed, 1=open
    reg blinking;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            door_open <= 1'b0;
            blink_counter <= 26'd0;
            door_timer <= 26'd0;
            door_state <= 1'b0;
            blinking <= 1'b0;
        end else begin
            // Start blinking when floor is reached
            if (floor_reached && !moving_up && !moving_down && !door_state) begin
                blinking <= 1'b1;
                door_timer <= 26'd0;
                door_state <= 1'b1;
            end
            
            // Handle blinking animation
            if (blinking) begin
                blink_counter <= blink_counter + 1;
                door_timer <= door_timer + 1;
                
                // Toggle door_open for blinking effect
                if (blink_counter >= BLINK_PERIOD) begin
                    door_open <= ~door_open;
                    blink_counter <= 26'd0;
                end
                
                // Stop blinking after 0.5 seconds
                if (door_timer >= DOOR_OPEN_TIME) begin
                    blinking <= 1'b0;
                    door_open <= 1'b0;
                    door_state <= 1'b0;
                end
            end else if (!floor_reached) begin
                // Door closed when moving
                door_open <= 1'b0;
                door_state <= 1'b0;
            end
        end
    end

endmodule