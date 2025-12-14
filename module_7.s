        AREA Module07, CODE, READONLY
        EXPORT module_seven
        
        ; IMPORT variables from data.s
        IMPORT MED_LIST
        IMPORT NUM_MEDS
        IMPORT TOTAL_MED_COST

module_seven
    PUSH {LR, R4-R11}      ; Save registers
    
    ; Compute medicine bill
    BL Compute_Medicine_Bill
    
    POP {LR, R4-R11}       ; Restore registers
    BX LR                  ; Return to main

; ============================================
; Compute_Medicine_Bill
; Calculates: total_cost = Σ(price × quantity × days)
; for each medicine in MED_LIST
; ============================================
Compute_Medicine_Bill
    PUSH {R4-R8, LR}
    
    ; Load pointer to medicine list
    LDR R0, =MED_LIST
    
    ; Load number of medicines
    LDR R1, =NUM_MEDS
    LDR R1, [R1]           ; R1 = number of medicines
    
    ; Initialize total cost to 0
    MOV R7, #0             ; R7 = total_cost = 0
    
    ; Check if there are any medicines
    CMP R1, #0
    BEQ finish             ; If no medicines, skip calculation
    
    ; Loop through each medicine
    MOV R4, #0             ; R4 = i = 0 (loop counter)

loop_start
    ; Check if we've processed all medicines
    CMP R4, R1
    BGE finish
    
    ; Each medicine entry is 12 bytes (3 words × 4 bytes)
    ; Calculate offset: i * 12
    MOV R5, #12
    MUL R6, R4, R5         ; R6 = i * 12
    
    ; Get address of current medicine
    ADD R6, R0, R6         ; R6 = &MED_LIST[i]
    
    ; Load medicine details
    LDR R8, [R6]           ; R8 = unit_price
    LDR R5, [R6, #4]       ; R5 = quantity
    LDR R3, [R6, #8]       ; R3 = days
    
    ; Calculate: med_cost = price × quantity × days
    MUL R8, R8, R5         ; R8 = price × quantity
    MUL R8, R8, R3         ; R8 = (price × quantity) × days
    
    ; Add to total cost
    ADD R7, R7, R8         ; total_cost += med_cost
    
    ; Increment counter
    ADD R4, R4, #1         ; i++
    
    B loop_start

finish
    ; Store final total cost
    LDR R0, =TOTAL_MED_COST
    STR R7, [R0]
    
    POP {R4-R8, PC}

    END