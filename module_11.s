        AREA myData, DATA, READWRITE
; ERROR_FLAG DCD 0  ; ❌ REMOVE - already defined in data.s
error_code DCD 0
hr_data    DCD 80, 80, 80, 80, 80
dosage     DCD 0

        AREA |.text|, CODE, READONLY
        EXPORT module_eleven
        IMPORT ERROR_FLAG    ; ✓ Import from data.s instead
        
module_eleven
    ; Check 1: Sensor
    LDR R0, =hr_data
    LDR R1, [R0]
    LDR R2, [R0, #4]
    CMP R1, R2
    BNE check_dosage
    MOV R0, #1
    BL set_error
    
check_dosage
    ; Check 2: Dosage
    LDR R0, =dosage
    LDR R1, [R0]
    CMP R1, #0
    BNE check_memory
    MOV R0, #2
    BL set_error
    
check_memory
    ; Check 3: Memory
    MOV R0, SP
    LDR R1, =0x20010000
    CMP R0, R1
    BLT all_checks_done
    MOV R0, #3
    BL set_error
    
all_checks_done
    BX LR                ; Return to caller

set_error
    LDR R1, =error_code
    STR R0, [R1]
    LDR R1, =ERROR_FLAG
    MOV R0, #1
    STR R0, [R1]
    BX LR

    END