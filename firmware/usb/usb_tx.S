	xref	_ll_usb_tx_count, _ll_usb_tx_buffer_pointer
	xdef	_ll_usb_tx
	
;;; 16 MHz ;;;

L_Bit0_Idle:
	dec		a		; a--
	jrne	L_Bit1_Begin	; Jump if Z == 0; if a != 0
	nop
	nop
	nop
	nop	
	cpl		20490				; GPIOC + ODR; input signals; add bit
	ld		a, #$06			; Resetting the counter
	nop
	jra		L_Bit1_Begin

L_Bit1_Idle:
	dec		a
	jrne	L_Bit2_Begin
	nop
	nop
	nop
	nop	
	cpl		20490				; GPIOC + ODR; input signals [N, Z, C = 1]
	ld		a, #$06
	nop
	jra		L_Bit2_Begin

L_Bit2_Idle:
	dec		a
	jrne	L_Bit3_Begin
	nop
	nop
	nop
	nop	
	cpl		20490				; GPIOC + ODR; input signals [N, Z, C = 1]
	ld		a, #$06
	nop
	jra		L_Bit3_Begin

L_Bit3_Idle:
	dec		a
	jrne	L_Bit4_Begin
	nop
	nop
	nop
	nop	
	cpl		20490				; GPIOC + ODR; input signals [N, Z, C = 1]
	ld		a, #$06
	nop
	jra		L_Bit4_Begin

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

L_Bit0_Begin:
	;;nop
	;;nop
	;;nop
	;;nop
	;;nop
	rrc		(x)						; bit 0 -> C, rotate right
	jrc		L_Bit0_Idle		; Branch if carry (C=1)
	cpl		20490					; GPIOC + ODR; input signals [N, Z, C = 1]
	ld		a, #$06				; if we got the investment, we will collect; a = 6
	nop

L_Bit1_Begin:
	nop
	nop
	nop
	nop
	nop
	rrc		(x)						; bit 0 -> C
	jrc		L_Bit1_Idle		; Branch if carry (C=1)
	cpl		20490					; GPIOC + ODR; input signals [N, Z, C = 1]
	ld		a, #$06       
	nop

L_Bit2_Begin:
	nop
	nop
	nop
	nop
	nop
	rrc		(x)						; bit 0 -> C
	jrc		L_Bit2_Idle		; Branch if carry (C=1)
	cpl		20490					; GPIOC + ODR; input signals [N, Z, C = 1]
	ld		a, #$06       
	nop

L_Bit3_Begin:
	nop
	nop
	nop
	nop
	nop
	rrc		(x)						; bit 0 -> C
	jrc		L_Bit3_Idle		; Branch if carry (C=1)
	cpl		20490					; GPIOC + ODR; input signals [N, Z, C = 1]
	ld		a, #$06       
	nop

L_Bit4_Begin:
	nop
	nop
	nop
	nop
	nop
	rrc		(x)						; bit 0 -> C
	jrc		L_Bit4_Idle		; Branch if carry (C=1)
	cpl		20490					; GPIOC + ODR; input signals [N, Z, C = 1]
	ld		a, #$06       
	nop

L_Bit5_Begin:
	nop
	nop
	nop
	nop
	nop
	rrc		(x)						; bit 0 -> C
	jrc		L_Bit5_Idle		; Branch if carry (C=1)
	cpl		20490					; GPIOC + ODR; input signals [N, Z, C = 1]
	ld		a, #$06       
	nop

L_Bit6_Begin:
	nop
	nop
	nop
	nop
	nop
	rrc		(x)						; bit 0 -> C
	jrc		L_Bit6_Idle		; Branch if carry (C=1)
	cpl		20490					; GPIOC + ODR; input signals [N, Z, C = 1]
	ld		a, #$06       
	nop

