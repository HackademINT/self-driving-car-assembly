;En-tête

;Déclaration des  variables 
W1_L 		data 		7Fh			
W1_H		data		7Eh
W2_L 		data		7Dh			
W2_H		data		7Ch
RES		bit		P3.7	
	

;Table des vecteurs
			org		0000h
			SJMP		debut
			org		0030h
			
debut:	
			MOV 		R0,#W1_H
			MOV 		R1,#W2_H
			LCALL		comp
			MOV 		C,F0
			MOV		RES,C

fin:		        SJMP		debut

;--------------------------------------------
comp:		
			MOV		A,@R0
			CLR		C
			SUBB 		A,@R1
si:  		        JNZ		fsi
			INC		R0
			INC 		R1
			MOV 		A,@R0
			CLR		C
			SUBB		A,@R1
fsi:
			MOV		F0,C
			RET

			end
