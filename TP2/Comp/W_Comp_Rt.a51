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
			
			MOV		R0,W1_H
			MOV		R1,W2_H
			LCALL		routine
si:  		        JNZ		fsi
			
			MOV		R0,W1_L
			MOV		R1,W2_L
			LCALL		routine	
fsi:
			MOV		F0,C
			
fin:	          	SJMP		debut
			 	
routine:			
			MOV		A,R0
			CLR		C
			SUBB 		A,R1
			RET

			end
