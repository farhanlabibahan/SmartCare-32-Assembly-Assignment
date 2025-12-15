        AREA Module10, CODE, READONLY
        EXPORT module_ten
        IMPORT patient1_name
        IMPORT patient_id1
        IMPORT patient1_age
        IMPORT patient1_ward
        IMPORT patient_alert_count1
        IMPORT HR1_data
        IMPORT BP1_data
        IMPORT O21_data
        IMPORT TOTAL_BILL
        IMPORT debug_send

module_ten
    PUSH {LR, R4-R11}
    
    ; Print ICU header
    BL print_icu_header
    
    ; Print summary for Patient 1 only
    BL print_patient1_summary
    
    POP {LR, R4-R11}
    BX LR


print_icu_header
    PUSH {LR}
        LDR R0, =icu_header
    BL print_string
    BL print_newline
    
    ; Print separator line
    MOV R0, #'-'
    MOV R1, #22
    BL print_repeat_char
    BL print_newline
    
    POP {PC}

print_patient1_summary
    PUSH {LR}
    
    ; Print ID
    LDR R0, =id_label
    BL print_string
    LDR R0, =patient_id1
    LDR R0, [R0]
    BL print_number
    BL print_newline
    
    ; Print Name
    LDR R0, =name_label
    BL print_string
    LDR R0, =patient1_name
    BL print_string
    BL print_newline
    
    ; Print Age
    LDR R0, =age_label
    BL print_string
    LDR R0, =patient1_age
    LDR R0, [R0]
    BL print_number
    BL print_newline
    
    ; Print Ward
    LDR R0, =ward_label
    BL print_string
    LDR R0, =patient1_ward
    LDR R0, [R0]
    BL print_number
    BL print_newline
    
    ; Print HR
    LDR R0, =hr_label
    BL print_string
    LDR R0, =HR1_data
    LDR R0, [R0]
    BL print_number
    BL print_newline
    
    ; Print BP
    LDR R0, =bp_label
    BL print_string
    LDR R0, =BP1_data
    LDR R0, [R0]
    BL print_number
    BL print_newline
    
    ; Print O2
    LDR R0, =o2_label
    BL print_string
    LDR R0, =O21_data
    LDR R0, [R0]
    BL print_number
    BL print_newline
    
    ; Print Alerts
    LDR R0, =alerts_label
    BL print_string
    LDR R0, =patient_alert_count1
    LDR R0, [R0]
    BL print_number
    BL print_newline
    
    ; Print Bill
    LDR R0, =bill_label
    BL print_string
    LDR R0, =TOTAL_BILL
    LDR R0, [R0]
    BL print_bill_amount
    BL print_newline
    
    ; Print separator
    MOV R0, #'-'
    MOV R1, #22
    BL print_repeat_char
    BL print_newline
    
    POP {PC}


print_string
    PUSH {R1, LR}
    MOV R1, R0
print_str_loop
    LDRB R0, [R1], #1
    CMP R0, #0
    BEQ print_str_done
    BL debug_send
    B print_str_loop
print_str_done
    POP {R1, PC}

print_newline
    PUSH {LR}
    MOV R0, #'\r'
    BL debug_send
    MOV R0, #'\n'
    BL debug_send
    POP {PC}

print_repeat_char
    PUSH {R0-R2, LR}
    MOV R2, R1
repeat_loop
    CMP R2, #0
    BEQ repeat_done
    BL debug_send
    SUBS R2, R2, #1
    B repeat_loop
repeat_done
    POP {R0-R2, PC}

print_number
    PUSH {R0-R2, LR}
    
    CMP R0, #0
    BNE not_zero
    
    MOV R0, #'0'
    BL debug_send
    B number_done
    
not_zero
    MOV R1, R0
    
    ; Hundreds
    CMP R1, #100
    BLT less_than_100
    MOV R0, R1
    MOV R2, #100
    BL simple_divide
    MOV R2, R1          ; Save remainder
    ADD R0, #'0'
    BL debug_send
    MOV R1, R2          ; Restore remainder
    
less_than_100
    ; Tens
    CMP R1, #10
    BLT less_than_10
    MOV R0, R1
    MOV R2, #10
    BL simple_divide
    MOV R2, R1          ; Save ones
    ADD R0, #'0'
    BL debug_send
    MOV R0, R2          ; Get ones
    ADD R0, #'0'
    BL debug_send
    B number_done
    
less_than_10
    ; Single digit
    MOV R0, R1
    ADD R0, #'0'
    BL debug_send
    
number_done
    POP {R0-R2, PC}

simple_divide
    ; R0 / R2, quotient in R0, remainder in R1
    PUSH {R3}
    MOV R3, #0
div_loop
    CMP R0, R2
    BLT div_done
    SUB R0, R0, R2
    ADD R3, R3, #1
    B div_loop
div_done
    MOV R1, R0      ; Remainder
    MOV R0, R3      ; Quotient
    POP {R3}
    BX LR

print_bill_amount
    PUSH {R0-R4, LR}
    
    ; R0 = cents
    MOV R4, R0
    
    ; Dollars (cents / 100)
    MOV R1, #100
    BL simple_divide    ; R0 = dollars, R1 = cents remainder
    
    ; Print dollars
    PUSH {R1}
    BL print_number
    POP {R1}
    
    ; Decimal point
    MOV R0, #'.'
    BL debug_send
    
    ; Print cents (2 digits)
    MOV R0, R1
    CMP R0, #10
    BGE two_digits
    
    ; One digit with leading zero
    MOV R0, #'0'
    BL debug_send
    MOV R0, R1
    ADD R0, #'0'
    BL debug_send
    B bill_done
    
two_digits
    BL print_number
    
bill_done
    POP {R0-R4, PC}


; String Data

icu_header   DCB "ICU PATIENT SUMMARY", 0
id_label     DCB "ID: ", 0
name_label   DCB "Name: ", 0
age_label    DCB "Age: ", 0
ward_label   DCB "Ward: ", 0
hr_label     DCB "HR: ", 0
bp_label     DCB "BP: ", 0
o2_label     DCB "O2: ", 0
alerts_label DCB "Alerts: ", 0
bill_label   DCB "Bill: $", 0

    ALIGN 4
    LTORG

    END