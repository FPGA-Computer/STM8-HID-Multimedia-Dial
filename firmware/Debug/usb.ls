   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.13 - 05 Feb 2019
   3                     ; Generator (Limited) V4.4.10 - 25 Sep 2019
   4                     ; Optimizer V4.4.10 - 25 Sep 2019
  20                     	bsct
  21  0000               _p_HSI_TRIM_VAL:
  22  0000 4000          	dc.w	16384
  23  0002               _p_HSI_TRIMING_DONE:
  24  0002 4001          	dc.w	16385
  55                     ; 18 void USB_Reset(void)
  55                     ; 19 {
  57                     	switch	.text
  58  0000               _USB_Reset:
  62                     ; 20 	if (usb.dev_state == USB_STATE_CONFIGURED) 
  64  0000 b618          	ld	a,_usb+4
  65  0002 a103          	cp	a,#3
  66  0004 2603          	jrne	L12
  67                     ; 21 		USB_Class_DeInit_callback();
  69  0006 cd0000        	call	_USB_Class_DeInit_callback
  71  0009               L12:
  72                     ; 23 	usb.device_address = 0;
  74  0009 3f15          	clr	_usb+1
  75                     ; 24 	usb.setup_address  = 0;
  77  000b 3f16          	clr	_usb+2
  78                     ; 25 	usb.dev_state = USB_STATE_DEFAULT;
  80  000d 35010018      	mov	_usb+4,#1
  81                     ; 26 	usb.stage = USB_STAGE_NONE;
  83  0011 3f14          	clr	_usb
  84                     ; 27 	usb.dev_config = 0;
  86  0013 3f19          	clr	_usb+5
  87                     ; 28 	usb.active_EP_num = 0;
  89  0015 3f17          	clr	_usb+3
  90                     ; 29 	usb.reset_counter = 0;
  92  0017 5f            	clrw	x
  93  0018 bf55          	ldw	_usb+65,x
  94                     ; 30 	usb.EP[0].tx_length = 0;
  96  001a 3f35          	clr	_usb+33
  97                     ; 31 	usb.EP[0].rx_length = 0;
  99  001c 3f27          	clr	_usb+19
 100                     ; 32 	usb.EP[0].rx_state = USB_EP_NO_DATA;
 102  001e 3f28          	clr	_usb+20
 103                     ; 33 	usb.EP[0].tx_state = USB_EP_NO_DATA;
 105  0020 3f37          	clr	_usb+35
 106                     ; 34 	usb.EP[1].tx_length = 0;
 108  0022 3f52          	clr	_usb+62
 109                     ; 35 	usb.EP[1].rx_length = 0;
 111  0024 3f44          	clr	_usb+48
 112                     ; 36 	usb.EP[1].rx_state = USB_EP_NO_DATA;
 114  0026 3f45          	clr	_usb+49
 115                     ; 37 	usb.EP[1].tx_state = USB_EP_NO_DATA;
 117  0028 3f54          	clr	_usb+64
 118                     ; 38 }
 121  002a 81            	ret	
 148                     ; 40 void USB_Init(void)
 148                     ; 41 {
 149                     	switch	.text
 150  002b               _USB_Init:
 154                     ; 43 	usb.delay_counter = 0;
 156  002b 5f            	clrw	x
 157  002c bf5b          	ldw	_usb+71,x
 158                     ; 45 	if (*p_HSI_TRIMING_DONE == MAGIC_VAL)
 160  002e 92c602        	ld	a,[_p_HSI_TRIMING_DONE.w]
 161  0031 a111          	cp	a,#17
 162  0033 2606          	jrne	L33
 163                     ; 46 		usb.trimming_stage = HSI_TRIMMER_DISABLE;
 165  0035 3504005a      	mov	_usb+70,#4
 167  0039 2002          	jra	L53
 168  003b               L33:
 169                     ; 48 		usb.trimming_stage = HSI_TRIMMER_ENABLE;
 171  003b 3f5a          	clr	_usb+70
 172  003d               L53:
 173                     ; 50 	usb.HSI_Trim_val = (uint8_t)(*p_HSI_TRIM_VAL & 0x0F);
 175  003d 92c600        	ld	a,[_p_HSI_TRIM_VAL.w]
 176  0040 a40f          	and	a,#15
 177  0042 b75d          	ld	_usb+73,a
 178                     ; 51 	CLK->HSITRIMR = (uint8_t)((CLK->HSITRIMR & (~0x0F)) | usb.HSI_Trim_val);
 180  0044 c650cc        	ld	a,20684
 181  0047 a4f0          	and	a,#240
 182  0049 ba5d          	or	a,_usb+73
 183  004b c750cc        	ld	20684,a
 184                     ; 64 	usb.dev_state = USB_STATE_DEFAULT;
 186  004e 35010018      	mov	_usb+4,#1
 187                     ; 69 	USB_Reset();
 189  0052 adac          	call	_USB_Reset
 191                     ; 81 	TIM1->CCER1 = TIM1_CCER1_CC2P|TIM1_CCER1_CC2E;
 193  0054 3530525c      	mov	21084,#48
 194                     ; 83 	TIM1->CCMR2 = 0x21;
 196  0058 35215259      	mov	21081,#33
 197                     ; 88 	TIM1->SMCR = 0x66;
 199  005c 35665252      	mov	21074,#102
 200                     ; 93 	TIM1->IER = TIM1_IER_CC2IE;
 202  0060 35045254      	mov	21076,#4
 203                     ; 97 }
 206  0064 81            	ret	
 229                     ; 99 void USB_connect(void)
 229                     ; 100 {
 230                     	switch	.text
 231  0065               _USB_connect:
 235                     ; 102 	USB_PORT->DDR &= (uint8_t)~USB_DM;
 237  0065 721d500c      	bres	20492,#6
 238                     ; 103 }
 241  0069 81            	ret	
 264                     ; 105 void USB_disconnect(void)
 264                     ; 106 {
 265                     	switch	.text
 266  006a               _USB_disconnect:
 270                     ; 108 	USB_PORT->ODR &= (uint8_t)~USB_DM;
 272  006a 721d500a      	bres	20490,#6
 273                     ; 110 	USB_PORT->DDR |= USB_DM;	
 275  006e 721c500c      	bset	20492,#6
 276                     ; 111 }
 279  0072 81            	ret	
 282                     .const:	section	.text
 283  0000               L75_data:
 284  0000 80            	dc.b	128
 285  0001 5a            	dc.b	90
 286  0002               L16_data:
 287  0002 80            	dc.b	128
 288  0003 d2            	dc.b	210
 289  0004               L37_data:
 290  0004 80            	dc.b	128
 291  0005 5a            	dc.b	90
 292  0006               L101_data:
 293  0006 80            	dc.b	128
 294  0007 d2            	dc.b	210
 365                     ; 152 void usb_rx_ok(void)
 365                     ; 153 {
 366                     	switch	.text
 367  0073               _usb_rx_ok:
 369  0073 89            	pushw	x
 370       00000002      OFST:	set	2
 373                     ; 154 	switch (ll_usb_rx_buffer[1])
 375  0074 b605          	ld	a,_ll_usb_rx_buffer+1
 377                     ; 229 		default:
 377                     ; 230 			break;
 378  0076 a02d          	sub	a,#45
 379  0078 2716          	jreq	L36
 380  007a a01e          	sub	a,#30
 381  007c 2603cc0111    	jreq	L77
 382  0081 a01e          	sub	a,#30
 383  0083 2734          	jreq	L76
 384  0085 a05a          	sub	a,#90
 385  0087 27f5          	jreq	L77
 386  0089 a01e          	sub	a,#30
 387  008b 2714          	jreq	L56
 388  008d cc017d        	jra	L541
 389  0090               L36:
 390                     ; 156 		case USB_PID_SETUP:
 390                     ; 157 			if ((ll_usb_rx_buffer[2] & 0x7F) == usb.device_address)
 392  0090 cd018c        	call	LC003
 393  0093 2703cc017b    	jrne	L171
 394                     ; 159 				usb.stage = USB_STAGE_SETUP;
 396  0098 35010014      	mov	_usb,#1
 397                     ; 160 				usb.active_EP_num = 0;//(usb_rx_buffer[2] & 0x80)?1:0;
 399  009c 3f17          	clr	_usb+3
 401  009e cc017d        	jra	L541
 402                     ; 163 				usb.stage = USB_STAGE_NONE;
 403  00a1               L56:
 404                     ; 166 		case USB_PID_OUT:
 404                     ; 167 			if ((ll_usb_rx_buffer[2] & 0x7F) == usb.device_address)
 406  00a1 cd018c        	call	LC003
 407  00a4 26ef          	jrne	L171
 408                     ; 169 				usb.stage = USB_STAGE_OUT;
 410  00a6 35020014      	mov	_usb,#2
 411                     ; 170 				usb.active_EP_num = (uint8_t)((ll_usb_rx_buffer[2] & 0x80)?1:0);
 413  00aa 720f000604    	btjf	_ll_usb_rx_buffer+2,#7,L22
 414  00af a601          	ld	a,#1
 415  00b1 2001          	jra	L42
 416  00b3               L22:
 417  00b3 4f            	clr	a
 418  00b4               L42:
 419  00b4 b717          	ld	_usb+3,a
 421  00b6 cc017d        	jra	L541
 422                     ; 173 				usb.stage = USB_STAGE_NONE;
 423  00b9               L76:
 424                     ; 176 		case USB_PID_IN:
 424                     ; 177 			if ((ll_usb_rx_buffer[2] & 0x7F) == usb.device_address)
 426  00b9 cd018c        	call	LC003
 427  00bc 26d7          	jrne	L171
 428                     ; 179 				usb.active_EP_num = (uint8_t)((ll_usb_rx_buffer[2] & 0x80)?1:0);
 430  00be 720f000604    	btjf	_ll_usb_rx_buffer+2,#7,L62
 431  00c3 a601          	ld	a,#1
 432  00c5 2001          	jra	L03
 433  00c7               L62:
 434  00c7 4f            	clr	a
 435  00c8               L03:
 436  00c8 b717          	ld	_usb+3,a
 437                     ; 180 				if (usb.EP[usb.active_EP_num].tx_state == USB_EP_DATA_READY)
 439  00ca cd0187        	call	LC002
 440  00cd e637          	ld	a,(_usb+35,x)
 441  00cf 4a            	dec	a
 442  00d0 2628          	jrne	L161
 443                     ; 182 					usb_send_packet(usb.active_EP_num);
 446  00d2 b617          	ld	a,_usb+3
 447  00d4 6b02          	ld	(OFST+0,sp),a
 449                     ; 134 	ll_usb_tx_count = usb.EP[EP_num].tx_length;
 451  00d6 cd0187        	call	LC002
 452  00d9 e635          	ld	a,(_usb+33,x)
 453  00db b701          	ld	_ll_usb_tx_count,a
 454                     ; 135 	ll_usb_tx_buffer_pointer = usb.EP[EP_num].tx_buffer;
 456  00dd 01            	rrwa	x,a
 457  00de ab29          	add	a,#_usb+21
 458  00e0 5f            	clrw	x
 459  00e1 97            	ld	xl,a
 460  00e2 bf02          	ldw	_ll_usb_tx_buffer_pointer,x
 461                     ; 136 	ll_usb_tx();
 463  00e4 cd0000        	call	_ll_usb_tx
 465                     ; 183 					usb.EP[usb.active_EP_num].tx_state = USB_EP_NO_DATA;
 467  00e7 b617          	ld	a,_usb+3
 468  00e9 cd0187        	call	LC002
 469  00ec 6f37          	clr	(_usb+35,x)
 470                     ; 185 					if (usb.setup_address)
 472  00ee b616          	ld	a,_usb+2
 473  00f0 27a3          	jreq	L171
 474                     ; 187 						usb.device_address = usb.setup_address;
 476  00f2 451615        	mov	_usb+1,_usb+2
 477                     ; 188 						usb.setup_address = 0;
 479  00f5 3f16          	clr	_usb+2
 480  00f7 cc017b        	jra	L171
 481  00fa               L161:
 482                     ; 116 	const uint8_t data[2] = {USB_SYNC_BYTE, USB_PID_NACK};
 485  00fa c60004        	ld	a,L37_data
 486  00fd 6b01          	ld	(OFST-1,sp),a
 487  00ff c60005        	ld	a,L37_data+1
 488  0102 6b02          	ld	(OFST+0,sp),a
 489                     ; 118 	ll_usb_tx_count = 2;
 491  0104 35020001      	mov	_ll_usb_tx_count,#2
 492                     ; 119 	ll_usb_tx_buffer_pointer = data;
 494  0108 96            	ldw	x,sp
 495  0109 5c            	incw	x
 496  010a bf02          	ldw	_ll_usb_tx_buffer_pointer,x
 497                     ; 120 	ll_usb_tx();
 499  010c cd0000        	call	_ll_usb_tx
 501                     ; 199 			usb.stage = USB_STAGE_NONE;
 502                     ; 200 			break;
 504  010f 206a          	jp	L171
 505  0111               L77:
 506                     ; 202 		case USB_PID_DATA0: // Data received
 506                     ; 203 		case USB_PID_DATA1: // Data received
 506                     ; 204 			if (usb.stage != USB_STAGE_NONE)
 508  0111 3d14          	tnz	_usb
 509  0113 2768          	jreq	L541
 510                     ; 206 				if (usb.EP[usb.active_EP_num].rx_state == USB_EP_NO_DATA) // if EP ready
 512  0115 b617          	ld	a,_usb+3
 513  0117 ad6e          	call	LC002
 514  0119 6d28          	tnz	(_usb+20,x)
 515  011b 265e          	jrne	L171
 516                     ; 208 					usb.EP[usb.active_EP_num].rx_state = USB_EP_DATA_READY;
 518  011d a601          	ld	a,#1
 519  011f e728          	ld	(_usb+20,x),a
 520                     ; 125 	const uint8_t data[2] = {USB_SYNC_BYTE, USB_PID_ACK};
 523  0121 c60006        	ld	a,L101_data
 524  0124 6b01          	ld	(OFST-1,sp),a
 525  0126 c60007        	ld	a,L101_data+1
 526  0129 6b02          	ld	(OFST+0,sp),a
 527                     ; 127 	ll_usb_tx_count = 2;
 529  012b 35020001      	mov	_ll_usb_tx_count,#2
 530                     ; 128 	ll_usb_tx_buffer_pointer = data;
 532  012f 96            	ldw	x,sp
 533  0130 5c            	incw	x
 534  0131 bf02          	ldw	_ll_usb_tx_buffer_pointer,x
 535                     ; 129 	ll_usb_tx();
 537  0133 cd0000        	call	_ll_usb_tx
 539                     ; 211 					if (usb.active_EP_num == 0)
 541  0136 b617          	ld	a,_usb+3
 542  0138 2603          	jrne	L371
 543                     ; 212 						usb.EP0_data_stage = usb.stage; // USB_STAGE_SETUP or USB_STAGE_OUT
 545  013a 45141a        	mov	_usb+6,_usb
 546  013d               L371:
 547                     ; 214 					usb.EP[usb.active_EP_num].rx_length = (uint8_t)(14 - ll_usb_rx_count);
 549  013d ad48          	call	LC002
 550  013f a60e          	ld	a,#14
 551  0141 b000          	sub	a,_ll_usb_rx_count
 552  0143 e727          	ld	(_usb+19,x),a
 553                     ; 215 					if (usb.EP[usb.active_EP_num].rx_length > 3)
 555  0145 b617          	ld	a,_usb+3
 556  0147 ad3e          	call	LC002
 557  0149 e627          	ld	a,(_usb+19,x)
 558  014b a104          	cp	a,#4
 559  014d 252a          	jrult	L571
 560                     ; 217 						usb.EP[usb.active_EP_num].rx_length -= 3; // 1..9
 562  014f a003          	sub	a,#3
 563  0151 e727          	ld	(_usb+19,x),a
 564                     ; 218 						usb_copy_rx_packet(usb.active_EP_num);
 568                     ; 141 	usb.EP[EP_num].rx_buffer[0] = ll_usb_rx_buffer[2];
 570  0153 b606          	ld	a,_ll_usb_rx_buffer+2
 571  0155 e71b          	ld	(_usb+7,x),a
 572                     ; 142 	usb.EP[EP_num].rx_buffer[1] = ll_usb_rx_buffer[3];
 574  0157 b607          	ld	a,_ll_usb_rx_buffer+3
 575  0159 e71c          	ld	(_usb+8,x),a
 576                     ; 143 	usb.EP[EP_num].rx_buffer[2] = ll_usb_rx_buffer[4];
 578  015b b608          	ld	a,_ll_usb_rx_buffer+4
 579  015d e71d          	ld	(_usb+9,x),a
 580                     ; 144 	usb.EP[EP_num].rx_buffer[3] = ll_usb_rx_buffer[5];
 582  015f b609          	ld	a,_ll_usb_rx_buffer+5
 583  0161 e71e          	ld	(_usb+10,x),a
 584                     ; 145 	usb.EP[EP_num].rx_buffer[4] = ll_usb_rx_buffer[6];
 586  0163 b60a          	ld	a,_ll_usb_rx_buffer+6
 587  0165 e71f          	ld	(_usb+11,x),a
 588                     ; 146 	usb.EP[EP_num].rx_buffer[5] = ll_usb_rx_buffer[7];
 590  0167 b60b          	ld	a,_ll_usb_rx_buffer+7
 591  0169 e720          	ld	(_usb+12,x),a
 592                     ; 147 	usb.EP[EP_num].rx_buffer[6] = ll_usb_rx_buffer[8];
 594  016b b60c          	ld	a,_ll_usb_rx_buffer+8
 595  016d e721          	ld	(_usb+13,x),a
 596                     ; 148 	usb.EP[EP_num].rx_buffer[7] = ll_usb_rx_buffer[9];
 598  016f b60d          	ld	a,_ll_usb_rx_buffer+9
 599  0171 e722          	ld	(_usb+14,x),a
 600                     ; 149 	usb.EP[EP_num].rx_buffer[8] = ll_usb_rx_buffer[10];
 602  0173 b60e          	ld	a,_ll_usb_rx_buffer+10
 603  0175 e723          	ld	(_usb+15,x),a
 604  0177 2002          	jra	L171
 605  0179               L571:
 606                     ; 221 						usb.EP[usb.active_EP_num].rx_length = 0;
 608  0179 6f27          	clr	(_usb+19,x)
 609  017b               L171:
 610                     ; 223 				usb.stage = USB_STAGE_NONE;
 615  017b 3f14          	clr	_usb
 616                     ; 229 		default:
 616                     ; 230 			break;
 618  017d               L541:
 619                     ; 233 	if (usb.trimming_stage == HSI_TRIMMER_ENABLE)
 621  017d b65a          	ld	a,_usb+70
 622  017f 2604          	jrne	L102
 623                     ; 234 		usb.trimming_stage = HSI_TRIMMER_STARTED;
 625  0181 3501005a      	mov	_usb+70,#1
 626  0185               L102:
 627                     ; 236 }
 630  0185 85            	popw	x
 631  0186 81            	ret	
 632  0187               LC002:
 633  0187 97            	ld	xl,a
 634  0188 a61d          	ld	a,#29
 635  018a 42            	mul	x,a
 636  018b 81            	ret	
 637  018c               LC003:
 638  018c b606          	ld	a,_ll_usb_rx_buffer+2
 639  018e a47f          	and	a,#127
 640  0190 b115          	cp	a,_usb+1
 641  0192 81            	ret	
 703                     ; 238 void usb_calc_crc16(uint8_t * buffer, uint8_t length)
 703                     ; 239 {
 704                     	switch	.text
 705  0193               _usb_calc_crc16:
 707  0193 89            	pushw	x
 708  0194 5203          	subw	sp,#3
 709       00000003      OFST:	set	3
 712                     ; 240 	uint16_t crc = 0xFFFF;
 714  0196 aeffff        	ldw	x,#65535
 715  0199 1f02          	ldw	(OFST-1,sp),x
 718  019b 203c          	jra	L142
 719  019d               L532:
 720                     ; 245 		crc ^= *buffer++;
 722  019d 1e04          	ldw	x,(OFST+1,sp)
 723  019f f6            	ld	a,(x)
 724  01a0 5c            	incw	x
 725  01a1 1f04          	ldw	(OFST+1,sp),x
 726  01a3 5f            	clrw	x
 727  01a4 97            	ld	xl,a
 728  01a5 01            	rrwa	x,a
 729  01a6 1803          	xor	a,(OFST+0,sp)
 730  01a8 01            	rrwa	x,a
 731  01a9 1802          	xor	a,(OFST-1,sp)
 732  01ab 01            	rrwa	x,a
 733  01ac 1f02          	ldw	(OFST-1,sp),x
 735                     ; 247 		for (i = 8; i--;)
 737  01ae a608          	ld	a,#8
 738  01b0 6b01          	ld	(OFST-2,sp),a
 741  01b2 201c          	jra	L152
 742  01b4               L542:
 743                     ; 249 			if ((crc & BIT(0)) != 0)
 745  01b4 7b03          	ld	a,(OFST+0,sp)
 746  01b6 a501          	bcp	a,#1
 747  01b8 2712          	jreq	L552
 748                     ; 251 				crc >>= 1;
 750  01ba 0402          	srl	(OFST-1,sp)
 751  01bc 0603          	rrc	(OFST+0,sp)
 753                     ; 252 				crc ^= 0xA001;
 755  01be 7b03          	ld	a,(OFST+0,sp)
 756  01c0 a801          	xor	a,#1
 757  01c2 6b03          	ld	(OFST+0,sp),a
 758  01c4 7b02          	ld	a,(OFST-1,sp)
 759  01c6 a8a0          	xor	a,#160
 760  01c8 6b02          	ld	(OFST-1,sp),a
 763  01ca 2004          	jra	L152
 764  01cc               L552:
 765                     ; 256 				crc >>= 1;
 767  01cc 0402          	srl	(OFST-1,sp)
 768  01ce 0603          	rrc	(OFST+0,sp)
 770  01d0               L152:
 771                     ; 247 		for (i = 8; i--;)
 773  01d0 7b01          	ld	a,(OFST-2,sp)
 774  01d2 0a01          	dec	(OFST-2,sp)
 776  01d4 4d            	tnz	a
 777  01d5 26dd          	jrne	L542
 778                     ; 243 	for (;length;length--)
 780  01d7 0a08          	dec	(OFST+5,sp)
 781  01d9               L142:
 784  01d9 7b08          	ld	a,(OFST+5,sp)
 785  01db 26c0          	jrne	L532
 786                     ; 261 	crc = ~crc;
 788  01dd 1e02          	ldw	x,(OFST-1,sp)
 789  01df 53            	cplw	x
 790  01e0 1f02          	ldw	(OFST-1,sp),x
 792                     ; 263 	*buffer++ = (uint8_t) crc;
 794  01e2 1e04          	ldw	x,(OFST+1,sp)
 795  01e4 7b03          	ld	a,(OFST+0,sp)
 796  01e6 f7            	ld	(x),a
 797  01e7 5c            	incw	x
 798  01e8 1f04          	ldw	(OFST+1,sp),x
 799                     ; 264 	*buffer = (uint8_t) (crc >> 8);
 801  01ea 7b02          	ld	a,(OFST-1,sp)
 802  01ec f7            	ld	(x),a
 803                     ; 265 }
 806  01ed 5b05          	addw	sp,#5
 807  01ef 81            	ret	
 889                     ; 267 int8_t USB_Send_Data(uint8_t * buffer, uint16_t length, uint8_t EP_num)
 889                     ; 268 {
 890                     	switch	.text
 891  01f0               _USB_Send_Data:
 893  01f0 89            	pushw	x
 894  01f1 5204          	subw	sp,#4
 895       00000004      OFST:	set	4
 898                     ; 270 	uint8_t flag = 0;
 900  01f3 0f01          	clr	(OFST-3,sp)
 902                     ; 271 	uint16_t timeout = 30000;
 904  01f5 ae7530        	ldw	x,#30000
 905  01f8 1f02          	ldw	(OFST-2,sp),x
 907                     ; 273 	if (EP_num == 0)
 909  01fa 7b0b          	ld	a,(OFST+7,sp)
 910  01fc 261a          	jrne	L323
 912  01fe 2003          	jra	L723
 913  0200               L523:
 914                     ; 277 		{ timeout--;
 916  0200 5a            	decw	x
 917  0201 1f02          	ldw	(OFST-2,sp),x
 919  0203               L723:
 920                     ; 276 		while ((usb.EP[0].tx_state == USB_EP_DATA_READY)&&(timeout)) // wait for prev transmission 
 922  0203 b637          	ld	a,_usb+35
 923  0205 4a            	dec	a
 924  0206 2604          	jrne	L333
 926  0208 1e02          	ldw	x,(OFST-2,sp)
 927  020a 26f4          	jrne	L523
 928  020c               L333:
 929                     ; 279 		if (timeout == 0)
 931  020c 1e02          	ldw	x,(OFST-2,sp)
 932  020e 2602          	jrne	L533
 933                     ; 281 			usb.EP[0].tx_state = USB_EP_NO_DATA; // drop old packet
 935  0210 3f37          	clr	_usb+35
 936  0212               L533:
 937                     ; 292 		usb.EP[0].tx_data_sync = USB_PID_DATA1;
 939  0212 354b0036      	mov	_usb+34,#75
 941  0216 201e          	jra	L733
 942  0218               L323:
 943                     ; 296 		if (usb.dev_state != USB_STATE_CONFIGURED)
 945  0218 b618          	ld	a,_usb+4
 946  021a a103          	cp	a,#3
 947  021c 2704          	jreq	L143
 948                     ; 297 			return -2;
 950  021e a6fe          	ld	a,#254
 952  0220 2009          	jra	L65
 953  0222               L143:
 954                     ; 298 		if (length > 8) 
 956  0222 1e09          	ldw	x,(OFST+5,sp)
 957  0224 a30009        	cpw	x,#9
 958  0227 2505          	jrult	L343
 959                     ; 299 			return -3; 				// 8 bytes max for INTR EP
 961  0229 a6fd          	ld	a,#253
 963  022b               L65:
 965  022b 5b06          	addw	sp,#6
 966  022d 81            	ret	
 967  022e               L343:
 968                     ; 302 		if (usb.EP[1].tx_state != USB_EP_NO_DATA)
 970  022e 3d54          	tnz	_usb+64
 971  0230 2704          	jreq	L733
 972                     ; 303 			return -4;
 974  0232 a6fc          	ld	a,#252
 976  0234 20f5          	jra	L65
 977  0236               L733:
 978                     ; 306 	if (length == 0)
 980  0236 1e09          	ldw	x,(OFST+5,sp)
 981  0238 2703cc031f    	jrne	L553
 982                     ; 307 		flag = 1;	// Just send an empty packet
 984  023d a601          	ld	a,#1
 985  023f 6b01          	ld	(OFST-3,sp),a
 988  0241 cc0326        	jra	L153
 989  0244               L353:
 990                     ; 311 			usb.EP[EP_num].tx_buffer[0] = USB_SYNC_BYTE;
 992  0244 7b0b          	ld	a,(OFST+7,sp)
 993  0246 cd0356        	call	LC004
 994  0249 a680          	ld	a,#128
 995  024b e729          	ld	(_usb+21,x),a
 996                     ; 312 			usb.EP[EP_num].tx_buffer[1] = usb.EP[EP_num].tx_data_sync;
 998  024d e636          	ld	a,(_usb+34,x)
 999  024f e72a          	ld	(_usb+22,x),a
1000                     ; 314 			if ((length == 8)&&(EP_num == 0)) 
1002  0251 1e09          	ldw	x,(OFST+5,sp)
1003  0253 a30008        	cpw	x,#8
1004  0256 2607          	jrne	L163
1006  0258 7b0b          	ld	a,(OFST+7,sp)
1007  025a 2603          	jrne	L163
1008                     ; 315 				flag = 1;	// If the length of last DATA packet is 8, then finialize the transaction by an empty packet
1010  025c 4c            	inc	a
1011  025d 6b01          	ld	(OFST-3,sp),a
1013  025f               L163:
1014                     ; 317 			if (length > 8)
1016  025f a30009        	cpw	x,#9
1017  0262 7b0b          	ld	a,(OFST+7,sp)
1018  0264 97            	ld	xl,a
1019  0265 a61d          	ld	a,#29
1020  0267 2555          	jrult	L363
1021                     ; 319 				usb.EP[EP_num].tx_length = 12; // 2+8+2
1023  0269 42            	mul	x,a
1024  026a a60c          	ld	a,#12
1025  026c e735          	ld	(_usb+33,x),a
1026                     ; 321 				for (i = 2; i < 10; i++)
1028  026e a602          	ld	a,#2
1029  0270 6b04          	ld	(OFST+0,sp),a
1031  0272               L563:
1032                     ; 322 					usb.EP[EP_num].tx_buffer[i] = *buffer++;
1034  0272 7b0b          	ld	a,(OFST+7,sp)
1035  0274 cd0356        	call	LC004
1036  0277 01            	rrwa	x,a
1037  0278 1b04          	add	a,(OFST+0,sp)
1038  027a 2401          	jrnc	L64
1039  027c 5c            	incw	x
1040  027d               L64:
1041  027d 1605          	ldw	y,(OFST+1,sp)
1042  027f 02            	rlwa	x,a
1043  0280 90f6          	ld	a,(y)
1044  0282 905c          	incw	y
1045  0284 1705          	ldw	(OFST+1,sp),y
1046  0286 e729          	ld	(_usb+21,x),a
1047                     ; 321 				for (i = 2; i < 10; i++)
1049  0288 0c04          	inc	(OFST+0,sp)
1053  028a 7b04          	ld	a,(OFST+0,sp)
1054  028c a10a          	cp	a,#10
1055  028e 25e2          	jrult	L563
1056                     ; 324 				length -= 8;
1058  0290 1e09          	ldw	x,(OFST+5,sp)
1059  0292 1d0008        	subw	x,#8
1061  0295               L373:
1062  0295 1f09          	ldw	(OFST+5,sp),x
1063                     ; 337 			usb_calc_crc16(&usb.EP[EP_num].tx_buffer[2], (uint8_t) (usb.EP[EP_num].tx_length - 4));
1065  0297 7b0b          	ld	a,(OFST+7,sp)
1066  0299 cd0356        	call	LC004
1067  029c e635          	ld	a,(_usb+33,x)
1068  029e a004          	sub	a,#4
1069  02a0 88            	push	a
1070  02a1 7b0c          	ld	a,(OFST+8,sp)
1071  02a3 cd0356        	call	LC004
1072  02a6 01            	rrwa	x,a
1073  02a7 ab2b          	add	a,#_usb+23
1074  02a9 5f            	clrw	x
1075  02aa 97            	ld	xl,a
1076  02ab cd0193        	call	_usb_calc_crc16
1078  02ae 84            	pop	a
1079                     ; 340 			if (usb.EP[EP_num].tx_data_sync == USB_PID_DATA1) 
1081  02af 7b0b          	ld	a,(OFST+7,sp)
1082  02b1 cd0356        	call	LC004
1083  02b4 e636          	ld	a,(_usb+34,x)
1084  02b6 a14b          	cp	a,#75
1085  02b8 263e          	jrne	L504
1086                     ; 341 				usb.EP[EP_num].tx_data_sync = USB_PID_DATA0;
1088  02ba a6c3          	ld	a,#195
1090  02bc 203c          	jra	L704
1091  02be               L363:
1092                     ; 328 				usb.EP[EP_num].tx_length = (uint8_t)(4 + length);
1094  02be 42            	mul	x,a
1095  02bf 7b0a          	ld	a,(OFST+6,sp)
1096  02c1 ab04          	add	a,#4
1097  02c3 e735          	ld	(_usb+33,x),a
1098                     ; 330 				for (i = 2; i < 2 + length; i++)
1100  02c5 a602          	ld	a,#2
1101  02c7 6b04          	ld	(OFST+0,sp),a
1104  02c9 201a          	jra	L104
1105  02cb               L573:
1106                     ; 331 					usb.EP[EP_num].tx_buffer[i] = *buffer++;
1108  02cb 7b0b          	ld	a,(OFST+7,sp)
1109  02cd cd0356        	call	LC004
1110  02d0 01            	rrwa	x,a
1111  02d1 1b04          	add	a,(OFST+0,sp)
1112  02d3 2401          	jrnc	L05
1113  02d5 5c            	incw	x
1114  02d6               L05:
1115  02d6 1605          	ldw	y,(OFST+1,sp)
1116  02d8 02            	rlwa	x,a
1117  02d9 90f6          	ld	a,(y)
1118  02db 905c          	incw	y
1119  02dd 1705          	ldw	(OFST+1,sp),y
1120  02df e729          	ld	(_usb+21,x),a
1121                     ; 330 				for (i = 2; i < 2 + length; i++)
1123  02e1 0c04          	inc	(OFST+0,sp)
1125  02e3 7b04          	ld	a,(OFST+0,sp)
1126  02e5               L104:
1129  02e5 1e09          	ldw	x,(OFST+5,sp)
1130  02e7 1c0002        	addw	x,#2
1131  02ea 905f          	clrw	y
1132  02ec 9097          	ld	yl,a
1133  02ee 90bf00        	ldw	c_y,y
1134  02f1 b300          	cpw	x,c_y
1135  02f3 22d6          	jrugt	L573
1136                     ; 333 				length = 0;
1138  02f5 5f            	clrw	x
1139  02f6 209d          	jra	L373
1140  02f8               L504:
1141                     ; 343 				usb.EP[EP_num].tx_data_sync = USB_PID_DATA1;
1143  02f8 a64b          	ld	a,#75
1144  02fa               L704:
1145  02fa e736          	ld	(_usb+34,x),a
1146                     ; 346 			usb.EP[EP_num].tx_state = USB_EP_DATA_READY;
1148  02fc 7b0b          	ld	a,(OFST+7,sp)
1149  02fe ad56          	call	LC004
1150  0300 a601          	ld	a,#1
1151  0302 e737          	ld	(_usb+35,x),a
1152                     ; 348 			if (EP_num == 0)
1154  0304 7b0b          	ld	a,(OFST+7,sp)
1155  0306 2617          	jrne	L553
1156                     ; 351 				timeout = 60000;
1158  0308 aeea60        	ldw	x,#60000
1160  030b 2001          	jra	L714
1161  030d               L314:
1162                     ; 353 				{ timeout--;
1164  030d 5a            	decw	x
1165  030e               L714:
1166  030e 1f02          	ldw	(OFST-2,sp),x
1168                     ; 352 				while ((usb.EP[0].tx_state == USB_EP_DATA_READY)&&(timeout)) // wait for prev transmission 
1168                     ; 353 				{ timeout--;
1170  0310 b637          	ld	a,_usb+35
1171  0312 4a            	dec	a
1172  0313 2604          	jrne	L324
1174  0315 1e02          	ldw	x,(OFST-2,sp)
1175  0317 26f4          	jrne	L314
1176  0319               L324:
1177                     ; 356 				if (!timeout)
1179  0319 1e02          	ldw	x,(OFST-2,sp)
1180  031b 2602          	jrne	L553
1181                     ; 358 					usb.EP[0].tx_state = USB_EP_NO_DATA; // drop old packet
1183  031d 3f37          	clr	_usb+35
1184  031f               L553:
1185                     ; 309 		while (length > 0)
1187  031f 1e09          	ldw	x,(OFST+5,sp)
1188  0321 2703cc0244    	jrne	L353
1189  0326               L153:
1190                     ; 370 	if (flag)
1192  0326 7b01          	ld	a,(OFST-3,sp)
1193  0328 2728          	jreq	L724
1194                     ; 372 		usb.EP[EP_num].tx_length = 4;
1196  032a 7b0b          	ld	a,(OFST+7,sp)
1197  032c ad28          	call	LC004
1198  032e a604          	ld	a,#4
1199  0330 e735          	ld	(_usb+33,x),a
1200                     ; 373 		usb.EP[EP_num].tx_buffer[0] = USB_SYNC_BYTE;
1202  0332 a680          	ld	a,#128
1203  0334 e729          	ld	(_usb+21,x),a
1204                     ; 374 		usb.EP[EP_num].tx_buffer[1] = usb.EP[EP_num].tx_data_sync;
1206  0336 e636          	ld	a,(_usb+34,x)
1207  0338 e72a          	ld	(_usb+22,x),a
1208                     ; 375 		usb.EP[EP_num].tx_buffer[2] = 0;
1210  033a 6f2b          	clr	(_usb+23,x)
1211                     ; 376 		usb.EP[EP_num].tx_buffer[3] = 0;
1213  033c 6f2c          	clr	(_usb+24,x)
1214                     ; 378 		if (usb.EP[EP_num].tx_data_sync == USB_PID_DATA1)
1216  033e a14b          	cp	a,#75
1217  0340 2604          	jrne	L134
1218                     ; 379 			usb.EP[EP_num].tx_data_sync = USB_PID_DATA0;
1220  0342 a6c3          	ld	a,#195
1222  0344 2002          	jra	L334
1223  0346               L134:
1224                     ; 381 			usb.EP[EP_num].tx_data_sync = USB_PID_DATA1;
1226  0346 a64b          	ld	a,#75
1227  0348               L334:
1228  0348 e736          	ld	(_usb+34,x),a
1229                     ; 383 		usb.EP[EP_num].tx_state = USB_EP_DATA_READY;
1231  034a 7b0b          	ld	a,(OFST+7,sp)
1232  034c ad08          	call	LC004
1233  034e a601          	ld	a,#1
1234  0350 e737          	ld	(_usb+35,x),a
1235  0352               L724:
1236                     ; 385 	return 0;
1238  0352 4f            	clr	a
1240  0353 cc022b        	jra	L65
1241  0356               LC004:
1242  0356 97            	ld	xl,a
1243  0357 a61d          	ld	a,#29
1244  0359 42            	mul	x,a
1245  035a 81            	ret	
1280                     ; 388 void USB_Send_STALL(uint8_t EP_num)
1280                     ; 389 {
1281                     	switch	.text
1282  035b               _USB_Send_STALL:
1284  035b 88            	push	a
1285       00000000      OFST:	set	0
1288                     ; 390 	usb.EP[EP_num].tx_length = 2;
1290  035c 97            	ld	xl,a
1291  035d a61d          	ld	a,#29
1292  035f 42            	mul	x,a
1293  0360 a602          	ld	a,#2
1294  0362 e735          	ld	(_usb+33,x),a
1295                     ; 391 	usb.EP[EP_num].tx_buffer[0] = USB_SYNC_BYTE;
1297  0364 7b01          	ld	a,(OFST+1,sp)
1298  0366 97            	ld	xl,a
1299  0367 a61d          	ld	a,#29
1300  0369 42            	mul	x,a
1301  036a a680          	ld	a,#128
1302  036c e729          	ld	(_usb+21,x),a
1303                     ; 392 	usb.EP[EP_num].tx_buffer[1] = USB_PID_STALL;
1305  036e a61e          	ld	a,#30
1306  0370 e72a          	ld	(_usb+22,x),a
1307                     ; 393 	usb.EP[EP_num].tx_state = USB_EP_DATA_READY;
1309  0372 a601          	ld	a,#1
1310  0374 e737          	ld	(_usb+35,x),a
1311                     ; 394 }
1314  0376 84            	pop	a
1315  0377 81            	ret	
1414                     ; 401 void USB_NRZI_RX_Decode(uint8_t *p_data, uint8_t length)
1414                     ; 402 {
1415                     	switch	.text
1416  0378               _USB_NRZI_RX_Decode:
1418  0378 89            	pushw	x
1419  0379 5207          	subw	sp,#7
1420       00000007      OFST:	set	7
1423                     ; 405 	uint16_t word = p_data[0] << 8;
1425  037b f6            	ld	a,(x)
1426  037c 97            	ld	xl,a
1427  037d 4f            	clr	a
1428  037e 02            	rlwa	x,a
1429  037f 1f03          	ldw	(OFST-4,sp),x
1431                     ; 406 	uint8_t offset = 0;
1433  0381 0f02          	clr	(OFST-5,sp)
1435                     ; 407 	uint8_t cnt = 0;
1437  0383 0f06          	clr	(OFST-1,sp)
1439                     ; 409 	for(i=0; i<length; i++) 
1441  0385 0f05          	clr	(OFST-2,sp)
1444  0387 2068          	jra	L135
1445  0389               L525:
1446                     ; 411 		word >>=8;
1448  0389 7b03          	ld	a,(OFST-4,sp)
1449  038b 6b04          	ld	(OFST-3,sp),a
1450  038d 0f03          	clr	(OFST-4,sp)
1452                     ; 412 		word |= (p_data[i+1] << 8);
1454  038f 5f            	clrw	x
1455  0390 7b05          	ld	a,(OFST-2,sp)
1456  0392 97            	ld	xl,a
1457  0393 72fb08        	addw	x,(OFST+1,sp)
1458  0396 e601          	ld	a,(1,x)
1459  0398 5f            	clrw	x
1460  0399 97            	ld	xl,a
1461  039a 7b04          	ld	a,(OFST-3,sp)
1462  039c 01            	rrwa	x,a
1463  039d 1a03          	or	a,(OFST-4,sp)
1464  039f 01            	rrwa	x,a
1465  03a0 1f03          	ldw	(OFST-4,sp),x
1467                     ; 413 		byte = 0;
1469  03a2 0f01          	clr	(OFST-6,sp)
1471                     ; 415 		for(j=0;j<8;j++) 
1473  03a4 4f            	clr	a
1474  03a5 6b07          	ld	(OFST+0,sp),a
1476  03a7               L535:
1477                     ; 417 			if (word & (1 << (j+offset)))
1479  03a7 ae0001        	ldw	x,#1
1480  03aa 1b02          	add	a,(OFST-5,sp)
1481  03ac 2704          	jreq	L46
1482  03ae               L66:
1483  03ae 58            	sllw	x
1484  03af 4a            	dec	a
1485  03b0 26fc          	jrne	L66
1486  03b2               L46:
1487  03b2 01            	rrwa	x,a
1488  03b3 1404          	and	a,(OFST-3,sp)
1489  03b5 01            	rrwa	x,a
1490  03b6 1403          	and	a,(OFST-4,sp)
1491  03b8 01            	rrwa	x,a
1492  03b9 5d            	tnzw	x
1493  03ba 271b          	jreq	L345
1494                     ; 419 				byte |= (uint8_t)(1 << j);
1496  03bc 7b07          	ld	a,(OFST+0,sp)
1497  03be 5f            	clrw	x
1498  03bf 97            	ld	xl,a
1499  03c0 a601          	ld	a,#1
1500  03c2 5d            	tnzw	x
1501  03c3 2704          	jreq	L07
1502  03c5               L27:
1503  03c5 48            	sll	a
1504  03c6 5a            	decw	x
1505  03c7 26fc          	jrne	L27
1506  03c9               L07:
1507  03c9 1a01          	or	a,(OFST-6,sp)
1508  03cb 6b01          	ld	(OFST-6,sp),a
1510                     ; 420 				cnt++;
1512  03cd 0c06          	inc	(OFST-1,sp)
1514                     ; 422 				if (cnt == 6)
1516  03cf 7b06          	ld	a,(OFST-1,sp)
1517  03d1 a106          	cp	a,#6
1518  03d3 2604          	jrne	L745
1519                     ; 424 					offset++;
1521  03d5 0c02          	inc	(OFST-5,sp)
1523                     ; 425 					cnt=0;
1524  03d7               L345:
1525                     ; 430 				cnt=0;
1528  03d7 0f06          	clr	(OFST-1,sp)
1530  03d9               L745:
1531                     ; 415 		for(j=0;j<8;j++) 
1533  03d9 0c07          	inc	(OFST+0,sp)
1537  03db 7b07          	ld	a,(OFST+0,sp)
1538  03dd a108          	cp	a,#8
1539  03df 25c6          	jrult	L535
1540                     ; 433 		p_data[i] = byte;
1542  03e1 7b08          	ld	a,(OFST+1,sp)
1543  03e3 97            	ld	xl,a
1544  03e4 7b09          	ld	a,(OFST+2,sp)
1545  03e6 1b05          	add	a,(OFST-2,sp)
1546  03e8 2401          	jrnc	L47
1547  03ea 5c            	incw	x
1548  03eb               L47:
1549  03eb 02            	rlwa	x,a
1550  03ec 7b01          	ld	a,(OFST-6,sp)
1551  03ee f7            	ld	(x),a
1552                     ; 409 	for(i=0; i<length; i++) 
1554  03ef 0c05          	inc	(OFST-2,sp)
1556  03f1               L135:
1559  03f1 7b05          	ld	a,(OFST-2,sp)
1560  03f3 110c          	cp	a,(OFST+5,sp)
1561  03f5 2592          	jrult	L525
1562                     ; 435 }
1565  03f7 5b09          	addw	sp,#9
1566  03f9 81            	ret	
1672                     ; 437 void USB_Device_Request(t_USB_SetupReq *p_USB_SetupReq)
1672                     ; 438 {
1673                     	switch	.text
1674  03fa               _USB_Device_Request:
1676  03fa 89            	pushw	x
1677       00000000      OFST:	set	0
1680                     ; 439 	switch (p_USB_SetupReq->bRequest)
1682  03fb e601          	ld	a,(1,x)
1684                     ; 599 			break;
1685  03fd 2603cc04b3    	jreq	L706
1686  0402 a005          	sub	a,#5
1687  0404 270d          	jreq	L155
1688  0406 a003          	sub	a,#3
1689  0408 2603cc049a    	jreq	L575
1690  040d 4a            	dec	a
1691  040e 272c          	jreq	L555
1692                     ; 398 	USB_Send_STALL(0);
1695  0410 cc04bc        	jp	LC008
1696  0413               L155:
1697                     ; 441 		case USB_REQ_SET_ADDRESS:	// SET_ADDRESS
1697                     ; 442 		
1697                     ; 443 			if ((p_USB_SetupReq->wIndex_LO == 0) && 
1697                     ; 444 					(p_USB_SetupReq->wLength_LO == 0) &&
1697                     ; 445 					(usb.dev_state != USB_STATE_CONFIGURED))
1699  0413 e604          	ld	a,(4,x)
1700  0415 26f9          	jrne	LC008
1702  0417 e606          	ld	a,(6,x)
1703  0419 26f5          	jrne	LC008
1705  041b b618          	ld	a,_usb+4
1706  041d a103          	cp	a,#3
1707  041f 27ef          	jreq	LC008
1708                     ; 447 				usb.setup_address = (uint8_t)(p_USB_SetupReq->wValue_LO & 0x7F);
1710  0421 e602          	ld	a,(2,x)
1711  0423 a47f          	and	a,#127
1712  0425 b716          	ld	_usb+2,a
1713                     ; 448 				USB_Send_Data(NULL, 0, 0);
1715  0427 cd04dd        	call	LC009
1716                     ; 450 				if (usb.setup_address)
1718  042a b616          	ld	a,_usb+2
1719  042c 2707          	jreq	L576
1720                     ; 451 					usb.dev_state  = USB_STATE_ADDRESSED;
1722  042e 35020018      	mov	_usb+4,#2
1724  0432 cc04db        	jra	L176
1725  0435               L576:
1726                     ; 453 					usb.dev_state  = USB_STATE_DEFAULT; 
1728  0435 35010018      	mov	_usb+4,#1
1729  0439 cc04db        	jra	L176
1730                     ; 398 	USB_Send_STALL(0);
1733  043c               L555:
1734                     ; 462 		case USB_REQ_SET_CONFIGURATION:	// SET_CONFIGURATION
1734                     ; 463 			if (p_USB_SetupReq->wValue_LO <= USB_MAX_NUM_CONFIGURATION)
1736  043c e602          	ld	a,(2,x)
1737  043e a102          	cp	a,#2
1738  0440 247a          	jruge	LC008
1739                     ; 465 				switch (usb.dev_state)
1741  0442 b618          	ld	a,_usb+4
1743                     ; 517 						break;
1744  0444 a002          	sub	a,#2
1745  0446 2705          	jreq	L755
1746  0448 4a            	dec	a
1747  0449 2725          	jreq	L365
1748                     ; 398 	USB_Send_STALL(0);
1751  044b 206f          	jp	LC008
1752  044d               L755:
1753                     ; 467 					case USB_STATE_ADDRESSED:
1753                     ; 468 					
1753                     ; 469 						if (p_USB_SetupReq->wValue_LO) 
1755  044d e602          	ld	a,(2,x)
1756  044f 2743          	jreq	L137
1757                     ; 471 							usb.dev_config = p_USB_SetupReq->wValue_LO; // set new configuration
1759  0451 b719          	ld	_usb+5,a
1760                     ; 472 							usb.dev_state = USB_STATE_CONFIGURED;
1762  0453 35030018      	mov	_usb+4,#3
1763                     ; 474 							if (USB_Class_Init_callback(usb.dev_config) < 0)
1765  0457 cd0000        	call	_USB_Class_Init_callback
1767  045a 4d            	tnz	a
1768  045b 2a06          	jrpl	L317
1769                     ; 398 	USB_Send_STALL(0);
1772  045d 4f            	clr	a
1773  045e cd035b        	call	_USB_Send_STALL
1775  0461 2002          	jra	L517
1776  0463               L317:
1777                     ; 477 								USB_Send_Data(NULL, 0, 0);
1779  0463 ad78          	call	LC009
1780  0465               L517:
1781                     ; 480 							if (usb.trimming_stage == HSI_TRIMMER_STARTED) 
1783  0465 b65a          	ld	a,_usb+70
1784  0467 4a            	dec	a
1785  0468 2671          	jrne	L176
1786                     ; 481 								usb.trimming_stage = HSI_TRIMMER_WRITE_TRIM_VAL;
1788  046a 3503005a      	mov	_usb+70,#3
1789  046e 206b          	jra	L176
1790                     ; 486 							USB_Send_Data(NULL, 0, 0);
1792  0470               L365:
1793                     ; 490 					case USB_STATE_CONFIGURED:
1793                     ; 491 					
1793                     ; 492 						if (p_USB_SetupReq->wValue_LO == 0) 
1795  0470 6d02          	tnz	(2,x)
1796  0472 260b          	jrne	L327
1797                     ; 494 							usb.dev_state = USB_STATE_ADDRESSED;
1799  0474 35020018      	mov	_usb+4,#2
1800                     ; 495 							usb.dev_config = 0;
1802  0478 b719          	ld	_usb+5,a
1803                     ; 496 							USB_Class_DeInit_callback();
1805  047a cd0000        	call	_USB_Class_DeInit_callback
1807                     ; 497 							USB_Send_Data(NULL, 0, 0);
1810  047d 2015          	jp	L137
1811  047f               L327:
1812                     ; 499 						else if (p_USB_SetupReq->wValue_LO != usb.dev_config) 
1814  047f e602          	ld	a,(2,x)
1815  0481 b119          	cp	a,_usb+5
1816  0483 270f          	jreq	L137
1817                     ; 501 							USB_Class_DeInit_callback();
1819  0485 cd0000        	call	_USB_Class_DeInit_callback
1821                     ; 502 							usb.dev_config = p_USB_SetupReq->wValue_LO; // set new configuration
1823  0488 1e01          	ldw	x,(OFST+1,sp)
1824  048a e602          	ld	a,(2,x)
1825  048c b719          	ld	_usb+5,a
1826                     ; 504 							if (USB_Class_Init_callback(usb.dev_config) < 0)
1828  048e cd0000        	call	_USB_Class_Init_callback
1830  0491 4d            	tnz	a
1831                     ; 398 	USB_Send_STALL(0);
1834  0492 2b28          	jrmi	LC008
1835  0494               L137:
1836                     ; 507 								USB_Send_Data(NULL, 0, 0);
1838                     ; 511 							USB_Send_Data(NULL, 0, 0);
1843  0494 4b00          	push	#0
1844  0496 5f            	clrw	x
1845  0497 89            	pushw	x
1847  0498 203c          	jp	LC006
1848                     ; 517 						break;
1849                     ; 398 	USB_Send_STALL(0);
1852  049a               L575:
1853                     ; 524 		case USB_REQ_GET_CONFIGURATION: // GET_CONFIGURATION
1853                     ; 525 			if (p_USB_SetupReq->wLength_LO == 1) 
1855  049a e606          	ld	a,(6,x)
1856  049c 4a            	dec	a
1857  049d 261d          	jrne	LC008
1858                     ; 527 				switch (usb.dev_state)  
1860  049f b618          	ld	a,_usb+4
1862                     ; 536 						break;
1863  04a1 a002          	sub	a,#2
1864  04a3 2703          	jreq	L775
1865  04a5 4a            	dec	a
1866                     ; 398 	USB_Send_STALL(0);
1869  04a6 2614          	jrne	LC008
1870  04a8               L775:
1871                     ; 529 					case USB_STATE_ADDRESSED:
1871                     ; 530 					case USB_STATE_CONFIGURED:
1871                     ; 531 						USB_Send_Data(&usb.dev_config, 1, 0);
1873  04a8 4b00          	push	#0
1874  04aa ae0001        	ldw	x,#1
1875  04ad 89            	pushw	x
1876  04ae ae0019        	ldw	x,#_usb+5
1878                     ; 532 						break;
1880  04b1 2023          	jp	LC006
1881                     ; 536 						break;
1882                     ; 398 	USB_Send_STALL(0);
1885  04b3               L706:
1886                     ; 543 		case USB_REQ_GET_STATUS: // GET_STATUS
1886                     ; 544 			switch (usb.dev_state) 
1888  04b3 b618          	ld	a,_usb+4
1890                     ; 561 					break;
1891  04b5 a002          	sub	a,#2
1892  04b7 2709          	jreq	L116
1893  04b9 4a            	dec	a
1894  04ba 2706          	jreq	L116
1895                     ; 398 	USB_Send_STALL(0);
1898  04bc               LC008:
1906  04bc 4f            	clr	a
1907  04bd cd035b        	call	_USB_Send_STALL
1909  04c0 2019          	jra	L176
1910  04c2               L116:
1911                     ; 546 				case USB_STATE_ADDRESSED:
1911                     ; 547 				case USB_STATE_CONFIGURED:
1911                     ; 548 				
1911                     ; 549 					usb.dev_config_status = 0;
1913  04c2 5f            	clrw	x
1914  04c3 bf57          	ldw	_usb+67,x
1915                     ; 553 					if (usb.dev_remote_wakeup)
1917  04c5 b659          	ld	a,_usb+69
1918  04c7 2704          	jreq	L557
1919                     ; 554 						usb.dev_config_status |= USB_CONFIG_REMOTE_WAKEUP;
1921  04c9 72120058      	bset	_usb+68,#1
1922  04cd               L557:
1923                     ; 556 					USB_Send_Data((uint8_t*)&usb.dev_config_status, 2, 0);
1925  04cd 4b00          	push	#0
1926  04cf ae0002        	ldw	x,#2
1927  04d2 89            	pushw	x
1928  04d3 ae0057        	ldw	x,#_usb+67
1930  04d6               LC006:
1931  04d6 cd01f0        	call	_USB_Send_Data
1932  04d9 5b03          	addw	sp,#3
1933                     ; 557 					break;
1935                     ; 563 			break;
1937  04db               L176:
1938                     ; 601 }
1941  04db 85            	popw	x
1942  04dc 81            	ret	
1943  04dd               LC009:
1944  04dd 4b00          	push	#0
1945  04df 5f            	clrw	x
1946  04e0 89            	pushw	x
1947  04e1 cd01f0        	call	_USB_Send_Data
1949  04e4 5b03          	addw	sp,#3
1950  04e6 81            	ret	
1993                     ; 603 void USB_Handle_Standard_Request(t_USB_SetupReq *p_USB_SetupReq)
1993                     ; 604 {
1994                     	switch	.text
1995  04e7               _USB_Handle_Standard_Request:
1997  04e7 89            	pushw	x
1998       00000000      OFST:	set	0
2001                     ; 605 	switch (p_USB_SetupReq->bmRequest & USB_RECIP_MASK)
2003  04e8 f6            	ld	a,(x)
2004  04e9 a41f          	and	a,#31
2006                     ; 668 			break;
2007  04eb 2705          	jreq	L757
2008  04ed 4a            	dec	a
2009  04ee 2707          	jreq	L167
2010                     ; 398 	USB_Send_STALL(0);
2013  04f0 2017          	jp	LC010
2014  04f2               L757:
2015                     ; 607 		case USB_REQ_RECIPIENT_DEVICE: 		// Device request
2015                     ; 608 			USB_Device_Request(p_USB_SetupReq);
2017  04f2 cd03fa        	call	_USB_Device_Request
2019                     ; 609 			break;
2021  04f5 2016          	jra	L3101
2022  04f7               L167:
2023                     ; 611 		case USB_REQ_RECIPIENT_INTERFACE: // Interface request
2023                     ; 612 			if ((usb.dev_state != USB_STATE_CONFIGURED)||
2023                     ; 613 				  (p_USB_SetupReq->wIndex_LO > USB_MAX_NUM_INTERFACES)||
2023                     ; 614 					(USB_Setup_Request_callback(p_USB_SetupReq)>= 0)	)		// <--  Callback
2025  04f7 b618          	ld	a,_usb+4
2026  04f9 a103          	cp	a,#3
2027  04fb 2610          	jrne	L3101
2029  04fd e604          	ld	a,(4,x)
2030  04ff a102          	cp	a,#2
2031  0501 240a          	jruge	L3101
2033  0503 cd0000        	call	_USB_Setup_Request_callback
2035  0506 4d            	tnz	a
2036                     ; 615 				return;
2038  0507 2a04          	jrpl	L3101
2039                     ; 398 	USB_Send_STALL(0);
2042  0509               LC010:
2044  0509 4f            	clr	a
2045  050a cd035b        	call	_USB_Send_STALL
2047  050d               L3101:
2048                     ; 670 }
2051  050d 85            	popw	x
2052  050e 81            	ret	
2107                     ; 672 void USB_Handle_GetDescriptor(t_USB_SetupReq *p_USB_SetupReq)
2107                     ; 673 {
2108                     	switch	.text
2109  050f               _USB_Handle_GetDescriptor:
2111  050f 89            	pushw	x
2112  0510 89            	pushw	x
2113       00000002      OFST:	set	2
2116                     ; 674 	uint16_t wLength = p_USB_SetupReq->wLength_LO|(p_USB_SetupReq->wLength_HI << 8);
2118  0511 e607          	ld	a,(7,x)
2119  0513 1603          	ldw	y,(OFST+1,sp)
2120  0515 97            	ld	xl,a
2121  0516 90e606        	ld	a,(6,y)
2122  0519 02            	rlwa	x,a
2123  051a 1f01          	ldw	(OFST-1,sp),x
2125                     ; 676 	switch (p_USB_SetupReq->wValue_HI)
2127  051c 93            	ldw	x,y
2128  051d e603          	ld	a,(3,x)
2130                     ; 709 			break;
2131  051f 4a            	dec	a
2132  0520 270f          	jreq	L5201
2133  0522 4a            	dec	a
2134  0523 271e          	jreq	L7201
2135  0525 4a            	dec	a
2136  0526 272d          	jreq	L1301
2137  0528 a01e          	sub	a,#30
2138  052a 2765          	jreq	L7301
2139  052c 4a            	dec	a
2140  052d 2750          	jreq	L5301
2141                     ; 398 	USB_Send_STALL(0);
2144  052f 2048          	jp	L5701
2145  0531               L5201:
2146                     ; 678 		case USB_DESC_TYPE_DEVICE:	// Device desc
2146                     ; 679 			USB_Send_Data(usb_device_descriptor,MIN(wLength, SIZE_DEVICE_DESCRIPTOR),0);
2148  0531 4b00          	push	#0
2149  0533 1e02          	ldw	x,(OFST+0,sp)
2150  0535 a30013        	cpw	x,#19
2151  0538 2503          	jrult	L471
2152  053a ae0012        	ldw	x,#18
2153  053d               L471:
2154  053d 89            	pushw	x
2155  053e ae0000        	ldw	x,#_usb_device_descriptor
2157                     ; 680 			break;
2159  0541 205e          	jp	LC011
2160  0543               L7201:
2161                     ; 682 		case USB_DESC_TYPE_CONFIGURATION:	// Configuration desc
2161                     ; 683 			USB_Send_Data(usb_configuration_descriptor,MIN(wLength, SIZE_CONFIGURATION_DESCRIPTOR),0);
2163  0543 4b00          	push	#0
2164  0545 1e02          	ldw	x,(OFST+0,sp)
2165  0547 a30023        	cpw	x,#35
2166  054a 2503          	jrult	L202
2167  054c ae0022        	ldw	x,#34
2168  054f               L202:
2169  054f 89            	pushw	x
2170  0550 ae0000        	ldw	x,#_usb_configuration_descriptor
2172                     ; 684 			break;
2174  0553 204c          	jp	LC011
2175  0555               L1301:
2176                     ; 686 		case USB_DESC_TYPE_STRING: // String desc
2176                     ; 687 			if (p_USB_SetupReq->wValue_LO < LENGTH_STRING_DESCRIPTOR) 
2178  0555 e602          	ld	a,(2,x)
2179  0557 a104          	cp	a,#4
2180  0559 241e          	jruge	L5701
2181                     ; 689 				USB_Send_Data(USB_String_Descriptors[p_USB_SetupReq->wValue_LO], 
2181                     ; 690 						MIN(wLength,USB_String_Descriptors_Length[p_USB_SetupReq->wValue_LO]),0);
2183  055b 4b00          	push	#0
2184  055d 1e04          	ldw	x,(OFST+2,sp)
2185  055f ad48          	call	LC013
2186  0561 1302          	cpw	x,(OFST+0,sp)
2187  0563 2504          	jrult	L602
2188  0565 1e02          	ldw	x,(OFST+0,sp)
2189  0567 2004          	jra	L012
2190  0569               L602:
2191  0569 1e04          	ldw	x,(OFST+2,sp)
2192  056b ad3c          	call	LC013
2193  056d               L012:
2194  056d 89            	pushw	x
2195  056e 1e06          	ldw	x,(OFST+4,sp)
2196  0570 e602          	ld	a,(2,x)
2197  0572 5f            	clrw	x
2198  0573 97            	ld	xl,a
2199  0574 58            	sllw	x
2200  0575 ee00          	ldw	x,(_USB_String_Descriptors,x)
2203  0577 2028          	jp	LC011
2204  0579               L5701:
2205                     ; 398 	USB_Send_STALL(0);
2209  0579 4f            	clr	a
2210  057a cd035b        	call	_USB_Send_STALL
2212  057d 2027          	jra	L3701
2213  057f               L5301:
2214                     ; 698 		case HID_DESCRIPTOR_REPORT: // handle HID class report descriptor
2214                     ; 699 			USB_Send_Data(HID_ReportDescriptor,MIN(wLength,SIZE_REPORT_DESCRIPTOR),0);
2216  057f 4b00          	push	#0
2217  0581 1e02          	ldw	x,(OFST+0,sp)
2218  0583 a3002c        	cpw	x,#44
2219  0586 2503          	jrult	L022
2220  0588 ae002b        	ldw	x,#43
2221  058b               L022:
2222  058b 89            	pushw	x
2223  058c ae0000        	ldw	x,#_HID_ReportDescriptor
2225                     ; 700 			break;
2227  058f 2010          	jp	LC011
2228  0591               L7301:
2229                     ; 702 		case HID_DESCRIPTOR:				// HID Descriptor
2229                     ; 703 			USB_Send_Data(USB_HID_descriptor,MIN(wLength,SIZE_HID_DESCRIPTOR),0);
2231  0591 4b00          	push	#0
2232  0593 1e02          	ldw	x,(OFST+0,sp)
2233  0595 a3000a        	cpw	x,#10
2234  0598 2503          	jrult	L622
2235  059a ae0009        	ldw	x,#9
2236  059d               L622:
2237  059d 89            	pushw	x
2238  059e ae0012        	ldw	x,#_usb_configuration_descriptor+18
2240  05a1               LC011:
2241  05a1 cd01f0        	call	_USB_Send_Data
2242  05a4 5b03          	addw	sp,#3
2243                     ; 704 			break;	
2245  05a6               L3701:
2246                     ; 711 }		
2249  05a6 5b04          	addw	sp,#4
2250  05a8 81            	ret	
2251  05a9               LC013:
2252  05a9 e602          	ld	a,(2,x)
2253  05ab 5f            	clrw	x
2254  05ac 97            	ld	xl,a
2255  05ad d60000        	ld	a,(_USB_String_Descriptors_Length,x)
2256  05b0 5f            	clrw	x
2257  05b1 97            	ld	xl,a
2258  05b2 81            	ret	
2305                     ; 713 void USB_loop(void)
2305                     ; 714 {
2306                     	switch	.text
2307  05b3               _USB_loop:
2309  05b3 89            	pushw	x
2310       00000002      OFST:	set	2
2313                     ; 715 	if (GPIOC->IDR&(USB_DP|USB_DM))
2315  05b4 c6500b        	ld	a,20491
2316  05b7 a5c0          	bcp	a,#192
2317  05b9 2705          	jreq	L3211
2318                     ; 716 		usb.reset_counter = 0;	
2320  05bb 5f            	clrw	x
2321  05bc bf55          	ldw	_usb+65,x
2323  05be 2010          	jra	L5211
2324  05c0               L3211:
2325                     ; 717 	else if (usb.reset_counter++ > USB_RESET_DELAY) 
2327  05c0 be55          	ldw	x,_usb+65
2328  05c2 5c            	incw	x
2329  05c3 bf55          	ldw	_usb+65,x
2330  05c5 5a            	decw	x
2331  05c6 a307d1        	cpw	x,#2001
2332  05c9 2505          	jrult	L5211
2333                     ; 719 		USB_Reset();
2335  05cb cd0000        	call	_USB_Reset
2337                     ; 720 		return;
2339  05ce 2068          	jra	L1511
2340  05d0               L5211:
2341                     ; 723 	if (usb.EP[0].rx_state == USB_EP_DATA_READY)
2343  05d0 b628          	ld	a,_usb+20
2344  05d2 4a            	dec	a
2345  05d3 2648          	jrne	L1311
2346                     ; 725 		if (usb.EP0_data_stage == USB_STAGE_SETUP) // EP0 Setup stage
2348  05d5 b61a          	ld	a,_usb+6
2349  05d7 4a            	dec	a
2350  05d8 262d          	jrne	L3311
2351                     ; 727 			t_USB_SetupReq *p_USB_SetupReq = (t_USB_SetupReq*)(usb.EP[0].rx_buffer);
2353                     ; 729 			if((p_USB_SetupReq->bmRequest & USB_REQ_TYPE_MASK)==USB_REQ_TYPE_STANDARD)
2355  05da b61b          	ld	a,_usb+7
2356  05dc a560          	bcp	a,#96
2357  05de 2616          	jrne	L5311
2358                     ; 731 				if(p_USB_SetupReq->bRequest==USB_REQ_GET_DESCRIPTOR)	// GET_DESCRIPTOR			
2360  05e0 b61c          	ld	a,_usb+8
2361  05e2 a106          	cp	a,#6
2362  05e4 2608          	jrne	L7311
2363                     ; 732 					USB_Handle_GetDescriptor(p_USB_SetupReq);
2365  05e6 ae001b        	ldw	x,#_usb+7
2366  05e9 cd050f        	call	_USB_Handle_GetDescriptor
2369  05ec 2015          	jra	L3411
2370  05ee               L7311:
2371                     ; 734 					USB_Handle_Standard_Request(p_USB_SetupReq);
2373  05ee ae001b        	ldw	x,#_usb+7
2374  05f1 cd04e7        	call	_USB_Handle_Standard_Request
2376  05f4 200d          	jra	L3411
2377  05f6               L5311:
2378                     ; 739 				if(USB_Setup_Request_callback(p_USB_SetupReq)<0)
2380  05f6 ae001b        	ldw	x,#_usb+7
2381  05f9 cd0000        	call	_USB_Setup_Request_callback
2383  05fc 4d            	tnz	a
2384  05fd 2a04          	jrpl	L3411
2385                     ; 398 	USB_Send_STALL(0);
2388  05ff 4f            	clr	a
2389  0600 cd035b        	call	_USB_Send_STALL
2391  0603               L3411:
2392                     ; 742 			usb.EP[0].rx_state = USB_EP_NO_DATA;	
2394  0603 3f28          	clr	_usb+20
2396  0605 2016          	jra	L1311
2397  0607               L3311:
2398                     ; 746 			USB_NRZI_RX_Decode(usb.EP[0].rx_buffer, usb.EP[0].rx_length);
2400  0607 3b0027        	push	_usb+19
2401  060a ae001b        	ldw	x,#_usb+7
2402  060d cd0378        	call	_USB_NRZI_RX_Decode
2404  0610 84            	pop	a
2405                     ; 747 			USB_EP0_RxReady_callback(usb.EP[0].rx_buffer, usb.EP[0].rx_length);
2407  0611 3b0027        	push	_usb+19
2408  0614 ae001b        	ldw	x,#_usb+7
2409  0617 cd0000        	call	_USB_EP0_RxReady_callback
2411  061a 3f28          	clr	_usb+20
2412  061c 84            	pop	a
2413                     ; 748 			usb.EP[0].rx_state = USB_EP_NO_DATA;
2415  061d               L1311:
2416                     ; 752 	if (usb.EP[1].rx_state == USB_EP_DATA_READY)
2418  061d b645          	ld	a,_usb+49
2419  061f 4a            	dec	a
2420  0620 2616          	jrne	L1511
2421                     ; 754 		USB_NRZI_RX_Decode(usb.EP[1].rx_buffer, usb.EP[1].rx_length);
2423  0622 3b0044        	push	_usb+48
2424  0625 ae0038        	ldw	x,#_usb+36
2425  0628 cd0378        	call	_USB_NRZI_RX_Decode
2427  062b 84            	pop	a
2428                     ; 755 		USB_EP1_RxReady_callback(usb.EP[1].rx_buffer, usb.EP[1].rx_length);
2430  062c 3b0044        	push	_usb+48
2431  062f ae0038        	ldw	x,#_usb+36
2432  0632 cd0000        	call	_USB_EP1_RxReady_callback
2434  0635 3f45          	clr	_usb+49
2435  0637 84            	pop	a
2436                     ; 756 		usb.EP[1].rx_state = USB_EP_NO_DATA;
2438  0638               L1511:
2439                     ; 758 }
2442  0638 85            	popw	x
2443  0639 81            	ret	
2473                     ; 760 void USB_slow_loop(void)
2473                     ; 761 {
2474                     	switch	.text
2475  063a               _USB_slow_loop:
2479                     ; 763 	if (usb.trimming_stage != HSI_TRIMMER_DISABLE)
2481  063a b65a          	ld	a,_usb+70
2482  063c a104          	cp	a,#4
2483  063e 275a          	jreq	L3611
2484                     ; 765 		if (usb.trimming_stage == HSI_TRIMMER_STARTED)
2486  0640 a101          	cp	a,#1
2487  0642 262a          	jrne	L5611
2488                     ; 767 			usb.delay_counter++;
2490  0644 be5b          	ldw	x,_usb+71
2491  0646 5c            	incw	x
2492  0647 bf5b          	ldw	_usb+71,x
2493                     ; 768 			if (usb.delay_counter == USB_CONNECT_TIMEOUT)
2495  0649 a302bc        	cpw	x,#700
2496  064c 264c          	jrne	L3611
2497                     ; 770 				usb.delay_counter = 0;
2499  064e 5f            	clrw	x
2500  064f bf5b          	ldw	_usb+71,x
2501                     ; 771 				usb.HSI_Trim_val++;
2503  0651 3c5d          	inc	_usb+73
2504                     ; 772 				usb.HSI_Trim_val &= 0x0F;
2506  0653 b65d          	ld	a,_usb+73
2507  0655 a40f          	and	a,#15
2508  0657 b75d          	ld	_usb+73,a
2509                     ; 773 				CLK->HSITRIMR = (uint8_t)((CLK->HSITRIMR & (~0x0F)) | usb.HSI_Trim_val);
2511  0659 c650cc        	ld	a,20684
2512  065c a4f0          	and	a,#240
2513  065e ba5d          	or	a,_usb+73
2514  0660 c750cc        	ld	20684,a
2515                     ; 774 				USB_disconnect();
2517  0663 cd006a        	call	_USB_disconnect
2519                     ; 775 				USB_Reset();
2521  0666 cd0000        	call	_USB_Reset
2523                     ; 776 				usb.trimming_stage = HSI_TRIMMER_RECONNECT_DELAY;
2525  0669 3502005a      	mov	_usb+70,#2
2527  066d 81            	ret	
2528  066e               L5611:
2529                     ; 779 		else if (usb.trimming_stage == HSI_TRIMMER_RECONNECT_DELAY)
2531  066e a102          	cp	a,#2
2532  0670 2612          	jrne	L3711
2533                     ; 781 			usb.delay_counter++;
2535  0672 be5b          	ldw	x,_usb+71
2536  0674 5c            	incw	x
2537  0675 bf5b          	ldw	_usb+71,x
2538                     ; 783 			if (usb.delay_counter == USB_RECONNECT_DELAY)
2540  0677 a30064        	cpw	x,#100
2541  067a 261e          	jrne	L3611
2542                     ; 785 				usb.delay_counter = 0;
2544  067c 5f            	clrw	x
2545  067d bf5b          	ldw	_usb+71,x
2546                     ; 786 				usb.trimming_stage = HSI_TRIMMER_ENABLE;
2548  067f 3f5a          	clr	_usb+70
2549                     ; 787 				USB_connect();
2553  0681 cc0065        	jp	_USB_connect
2554  0684               L3711:
2555                     ; 790 		else if (usb.trimming_stage == HSI_TRIMMER_WRITE_TRIM_VAL)
2557  0684 a103          	cp	a,#3
2558  0686 2612          	jrne	L3611
2559                     ; 792 			FLASH_Data_lock(0);
2561  0688 4f            	clr	a
2562  0689 cd0000        	call	_FLASH_Data_lock
2564                     ; 793 			*p_HSI_TRIM_VAL = usb.HSI_Trim_val;
2566  068c b65d          	ld	a,_usb+73
2567  068e 92c700        	ld	[_p_HSI_TRIM_VAL.w],a
2568                     ; 794 			*p_HSI_TRIMING_DONE = MAGIC_VAL;
2570  0691 a611          	ld	a,#17
2571  0693 92c702        	ld	[_p_HSI_TRIMING_DONE.w],a
2572                     ; 795 			usb.trimming_stage = HSI_TRIMMER_DISABLE;
2574  0696 3504005a      	mov	_usb+70,#4
2575  069a               L3611:
2576                     ; 817 }
2579  069a 81            	ret	
2914                     	xdef	_USB_Handle_GetDescriptor
2915                     	xdef	_USB_Handle_Standard_Request
2916                     	xdef	_USB_Device_Request
2917                     	xdef	_USB_NRZI_RX_Decode
2918                     	xdef	_USB_Send_STALL
2919                     	xdef	_usb_calc_crc16
2920                     	xdef	_usb_rx_ok
2921                     	xdef	_USB_Reset
2922                     	xref	_ll_usb_tx
2923                     	xdef	_p_HSI_TRIMING_DONE
2924                     	xdef	_p_HSI_TRIM_VAL
2925                     	switch	.ubsct
2926  0000               _ll_usb_rx_count:
2927  0000 00            	ds.b	1
2928                     	xdef	_ll_usb_rx_count
2929  0001               _ll_usb_tx_count:
2930  0001 00            	ds.b	1
2931                     	xdef	_ll_usb_tx_count
2932  0002               _ll_usb_tx_buffer_pointer:
2933  0002 0000          	ds.b	2
2934                     	xdef	_ll_usb_tx_buffer_pointer
2935  0004               _ll_usb_rx_buffer:
2936  0004 000000000000  	ds.b	16
2937                     	xdef	_ll_usb_rx_buffer
2938  0014               _usb:
2939  0014 000000000000  	ds.b	74
2940                     	xdef	_usb
2941                     	xref	_USB_Class_DeInit_callback
2942                     	xref	_USB_Class_Init_callback
2943                     	xref	_USB_Setup_Request_callback
2944                     	xref	_USB_EP1_RxReady_callback
2945                     	xref	_USB_EP0_RxReady_callback
2946                     	xdef	_USB_Send_Data
2947                     	xdef	_USB_slow_loop
2948                     	xdef	_USB_disconnect
2949                     	xdef	_USB_connect
2950                     	xdef	_USB_loop
2951                     	xdef	_USB_Init
2952                     	xref	_HID_ReportDescriptor
2953                     	xref	_USB_String_Descriptors_Length
2954                     	xref.b	_USB_String_Descriptors
2955                     	xref	_usb_configuration_descriptor
2956                     	xref	_usb_device_descriptor
2957                     	xref	_FLASH_Data_lock
2958                     	xref.b	c_y
2978                     	end
