        AREA    RoomBilling, CODE, READONLY
        EXPORT  main
        EXPORT  Calc_Room_Rent
        ENTRY
main
        ; Load addresses of the 3 variables in RAM
        LDR     r0, =ROOM_RATE
        LDR     r1, =DAYS_STAYED
        LDR     r2, =ROOM_COST

        ; Call the room rent calculator
        BL      Calc_Room_Rent

STOP
        B       STOP               ; infinite loop for debugging

;Calc_Room_Rent
Calc_Room_Rent
        PUSH    {r4-r7, lr}

        ;Load room rate
        LDR     r4, [r0]

        ;Load number of stay days
        LDR     r5, [r1]

        ;room_cost=rate×days
        MUL     r6, r4, r5
        STR     r6, [r2]           ;store initial cost

        ;Check for discount: if days <= 10 ? skip
        CMP     r5, #10
        BLE     NO_DISCOUNT

        ;discount =(room_cost×5)/100
        MOV     r7, #5
        MUL     r7, r7, r6         ; r7 =cost×5

        MOV     r4, #100
        SDIV    r7, r7, r4         ; r7 =(cost×5)/100

        ; Apply discount
        SUB     r6, r6, r7
        STR     r6, [r2]           ; final cost

NO_DISCOUNT
        POP     {r4-r7, pc}


; DATA SECTION — INPUT from MEMORY, OUTPUT to MEMORY
        AREA    RoomBilling_DATA, DATA, READWRITE
        ALIGN   4

        EXPORT ROOM_RATE
        EXPORT DAYS_STAYED
        EXPORT ROOM_COST

ROOM_RATE       DCD     0      ; YOU SET THIS IN MEMORY WINDOW
DAYS_STAYED     DCD     0      ; YOU SET THIS IN MEMORY WINDOW
ROOM_COST       DCD     0      ; OUTPUT WRITTEN HERE

        END
