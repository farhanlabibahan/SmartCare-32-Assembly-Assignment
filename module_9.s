AREA myData, DATA, READWRITE
        ALIGN 4

; Patient Structure (16 bytes each)
; Byte 0-3: Patient ID
; Byte 4-7: Alert Count  <-- SORT BY THIS
; Byte 8-11: Heart Rate
; Byte 12-15: Last Check Time

; 4 Patients
patients    DCD 1001    ; Patient 1 ID
            DCD 0       ; Alert Count
            DCD 0       ; Heart Rate
            DCD 0       ; Last Check Time
            
            DCD 1002    ; Patient 2 ID
            DCD 0       ; Alert Count
            DCD 0       ; Heart Rate
            DCD 0       ; Last Check Time
            
            DCD 1003    ; Patient 3 ID
            DCD 0       ; Alert Count
            DCD 0       ; Heart Rate
            DCD 0       ; Last Check Time
            
            DCD 1004    ; Patient 4 ID
            DCD 0       ; Alert Count
            DCD 0       ; Heart Rate
            DCD 0       ; Last Check Time

num_patients DCD 4      ; Number of patients

        AREA |.text|, CODE, READONLY
        EXPORT main
        ENTRY

main
    ; Initialize patients with some alert counts
    BL setup_test_data
    
    ; Display patients before sorting
    BL display_patients
    
    ; Sort patients by alert count (bubble sort)
    BL sort_patients
    
    ; Display patients after sorting
    BL display_patients
    
stop
    B stop

; Setup test data with different alert counts
setup_test_data
    PUSH {R0-R3, LR}
    
    ; Patient 1: 3 alerts (most critical)
    LDR R0, =patients
    MOV R1, #3
    STR R1, [R0, #4]    ; Alert count = 3
    MOV R1, #130        ; High HR
    STR R1, [R0, #8]    ; Heart Rate
    MOV R1, #100
    STR R1, [R0, #12]   ; Last check time
    
    ; Patient 2: 0 alerts (least critical)
    ADD R0, R0, #16     ; Next patient
    MOV R1, #0
    STR R1, [R0, #4]    ; Alert count = 0
    MOV R1, #90         ; Normal HR
    STR R1, [R0, #8]    ; Heart Rate
    MOV R1, #101
    STR R1, [R0, #12]   ; Last check time
    
    ; Patient 3: 2 alerts
    ADD R0, R0, #16     ; Next patient
    MOV R1, #2
    STR R1, [R0, #4]    ; Alert count = 2
    MOV R1, #125        ; High HR
    STR R1, [R0, #8]    ; Heart Rate
    MOV R1, #102
    STR R1, [R0, #12]   ; Last check time
    
    ; Patient 4: 1 alert
    ADD R0, R0, #16     ; Next patient
    MOV R1, #1
    STR R1, [R0, #4]    ; Alert count = 1
    MOV R1, #115        ; Normal HR
    STR R1, [R0, #8]    ; Heart Rate
    MOV R1, #103
    STR R1, [R0, #12]   ; Last check time
    
    POP {R0-R3, PC}

; MODULE 9: Bubble sort patients by alert count
sort_patients
    PUSH {R0-R9, LR}
    
    ; Get number of patients
    LDR R0, =num_patients
    LDR R1, [R0]        ; R1 = number of patients
    SUB R1, R1, #1      ; n-1 for outer loop
    
    ; Outer loop: i from 0 to n-2
    MOV R2, #0          ; i = 0
outer_loop
    CMP R2, R1
    BGE sort_done
    
    ; Inner loop: j from 0 to n-i-2
    MOV R3, #0          ; j = 0
    LDR R0, =num_patients
    LDR R4, [R0]        ; R4 = n
    SUB R4, R4, R2      ; n - i
    SUB R4, R4, #1      ; n - i - 1
    
inner_loop
    CMP R3, R4
    BGE inner_done
    
    ; Calculate address of patient[j]
    LDR R0, =patients
    MOV R5, #16         ; Size of each patient
    MUL R6, R3, R5      ; j * 16
    ADD R7, R0, R6      ; Address of patient[j]
    
    ; Calculate address of patient[j+1]
    ADD R8, R7, R5      ; Address of patient[j+1]
    
    ; Get alert count of patient[j]
    LDR R9, [R7, #4]    ; R9 = alert count of patient[j]
    
    ; Get alert count of patient[j+1]
    LDR R0, [R8, #4]    ; R0 = alert count of patient[j+1]
    
    ; Compare alert counts
    ; We want descending order (most alerts first)
    CMP R9, R0
    BGE no_swap
    
    ; Swap patient[j] and patient[j+1]
    MOV R0, R7          ; Address of patient[j]
    MOV R1, R8          ; Address of patient[j+1]
    BL swap_patients
    
no_swap
    ADD R3, R3, #1      ; j++
    B inner_loop
    
inner_done
    ADD R2, R2, #1      ; i++
    B outer_loop

sort_done
    POP {R0-R9, PC}

; Swap two patient records (16 bytes each)
; R0 = address of patient A
; R1 = address of patient B
swap_patients
    PUSH {R2-R5, LR}
    
    MOV R2, #0          ; Byte counter
swap_loop
    CMP R2, #16
    BGE swap_complete
    
    ; Load byte from patient A
    LDRB R3, [R0, R2]
    
    ; Load byte from patient B
    LDRB R4, [R1, R2]
    
    ; Swap bytes
    STRB R4, [R0, R2]
    STRB R3, [R1, R2]
    
    ADD R2, R2, #1
    B swap_loop
    
swap_complete
    POP {R2-R5, PC}

; Display patient information (for verification)
display_patients
    PUSH {R0-R5, LR}
    
    LDR R0, =num_patients
    LDR R1, [R0]        ; Number of patients
    MOV R2, #0          ; Counter
    
    LDR R3, =patients   ; Start address
    
display_loop
    CMP R2, R1
    BGE display_done
    
    ; Get patient data
    LDR R4, [R3]        ; Patient ID
    LDR R5, [R3, #4]    ; Alert Count
    
    ; Here you would display R4 (ID) and R5 (Alert Count)
    ; For now, we just store them somewhere or use debugger
    
    ; Move to next patient
    ADD R3, R3, #16
    ADD R2, R2, #1
    B display_loop
    
display_done
    POP {R0-R5, PC}

    END