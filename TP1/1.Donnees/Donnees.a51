;En-tête

;Déclaration des  variables 

VAR		equ	0A4h		;constante
Adro_1	        data	10h		;adresse octet
Adro_2	        data	31h		;adresse octet
Adrb		bit	31h		;adresse bit

;Table des vecteurs
			org	0000h
			SJMP	start
			org	0030h
			

;main			
start:
			MOV A,VAR		;(A) <- VAR
			MOV P0,VAR		;(P0) <- VAR
			MOV PSW,#0		;(R0[0]) <- VAR
			MOV R0,VAR
			SETB RS0		;(R0[1]) <- VAR
			MOV R0,VAR			
			MOV Adro_1,VAR		;((Adro_1))<- VAR
			MOV Adro_2,@R1		;((Adro_2))<-((R1[1]))
			SETB Adrb		;((Adrb))<-1b
stop:		        SJMP stop		;fin
			end

