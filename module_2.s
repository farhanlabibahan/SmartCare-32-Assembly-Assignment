        AREA myData, DATA, READWRITE
        ALIGN 4

;
;   Sensor ADDRESS
HR_SENSOR_ADDR    EQU 0x20001000
BP_SENSOR_ADDR    EQU 0x20001004  
O2_SENSOR_ADDR    EQU 0x20001008

;   BUFFER CAL total
hr_buffer         SPACE 40
bp_buffer         SPACE 40  
o2_buffer         SPACE 40

; indexes
hr_index          DCD 0
bp_index          DCD 0
o2_index          DCD 0

        AREA |.text|, CODE, READONLY
        EXPORT main
        ENTRY

main
    ; 
	;   RESETTING ALL STUFF
    LDR R0, =hr_index
    MOV R1, #0
    STR R1, [R0]
    LDR R0, =bp_index
    STR R1, [R0]
    LDR R0, =o2_index
    STR R1, [R0]

    ;    READ sensors
    BL read_vital_signs

stop
    B stop


read_vital_signs
  
  
    LDR R0, =HR_SENSOR_ADDR
    LDR R1, [R0]               ; HR value read 
    
    LDR R2, =hr_buffer
    LDR R3, =hr_index
    LDR R4, [R3]               ;  index
    STR R1, [R2, R4, LSL #2]   
    
    ; 
	; 		Update index a/c BUFFER   + mod
	
    ADD R4, R4, #1
    CMP R4, #10
    MOVGE R4, #0
    STR R4, [R3]
    
    ; 	Read Blood Pressure  
    LDR R0, =BP_SENSOR_ADDR
    LDR R1, [R0]               ; BP read
    
    LDR R2, =bp_buffer
    LDR R3, =bp_index
    LDR R4, [R3]               
    STR R1, [R2, R4, LSL #2]  
    
	
	 
    ; 
	; 		Update index a/c BUFFER   + mod
	
    ADD R4, R4, #1
    CMP R4, #10
    MOVGE R4, #0
    STR R4, [R3]
    
    ;		 Read Oxygen
	
    LDR R0, =O2_SENSOR_ADDR
    LDR R1, [R0]              
    
    LDR R2, =o2_buffer
    LDR R3, =o2_index
    LDR R4, [R3]               
    STR R1, [R2, R4, LSL #2]   
    
    
	; 		Update index a/c BUFFER   + mod
    ADD R4, R4, #1
    CMP R4, #10
    MOVGE R4, #0
    STR R4, [R3]
    
    BX LR

    END