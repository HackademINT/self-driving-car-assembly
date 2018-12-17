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
			org		0003h
			LJMP		routine_interruption
			org		0030h
			
debut:	
			MOV		SP,#30h				;On deplace le SP en 0030h
			SETB		IT0					;On met IT0 à 1
			MOV		IE,#81h				;On active les interruptions
rpt:
jsq:		SJMP		rpt

fin:
;--------------------------------------------
routine_interruption:
			LCALL		init_comp
			LCALL		comp
			MOV 		C,F0
			MOV		SUP,C					; SUP prend la valeur de la carry (1 si c'est supérieur ou égal)
			CPL 		C						; on affecte inv(SUP) à INF (condition <)
			MOV 		INF, C
			RETI
			
;-------------------------------------------- 
init_comp:		

			MOV		A,P1					;On met P1 dans A pour faciliter les permutations circulaires 
			MOV      W2_L,#MASK			;On fait un ET entre P1 et le masque qui nous donne W2_L
			ANL		W2_L,A
			
			RR			A						;Double rotation a droite
			RR			A
			MOV		W2_H,#MASK			;On fait un ET entre P1 et le masque qui nous donne W1_H
			ANL		W2_H,A		
			
			SWAP		A						;On fait un swap de A
			MOV		W1_H,#MASK			;On fait un ET entre P1 et le masque qui nous donne W1_L
			ANL		W1_H,A
			
			RL			A						;On fait une rotation de la gauche vers la droite de l'entree
			RL			A
			MOV		W1_L,#MASK			;On fait un ET entre P1 et le masque qui nous donne W2_H
			ANL		W1_L,A
			
			MOV 		R0,#W1_H
			MOV 		R1,#W2_H
			
			RET
			
;--------------------------------------------
comp:		
			MOV		A,@R0
			CLR		C
			SUBB 		A,@R1
si:  		JNZ		fsi
			INC		R0
			INC 		R1
			MOV 		A,@R0
			CLR		C
			SUBB		A,@R1
fsi:
			MOV		F0,C
			RET

			end
			 
