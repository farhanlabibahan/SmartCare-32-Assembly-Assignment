        AREA    RoomBilling, CODE, READONLY
        EXPORT  module_six
        EXPORT  Calc_Room_Rent
        
        IMPORT ROOM_RATE
        IMPORT DAYS_STAYED
        IMPORT ROOM_COST

module_six
        ; Load addresses of the 3 variables in RAM
        LDR     r0, =ROOM_RATE
        LDR     r1, =DAYS_STAYED
        LDR     r2, =ROOM_COST

        ; Call the room rent calculator
        BL      Calc_Room_Rent

STOP
        BX LR           ; infinite loop for debugging

;Calc_Room_Rent
Calc_Room_Rent
        PUSH    {r4-r7, lr}

        ;Load room rate
        LDR     r4, [r0]

        ;Load number of stay days
        LDR     r5, [r1]

        ;room_cost=rate�days
        MUL     r6, r4, r5
        STR     r6, [r2]           ;store initial cost

        ;Check for discount: if days <= 10 ? skip
        CMP     r5, #10
        BLE     NO_DISCOUNT

        ;discount =(room_cost�5)/100
        MOV     r7, #5
        MUL     r7, r7, r6         ; r7 =cost�5

        MOV     r4, #100
        SDIV    r7, r7, r4         ; r7 =(cost�5)/100

        ; Apply discount
        SUB     r6, r6, r7
        STR     r6, [r2]           ; final cost

NO_DISCOUNT
        POP     {r4-r7, pc}


        END
