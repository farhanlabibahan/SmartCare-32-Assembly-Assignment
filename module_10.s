AREA myData, DATA, READWRITE
        ALIGN 4

; Patient Structure (simple version)
patient_id      DCD 1001        ; Patient ID
patient_age     DCD 65          ; Age
patient_ward    DCD 7           ; Ward
patient_hr      DCD 130         ; Heart Rate
patient_o2      DCD 95          ; O2 Level
patient_alerts  DCD 3           ; Alert Count
patient_bill    DCD 12500       ; Billing $125.00 (in cents)

; ITM Port 0 address (for printf in Keil)
ITM_PORT0   EQU 0xE0000000

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
    ; Generate summary for 1 patient
    BL print_summary
    
stop
    B stop

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
    PUSH {R0-R2, LR}
    
    ; Get dollars (divide by 100)
    MOV R1, #100
    MOV R2, #0          ; Counter for dollars
    
dollar_loop
    CMP R0, R1
    BLT dollars_done
    SUB R0, R0, R1      ; Subtract 100 cents
    ADD R2, R2, #1      ; Count dollars
    B dollar_loop
    
dollars_done
    ; R2 = dollars, R0 = remaining cents
    
    ; Print dollars
    MOV R0, R2
    BL print_number
    
    ; Print decimal point
    MOV R0, #'.'
    BL send_char
    
    ; Print cents (always 2 digits)
    POP {R0-R2, LR}
    PUSH {R0-R2, LR}
    
    ; Get cents again
    LDR R0, =patient_bill
    LDR R0, [R0]
    MOV R1, #100
    
    ; Find remainder (cents)
cent_loop
    CMP R0, R1
    BLT cents_done
    SUB R0, R0, R1
    B cent_loop
    
cents_done
    ; R0 = cents (0-99)
    
    ; Check if less than 10
    CMP R0, #10
    BGE print_two_digits
    
    ; Print leading zero
    MOV R1, #'0'
    MOV R0, R1
    BL send_char
    
    ; Get cents value again
    LDR R0, =patient_bill
    LDR R0, [R0]
    MOV R1, #100
    
last_cent_loop
    CMP R0, R1
    BLT last_cents_done
    SUB R0, R0, R1
    B last_cent_loop
    
last_cents_done
    ; Now print the cents digit
    B print_one_digit
    
print_two_digits
    ; R0 has cents (10-99)
    ; Need to print tens digit and ones digit
    
    ; Save original
    MOV R2, R0
    
    ; Get tens digit (divide by 10)
    MOV R1, #10
    MOV R3, #0          ; Tens counter
    
tens_loop
    CMP R2, R1
    BLT tens_done
    SUB R2, R2, R1
    ADD R3, R3, #1
    B tens_loop
    
tens_done
    ; R3 = tens digit
    MOV R0, R3
    ADD R0, R0, #'0'    ; Convert to ASCII
    BL send_char
    
    ; Get ones digit
    MOV R1, #10
    MUL R3, R3, R1      ; tens * 10
    LDR R0, =patient_bill
    LDR R0, [R0]
    MOV R1, #100
    
final_cent_loop
    CMP R0, R1
    BLT final_cents_done
    SUB R0, R0, R1
    B final_cent_loop
    
final_cents_done
    SUB R0, R0, R3      ; Subtract tens part
    B print_one_digit
    
print_one_digit
    ; R0 has single digit (0-9)
    ADD R0, R0, #'0'    ; Convert to ASCII
    BL send_char
    
    ; Print newline
    LDR R0, =newline
    BL print_string
    
    POP {R0-R2, PC}

; Print a number (0-999)
; R0 = number to print
print_number
    PUSH {R0-R4, LR}
    
    ; Check if 0
    CMP R0, #0
    BNE not_zero
    
    ; Print "0"
    MOV R0, #'0'
    BL send_char
    B number_done
    
not_zero
    ; Count digits
    MOV R1, R0
    MOV R2, #0          ; Digit counter
    
count_loop
    CMP R1, #0
    BEQ counted
    MOV R3, #10
    BL divide_simple
    ADD R2, R2, #1
    B count_loop
    
counted
    ; R2 = number of digits
    
    ; Print digits in correct order
    MOV R4, R0          ; Save number
    
    ; For 3-digit number
    CMP R2, #3
    BNE check_two
    
    ; Hundreds digit
    MOV R0, R4
    MOV R1, #100
    BL divide_simple    ; R0 = hundreds digit
    ADD R0, R0, #'0'
    BL send_char
    
    ; Update number
    MOV R1, #100
    MUL R0, R0, R1
    SUB R4, R4, R0
    MOV R2, #2          ; Now 2 digits left
    
check_two
    CMP R2, #2
    BNE check_one
    
    ; Tens digit
    MOV R0, R4
    MOV R1, #10
    BL divide_simple    ; R0 = tens digit
    ADD R0, R0, #'0'
    BL send_char
    
    ; Update number
    MOV R1, #10
    MUL R0, R0, R1
    SUB R4, R4, R0
    
check_one
    ; Ones digit
    MOV R0, R4
    ADD R0, R0, #'0'
    BL send_char
    
number_done
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
; R0 = string address
print_string
    PUSH {R0-R1, LR}
    MOV R1, R0
str_loop
    LDRB R0, [R1], #1
    CMP R0, #0
    BEQ str_done
    BL send_char
    B str_loop
str_done
    POP {R0-R1, PC}

; Send one character to ITM
; R0 = character
send_char
    PUSH {R1}
    LDR R1, =ITM_PORT0
    STR R0, [R1]
    POP {R1}
    BX LR

    END