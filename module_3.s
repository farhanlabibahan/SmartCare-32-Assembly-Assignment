        AREA Module03, CODE, READONLY
        EXPORT module_three    
        
        ; IMPORT threshold constants
        IMPORT HR_HIGH_THRESHOLD
        IMPORT O2_LOW_THRESHOLD
        IMPORT SBP_HIGH_THRESHOLD
        IMPORT SBP_LOW_THRESHOLD
        
        ; IMPORT alert flags
        IMPORT hr_alert_flag1
        IMPORT hr_alert_flag2
        IMPORT hr_alert_flag3
        IMPORT o2_alert_flag1
        IMPORT o2_alert_flag2
        IMPORT o2_alert_flag3
        IMPORT sbp_alert_flag1
        IMPORT sbp_alert_flag2
        IMPORT sbp_alert_flag3
        
        ; IMPORT alert buffers and indexes
        IMPORT alert_buffer1
        IMPORT alert_buffer2
        IMPORT alert_buffer3
        IMPORT alert_index1
        IMPORT alert_index2
        IMPORT alert_index3
        
        ; IMPORT counters
        IMPORT timestamp_counter
        IMPORT patient_alert_count1
        IMPORT patient_alert_count2
        IMPORT patient_alert_count3

module_three
    PUSH {LR, R4-R11}
    
    ; Initialize
    MOV R0, #0
    
    ; Reset alert indexes
    LDR R1, =alert_index1
    STR R0, [R1]
    LDR R1, =alert_index2
    STR R0, [R1]
    LDR R1, =alert_index3
    STR R0, [R1]
    
    ; Reset alert counts
    LDR R1, =patient_alert_count1
    STR R0, [R1]
    LDR R1, =patient_alert_count2
    STR R0, [R1]
    LDR R1, =patient_alert_count3
    STR R0, [R1]
    
    ; Reset alert flags
    LDR R1, =hr_alert_flag1
    STRB R0, [R1]
    LDR R1, =hr_alert_flag2
    STRB R0, [R1]
    LDR R1, =hr_alert_flag3
    STRB R0, [R1]
    
    LDR R1, =o2_alert_flag1
    STRB R0, [R1]
    LDR R1, =o2_alert_flag2
    STRB R0, [R1]
    LDR R1, =o2_alert_flag3
    STRB R0, [R1]
    
    LDR R1, =sbp_alert_flag1
    STRB R0, [R1]
    LDR R1, =sbp_alert_flag2
    STRB R0, [R1]
    LDR R1, =sbp_alert_flag3
    STRB R0, [R1]
    
    ; Reset timestamp
    LDR R1, =timestamp_counter
    STR R0, [R1]
    
    ; Test: Create alerts for different patients
    
    ; Patient 1: 2 alerts (HR and BP high)
    MOV R0, #1          ; Patient 1
    MOV R1, #130        ; HR high (>120)
    MOV R2, #170        ; BP high (>160)
    MOV R3, #95         ; O2 normal (>92)
    BL check_patient_vitals
    
    ; Patient 2: 1 alert (O2 low)
    MOV R0, #2          ; Patient 2
    MOV R1, #110        ; HR normal
    MOV R2, #120        ; BP normal
    MOV R3, #85         ; O2 low (<92)
    BL check_patient_vitals
    
    ; Patient 3: 3 alerts (all critical)
    MOV R0, #3          ; Patient 3
    MOV R1, #130        ; HR high
    MOV R2, #170        ; BP high
    MOV R3, #85         ; O2 low
    BL check_patient_vitals
    
    ; Update timestamp counter
    LDR R0, =timestamp_counter
    LDR R1, [R0]
    ADD R1, R1, #3      ; Increment by number of patients checked
    STR R1, [R0]
    
    POP {LR, R4-R11}
    BX LR

