        AREA Module02, CODE, READONLY
        EXPORT module_two
        
     
        IMPORT HR1_data
        IMPORT BP1_data
        IMPORT O21_data
        IMPORT HR2_data
        IMPORT BP2_data
        IMPORT O22_data
        IMPORT HR3_data
        IMPORT BP3_data
        IMPORT O23_data
        IMPORT hr1_index
        IMPORT hr2_index
        IMPORT hr3_index
        IMPORT bp1_index
        IMPORT bp2_index
        IMPORT bp3_index
        IMPORT o21_index
        IMPORT o22_index
        IMPORT o23_index
        IMPORT hr1_buffer
        IMPORT hr2_buffer
        IMPORT hr3_buffer
        IMPORT bp1_buffer
        IMPORT bp2_buffer
        IMPORT bp3_buffer
        IMPORT o21_buffer
        IMPORT o22_buffer
        IMPORT o23_buffer

module_two
    PUSH {LR, R4-R11}    
    
    ;       Reset all 
    MOV R0, #0
    
        ; Reset HR indexes
    LDR R1, =hr1_index
    STR R0, [R1]
    LDR R1, =hr2_index
    STR R0, [R1]
    LDR R1, =hr3_index
    STR R0, [R1]
    
        ; Reset BP indexes
    LDR R1, =bp1_index
    STR R0, [R1]
    LDR R1, =bp2_index
    STR R0, [R1]
    LDR R1, =bp3_index
    STR R0, [R1]
    
        ; Reset O2 indexes
    LDR R1, =o21_index
    STR R0, [R1]
    LDR R1, =o22_index
    STR R0, [R1]
    LDR R1, =o23_index
    STR R0, [R1]
    
    ; Read all patients
    BL read_all_patients
    
    POP {LR, R4-R11}     ; Restore 
    BX LR                


; Read all patients
read_all_patients
    PUSH {LR}
    
    ; Read Patient 1
    BL read_patient1
    
    ; Read Patient 2
    BL read_patient2
    
    ; Read Patient 3
    BL read_patient3
    
    POP {PC}


; Read Patient 1
read_patient1
    PUSH {LR}
    
    ; Read HR for Patient 1
    LDR R0, =HR1_data
    LDR R1, [R0]
    LDR R2, =hr1_buffer
    LDR R3, =hr1_index
    BL store_reading
    
    ; Read BP for Patient 1
    LDR R0, =BP1_data
    LDR R1, [R0]
    LDR R2, =bp1_buffer
    LDR R3, =bp1_index
    BL store_reading
    
    ; Read O2 for Patient 1
    LDR R0, =O21_data
    LDR R1, [R0]
    LDR R2, =o21_buffer
    LDR R3, =o21_index
    BL store_reading
    
    POP {PC}


; Read Patient 2
read_patient2
    PUSH {LR}
    
    ; Read HR for Patient 2
    LDR R0, =HR2_data
    LDR R1, [R0]
    LDR R2, =hr2_buffer
    LDR R3, =hr2_index
    BL store_reading
    
    ; Read BP for Patient 2
    LDR R0, =BP2_data
    LDR R1, [R0]
    LDR R2, =bp2_buffer
    LDR R3, =bp2_index
    BL store_reading
    
    ; Read O2 for Patient 2
    LDR R0, =O22_data
    LDR R1, [R0]
    LDR R2, =o22_buffer
    LDR R3, =o22_index
    BL store_reading
    
    POP {PC}


; Read Patient 3
read_patient3
    PUSH {LR}
    
    ; Read HR for Patient 3
    LDR R0, =HR3_data
    LDR R1, [R0]
    LDR R2, =hr3_buffer
    LDR R3, =hr3_index
    BL store_reading
    
    ; Read BP for Patient 3
    LDR R0, =BP3_data
    LDR R1, [R0]
    LDR R2, =bp3_buffer
    LDR R3, =bp3_index
    BL store_reading
    
    ; Read O2 for Patient 3
    LDR R0, =O23_data
    LDR R1, [R0]
    LDR R2, =o23_buffer
    LDR R3, =o23_index
    BL store_reading
    
    POP {PC}


; store reading
store_reading
    PUSH {R4}
    
    ; Get current index
    LDR R4, [R3]
    
    ; Store reading at buffer[index]
    STR R1, [R2, R4, LSL #2]  ; R4 * 4 for word offset
    
    ; Update index: (index + 1) % 10
    ADD R4, R4, #1
    CMP R4, #10
    MOVGE R4, #0
    
    ; Save new index
    STR R4, [R3]
    
    POP {R4}
    BX LR

    END