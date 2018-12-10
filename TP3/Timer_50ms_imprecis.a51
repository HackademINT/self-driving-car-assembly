;En-tête

;Déclaration des  variables 
LED		bit		P3.0


;Table des vecteurs
			org		0000h
			SJMP		debut
			org		0030h
			
debut:	
			CLR		LED		
			MOV		TMOD,#1h				;On initialise le timer en mode 1 avec GATE=0 et C/T=0
deb_timer:	
			MOV		TH0,#3ch		
			MOV		TL0,#0b0h			;On veut compter 50 000 µs donc ffffh-c34fh=3cb0h
			SETB		TR0					;On démarre le timer
			CLR		TF0
tq:		JNB   	TF0,tq
			CLR		TR0
			CPL		LED		
fin:		SJMP		deb_timer
			
			end
			
