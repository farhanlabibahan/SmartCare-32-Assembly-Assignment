		AREA    myCode, CODE, READONLY
        EXPORT  main
        ENTRY
        
        ; Import functions from Module 01
        IMPORT  init_patients
        IMPORT  get_patient1
        IMPORT  get_patient2
        IMPORT  get_patient3
        
        ; IMPORT FROM MODULE 02-11
        IMPORT  module_two
        IMPORT  module_three
        IMPORT  module_four
        IMPORT  module_nine
        IMPORT  module_five
        IMPORT  module_six
        IMPORT  module_seven
        IMPORT  module_eight
        IMPORT  module_ten
        IMPORT  module_eleven
        
        ; --- ADD THESE IMPORTs ---
        IMPORT  TOTAL_MED_COST    ; From data.s
        IMPORT  MEDICINE_COST     ; From data.s
        ; -------------------------
                
main
    BL init_patients      ; Module 1
    BL module_two         ; Module 2
    BL module_three       ; Module 3
    BL module_four        ; Module 4
    BL module_five        ; Module 5
    BL module_six         ; Module 6
    BL module_seven       ; Module 7
    
    ; Copy medicine cost from Module 7 output to Module 8/10 input
    LDR R0, =TOTAL_MED_COST
    LDR R1, [R0]
    LDR R0, =MEDICINE_COST
    STR R1, [R0]
    
    BL module_eight       ; Module 8
    BL module_nine        ; Module 9
    BL module_ten         ; Module 10
    BL module_eleven      ; Module 11
    
tata
    B tata

    END