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
		IMPORT  module_four
		IMPORT	module_nine
		IMPORT 	module_five
		IMPORT	module_six
		IMPORT  module_seven
		IMPORT  module_eight
		IMPORT  module_ten
			
		

main
               
		
		; MODULE 10
		BL		module_ten
		
		; MODULE 11
		;BL		module_eleven
		
		
		
		
        
        
        
tata
        B       tata           ; infinite loop
        END