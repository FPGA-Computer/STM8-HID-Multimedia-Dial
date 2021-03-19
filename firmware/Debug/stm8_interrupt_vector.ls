   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.13 - 05 Feb 2019
   3                     ; Generator (Limited) V4.4.10 - 25 Sep 2019
   4                     ; Optimizer V4.4.10 - 25 Sep 2019
  50                     ; 34 @far @interrupt void Default_IRQ_Handler(void)
  50                     ; 35 {
  51                     	switch	.text
  52  0000               f_Default_IRQ_Handler:
  56                     ; 36 }
  59  0000 80            	iret	
  61                     .const:	section	.text
  62  0000               __vectab:
  63  0000 82            	dc.b	130
  65  0001 00            	dc.b	page(__stext)
  66  0002 0000          	dc.w	__stext
  67  0004 82            	dc.b	130
  69  0005 00            	dc.b	page(f_Default_IRQ_Handler)
  70  0006 0000          	dc.w	f_Default_IRQ_Handler
  71  0008 82            	dc.b	130
  73  0009 00            	dc.b	page(f_Default_IRQ_Handler)
  74  000a 0000          	dc.w	f_Default_IRQ_Handler
  75  000c 82            	dc.b	130
  77  000d 00            	dc.b	page(f_Default_IRQ_Handler)
  78  000e 0000          	dc.w	f_Default_IRQ_Handler
  79  0010 82            	dc.b	130
  81  0011 00            	dc.b	page(f_Default_IRQ_Handler)
  82  0012 0000          	dc.w	f_Default_IRQ_Handler
  83  0014 82            	dc.b	130
  85  0015 00            	dc.b	page(f_Default_IRQ_Handler)
  86  0016 0000          	dc.w	f_Default_IRQ_Handler
  87  0018 82            	dc.b	130
  89  0019 00            	dc.b	page(f_Encoder_IRQ)
  90  001a 0000          	dc.w	f_Encoder_IRQ
  91  001c 82            	dc.b	130
  93  001d 00            	dc.b	page(f_Encoder_IRQ)
  94  001e 0000          	dc.w	f_Encoder_IRQ
  95  0020 82            	dc.b	130
  97  0021 00            	dc.b	page(f_Encoder_IRQ)
  98  0022 0000          	dc.w	f_Encoder_IRQ
  99  0024 82            	dc.b	130
 101  0025 00            	dc.b	page(f_Default_IRQ_Handler)
 102  0026 0000          	dc.w	f_Default_IRQ_Handler
 103  0028 82            	dc.b	130
 105  0029 00            	dc.b	page(f_Default_IRQ_Handler)
 106  002a 0000          	dc.w	f_Default_IRQ_Handler
 107  002c 82            	dc.b	130
 109  002d 00            	dc.b	page(f_Default_IRQ_Handler)
 110  002e 0000          	dc.w	f_Default_IRQ_Handler
 111  0030 82            	dc.b	130
 113  0031 00            	dc.b	page(f_Default_IRQ_Handler)
 114  0032 0000          	dc.w	f_Default_IRQ_Handler
 115  0034 82            	dc.b	130
 117  0035 00            	dc.b	page(f_Default_IRQ_Handler)
 118  0036 0000          	dc.w	f_Default_IRQ_Handler
 119  0038 82            	dc.b	130
 121  0039 00            	dc.b	page(_ll_usb_rx)
 122  003a 0000          	dc.w	_ll_usb_rx
 123  003c 82            	dc.b	130
 125  003d 00            	dc.b	page(f_Default_IRQ_Handler)
 126  003e 0000          	dc.w	f_Default_IRQ_Handler
 127  0040 82            	dc.b	130
 129  0041 00            	dc.b	page(f_Default_IRQ_Handler)
 130  0042 0000          	dc.w	f_Default_IRQ_Handler
 131  0044 82            	dc.b	130
 133  0045 00            	dc.b	page(f_Default_IRQ_Handler)
 134  0046 0000          	dc.w	f_Default_IRQ_Handler
 135  0048 82            	dc.b	130
 137  0049 00            	dc.b	page(f_Default_IRQ_Handler)
 138  004a 0000          	dc.w	f_Default_IRQ_Handler
 139  004c 82            	dc.b	130
 141  004d 00            	dc.b	page(f_Default_IRQ_Handler)
 142  004e 0000          	dc.w	f_Default_IRQ_Handler
 143  0050 82            	dc.b	130
 145  0051 00            	dc.b	page(f_Default_IRQ_Handler)
 146  0052 0000          	dc.w	f_Default_IRQ_Handler
 147  0054 82            	dc.b	130
 149  0055 00            	dc.b	page(f_Default_IRQ_Handler)
 150  0056 0000          	dc.w	f_Default_IRQ_Handler
 151  0058 82            	dc.b	130
 153  0059 00            	dc.b	page(f_Default_IRQ_Handler)
 154  005a 0000          	dc.w	f_Default_IRQ_Handler
 155  005c 82            	dc.b	130
 157  005d 00            	dc.b	page(f_Default_IRQ_Handler)
 158  005e 0000          	dc.w	f_Default_IRQ_Handler
 159  0060 82            	dc.b	130
 161  0061 00            	dc.b	page(f_Default_IRQ_Handler)
 162  0062 0000          	dc.w	f_Default_IRQ_Handler
 163  0064 82            	dc.b	130
 165  0065 00            	dc.b	page(f_Default_IRQ_Handler)
 166  0066 0000          	dc.w	f_Default_IRQ_Handler
 167  0068 82            	dc.b	130
 169  0069 00            	dc.b	page(f_Default_IRQ_Handler)
 170  006a 0000          	dc.w	f_Default_IRQ_Handler
 171  006c 82            	dc.b	130
 173  006d 00            	dc.b	page(f_Default_IRQ_Handler)
 174  006e 0000          	dc.w	f_Default_IRQ_Handler
 175  0070 82            	dc.b	130
 177  0071 00            	dc.b	page(f_Default_IRQ_Handler)
 178  0072 0000          	dc.w	f_Default_IRQ_Handler
 179  0074 82            	dc.b	130
 181  0075 00            	dc.b	page(f_Default_IRQ_Handler)
 182  0076 0000          	dc.w	f_Default_IRQ_Handler
 183  0078 82            	dc.b	130
 185  0079 00            	dc.b	page(f_Default_IRQ_Handler)
 186  007a 0000          	dc.w	f_Default_IRQ_Handler
 187  007c 82            	dc.b	130
 189  007d 00            	dc.b	page(f_Default_IRQ_Handler)
 190  007e 0000          	dc.w	f_Default_IRQ_Handler
 240                     	xdef	__vectab
 241                     	xdef	f_Default_IRQ_Handler
 242                     	xref	__stext
 243                     	xref	f_Encoder_IRQ
 244                     	xref	_ll_usb_rx
 263                     	end
