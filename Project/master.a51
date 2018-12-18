;declaration des variables
PWM_DIR		bit	P1.4
PWM_PROP	bit	P1.5

BTN_INC_DIR	bit	P3.0
BTN_DEC_DIR	bit	P3.1
BTN_INC_PROP	bit	P3.2
BTN_DEC_PROP	bit	P3.3
	
NEXT_PWM_STATE	data	7Fh
PROP_HH		data	7Eh
PROP_HL		data	7Dh
PROP_LH		data	7Ch
PROP_LL		data	7Bh
DIR_HH		data	7Ah
DIR_HL		data	79h
TMP_PROP_HH	data	78h
TMP_PROP_HL	data	77h
TMP_PROP_LH	data	76h
TMP_PROP_LL	data	75h
TMP_DIR_HH	data	74h
TMP_DIR_HL	data	73h

T_LOAD_H	equ	3Ch
T_LOAD_L	equ	0B0h
T_PROP_MIN_LH	equ	0B3h
T_PROP_MIN_LL	equ	0D4h

;====CENTRE====;
DIR_INIT_HH	equ	0FAh
DIR_INIT_HL	equ	24h
DIR_INIT_LH	equ	0FEh
DIR_INIT_LL	equ	0Ch
;=============;

;===GAUCHE===;
DIR_G_HH	equ	0F8h
DIR_G_HL       	equ	30h
DIR_G_LH       	equ	0FEh
DIR_G_LL       	equ	0Ch
;=============;

;===DROITE===;
DIR_D_HH	equ	0FCh
DIR_D_HL       	equ	18h
DIR_D_LH       	equ	0FEh
DIR_D_LL       	equ	0Ch
;=============;

;====ARRET====;
PROP_ARRET_HH	equ	0FAh
PROP_ARRET_HL	equ	24h
PROP_ARRET_LH	equ	0BFh
PROP_ARRET_LL	equ	8Ch
;=============;

;====AVANT====;
PROP_AV_HH	equ	0F8h
PROP_AV_HL    	equ	30h
PROP_AV_LH	equ	0C3h
PROP_AV_LL	equ	74h
;=============;

;===ARRIERE===;
PROP_AR_HH	equ	0FCh
PROP_AR_HL    	equ	18h
PROP_AR_LH	equ	0BBh
PROP_AR_LL	equ	0A4h
;=============;

;vtable
		org	0000h
		SJMP	debut
		org	000Bh
		LJMP	it_pwm
		org	0030h	
 
;main
debut:
		MOV	SP,#2Fh		          ;on deplace le stack pointer pour liberer la banque
					
		MOV	TMOD,#00010001b	          ;Timer0 en mode 1 (16bits) / Timer1 en mode 1 (16bits)
		SETB	EA			  ;Activation générale des interruptions
		SETB	ET0			  ;Activation de l'interruption d'overflow pour Timer0
		MOV	NEXT_PWM_STATE,#00b	  ;Etat suivant (direction haute)
		MOV	TH0,#PROP_ARRET_HH        ;on met la valeur de chargement de Timer0
		MOV	TL0,#PROP_ARRET_HL
		MOV	PROP_HL,#PROP_ARRET_HL
		MOV	PROP_HH,#PROP_ARRET_HH
		MOV	PROP_LL,#PROP_ARRET_LL
		MOV	PROP_LH,#PROP_ARRET_LH
		MOV	DIR_HL,#DIR_INIT_HL
		MOV	DIR_HH,#DIR_INIT_HH
		MOV	TMP_PROP_HL,PROP_HL
		MOV	TMP_PROP_HH,PROP_HH
		MOV	TMP_PROP_LL,PROP_LL
		MOV	TMP_PROP_LH,PROP_LH
		MOV	TMP_DIR_HL,DIR_HL
		MOV	TMP_DIR_HH,DIR_HH
		SETB	PWM_DIR
		SETB	TR0
					
rpt:
		;=========================;
		; entrees boutons inc/dec:
		;=========================;
		CLR	C				
si_bid1:	JNB	BTN_INC_DIR,fin_si_bid1
		MOV	A,DIR_HL
		SUBB	A,#0A0h
		MOV	TMP_DIR_HL,A
		MOV	A,DIR_HH
		SUBB	A,#0
		MOV	TMP_DIR_HH,A				
fin_si_bid1:	
si_bdd1:	JNB	BTN_DEC_DIR,fin_si_bdd1
           	MOV	A,DIR_HL
           	ADD	A,#0A0h
           	MOV	TMP_DIR_HL,A
           	MOV	A,DIR_HH
           	ADDC	A,#0
           	MOV	TMP_DIR_HH,A
