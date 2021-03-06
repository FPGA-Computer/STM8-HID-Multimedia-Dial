.utext: section
	xref	_ll_usb_rx_count, _ll_usb_rx_buffer, _usb_rx_ok
	xdef	_ll_usb_rx
;;; 16 MHz ;;;
switch .utext
debug_cpl: macro
	cpl		($14,y)					; DEBUG; sync signal; invert (& GPIOC-> IDR + 20) = GPIOG-> ODR
	;cpl		20495		; DEBUG; GPIOD-> ODR input signal inputs
endm

	;nop ;; BOUNDING
	;nop ;; BOUNDING
	;nop ;; BOUNDING
	
L_Bit0_Begin:
	debug_cpl			; DEBUG ;
	srl		($01, SP)				; RX_BYTE >>= 1
	ld		a,(y)						; a = IDR
	and		a,#$C0					; a &= 0b11000000
	jreq	L_End_Rx				; output, if input = 0 (end of packet)
	xor		a, ($01, SP)		; a = a XOR RX_BYTE
	ld		($01, SP),a			; RX_BYTE = a
	nop
	nop
	nop
	
L_Bit1_Begin:
	debug_cpl			; DEBUG ;
	srl		($01, SP)
	ld		a,(y)
	and		a,#$C0					; a &= 0b11000000
	jreq	L_End_Rx				; output, if input = 0 (end of packet)
	xor		a, ($01, SP)
	ld		($01, SP),a
	nop
	nop
	incw	x								; _ll_usb_rx_buffer++

L_Bit2_Begin:
	debug_cpl			; DEBUG ;
	srl		($01, SP)
	ld		a,(y)
	and		a,#$C0					; a &= 0b11000000
	jreq	L_End_Rx				; output, if input = 0 (end of package)
	xor		a, ($01, SP)
	ld		($01, SP),a
	nop
	nop
	nop
	nop

L_Bit3_Begin:
	debug_cpl			; DEBUG ;
	srl		($01, SP)
	ld		a,(y)
	and		a,#$C0					; a &= 0b11000000
	jreq	L_End_Rx				; output, if input = 0 (end of package)
	xor		a, ($01, SP)
	ld		($01, SP),a
	nop
	nop
	nop	

L_Bit4_Begin:
	debug_cpl			; DEBUG ;
	srl		($01, SP)
	ld		a,(y)
	and		a,#$C0					; a &= 0b11000000
	jreq	L_End_Rx				; output, if input = 0 (end of package)
	xor		a, ($01, SP)
	ld		($01, SP),a
	nop
	nop
	nop
	nop	

L_Bit5_Begin:
	debug_cpl			; DEBUG ;
	srl		($01, SP)
	ld		a,(y)
	and		a,#$C0					; a &= 0b11000000
	jreq	L_End_Rx				; output, if input = 0 (end of package)
	xor		a, ($01, SP)
	ld		($01, SP),a
	dec		($02,SP) 				; Detector for counting the number of bytes
	jreq	L_End_Rx 				; output, if input = 0 (end of package)
	nop	

L_Bit6_Begin:
	debug_cpl			; DEBUG ;
	srl		($01, SP)
	ld		a,(y)
	and		a,#$C0					; a &= 0b11000000
	jreq	L_End_Rx				; output, if input = 0 (end of package)
	xor		a, ($01, SP)
	ld		($01, SP),a
	nop
	nop
	nop
	nop	

L_Bit7_Begin:
	debug_cpl			; DEBUG ;
	srl		($01, SP)
	ld		a,(y)
	and		a,#$C0					; a &= 0b11000000
	jreq	L_End_Rx				; output, if input = 0 (end of package)
	xor		a, ($01, SP)
	ld		($01, SP),a
	ld		(x),a					;; save the private store; _ll_usb_rx_buffer [] = a
	rlc   (x)						;; rotate x
	nop	

	;; BIT 0
	debug_cpl			; DEBUG ;
	srl		($01, SP)
	ld		a,(y)
	and		a,#$C0					; a &= 0b11000000
	jreq	L_End_Rx				; output, if input = 0 (end of package)
	xor		a, ($01, SP)
	ld		($01, SP),a
	nop	
	jra		L_Bit1_Begin

	nop
	nop
	nop

L_End_Rx:

	;debug_cpl			; DEBUG ;
	pop		a
	pop		a
	ld		_ll_usb_rx_count,a

	call	_usb_rx_ok

	mov		21077,#251 			; Resetting the timer flag; TIM1_BaseAddress + SR1 = 0xFB

	bres	21072,#0				; stop time; TIM1_BaseAddress + CR1 & = 0x2
	clr		21086					; Resetting the counting register; TIM1_BaseAddress + CNTRH = 0
	clr		21087					; TIM1_BaseAddress + CNTRL = 0
	
	;clr		20495		; DEBUG ; Resetting the GPIOD-> ODR output signals
	
	iret

;
;
;

_ll_usb_rx:
	ldw		x, #L_Delay_Begin	; start of delays table
	addw	x, 21086			; + measurement (time value); x + = TIM1_BaseAddress + CNTRH * 256 + CNTRL
	cpw		x, #L_Delay_End		; checking the output for the limit of the table (safety!); check x <L_Delay_End
	jruge	L_Error						; Jump if C = 0
	jp		(x)					; Delay setting pass
	
L_Error:

	iret ; Normal EXIT

L_Delay_Begin:
	nop		; 0
	nop		; 1
	nop		; 2
	nop		; 3
	nop		; 4
	nop		; 5
	nop		; 6
	nop		; 7
	nop		; 8
	nop		; 9
	nop		; 10
	nop		; 11
	nop		; 12
	nop		; 13
	nop		; 14
	nop		; 15
	nop		; 16
	nop		; 17
	nop		; 18
	nop		; 19
	nop		; 20
	nop		; 21
	nop		; 22
	nop		; 23
	nop		; 24
	nop		; 25
	nop		; 26
	nop		; 27
	nop		; 28
	nop		; 29
	nop		; 30
	nop		; 31
	nop		; 32
	nop		; 33
	nop		; 34
	nop		; 35
	nop		; 36
	nop		; 37
	nop		; 38
	nop		; 39
	nop		; 40
	nop		; 41
	nop		; 42
	nop		; 43
	nop		; 44
	nop		; 45
	nop		; 46
	nop		; 47
	nop		; 48
	nop		; 49 ;; MIN
	nop		; 50
	;nop		; 51 
	;nop		; 52 ;; MAX
	;nop		; 53
	;nop		; 54
	;nop		; 55 

L_Delay_End:
         
	ldw		x, #_ll_usb_rx_buffer		; adds the beginning of a buffer; x = _ll_usb_rx_buffer
	ldw		y, #20491 				; input signal card; y = & GPIOC-> IDR
	ld		a, #$0E					; the maximum amount of bits a = 14 (safe!)
	push	a								; a -> stack	
	ld		a, #$80					; a = 128; RX_BYTE = 0b10000000
	push	a								; a -> stack
	
	jra		L_Bit0_Begin		; jump
	
switch .text
