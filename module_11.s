        AREA Module11, CODE, READONLY
        EXPORT module_eleven
        IMPORT hr1_buffer
        IMPORT hr2_buffer
        IMPORT hr3_buffer

        IMPORT bp1_buffer
        IMPORT bp2_buffer
        IMPORT bp3_buffer

        IMPORT o21_buffer
        IMPORT o22_buffer
        IMPORT o23_buffer

        IMPORT hr1_index
        IMPORT hr2_index
        IMPORT hr3_index

        IMPORT bp1_index
        IMPORT bp2_index
        IMPORT bp3_index

        IMPORT o21_index
        IMPORT o22_index
        IMPORT o23_index

        IMPORT MED1_INTERVAL
        IMPORT MED2_INTERVAL
        IMPORT MED3_INTERVAL

        IMPORT TOTAL_BILL
        IMPORT ERROR_FLAG

        IMPORT debug_send
        IMPORT timestamp_counter
        IMPORT patient_alert_count1


module_eleven

    PUSH {LR, R4-R11}
    
    ; Clear all errors
    MOV R0, #0
    LDR R1, =ERROR_FLAG
    STR R0, [R1]
    
    
    BL check_sensor_repetition    ; Check 1: Sensor malfunction
    BL check_medicine_zero        ; Check 2: Invalid medicine dosage  
    BL check_memory_boundaries    ; Check 3: Memory overflow
    BL check_bill_sanity          ; Check 4: Bill sanity check
    
   
    
    POP {LR, R4-R11}
    BX LR

; CHECK 1: Sensor Malfunction Detection
; Check if same sensor value repeats > 10 times

check_sensor_repetition
    PUSH {LR}
    
    ; Check all 9 sensor buffers (3 patients × 3 sensors)
    
    ; Patient 1 sensors
    LDR R0, =hr1_buffer
    LDR R1, =hr1_index
    MOV R2, #1                    ; Sensor type: 1=HR
    MOV R3, #1                    ; Patient: 1
    BL check_single_sensor
    
    LDR R0, =bp1_buffer
    LDR R1, =bp1_index
    MOV R2, #2                    ; 2=BP
    MOV R3, #1
    BL check_single_sensor
    
    LDR R0, =o21_buffer
    LDR R1, =o21_index
    MOV R2, #3                    ; 3=O2
    MOV R3, #1
    BL check_single_sensor
    
    ; Patient 2 sensors
    LDR R0, =hr2_buffer
    LDR R1, =hr2_index
    MOV R2, #1
    MOV R3, #2
    BL check_single_sensor
    
    LDR R0, =bp2_buffer
    LDR R1, =bp2_index
    MOV R2, #2
    MOV R3, #2
    BL check_single_sensor
    
    LDR R0, =o22_buffer
    LDR R1, =o22_index
    MOV R2, #3
    MOV R3, #2
    BL check_single_sensor
    
    ; Patient 3 sensors
    LDR R0, =hr3_buffer
    LDR R1, =hr3_index
    MOV R2, #1
    MOV R3, #3
    BL check_single_sensor
    
    LDR R0, =bp3_buffer
    LDR R1, =bp3_index
    MOV R2, #2
    MOV R3, #3
    BL check_single_sensor
    
    LDR R0, =o23_buffer
    LDR R1, =o23_index
    MOV R2, #3
    MOV R3, #3
    BL check_single_sensor
    
    POP {PC}

; R0 = buffer address, R1 = index address, R2 = sensor type, R3 = patient


check_single_sensor
    PUSH {R4-R9, LR}
    
    MOV R4, R0          ; Buffer address
    MOV R5, R1          ; Index address
    MOV R6, R2          ; Sensor type
    MOV R7, R3          ; Patient number
    
    ;           Get current index
    LDR R8, [R5]        ; R8 = current index
    
    ; Need at least 10 readings to check
    CMP R8, #10
    BLT sensor_check_done
    
    ; Check last 10 readings
    ;..........
    ; Get the last value

    SUB R0, R8, #1      ; Last index
    BL wrap_index       ; Handle wrap-around
    BL get_buffer_value ; R0 = last value
    
    MOV R9, R0          ; R9 = reference value
    
    ; Now check if all last 10 readings are the same


    MOV R1, #1          ; Start checking from 1 reading ago
    MOV R2, #0          ; Match count (starts with last reading)
    
