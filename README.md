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

1. **[Reset State Activation](https://github.com/YOUR_USERNAME/YOUR_REPO/blob/main/YOUR_FILE.v#L10-L15)**: In the reset state, data lines will be held high.

2. **[Start Condition Detection](https://github.com/YOUR_USERNAME/YOUR_REPO/blob/main/YOUR_FILE.v#L20-L25)**: After lowering the reset, the system will wait for the transition of low data lines, which indicates the start condition.

3. **[State Transition to DATA](https://github.com/YOUR_USERNAME/YOUR_REPO/blob/main/YOUR_FILE.v#L30-L35)**: Detection of the start condition will change the state from `IDLE` to `DATA`.

4. **[Data Transfer](https://github.com/YOUR_USERNAME/YOUR_REPO/blob/main/YOUR_FILE.v#L40-L55)**: In the `DATA` state, one after another, a total of **4×4 = 16 bits** of data will be transferred, monitored via a 2-bit data counter.

5. **[Checksum Calculation During Transfer](https://github.com/YOUR_USERNAME/YOUR_REPO/blob/main/YOUR_FILE.v#L60-L70)**: With transferring each bit, their checksum bit will also be calculated and stored.

6. **[Checksum Transmission](https://github.com/YOUR_USERNAME/YOUR_REPO/blob/main/YOUR_FILE.v#L75-L80)**: After completion of these calculations, checksum bits will be transferred to the output checksum register.

7. **[Output Side Checksum Calculation](https://github.com/YOUR_USERNAME/YOUR_REPO/blob/main/YOUR_FILE.v#L85-L95)**: Data received at the output side will again go through the process of checksum calculation.

8. **[Checksum Validation](https://github.com/YOUR_USERNAME/YOUR_REPO/blob/main/YOUR_FILE.v#L100-L110)**: Previously calculated checksum will be compared with the new calculation, and if they match, the valid register will be high to indicate data validity.

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

[Your Name/Team]
