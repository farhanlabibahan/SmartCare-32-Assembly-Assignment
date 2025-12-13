        AREA myData, DATA, READWRITE
        ALIGN 4

; Sensor ADDRESSES (2 patients)
HR1    EQU 0x20001000  ; Patient 1 Heart Rate
BP1    EQU 0x20001004  ; Patient 1 Blood Pressure
O21    EQU 0x20001008  ; Patient 1 Oxygen

HR2    EQU 0x2000100C  ; Patient 2 Heart Rate
BP2    EQU 0x20001010  ; Patient 2 Blood Pressure
O22    EQU 0x20001014  ; Patient 2 Oxygen

; Buffers for 2 patients (10 readings each)
hr1_buffer   SPACE 40   ; 10 words for Patient 1 HR
hr2_buffer   SPACE 40   ; Patient 2 HR

bp1_buffer   SPACE 40   ; Patient 1 BP
bp2_buffer   SPACE 40   ; Patient 2 BP

o21_buffer   SPACE 40   ; Patient 1 O2
o22_buffer   SPACE 40   ; Patient 2 O2

; Indexes (one for each buffer)
hr1_index    DCD 0
hr2_index    DCD 0

bp1_index    DCD 0
bp2_index    DCD 0

o21_index    DCD 0
o22_index    DCD 0

        AREA |.text|, CODE, READONLY
        EXPORT main
        ENTRY

main
    ; Reset all indexes to 0
    MOV R0, #0
    
    ; Reset HR indexes
    LDR R1, =hr1_index
    STR R0, [R1]
    LDR R1, =hr2_index
    STR R0, [R1]
    
    ; Reset BP indexes
    LDR R1, =bp1_index
    STR R0, [R1]
    LDR R1, =bp2_index
    STR R0, [R1]
    
    ; Reset O2 indexes
    LDR R1, =o21_index
    STR R0, [R1]
    LDR R1, =o22_index
    STR R0, [R1]
    
    ; Read both patients
    BL read_both_patients

stop
    B stop


; Read both patients
read_both_patients
    PUSH {LR}
    
    ; Read Patient 1
    BL read_patient1
    
    ; Read Patient 2
    BL read_patient2
    
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