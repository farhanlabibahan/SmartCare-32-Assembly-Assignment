        AREA Module08, CODE, READONLY
        EXPORT module_eight
        IMPORT TREATMENT_COST   
        IMPORT ROOM_COST    
        IMPORT MEDICINE_COST
        IMPORT LABTEST_COST
        IMPORT TOTAL_BILL
        IMPORT ERROR_FLAG

module_eight
    PUSH {LR, R4-R11}      ; Save registers
    
    ; Compute total bill
    BL Compute_Total_Bill
    
    POP {LR, R4-R11}       ; Restore registers
    BX LR                  ; Return to main

; Compute_Total_Billll
; TOTAL: total = treatment + room + medicine + labtest
; Settts ERROR_FLAG if overflow occurs

Compute_Total_Bill
    PUSH {R4-R7, LR}
    
    ; Clear error flag
    MOV R7, #0
    LDR R0, =ERROR_FLAG
    STR R7, [R0]
    
    ; Load all cost components
    LDR R0, =TREATMENT_COST
    LDR R1, [R0]           ; R1 = treatment cost
    
    LDR R0, =ROOM_COST
    LDR R2, [R0]           ; R2 = room cost
    
    LDR R0, =MEDICINE_COST
    LDR R3, [R0]           ; R3 = medicine cost
    
    LDR R0, =LABTEST_COST
    LDR R4, [R0]           ; R4 = lab test cost
    
    ; Initialize total to 0
    MOV R5, #0             ; R5 = total bill
    
    ; Add treatment cost
    ADDS R5, R5, R1
    BCS overflow           ; Check for overflow
    
    ; Add room cost
    ADDS R5, R5, R2
    BCS overflow           
    
    ; Add medicine cost
    ADDS R5, R5, R3
    BCS overflow           
    
    ; Add lab test cost
    ADDS R5, R5, R4
    BCS overflow           
    
    ; Store result - no overflow occurred
    LDR R0, =TOTAL_BILL
    STR R5, [R0]
    
    POP {R4-R7, PC}

overflow
    ; Set error flag
    MOV R7, #1
    LDR R0, =ERROR_FLAG
    STR R7, [R0]
    
    ; Set total bill to 0 or max value
    MOV R5, #0
    LDR R0, =TOTAL_BILL
    STR R5, [R0]
    
    POP {R4-R7, PC}

    END