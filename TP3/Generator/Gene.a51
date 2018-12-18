;En-tête

;Déclaration des  variables 
LED		bit		P3.0
ETAT		bit		20h

;Table des vecteurs
			org		0000h
			SJMP		debut
			org		000Bh
			LJMP		interrupt
			org		0030h
			
debut:	
			CLR		LED
			SETB		ETAT		
			MOV		TMOD,#1h		;On initialise le timer en mode 1 avec GATE=0 et C/T=0
			MOV		IE,#10000010b		;Activation du timer 0		
			SETB		TF0					

rpt:
f_rpt:	SJMP		rpt			
			
fin:


interrupt:
  			CPL 		LED
si:                     JNB		ETAT,sinon              ;si état bas --> wait after 200µs
 			MOV		R0,#3fh
 			MOV		R1,#0ffh
fsi:
sinon:                  JB		ETAT,fsin        	;si état haut --> wait after 800µs
 			MOV		R0,#0e7h
			MOV		R1,#0fch
fsin:
 			CPL		ETAT					
			CLR		TR0
			MOV		A,TL0			;1cm
			ADD             A,R0			;1cm / On veut compter 50 000 µs donc ffffh-c34fh+07h=3cb7h (7instructions)
			MOV		TL0,A			;1cm
			MOV		A,TH0                   ;1cm
			ADDC		A,R1	                ;1cm
			MOV		TH0,A			;1cm
			SETB		TR0			;1cm / On démarre le timer
			
			RETI
							
			end
