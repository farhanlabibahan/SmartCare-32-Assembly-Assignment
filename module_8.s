        AREA    BillData, DATA, READWRITE
        ALIGN   4


        AREA    BillModule, CODE, READONLY
        EXPORT  module_eight
        EXPORT  Compute_Total_Bill
        IMPORT  TREATMENT_COST   
        IMPORT  ROOM_COST    
        IMPORT  MEDICINE_COST
        IMPORT  LABTEST_COST
        IMPORT  TOTAL_BILL
        IMPORT  ERROR_FLAG
   
        ENTRY

;module_eight 
module_eight
        BL      Compute_Total_Bill

STOP
        BX LR

;FUNCTION
Compute_Total_Bill
        PUSH    {r4-r7, lr}

        ;clear error flag
        MOVS    r7, #0
        LDR     r0, =ERROR_FLAG
        STR     r7, [r0]

        ;load inputs from memory
        LDR     r0, =TREATMENT_COST
        LDR     r1, [r0]
        
        LDR     r0, =ROOM_COST
        LDR     r2, [r0]
        
        LDR     r0, =MEDICINE_COST
        LDR     r3, [r0]
        
        LDR     r0, =LABTEST_COST
        LDR     r4, [r0]

        ;initialize total to 0
        MOVS    r5, #0

        ;add treatment cost
        ADDS    r5, r1, r2
        BCS     overflow

        ;add medicine cost
        ADDS    r5, r5, r3
        BCS     overflow

        ;add lab test cost
        ADDS    r5, r5, r4
        BCS     overflow

        ;store result
        LDR     r0, =TOTAL_BILL
        STR     r5, [r0]
        POP     {r4-r7, pc}

overflow
        MOVS    r7, #1
        LDR     r0, =ERROR_FLAG
        STR     r7, [r0]
        
        MOVS    r5, #0
        LDR     r0, =TOTAL_BILL
        STR     r5, [r0]
        POP     {r4-r7, pc}

        END