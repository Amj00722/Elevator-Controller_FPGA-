# 🚀 Elevator Controller FPGA (ZedBoard – Zynq-7000)

## 📌 Overview
**Elevator Controller FPGA** is a Verilog-based digital design for a **3-floor elevator system** implemented on the **ZedBoard (Zynq-7000)**.  
The project handles **inside and outside floor requests**, **motor up/down control**, **door open/close logic**, **floor indication using LEDs**, and **automatic return to the ground floor** using a **Finite State Machine (FSM)**.

The design is fully **synthesizable**, **simulated**, and **implemented** using **Vivado**.

---

## ✨ Features
- 3-floor elevator (Floor 0, 1, 2)
- Inside elevator floor selection switches
- Outside elevator call switches
- Motor control:
  - Up movement
  - Down movement
- Door control:
  - Door open signal
  - Door close signal
- Floor indication using LEDs (one-hot)
- Automatic return to ground floor
- FSM-based control logic
- ZedBoard-compatible `.xdc` constraints

---

---

## 🧠 Finite State Machine (FSM)

### States
- **IDLE** – Elevator waiting for a request
- **MOVING_UP** – Elevator moving upward
- **MOVING_DOWN** – Elevator moving downward
- **DOOR_OPEN** – Door opens at target floor
- **RETURNING** – Elevator returns to ground floor

### FSM Operation
1. Elevator starts in **IDLE** with doors closed.
2. On a valid inside or outside request:
   - Elevator moves **up or down** toward the target floor.
3. When the target floor is reached:
   - Door opens for a fixed duration.
4. After the door closes:
   - Elevator automatically returns to **Floor 0**.
5. System returns to **IDLE** state.

---
## 👩‍💻 Project Contributors
This project was developed as a team effort by:

- **Ameena Fathima VN**
- **Ann Maria Jose**
- **Merieum Abraham**
- **Judith Jose**
- **Joann Jose**



