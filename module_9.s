        AREA |.text|, CODE, READONLY
        EXPORT nine
        
        IMPORT patient_alert_count1, patient_alert_count2, patient_alert_count3

nine
    ; Load all alert counts
    LDR R0, =patient_alert_count1
    LDR R1, =patient_alert_count2
    LDR R2, =patient_alert_count3
    
    LDR R3, [R0]        ; count1
    LDR R4, [R1]        ; count2  
    LDR R5, [R2]        ; count3
    
    ; Simple bubble sort for 3 numbers
    ; First pass
    CMP R3, R4
    BGE no_swap1
    ; Swap R3 and R4
    MOV R6, R3
    MOV R3, R4
    MOV R4, R6
    
no_swap1
    CMP R4, R5
    BGE no_swap2
    ; Swap R4 and R5
    MOV R6, R4
    MOV R4, R5
    MOV R5, R6
    
no_swap2
    ; Second pass
    CMP R3, R4
    BGE sorted
    
    ; Swap R3 and R4
    MOV R6, R3
    MOV R3, R4
    MOV R4, R6
    
sorted
    ; Now R3 >= R4 >= R5 (sorted descending)
    ; R3 = highest alert count (most critical patient)
    ; R5 = lowest alert count (least critical patient)
    
    ; You can store these sorted values or use them directly
    ; For example, store sorted patient IDs
    
    B .
    
    END