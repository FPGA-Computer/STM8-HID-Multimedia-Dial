   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.13 - 05 Feb 2019
   3                     ; Generator (Limited) V4.4.10 - 25 Sep 2019
   4                     ; Optimizer V4.4.10 - 25 Sep 2019
  61                     ; 10 void USB_EP0_RxReady_callback(uint8_t *p_data, uint8_t length)
  61                     ; 11 {
  63                     	switch	.text
  64  0000               _USB_EP0_RxReady_callback:
  68                     ; 12 }
  71  0000 81            	ret	
 106                     ; 18 int8_t USB_Class_Init_callback(uint8_t dev_config)
 106                     ; 19 {
 107                     	switch	.text
 108  0001               _USB_Class_Init_callback:
 112                     ; 20 	return 0;
 114  0001 4f            	clr	a
 117  0002 81            	ret	
 141                     ; 27 int8_t USB_Class_DeInit_callback(void)
 141                     ; 28 {
 142                     	switch	.text
 143  0003               _USB_Class_DeInit_callback:
 147                     ; 29 	return 0;
 149  0003 4f            	clr	a
 152  0004 81            	ret	
 254                     ; 37 int8_t USB_Setup_Request_callback(t_USB_SetupReq *p_req)
 254                     ; 38 {	
 255                     	switch	.text
 256  0005               _USB_Setup_Request_callback:
 260                     ; 40   if (((p_req->bmRequest&USB_REQ_TYPE_MASK)==USB_REQ_TYPE_CLASS) && 
 260                     ; 41 			(p_req->bRequest==HID_REQ_GET_REPORT))
 262  0005 f6            	ld	a,(x)
 263  0006 a460          	and	a,#96
 264  0008 a120          	cp	a,#32
 265  000a 2610          	jrne	L121
 267  000c e601          	ld	a,(1,x)
 268  000e 4a            	dec	a
 269  000f 260b          	jrne	L121
 270                     ; 43 		USB_Send_Data(NULL,0,0); 
 272  0011 4b00          	push	#0
 273  0013 5f            	clrw	x
 274  0014 89            	pushw	x
 275  0015 cd0000        	call	_USB_Send_Data
 277  0018 5b03          	addw	sp,#3
 278                     ; 44 		return 0;
 280  001a 4f            	clr	a
 283  001b 81            	ret	
 284  001c               L121:
 285                     ; 47 	return -1;
 287  001c a6ff          	ld	a,#255
 290  001e 81            	ret	
 326                     ; 54 void USB_EP1_RxReady_callback(uint8_t *p_data, uint8_t length)
 326                     ; 55 {
 327                     	switch	.text
 328  001f               _USB_EP1_RxReady_callback:
 332                     ; 57 }
 335  001f 81            	ret	
 375                     ; 61 void main(void)
 375                     ; 62 {
 376                     	switch	.text
 377  0020               _main:
 379  0020 88            	push	a
 380       00000001      OFST:	set	1
 383                     ; 63 	uint8_t counter = TIM4_CNTMAX;
 385  0021 a605          	ld	a,#5
 386  0023 6b01          	ld	(OFST+0,sp),a
 388                     ; 65 	Init_Hardware();
 390  0025 cd0000        	call	_Init_Hardware
 392  0028               L751:
 393                     ; 69 		USB_loop(); // A "quick" USB loop for processing requests
 395  0028 cd0000        	call	_USB_loop
 397                     ; 70 		HID_Task();
 399  002b cd0000        	call	_HID_Task
 401                     ; 72 		if (TIM4->SR1 && TIM4_SR1_UIF)	// poll for TIM4 update
 403  002e 725d5344      	tnz	21316
 404  0032 27f4          	jreq	L751
 405                     ; 75 			TIM4->SR1 = (uint8_t) ~TIM4_SR1_UIF;
 407  0034 35fe5344      	mov	21316,#254
 408                     ; 77 			if (counter)
 410  0038 7b01          	ld	a,(OFST+0,sp)
 411  003a 270c          	jreq	L561
 412                     ; 79 				counter--;
 414  003c 0a01          	dec	(OFST+0,sp)
 416                     ; 81 				if(!counter)
 418  003e 26e8          	jrne	L751
 419                     ; 84 					Encoder_Task();				
 421  0040 cd0000        	call	_Encoder_Task
 423                     ; 85 					Encoder_Switch_Task();
 425  0043 cd0000        	call	_Encoder_Switch_Task
 427  0046 20e0          	jra	L751
 428  0048               L561:
 429                     ; 90 				USB_slow_loop(); // "slow" USB loop for setting HSI generator and EP1 watchdog
 431  0048 cd0000        	call	_USB_slow_loop
 433                     ; 91 				counter = TIM4_CNTMAX;		
 435  004b a605          	ld	a,#5
 436  004d 6b01          	ld	(OFST+0,sp),a
 438  004f 20d7          	jra	L751
 451                     	xdef	_main
 452                     	xdef	_USB_Class_DeInit_callback
 453                     	xdef	_USB_Class_Init_callback
 454                     	xdef	_USB_Setup_Request_callback
 455                     	xdef	_USB_EP1_RxReady_callback
 456                     	xdef	_USB_EP0_RxReady_callback
 457                     	xref	_USB_Send_Data
 458                     	xref	_USB_slow_loop
 459                     	xref	_USB_loop
 460                     	xref	_HID_Task
 461                     	xref	_Encoder_Task
 462                     	xref	_Encoder_Switch_Task
 463                     	xref	_Init_Hardware
 482                     	end