; ============================================
; Check vitals for specific patient
; R0 = Patient number (1-3)
; R1 = Heart Rate
; R2 = Blood Pressure
; R3 = Oxygen
; ============================================
check_patient_vitals
    PUSH {R4, LR}
    MOV R4, R0          ; Save patient number
    
    ; Check HR
    MOV R0, R4
    ; R1 already has HR value
    BL check_hr_for_patient
    
    ; Check BP
    MOV R0, R4
    MOV R1, R2          ; Move BP to R1
    BL check_bp_for_patient
    
    ; Check O2
    MOV R0, R4
    MOV R1, R3          ; Move O2 to R1
    BL check_o2_for_patient
    
    POP {R4, PC}

; ============================================
; Check HR for patient
; R0 = Patient number (1-3)
; R1 = HR value
; ============================================
check_hr_for_patient
    PUSH {LR}
    
    LDR R2, =HR_HIGH_THRESHOLD
    CMP R1, R2
    BLE hr_normal
    
    ; HR is high - create alert
    MOV R1, #1          ; Alert type: HR High
    BL create_alert
    B hr_done_check
    
hr_normal
    ; No alert needed
hr_done_check
    POP {PC}

; ============================================
; Check BP for patient  
; R0 = Patient number (1-3)
; R1 = BP value
; ============================================
check_bp_for_patient
    PUSH {LR}
    
    LDR R2, =SBP_HIGH_THRESHOLD
    CMP R1, R2
    BGT bp_alert_high
    
    LDR R2, =SBP_LOW_THRESHOLD
    CMP R1, R2
    BLT bp_alert_low
    
    B bp_normal
    
bp_alert_high
    ; BP is too high
    MOV R1, #2          ; Alert type: BP High
    BL create_alert
    B bp_done_check
    
bp_alert_low
    ; BP is too low
    MOV R1, #3          ; Alert type: BP Low
    BL create_alert
    B bp_done_check
    
bp_normal
    ; No alert needed
bp_done_check
    POP {PC}

; ============================================
; Check O2 for patient
; R0 = Patient number (1-3)
; R1 = O2 value
; ============================================
check_o2_for_patient
    PUSH {LR}
    
    LDR R2, =O2_LOW_THRESHOLD
    CMP R1, R2
    BGE o2_normal
    
    ; O2 is low - create alert
    MOV R1, #4          ; Alert type: O2 Low
    BL create_alert
    
o2_normal
    POP {PC}

; ============================================
; Create alert for patient
; R0 = Patient number (1-3)
; R1 = Alert type (1=HR High, 2=BP High, 3=BP Low, 4=O2 Low)
; ============================================
create_alert
    PUSH {R2-R5, LR}
    
    ; Save parameters
    MOV R4, R0          ; Patient number
    MOV R5, R1          ; Alert type
    
    ; 1. Set alert flag based on type
    BL set_alert_flag
    
    ; 2. Store alert in buffer
    BL store_alert_in_buffer
    
    ; 3. Increment alert count
    BL increment_alert_count
    
    POP {R2-R5, PC}

; ============================================
; Set alert flag for patient
; R4 = Patient number (1-3)
; R5 = Alert type (1=HR High, 2=BP High, 3=BP Low, 4=O2 Low)
; ============================================
set_alert_flag
    PUSH {LR}
    
    ; Determine which flag to set based on alert type
    CMP R5, #1
    BEQ set_hr_flag
    
    CMP R5, #2
    BEQ set_bp_flag
    
    CMP R5, #3
    BEQ set_bp_flag
    
    ; Otherwise it's O2 flag
    B set_o2_flag
    
set_hr_flag
    ; Set HR alert flag
    CMP R4, #1
    BNE set_hr_flag2
    
    LDR R0, =hr_alert_flag1
    MOV R1, #1
    STRB R1, [R0]
    B flag_set_done
    
set_hr_flag2
    CMP R4, #2
    BNE set_hr_flag3
    
    LDR R0, =hr_alert_flag2
    MOV R1, #1
    STRB R1, [R0]
    B flag_set_done
    
