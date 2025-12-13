        AREA    myCode, CODE, READONLY
        EXPORT  main
        ENTRY
        
        ; Import functions from Module 01
        IMPORT  init_patients
        IMPORT  get_patient1
        IMPORT  get_patient2
        IMPORT  get_patient3
		; IMPORT FROM MODULE 02
		IMPORT	module_two
		; IMPORT FROM MODULE 03
		IMPORT	module_three
		; IMPORT FROM MODULE 09
		IMPORT	module_nine
		

main
        ; MODULE 01
        BL      init_patients
		
		; MODULE 02
		BL		module_two
		
		; MODULE 03
		BL		module_three
		
		; MODULE 09
		BL		module_nine
        
        
        
tata
        B       tata           ; infinite loop
        END