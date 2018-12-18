;declaration
RGS				bit	P0.5
RW				bit	P0.6
E				bit	P0.7
LED				bit	P1.0
Laser				bit	P1.2
Sirene			        bit	P1.3
DATABUS			        equ 	P2
BUSY_FLAG		        bit	P2.7
CNT				equ	R7
; R6 => utilisé comme registre tampon
MARCHE_ARRET	bit	20h

RECU			data	7Fh				
NB_TOUR			data	7Eh
DDRAM_NB_TOUR	        equ	8Bh	
NB_TIR_DROITE	        data	7Dh
DDRAM_DROITE	        equ	11000101b	
NB_TIR_CENTRE	        data	7Ch
DDRAM_CENTRE	        equ	11001001b	
NB_TIR_GAUCHE	        data	7Bh
DDRAM_GAUCHE	        equ	11001101b	

MAGIC_INIT		equ	00110000b
CFG_5x8			equ	00111000b
CFG_CURSOR		equ	00001100b
CFG_OFF			equ	00001000b
CFG_CLEAR		equ	00000001b
CFG_MODESET		equ	00000110b

;valeurs utiles pour le LCD
debut_ligne		equ	11000000b
saut_de_ligne	        equ	10000000b 


;vtable
                        org	0000h
                        SJMP	debut
                        org	0023h			      ;adresse de l'interruption série		
                        LJMP	interrupt		      ;interrupt i.e. RI=1 flag de réception
                        org	0030h

;Définition des chaines de caractère à envoyer
ligne_H:		DB	'  Tour(s): 0/3  ',0
ligne_L:		DB	'   D=0 C=0 G=0  ',0
			
;main
debut:			MOV	SP,#2Fh
			LCALL	init
rpt: 			SJMP	rpt		
fin:		

;==============================================================================================================

init:
				CLR		LASER				;on coupe le laser au démarrage
				CLR		SIRENE				;on coupe la sirène au démarrage
				CLR		MARCHE_ARRET		        ;On met le marche arrêt à 0
				SETB		LED				;On éteint la LED
				MOV		RECU,#00h			;init de la donnee recu
				MOV		NB_TOUR,#30h			;init du nombre de tours à 0 (ascii)
				MOV		NB_TIR_DROITE,#30h		;init du nombre de tir à droite à 0 (ascii)
				MOV		NB_TIR_CENTRE,#30h		;init du nombre de tir à centre à 0 (ascii)
				MOV		NB_TIR_GAUCHE,#30h		;init du nombre de tir à gauche à 0 (ascii)
				MOV		PCON,#0
				
				MOV		SCON,#01010000b			;On initialise la liaison série, asynchrone 1200Bd sans parité 
				MOV		IE,#10010000b			;validation de l'interruption sur la série
				MOV		PCON,#0h						
				
				MOV		TMOD,#00100001b
				MOV		TH1,#0E6h
				MOV		TL1,#0E6h
				
				;Affichage du message de départ sur l'écran LCD
				LCALL		LCD_INIT
				
				;ligne haute
				MOV		DATABUS,#saut_de_ligne
				LCALL		LCD_Code
				MOV		DPTR,#ligne_H
				LCALL		LCD_MSG	
				;ligne basse
				MOV		DATABUS,#debut_ligne
				LCALL		LCD_Code
				MOV		DPTR,#ligne_L
				LCALL		LCD_MSG
				
				SETB		TR1
			
				RET
				
;==============================================================================================================

;interrupt i.e. RI=1 flag de reception
interrupt:
						PUSH		Acc
						JNB		RI,fsi_recu	  ;gestion de la deuxième interruption déclenchée par l'envoie de données à la carte maitre sur la liaison série
						CLR		RI						
  						MOV		A,SBUF  
si_parite:  		                        JB		P,fsi_parite	   ;test du bit de parité	
						CLR		ACC.7		   ;clear du bit de poids fort = bit de parité
						CJNE		A,RECU,si_recu	   ;On traite la valeur reçue si elle est différente de la précédente reçue
						SJMP		fsi_recu;	   ;On saute la mise à jour si la valeur n'a pas été déjà reçue	
si_recu:				
si_egal_0:			                CJNE 		A,#'0',si_egal_4
						LCALL		cas_0
fsi_egal_0:			                LJMP		fcase

si_egal_4:		                    	CJNE 		A,#'4',si_egal_D
						LCALL		cas_4
fsi_egal_4:	                    		LJMP		fcase

si_egal_D:	                    		CJNE 		A,#'D',si_egal_C
						LCALL		cas_D	
fsi_egal_D:	                  		LJMP		fcase

si_egal_C:		                  	CJNE 		A,#'C',si_egal_G
						LCALL		cas_C
fsi_egal_C:	                		LJMP		fcase

si_egal_G:		                  	CJNE 		A,#'G',fcase
						LCALL		cas_G
fsi_egal_G:		
fcase:	               	 
						MOV		RECU,A			
fsi_recu:
fsi_parite:
						POP		Acc
						RETI				

;==============================================================================================================

;Le caractère envoyé est contenu dans l'accumulateur lors de l'appel à cette fonction
cas_0:
si_MA_0:	          		JB	        MARCHE_ARRET,sinon_MA_0
					MOV		R6,NB_TOUR
					CJNE		R6,#'3',si_tour_diff_3			 
					SJMP 		fsi_tour_diff_3				
