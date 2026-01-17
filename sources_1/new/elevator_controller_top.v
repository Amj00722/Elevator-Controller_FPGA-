// Top Module - Elevator Controller
module elevator_controller_top(
    input wire clk,
    input wire rst,
    // External call buttons (outside elevator)
    input wire call_up_0,      // Call button UP at floor 0
    input wire call_up_1,      // Call button UP at floor 1
    input wire call_down_1,    // Call button DOWN at floor 1
    input wire call_down_2,    // Call button DOWN at floor 2
    // Internal floor selection buttons (inside elevator)
    input wire select_floor_0,
    input wire select_floor_1,
    input wire select_floor_2,
    // Outputs
    output wire [1:0] current_floor,
    output wire door_open,
    output wire moving_up,
    output wire moving_down
);

    // Internal signals
    wire [2:0] floor_requests;
    wire floor_reached;
    wire [1:0] target_floor;
    
    // Instantiate Request Handler
    request_handler req_handler(
        .clk(clk),
        .rst(rst),
        .call_up_0(call_up_0),
        .call_up_1(call_up_1),
        .call_down_1(call_down_1),
        .call_down_2(call_down_2),
        .select_floor_0(select_floor_0),
        .select_floor_1(select_floor_1),
        .select_floor_2(select_floor_2),
        .current_floor(current_floor),
        .floor_reached(floor_reached),
        .floor_requests(floor_requests),
        .target_floor(target_floor)
    );
    
    // Instantiate Movement Controller
    movement_controller move_ctrl(
        .clk(clk),
        .rst(rst),
        .floor_requests(floor_requests),
        .target_floor(target_floor),
        .current_floor(current_floor),
        .floor_reached(floor_reached),
        .moving_up(moving_up),
        .moving_down(moving_down)
    );
    
    // Instantiate Door Controller
    door_controller door_ctrl(
        .clk(clk),
        .rst(rst),
        .floor_reached(floor_reached),
        .moving_up(moving_up),
        .moving_down(moving_down),
        .door_open(door_open)
    );

endmodule