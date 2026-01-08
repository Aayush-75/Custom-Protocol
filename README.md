# Custom 4-bit Asynchronous Communication Protocol

## 1. Objective

There are 6 hardware pins available in both devices for one-to-one communication between each other. A custom protocol is designed for communication between them, and for redundancy, a checksum is also implemented for received data. This is an **asynchronous bidirectional half-duplex communication protocol**.

---

## 2. Hardware Pins

1. **Data Pin 1**
2. **Data Pin 2**
3. **Data Pin 3**
4. **Data Pin 4**
5. **Strobe Pin**
6. **Direction Pin**

---

## 3. System Architecture

A **Mealy state machine** is used for FSM designing of this protocol. After initially resetting the system, data lines will be in a high state (`4'b1111`). For the start of communication, all of these data lines will be transitioned to a low state (`4'b0000`). 

After detection of the start condition, data will be transmitted through data lines. Each cycle will transmit **4 bits of data** to the output side. After **4 cycles**, a total of **16 bits** will be transmitted to the output side. 

Parallelly, checksum bits will be calculated for each of the data transmitted, and after transmission of data, checksum bits will also be transmitted. Upon receiving data at the output side, the checksum will be calculated again and compared with the previously calculated checksum. Upon getting a match in the comparison of both checksums, the valid register will be high to indicate data validation.

---

## 4. Working of Code

The FSM has **3 states**: `IDLE`, `DATA`, and `CHECKSUM`.

### Step-by-Step Process:

- [FSM has 3 states idle, data and checksum. First of all reset state will be activated.](https://github.com/Aayush-75/Custom-Protocol/blob/main/protocol.v#L54-L57) In reset state data lines will be held high. [After lowering the reset system will wait for transition of low data lines which indicates start condition.](https://github.com/Aayush-75/Custom-Protocol/blob/main/protocol.v#L67) [Detection of start condition will change state to idle to data.](https://github.com/Aayush-75/Custom-Protocol/blob/main/protocol.v#L69) [In data state one after one total 4*4 16 bits of data will be transferred monitored via 2 bit data counter. With transferring each bits their checksum bit will also be calculated and stored.](https://github.com/Aayush-75/Custom-Protocol/blob/main/protocol.v#L85-L92) [After completion of this calculations checksum bits will be transferred to output checksum register.](https://github.com/Aayush-75/Custom-Protocol/blob/main/protocol.v#L125) [Data received at output side will again go through process of checksum calculation.](https://github.com/Aayush-75/Custom-Protocol/blob/main/protocol.v#L144-L148) [Previously calculated checksum will be compared with new calculation and if they match than valid register will be high to indicate data validity.](https://github.com/Aayush-75/Custom-Protocol/blob/main/protocol.v#L151)


---

## 5. Clock Cycle Wise Explanation

Data communication and checksum transfer takes **7 clock cycles** to complete transfer from master to slave end:

| **Cycle** | **Operation** |
|-----------|---------------|
| **1st Cycle** | Start condition will be checked, and upon detection, transition to `DATA` state. |
| **2nd Cycle** | With consideration of direction and strobe pin, data will start getting transferred (**1st data transfer cycle**) and calculation of its checksum. |
| **3rd Cycle** | **2nd data transfer cycle** and calculation of its checksum. |
| **4th Cycle** | **3rd data transfer cycle** and calculation of its checksum. |
| **5th Cycle** | **4th data transfer cycle** and calculation of its checksum. |
| **6th Cycle** | Calculated checksum bits transfer, and next state will be end of communication. |
| **7th Cycle** | Calculation of checksum of arrived data and comparison with previously calculated checksum. Upon match, valid register will be high. |

---



---

## Contributors

[Aayush Desai/Vicharak]
