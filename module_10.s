        AREA UART_Summary, CODE, READONLY
        EXPORT module_ten
        
        ; Import symbols from other modules
        IMPORT TREATMENT_COST
        IMPORT ROOM_COST
        IMPORT MEDICINE_COST
        IMPORT LABTEST_COST
        IMPORT TOTAL_BILL
        IMPORT patient_id1
        IMPORT patient_alert_count1
        IMPORT patient1_name
        
        ; ITM Port 0 address (for printf in Keil)
ITM_PORT0       EQU 0xE0000000
ITM_TER0        EQU 0xE0000E00  ; ITM Trace Enable Register
ITM_TPR         EQU 0xE0000E40  ; ITM Trace Privilege Register
ITM_TCR         EQU 0xE0000E80  ; ITM Trace Control Register

        ; Strings
title           DCB "Patient 1 Summary\r\n", 0
sep             DCB "--------------------\r\n", 0
id_str          DCB "ID: ", 0
name_str        DCB "Name: ", 0
alert_str       DCB "Alerts: ", 0
bill_str        DCB "Bill Details:\r\n", 0
treat_str       DCB "  Treatment: $", 0
room_str        DCB "  Room: $", 0
med_str         DCB "  Medicine: $", 0
lab_str         DCB "  Lab: $", 0
total_str       DCB "  TOTAL: $", 0
newline         DCB "\r\n", 0

        AREA |.text|, CODE, READONLY
        EXPORT module_ten
  

module_ten
    ; Initialize ITM for debug output
    BL init_itm
    
    ; Generate summary for Patient 1
    BL print_summary
    
    BX LR    ; Return to caller instead of infinite loop

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
    
    ; Print Patient Name
    LDR R0, =name_str
    BL print_string
    LDR R0, =patient1_name
    BL print_string
    LDR R0, =newline
    BL print_string
    
    ; Print Patient ID
    LDR R0, =id_str
    BL print_string
    LDR R0, =patient_id1
    LDR R0, [R0]
    BL print_hex_number
    LDR R0, =newline
    BL print_string
    
    ; Print Alert Count
    LDR R0, =alert_str
    BL print_string
    LDR R0, =patient_alert_count1
    LDR R0, [R0]
    BL print_number
    LDR R0, =newline
    BL print_string
    
    ; Print billing header
    LDR R0, =newline
    BL print_string
    LDR R0, =bill_str
    BL print_string
    
    ; Print Treatment Cost
    LDR R0, =treat_str
    BL print_string
    LDR R0, =TREATMENT_COST
    LDR R0, [R0]
    BL print_bill_amount
    LDR R0, =newline
    BL print_string
    
    ; Print Room Cost
    LDR R0, =room_str
    BL print_string
    LDR R0, =ROOM_COST
    LDR R0, [R0]
    BL print_bill_amount
    LDR R0, =newline
    BL print_string
    
    ; Print Medicine Cost
    LDR R0, =med_str
    BL print_string
    LDR R0, =MEDICINE_COST
    LDR R0, [R0]
    BL print_bill_amount
    LDR R0, =newline
    BL print_string
    
    ; Print Lab Test Cost
    LDR R0, =lab_str
    BL print_string
    LDR R0, =LABTEST_COST
    LDR R0, [R0]
    BL print_bill_amount
    LDR R0, =newline
    BL print_string
    
    ; Print Total Bill
    LDR R0, =total_str
    BL print_string
    LDR R0, =TOTAL_BILL
    LDR R0, [R0]
    BL print_bill_amount
    
    POP {PC}

; Print bill amount as dollars.cents
; R0 = amount in cents
print_bill_amount
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
    MOV R0, R2
    CMP R0, #10
    BGE print_two_digits
    
    ; Print leading zero
    MOV R0, #'0'
    BL send_char
    
    ; Print cents digit
    MOV R0, R2
    ADD R0, R0, #'0'
    BL send_char
    B cents_done
    
print_two_digits
    ; R0 has cents (10-99)
    MOV R4, R0          ; Save cents
    MOV R5, #10         ; Divisor
    
    ; Get tens digit
    MOV R1, R5
    BL divide_simple    ; R0 = tens digit
    MOV R3, R0          ; Save tens digit
    
    ; Print tens digit
    ADD R0, R3, #'0'
    BL send_char
    
    ; Calculate ones digit: cents - (tens * 10)
    MOV R0, R3
    MUL R0, R0, R5      ; tens * 10
    SUB R0, R4, R0      ; cents - (tens * 10)
    
    ; Print ones digit
    ADD R0, R0, #'0'
    BL send_char
    