check_repetition_loop
    CMP R1, #10         ; Check up to 10 readings back
    BGE repetition_check_done
    
    ; Get index for reading i positions back
    SUB R0, R8, R1
    SUB R0, R0, #1      ; -1 because we already checked index-1
    BL wrap_index
    
    ; Get value at that index
    PUSH {R1-R2}
    BL get_buffer_value
    POP {R1-R2}
    
    ; CCCCCompare with reference
    CMP R0, R9
    BNE repetition_check_done  ; Different value found
    
    ; Saaaame value, continue checking
    ADD R1, R1, #1
    ADD R2, R2, #1
    B check_repetition_loop

repetition_check_done
    ;        If we found 10 identical readings (R2 = 9 means 10 total including reference)
    CMP R2, #9
    BLT sensor_check_done
    
    MOV R0, #1          ; Error code 1 = sensor malfunction
    MOV R1, R6          ; Sensor type
    MOV R2, R7          ; Patient number
    BL record_error
    
sensor_check_done
    POP {R4-R9, PC}

; Get value from circular buffer (0-9 index)
; R0 = index, R4 = buffer base
; Returns: R0 = value

get_buffer_value
    LDR R0, [R4, R0, LSL #2]  ; buffer[index * 4]
    BX LR

; Wrap index around 0-9
; R0 = index, returns wrapped index

wrap_index
    CMP R0, #0
    BGE wrap_check_high
    ADD R0, R0, #10     ;   Add 10 if negative
    B wrap_index        ;   Re-check
    
wrap_check_high
    CMP R0, #9
    BLE wrap_done
    SUB R0, R0, #10     ;   Subtract 10 if > 9
    B wrap_index        ;   Re-check
    
wrap_done
    BX LR

; CHECK 2: Invalid Medicine Dosage
; Check for zero or negative interval values


check_medicine_zero
    PUSH {LR}
    
    ; Check Medicine 1
    LDR R0, =MED1_INTERVAL
    LDR R0, [R0]
    CMP R0, #0
    BLE medicine1_error
    
    ; Check Medicine 2
    LDR R0, =MED2_INTERVAL
    LDR R0, [R0]
    CMP R0, #0
    BLE medicine2_error
    
    ; Check Medicine 3
    LDR R0, =MED3_INTERVAL
    LDR R0, [R0]
    CMP R0, #0
    BLE medicine3_error
    
    B medicine_check_done

medicine1_error
    MOV R0, #2          ; Error code 2 = medicine error
    MOV R1, #1          ; Medicine 1
    MOV R2, #0          ; Not used
    BL record_error
    B medicine_check_done

medicine2_error
    MOV R0, #2
    MOV R1, #2          ; Medicine 2
    MOV R2, #0
    BL record_error
    B medicine_check_done

medicine3_error
    MOV R0, #2
    MOV R1, #3          ; Medicine 3
    MOV R2, #0
    BL record_error

medicine_check_done
    POP {PC}

; CHECK 3: Memory Boundaries
; Check if critical data is within valid RAM range
check_memory_boundaries
    PUSH {LR}
    
    ; Define valid RAM range for Cortex-M (adjust as needed)
    LDR R4, =0x20000000  ; Start of SRAM
    LDR R5, =0x20010000  ; 64KB SRAM typical
    
    ; Check patient vital buffers
    LDR R0, =hr1_buffer
    BL check_address
    
    LDR R0, =hr2_buffer
    BL check_address
    
    LDR R0, =hr3_buffer
    BL check_address
    
    ; Check alert buffers
    LDR R0, =patient_alert_count1
    BL check_address
    
    ; Check bill data
    LDR R0, =TOTAL_BILL
    BL check_address
    
    ; Check medicine data
    LDR R0, =MED1_INTERVAL
    BL check_address
    
    POP {PC}

;       ------ Check if address is within bounds
; R0 = address to check, R4 = lower bound, R5 = upper bound

check_address
    CMP R0, R4
    BLT address_error
    
    CMP R0, R5
    BGT address_error
    
    BX LR

address_error
    MOV R0, #3          
    MOV R1, #0          ; Not applicable
    MOV R2, R0          ; Save the failing address
    BL record_error
    BX LR

; CHECK 4: Bill Sanity Check
; Ensure bill amount is reasonable

check_bill_sanity
    PUSH {LR}
    
    LDR R0, =TOTAL_BILL
    LDR R0, [R0]
    
    ; Check 1: Bill should not be negative

    CMP R0, #0
    BLT bill_negative_error
    
    ; Check 2: Bill should not exceed $1,000,000 (100,000,000 cents)

    LDR R1, =100000000
    CMP R0, R1
    BGT bill_too_large_error
    
    ; Check 3: Bill should be divisible by 1 cent (always true for integers)

    LDR R1, =0x7FFFFFFF  ; Max positive 32-bit
    CMP R0, R1
    BGT bill_overflow_error
    
    B bill_check_done

bill_negative_error
    MOV R0, #4          ; Error code 4 = negative bill
    MOV R1, #0
    MOV R2, #0
    BL record_error
    B bill_check_done

bill_too_large_error
    MOV R0, #5          ; Error code 5 = bill too large
    MOV R1, #0
    MOV R2, #0
    BL record_error
    B bill_check_done

bill_overflow_error
    MOV R0, #6          ; Error code 6 = bill overflow
    MOV R1, #0
    MOV R2, #0
    BL record_error

bill_check_done
    POP {PC}


; Record Error Function
; R0 = error code, R1 = item, R2 = additional info


record_error
    PUSH {R3-R5, LR}
    
    ; Set global error flag
    MOV R3, #1
    LDR R4, =ERROR_FLAG
    STR R3, [R4]
    
    ; Get current timestamp
    LDR R4, =timestamp_counter
    LDR R5, [R4]        ; R5 = timestamp
    
    
    ; Send error information via debug
    MOV R3, R0          ; Save error code
    
    ; Format: E{code}:P{item}:T{timestamp}
    MOV R0, #'E'
    BL debug_send
    MOV R0, #'='
    BL debug_send
    
    ; Error code
    MOV R0, R3
    BL print_number
    
    MOV R0, #':'
    BL debug_send
    
    ; Item (patient/medicine number)
    MOV R0, R1
    BL print_number
    
    MOV R0, #':'
    BL debug_send
    
    ; Timestamp
    MOV R0, R5
    BL print_number
    
    MOV R0, #' '
    BL debug_send
    
    POP {R3-R5, PC}


; Utility: Print Number (0-999)
print_number
    PUSH {R0-R2, LR}
    
    CMP R0, #0
    BNE not_zero_print
    
    MOV R0, #'0'
    BL debug_send
    B print_done
    
not_zero_print
    MOV R1, R0
    
    ; Hundreds
    CMP R1, #100
    BLT less_than_100_print
    MOV R0, R1
    MOV R2, #100
    BL simple_divide_print
    MOV R2, R1          ; Save remainder
    ADD R0, #'0'
    BL debug_send
    MOV R1, R2          ; Restore remainder
    
less_than_100_print
    ; Tens
    CMP R1, #10
    BLT less_than_10_print
    MOV R0, R1
    MOV R2, #10
    BL simple_divide_print
    MOV R2, R1          ; Save ones
    ADD R0, #'0'
    BL debug_send
    MOV R0, R2          ; Get ones
    ADD R0, #'0'
    BL debug_send
    B print_done
    
less_than_10_print
    ; Single digit
    MOV R0, R1
    ADD R0, #'0'
    BL debug_send
    
print_done
    POP {R0-R2, PC}

simple_divide_print
    ; R0 / R2, quotient in R0, remainder in R1
    PUSH {R3}
    MOV R3, #0
div_loop_print
    CMP R0, R2
    BLT div_done_print
    SUB R0, R0, R2
    ADD R3, R3, #1
    B div_loop_print
div_done_print
    MOV R1, R0      ; Remainder
    MOV R0, R3      ; Quotient
    POP {R3}
    BX LR

    ALIGN 4
    LTORG

    END