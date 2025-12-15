		AREA SharedData, DATA, READWRITE
        
        ; MODULE 01: Patient Information



; Patient Names
patient1_name       DCB "Shahriar Samrat", 0
                    ALIGN 4
patient2_name       DCB "Dipa Biswas", 0
                    ALIGN 4
patient3_name       DCB "Farhan Labib", 0
                    ALIGN 4

PATIENT1_ADDR    EQU  0x20000000
PATIENT2_ADDR    EQU  0x20000020  
PATIENT3_ADDR    EQU  0x20000040

        EXPORT PATIENT1_ADDR
        EXPORT PATIENT2_ADDR
        EXPORT PATIENT3_ADDR


; Patient ID
patient_id1        DCD 0x00001001
patient_id2        DCD 0x00001002
patient_id3        DCD 0x00001003

; Patient Age 
patient1_age       DCD 35
patient2_age       DCD 42
patient3_age       DCD 28

; Patient Ward 
patient1_ward      DCD 10
patient2_ward      DCD 11
patient3_ward      DCD 12
                    

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
        EXPORT patient1_age
        EXPORT patient2_age
        EXPORT patient3_age
        EXPORT patient1_ward
        EXPORT patient2_ward
        EXPORT patient3_ward


        ; MODULE 02: Patient Vitals - ACTUAL DATA (not EQU addresses)

; Actual vital data for patients (replace EQU with DCD)
HR1_data    DCD 80      ; Patient 1 Heart Rate
BP1_data    DCD 120     ; Patient 1 Blood Pressure
O21_data    DCD 98      ; Patient 1 Oxygen

HR2_data    DCD 75      ; Patient 2 Heart Rate
BP2_data    DCD 110     ; Patient 2 Blood Pressure
O22_data    DCD 96      ; Patient 2 Oxygen

HR3_data    DCD 90      ; Patient 3 Heart Rate
BP3_data    DCD 130     ; Patient 3 Blood Pressure
O23_data    DCD 94      ; Patient 3 Oxygen

; Buffers for 3 patients (10 readings each)
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

        ; Export the actual data variables (not EQU addresses)
        EXPORT HR1_data
        EXPORT BP1_data
        EXPORT O21_data
        EXPORT HR2_data
        EXPORT BP2_data
        EXPORT O22_data
        EXPORT HR3_data
        EXPORT BP3_data
        EXPORT O23_data
        
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


; Module 04: Medicine Administration Scheduler

; Internal clock counter (hours)
CLOCK_COUNTER   DCD     0

; Medicine 1 data
MED1_INTERVAL   DCD     6      ; Every 6 hours
MED1_LAST       DCD     0      ; Last administered time
MED1_NEXT       DCD     0      ; Next due time
MED1_FLAG       DCD     0      ; 0=not due, 1=dosage due

; Medicine 2 data  
MED2_INTERVAL   DCD     8      ; Every 8 hours
MED2_LAST       DCD     0      ; Last administered time
MED2_NEXT       DCD     0      ; Next due time
MED2_FLAG       DCD     0      ; 0=not due, 1=dosage due

; Medicine 3 data
MED3_INTERVAL   DCD     12     ; Every 12 hours
MED3_LAST       DCD     0      ; Last administered time
MED3_NEXT       DCD     0      ; Next due time
MED3_FLAG       DCD     0      ; 0=not due, 1=dosage due

        ; Export all variables
        EXPORT CLOCK_COUNTER
        EXPORT MED1_INTERVAL
        EXPORT MED1_LAST
        EXPORT MED1_NEXT
        EXPORT MED1_FLAG
        EXPORT MED2_INTERVAL
        EXPORT MED2_LAST
        EXPORT MED2_NEXT
        EXPORT MED2_FLAG
        EXPORT MED3_INTERVAL
        EXPORT MED3_LAST
        EXPORT MED3_NEXT
        EXPORT MED3_FLAG

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

; Module 05: Treatment Table (100 entries, 0-99)
TREATMENT_TABLE
    DCD 100,200,300,400,500,600,700,800,900,1000
    DCD 1100,1200,1300,1400,1500,1600,1700,1800,1900,2000
    DCD 2100,2200,2300,2400,2500,2600,2700,2800,2900,3000
    DCD 3100,3200,3300,3400,3500,3600,3700,3800,3900,4000
    DCD 4100,4200,4300,4400,4500,4600,4700,4800,4900,5000
    DCD 5100,5200,5300,5400,5500,5600,5700,5800,5900,6000
    DCD 6100,6200,6300,6400,6500,6600,6700,6800,6900,7000
    DCD 7100,7200,7300,7400,7500,7600,7700,7800,7900,8000
    DCD 8100,8200,8300,8400,8500,8600,8700,8800,8900,9000
    DCD 9100,9200,9300,9400,9500,9600,9700,9800,9900,10000

    EXPORT TREATMENT_TABLE

; Module 05 : Treatment Codes and Costs
TREATMENT_CODE    DCD     50     ; Test with treatment code 50 (should give 5100)
TREATMENT_COST    DCD     0      ; output cost will be stored here

    EXPORT TREATMENT_CODE
    EXPORT TREATMENT_COST


        ; Module 06 : Room Rent 

ROOM_RATE       DCD     15      ; YOU SET THIS IN MEMORY WINDOW
DAYS_STAYED     DCD     5      ; YOU SET THIS IN MEMORY WINDOW
ROOM_COST       SPACE   4      ; OUTPUT WRITTEN HERE

        EXPORT ROOM_COST
        EXPORT DAYS_STAYED
        EXPORT ROOM_RATE

        ; Module 07: Medicine Billing Data

; Medicine list format: Each entry is 12 bytes (3 words):
; [unit_price, quantity, days]
MED_LIST
    DCD 10, 2, 3       ; med1: price=10, quantity=2, days=3 → 10×2×3 = 60
    DCD 50, 1, 5       ; med2: price=50, quantity=1, days=5 → 50×1×5 = 250  
    DCD 20, 3, 2       ; med3: price=20, quantity=3, days=2 → 20×3×2 = 120
    ; Total: 60 + 250 + 120 = 430

NUM_MEDS        DCD 3   ; Number of medicines in the list

        EXPORT MED_LIST
        EXPORT NUM_MEDS
TOTAL_MED_COST  SPACE   4    ; Module 7 writes here
        EXPORT TOTAL_MED_COST

        ; Module 08 : Final Bill
MEDICINE_COST   SPACE   4    ; Changed from DCD 5 to SPACE 4
        EXPORT MEDICINE_COST

LABTEST_COST     DCD  7    ; $7.00 in cents (changed from 7 to 700)
        EXPORT LABTEST_COST

TOTAL_BILL       DCD  0      ; OUTPUT
ERROR_FLAG       DCD  0      ; OUTPUT
        EXPORT TOTAL_BILL
        EXPORT ERROR_FLAG

        ; Module 11 : Anomaly Detection Thresholds
                ; Module 11: Anomaly Detection Storage

ERROR_CODE       DCD  0      ; Type of error (1-6)
ERROR_ITEM       DCD  0      ; Which item failed
ERROR_INFO       DCD  0      ; Additional info
ERROR_TIMESTAMP  DCD  0      ; When error occurred


        EXPORT ERROR_CODE
        EXPORT ERROR_ITEM
        EXPORT ERROR_INFO
        EXPORT ERROR_TIMESTAMP


        END