        AREA Module09, CODE, READONLY
        EXPORT module_nine
        
        IMPORT patient_alert_count1
        IMPORT patient_alert_count2
        IMPORT patient_alert_count3
        IMPORT patient_id1
        IMPORT patient_id2
        IMPORT patient_id3

module_nine
    ; Load all alert counts and their corresponding patient IDs
    LDR R0, =patient_alert_count1
    LDR R1, =patient_alert_count2
    LDR R2, =patient_alert_count3
    
    LDR R3, =patient_id1
    LDR R4, =patient_id2
    LDR R5, =patient_id3
    
    ; Load alert counts into registers
    LDR R6, [R0]        ; count1
    LDR R7, [R1]        ; count2  
    LDR R8, [R2]        ; count3
    
    ; Load patient IDs into registers
    LDR R9, [R3]        ; id1
    LDR R10, [R4]       ; id2
    LDR R11, [R5]       ; id3
    
    ; Bubble sort for 3 elements - outer loop (n-1 passes)
    MOV R12, #3          ; n = 3
    SUB R12, R12, #1     ; n-1
    
outer_loop
    ; Setup for inner loop
    MOV R0, #0           ; i = 0
    MOV R1, R12          ; j = n-1
    SUBS R1, R1, R0      ; j-i
    
inner_loop
    ; Compare adjacent elements (counts)
    ; We'll compare counts and swap both counts and IDs if needed
    
    ; First pair: count1 (R6) vs count2 (R7)
    CMP R6, R7
    BGE check_next_pair  ; if R6 >= R7, no swap needed
    
    ; Swap counts and their IDs
    ; Swap counts
    MOV R2, R6
    MOV R6, R7
    MOV R7, R2
    
    ; Swap corresponding IDs
    MOV R2, R9
    MOV R9, R10
    MOV R10, R2
    
check_next_pair
    ; Second pair: count2 (R7) vs count3 (R8)
    CMP R7, R8
    BGE next_iteration  ; if R7 >= R8, no swap needed
    
    ; Swap counts
    MOV R2, R7
    MOV R7, R8
    MOV R8, R2
    
    ; Swap corresponding IDs
    MOV R2, R10
    MOV R10, R11
    MOV R11, R2
    
next_iteration
    ; Update loop counter
    SUBS R1, R1, #1
    BGT inner_loop
    
    ; Decrement outer loop counter
    SUBS R12, R12, #1
    BGT outer_loop
    
    ; Sort complete
    ; Now store sorted values back to memory if needed
    LDR R0, =patient_alert_count1
    LDR R1, =patient_alert_count2
    LDR R2, =patient_alert_count3
    
    STR R6, [R0]        ; Store sorted count1
    STR R7, [R1]        ; Store sorted count2
    STR R8, [R2]        ; Store sorted count3
    
    LDR R3, =patient_id1
    LDR R4, =patient_id2
    LDR R5, =patient_id3
    
    STR R9, [R3]        ; Store sorted id1
    STR R10, [R4]       ; Store sorted id2
    STR R11, [R5]       ; Store sorted id3
    
    ; At this point:
    ; R6/R9 = highest alert count with its patient ID (most critical)
    ; R8/R11 = lowest alert count with its patient ID (least critical)
    
    B .
    
    END