        AREA Module02, CODE, READONLY
        EXPORT module_two
        
        IMPORT HR1
        IMPORT BP1
        IMPORT O21
        IMPORT HR2
        IMPORT BP2
        IMPORT O22
        IMPORT HR3          ; Fixed: Changed HP3 to HR3
        IMPORT BP3
        IMPORT O23
        IMPORT hr1_index
        IMPORT hr2_index
        IMPORT hr3_index    ; Added
        IMPORT bp1_index
        IMPORT bp2_index
        IMPORT bp3_index    ; Added
        IMPORT o21_index
        IMPORT o22_index
        IMPORT o23_index    ; Added
        IMPORT hr1_buffer
        IMPORT hr2_buffer
        IMPORT hr3_buffer   ; Added
        IMPORT bp1_buffer
        IMPORT bp2_buffer
        IMPORT bp3_buffer   ; Added
        IMPORT o21_buffer
        IMPORT o22_buffer
        IMPORT o23_buffer   ; Added

module_two
    ; Reset all indexes to 0
    MOV R0, #0
    
    ; Reset HR indexes
    LDR R1, =hr1_index
    STR R0, [R1]
    LDR R1, =hr2_index
    STR R0, [R1]
    LDR R1, =hr3_index      ; Added Patient 3
    STR R0, [R1]
    
    ; Reset BP indexes
    LDR R1, =bp1_index
    STR R0, [R1]
    LDR R1, =bp2_index
    STR R0, [R1]
    LDR R1, =bp3_index      ; Added Patient 3
    STR R0, [R1]
    
    ; Reset O2 indexes
    LDR R1, =o21_index
    STR R0, [R1]
    LDR R1, =o22_index
    STR R0, [R1]
    LDR R1, =o23_index      ; Added Patient 3
    STR R0, [R1]
    
    ; Read all patients
    BL read_all_patients    ; Changed from read_both_patients

stop
    B stop


; Read all patients
read_all_patients
    PUSH {LR}
    
    ; Read Patient 1
    BL read_patient1
    
    ; Read Patient 2
    BL read_patient2
    
    ; Read Patient 3
    BL read_patient3       ; Added
    
    POP {PC}


; Read Patient 1
read_patient1
    PUSH {LR}
    
    ; Read HR for Patient 1
    LDR R0, =HR1
    LDR R1, [R0]           ; Get HR value
    LDR R2, =hr1_buffer
    LDR R3, =hr1_index
    BL store_reading
    
    ; Read BP for Patient 1
    LDR R0, =BP1
    LDR R1, [R0]           ; Get BP value
    LDR R2, =bp1_buffer
    LDR R3, =bp1_index
    BL store_reading
    
    ; Read O2 for Patient 1
    LDR R0, =O21
    LDR R1, [R0]           ; Get O2 value
    LDR R2, =o21_buffer
    LDR R3, =o21_index
    BL store_reading
    
    POP {PC}


; Read Patient 2
read_patient2
    PUSH {LR}
    
    ; Read HR for Patient 2
    LDR R0, =HR2
    LDR R1, [R0]
    LDR R2, =hr2_buffer
    LDR R3, =hr2_index
    BL store_reading
    
    ; Read BP for Patient 2
    LDR R0, =BP2
    LDR R1, [R0]
    LDR R2, =bp2_buffer
    LDR R3, =bp2_index
    BL store_reading
    
    ; Read O2 for Patient 2
    LDR R0, =O22
    LDR R1, [R0]
    LDR R2, =o22_buffer
    LDR R3, =o22_index
    BL store_reading
    
    POP {PC}


; Read Patient 3 - Added this function
read_patient3
    PUSH {LR}
    
    ; Read HR for Patient 3
    LDR R0, =HR3
    LDR R1, [R0]
    LDR R2, =hr3_buffer
    LDR R3, =hr3_index
    BL store_reading
    
    ; Read BP for Patient 3
    LDR R0, =BP3
    LDR R1, [R0]
    LDR R2, =bp3_buffer
    LDR R3, =bp3_index
    BL store_reading
    
    ; Read O2 for Patient 3
    LDR R0, =O23
    LDR R1, [R0]
    LDR R2, =o23_buffer
    LDR R3, =o23_index
    BL store_reading
    
    POP {PC}


; Helper function: Store one reading in a buffer
; Input: R1 = reading value, R2 = buffer address, R3 = index address
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