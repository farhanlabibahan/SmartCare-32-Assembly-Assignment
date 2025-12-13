		AREA myData, DATA, READWRITE
        ALIGN 4

; Patient Structure (simple version)
patient_id      DCD 100        ; Patient ID
patient_age     DCD 65          ; Age
patient_ward    DCD 7           ; Ward
patient_hr      DCD 130         ; Heart Rate
patient_o2      DCD 95          ; O2 Level
patient_alerts  DCD 3           ; Alert Count
patient_bill    DCD 12500       ; Billing $125.00 (in cents)

; ITM Port 0 address (for printf in Keil)
ITM_PORT0       EQU 0xE0000000
ITM_TER0        EQU 0xE0000E00  ; ITM Trace Enable Register
ITM_TPR         EQU 0xE0000E40  ; ITM Trace Privilege Register
ITM_TCR         EQU 0xE0000E80  ; ITM Trace Control Register

; Strings
title       DCB "ICU Patient Summary\r\n", 0
sep         DCB "--------------------\r\n", 0
id_str      DCB "ID: ", 0
age_str     DCB "Age: ", 0
ward_str    DCB "Ward: ", 0
hr_str      DCB "HR: ", 0
o2_str      DCB "O2: ", 0
alert_str   DCB "Alerts: ", 0
bill_str    DCB "Bill: $", 0
newline     DCB "\r\n", 0

        AREA |.text|, CODE, READONLY
        EXPORT main
        ENTRY

main
    ; Initialize ITM for debug output
    BL init_itm
    
    ; Generate summary for 1 patient
    BL print_summary
    
stop
    B stop

; Initialize ITM (Instrumentation Trace Macrocell)
init_itm
    PUSH {R0-R1, LR}
    
    ; Unlock ITM (if locked)
    LDR R0, =0xE0000FB0      ; ITM Lock Access Register
    LDR R1, =0xC5ACCE55      ; Unlock key
    STR R1, [R0]
    
    ; Enable ITM
    LDR R0, =ITM_TCR         ; Trace Control Register
    LDR R1, [R0]
    ORR R1, R1, #0x00000001  ; Set ITMENA bit
    STR R1, [R0]
    
    ; Enable stimulus port 0
    LDR R0, =ITM_TER0        ; Trace Enable Register
    MOV R1, #0x00000001      ; Enable port 0
    STR R1, [R0]
    
    ; Set privilege level (allow user access)
    LDR R0, =ITM_TPR         ; Trace Privilege Register
    MOV R1, #0x00000000      ; Allow all privilege levels
    STR R1, [R0]
    
    POP {R0-R1, PC}

print_summary
    PUSH {LR}
    
    ; Print title
    LDR R0, =title
    BL print_string
    
    LDR R0, =sep
    BL print_string
    
    ; Print Patient ID
    LDR R0, =id_str
    BL print_string
    LDR R0, =patient_id
    LDR R0, [R0]
    BL print_number
    LDR R0, =newline
    BL print_string
    
    ; Print Age
    LDR R0, =age_str
    BL print_string
    LDR R0, =patient_age
    LDR R0, [R0]
    BL print_number
    LDR R0, =newline
    BL print_string
    
    ; Print Ward
    LDR R0, =ward_str
    BL print_string
    LDR R0, =patient_ward
    LDR R0, [R0]
    BL print_number
    LDR R0, =newline
    BL print_string
    
    ; Print Heart Rate
    LDR R0, =hr_str
    BL print_string
    LDR R0, =patient_hr
    LDR R0, [R0]
    BL print_number
    LDR R0, =newline
    BL print_string
    
    ; Print O2 Level
    LDR R0, =o2_str
    BL print_string
    LDR R0, =patient_o2
    LDR R0, [R0]
    BL print_number
    LDR R0, =newline
    BL print_string
    
    ; Print Alert Count
    LDR R0, =alert_str
    BL print_string
    LDR R0, =patient_alerts
    LDR R0, [R0]
    BL print_number
    LDR R0, =newline
    BL print_string
    
    ; Print Billing
    LDR R0, =bill_str
    BL print_string
    LDR R0, =patient_bill
    LDR R0, [R0]
    BL print_bill
    
    POP {PC}

; Print billing as dollars.cents
; R0 = amount in cents
print_bill
    PUSH {R0-R5, LR}
    
    ; Get dollars (divide by 100)
    MOV R1, #100
    MOV R2, R0          ; Save original
    MOV R3, #0          ; Counter for dollars
    
dollar_loop
    CMP R2, R1
    BLT dollars_done
    SUB R2, R2, R1      ; Subtract 100 cents
    ADD R3, R3, #1      ; Count dollars
    B dollar_loop
    
dollars_done
    ; R3 = dollars, R2 = remaining cents
    
    ; Print dollars
    MOV R0, R3
    BL print_number
    
    ; Print decimal point
    MOV R0, #'.'
    BL send_char
    
    ; Print cents (always 2 digits)
    ; R2 already has remainder (cents 0-99)
    MOV R0, R2
    
    ; Check if less than 10
    CMP R0, #10
    BGE print_two_digits
    
    ; Print leading zero
    MOV R1, #'0'
    MOV R0, R1
    BL send_char
    
    ; Get cents value again from R2
    MOV R0, R2
    B print_one_digit
    
