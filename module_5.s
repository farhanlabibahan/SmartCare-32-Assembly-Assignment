        AREA    TreatmentModule, CODE, READONLY
        ENTRY                    
        EXPORT  module_five
        EXPORT  Compute_Treatment_Cost
        IMPORT TREATMENT_CODE
        IMPORT TREATMENT_COST
        

        ALIGN 4                  ; Align to word boundary
TREATMENT_TABLE
        DCD 100,200,300,400,500,600,700,800,900,1000
        DCD 1100,1200,1300,1400,1500,1600,1700,1800,1900,2000
        DCD 2100,2200,2300,2400,2500,2600,2700,2800,2900,3000
        DCD 3100,3200,3300,3400,3500,3600,3700,3800,3900,4000
        DCD 4100,4200,4300,4400,4500,4600,4700,4800,4900,5000
        DCD 5100,5200,5300,5400,5500,5600,5700,5800,5900,6000
        DCD 6100,6200,6300,6400,6500,6600,6700,6800,6900,7000
        DCD 7100,7200,7300,7400,7500,7600,7700,7800,7900,8000
        DCD 8100,8200,8300,8400,8500,8600,8700,8800,8900,9000
        DCD 9100,9200,9300,9400,9500,9600,9700,9800,9900,10000

    EXPORT TREATMENT_TABLE


; ---------------------------------------------------------
; module_five - Main entry point
; ---------------------------------------------------------
module_five
        LDR     r0, =TREATMENT_CODE     ; pointer to input code
        LDR     r1, =TREATMENT_COST     ; pointer to output cost
        BL      Compute_Treatment_Cost

STOP
        BX LR                 ; hold program here


; ---------------------------------------------------------
; Compute_Treatment_Cost
; Input:  r0 = &TREATMENT_CODE
;         r1 = &TREATMENT_COST
; Output: Stores cost in TREATMENT_COST
; ---------------------------------------------------------
Compute_Treatment_Cost
        PUSH    {r4-r7, lr}

        ; Load input treatment code
        LDR     r4, [r0]                ; r4 = code (0-99)

        ; Check if code is valid (0-99)
        CMP     r4, #99
        BHI     invalid_code            ; If > 99, handle invalid

        ; Load table base
        LDR     r5, =TREATMENT_TABLE

        ; Compute offset = code * 4 (word size)
        LSL     r4, r4, #2

        ; Address of selected entry
        ADD     r6, r5, r4

        ; Load cost from table
        LDR     r7, [r6]

        ; Write cost to output memory
        STR     r7, [r1]
        
        B       done

invalid_code
        ; Handle invalid code - maybe set cost to 0 or error value
        MOV     r7, #0
        STR     r7, [r1]

done
        POP     {r4-r7, pc}

        END