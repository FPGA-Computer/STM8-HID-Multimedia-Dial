   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.13 - 05 Feb 2019
   3                     ; Generator (Limited) V4.4.10 - 25 Sep 2019
   4                     ; Optimizer V4.4.10 - 25 Sep 2019
  20                     	bsct
  21  0000               _ReportIn:
  22  0000 01            	dc.b	1
  23  0001 00            	ds.b	1
  24  0002               _Report_State:
  25  0002 00            	dc.b	0
  26  0003               _Encoder:
  27  0003 00            	dc.b	0
  64                     ; 33 void Init_Hardware(void)
  64                     ; 34 {	
  66                     	switch	.text
  67  0000               _Init_Hardware:
  71                     ; 35 	Check_OPTION_BYTE();
  73  0000 ad39          	call	_Check_OPTION_BYTE
  75                     ; 36 	CLK->CKDIVR = 0; // HSIDIV = 0; CPUDIV = 0
  77  0002 725f50c6      	clr	20678
  78                     ; 38 	USB_disconnect();
  80  0006 cd0000        	call	_USB_disconnect
  82                     ; 39 	TIM4_Init();
  84  0009 cd00b0        	call	_TIM4_Init
  86                     ; 40 	Encoder_Init();
  88  000c cd00ec        	call	_Encoder_Init
  90                     ; 41 	USB_Init();
  92  000f cd0000        	call	_USB_Init
  94                     ; 42 	Delay(US_DELAY(90000));
  96  0012 aedd7c        	ldw	x,#56700
  97  0015 cd0262        	call	_Delay
  99                     ; 43 	enableInterrupts();
 102  0018 9a            	rim	
 104                     ; 44 	USB_connect();
 108                     ; 45 }
 111  0019 cc0000        	jp	_USB_connect
 134                     ; 49 void RESET_CHIP(void)
 134                     ; 50 {
 135                     	switch	.text
 136  001c               _RESET_CHIP:
 140                     ; 51 	IWDG->KR = IWDG_KEY_ENABLE; // Reset the CPU: Enable the watchdog and wait until it expires
 142  001c 35cc50e0      	mov	20704,#204
 143  0020               L13:
 144                     ; 52 	while(1);    // Wait until reset occurs from IWDG
 146  0020 20fe          	jra	L13
 180                     ; 55 void FLASH_Data_lock(uint8_t lock)
 180                     ; 56 {
 181                     	switch	.text
 182  0022               _FLASH_Data_lock:
 186                     ; 57 	if(lock)
 188  0022 4d            	tnz	a
 189  0023 2705          	jreq	L35
 190                     ; 58 		FLASH->IAPSR = 0;
 192  0025 725f505f      	clr	20575
 195  0029 81            	ret	
 196  002a               L35:
 197                     ; 62     FLASH->DUKR = FLASH_RASS_KEY2;
 199  002a 35ae5064      	mov	20580,#174
 200                     ; 63     FLASH->DUKR = FLASH_RASS_KEY1;		
 202  002e 35565064      	mov	20580,#86
 203                     ; 65 }
 206  0032 81            	ret	
 229                     ; 67 void FLASH_Wait(void)
 229                     ; 68 {
 230                     	switch	.text
 231  0033               _FLASH_Wait:
 235  0033               L17:
 236                     ; 69 	while(!(uint8_t)(FLASH->IAPSR & (FLASH_IAPSR_EOP | FLASH_IAPSR_WR_PG_DIS)))
 238  0033 c6505f        	ld	a,20575
 239  0036 a505          	bcp	a,#5
 240  0038 27f9          	jreq	L17
 241                     ; 71 }
 244  003a 81            	ret	
 281                     ; 73 void Check_OPTION_BYTE(void)
 281                     ; 74 {
 282                     	switch	.text
 283  003b               _Check_OPTION_BYTE:
 285  003b 89            	pushw	x
 286       00000002      OFST:	set	2
 289                     ; 77 	if ((OPT->OPT2 != (uint8_t)(~OPT->NOPT2))||((OPT->OPT2 & AFR0) == 0)) 
 291  003c c64804        	ld	a,18436
 292  003f 43            	cpl	a
 293  0040 6b01          	ld	(OFST-1,sp),a
 295  0042 c64803        	ld	a,18435
 296  0045 1101          	cp	a,(OFST-1,sp)
 297  0047 2605          	jrne	L511
 299  0049 7200480318    	btjt	18435,#0,L311
 300  004e               L511:
 301                     ; 79 		option_byte = OPT->OPT2|AFR0; 		// set AFR0 = 1 // PORT C[7..5] Alternate Function
 303  004e c64803        	ld	a,18435
 304  0051 aa01          	or	a,#1
 305  0053 6b02          	ld	(OFST+0,sp),a
 307                     ; 81 		FLASH_Data_lock(0);
 309  0055 ad4c          	call	LC002
 310                     ; 85 		OPT->OPT2 = option_byte;
 312  0057 7b02          	ld	a,(OFST+0,sp)
 313  0059 c74803        	ld	18435,a
 314                     ; 86 		FLASH_Wait();
 316  005c add5          	call	_FLASH_Wait
 318                     ; 88 		OPT->NOPT2 = (uint8_t)(~option_byte);
 320  005e 7b02          	ld	a,(OFST+0,sp)
 321  0060 43            	cpl	a
 322  0061 c74804        	ld	18436,a
 323                     ; 89 		FLASH_Wait();
 325  0064 ad2c          	call	LC001
 327  0066               L311:
 328                     ; 99 	if ((OPT->OPT3 != (uint8_t)(~OPT->NOPT3))||((OPT->OPT3 & HSITRIM) == 0)) 
 330  0066 c64806        	ld	a,18438
 331  0069 43            	cpl	a
 332  006a 6b01          	ld	(OFST-1,sp),a
 334  006c c64805        	ld	a,18437
 335  006f 1101          	cp	a,(OFST-1,sp)
 336  0071 2605          	jrne	L121
 338  0073 7208480518    	btjt	18437,#4,L711
 339  0078               L121:
 340                     ; 101 		option_byte = OPT->OPT3|HSITRIM;			// 4 bit on-the-fly trimming
 342  0078 c64805        	ld	a,18437
 343  007b aa10          	or	a,#16
 344  007d 6b02          	ld	(OFST+0,sp),a
 346                     ; 103 		FLASH_Data_lock(0);
 348  007f ad22          	call	LC002
 349                     ; 107 		OPT->OPT3 = option_byte;
 351  0081 7b02          	ld	a,(OFST+0,sp)
 352  0083 c74805        	ld	18437,a
 353                     ; 108 		FLASH_Wait();
 355  0086 adab          	call	_FLASH_Wait
 357                     ; 110 		OPT->NOPT3 = (uint8_t)(~option_byte);
 359  0088 7b02          	ld	a,(OFST+0,sp)
 360  008a 43            	cpl	a
 361  008b c74806        	ld	18438,a
 362                     ; 111 		FLASH_Wait();
 364  008e ad02          	call	LC001
 366  0090               L711:
 367                     ; 119 }
 370  0090 85            	popw	x
 371  0091 81            	ret	
 372  0092               LC001:
 373  0092 ad9f          	call	_FLASH_Wait
 375                     ; 92 		FLASH->CR2 &= (uint8_t)(~FLASH_CR2_OPT);
 377  0094 721f505b      	bres	20571,#7
 378                     ; 93 		FLASH->NCR2 |= FLASH_NCR2_NOPT;
 380  0098 721e505c      	bset	20572,#7
 381                     ; 95 		FLASH_Data_lock(1);
 383  009c a601          	ld	a,#1
 384  009e ad82          	call	_FLASH_Data_lock
 386                     ; 96     RESET_CHIP();
 388  00a0 cc001c        	jp	_RESET_CHIP
 389  00a3               LC002:
 390  00a3 4f            	clr	a
 391  00a4 cd0022        	call	_FLASH_Data_lock
 393                     ; 82 		FLASH->CR2 |= FLASH_CR2_OPT;
 395  00a7 721e505b      	bset	20571,#7
 396                     ; 83 		FLASH->NCR2 &= (uint8_t)(~FLASH_NCR2_NOPT);
 398  00ab 721f505c      	bres	20572,#7
 399  00af 81            	ret	
 422                     ; 121 void TIM4_Init(void)
 422                     ; 122 {
 423                     	switch	.text
 424  00b0               _TIM4_Init:
 428                     ; 123 	TIM4->ARR = TIM4_RELOAD;
 430  00b0 35fa5348      	mov	21320,#250
 431                     ; 124 	TIM4->PSCR = TIM4_PRSC;
 433  00b4 35075347      	mov	21319,#7
 434                     ; 126 	TIM4->CR1 = TIM4_CR1_CEN;
 436  00b8 35015340      	mov	21312,#1
 437                     ; 127 }
 440  00bc 81            	ret	
 474                     ; 129 void LED(uint8_t Colour)
 474                     ; 130 {	
 475                     	switch	.text
 476  00bd               _LED:
 478  00bd 88            	push	a
 479       00000000      OFST:	set	0
 482                     ; 131 	if(Colour & LED_RED)
 484  00be a501          	bcp	a,#1
 485  00c0 2706          	jreq	L151
 486                     ; 132 		LED_R_PORT->ODR &= (uint8_t)~LED_R;
 488  00c2 7213500f      	bres	20495,#1
 490  00c6 2004          	jra	L351
 491  00c8               L151:
 492                     ; 134 		LED_R_PORT->ODR |= LED_R;
 494  00c8 7212500f      	bset	20495,#1
 495  00cc               L351:
 496                     ; 136 	if(Colour & LED_GREEN)
 498  00cc 7b01          	ld	a,(OFST+1,sp)
 499  00ce a502          	bcp	a,#2
 500  00d0 2706          	jreq	L551
 501                     ; 137 		LED_G_PORT->ODR &= (uint8_t)~LED_G;
 503  00d2 721b5005      	bres	20485,#5
 505  00d6 2004          	jra	L751
 506  00d8               L551:
 507                     ; 139 		LED_G_PORT->ODR |= LED_G;
 509  00d8 721a5005      	bset	20485,#5
 510  00dc               L751:
 511                     ; 141 	if(Colour & LED_BLUE)
 513  00dc a504          	bcp	a,#4
 514  00de 2706          	jreq	L161
 515                     ; 142 		LED_B_PORT->ODR &= (uint8_t)~LED_B;
 517  00e0 72195005      	bres	20485,#4
 519  00e4 2004          	jra	L361
 520  00e6               L161:
 521                     ; 144 		LED_B_PORT->ODR |= LED_B;
 523  00e6 72185005      	bset	20485,#4
 524  00ea               L361:
 525                     ; 145 }
 528  00ea 84            	pop	a
 529  00eb 81            	ret	
 553                     ; 147 void Encoder_Init(void)
 553                     ; 148 {
 554                     	switch	.text
 555  00ec               _Encoder_Init:
 559                     ; 149 	EXTI->CR1 = EXTI_CR1;			// Rising and falling edges
 561  00ec 353050a0      	mov	20640,#48
 562                     ; 151 	ENC_PORT->CR2 |=  ENC_CLK;
 564  00f0 721a500e      	bset	20494,#5
 565                     ; 153 	ENC_SW_PORT->CR1 |= ENC_SW;
 567  00f4 7216500d      	bset	20493,#3
 568                     ; 155 	LED(LED_OFF);
 570  00f8 4f            	clr	a
 571  00f9 adc2          	call	_LED
 573                     ; 157 	if(!(RST->SR & RST_SR_SWIMF))
 575  00fb 720650b304    	btjt	20659,#3,L571
 576                     ; 158 		LED_R_PORT->DDR |= LED_R;
 578  0100 72125011      	bset	20497,#1
 579  0104               L571:
 580                     ; 160 	LED_G_PORT->DDR |= LED_G;
 582  0104 721a5007      	bset	20487,#5
 583                     ; 161 	LED_B_PORT->DDR |= LED_B;
 585  0108 72185007      	bset	20487,#4
 586                     ; 162 }
 589  010c 81            	ret	
 592                     	switch	.ubsct
 593  0000               L771_Enc_Status:
 594  0000 00            	ds.b	1
 627                     ; 182 @far @interrupt void Encoder_IRQ(void)
 627                     ; 183 {
 629                     	switch	.text
 630  010d               f_Encoder_IRQ:
 632       00000001      OFST:	set	1
 633  010d 88            	push	a
 636                     ; 186 	Enc_Status = (Enc_Status<<2)|(ENC_PORT->IDR&(ENC_CLK|ENC_DIR));	
 638  010e c6500b        	ld	a,20491
 639  0111 a430          	and	a,#48
 640  0113 6b01          	ld	(OFST+0,sp),a
 642  0115 b600          	ld	a,L771_Enc_Status
 643  0117 48            	sll	a
 644  0118 48            	sll	a
 645  0119 1a01          	or	a,(OFST+0,sp)
 646  011b b700          	ld	L771_Enc_Status,a
 647                     ; 188 	if(Enc_Status == ((ENC_DIR<<2)|ENC_CLK))
 649  011d a160          	cp	a,#96
 650  011f 2604          	jrne	L712
 651                     ; 189     Encoder_--;
 653  0121 3a02          	dec	_Encoder_
 655  0123 2006          	jra	L122
 656  0125               L712:
 657                     ; 190 	else if(Enc_Status == (ENC_CLK|ENC_DIR))
 659  0125 a130          	cp	a,#48
 660  0127 2602          	jrne	L122
 661                     ; 191     Encoder_++;
 663  0129 3c02          	inc	_Encoder_
 664  012b               L122:
 665                     ; 192 }
 668  012b 84            	pop	a
 669  012c 80            	iret	
 671                     	bsct
 672  0004               L522_Switch_Status:
 673  0004 0f            	dc.b	15
 674  0005               L132_Sw_State:
 675  0005 00            	dc.b	0
 676  0006               L332_Enc_State:
 677  0006 00            	dc.b	0
 706                     ; 196 void Encoder_Switch_Task(void)
 706                     ; 197 {
 708                     	switch	.text
 709  012d               _Encoder_Switch_Task:
 713                     ; 198 	if(Sw_Timer)
 715  012d b601          	ld	a,L722_Sw_Timer
 716  012f 2702          	jreq	L162
 717                     ; 199 		Sw_Timer--;
 719  0131 3a01          	dec	L722_Sw_Timer
 720  0133               L162:
 721                     ; 202 	Switch_Status <<= 1;
 723  0133 3804          	sll	L522_Switch_Status
 724                     ; 204 	if(ENC_SW_PORT->IDR & ENC_SW)
 726  0135 7207500b04    	btjf	20491,#3,L362
 727                     ; 205 		Switch_Status |= 1;
 729  013a 72100004      	bset	L522_Switch_Status,#0
 730  013e               L362:
 731                     ; 208 	switch(Sw_State)
 733  013e b605          	ld	a,L132_Sw_State
 735                     ; 271 		break;                
 736  0140 2713          	jreq	L532
 737  0142 4a            	dec	a
 738  0143 2724          	jreq	L732
 739  0145 4a            	dec	a
 740  0146 2750          	jreq	L142
 741  0148 4a            	dec	a
 742  0149 2761          	jreq	L342
 743  014b 4a            	dec	a
 744  014c 2778          	jreq	L542
 745  014e 4a            	dec	a
 746  014f 2603cc01e3    	jreq	L113
 748  0154 81            	ret	
 749  0155               L532:
 750                     ; 210 		case SW_NONE:
 750                     ; 211 			if(SW_AT_MAKE)
 752  0155 b604          	ld	a,L522_Switch_Status
 753  0157 a40f          	and	a,#15
 754  0159 a108          	cp	a,#8
 755  015b 2703cc01ed    	jrne	L762
 756                     ; 213 				Sw_State = SW_PRESS;
 758  0160 35010005      	mov	L132_Sw_State,#1
 759                     ; 214 				Sw_Timer = TIMER_CLICK_MAKE;
 761  0164 350f0001      	mov	L722_Sw_Timer,#15
 763  0168 81            	ret	
 764  0169               L732:
 765                     ; 218 		case SW_PRESS:
 765                     ; 219 			if(!Sw_Timer)                                 // Double click times out -> Pressed
 767  0169 b601          	ld	a,L722_Sw_Timer
 768  016b 261a          	jrne	L372
 769                     ; 221 				if(Report_State == REPORT_RDY)              // cheat: wait for HID to be ready
 771  016d b602          	ld	a,_Report_State
 772  016f 267c          	jrne	L762
 773                     ; 223 					Sw_State = SW_HOLD;
 775  0171 35040005      	mov	L132_Sw_State,#4
 776                     ; 224 					Sw_Timer = TIMER_LONG;
 778  0175 35280001      	mov	L722_Sw_Timer,#40
 779                     ; 227 					ReportIn[1] = (Enc_State == ENC_VOLUME)?Cmd_Mute:Cmd_Play_Pause;
 781  0179 b606          	ld	a,L332_Enc_State
 782  017b 2604          	jrne	L47
 783  017d a610          	ld	a,#16
 784  017f 2002          	jra	L67
 785  0181               L47:
 786  0181 a608          	ld	a,#8
 787  0183               L67:
 788  0183 b701          	ld	_ReportIn+1,a
 789                     ; 228 					Report_State = REPORT_CMD;
 790  0185 2057          	jp	LC004
 791  0187               L372:
 792                     ; 231 			else if (SW_BREAK)
 794  0187 b604          	ld	a,L522_Switch_Status
 795  0189 a403          	and	a,#3
 796  018b a103          	cp	a,#3
 797  018d 265e          	jrne	L762
 798                     ; 233 				Sw_State = SW_DBL_BREAK;
 800  018f 35020005      	mov	L132_Sw_State,#2
 801                     ; 234 				Sw_Timer = TIMER_DBL_BREAK;
 803  0193 35190001      	mov	L722_Sw_Timer,#25
 805  0197 81            	ret	
 806  0198               L142:
 807                     ; 238 		case SW_DBL_BREAK:
 807                     ; 239 			if(!Sw_Timer)                                 // break is too long, treat it as no pressed
 809  0198 3d01          	tnz	L722_Sw_Timer
 810  019a 2603          	jrne	L303
 811                     ; 240 				Sw_State = SW_NONE;
 813  019c b705          	ld	L132_Sw_State,a
 816  019e 81            	ret	
 817  019f               L303:
 818                     ; 241 			else if(SW_AT_MAKE)
 820  019f b604          	ld	a,L522_Switch_Status
 821  01a1 a40f          	and	a,#15
 822  01a3 a108          	cp	a,#8
 823  01a5 2646          	jrne	L762
 824                     ; 242 				Sw_State = SW_DBL_CLICK; 
 826  01a7 35030005      	mov	L132_Sw_State,#3
 828  01ab 81            	ret	
 829  01ac               L342:
 830                     ; 245 		case SW_DBL_CLICK:
 830                     ; 246 			// double click switches operating mode
 830                     ; 247 			Enc_State = !Enc_State;
 832  01ac 3d06          	tnz	L332_Enc_State
 833  01ae 2603          	jrne	L001
 834  01b0 4c            	inc	a
 835  01b1 2001          	jra	L201
 836  01b3               L001:
 837  01b3 4f            	clr	a
 838  01b4               L201:
 839  01b4 b706          	ld	L332_Enc_State,a
 840                     ; 248 			LED(Enc_State==ENC_VOLUME?LED_OFF:LED_GREEN);
 842  01b6 2702          	jreq	L011
 843  01b8 a602          	ld	a,#2
 844  01ba               L011:
 845  01ba cd00bd        	call	_LED
 847                     ; 250 			Sw_Timer = TIMER_LONG;
 849  01bd 35280001      	mov	L722_Sw_Timer,#40
 850                     ; 251 			Sw_State = SW_BREAK_WAIT;        
 852  01c1 35050005      	mov	L132_Sw_State,#5
 853                     ; 252 			break;
 856  01c5 81            	ret	
 857  01c6               L542:
 858                     ; 254 		case SW_HOLD:
 858                     ; 255 			if(!Sw_Timer)                                 // Long press
 860  01c6 b601          	ld	a,L722_Sw_Timer
 861  01c8 2619          	jrne	L113
 862                     ; 257 				if(Report_State == REPORT_RDY)              // cheat: wait to HID to be ready
 864  01ca b602          	ld	a,_Report_State
 865  01cc 261f          	jrne	L762
 866                     ; 259 					ReportIn[1] = (Enc_State == ENC_VOLUME)?Cmd_Play_Pause:Cmd_Stop;
 868  01ce b606          	ld	a,L332_Enc_State
 869  01d0 2604          	jrne	L211
 870  01d2 a608          	ld	a,#8
 871  01d4 2002          	jra	L411
 872  01d6               L211:
 873  01d6 a604          	ld	a,#4
 874  01d8               L411:
 875  01d8 b701          	ld	_ReportIn+1,a
 876                     ; 260 					Sw_State = SW_BREAK_WAIT;          
 878  01da 35050005      	mov	L132_Sw_State,#5
 879                     ; 261 					Report_State = REPORT_CMD;
 881  01de               LC004:
 883  01de 35020002      	mov	_Report_State,#2
 885  01e2 81            	ret	
 886  01e3               L113:
 887                     ; 264 			else if (SW_BREAK)
 888                     ; 265 				Sw_State = SW_NONE;
 889                     ; 268 		case SW_BREAK_WAIT:
 889                     ; 269 			if (SW_BREAK)
 891                     ; 270 				Sw_State = SW_NONE;
 894  01e3 b604          	ld	a,L522_Switch_Status
 895  01e5 a403          	and	a,#3
 896  01e7 a103          	cp	a,#3
 897  01e9 2602          	jrne	L762
 899  01eb 3f05          	clr	L132_Sw_State
 900  01ed               L762:
 901                     ; 273 }
 904  01ed 81            	ret	
 945                     ; 275 void Encoder_Task(void)
 945                     ; 276 {
 946                     	switch	.text
 947  01ee               _Encoder_Task:
 949  01ee 88            	push	a
 950       00000001      OFST:	set	1
 953                     ; 277   if(Report_State == REPORT_RDY)
 955  01ef b602          	ld	a,_Report_State
 956  01f1 263b          	jrne	L143
 957                     ; 279     if(Encoder_)              // Update Encoder from IRQ value
 959  01f3 3d02          	tnz	_Encoder_
 960  01f5 270e          	jreq	L343
 961                     ; 283       sim();                  // disable interrupt and gain access to Encoder_Count
 964  01f7 9b            	sim	
 966                     ; 284       Encoder_IRQ = Encoder_; // Keep it very short
 969  01f8 b602          	ld	a,_Encoder_
 970  01fa 6b01          	ld	(OFST+0,sp),a
 972                     ; 285       Encoder_ = 0;
 974  01fc 3f02          	clr	_Encoder_
 975                     ; 286 			rim();
 978  01fe 9a            	rim	
 980                     ; 288       Encoder += Encoder_IRQ;
 983  01ff b603          	ld	a,_Encoder
 984  0201 1b01          	add	a,(OFST+0,sp)
 985  0203 b703          	ld	_Encoder,a
 986  0205               L343:
 987                     ; 292     if(Encoder >0)
 989  0205 b603          	ld	a,_Encoder
 990  0207 9c            	rvf	
 991  0208 2d0e          	jrsle	L543
 992                     ; 294       Encoder--;
 994  020a 3a03          	dec	_Encoder
 995                     ; 295       ReportIn[EP1]|= (Enc_State == ENC_VOLUME)?Cmd_Volume_Up:Cmd_Next_Track;
 997  020c b606          	ld	a,L332_Enc_State
 998  020e 2604          	jrne	L021
 999  0210 a620          	ld	a,#32
1000  0212 2012          	jra	L621
1001  0214               L021:
1002  0214 a601          	ld	a,#1
1003                     ; 296       Report_State = REPORT_CMD;
1005  0216 200e          	jp	L621
1006  0218               L543:
1007                     ; 298     else if (Encoder <0)
1009  0218 2a14          	jrpl	L143
1010                     ; 300       Encoder++;
1012  021a 3c03          	inc	_Encoder
1013                     ; 301       ReportIn[EP1]|= (Enc_State == ENC_VOLUME)?Cmd_Volume_Down:Cmd_Prev_Track;
1015  021c b606          	ld	a,L332_Enc_State
1016  021e 2604          	jrne	L421
1017  0220 a640          	ld	a,#64
1018  0222 2002          	jra	L621
1019  0224               L421:
1020  0224 a602          	ld	a,#2
1021  0226               L621:
1022                     ; 302       Report_State = REPORT_CMD;
1024  0226 ba01          	or	a,_ReportIn+1
1025  0228 b701          	ld	_ReportIn+1,a
1027  022a 35020002      	mov	_Report_State,#2
1028  022e               L143:
1029                     ; 305 }    
1032  022e 84            	pop	a
1033  022f 81            	ret	
1060                     ; 307 void HID_Task(void)
1060                     ; 308 {
1061                     	switch	.text
1062  0230               _HID_Task:
1066                     ; 309   if ((Report_State != REPORT_RDY) && USB_Tx_Ready(EP1))
1068  0230 b602          	ld	a,_Report_State
1069  0232 2717          	jreq	L763
1071  0234 3d40          	tnz	_usb+64
1072  0236 2613          	jrne	L763
1073                     ; 311     switch(Report_State)
1076                     ; 323         break;
1077  0238 4a            	dec	a
1078  0239 270a          	jreq	L553
1079  023b 4a            	dec	a
1080  023c 260d          	jrne	L763
1081                     ; 313       case REPORT_CMD:
1081                     ; 314 				USB_Send_Data(ReportIn,REPORT_SIZE,EP1);
1083  023e ad0c          	call	LC006
1084                     ; 315         Report_State = REPORT_CMD_RELEASE;
1086  0240 35010002      	mov	_Report_State,#1
1087                     ; 316         break;
1090  0244 81            	ret	
1091  0245               L553:
1092                     ; 318       case REPORT_CMD_RELEASE:
1092                     ; 319         // clear all bits in report
1092                     ; 320         ReportIn[EP1] = 0;
1094  0245 b701          	ld	_ReportIn+1,a
1095                     ; 321 				USB_Send_Data(ReportIn,REPORT_SIZE,EP1);
1097  0247 ad03          	call	LC006
1098                     ; 322         Report_State = REPORT_RDY;
1100  0249 3f02          	clr	_Report_State
1101                     ; 323         break;
1103  024b               L763:
1104                     ; 326 }
1107  024b 81            	ret	
1108  024c               LC006:
1109  024c 4b01          	push	#1
1110  024e ae0002        	ldw	x,#2
1111  0251 89            	pushw	x
1112  0252 ae0000        	ldw	x,#_ReportIn
1113  0255 cd0000        	call	_USB_Send_Data
1115  0258 5b03          	addw	sp,#3
1116  025a 81            	ret	
1140                     ; 328 void Short_Delay(void)
1140                     ; 329 {
1141                     	switch	.text
1142  025b               _Short_Delay:
1146                     ; 330 		_asm("nop");
1149  025b 9d            	nop	
1151                     ; 331 		_asm("nop");
1154  025c 9d            	nop	
1156                     ; 332 		_asm("nop");
1159  025d 9d            	nop	
1161                     ; 333 		_asm("nop");
1164  025e 9d            	nop	
1166                     ; 334 		_asm("nop");	
1169  025f 9d            	nop	
1171                     ; 335 		_asm("nop");		
1174  0260 9d            	nop	
1176                     ; 336 }
1179  0261 81            	ret	
1214                     ; 339 void Delay(uint16_t t)
1214                     ; 340 {
1215                     	switch	.text
1216  0262               _Delay:
1218  0262 89            	pushw	x
1219       00000000      OFST:	set	0
1222  0263 2007          	jra	L724
1223  0265               L324:
1224                     ; 342 		Short_Delay();
1226  0265 adf4          	call	_Short_Delay
1228                     ; 341 	for(;t;t--)
1230  0267 1e01          	ldw	x,(OFST+1,sp)
1231  0269 5a            	decw	x
1232  026a 1f01          	ldw	(OFST+1,sp),x
1233  026c               L724:
1236  026c 1e01          	ldw	x,(OFST+1,sp)
1237  026e 26f5          	jrne	L324
1238                     ; 343 }
1241  0270 85            	popw	x
1242  0271 81            	ret	
1330                     	xdef	_Short_Delay
1331                     	switch	.ubsct
1332  0001               L722_Sw_Timer:
1333  0001 00            	ds.b	1
1334                     	xdef	f_Encoder_IRQ
1335                     	xdef	_Encoder
1336  0002               _Encoder_:
1337  0002 00            	ds.b	1
1338                     	xdef	_Encoder_
1339                     	xdef	_Report_State
1340                     	xdef	_ReportIn
1341                     	xref.b	_usb
1342                     	xref	_USB_Send_Data
1343                     	xref	_USB_disconnect
1344                     	xref	_USB_connect
1345                     	xref	_USB_Init
1346                     	xdef	_FLASH_Wait
1347                     	xdef	_FLASH_Data_lock
1348                     	xdef	_HID_Task
1349                     	xdef	_Encoder_Task
1350                     	xdef	_Encoder_Switch_Task
1351                     	xdef	_Encoder_Init
1352                     	xdef	_LED
1353                     	xdef	_Delay
1354                     	xdef	_TIM4_Init
1355                     	xdef	_Check_OPTION_BYTE
1356                     	xdef	_RESET_CHIP
1357                     	xdef	_Init_Hardware
1377                     	end
