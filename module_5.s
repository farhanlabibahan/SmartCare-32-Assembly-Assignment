        AREA Module05, CODE, READONLY
        EXPORT module_five
        
        IMPORT TREATMENT_CODE
        IMPORT TREATMENT_COST
        IMPORT TREATMENT_TABLE

module_five
    PUSH {LR, R4-R11}
    
    ; Load treatment code
    LDR R0, =TREATMENT_CODE
    LDR R0, [R0]
    
    ; Load table address
    LDR R1, =TREATMENT_TABLE
    
    ; Check if code is valid (0-99)
    CMP R0, #0
    BLT invalid
    CMP R0, #99
    BGT invalid
    
    ; Get cost from table: cost = table[code]
    ; Each entry is 4 bytes
    LDR R2, [R1, R0, LSL #2]  ; R2 = table[code]
    
    ; Store cost
    LDR R3, =TREATMENT_COST
    STR R2, [R3]
    
    B done
    
invalid
    ; Invalid code - set cost to 0
    MOV R2, #0
    LDR R3, =TREATMENT_COST
    STR R2, [R3]
    
done
    POP {LR, R4-R11}
    BX LR

    END