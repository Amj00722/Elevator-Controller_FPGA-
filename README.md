# Elevator-Controller_FPGA-
Elevator Controller FPGA is a Verilog-based digital design for a 3-floor elevator system implemented on the ZedBoard (Zynq-7000). The project handles inside and outside floor requests, motor up/down control, door open/close logic, floor indication using LEDs, and automatic return to the ground floor using a finite state machine (FSM).
The system handles inside and outside floor requests, controls motor direction, manages door open/close operations, displays the current floor using LEDs, and automatically returns to the ground floor after servicing a request.

The design is based on a Finite State Machine (FSM) and is fully synthesizable, simulated, and implemented using Vivado.

Features

3-floor elevator (Floor 0, 1, 2)

Inside elevator floor selection switches

Outside elevator call switches

Motor control:

Up movement

Down movement

Door control:

Door open signal

Door close signal

Floor indication using LEDs (one-hot encoding)

Automatic return to ground floor (Floor 0)

FSM-based control logic

ZedBoard-compatible .xdc constraints
FSM Flow

IDLE

Waits for inside or outside floor request.

If request is at the current floor → open door.

Else → decide whether to move up or down.

MOVING_UP / MOVING_DOWN

Motor signal activated.

Elevator moves one floor after a fixed delay.

When target floor is reached → transition to DOOR_OPEN.

DOOR_OPEN

Door open signal asserted.

Door remains open for a fixed time.

After door closes:

If current floor ≠ 0 → go to RETURNING

Else → return to IDLE

RETURNING

Elevator moves downward until Floor 0.

Once reached → transition to IDLE
