        AREA Module10, CODE, READONLY
        EXPORT module_ten
        
        ; Import ALL available data from data.s
        IMPORT patient1_name
        IMPORT patient2_name
        IMPORT patient3_name
        IMPORT patient_id1
        IMPORT patient_id2
        IMPORT patient_id3
        IMPORT patient_alert_count1
        IMPORT patient_alert_count2
        IMPORT patient_alert_count3
        IMPORT TOTAL_BILL
        IMPORT HR1_data
        IMPORT BP1_data
        IMPORT O21_data
        IMPORT HR2_data
        IMPORT BP2_data
        IMPORT O22_data
        IMPORT HR3_data
        IMPORT BP3_data
        IMPORT O23_data
        IMPORT debug_send    ; Use your existing debug output

module_ten
    PUSH {LR, R4-R11}
    
    ; Print summary for Patient 1
    MOV R0, #1
    BL print_patient_summary
    
    POP {LR, R4-R11}
    BX LR

; ============================================
; Print summary for a specific patient
; R0 = patient number (1-3)
; ============================================
print_patient_summary
    PUSH {LR, R4-R11}
    MOV R4, R0          ; Save patient number
    
    ; Print header
    BL print_newline
    MOV R0, #'='
    MOV R1, #40
    BL print_repeat_char
    BL print_newline
    
    ; Print "PATIENT SUMMARY"
    MOV R0, #'P'
    BL debug_send
    MOV R0, #'A'
    BL debug_send
    MOV R0, #'T'
    BL debug_send
    MOV R0, #'I'
    BL debug_send
    MOV R0, #'E'
    BL debug_send
    MOV R0, #'N'
    BL debug_send
    MOV R0, #'T'
    BL debug_send
    MOV R0, #' '
    BL debug_send
    
    ; Print patient number
    MOV R0, R4
    ADD R0, R0, #'0'
    BL debug_send
    
    MOV R0, #' '
    BL debug_send
    MOV R0, #'S'
    BL debug_send
    MOV R0, #'U'
    BL debug_send
    MOV R0, #'M'
    BL debug_send
    MOV R0, #'M'
    BL debug_send
    MOV R0, #'A'
    BL debug_send
    MOV R0, #'R'
    BL debug_send
    MOV R0, #'Y'
    BL debug_send
    BL print_newline
    
    MOV R0, #'='
    MOV R1, #40
    BL print_repeat_char
    BL print_newline
    
    ; Print Name
    BL print_name
    MOV R0, R4
    BL get_patient_name
    BL print_string
    BL print_newline
    
    ; Print ID
    BL print_id
    MOV R0, R4
    BL get_patient_id
    BL print_hex
    BL print_newline
    
    ; Print Latest Vitals
    BL print_vitals_header
    BL print_newline
    
    ; Print HR
    BL print_hr
    MOV R0, R4
    BL get_patient_hr
    BL print_number
    MOV R0, #' '
    BL debug_send
    MOV R0, #'b'
    BL debug_send
    MOV R0, #'p'
    BL debug_send
    MOV R0, #'m'
    BL debug_send
    BL print_newline
    
    ; Print BP
    BL print_bp
    MOV R0, R4
    BL get_patient_bp
    BL print_number
    MOV R0, #' '
    BL debug_send
    MOV R0, #'m'
    BL debug_send
    MOV R0, #'m'
    BL debug_send
    MOV R0, #'H'
    BL debug_send
    MOV R0, #'g'
    BL debug_send
    BL print_newline
    
    ; Print O2
    BL print_o2
    MOV R0, R4
    BL get_patient_o2
    BL print_number
    MOV R0, #'%'
    BL debug_send
    BL print_newline
    
    ; Print Alert Count
    BL print_alerts
    MOV R0, R4
    BL get_patient_alert_count
    BL print_number
    BL print_newline
    
    ; Print Total Bill (same for all patients from module 8)
    BL print_bill
    LDR R0, =TOTAL_BILL
    LDR R0, [R0]
    BL print_bill_amount
    BL print_newline
    
    MOV R0, #'='
    MOV R1, #40
    BL print_repeat_char
    BL print_newline
    
    POP {LR, R4-R11}
    BX LR

; ============================================
; Data access functions
; ============================================

; Get patient name address
; R0 = patient number (1-3)
; Returns: R0 = address of name string
get_patient_name
    CMP R0, #1
    BNE check_patient2_name
    LDR R0, =patient1_name
    BX LR
    
check_patient2_name
    CMP R0, #2
    BNE patient3_name_fun
    LDR R0, =patient2_name
    BX LR
    
patient3_name_fun
    LDR R0, =patient3_name
    BX LR

