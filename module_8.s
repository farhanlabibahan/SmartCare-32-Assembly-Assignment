        AREA    BillModule, CODE, READONLY
        EXPORT  main
        EXPORT  Compute_Total_Bill
        ENTRY

;OFFSETS 
TREAT_OFF   EQU     0
ROOM_OFF    EQU     4
MED_OFF     EQU     8
LAB_OFF     EQU     12
TOTAL_OFF   EQU     16
ERR_OFF     EQU     20

;MAIN 
main
        LDR     r0, =BILLING_BLOCK
        BL      Compute_Total_Bill

STOP
        B       STOP

;FUNCTION
Compute_Total_Bill
        PUSH    {r4-r7, lr}

        ;clear error flag
        MOVS    r7, #0
        STR     r7, [r0, #ERR_OFF]

        ;load inputs from memory
        LDR     r1, [r0, #TREAT_OFF]
        LDR     r2, [r0, #ROOM_OFF]
        LDR     r3, [r0, #MED_OFF]
        LDR     r4, [r0, #LAB_OFF]

        ;overflow check
        ADDS    r5, r1, r2
        BCS     overflow

        ADDS    r5, r5, r3
        BCS     overflow

        ADDS    r5, r5, r4
        BCS     overflow

        ;store result
        STR     r5, [r0, #TOTAL_OFF]
        POP     {r4-r7, pc}

overflow
        MOVS    r7, #1
        STR     r7, [r0, #ERR_OFF]
        MOVS    r5, #0
        STR     r5, [r0, #TOTAL_OFF]
        POP     {r4-r7, pc}

;DATA
        AREA    BillData, DATA, READWRITE
        ALIGN   4

BILLING_BLOCK
TREATMENT_COST   DCD  1000   ; INPUT
ROOM_COST        DCD  2000   ; INPUT
MEDICINE_COST    DCD  500    ; INPUT
LABTEST_COST     DCD  700    ; INPUT
TOTAL_BILL       DCD  0      ; OUTPUT
ERROR_FLAG       DCD  0      ; OUTPUT

        END
