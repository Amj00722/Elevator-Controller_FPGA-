// Testbench for Elevator Controller
`timescale 1ns/1ps

module elevator_testbench;

    // Clock and reset
    reg clk;
    reg rst;
    
    // External call buttons
    reg call_up_0;
    reg call_up_1;
    reg call_down_1;
    reg call_down_2;
    
    // Internal floor selection buttons
    reg select_floor_0;
    reg select_floor_1;
    reg select_floor_2;
    
    // Outputs
    wire [1:0] current_floor;
    wire door_open;
    wire moving_up;
    wire moving_down;
    
    // Instantiate the elevator controller
    elevator_controller_top uut (
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
        .door_open(door_open),
        .moving_up(moving_up),
        .moving_down(moving_down)
    );
    
    // Clock generation (10ns period = 100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Monitor outputs
    initial begin
        $monitor("Time=%0t | Floor=%0d | Door=%b | Moving_Up=%b | Moving_Down=%b", 
                 $time, current_floor, door_open, moving_up, moving_down);
    end
    
    // Test scenarios
    initial begin
        // Initialize inputs
        rst = 1;
        call_up_0 = 0;
        call_up_1 = 0;
        call_down_1 = 0;
        call_down_2 = 0;
        select_floor_0 = 0;
        select_floor_1 = 0;
        select_floor_2 = 0;
        
        // Reset
        #20 rst = 0;
        $display("\n=== Test 1: Passenger at Floor 0 selects Floor 2 ===");
        #100;
        
        // Passenger enters at floor 0 and selects floor 2
        select_floor_2 = 1;
        #20 select_floor_2 = 0;
        
        // Wait for elevator to reach floor 2 and return to floor 0
        #200000000;
        
        $display("\n=== Test 2: External call from Floor 1 (Up) ===");
        #100;
        
        // Someone calls elevator from floor 1 going up
        call_up_1 = 1;
        #20 call_up_1 = 0;
        
        // Wait for elevator to arrive at floor 1
        #100000000;
        
        // Passenger selects floor 2
        select_floor_2 = 1;
        #20 select_floor_2 = 0;
        
        // Wait for completion
        #200000000;
        
        $display("\n=== Test 3: External call from Floor 2 (Down) ===");
        #100;
        
        // Someone calls elevator from floor 2 going down
        call_down_2 = 1;
        #20 call_down_2 = 0;
        
        // Wait for elevator to arrive at floor 2
        #100000000;
        
        // Passenger selects floor 0
        select_floor_0 = 1;
        #20 select_floor_0 = 0;
        
        // Wait for completion
        #150000000;
        
        $display("\n=== Test 4: Passenger at Floor 0 selects Floor 1 ===");
        #100;
        
        // Passenger selects floor 1
        select_floor_1 = 1;
        #20 select_floor_1 = 0;
        
        // Wait for completion
        #200000000;
        
        $display("\n=== Simulation Complete ===");
        $finish;
    end
    
    // Generate VCD file for waveform viewing
    initial begin
        $dumpfile("elevator_waveform.vcd");
        $dumpvars(0, elevator_testbench);
    end

endmodule