fin_si_bdd1:
si_bip1:	JNB	BTN_INC_PROP,fin_si_bip1
            	MOV	A,PROP_HL
            	SUBB	A,#0A0h
            	MOV	TMP_PROP_HL,A
            	MOV	A,PROP_HH
		SUBB	A,#0
		MOV	TMP_PROP_HH,A
fin_si_bip1:
si_bdp1:	JNB	BTN_DEC_PROP,fin_si_bdp1
            	MOV	A,PROP_HL
            	ADD	A,#0A0h
            	MOV	TMP_PROP_HL,A
            	MOV	A,PROP_HH
           	ADDC	A,#0
           	MOV	TMP_PROP_HH,A
fin_si_bdp1:
		CLR	RS0
		CLR	RS1

		;================;
		;Test limites pwm;
		;================;

		;si PROP1 < AVANT1;
		MOV	R0,TMP_PROP_HL
		MOV	R1,TMP_PROP_HH
		MOV	R2,#PROP_AV_HL
		MOV	R3,#PROP_AV_HH
		LCALL	w_comp
si_prop1_inf:	JNB	F0,fin_si_prop1_inf
		MOV	TMP_PROP_HL,#PROP_AV_HL
		MOV	TMP_PROP_HH,#PROP_AV_HH
fin_si_prop1_inf:
		;si ARRIERE1 < PROP1;
		MOV	R2,#PROP_AR_HL
		MOV	R3,#PROP_AR_HH
		LCALL	w_comp
si_prop1_sup:	JB	F0,fin_si_prop1_sup
		MOV	TMP_PROP_HL,#PROP_AR_HL
		MOV	TMP_PROP_HH,#PROP_AR_HH
fin_si_prop1_sup:	
		;si DIR1 < DIR_GAUCHE;
		MOV	R0,TMP_DIR_HL
		MOV	R1,TMP_DIR_HH
		MOV	R2,#DIR_G_HL
		MOV	R3,#DIR_G_HH
		LCALL	w_comp
si_dir1_inf:	JNB	F0,fin_si_dir1_inf
		MOV	TMP_DIR_HL,#DIR_G_HL
		MOV	TMP_DIR_HH,#DIR_G_HH
fin_si_dir1_inf:				
		;si DIR_DROITE < DIR1;	
		MOV	R2,#DIR_D_HL
		MOV	R3,#DIR_D_HH
		LCALL	w_comp
si_dir1_sup:	JB	F0,fin_si_dir1_sup
		MOV	TMP_DIR_HL,#DIR_D_HL
		MOV	TMP_DIR_HH,#DIR_D_HH
fin_si_dir1_sup:		

		MOV	DIR_HL,TMP_DIR_HL
		MOV	DIR_HH,TMP_DIR_HH
		MOV	PROP_HL,TMP_PROP_HL
		MOV	PROP_HH,TMP_PROP_HH
		
		LCALL	calc_prop_l

;		MOV	R5,#20		
;attendre:	LCALL	timer_50ms					
;		DJNZ	R5,attendre

		LJMP	rpt
jsq:

fin:

;=============================================;
;	calc_prop_l: calcul prop_L en fonction de dir_H et prop_H (dir_L etant connu)
;	needs :  banque 3
;	args :	None
;	return :None
;=============================================;	
calc_prop_l:
		PUSH	ACC
		PUSH	PSW
		SETB	RS0
		SETB	RS1
		CLR	C

		;tmp1 <- 0xFFF - prop_h + 1
		MOV	A,#0FFh
		SUBB	A,PROP_HL
		MOV	R0,A
		MOV	A,#0FFh
		SUBB	A,PROP_HH
		MOV	R1,A
		MOV	A,R0
		ADD	A,#1
		MOV	R0,A
		MOV	A,R1
		ADDC	A,#0
		MOV	R1,A

		;tmp2 <- 0xFFF - dir_h + 1
		MOV	A,#0FFh
		SUBB	A,DIR_HL
		MOV	R2,A
		MOV	A,#0FFh
		SUBB	A,DIR_HH
		MOV	R3,A
		MOV	A,R2
		ADD	A,#1
		MOV	R2,A
		MOV	A,R3
		ADDC	A,#0
		MOV	R3,A

		;tmp1 <- tmp1 + tmp2
		MOV	A,R0
		ADD	A,R2
		MOV	R0,A
		MOV	A,R1
		ADDC	A,R3
		MOV	R1,A

		;prop_l <- 0xB2D4 + tmp1
		MOV	A,#T_PROP_MIN_LL
		ADD	A,R0
		MOV	PROP_LL,A
		MOV	A,#T_PROP_MIN_LH
		ADDC	A,R1
		MOV	PROP_LH,A
		
		POP 	PSW
		POP	ACC
		RET	
