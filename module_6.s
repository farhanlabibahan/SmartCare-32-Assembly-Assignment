        AREA Module06, CODE, READONLY
        EXPORT module_six
        EXPORT Calc_Room_Rent
        
        IMPORT ROOM_RATE
        IMPORT DAYS_STAYED
        IMPORT ROOM_COST

module_six
    PUSH {LR, R4-R11}      ; Save registers
    
    ; Call the room rent calculator
    BL Calc_Room_Rent
    
    POP {LR, R4-R11}       ; Restore registers
    BX LR                  ; Return to main


; Calc_Room_Rent
; Calculates: room_cost = rate * days
; Applies 5% discount if days > 10

Calc_Room_Rent
    PUSH {R4-R7, LR}
    
    ; Load room rate
    LDR R4, =ROOM_RATE
    LDR R4, [R4]           ; R4 = room rate
    
    ; Load number of stay days
    LDR R5, =DAYS_STAYED
    LDR R5, [R5]           ; R5 = days stayed
    
    ; room_cost = rate * days
    MUL R6, R4, R5         ; R6 = initial cost
    
    ; Store initial cost
    LDR R7, =ROOM_COST
    STR R6, [R7]
    
    ;       Check for discount: if days > 10, apply 5% discount
    CMP R5, #10
    BLE no_discount
    
    
    ; discount = (room_cost * 5) / 100
    
    ; Method 1: Using multiplication and division

    MOV R0, R6             ; Save original cost
    MOV R1, #5
    MUL R2, R0, R1         ; R2 = cost * 5
    
    ; Divide by 100 
    MOV R3, #0             ; R3 = quotient

div_loop
    CMP R2, #100
    BLT div_done
    SUB R2, R2, #100
    ADD R3, R3, #1
    B div_loop
    
div_done
    ; R3 = discount amount
    SUB R6, R0, R3         ; final cost = original - discount
    
    ; Store final cost
    STR R6, [R7]

no_discount
    POP {R4-R7, PC}

    END