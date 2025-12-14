        AREA Module04, CODE, READONLY
        EXPORT module_four
        
        ; IMPORT variables (define these in data.s)
        IMPORT CLOCK_COUNTER
        IMPORT MED1_INTERVAL
        IMPORT MED1_LAST
        IMPORT MED1_NEXT
        IMPORT MED1_FLAG
        IMPORT MED2_INTERVAL
        IMPORT MED2_LAST
        IMPORT MED2_NEXT
        IMPORT MED2_FLAG
        IMPORT MED3_INTERVAL
        IMPORT MED3_LAST
        IMPORT MED3_NEXT
        IMPORT MED3_FLAG

module_four
    PUSH {LR, R4-R11}
    
    ; Update internal clock counter
    BL update_clock
    
    ; Check each medicine
    BL check_medicine_1
    BL check_medicine_2
    BL check_medicine_3
    
    POP {LR, R4-R11}
    BX LR

; ============================================
; Update internal clock counter
; ============================================
update_clock
    PUSH {R0-R1}
    
    LDR R0, =CLOCK_COUNTER
    LDR R1, [R0]
    ADD R1, R1, #1      ; Increment clock by 1 hour
    STR R1, [R0]
    
    POP {R0-R1}
    BX LR

; ============================================
; Check Medicine 1
; ============================================
check_medicine_1
    PUSH {LR}
    
    LDR R0, =CLOCK_COUNTER
    LDR R0, [R0]        ; Current time
    
    LDR R1, =MED1_LAST
    LDR R1, [R1]        ; Last administered time
    
    LDR R2, =MED1_INTERVAL
    LDR R2, [R2]        ; Dosage interval
    
    ; Compute next due time
    ADD R3, R1, R2      ; next_due_time = last + interval
    
    ; Store next due time
    LDR R4, =MED1_NEXT
    STR R3, [R4]
    
    ; Check if dosage is due
    CMP R0, R3
    BLT med1_not_due
    
    ; Dosage is due - set flag
    MOV R5, #1
    LDR R6, =MED1_FLAG
    STR R5, [R6]
    
    ; Update last administered time to current time
    LDR R6, =MED1_LAST
    STR R0, [R6]
    
    B med1_done
    
med1_not_due
    ; Dosage not due - clear flag
    MOV R5, #0
    LDR R6, =MED1_FLAG
    STR R5, [R6]
    
med1_done
    POP {PC}

; ============================================
; Check Medicine 2
; ============================================
check_medicine_2
    PUSH {LR}
    
    LDR R0, =CLOCK_COUNTER
    LDR R0, [R0]        ; Current time
    
    LDR R1, =MED2_LAST
    LDR R1, [R1]        ; Last administered time
    
    LDR R2, =MED2_INTERVAL
    LDR R2, [R2]        ; Dosage interval
    
    ; Compute next due time
    ADD R3, R1, R2      ; next_due_time = last + interval
    
    ; Store next due time
    LDR R4, =MED2_NEXT
    STR R3, [R4]
    
    ; Check if dosage is due
    CMP R0, R3
    BLT med2_not_due
    
    ; Dosage is due - set flag
    MOV R5, #1
    LDR R6, =MED2_FLAG
    STR R5, [R6]
    
    ; Update last administered time to current time
    LDR R6, =MED2_LAST
    STR R0, [R6]
    
    B med2_done
    
med2_not_due
    ; Dosage not due - clear flag
    MOV R5, #0
    LDR R6, =MED2_FLAG
    STR R5, [R6]
    
med2_done
    POP {PC}

; ============================================
; Check Medicine 3
; ============================================
check_medicine_3
    PUSH {LR}
    
    LDR R0, =CLOCK_COUNTER
    LDR R0, [R0]        ; Current time
    
    LDR R1, =MED3_LAST
    LDR R1, [R1]        ; Last administered time
    
    LDR R2, =MED3_INTERVAL
    LDR R2, [R2]        ; Dosage interval
    
    ; Compute next due time
    ADD R3, R1, R2      ; next_due_time = last + interval
    
    ; Store next due time
    LDR R4, =MED3_NEXT
    STR R3, [R4]
    
    ; Check if dosage is due
    CMP R0, R3
    BLT med3_not_due
    
    ; Dosage is due - set flag
    MOV R5, #1
    LDR R6, =MED3_FLAG
    STR R5, [R6]
    
    ; Update last administered time to current time
    LDR R6, =MED3_LAST
    STR R0, [R6]
    
    B med3_done
    
med3_not_due
    ; Dosage not due - clear flag
    MOV R5, #0
    LDR R6, =MED3_FLAG
    STR R5, [R6]
    
med3_done
    POP {PC}

    END