; Get patient ID
; R0 = patient number (1-3)
; Returns: R0 = patient ID value
get_patient_id
    CMP R0, #1
    BNE check_patient2_id
    LDR R0, =patient_id1
    LDR R0, [R0]
    BX LR
    
check_patient2_id
    CMP R0, #2
    BNE patient3_id
    LDR R0, =patient_id2
    LDR R0, [R0]
    BX LR
    
patient3_id
    LDR R0, =patient_id3
    LDR R0, [R0]
    BX LR

; Get patient alert count
; R0 = patient number (1-3)
; Returns: R0 = alert count
get_patient_alert_count
    CMP R0, #1
    BNE check_patient2_alerts
    LDR R0, =patient_alert_count1
    LDR R0, [R0]
    BX LR
    
check_patient2_alerts
    CMP R0, #2
    BNE patient3_alerts
    LDR R0, =patient_alert_count2
    LDR R0, [R0]
    BX LR
    
patient3_alerts
    LDR R0, =patient_alert_count3
    LDR R0, [R0]
    BX LR

; Get patient HR
; R0 = patient number (1-3)
; Returns: R0 = HR value
get_patient_hr
    CMP R0, #1
    BNE check_patient2_hr
    LDR R0, =HR1_data
    LDR R0, [R0]
    BX LR
    
check_patient2_hr
    CMP R0, #2
    BNE patient3_hr
    LDR R0, =HR2_data
    LDR R0, [R0]
    BX LR
    
patient3_hr
    LDR R0, =HR3_data
    LDR R0, [R0]
    BX LR

; Get patient BP
; R0 = patient number (1-3)
; Returns: R0 = BP value
get_patient_bp
    CMP R0, #1
    BNE check_patient2_bp
    LDR R0, =BP1_data
    LDR R0, [R0]
    BX LR
    
check_patient2_bp
    CMP R0, #2
    BNE patient3_bp
    LDR R0, =BP2_data
    LDR R0, [R0]
    BX LR
    
patient3_bp
    LDR R0, =BP3_data
    LDR R0, [R0]
    BX LR

; Get patient O2
; R0 = patient number (1-3)
; Returns: R0 = O2 value
get_patient_o2
    CMP R0, #1
    BNE check_patient2_o2
    LDR R0, =O21_data
    LDR R0, [R0]
    BX LR
    
check_patient2_o2
    CMP R0, #2
    BNE patient3_o2
    LDR R0, =O22_data
    LDR R0, [R0]
    BX LR
    
patient3_o2
    LDR R0, =O23_data
    LDR R0, [R0]
    BX LR

; ============================================
; Label printing functions
; ============================================

print_name
    PUSH {R0, LR}
    MOV R0, #'N'
    BL debug_send
    MOV R0, #'a'
    BL debug_send
    MOV R0, #'m'
    BL debug_send
    MOV R0, #'e'
    BL debug_send
    MOV R0, #':'
    BL debug_send
    MOV R0, #' '
    BL debug_send
    POP {R0, PC}

print_id
    PUSH {R0, LR}
    MOV R0, #'I'
    BL debug_send
    MOV R0, #'D'
    BL debug_send
    MOV R0, #':'
    BL debug_send
    MOV R0, #' '
    BL debug_send
    POP {R0, PC}

print_vitals_header
    PUSH {R0, LR}
    MOV R0, #'V'
    BL debug_send
    MOV R0, #'i'
    BL debug_send
    MOV R0, #'t'
    BL debug_send
    MOV R0, #'a'
    BL debug_send
    MOV R0, #'l'
    BL debug_send
    MOV R0, #'s'
    BL debug_send
    MOV R0, #':'
    BL debug_send
    POP {R0, PC}

print_hr
    PUSH {R0, LR}
    MOV R0, #' '
    BL debug_send
    MOV R0, #' '
    BL debug_send
    MOV R0, #'H'
    BL debug_send
    MOV R0, #'R'
    BL debug_send
    MOV R0, #':'
    BL debug_send
    MOV R0, #' '
    BL debug_send
    POP {R0, PC}

print_bp
    PUSH {R0, LR}
    MOV R0, #' '
    BL debug_send
    MOV R0, #' '
    BL debug_send
    MOV R0, #'B'
    BL debug_send
    MOV R0, #'P'
    BL debug_send
    MOV R0, #':'
    BL debug_send
    MOV R0, #' '
    BL debug_send
    POP {R0, PC}

print_o2
    PUSH {R0, LR}
    MOV R0, #' '
    BL debug_send
    MOV R0, #' '
    BL debug_send
    MOV R0, #'O'
    BL debug_send
    MOV R0, #'2'
    BL debug_send
    MOV R0, #':'
    BL debug_send
    MOV R0, #' '
    BL debug_send
    POP {R0, PC}

