; ============================================================
; MODULE 01: Patient Record Initialization
; UPDATED VERSION - Uses data from data.s
; ============================================================

        AREA    Module01, CODE, READONLY
        
        ; Import from data file
        IMPORT  patient1_name
        IMPORT  patient2_name  
        IMPORT  patient3_name
        IMPORT  patient_id1
        IMPORT  patient_id2
        IMPORT  patient_id3
        IMPORT  patient1_age
        IMPORT  patient2_age
        IMPORT  patient3_age
        IMPORT  patient1_ward
        IMPORT  patient2_ward
        IMPORT  patient3_ward
        IMPORT  med_list1
        IMPORT  med_list2
        IMPORT  med_list3
        IMPORT PATIENT1_ADDR
        IMPORT PATIENT2_ADDR
        IMPORT PATIENT3_ADDR
        IMPORT ROOM_RATE
        
        ; Export functions
        EXPORT  init_patients
        EXPORT  get_patient1
        EXPORT  get_patient2
        EXPORT  get_patient3

; ============================================================
; Function: init_patients
; Initialize all 3 patients using data from data.s
; ============================================================
init_patients
    PUSH    {LR}
    
    BL      init_patient1
    BL      init_patient2  
    BL      init_patient3
    
    POP     {PC}

; ============================================================
; Patient 1: Shahriar Samrat
; Uses actual data from data.s
; ============================================================
init_patient1
    PUSH    {R4-R5, LR}
    LDR     R4, =PATIENT1_ADDR
    
    ; Store ID from data.s
    LDR     R0, =patient_id1
    LDR     R1, [R0]            ; Get ID from data.s
    STR     R1, [R4]            ; Store at patient record
    
    ; Store name pointer from data.s
    LDR     R2, =patient1_name  ; Get name address from data.s
    STR     R2, [R4, #4]        ; Store pointer
    
    ; Store age from data.s
    LDR     R0, =patient1_age
    LDR     R1, [R0]            ; Get age from data.s
    STR     R1, [R4, #8]        ; Store age
    
    ; Store ward from data.s (store as pointer to string)
    LDR     R2, =patient1_ward  ; Get ward address from data.s
    STR     R2, [R4, #12]       ; Store pointer
    
    ; Store treatment code (using default value 1)
    MOV     R0, #1
    STR     R0, [R4, #16]
    
    ; Store room rate (using value from data.s)
    LDR     R0, =ROOM_RATE
    LDR     R1, [R0]            ; Get room rate from data.s
    STR     R1, [R4, #20]       ; Store room rate
    
    ; Store medicine list pointer from data.s
    LDR     R3, =med_list1      ; Get med list address from data.s
    STR     R3, [R4, #24]       ; Store pointer
    
    POP     {R4-R5, PC}

; ============================================================
; Patient 2: Dipa Biswas
; Uses actual data from data.s
; ============================================================
init_patient2
    PUSH    {R4-R5, LR}
    LDR     R4, =PATIENT2_ADDR
    
    ; Store ID from data.s
    LDR     R0, =patient_id2
    LDR     R1, [R0]            ; Get ID from data.s
    STR     R1, [R4]
    
    ; Store name pointer from data.s
    LDR     R2, =patient2_name  ; Get name address from data.s
    STR     R2, [R4, #4]
    
    ; Store age from data.s
    LDR     R0, =patient2_age
    LDR     R1, [R0]            ; Get age from data.s
    STR     R1, [R4, #8]
    
    ; Store ward from data.s
    LDR     R2, =patient2_ward  ; Get ward address from data.s
    STR     R2, [R4, #12]
    
    ; Store treatment code (using default value 2)
    MOV     R0, #2
    STR     R0, [R4, #16]
    
    ; Store room rate (using value from data.s)
    LDR     R0, =ROOM_RATE
    LDR     R1, [R0]            ; Get room rate from data.s
    STR     R1, [R4, #20]
    
    ; Store medicine list pointer from data.s
    LDR     R3, =med_list2      ; Get med list address from data.s
    STR     R3, [R4, #24]
    
    POP     {R4-R5, PC}

; ============================================================
; Patient 3: Farhan Labib
; Uses actual data from data.s
; ============================================================
init_patient3
    PUSH    {R4-R5, LR}
    LDR     R4, =PATIENT3_ADDR
    
    ; Store ID from data.s
    LDR     R0, =patient_id3
    LDR     R1, [R0]            ; Get ID from data.s
    STR     R1, [R4]
    
    ; Store name pointer from data.s
    LDR     R2, =patient3_name  ; Get name address from data.s
    STR     R2, [R4, #4]
    
    ; Store age from data.s
    LDR     R0, =patient3_age
    LDR     R1, [R0]            ; Get age from data.s
    STR     R1, [R4, #8]
    
    ; Store ward from data.s
    LDR     R2, =patient3_ward  ; Get ward address from data.s
    STR     R2, [R4, #12]
    
    ; Store treatment code (using default value 3)
    MOV     R0, #3
    STR     R0, [R4, #16]
    
    ; Store room rate (using value from data.s)
    LDR     R0, =ROOM_RATE
    LDR     R1, [R0]            ; Get room rate from data.s
    STR     R1, [R4, #20]
    
    ; Store medicine list pointer from data.s
    LDR     R3, =med_list3      ; Get med list address from data.s
    STR     R3, [R4, #24]
    
    POP     {R4-R5, PC}

; ============================================================
; Get patient address functions
; ============================================================
get_patient1
    LDR     R0, =PATIENT1_ADDR
    BX      LR

get_patient2
    LDR     R0, =PATIENT2_ADDR
    BX      LR

get_patient3
    LDR     R0, =PATIENT3_ADDR
    BX      LR

        END