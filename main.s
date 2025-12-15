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
    
    ;Small delay to ensure ITM is ready
    MOV R0, #1000
init_delay
    SUBS R0, R0, #1
    BNE init_delay

        ; ALL MODULE CALLS
        BL init_patients
        BL module_two
        BL module_three
        BL module_four
        BL module_five
        BL module_six
        BL module_seven
        BL module_eight
        BL module_nine
        BL module_ten
        BL module_eleven
      
stop
    B stop

END