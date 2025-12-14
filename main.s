        AREA    myCode, CODE, READONLY
        EXPORT  main
        ENTRY
        
        ; Import functions from Module 01
        IMPORT  init_patients
        IMPORT  get_patient1
        IMPORT  get_patient2
        IMPORT  get_patient3
		; IMPORT FROM MODULE 02-11
		IMPORT	module_two
		IMPORT	module_three
		IMPORT	module_nine
		IMPORT 	module_five
		IMPORT	module_six
		IMPORT  module_seven
		IMPORT  module_eight
			
		

main
        ; MODULE 01
        BL      init_patients
		
		; MODULE 02
		BL		module_two
		
		; MODULE 03
		BL		module_three
		
		; MODULE 09
		BL		module_nine
		
		; MODULE 05
		BL		module_five
		
		; MODULE 06
		BL		module_six
		
		; MODULE 07
		BL		module_seven
		
		; MODULE 08
		BL		module_eight
		
		
		
		
        
        
        
tata
        B       tata           ; infinite loop
        END