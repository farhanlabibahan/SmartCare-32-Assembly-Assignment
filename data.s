; ================================
; data.s - Shared Data Definitions
; ================================
        AREA SharedData, DATA, READWRITE
        ALIGN 4

; Threshold values
HR_HIGH_THRESHOLD  EQU 120
O2_LOW_THRESHOLD   EQU 92  
SBP_HIGH_THRESHOLD EQU 160
SBP_LOW_THRESHOLD  EQU 90

; Patient Structure (28 bytes each)
; Byte 0-3: Patient ID
; Byte 4-7: Age
; Byte 8-11: Ward
; Byte 12-15: Heart Rate
; Byte 16-19: O2 Level
; Byte 20-23: Alert Count
; Byte 24-27: Billing Amount (cents)

; Export these so other files can use them
        EXPORT HR_HIGH_THRESHOLD
        EXPORT O2_LOW_THRESHOLD
        EXPORT SBP_HIGH_THRESHOLD
        EXPORT SBP_LOW_THRESHOLD

; Global variables
patients    DCD 1001    ; Patient 1 ID
            DCD 65      ; Age
            DCD 7       ; Ward
            DCD 130     ; Heart Rate
            DCD 95      ; O2 Level
            DCD 3       ; Alert Count
            DCD 12500   ; Billing
            
            DCD 1002    ; Patient 2 ID
            DCD 42      ; Age
            DCD 5       ; Ward
            DCD 110     ; Heart Rate
            DCD 98      ; O2 Level
            DCD 1       ; Alert Count
            DCD 8900    ; Billing

num_patients DCD 2      ; Number of patients

; Export global variables
        EXPORT patients
        EXPORT num_patients

; Alert buffer (16 bytes per alert)
alert_buffer       SPACE 160  ; 10 alerts * 16 bytes
alert_index        DCD 0
timestamp_counter  DCD 0

        EXPORT alert_buffer
        EXPORT alert_index
        EXPORT timestamp_counter

; Alert flags
hr_alert_flag      DCB 0
o2_alert_flag      DCB 0
sbp_alert_flag     DCB 0

        EXPORT hr_alert_flag
        EXPORT o2_alert_flag
        EXPORT sbp_alert_flag

        END