   1                     	xref	_ll_usb_tx_count, _ll_usb_tx_buffer_pointer
   2                     	xdef	_ll_usb_tx
   3                     	
   4                     ;;; 16 MHz ;;;
   5                     
   6  0000               L_Bit0_Idle:
   7  0000 4a            	dec		a		; a--
   8  0001 2647          	jrne	L_Bit1_Begin	; Jump if Z == 0; if a != 0
   9  0003 9d            	nop
  10  0004 9d            	nop
  11  0005 9d            	nop
  12  0006 9d            	nop	
  13  0007 7253500a      	cpl		20490				; GPIOC + ODR; input signals; add bit
  14  000b a606          	ld		a, #$06			; Resetting the counter
  15  000d 9d            	nop
  16  000e 203a          	jra		L_Bit1_Begin
  17                     
  18  0010               L_Bit1_Idle:
  19  0010 4a            	dec		a
  20  0011 2646          	jrne	L_Bit2_Begin
  21  0013 9d            	nop
  22  0014 9d            	nop
  23  0015 9d            	nop
  24  0016 9d            	nop	
  25  0017 7253500a      	cpl		20490				; GPIOC + ODR; input signals [N, Z, C = 1]
  26  001b a606          	ld		a, #$06
  27  001d 9d            	nop
  28  001e 2039          	jra		L_Bit2_Begin
  29                     
  30  0020               L_Bit2_Idle:
  31  0020 4a            	dec		a
  32  0021 2645          	jrne	L_Bit3_Begin
  33  0023 9d            	nop
  34  0024 9d            	nop
  35  0025 9d            	nop
  36  0026 9d            	nop	
  37  0027 7253500a      	cpl		20490				; GPIOC + ODR; input signals [N, Z, C = 1]
  38  002b a606          	ld		a, #$06
  39  002d 9d            	nop
  40  002e 2038          	jra		L_Bit3_Begin
  41                     
  42  0030               L_Bit3_Idle:
  43  0030 4a            	dec		a
  44  0031 2644          	jrne	L_Bit4_Begin
  45  0033 9d            	nop
  46  0034 9d            	nop
  47  0035 9d            	nop
  48  0036 9d            	nop	
  49  0037 7253500a      	cpl		20490				; GPIOC + ODR; input signals [N, Z, C = 1]
  50  003b a606          	ld		a, #$06
  51  003d 9d            	nop
  52  003e 2037          	jra		L_Bit4_Begin
  53                     
  54                     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  55                     
  56  0040               L_Bit0_Begin:
  57                     	;;nop
  58                     	;;nop
  59                     	;;nop
  60                     	;;nop
  61                     	;;nop
  62  0040 76            	rrc		(x)						; bit 0 -> C, rotate right
  63  0041 25bd          	jrc		L_Bit0_Idle		; Branch if carry (C=1)
  64  0043 7253500a      	cpl		20490					; GPIOC + ODR; input signals [N, Z, C = 1]
  65  0047 a606          	ld		a, #$06				; if we got the investment, we will collect; a = 6
  66  0049 9d            	nop
  67                     
  68  004a               L_Bit1_Begin:
  69  004a 9d            	nop
  70  004b 9d            	nop
  71  004c 9d            	nop
  72  004d 9d            	nop
  73  004e 9d            	nop
  74  004f 76            	rrc		(x)						; bit 0 -> C
  75  0050 25be          	jrc		L_Bit1_Idle		; Branch if carry (C=1)
  76  0052 7253500a      	cpl		20490					; GPIOC + ODR; input signals [N, Z, C = 1]
  77  0056 a606          	ld		a, #$06       
  78  0058 9d            	nop
  79                     
  80  0059               L_Bit2_Begin:
  81  0059 9d            	nop
  82  005a 9d            	nop
  83  005b 9d            	nop
  84  005c 9d            	nop
  85  005d 9d            	nop
  86  005e 76            	rrc		(x)						; bit 0 -> C
  87  005f 25bf          	jrc		L_Bit2_Idle		; Branch if carry (C=1)
  88  0061 7253500a      	cpl		20490					; GPIOC + ODR; input signals [N, Z, C = 1]
  89  0065 a606          	ld		a, #$06       
  90  0067 9d            	nop
  91                     
  92  0068               L_Bit3_Begin:
  93  0068 9d            	nop
  94  0069 9d            	nop
  95  006a 9d            	nop
  96  006b 9d            	nop
  97  006c 9d            	nop
  98  006d 76            	rrc		(x)						; bit 0 -> C
  99  006e 25c0          	jrc		L_Bit3_Idle		; Branch if carry (C=1)
 100  0070 7253500a      	cpl		20490					; GPIOC + ODR; input signals [N, Z, C = 1]
 101  0074 a606          	ld		a, #$06       
 102  0076 9d            	nop
 103                     
 104  0077               L_Bit4_Begin:
 105  0077 9d            	nop
 106  0078 9d            	nop
 107  0079 9d            	nop
 108  007a 9d            	nop
 109  007b 9d            	nop
 110  007c 76            	rrc		(x)						; bit 0 -> C
 111  007d 2552          	jrc		L_Bit4_Idle		; Branch if carry (C=1)
 112  007f 7253500a      	cpl		20490					; GPIOC + ODR; input signals [N, Z, C = 1]
 113  0083 a606          	ld		a, #$06       
 114  0085 9d            	nop
 115                     
 116  0086               L_Bit5_Begin:
 117  0086 9d            	nop
 118  0087 9d            	nop
 119  0088 9d            	nop
 120  0089 9d            	nop
 121  008a 9d            	nop
 122  008b 76            	rrc		(x)						; bit 0 -> C
 123  008c 2553          	jrc		L_Bit5_Idle		; Branch if carry (C=1)
 124  008e 7253500a      	cpl		20490					; GPIOC + ODR; input signals [N, Z, C = 1]
 125  0092 a606          	ld		a, #$06       
 126  0094 9d            	nop
 127                     
 128  0095               L_Bit6_Begin:
 129  0095 9d            	nop
 130  0096 9d            	nop
 131  0097 9d            	nop
 132  0098 9d            	nop
 133  0099 9d            	nop
 134  009a 76            	rrc		(x)						; bit 0 -> C
 135  009b 2554          	jrc		L_Bit6_Idle		; Branch if carry (C=1)
 136  009d 7253500a      	cpl		20490					; GPIOC + ODR; input signals [N, Z, C = 1]
 137  00a1 a606          	ld		a, #$06       
 138  00a3 9d            	nop
 139                     
 140  00a4               L_Bit7_Begin:
 141  00a4 9d            	nop
 142  00a5 9d            	nop
 143  00a6 9d            	nop
 144  00a7 9d            	nop
 145  00a8 9d            	nop
 146  00a9 76            	rrc		(x)						; bit 0 -> C
 147  00aa 2555          	jrc		L_Bit7_Idle		; Branch if carry (C=1)
 148  00ac 7253500a      	cpl		20490					; GPIOC + ODR; input signals [N, Z, C = 1]
 149  00b0 a606          	ld		a, #$06
 150  00b2 9d            	nop
 151  00b3 9d            	nop	
 152                     
 153  00b4               L_Check_End:
 154                     
 155  00b4 5c            	incw	x
 156  00b5 725a0000      	dec		_ll_usb_tx_count
 157  00b9 2685          	jrne	L_Bit0_Begin
 158  00bb 9d            	nop
 159                     	
 160  00bc               L_Tx_End:
 161                     	;;nop                
 162  00bc 9d            	nop
 163  00bd 9d            	nop
 164                     	
 165  00be 725f500a      	clr		20490			 		; Resetting the output signals
 166                     
 167  00c2 9d            	nop
 168  00c3 9d            	nop
 169  00c4 9d            	nop
 170  00c5 9d            	nop
 171                     
 172  00c6 9d            	nop	;
 173  00c7 9d            	nop	;
 174  00c8 9d            	nop	;
 175  00c9 9d            	nop	;
 176  00ca 9d            	nop	;
 177                     	
 178  00cb 81            	ret
 179                     
 180  00cc 9d            	nop
 181  00cd 9d            	nop
 182  00ce 9d            	nop
 183  00cf 9d            	nop
 184                     
 185                     ;
 186                     ;
 187                     ;
 188  00d0 9d            	nop
 189                     
 190  00d1               L_Bit4_Idle:
 191  00d1 4a            	dec		a
 192  00d2 26b2          	jrne	L_Bit5_Begin
 193  00d4 9d            	nop
 194  00d5 9d            	nop
 195  00d6 9d            	nop
 196  00d7 9d            	nop	
 197  00d8 7253500a      	cpl		20490		 ; GPIOC + ODR; input signals [N, Z, C = 1]
 198  00dc a606          	ld		a, #$06
 199  00de 9d            	nop
 200  00df 20a5          	jra		L_Bit5_Begin
 201                     
 202  00e1               L_Bit5_Idle:
 203  00e1 4a            	dec		a
 204  00e2 26b1          	jrne	L_Bit6_Begin
 205  00e4 9d            	nop
 206  00e5 9d            	nop
 207  00e6 9d            	nop
 208  00e7 9d            	nop
 209  00e8 7253500a      	cpl		20490		; input signal inputs [N, Z, C = 1]
 210  00ec a606          	ld		a, #$06
 211  00ee 9d            	nop
 212  00ef 20a4          	jra		L_Bit6_Begin
 213                     
 214  00f1               L_Bit6_Idle:
 215  00f1 4a            	dec		a
 216  00f2 26b0          	jrne	L_Bit7_Begin
 217  00f4 9d            	nop
 218  00f5 9d            	nop
 219  00f6 9d            	nop
 220  00f7 9d            	nop
 221  00f8 7253500a      	cpl		20490		; GPIOC + ODR; input signals [N, Z, C = 1]
 222  00fc a606          	ld		a, #$06
 223  00fe 9d            	nop
 224  00ff 20a3          	jra		L_Bit7_Begin
 225                     
 226  0101               L_Bit7_Idle:
 227  0101 4a            	dec		a
 228  0102 26b0          	jrne	L_Check_End
 229  0104 9d            	nop
 230  0105 9d            	nop
 231  0106 725a0000      	dec		_ll_usb_tx_count
 232  010a 5c            	incw	x
 233  010b a606          	ld		a, #$06
 234  010d 7253500a      	cpl		20490		; GPIOC + ODR; input signals [N, Z, C = 1]
 235  0111 725d0000      	tnz		_ll_usb_tx_count
 236  0115 2704ac400040  	jrne	L_Bit0_Begin
 237                     	
 238                     	;;cpl		20490		; GPIOC + ODR; input signals [N, Z, C = 1]
 239                     	;;ld		a, #$06
 240                     	;;incw	x
 241                     	;;dec		_ll_usb_tx_count
 242                     	;;jrne	L_Bit0_Begin
 243  011b 209f          	jra		L_Tx_End
 244                     
 245                     ;
 246                     ;	Entry point
 247                     ;
 248  011d               _ll_usb_tx:
 249                     
 250                     	; consolidate common GPIO code here
 251                     	
 252                     	;GPIOC->ODR |= USB_DM; 									// set PC6
 253  011d 721c500a      	BSET  0x500a,#6
 254                     
 255                     	;GPIOC->CR1 |= USB_DP|USB_DM;
 256  0121 c6500d        	LD    A,0x500d
 257  0124 aac0          	OR    A,#0xc0
 258  0126 c7500d        	LD    0x500d,A
 259                     	;GPIOC->CR2 |= USB_DP|USB_DM; 						// PC6, PC7 - 10 MHz mode (external INTR enable)	
 260  0129 c6500e        	LD    A,0x500e
 261  012c aac0          	OR    A,#0xc0
 262  012e c7500e        	LD    0x500e,A
 263                     	;	GPIOC->DDR |= USB_DP|USB_DM; 						// PC6, PC7 - output mode
 264  0131 c6500c        	LD    A,0x500c 
 265  0134 aac0          	OR    A,#0xc0 
 266  0136 c7500c        	LD    0x500c,A 
 267                     	
 268  0139 ce0000        	ldw		x, _ll_usb_tx_buffer_pointer
 269                     	
 270  013c a640          	ld		a,#$40						; a = 0x40 (bit 6)
 271  013e c7500a        	ld		20490,a						; GPIOC->ODR = a (set bit 6)
 272  0141 a606          	ld		a, #$06						; counter constant
 273                     
 274                     ; Don't want to patch the exit point of Tx code and change the alignment 
 275                     	;jra		L_Bit0_Begin
 276  0143 cd0040        	call	L_Bit0_Begin
 277                     	
 278                     	; move common GPIO code here
 279                     	;GPIOC->CR2 &= (uint8_t)~(USB_DP|USB_DM);// PC6, PC7 - disable external INTR (2 MHz)
 280  0146 c6500e        	LD    A,0x500e
 281  0149 a43f          	AND   A,#0x3f
 282  014b c7500e        	LD    0x500e,A
 283                     	;GPIOC->CR1 &= (uint8_t)~(USB_DP|USB_DM);// PC6, PC7 - disable PU (PP) mode
 284  014e c6500d        	LD    A,0x500d
 285  0151 a43f          	AND   A,#0x3f
 286  0153 c7500d        	LD    0x500d,A
 287                     	;GPIOC->DDR = 0; 												// PC0..PC7 - input mode
 288  0156 725f500c      	CLR   0x500c
 289  015a 81            	ret