print_two_digits
    ; R0 has cents (10-99)
    ; Need to print tens digit and ones digit
    
    ; Save original
    MOV R4, R0          ; Save cents
    MOV R5, #10         ; Divisor
    
    ; Get tens digit
    MOV R0, R4
    MOV R1, R5
    BL divide_simple    ; R0 = tens digit
    MOV R3, R0          ; Save tens digit
    
    ; Print tens digit
    ADD R0, R3, #'0'    ; Convert to ASCII
    BL send_char
    
    ; Calculate ones digit: cents - (tens * 10)
    MOV R0, R3
    MUL R0, R0, R5      ; tens * 10
    SUB R0, R4, R0      ; cents - (tens * 10)
    
print_one_digit
    ; R0 has single digit (0-9)
    ADD R0, R0, #'0'    ; Convert to ASCII
    BL send_char
    
    ; Print newline
    LDR R0, =newline
    BL print_string
    
    POP {R0-R5, PC}

; Print a number (0-999)
; R0 = number to print
print_number
    PUSH {R0-R5, LR}
    
    ; Check if 0
    CMP R0, #0
    BNE not_zero
    
    ; Print "0"
    MOV R0, #'0'
    BL send_char
    B number_done
    
not_zero
    ; Count digits
    MOV R4, R0          ; Save number
    MOV R5, #0          ; Digit counter
    
count_loop
    CMP R4, #0
    BEQ counted
    MOV R1, #10
    BL divide_by_10     ; R0 = quotient, R1 = remainder
    MOV R4, R0          ; Update number
    ADD R5, R5, #1      ; Increment counter
    B count_loop
    
counted
    ; R5 = number of digits
    ; Restore original number
    LDR R0, [SP, #0]    ; Get original from stack
    
    ; For 3-digit number
    CMP R5, #3
    BNE check_two
    
    ; Hundreds digit
    MOV R1, #100
    BL divide_simple    ; R0 = hundreds digit
    MOV R3, R0          ; Save hundreds digit
    ADD R0, R3, #'0'
    BL send_char
    
    ; Update number: subtract (hundreds * 100)
    MOV R1, #100
    MUL R2, R3, R1      ; hundreds * 100
    LDR R0, [SP, #0]    ; Get original
    SUB R0, R0, R2
    STR R0, [SP, #0]    ; Update on stack
    MOV R5, #2          ; Now 2 digits left
    
check_two
    CMP R5, #2
    BNE check_one
    
    ; Tens digit
    LDR R0, [SP, #0]    ; Get updated number
    MOV R1, #10
    BL divide_simple    ; R0 = tens digit
    MOV R3, R0          ; Save tens digit
    ADD R0, R3, #'0'
    BL send_char
    
    ; Update number: subtract (tens * 10)
    MOV R1, #10
    MUL R2, R3, R1      ; tens * 10
    LDR R0, [SP, #0]    ; Get current number
    SUB R0, R0, R2
    STR R0, [SP, #0]    ; Update on stack
    
check_one
    ; Ones digit
    LDR R0, [SP, #0]    ; Get final number
    ADD R0, R0, #'0'
    BL send_char
    
number_done
    POP {R0-R5, PC}

; Simple divide: R0 / R1, result in R0, remainder lost
divide_simple
    PUSH {R2}
    MOV R2, #0
div_loop
    CMP R0, R1
    BLT div_done
    SUB R0, R0, R1
    ADD R2, R2, #1
    B div_loop
div_done
    MOV R0, R2
    POP {R2}
    BX LR

; Divide by 10: R0 / 10, quotient in R0, remainder in R1
divide_by_10
    MOV R1, #0
div10_loop
    CMP R0, #10
    BLT div10_done
    SUB R0, R0, #10
    ADD R1, R1, #1
    B div10_loop
div10_done
    ; R0 = remainder, R1 = quotient
    ; Swap to match expected: R0 = quotient, R1 = remainder
    MOV R2, R0
    MOV R0, R1
    MOV R1, R2
    BX LR

; Print string
; R0 = string address
print_string
    PUSH {R0-R2, LR}
    MOV R1, R0
str_loop
    LDRB R0, [R1], #1
    CMP R0, #0
    BEQ str_done
    BL send_char
    B str_loop
str_done
    POP {R0-R2, PC}

; Send one character to ITM
; R0 = character
send_char
    PUSH {R1-R2, LR}
    LDR R1, =ITM_PORT0
    
    ; Wait until ITM port 0 is ready
    ; Check if FIFO is full (bit 0 of ITM Port 31)
wait_fifo
    LDR R2, =0xE0000E7C  ; ITM Port 31 (status port)
    LDR R2, [R2]
    ANDS R2, R2, #1      ; Check bit 0 (FIFO full)
    BNE wait_fifo        ; Wait if FIFO is full
    
    ; Write character
    STR R0, [R1]
    
    ; Small delay to ensure character is sent
    MOV R2, #0x100
delay_loop
    SUBS R2, R2, #1
    BNE delay_loop
    
    POP {R1-R2, PC}

    END