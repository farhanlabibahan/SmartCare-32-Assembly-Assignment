AREA myData, DATA, READWRITE
        ALIGN 4

; Threshold values
HR_HIGH_THRESHOLD  EQU 120
O2_LOW_THRESHOLD   EQU 92  
SBP_HIGH_THRESHOLD EQU 160
SBP_LOW_THRESHOLD  EQU 90

; Alert flags (1 byte each)
hr_alert_flag      DCB 0
o2_alert_flag      DCB 0
sbp_alert_flag     DCB 0

; Alert buffer: 10 alerts * 16 bytes each
alert_buffer       SPACE 160

; Current alert index
alert_index        DCD 0

; Timestamp counter
timestamp_counter  DCD 0

        AREA |.text|, CODE, READONLY
        EXPORT main
        ENTRY

main
    ; Initialize
    MOV R0, #0
    LDR R1, =alert_index
    STR R0, [R1]
    
    LDR R1, =timestamp_counter
    STR R0, [R1]
    
    ; Reset alert flags
    LDR R1, =hr_alert_flag
    STRB R0, [R1]
    LDR R1, =o2_alert_flag
    STRB R0, [R1]
    LDR R1, =sbp_alert_flag
    STRB R0, [R1]
    
    ; Test Case 1: All vitals in danger
    MOV R0, #130        ; HR = 130 (>120) -> ALERT
    MOV R1, #170        ; SBP = 170 (>160) -> ALERT
    MOV R2, #85         ; O2 = 85 (<92) -> ALERT
    BL check_vitals
    
    ; Test Case 2: Normal vitals
    MOV R0, #110        ; HR = 110 (OK)
    MOV R1, #120        ; SBP = 120 (OK)
    MOV R2, #96         ; O2 = 96 (OK)
    BL check_vitals
    
stop
    B stop

; Check all vitals
; R0 = Heart Rate
; R1 = Systolic BP
; R2 = O2 Saturation
check_vitals
    PUSH {LR}
    
    ; Check Heart Rate
    BL check_hr
    
    ; Check Blood Pressure
    MOV R0, R1          ; Move SBP to R0 for function
    BL check_sbp
    
    ; Check O2 Saturation
    MOV R0, R2          ; Move O2 to R0 for function
    BL check_o2
    
    POP {PC}

; Check Heart Rate
; R0 = Heart Rate value
check_hr
    PUSH {R1-R4, LR}
    
    ; Compare with threshold
    CMP R0, #HR_HIGH_THRESHOLD
    BLE hr_ok
    
    ; Set HR alert flag
    MOV R1, #1
    LDR R2, =hr_alert_flag
    STRB R1, [R2]
    
    ; Create alert record
    MOV R1, #1          ; Vital type: 1 = HR
    MOV R2, R0          ; Actual reading
    MOV R3, #HR_HIGH_THRESHOLD ; Threshold value
    BL create_alert_record
    
    B hr_done
    
hr_ok
    ; Clear HR alert flag
    MOV R1, #0
    LDR R2, =hr_alert_flag
    STRB R1, [R2]
    
hr_done
    POP {R1-R4, PC}

; Check Systolic Blood Pressure
; R0 = SBP value
check_sbp
    PUSH {R1-R4, LR}
    
    ; Check if too high
    CMP R0, #SBP_HIGH_THRESHOLD
    BGT sbp_alert
    
    ; Check if too low
    CMP R0, #SBP_LOW_THRESHOLD
    BGE sbp_ok
    
sbp_alert
    ; Set SBP alert flag
    MOV R1, #1
    LDR R2, =sbp_alert_flag
    STRB R1, [R2]
    
    ; Create alert record
    MOV R1, #2          ; Vital type: 2 = SBP
    MOV R2, R0          ; Actual reading
    
    ; Determine which threshold was crossed
    CMP R0, #SBP_HIGH_THRESHOLD
    MOVGT R3, #SBP_HIGH_THRESHOLD  ; Too high
    MOVLT R3, #SBP_LOW_THRESHOLD   ; Too low
    
    BL create_alert_record
    B sbp_done
    
sbp_ok
    ; Clear SBP alert flag
    MOV R1, #0
    LDR R2, =sbp_alert_flag
    STRB R1, [R2]
    
sbp_done
    POP {R1-R4, PC}

; Check O2 Saturation
; R0 = O2 value
check_o2
    PUSH {R1-R4, LR}
    
    ; Compare with threshold
    CMP R0, #O2_LOW_THRESHOLD
    BGE o2_ok
    
    ; Set O2 alert flag
    MOV R1, #1
    LDR R2, =o2_alert_flag
    STRB R1, [R2]
    
    ; Create alert record
    MOV R1, #3          ; Vital type: 3 = O2
    MOV R2, R0          ; Actual reading
    MOV R3, #O2_LOW_THRESHOLD ; Threshold value
    BL create_alert_record
    
    B o2_done
    
o2_ok
    ; Clear O2 alert flag
    MOV R1, #0
    LDR R2, =o2_alert_flag
    STRB R1, [R2]
    
o2_done
    POP {R1-R4, PC}

; Create a 16-byte alert record
; R1 = Vital type (1=HR, 2=SBP, 3=O2)
; R2 = Actual reading
; R3 = Threshold value
create_alert_record
    PUSH {R4-R9, LR}
    
    ; Get current alert index
    LDR R4, =alert_index
    LDR R5, [R4]        ; R5 = current index
    
    ; Calculate buffer address: alert_buffer + (index * 16)
    LDR R6, =alert_buffer
    MOV R7, #16
    MUL R8, R5, R7      ; R8 = index * 16
    ADD R9, R6, R8      ; R9 = alert record address
    
    ; Byte 0-3: Store vital type
    STR R1, [R9]
    
    ; Byte 4-7: Store actual reading
    STR R2, [R9, #4]
    
    ; Byte 8-11: Store threshold value
    STR R3, [R9, #8]
    
    ; Byte 12-15: Store timestamp and increment
    LDR R6, =timestamp_counter
    LDR R7, [R6]        ; R7 = current timestamp
    STR R7, [R9, #12]
    
    ; Increment timestamp for next alert
    ADD R7, R7, #1
    STR R7, [R6]
    
    ; Update alert index (wrap around after 10 alerts)
    ADD R5, R5, #1
    CMP R5, #10
    MOVGE R5, #0
    STR R5, [R4]
    
    POP {R4-R9, PC}

    END