;Déclaration des  variables 
RegS		bit		P1.5
RW			bit		P1.6
E			bit		P1.7
LCD_DB	data		P2
W_L_L		equ		11000000b
W_L_H		equ		10000000b 
;Table des vecteurs
			org		0000h
			SJMP		debut
			org		0030h
			
;Définition des chaines de caractère à envoyer
ligne_H:	DB			'*** Bonjour ***',0
ligne_L:	DB			'*** ISE 2018 ***',0

;Début du programme			
debut:	
			MOV		SP,2Fh			;On déplace le StackPointer
			LCALL		LCD_Init
			;ligne haute
			MOV		LCD_DB,#W_L_H
			LCALL		LCD_Code
			MOV		DPTR,#ligne_H
			LCALL		LCD_msg
			;On vérifie le busy_flag
			LCALL		LCD_BF
			;ligne basse
			MOV		LCD_DB,#W_L_L
			LCALL		LCD_Code
			MOV		DPTR,#ligne_L
			LCALL		LCD_msg
rpt:
f_rpt:	SJMP		rpt			
			
fin:

;-----------------------------------------------------------------------------

LCD_msg:	
message:
			MOV		A,#0h
			MOVC		A,@A+DPTR
			JZ			fin_msg
			MOV 		LCD_DB,A
			LCALL		LCD_Data
         INC		DPTR
         SJMP		message
fin_msg:					
   		RET
   		

;----------------------------------------------------------------------------

LCD_Init:
			MOV		R0,#03h			;On veut faire 3 fois l'initialisation 
			CLR		RegS				;On initialise une fois
			CLR		RW
			MOV		P2,#30h
tq_Init:	LCALL		Tempo_50ms		;On temporise pdt 50ms
			SETB		E
			CLR		E
ftq_Init:DJNZ		R0,tq_Init		;Tant que R0!=0 on refait l'init
			;On ecrit les quatres instructions nécessaires à l'initialisation.

			MOV		LCD_DB,#38h
			LCALL		LCD_Code
			MOV		LCD_DB,#0Ch
			LCALL		LCD_Code
			MOV		LCD_DB,#01h
			LCALL		LCD_Code
			MOV		LCD_DB,#06h
			LCALL		LCD_Code
fin_Init:
			RET


	
;-----------------------------------------------------------------------------

LCD_BF:	
			MOV		P2,#0FFh			;On initialise le port 2 pour la lecture
			CLR		RegS				;On place RS et R/W en mode lecture d'instruction
			SETB		RW	
tq_BF:	CLR		E					;On clear et puis on active E
			SETB		E					;On lit, on clear
fin_BF:	JB			P2.7,tq_BF		;Tant que BF est à l'état haut
			CLR		E
			RET
			
;-----------------------------------------------------------------------------

LCD_Code:
			CLR		RegS				;On place RS et R/W en mode envoie d'instruction
			CLR		RW	
			SETB		E
			CLR		E
			LCALL		LCD_BF			;On check si l'écran est busy
fin_Code:
			RET		
			
;----------------------------------------------------------------------------

LCD_Data:                      	

			SETB		RegS				;On se met en mode envoie de donnée
			CLR		RW
			SETB		E
			CLR		E
			LCALL		LCD_BF			;On attend que le busy flag soit à l'état bas
fin_Data:
			RET


			
;---------------------------------------------------------------------------

Tempo_50ms:
			MOV		TMOD,#1h				;On initialise le timer en mode 1 avec GATE=0 et C/T=0
deb_timer:	
			MOV		TH0,#3ch		
			MOV		TL0,#0b0h			;On veut compter 50 000 µs donc ffffh-c34fh=3cb0h
			SETB		TR0					;On démarre le timer
			CLR		TF0
tq:		JNB   	TF0,tq
			CLR		TR0
fin_Tempo:			
			RET											
			
			end
			 
