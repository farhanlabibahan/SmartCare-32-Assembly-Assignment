        AREA Module03, CODE, READONLY
        EXPORT module_three    
        
        IMPORT hr_alert_flag1
        IMPORT hr_alert_flag2
        IMPORT hr_alert_flag3
        IMPORT o2_alert_flag1
        IMPORT o2_alert_flag2
        IMPORT o2_alert_flag3
        IMPORT sbp_alert_flag1
        IMPORT sbp_alert_flag2
        IMPORT sbp_alert_flag3
        IMPORT alert_buffer1
        IMPORT alert_buffer2
        IMPORT alert_buffer3
        IMPORT alert_index1
        IMPORT alert_index2
        IMPORT alert_index3
        IMPORT timestamp_counter
        IMPORT patient_alert_count1
        IMPORT patient_alert_count2
        IMPORT patient_alert_count3

module_three
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
    
    ; Now:
    ; patient_alert_count1 = 2
    ; patient_alert_count2 = 1
    ; patient_alert_count3 = 3
    
    ; Module 9 can sort these: Patient3 > Patient1 > Patient2
    
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
    
    CMP R1, #120        ; HR_HIGH_THRESHOLD
    BLE hr_normal
    
    ; HR is high - create alert
    BL increment_alert_count
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
    
    ; Check if too high
    CMP R1, #160        ; SBP_HIGH_THRESHOLD
    BGT bp_alert
    
    ; Check if too low
    CMP R1, #90         ; SBP_LOW_THRESHOLD
    BGE bp_normal
    
bp_alert
    ; BP is abnormal - create alert
    BL increment_alert_count
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
    
    CMP R1, #92         ; O2_LOW_THRESHOLD
    BGE o2_normal
    
    ; O2 is low - create alert
    BL increment_alert_count
    
o2_normal
    POP {PC}

; ============================================
; Increment alert count for patient
; R0 = Patient number (1-3)
; ============================================
increment_alert_count
    PUSH {R1-R2, LR}
    
    ; Get the address of the patient's alert count
    CMP R0, #1
    BNE check_patient2_increment
    
    ; Patient 1
    LDR R1, =patient_alert_count1
    B do_increment
    
check_patient2_increment
    CMP R0, #2
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