print_alerts
    PUSH {R0, LR}
    MOV R0, #'A'
    BL debug_send
    MOV R0, #'l'
    BL debug_send
    MOV R0, #'e'
    BL debug_send
    MOV R0, #'r'
    BL debug_send
    MOV R0, #'t'
    BL debug_send
    MOV R0, #'s'
    BL debug_send
    MOV R0, #':'
    BL debug_send
    MOV R0, #' '
    BL debug_send
    POP {R0, PC}

print_bill
    PUSH {R0, LR}
    MOV R0, #'B'
    BL debug_send
    MOV R0, #'i'
    BL debug_send
    MOV R0, #'l'
    BL debug_send
    MOV R0, #'l'
    BL debug_send
    MOV R0, #':'
    BL debug_send
    MOV R0, #' '
    BL debug_send
    MOV R0, #'$'
    BL debug_send
    POP {R0, PC}

; ============================================
; Utility functions
; ============================================

print_newline
    PUSH {R0, LR}
    MOV R0, #'\r'
    BL debug_send
    MOV R0, #'\n'
    BL debug_send
    POP {R0, PC}

print_repeat_char
    ; R0 = character, R1 = count
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

print_string
    PUSH {R0-R1, LR}
    MOV R1, R0
str_loop
    LDRB R0, [R1], #1
    CMP R0, #0
    BEQ str_done
    BL debug_send
    B str_loop
str_done
    POP {R0-R1, PC}

print_hex
    PUSH {R0-R4, LR}
    MOV R4, #28
    
    ; Print "0x"
    MOV R0, #'0'
    BL debug_send
    MOV R0, #'x'
    BL debug_send
    
    MOV R3, R0          ; Save original value
    
hex_loop
    MOV R2, R3
    LSR R2, R4
    AND R2, R2, #0xF
    
    CMP R2, #9
    BGT hex_alpha
    ADD R2, #'0'
    B print_hex_digit
    
hex_alpha
    SUB R2, #10
    ADD R2, #'A'
    
print_hex_digit
    MOV R0, R2
    BL debug_send
    
    SUBS R4, #4
    BPL hex_loop
    
    POP {R0-R4, PC}

print_number
    PUSH {R0-R2, LR}
    
    CMP R0, #0
    BNE not_zero
    
    MOV R0, #'0'
    BL debug_send
    B number_done
    
not_zero
    ; Handle up to 3 digits (vitals are 0-999)
    MOV R1, R0
    MOV R2, #100
    
    CMP R1, R2
    BLT less_than_100
    
    ; Hundreds digit
    MOV R0, R1
    BL divide_simple
    ADD R0, R0, #'0'
    BL debug_send
    
    ; Update remainder
    MOV R2, #100
    MUL R2, R0, R2
    SUB R1, R1, R2
    
less_than_100
    MOV R2, #10
    CMP R1, R2
    BLT less_than_10
    
    ; Tens digit
    MOV R0, R1
    MOV R1, #10
    BL divide_simple
    ADD R0, R0, #'0'
    BL debug_send
    
    ; Ones digit
    MOV R0, R1          ; Remainder
    ADD R0, R0, #'0'
    BL debug_send
    B number_done
    
less_than_10
    ; Single digit
    MOV R0, R1
    ADD R0, R0, #'0'
    BL debug_send
    
number_done
    POP {R0-R2, PC}

print_bill_amount
    PUSH {R0-R4, LR}
    
    ; R0 = cents
    MOV R4, R0
    
    ; Dollars = cents / 100
    MOV R1, #100
    BL divide_simple    ; R0 = dollars
    BL print_number
    
    ; Decimal point
    MOV R0, #'.'
    BL debug_send
    
    ; Cents remainder
    MOV R0, R4
    MOV R1, #100
    BL divide_simple    ; R0 = dollars, R1 = remainder
    
    ; Ensure 2 digits
    MOV R0, R1
    CMP R0, #10
    BGE two_digits_cents
    
    ; Leading zero
    MOV R0, #'0'
    BL debug_send
    
    ; Ones digit
    MOV R0, R1
    ADD R0, R0, #'0'
    BL debug_send
    B bill_amount_done
    
two_digits_cents
    MOV R0, R1
    BL print_number
    
bill_amount_done
    POP {R0-R4, PC}

divide_simple
    PUSH {R2}
    MOV R2, #0
divide_loop
    CMP R0, R1
    BLT divide_done
    SUB R0, R0, R1
    ADD R2, R2, #1
    B divide_loop
divide_done
    MOV R1, R0          ; Remainder
    MOV R0, R2          ; Quotient
    POP {R2}
    BX LR

    END