        AREA myData, DATA, READWRITE
        ALIGN 4


; Patient names 
patient1_name  		DCB "Dipa Biswas",0
patient2_name     	DCB "Shahriar Samrat",0
med_list1    		DCD 0x12345678, 0x9ABCDEF0, 0
med_list2    		DCD 0x11111111, 0x22222222, 0x33333333, 0

        AREA PatientData, DATA, READWRITE
        ALIGN 4

patient_struct SPACE 32  ; space f0r patients


        AREA |.text|, CODE, READONLY
        EXPORT main
        ENTRY

main
    ; patient 1    data entry
    LDR R0, =0x20000000      
    BL init_patient1
    
    ; patient 2     data entry
    LDR R0, =0x20000010      
    BL init_patient2

stop
    B stop


init_patient1
    
    LDR R1, =0x00001001      ; id
    STR R1, [R0]             
    
   
    LDR R1, =patient1_name   ;   name
    STR R1, [R0, #4]         
    
    
    MOV R1, #45              ;  age
    STRB R1, [R0, #8]        
    
     
    MOV R1, #205             ;  ward
    STRH R1, [R0, #9]        
    
    
    MOV R1, #0x3A            ;    treatement code
    STRB R1, [R0, #11]       
    
    
    LDR R1, =2500            ;room daily rate
    STR R1, [R0, #12]        
    BX LR

; patient 2 data entry

init_patient2
    LDR R1, =0x00001002      
    STR R1, [R0]             
    
    LDR R1, =patient2_name   
    STR R1, [R0, #4]         
    
    MOV R1, #32              
    STRB R1, [R0, #8]        
    
    MOV R1, #107             
    STRH R1, [R0, #9]        
    
    MOV R1, #0x2B            
    STRB R1, [R0, #11]       
    
    LDR R1, =1800            
    STR R1, [R0, #12]        
    BX LR

    END