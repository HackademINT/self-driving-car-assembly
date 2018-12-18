;En-tête

;Déclaration des  variables 
LED		bit		P3.0


;Table des vecteurs
			org		0000h
			SJMP		debut
			org		0030h
			
debut:	
			CLR		LED		
			MOV		TMOD,#1h	  ;On initialise le timer en mode 1 avec GATE=0 et C/T=0
deb_timer:	
			CLR		TF0					
			CLR		TR0
			MOV		A,TL0		  ;1cm
			ADD             A,#0b7h		  ;1cm / On veut compter 50 000 µs donc ffffh-c34fh+07h=3cb7h (7instructions)
			MOV		TL0,A		  ;1cm
			MOV		A,TH0             ;1cm
			ADDC		A,#3ch            ;1cm
			MOV		TH0,A		  ;1cm
			SETB		TR0		  ;1cm / On démarre le timer
tq:		        JNB   	TF0,tq
			CPL		LED	
fin:		        SJMP		deb_timer
			
			end
