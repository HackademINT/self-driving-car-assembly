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
			MOV		A,W1_H
			CLR		C
			SUBB 		A,W2_H
si:  		JNZ		fsi
			MOV 		A,W1_L
			CLR		C
			SUBB		A,W2_L
fsi:
			MOV		RES,C
fin:		SJMP		debut
			end
			