fin_calc_prop0:


;====================
;timer_50ms

timer_50ms:
		CLR	TF1
		CLR	TR1
					
		MOV	A,TL1	        ; Place le dépacement du timer dans l'accumulateur
		ADD	A,#T_LOAD_L	; On augmente le chargement en conséquence
		MOV	TL1,A		; Et on le sauvegarde dans le timer L
					
		MOV	A,#T_LOAD_H	; On charge la partie haute du chargement
		ADDC	A,#0		; On y ajoute l'éventuelle carry
		MOV	TH1,A		; Et on la sauvegarde dans le timer H
		MOV	A,TL1		; On recharge la partie basse du timer
		ADD	A,#13	        ; Et on y ajoute le nombre de cycles entre l'arrêt et le démarrage
		MOV	TL1,A		; Qu'on replace
		MOV	A,TH1	        ; On recharge la partie haute pour prendre en compte la carry
		ADDC	A,#0
		MOV	TH1,A

		SETB	TR1
		
boucle_timer: 	JNB 	TF1,boucle_timer
					
               	RET
fin_timer_50ms:

;=============================================;
;	w_comp : comparaison mots 16bits
;	W1 < W2 => F0	
;	args : 	W1_L (0R0) / W1_H (0R1) / W2_L (0R2) / W2_H (0R3)
;	return : F0
;=============================================;	
w_comp:    		
		PUSH	ACC
					
		CLR	C
		MOV	A,01h		;on met W1_H dans A
		SUBB	A,03h		; On soustrait les deux octets de poids fort
				
si_diff:	JNZ	fin_si_diff	; Si ils sont différents, on a le résultat
          	MOV	A,00h		; Sinon, on refait la comparaison sur le poids faible
          	SUBB	A,02h
fin_si_diff:         	
          	MOV	F0,C
          	
		POP	ACC
		RET
fin_w_comp:

;=============================================;

it_pwm:
		PUSH	ACC	                ;on sauvegarde les valeurs utilent dans la stack
		PUSH	PSW
		SETB	RS0	                ;on se place dans la banque 3 pour temporaire
		SETB	RS1
		MOV	A,NEXT_PWM_STATE	;on move next_state dans A pour les tests avec CJNE
si0:  		CJNE	A,#0,fin0		;si next_state=0
		SETB	PWM_DIR			;on change l'etat de la sortie pwm
		MOV	R0,DIR_HL	        ;on charge dans 3R0 et 3R1 les valeurs de chargement pour Timer0					
		MOV	R1,DIR_HH
		INC	NEXT_PWM_STATE		;on incremente l'etat suivant desire
		SJMP	finsi		
fin0:

sinon1:        	CJNE	A,#1,fin1               ;si next_state==1
		CLR	PWM_DIR
		MOV	R0,#DIR_INIT_LL
		MOV	R1,#DIR_INIT_LH
		INC	NEXT_PWM_STATE
		SJMP	finsi
fin1:
        
sinon2:		CJNE	A,#2,fin2	        ;si next_state==2
		SETB	PWM_PROP
		MOV	R0,PROP_HL
		MOV	R1,PROP_HH
		INC	NEXT_PWM_STATE
		SJMP	finsi
fin2:
sinon3:		CJNE	A,#3,fin3	        ;si next_state==3
		CLR	PWM_PROP
		MOV	R0,PROP_LL
		MOV	R1,PROP_LH
		MOV	NEXT_PWM_STATE,#0
fin3:
finsi:
		CLR	TR0	                ; on desactive le timer

		;<!> ATTENTION PRENDRE EN COMPTE LES CYCLES (7), TIMER ARRETE <!>;
		MOV	A,TL0	                ; Place le dépacement du timer dans l'accumulateur
		ADD	A,R0	                ; On augmente le chargement en conséquence
		MOV	TL0,A	                ; Et on le sauvegarde dans le timer L
		MOV	A,R1	                ; On charge la partie haute du chargement
		ADDC	A,TH0	                ; On y ajoute l'éventuelle carry
		MOV	TH0,A	                ; Et on la sauvegarde dans le timer H
		;<!> FIN ATTENTION <!>;

		SETB	TR0	                ; on reactive le timer
		POP	PSW
		POP	ACC
		RETI			
fin_it_pwm:
			end
