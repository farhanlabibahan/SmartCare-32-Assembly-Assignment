        AREA    debug, CODE, READONLY
        EXPORT  debug_send
        EXPORT  debug_init
        
; ITM Register addresses
ITM_PORT0       EQU 0xE0000000
ITM_TER         EQU 0xE0000E00
ITM_TPR         EQU 0xE0000E40
ITM_TCR         EQU 0xE0000E80
ITM_LAR         EQU 0xE0000FB0

debug_init
    ; Initialize ITM for debug output
    PUSH {R0-R2, LR}
    
    ; Unlock ITM
    LDR R0, =ITM_LAR
    LDR R1, =0xC5ACCE55
    STR R1, [R0]
    
    ; Enable ITM
    LDR R0, =ITM_TCR
    LDR R1, =0x00010001      ; Enable ITM with sync packets
    STR R1, [R0]
    
    ; Enable stimulus port 0
    LDR R0, =ITM_TER
    LDR R1, =0x00000001      ; Enable port 0
    STR R1, [R0]
    
    ; Set privilege level
    LDR R0, =ITM_TPR
    LDR R1, =0x00000000      ; Allow all privilege levels
    STR R1, [R0]
    
    POP {R0-R2, PC}

debug_send
    ; Send character in R0 via ITM port 0
    ; Input: R0 = character to send
    PUSH {R1-R2, LR}
    
    LDR R1, =ITM_PORT0
    
    ; Wait for port to be ready
wait_ready
    LDR R2, [R1]
    TST R2, #1              ; Check FIFOREADY bit
    BEQ wait_ready
    
    ; Send character
    STRB R0, [R1]           ; Use STRB for byte write
    
    ; Small delay to ensure write completes
    MOV R2, #100
delay
    SUBS R2, R2, #1
    BNE delay
    
    POP {R1-R2, PC}
    
    END