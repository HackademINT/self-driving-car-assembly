;En-t�te

;D�claration des  variables 
W1_L 		data 		7Fh			
W1_H		data		7Eh
W2_L 		data		7Dh			
W2_H		data		7Ch


;Table des vecteurs
			org		0000h
			SJMP		debut
			org		0030h
			
debut:
			MOV		A,W1_L
			ADD 		A,W2_L
			MOV 		R0,A
			MOV		A,W1_H
			ADDC 		A,W2_H
			MOV 		R1,A

fin:		SJMP		debut
			end
			
