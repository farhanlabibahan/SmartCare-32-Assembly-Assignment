        AREA MainProg, CODE, READONLY
        EXPORT main
        ENTRY

        IMPORT init_patients
        IMPORT module_two
        IMPORT module_three
        IMPORT module_four
        IMPORT module_five
        IMPORT module_six
        IMPORT module_seven
        IMPORT module_eight
        IMPORT module_nine
        IMPORT module_ten
        IMPORT module_eleven
        IMPORT TOTAL_MED_COST
        IMPORT MEDICINE_COST
        IMPORT debug_send
        IMPORT debug_init

main
    ; Initialize ITM first
    BL debug_init
    
    ; Small delay after init
    MOV R0, #1000
init_delay
    SUBS R0, R0, #1
    BNE init_delay
    
    ; Send start marker
    MOV R0, #'S'          ; 'S' for Start
    BL debug_send
    
    ; Test init_patients
    BL init_patients
    MOV R0, #'1'          ; '1' for module 1
    BL debug_send
    
    ; Test module_two
    BL module_two
    MOV R0, #'2'          ; '2' for module 2
    BL debug_send
    
    ; Test module_three
    MOV R0, #'3'          ; '3' for module 3
    BL debug_send
    BL module_three

    ; Test module_four
        MOV R0, #'4'          ; '4' for module 4
        BL debug_send
        BL module_four


        ; Test module_five
        MOV R0, #'5'          ; '5' for module 5
        BL debug_send
        BL module_five

        ; Test module_six
        MOV R0, #'6'          ; '6' for module 6
        BL debug_send
        BL module_six

        ; Test module_seven
        MOV R0, #'7'          ; '7' for module 7
        BL debug_send
        BL module_seven
        ; Test module_eight
        MOV R0, #'8'          ; '8' for module 8
        BL debug_send
        BL module_eight
        ; Test module_nine
        MOV R0, #'9'          ; '9' for module 9
        BL debug_send
        BL module_nine
        ; Test module_ten
        MOV R0, #'A'          ; 'A' for module 10
        BL debug_send
        BL module_ten

        ; Test module_eleven
        MOV R0, #'B'          ; 'B' for module 11
        BL debug_send
        BL module_eleven



    
    ; ... rest of your original code ...
    
stop
    B stop

END