set_hr_flag3
    LDR R0, =hr_alert_flag3
    MOV R1, #1
    STRB R1, [R0]
    B flag_set_done
    
set_bp_flag
    ; Set BP alert flag
    CMP R4, #1
    BNE set_bp_flag2
    
    LDR R0, =sbp_alert_flag1
    MOV R1, #1
    STRB R1, [R0]
    B flag_set_done
    
set_bp_flag2
    CMP R4, #2
    BNE set_bp_flag3
    
    LDR R0, =sbp_alert_flag2
    MOV R1, #1
    STRB R1, [R0]
    B flag_set_done
    
set_bp_flag3
    LDR R0, =sbp_alert_flag3
    MOV R1, #1
    STRB R1, [R0]
    B flag_set_done
    
set_o2_flag
    ; Set O2 alert flag
    CMP R4, #1
    BNE set_o2_flag2
    
    LDR R0, =o2_alert_flag1
    MOV R1, #1
    STRB R1, [R0]
    B flag_set_done
    
set_o2_flag2
    CMP R4, #2
    BNE set_o2_flag3
    
    LDR R0, =o2_alert_flag2
    MOV R1, #1
    STRB R1, [R0]
    B flag_set_done
    
set_o2_flag3
    LDR R0, =o2_alert_flag3
    MOV R1, #1
    STRB R1, [R0]
    
flag_set_done
    POP {PC}

; ============================================
; Store alert in buffer for patient
; R4 = Patient number (1-3)
; R5 = Alert type (1=HR High, 2=BP High, 3=BP Low, 4=O2 Low)
; ============================================
store_alert_in_buffer
    PUSH {R0-R3, LR}
    
    ; Get current timestamp
    LDR R0, =timestamp_counter
    LDR R1, [R0]
    
    ; Create alert structure: [timestamp | alert_type]
    ; Combine into one 32-bit word
    LSL R2, R1, #16     ; Shift timestamp to upper 16 bits
    ORR R2, R2, R5      ; Combine with alert type in lower 16 bits
    
    ; Get the correct buffer and index for this patient
    CMP R4, #1
    BNE get_buffer_patient2
    
    ; Patient 1
    LDR R0, =alert_buffer1
    LDR R1, =alert_index1
    B store_in_buffer
    
get_buffer_patient2
    CMP R4, #2
    BNE get_buffer_patient3
    
    ; Patient 2
    LDR R0, =alert_buffer2
    LDR R1, =alert_index2
    B store_in_buffer
    
get_buffer_patient3
    ; Patient 3
    LDR R0, =alert_buffer3
    LDR R1, =alert_index3
    
store_in_buffer
    ; Get current index
    LDR R3, [R1]
    
    ; Store alert at buffer[index]
    STR R2, [R0, R3, LSL #2]  ; R3 * 4 for word offset
    
    ; Update index: (index + 1) % 40 (10 alerts * 4 bytes each? Wait, 160 bytes = 40 words)
    ADD R3, R3, #1
    CMP R3, #40               ; 160 bytes / 4 bytes per word = 40 words
    MOVGE R3, #0
    
    ; Save new index
    STR R3, [R1]
    
    POP {R0-R3, PC}

; ============================================
; Increment alert count for patient
; R4 = Patient number (1-3)
; ============================================
increment_alert_count
    PUSH {R1-R2, LR}
    
    ; Get the address of the patient's alert count
    CMP R4, #1
    BNE check_patient2_increment
    
    ; Patient 1
    LDR R1, =patient_alert_count1
    B do_increment
    
check_patient2_increment
    CMP R4, #2
    BNE patient3_increment
    
    ; Patient 2
    LDR R1, =patient_alert_count2
    B do_increment
    
patient3_increment
    ; Patient 3
    LDR R1, =patient_alert_count3
    
do_increment
    ; Load current count, increment, store back
    LDR R2, [R1]
    ADD R2, R2, #1
    STR R2, [R1]
    
    POP {R1-R2, PC}

    END