;En-tête

;Déclaration des  variables 
W1_L 		data 		7Fh			
W1_H		data		7Eh
W2_L 		data		7Dh			
W2_H		data		7Ch
SUP		bit		P3.7
INF		bit		P3.6	
MASK		data		03h

;Table des vecteurs
			org		0000h
			SJMP		debut
			org		0030h
			

debut:	
			MOV		SP,#30h				;On deplace le SP en 0030h
			
boucle:
			MOV		A,P1				;On met P1 dans A pour faciliter les permutations circulaires 
			MOV             W2_L,#MASK			;On fait un ET entre P1 et le masque qui nous donne W2_L
			ANL		W2_L,A
			
			RR		A				;Double rotation a droite
			RR		A				;Double rotation a droite
			MOV		W2_H,#MASK			;On fait un ET entre P1 et le masque qui nous donne W1_H
			ANL		W2_H,A		
			
			SWAP		A				;On fait un swap de A
			MOV		W1_H,#MASK			;On fait un ET entre P1 et le masque qui nous donne W1_L
			ANL		W1_H,A
			
			RL		A				;On fait une rotation de la gauche vers la droite de l'entree
			RL		A				;On fait une rotation de la gauche vers la droite de l'entree
			MOV		W1_L,#MASK			;On fait un ET entre P1 et le masque qui nous donne W2_H
			ANL		W1_L,A
			
					
			
			
			MOV		R0,W1_H				;On compare W1 et W2, meme programme que W_Comp_Rt
			MOV		R1,W2_H
			LCALL		routine
si:  		        JNZ		fsi				; Si C=1 jump à finsi
			MOV		R0,W1_L				; Si C=0
			MOV		R1,W2_L
			LCALL		routine	
fsi:											
			MOV		SUP,C				; SUP prend la valeur de la carry (1 si c'est supérieur ou égal)
			CPL 		C				; on affecte inv(SUP) à INF (condition <)
			MOV 		INF, C
			
fin:		        SJMP		boucle
			 	
routine:			
			MOV		A,R0
			CLR		C
			SUBB 		A,R1
			RET

			end
			
