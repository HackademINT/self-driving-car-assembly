;D�claration des  variables 
BP				bit		P0.0
Donnee		data		P1
Mask4bit		equ	   00001111b
MaskAscii	equ		30h

;Table des vecteurs
			org		0000h
			SJMP		debut
			org		0030h
			
;D�finition des chaines de caract�re � envoyer

;D�but du programme			
debut:	
			MOV		SP,2Fh			;On d�place le StackPointer
			LCALL		init
rpt:
att_bp1:	JNB		BP,att_bp1
att_bp2:	JB 		BP,att_bp2
			LCALL		msg
			
jsq:     SJMP 		rpt	
			
fin:

;------------------------------------------------------------

init:
			MOV		SCON,#01010000b	;On initialise la liaison s�rie, asynchrone 1200Bd sans parit�
			MOV		PCON,#0h
			MOV		TMOD,#00100000b
			MOV		TH1,#0E6h
			MOV		TL1,#0E6h
			SETB		TR1					;On d�marre le timer 
fin_init:			
			RET
			
;-----------------------------------------------------------

msg:
			MOV		A,Donnee
			ANL		A,#Mask4bit
			ORL		A,#MaskAscii
         MOV		SBUF,A	   		;On charge la donn�e dans le serial buffer
tq:		JNB		TI,tq					;On attend la fin de l'envoie du message
			CLR		TI
fin_msg:
			RET			
			
			end
			  
