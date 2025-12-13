; ============================================================
; MODULE 01: Patient Record Initialization
; SUPER SIMPLE VERSION
; ============================================================

        AREA    Module01, CODE, READONLY
        
        ; Import from data file
        IMPORT  patient1_name
        IMPORT  patient2_name  
        IMPORT  patient3_name
        IMPORT  patient_id1
        IMPORT  patient_id2
        IMPORT  patient_id3
        IMPORT  med_list1
        IMPORT  med_list2
        IMPORT  med_list3
        
        ; Export functions
        EXPORT  init_patients
        EXPORT  get_patient1
        EXPORT  get_patient2
        EXPORT  get_patient3

; Memory addresses for patients
PATIENT1_ADDR    EQU  0x20000000
PATIENT2_ADDR    EQU  0x20000020  
PATIENT3_ADDR    EQU  0x20000040

; ============================================================
; Function: init_patients
; Initialize all 3 patients
; ============================================================
init_patients
    PUSH    {LR}
    
    BL      init_patient1
    BL      init_patient2  
    BL      init_patient3
    
    POP     {PC}

; ============================================================
; Patient 1: Shahriar Samrat
; ============================================================
init_patient1
    LDR     R4, =PATIENT1_ADDR
    
    ; Store ID
    LDR     R0, =patient_id1
    LDR     R1, [R0]
    STR     R1, [R4]
    
    ; Store name pointer
    LDR     R2, =patient1_name
    STR     R2, [R4, #4]
    
    ; Store age (35)
    MOV     R0, #35
    STRB    R0, [R4, #8]
    
    ; Store ward (201)
    MOV     R0, #201
    STRH    R0, [R4, #10]
    
    ; Store treatment code (1)
    MOV     R0, #1
    STRB    R0, [R4, #12]
    
    ; Store room rate (2500)
    LDR     R0, =2500
    STR     R0, [R4, #16]
    
    ; Store medicine list pointer
    LDR     R3, =med_list1
    STR     R3, [R4, #20]
    
    BX      LR

; ============================================================
; Patient 2: Dipa Biswas
; ============================================================
init_patient2
    LDR     R4, =PATIENT2_ADDR
    
    ; Store ID
    LDR     R0, =patient_id2
    LDR     R1, [R0]
    STR     R1, [R4]
    
    ; Store name pointer
    LDR     R2, =patient2_name
    STR     R2, [R4, #4]
    
    ; Store age (28)
    MOV     R0, #28
    STRB    R0, [R4, #8]
    
    ; Store ward (305)
    MOV     R0, #305
    STRH    R0, [R4, #10]
    
    ; Store treatment code (2)
    MOV     R0, #2
    STRB    R0, [R4, #12]
    
    ; Store room rate (1800)
    LDR     R0, =1800
    STR     R0, [R4, #16]
    
    ; Store medicine list pointer
    LDR     R3, =med_list2
    STR     R3, [R4, #20]
    
    BX      LR

; ============================================================
; Patient 3: Farhan Labib
; ============================================================
init_patient3
    LDR     R4, =PATIENT3_ADDR
    
    ; Store ID
    LDR     R0, =patient_id3
    LDR     R1, [R0]
    STR     R1, [R4]
    
    ; Store name pointer
    LDR     R2, =patient3_name
    STR     R2, [R4, #4]
    
    ; Store age (42)
    MOV     R0, #42
    STRB    R0, [R4, #8]
    
    ; Store ward (102)
    MOV     R0, #102
    STRH    R0, [R4, #10]
    
    ; Store treatment code (3)
    MOV     R0, #3
    STRB    R0, [R4, #12]
    
    ; Store room rate (3200)
    LDR     R0, =3200
    STR     R0, [R4, #16]
    
    ; Store medicine list pointer
    LDR     R3, =med_list3
    STR     R3, [R4, #20]
    
    BX      LR

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