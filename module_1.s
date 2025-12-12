        AREA myData, DATA, READWRITE
        ALIGN 4

; Patient names 
patient1_name   DCB "Dipa Biswas",0
                ALIGN 4          ; Align to word boundary
patient2_name   DCB "Shahriar Samrat",0
                ALIGN 4          ; Align to word boundary

; Medicine lists
med_list1       DCD 0x12345678, 0x9ABCDEF0, 0
med_list2       DCD 0x11111111, 0x22222222, 0x33333333, 0

        AREA PatientData, DATA, READWRITE
        ALIGN 4

; Space for 2 patient structures (24 bytes each)
patient_struct  SPACE 48        ; Reserve space for 2 patients (24 bytes each)

        AREA |.text|, CODE, READONLY
        EXPORT one
        
one
    ; Initialize patient 1 at address 0x20000000
    LDR R0, =0x20000000      
    BL init_patient1
    
    ; Initialize patient 2 at address 0x20000018 (24 bytes apart)
    LDR R0, =0x20000018      
    BL init_patient2

stop
    B stop


init_patient1
    ; Store Patient ID
    LDR R1, =0x00001001      
    STR R1, [R0]             ; Offset 0x00
    
    ; Store Name pointer
    LDR R1, =patient1_name   
    STR R1, [R0, #4]         ; Offset 0x04
    
    ; Store Age
    MOV R1, #45              
    STRB R1, [R0, #8]        ; Offset 0x08
    
    ; Store Ward number - properly aligned at halfword boundary
    MOV R1, #205             
    STRH R1, [R0, #10]       ; Offset 0x0A
    
    ; Store Treatment code
    MOV R1, #0x3A            
    STRB R1, [R0, #12]       ; Offset 0x0C
    
    ; Store Room Daily Rate
    LDR R1, =2500            
    STR R1, [R0, #16]        ; Offset 0x10
    
    ; Store Medicine List pointer
    LDR R1, =med_list1       
    STR R1, [R0, #20]        ; Offset 0x14
    
    BX LR

init_patient2
    ; Store Patient ID
    LDR R1, =0x00001002      
    STR R1, [R0]             ; Offset 0x00
    
    ; Store Name pointer
    LDR R1, =patient2_name   
    STR R1, [R0, #4]         ; Offset 0x04
    
    ; Store Age
    MOV R1, #32              
    STRB R1, [R0, #8]        ; Offset 0x08
    
    ; Store Ward number
    MOV R1, #107             
    STRH R1, [R0, #10]       ; Offset 0x0A
    
    ; Store Treatment code
    MOV R1, #0x2B            
    STRB R1, [R0, #12]       ; Offset 0x0C
    
    ; Store Room Daily Rate
    LDR R1, =1800            
    STR R1, [R0, #16]        ; Offset 0x10
    
    ; Store Medicine List pointer
    LDR R1, =med_list2       
    STR R1, [R0, #20]        ; Offset 0x14
    
    BX LR

    END