;Déclaration des  variables 
Mask4bit		equ	   00001111b
MaskAscii	        equ		30h
RegS			bit		P1.5
RW		        bit		P1.6
E			bit		P1.7
LCD_DB		        data		P2
W_L_L			equ		11000000b
W_L_H			equ		10000000b

;Table des vecteurs
			org		0000h
			SJMP		debut
			org		0030h

;Début du programme			
debut:	
			MOV		SP,2Fh			;On déplace le StackPointer
			LCALL		serial_init
			LCALL		LCD_Init
rpt:
			LCALL		serial_msg
			MOV		LCD_DB,#W_L_H	        ;On écrit sur la ligne haute
			LCALL		LCD_Code
			MOV		DPTR,#LCD_DB   
			LCALL		LCD_msg		
jsq:     SJMP 		rpt	

fin:

;------------------------------------------------------------

serial_init:
			MOV		SCON,#01010000b	        ;On initialise la liaison série, asynchrone 1200Bd sans parité
			MOV		PCON,#0h
			MOV		TMOD,#00100010b         ;On initialise le timer 0 et le timer 1
fin_serial_init:			
			RET
			
;-----------------------------------------------------------

serial_msg:
			MOV		TH1,#0E6h
			MOV		TL1,#0E6h
			SETB		TR1			;On démarre le timer 
tq:		        JNB		RI,tq			;On attend la reception du message
			CLR		RI
			MOV		LCD_DB,#SBUF		;On place SBUF dans P2
			
fin_serial_msg:
			RET			


;-----------------------------------------------------------------------------

LCD_msg:	
message:
			MOV		A,#0h
			MOVC		A,@A+DPTR
			JZ	        fin_LCD_msg
			MOV 		LCD_DB,A
			LCALL		LCD_Data
                        INC		DPTR
                        SJMP		message
fin_LCD_msg:					
   	          	RET
   		

;----------------------------------------------------------------------------

LCD_Init:
			MOV		R0,#03h			;On veut faire 3 fois l'initialisation 
			CLR		RegS			;On initialise une fois
			CLR		RW
			MOV		P2,#30h
tq_Init:	        LCALL		Tempo_50ms		;On temporise pdt 50ms
			SETB		E
			CLR		E
ftq_Init:DJNZ		R0,tq_Init		                ;Tant que R0!=0 on refait l'init
			;On ecrit les quatres instructions nécessaires à l'initialisation.
			MOV		LCD_DB,#38h
			LCALL		LCD_Code
			MOV		LCD_DB,#0Ch
			LCALL		LCD_Code
			MOV		LCD_DB,#01h
			LCALL		LCD_Code
			MOV		LCD_DB,#06h
			LCALL		LCD_Code
fin_LCD_Init:
			RET


	
;-----------------------------------------------------------------------------

LCD_BF:	
			MOV		P2,#0FFh		  ;On initialise le port 2 pour la lecture
			CLR		RegS			  ;On place RS et R/W en mode lecture d'instruction
			SETB		RW	
tq_BF:	                CLR		E		          ;On clear et puis on active E
			SETB		E			  ;On lit, on clear
fin_BF:	                JB		P2.7,tq_BF		  ;Tant que BF est à l'état haut
			CLR		E
			RET
			
;-----------------------------------------------------------------------------

LCD_Code:
			CLR		RegS			  ;On place RS et R/W en mode envoie d'instruction
			CLR		RW	
			SETB		E
			CLR		E
			LCALL		LCD_BF			  ;On check si l'écran est busy
fin_Code:
			RET		
			
;----------------------------------------------------------------------------

LCD_Data:                      	

			SETB		RegS			  ;On se met en mode envoie de donnée
			CLR		RW
			SETB		E
			CLR		E
			LCALL		LCD_BF			  ;On attend que le busy flag soit à l'état bas
fin_Data:
			RET


			
;---------------------------------------------------------------------------

Tempo_50ms:
deb_timer:	
			MOV		TH0,#3ch		
			MOV		TL0,#0b0h		  ;On veut compter 50 000 µs donc ffffh-c34fh=3cb0h
			SETB		TR0			  ;On démarre le timer
			CLR		TF0
tq_timer:		JNB   	        TF0,tq
			CLR		TR0
fin_Tempo:			
			RET											
			
			end
