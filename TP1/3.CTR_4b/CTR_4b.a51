;En-tête

;Déclaration des  variables 

BP		bit	80h		;adresse port bouton
SEL		bit	81h		;adresse port selection
Aff		data 	0B0h		;adresse port led

;Table des vecteurs
			org	0000h
			SJMP	debut
			org	0030h
			
debut:
rpt:
att_bp1:	JNB BP,att_bp1
att_bp2:	JB BP,att_bp2
sidec:	        JB SEL,sinon 
		DEC Aff
		SJMP rpt			
sinon:	        INC Aff
		SJMP rpt				
finsi:
		end