L_Bit7_Begin:
	nop
	nop
	nop
	nop
	nop
	rrc		(x)						; bit 0 -> C
	jrc		L_Bit7_Idle		; Branch if carry (C=1)
	cpl		20490					; GPIOC + ODR; input signals [N, Z, C = 1]
	ld		a, #$06
	nop
	nop	

L_Check_End:

	incw	x
	dec		_ll_usb_tx_count
	jrne	L_Bit0_Begin
	nop
	
L_Tx_End:
	;;nop                
	nop
	nop
	
	clr		20490			 		; Resetting the output signals

	nop
	nop
	nop
	nop

	nop	;
	nop	;
	nop	;
	nop	;
	nop	;
	
	ret

	nop
	nop
	nop
	nop

;
;
;
	nop

L_Bit4_Idle:
	dec		a
	jrne	L_Bit5_Begin
	nop
	nop
	nop
	nop	
	cpl		20490		 ; GPIOC + ODR; input signals [N, Z, C = 1]
	ld		a, #$06
	nop
	jra		L_Bit5_Begin

L_Bit5_Idle:
	dec		a
	jrne	L_Bit6_Begin
	nop
	nop
	nop
	nop
	cpl		20490		; input signal inputs [N, Z, C = 1]
	ld		a, #$06
	nop
	jra		L_Bit6_Begin

L_Bit6_Idle:
	dec		a
	jrne	L_Bit7_Begin
	nop
	nop
	nop
	nop
	cpl		20490		; GPIOC + ODR; input signals [N, Z, C = 1]
	ld		a, #$06
	nop
	jra		L_Bit7_Begin

L_Bit7_Idle:
	dec		a
	jrne	L_Check_End
	nop
	nop
	dec		_ll_usb_tx_count
	incw	x
	ld		a, #$06
	cpl		20490		; GPIOC + ODR; input signals [N, Z, C = 1]
	tnz		_ll_usb_tx_count
	jrne	L_Bit0_Begin
	
	;;cpl		20490		; GPIOC + ODR; input signals [N, Z, C = 1]
	;;ld		a, #$06
	;;incw	x
	;;dec		_ll_usb_tx_count
	;;jrne	L_Bit0_Begin
	jra		L_Tx_End

;
;	Entry point
;
_ll_usb_tx:

	; consolidate common GPIO code here
	
	;GPIOC->ODR |= USB_DM; 									// set PC6
	BSET  0x500a,#6

	;GPIOC->CR1 |= USB_DP|USB_DM;
	LD    A,0x500d
	OR    A,#0xc0
	LD    0x500d,A
	;GPIOC->CR2 |= USB_DP|USB_DM; 						// PC6, PC7 - 10 MHz mode (external INTR enable)	
	LD    A,0x500e
	OR    A,#0xc0
	LD    0x500e,A
	;	GPIOC->DDR |= USB_DP|USB_DM; 						// PC6, PC7 - output mode
	LD    A,0x500c 
	OR    A,#0xc0 
	LD    0x500c,A 
	
	ldw		x, _ll_usb_tx_buffer_pointer
	
	ld		a,#$40						; a = 0x40 (bit 6)
	ld		20490,a						; GPIOC->ODR = a (set bit 6)
	ld		a, #$06						; counter constant

; Don't want to patch the exit point of Tx code and change the alignment 
	;jra		L_Bit0_Begin
	call	L_Bit0_Begin
	
	; move common GPIO code here
	;GPIOC->CR2 &= (uint8_t)~(USB_DP|USB_DM);// PC6, PC7 - disable external INTR (2 MHz)
	LD    A,0x500e
	AND   A,#0x3f
	LD    0x500e,A
	;GPIOC->CR1 &= (uint8_t)~(USB_DP|USB_DM);// PC6, PC7 - disable PU (PP) mode
	LD    A,0x500d
	AND   A,#0x3f
	LD    0x500d,A
	;GPIOC->DDR = 0; 												// PC0..PC7 - input mode
	CLR   0x500c
	ret
