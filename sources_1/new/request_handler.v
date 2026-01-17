// Request Handler Module
// File: request_handler.v

module request_handler(
    input wire clk,
    input wire rst,
    // External call buttons
    input wire call_up_0,
    input wire call_up_1,
    input wire call_down_1,
    input wire call_down_2,
    // Internal floor selection buttons
    input wire select_floor_0,
    input wire select_floor_1,
    input wire select_floor_2,
    input wire [1:0] current_floor,
    input wire floor_reached,
    // Outputs
    output reg [2:0] floor_requests,  // One bit per floor
    output reg [1:0] target_floor
);

    // State to track if passenger is inside
    reg passenger_inside;
    reg [1:0] passenger_destination;
    reg return_to_zero; // Flag to return to floor 0 after passenger exits
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            floor_requests <= 3'b000;
            target_floor <= 2'd0;
            passenger_inside <= 1'b0;
            passenger_destination <= 2'd0;
            return_to_zero <= 1'b0;
        end else begin
            // Clear request when floor is reached
            if (floor_reached) begin
                floor_requests[current_floor] <= 1'b0;
                
                // If passenger reached destination, clear passenger state and initiate return
                if (passenger_inside && current_floor == passenger_destination) begin
                    passenger_inside <= 1'b0;
                    // Set flag to return to floor 0 if not already there
                    // Only set floor request after a brief delay (handled by door timer)
                    if (current_floor != 2'd0) begin
                        return_to_zero <= 1'b1;
                    end
                end
                
                // Clear return flag when back at floor 0
                if (return_to_zero && current_floor == 2'd0) begin
                    return_to_zero <= 1'b0;
                end
            end
            
            // Set floor 0 request only after passenger exits and door cycle completes
            // This prevents door from opening at floor 0 before departure
            if (return_to_zero && !floor_reached) begin
                floor_requests[0] <= 1'b1;
            end
            
            // Handle external call buttons (only when no passenger inside and not returning)
            if (!passenger_inside && !return_to_zero) begin
                if (call_up_0) begin
                    floor_requests[0] <= 1'b1;
                end
                if (call_up_1 || call_down_1) begin
                    floor_requests[1] <= 1'b1;
                end
                if (call_down_2) begin
                    floor_requests[2] <= 1'b1;
                end
            end
            
            // Handle internal floor selection (passenger enters and selects floor)
            // Only accept new passengers when at floor 0 (idle state) and not returning
            if (!passenger_inside && !return_to_zero) begin
                if (select_floor_0) begin
                    floor_requests[0] <= 1'b1;
                    passenger_inside <= 1'b1;
                    passenger_destination <= 2'd0;
                end
                if (select_floor_1) begin
                    floor_requests[1] <= 1'b1;
                    passenger_inside <= 1'b1;
                    passenger_destination <= 2'd1;
                end
                if (select_floor_2) begin
                    floor_requests[2] <= 1'b1;
                    passenger_inside <= 1'b1;
                    passenger_destination <= 2'd2;
                end
            end
            
            // Determine target floor
            // Priority 1: Returning to floor 0 after dropping passenger
            if (return_to_zero) begin
                target_floor <= 2'd0;
            // Priority 2: Passenger destination
            end else if (passenger_inside) begin
                target_floor <= passenger_destination;
            // Priority 3: External calls (find closest floor)
            end else if (floor_requests != 3'b000) begin
                // Find closest requested floor
                if (floor_requests[current_floor]) begin
                    target_floor <= current_floor;
                end else if (current_floor == 2'd0) begin
                    if (floor_requests[1]) target_floor <= 2'd1;
                    else if (floor_requests[2]) target_floor <= 2'd2;
                end else if (current_floor == 2'd1) begin
                    if (floor_requests[0]) target_floor <= 2'd0;
                    else if (floor_requests[2]) target_floor <= 2'd2;
                end else begin // current_floor == 2
                    if (floor_requests[1]) target_floor <= 2'd1;
                    else if (floor_requests[0]) target_floor <= 2'd0;
                end
            end else begin
                target_floor <= current_floor;
            end
        end
    end

endmodule