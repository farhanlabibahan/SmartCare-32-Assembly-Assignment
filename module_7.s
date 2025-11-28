        AREA    MedicineBilling, CODE, READONLY
        EXPORT  main
        EXPORT  Compute_Medicine_Bill
        ENTRY

main
        ;Load pointer to medicine list
        LDR     r0, =MED_LIST

        ;Load number of medicines
        LDR     r1, =NUM_MEDS
        LDR     r1, [r1]

        ;Load address of total output
        LDR     r2, =TOTAL_MED_COST

        ;Call billing function
        BL      Compute_Medicine_Bill

STOP
        B       STOP
        

;       med_cost = price×qty×days
;       total += med_cost

Compute_Medicine_Bill
        PUSH    {r4-r8, lr}

        MOVS    r7, #0             ; r7 = total_cost = 0
        MOVS    r4, #0             ; r4 = i = 0 (loop counter)

Loop_Start
        ;if i >=num_meds or end
        CMP     r4, r1
        BGE     Finish

        ;Each medicine is 12 bytes-(3×4B)
        MOV     r5, #12            
        MUL     r6, r4, r5         ; r6 =i*12
        ADD     r6, r6, r0         ; r6 =&MED_LIST[i]

        ;Load fields
        LDR     r8, [r6]           ;unit_price
        LDR     r5, [r6, #4]       ;quantity
        LDR     r3, [r6, #8]       ;days

        ; med_cost=price×qty×days
        MUL     r8, r8, r5         ;price×qty
        MUL     r8, r8, r3         ;(price×qty)×days

        ; total_cost += med_cost
        ADD     r7, r7, r8

        ; i++
        ADD     r4, r4, #1
        B       Loop_Start


Finish
        ; Store final total cost in RAM
        STR     r7, [r2]

        POP     {r4-r8, pc}

; DATA SECTION (INPUT + OUTPUT)
        AREA    MedicineBilling_DATA, DATA, READWRITE
        ALIGN   4

MED_LIST
        DCD     10,  2, 3       ; med1 = 10×2×3=60
        DCD     50,  1, 5       ; med2 = 50×1×5=250
        DCD     20,  3, 2       ; med3 = 20×3×2=120

NUM_MEDS        DCD     3

TOTAL_MED_COST  DCD     0        ;total result will be written here

        END