cents_done
    POP {R0-R5, PC}

; SIMPLIFIED: Print a decimal number (0-9999)
; R0 = number to print
print_number
    PUSH {R0-R5, LR}
    
    ; Check if zero
    CMP R0, #0
    BNE not_zero
    
    MOV R0, #'0'
    BL send_char
    B number_done
    
not_zero
    ; For simplicity, handle numbers up to 9999 with manual checking
    CMP R0, #1000
    BGE handle_1000_to_9999
    CMP R0, #100
    BGE handle_100_to_999
    CMP R0, #10
    BGE handle_10_to_99
    
    ; Single digit (1-9)
    ADD R0, R0, #'0'
    BL send_char
    B number_done
    
handle_10_to_99
    ; Two digits (10-99)
    MOV R4, R0          ; Save number
    MOV R1, #10
    BL divide_simple    ; R0 = tens digit
    MOV R5, R0          ; Save tens digit
    ADD R0, R5, #'0'
    BL send_char
    
    ; Get ones digit
    MOV R0, R5
    MOV R1, #10
    MUL R0, R0, R1      ; tens * 10
    SUB R0, R4, R0      ; remainder = ones digit
    ADD R0, R0, #'0'
    BL send_char
    B number_done
    
handle_100_to_999
    ; Three digits (100-999)
    MOV R4, R0          ; Save number
    MOV R1, #100
    BL divide_simple    ; R0 = hundreds digit
    MOV R5, R0          ; Save hundreds digit
    ADD R0, R5, #'0'
    BL send_char
    
    ; Get remaining two digits
    MOV R0, R5
    MOV R1, #100
    MUL R0, R0, R1      ; hundreds * 100
    SUB R0, R4, R0      ; remainder (0-99)
    
    ; Print remainder as two-digit number
    MOV R4, R0          ; Save remainder
    MOV R1, #10
    BL divide_simple    ; R0 = tens digit
    MOV R5, R0          ; Save tens digit
    ADD R0, R5, #'0'
    BL send_char
    
    ; Get ones digit
    MOV R0, R5
    MOV R1, #10
    MUL R0, R0, R1      ; tens * 10
    SUB R0, R4, R0      ; remainder = ones digit
    ADD R0, R0, #'0'
    BL send_char
    B number_done
    
handle_1000_to_9999
    ; Four digits (1000-9999)
    MOV R4, R0          ; Save number
    MOV R1, #1000
    BL divide_simple    ; R0 = thousands digit
    MOV R5, R0          ; Save thousands digit
    ADD R0, R5, #'0'
    BL send_char
    
    ; Get remaining three digits
    MOV R0, R5
    MOV R1, #1000
    MUL R0, R0, R1      ; thousands * 1000
    SUB R0, R4, R0      ; remainder (0-999)
    
    ; Save and recursively print remainder
    PUSH {R0}
    MOV R0, R0
    BL print_number     ; Recursive call for remainder
    POP {R0}
    
number_done
    POP {R0-R5, PC}

; Print hex number (for patient ID)
; R0 = hex number to print
print_hex_number
    PUSH {R0-R4, LR}
    
    ; Print "0x" prefix
    MOV R0, #'0'
    BL send_char
    MOV R0, #'x'
    BL send_char
    
    MOV R4, #28         ; Start with most significant nibble
    
hex_loop
    MOV R3, R0          ; Copy to R3
    LSR R3, R4          ; Shift to get current nibble
    AND R3, R3, #0xF    ; Mask to get 4 bits
    
    ; Convert to ASCII
    CMP R3, #9
    BGT hex_letter
    ADD R3, #'0'
    B print_hex_char
    
hex_letter
    SUB R3, #10
    ADD R3, #'A'
    
print_hex_char
    MOV R0, R3
    BL send_char
    
    SUBS R4, #4
    BPL hex_loop
    
    POP {R0-R4, PC}

; Simple divide: R0 / R1, result in R0
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

; Print string
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
send_char
    PUSH {R1-R2, LR}
    LDR R1, =ITM_PORT0
    
wait_fifo
    LDR R2, =0xE0000E7C  ; ITM Port 31 (status port)
    LDR R2, [R2]
    ANDS R2, R2, #1      ; Check bit 0 (FIFO full)
    BNE wait_fifo        ; Wait if FIFO is full
    
    STR R0, [R1]
    
    MOV R2, #0x100
delay_loop
    SUBS R2, R2, #1
    BNE delay_loop
    
    POP {R1-R2, PC}

    END