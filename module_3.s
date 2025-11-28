        AREA myData, DATA, READWRITE
        ALIGN 4

; 		threshold values
;
HR_HIGH_THRESHOLD  EQU 120
O2_LOW_THRESHOLD   EQU 92  
SBP_HIGH_THRESHOLD EQU 160
SBP_LOW_THRESHOLD  EQU 90
	
	

; 	alert flags

hr_alert_flag      DCB 0
o2_alert_flag      DCB 0
sbp_alert_flag     DCB 0


; ------------------------Alert buffer (16 bytes per alert, space for 10 alerts)
alert_buffer       SPACE 160  ; 10*16

; Alert buffer index---------------------------------------
alert_index        DCD 0

; 	
;
; Time STAMP COUNTER
timestamp_counter  DCD 0

        AREA |.text|, CODE, READONLY
        EXPORT main
        ENTRY

main


    ; 	RESETTING ALL VALUES
	
	
    MOV R0, #0
    LDR R1, =hr_alert_flag
    STRB R0, [R1]
    LDR R1, =o2_alert_flag
    STRB R0, [R1]
    LDR R1, =sbp_alert_flag
    STRB R0, [R1]
    
    ; 	Init alert + timestamp index
	
	
    LDR R1, =alert_index
    STR R0, [R1]
    LDR R1, =timestamp_counter
    STR R0, [R1]
    
	
    ; 		-------------Sample VALUES
	
    MOV R0, #130        ; High HR 
    MOV R1, #170        ; High SBP 
    MOV R2, #90         ; Low O2 
	
	;           all should trigger alert
	
	
    BL check_thresholds
    
stop
    B stop


check_thresholds

    ; 		Check Heart Rate if (HR > 120)
    CMP R0, #HR_HIGH_THRESHOLD
    BLE check_sbp
    
    ; HR alert triggered
	
    MOV R3, #1          ; Vital type: 1 = HR
    MOV R4, R0          ; Actual reading
    BL create_alert
    
    ; Set HR alert flag
    MOV R5, #1
    LDR R6, =hr_alert_flag
    STRB R5, [R6]

check_sbp
    ; Check SBP thresholds 
    CMP R1, #SBP_HIGH_THRESHOLD
    BGT sbp_alert
    CMP R1, #SBP_LOW_THRESHOLD
    BGE check_o2
    
sbp_alert
    ; SBP alert triggered
    MOV R3, #2          ; Vital type: 2 = SBP
    MOV R4, R1          ; Actual reading
    BL create_alert
    
    ; Set SBP alert flag
    MOV R5, #1
    LDR R6, =sbp_alert_flag
    STRB R5, [R6]

check_o2
    ; Check O2 threshold (O2 < 92)
    CMP R2, #O2_LOW_THRESHOLD
    BGE thresholds_done
    
    ; O2 alert triggered
    MOV R3, #3          ; Vital type: 3 = O2
    MOV R4, R2          ; Actual reading
    BL create_alert
    
    ; Set O2 alert flag
    MOV R5, #1
    LDR R6, =o2_alert_flag
    STRB R5, [R6]

thresholds_done
    BX LR

; 		------  Function to create alert record

create_alert
    ; Get current alert buffer position
    LDR R5, =alert_index
    LDR R6, [R5]        ; R6 = current index
    
    ; Calculate buffer address: alert_buffer + (index * 16)
    LDR R7, =alert_buffer
    MOV R8, #16
    MUL R9, R6, R8      ; R9 = index * 16
    ADD R10, R7, R9     ; R10 = alert record address
    
    ; Store vital type
    STR R3, [R10]
    
    ; Store actual reading 
    STR R4, [R10, #4]
    
    ; Get and store timestamp
    LDR R11, =timestamp_counter
    LDR R12, [R11]      ; R12 = current timestamp
    STR R12, [R10, #8]
    
    ; Increment timestamp for next alert
    ADD R12, R12, #1
    STR R12, [R11]
    
    ; MODULO
    ADD R6, R6, #1
    CMP R6, #10
    MOVGE R6, #0
    STR R6, [R5]
    
    BX LR

    END