si_tour_diff_3:
					;envoyer "G" a la carte maitre
				        MOV		SBUF,#'G'	   		;On charge la donnée dans le serial buffer
tq_send_G:	                        JNB		TI,tq_send_G			;On attend la fin de l'envoie du message
					CLR		TI
					CLR		LED				;test start led
					SETB 		MARCHE_ARRET	
fsi_tour_diff_3:					
finsi_MA_0:
					LJMP 		fsn_MA_0
sinon_MA_0:		
					;envoyer "S" à la carte maitre
					MOV		SBUF,#'S'	   		;On charge la donnée dans le serial buffer
tq_send_S:	                	JNB		TI,tq_send_S			;On attend la fin de l'envoie du message
					CLR		TI
					CLR		MARCHE_ARRET
					MOV		A,#0h				;permet de recevoir un deuxième zéro après la tempo de 2s puisque MOV RECU,A ensuite
					INC		NB_TOUR
					MOV		DATABUS,#DDRAM_NB_TOUR
					LCALL		LCD_Code
					MOV		DATABUS,NB_TOUR
					LCALL		LCD_DATA	
					MOV		R6,#100
att_depart:		                LCALL		timer_50ms
					DJNZ		R6,att_depart
fsn_MA_0:
					RET
					
;==============================================================================================================

cas_4:	
					MOV		R6,RECU
si_old_0:		                CJNE		R6,#'0',fsi_old_0 
					SETB		LED				;test stop led
					SETB		LASER        
					SETB		SIRENE
fsi_old_0:
					RET
					
;==============================================================================================================

cas_D:
					INC 		NB_TIR_DROITE
					MOV		DATABUS,#DDRAM_DROITE
					LCALL		LCD_Code
					MOV		DATABUS,NB_TIR_DROITE
					LCALL		LCD_DATA	
					RET
					
;==============================================================================================================

cas_C:
					INC 		NB_TIR_CENTRE
					MOV		DATABUS,#DDRAM_CENTRE
					LCALL		LCD_Code
					MOV		DATABUS,NB_TIR_CENTRE
					LCALL		LCD_DATA	
					RET
					
;==============================================================================================================

cas_G:
					INC 		NB_TIR_GAUCHE
					MOV		DATABUS,#DDRAM_GAUCHE
					LCALL		LCD_Code
					MOV		DATABUS,NB_TIR_GAUCHE
					LCALL		LCD_DATA	
					CLR		LASER
					CLR		SIRENE
					RET
									
;==============================================================================================================

LCD_MSG:
            	                        PUSH	ACC
            	                        MOV 	CNT,#0
tq_string:    	                        MOV   A,CNT
			   	        MOVC	A,@A+DPTR
 			   	        JZ		tq_string_fin
					MOV	DATABUS,A
					LCALL	LCD_DATA
					INC 	CNT
					SJMP 	tq_string
tq_string_fin:            	
            	POP	ACC
LCD_MSG_fin:   RET


;==============================================================================================================

LCD_BF:
					MOV	DATABUS,#0FFh			;P2 en lecture
					SETB	RW
					CLR	RGS
					
tq_busy:			        CLR	E			        ;tq busy_flag==1, on attend
					SETB	E
					JB      BUSY_FLAG,tq_busy	
tq_busy_fin:					
					CLR	E	
LCD_BF_fin:		                RET											

;==============================================================================================================
					
;Envoi le contenu de databus à l'ecran LCD en tant qu'ordre
LCD_CODE:
					CLR	RGS
					CLR	RW
					SETB	E
					CLR	E
					LCALL	LCD_BF
LCD_CODE_fin:	RET

;==============================================================================================================	

;Envoi le contenu de databus à l'ecran LCD en tant que donnée
LCD_DATA:
					SETB	RGS
					CLR	RW
					SETB	E
					CLR	E
					LCALL	LCD_BF
LCD_DATA_fin:	                        RET

;==============================================================================================================

LCD_INIT:
                                        CLR	RGS
                                        CLR	RW
                                        MOV	R6,#3
rpt3x:
					LCALL	timer_50ms
					MOV	DATABUS,#MAGIC_INIT
					SETB	E
					CLR	E
					DJNZ	R6,rpt3x
rpt3x_fin:		
					LCALL	timer_50ms																												
					MOV	DATABUS,#CFG_5x8
					LCALL	LCD_CODE
					MOV	DATABUS,#CFG_OFF
					LCALL	LCD_CODE
					MOV	DATABUS,#CFG_CLEAR
					LCALL	LCD_CODE
					MOV	DATABUS,#CFG_MODESET
					LCALL	LCD_CODE
					MOV	DATABUS,#CFG_CURSOR
					LCALL	LCD_CODE               
LCD_INIT_fin:	RET	

;==============================================================================================================

timer_50ms:
  					MOV	TL0,#0B0h				; Et on le sauvegarde dans le timer L
					MOV	TH0,#3Ch				; On charge la partie haute du chargement
					SETB	TR0
boucle_timer: 	JNB 	TF0,boucle_timer
					CLR	TF0
					CLR	TR0
fin_timer_50ms:
					RET


					end	
