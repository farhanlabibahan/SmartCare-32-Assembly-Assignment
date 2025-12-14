        AREA SharedData, DATA, READWRITE
        
        ; MODULE 01: Patient Information

; Patient Names
patient1_name       DCB "Shahriar Samrat", 0
                    ALIGN 4
patient2_name       DCB "Dipa Biswas", 0
                    ALIGN 4
patient3_name       DCB "Farhan Labib", 0
                    ALIGN 4

; Patient ID
patient_id1        DCD 0x00001001
patient_id2        DCD 0x00001002
patient_id3        DCD 0x00001003

; Medicine Lists
med_list1           DCD 0x11111111, 0x22222222
med_list2           DCD 0x12345678, 0x9ABCDEF0, 0
med_list3           DCD 0xDEADBEEF, 0xFEEDC

        EXPORT patient1_name
        EXPORT patient2_name
        EXPORT patient3_name
        EXPORT med_list1
        EXPORT med_list2
        EXPORT med_list3
        EXPORT patient_id1
        EXPORT patient_id2
        EXPORT patient_id3

        ; MODULE 02: Patient Vitals Indexes

HR1    EQU 0x20001000  ; Patient 1 Heart Rate
BP1    EQU 0x20001004  ; Patient 1 Blood Pressure
O21    EQU 0x20001008  ; Patient 1 Oxygen

HR2    EQU 0x2000100C  ; Patient 2 Heart Rate
BP2    EQU 0x20001010  ; Patient 2 Blood Pressure
O22    EQU 0x20001014  ; Patient 2 Oxygen

HR3    EQU 0x20001018  ; Patient 3 Heart Rate
BP3    EQU 0x2000101C  ; Patient 3 Blood Pressure
O23    EQU 0x20001020  ; Patient 3 Oxygen

; Buffers for 2 patients (10 readings each)
hr1_buffer   SPACE 40   ; 10 words for Patient 1 HR
hr2_buffer   SPACE 40   ; Patient 2 HR
hr3_buffer   SPACE 40   ; Patient 3 HR

bp1_buffer   SPACE 40   ; Patient 1 BP
bp2_buffer   SPACE 40   ; Patient 2 BP
bp3_buffer   SPACE 40   ; Patient 3 BP

o21_buffer   SPACE 40   ; Patient 1 O2
o22_buffer   SPACE 40   ; Patient 2 O2
o23_buffer   SPACE 40   ; Patient 3 O2

; Indexes (one for each buffer)
hr1_index    DCD 0
hr2_index    DCD 0
hr3_index    DCD 0

bp1_index    DCD 0
bp2_index    DCD 0
bp3_index    DCD 0

o21_index    DCD 0
o22_index    DCD 0
o23_index    DCD 0

        EXPORT HR1
        EXPORT BP1
        EXPORT O21
        EXPORT HR2
        EXPORT BP2
        EXPORT O22
        EXPORT HR3
        EXPORT BP3
        EXPORT O23
        EXPORT hr1_index
        EXPORT hr2_index
        EXPORT hr3_index
        EXPORT bp1_index
        EXPORT bp2_index
        EXPORT bp3_index
        EXPORT o21_index
        EXPORT o22_index
        EXPORT o23_index
        EXPORT hr1_buffer
        EXPORT hr2_buffer
        EXPORT hr3_buffer
        EXPORT bp1_buffer
        EXPORT bp2_buffer
        EXPORT bp3_buffer
        EXPORT o21_buffer
        EXPORT o22_buffer
        EXPORT o23_buffer

        ; MODULE 03: Alert Management

; Threshold values
HR_HIGH_THRESHOLD  EQU 120
O2_LOW_THRESHOLD   EQU 92  
SBP_HIGH_THRESHOLD EQU 160
SBP_LOW_THRESHOLD  EQU 90

; Alert flags (1 byte each) for each patient
hr_alert_flag1      DCB 0
o2_alert_flag1      DCB 0
sbp_alert_flag1     DCB 0

hr_alert_flag2      DCB 0
o2_alert_flag2      DCB 0
sbp_alert_flag2     DCB 0

hr_alert_flag3      DCB 0
o2_alert_flag3      DCB 0
sbp_alert_flag3     DCB 0

; Alert buffers for each patient (10 alerts each)
alert_buffer1       SPACE 160  ; Patient 1 alerts
alert_buffer2       SPACE 160  ; Patient 2 alerts
alert_buffer3       SPACE 160  ; Patient 3 alerts

; Current alert indexes for each patient
alert_index1        DCD 0
alert_index2        DCD 0
alert_index3        DCD 0

; Timestamp counter
timestamp_counter   DCD 0

;   MODULE 09: Patient Alert Counts

; Patient alert counts (increment when new alert created)
patient_alert_count1 DCD 0
patient_alert_count2 DCD 0  
patient_alert_count3 DCD 0

        ; ============================
        ; FIXED EXPORTS - Separate lines
        ; ============================
        EXPORT hr_alert_flag1
        EXPORT hr_alert_flag2
        EXPORT hr_alert_flag3
        EXPORT o2_alert_flag1
        EXPORT o2_alert_flag2
        EXPORT o2_alert_flag3
        EXPORT sbp_alert_flag1
        EXPORT sbp_alert_flag2
        EXPORT sbp_alert_flag3
        EXPORT alert_buffer1
        EXPORT alert_buffer2
        EXPORT alert_buffer3
        EXPORT alert_index1
        EXPORT alert_index2
        EXPORT alert_index3
        EXPORT timestamp_counter
        EXPORT patient_alert_count1
        EXPORT patient_alert_count2
        EXPORT patient_alert_count3
        EXPORT HR_HIGH_THRESHOLD
        EXPORT O2_LOW_THRESHOLD
        EXPORT SBP_HIGH_THRESHOLD
        EXPORT SBP_LOW_THRESHOLD


        ; Module 05 : Treatment Codes and Costs

TREATMENT_CODE    DCD     11     ; input value will be stored here
TREATMENT_COST    DCD     0       ; output cost will be stored here

        EXPORT TREATMENT_CODE
        EXPORT TREATMENT_COST


        ; Module 06 : Room Rent 

ROOM_RATE       DCD     15      ; YOU SET THIS IN MEMORY WINDOW
DAYS_STAYED     DCD     5      ; YOU SET THIS IN MEMORY WINDOW
ROOM_COST       SPACE   4      ; OUTPUT WRITTEN HERE

        EXPORT ROOM_COST
        EXPORT DAYS_STAYED
        EXPORT ROOM_RATE

        ; Module 07: Medicine Cost
TOTAL_MED_COST  SPACE   4    ; Module 7 writes here
        EXPORT TOTAL_MED_COST

        ; Module 08 : Final Bill
MEDICINE_COST   SPACE   4    ; Changed from DCD 5 to SPACE 4
        EXPORT MEDICINE_COST

LABTEST_COST     DCD  700    ; $7.00 in cents (changed from 7 to 700)
        EXPORT LABTEST_COST

TOTAL_BILL       DCD  0      ; OUTPUT
ERROR_FLAG       DCD  0      ; OUTPUT
        EXPORT TOTAL_BILL
        EXPORT ERROR_FLAG


        END