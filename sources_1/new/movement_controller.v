// Movement Controller Module
// File: movement_controller.v

module movement_controller(
    input wire clk,
    input wire rst,
    input wire [2:0] floor_requests,
    input wire [1:0] target_floor,
    output reg [1:0] current_floor,
    output reg floor_reached,
    output reg moving_up,
    output reg moving_down
);

    // Movement timing counter (simulates elevator speed)
    reg [28:0] move_counter;
    // At 50 MHz clock: 150,000,000 cycles = 3 seconds between floors
    parameter MOVE_DELAY = 29'd150000000; // 3 sec per floor (VERY SLOW - easy to see!)
    // This means Floor 0?1 takes 3 seconds, Floor 1?2 takes 3 seconds, etc.
    
    // State machine
    localparam IDLE = 2'd0;
    localparam MOVING = 2'd1;
    localparam ARRIVED = 2'd2;
    
    reg [1:0] state;
    reg [28:0] door_timer;
    // At 50 MHz clock: 250,000,000 cycles = 5 seconds door open
    parameter DOOR_DELAY = 29'd250000000; // 5 sec door stays open (VERY SLOW - easy to see!)
    // Door will stay open for full 5 seconds - plenty of time to observe!
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_floor <= 2'd0;
            floor_reached <= 1'b0;
            moving_up <= 1'b0;
            moving_down <= 1'b0;
            move_counter <= 28'd0;
            state <= IDLE;
            door_timer <= 28'd0;
        end else begin
            case (state)
                IDLE: begin
                    floor_reached <= 1'b0;
                    moving_up <= 1'b0;
                    moving_down <= 1'b0;
                    
                    // Check if there's a request to move
                    if (floor_requests != 3'b000 && target_floor != current_floor) begin
                        state <= MOVING;
                        move_counter <= 28'd0;
                        
                        if (target_floor > current_floor) begin
                            moving_up <= 1'b1;
                        end else begin
                            moving_down <= 1'b1;
                        end
                    end
                end
                
                MOVING: begin
                    move_counter <= move_counter + 1;
                    
                    // Move to next floor after delay
                    if (move_counter >= MOVE_DELAY) begin
                        move_counter <= 28'd0;
                        
                        if (moving_up && current_floor < 2'd2) begin
                            current_floor <= current_floor + 1;
                        end else if (moving_down && current_floor > 2'd0) begin
                            current_floor <= current_floor - 1;
                        end
                        
                        // Check if reached target floor
                        if ((moving_up && current_floor + 1 == target_floor) ||
                            (moving_down && current_floor - 1 == target_floor) ||
                            (current_floor == target_floor)) begin
                            state <= ARRIVED;
                            door_timer <= 28'd0;
                            floor_reached <= 1'b1;
                            moving_up <= 1'b0;
                            moving_down <= 1'b0;
                        end
                    end
                end
                
                ARRIVED: begin
                    door_timer <= door_timer + 1;
                    
                    // Keep door open for a period
                    if (door_timer >= DOOR_DELAY) begin
                        floor_reached <= 1'b0;
                        state <= IDLE;
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule