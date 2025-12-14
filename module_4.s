        AREA    MedSCHED, CODE, READONLY
        EXPORT  module_four
        EXPORT  Update_Clock
        EXPORT  Compute_Dosage
        IMPORT TREATMENT_CODE
        IMPORT TREATMENT_COST
        IMPORT TREATMENT_TABLE

module_four
        
        LDR     r0, =MED1_LAST
        LDR     r1, =MED1_INTERVAL
        LDR     r2, =MED1_NEXT
        LDR     r3, =MED1_FLAG

        BL      Compute_Dosage   ;CALL FUNCTION

STOP
        B       STOP             ;hold execution so we can see memory


;Update Clock
Update_Clock
        LDR     r0, =CURRENT_TIME
        LDR     r1, [r0]
        ADD     r1, r1, #1
        STR     r1, [r0]
        BX      LR

;Compute_Dosage
Compute_Dosage
        PUSH    {r4-r7, lr}

        LDR     r4, [r0]     ; last time
        LDR     r5, [r1]     ; interval
        ADD     r6, r4, r5   ; next_due
        STR     r6, [r2]

        LDR     r7, =CURRENT_TIME
        LDR     r7, [r7]

        CMP     r7, r6    
        BLT     NOT_DUE  ;when FLAG=0

        MOVS    r4, #1
        STR     r4, [r3]
        B       DONE

NOT_DUE
        MOVS    r4, #0
        STR     r4, [r3]

DONE
        POP     {r4-r7, pc}

;DATA SECTION (RAM)
        AREA    MedSCHED_DATA, DATA, READWRITE
        ALIGN   4

CURRENT_TIME    DCD     0
MED1_LAST       DCD     0
MED1_INTERVAL   DCD     0
MED1_NEXT       DCD     0
MED1_FLAG       DCD     0

        END
