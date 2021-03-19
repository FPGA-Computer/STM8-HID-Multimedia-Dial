   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.13 - 05 Feb 2019
   3                     ; Generator (Limited) V4.4.10 - 25 Sep 2019
   4                     ; Optimizer V4.4.10 - 25 Sep 2019
  20                     .const:	section	.text
  21  0000               _usb_device_descriptor:
  22  0000 12            	dc.b	18
  23  0001 01            	dc.b	1
  24  0002 10            	dc.b	16
  25  0003 01            	dc.b	1
  26  0004 00            	dc.b	0
  27  0005 00            	dc.b	0
  28  0006 00            	dc.b	0
  29  0007 08            	dc.b	8
  30  0008 c0            	dc.b	192
  31  0009 16            	dc.b	22
  32  000a df            	dc.b	223
  33  000b 05            	dc.b	5
  34  000c 00            	dc.b	0
  35  000d 02            	dc.b	2
  36  000e 01            	dc.b	1
  37  000f 02            	dc.b	2
  38  0010 03            	dc.b	3
  39  0011 01            	dc.b	1
  40  0012               _usb_configuration_descriptor:
  41  0012 09            	dc.b	9
  42  0013 02            	dc.b	2
  43  0014 22            	dc.b	34
  44  0015 00            	dc.b	0
  45  0016 01            	dc.b	1
  46  0017 01            	dc.b	1
  47  0018 00            	dc.b	0
  48  0019 80            	dc.b	128
  49  001a 05            	dc.b	5
  50  001b 09            	dc.b	9
  51  001c 04            	dc.b	4
  52  001d 01            	dc.b	1
  53  001e 00            	dc.b	0
  54  001f 01            	dc.b	1
  55  0020 03            	dc.b	3
  56  0021 00            	dc.b	0
  57  0022 00            	dc.b	0
  58  0023 00            	dc.b	0
  59  0024 09            	dc.b	9
  60  0025 21            	dc.b	33
  61  0026 10            	dc.b	16
  62  0027 01            	dc.b	1
  63  0028 00            	dc.b	0
  64  0029 01            	dc.b	1
  65  002a 22            	dc.b	34
  66  002b 2b            	dc.b	43
  67  002c 00            	dc.b	0
  68  002d 07            	dc.b	7
  69  002e 05            	dc.b	5
  70  002f 81            	dc.b	129
  71  0030 03            	dc.b	3
  72  0031 08            	dc.b	8
  73  0032 00            	dc.b	0
  74  0033 0a            	dc.b	10
  75  0034               _String_LangID:
  76  0034 04            	dc.b	4
  77  0035 03            	dc.b	3
  78  0036 09            	dc.b	9
  79  0037 04            	dc.b	4
  80  0038               _String_Vendor:
  81  0038 34            	dc.b	52
  82  0039 03            	dc.b	3
  83  003a 68            	dc.b	104
  84  003b 00            	dc.b	0
  85  003c 77            	dc.b	119
  86  003d 00            	dc.b	0
  87  003e 2d            	dc.b	45
  88  003f 00            	dc.b	0
  89  0040 62            	dc.b	98
  90  0041 00            	dc.b	0
  91  0042 79            	dc.b	121
  92  0043 00            	dc.b	0
  93  0044 2d            	dc.b	45
  94  0045 00            	dc.b	0
  95  0046 64            	dc.b	100
  96  0047 00            	dc.b	0
  97  0048 65            	dc.b	101
  98  0049 00            	dc.b	0
  99  004a 73            	dc.b	115
 100  004b 00            	dc.b	0
 101  004c 69            	dc.b	105
 102  004d 00            	dc.b	0
 103  004e 67            	dc.b	103
 104  004f 00            	dc.b	0
 105  0050 6e            	dc.b	110
 106  0051 00            	dc.b	0
 107  0052 2e            	dc.b	46
 108  0053 00            	dc.b	0
 109  0054 62            	dc.b	98
 110  0055 00            	dc.b	0
 111  0056 6c            	dc.b	108
 112  0057 00            	dc.b	0
 113  0058 6f            	dc.b	111
 114  0059 00            	dc.b	0
 115  005a 67            	dc.b	103
 116  005b 00            	dc.b	0
 117  005c 73            	dc.b	115
 118  005d 00            	dc.b	0
 119  005e 70            	dc.b	112
 120  005f 00            	dc.b	0
 121  0060 6f            	dc.b	111
 122  0061 00            	dc.b	0
 123  0062 74            	dc.b	116
 124  0063 00            	dc.b	0
 125  0064 2e            	dc.b	46
 126  0065 00            	dc.b	0
 127  0066 63            	dc.b	99
 128  0067 00            	dc.b	0
 129  0068 6f            	dc.b	111
 130  0069 00            	dc.b	0
 131  006a 6d            	dc.b	109
 132  006b 00            	dc.b	0
 133  006c               _String_Product:
 134  006c 2a            	dc.b	42
 135  006d 03            	dc.b	3
 136  006e 48            	dc.b	72
 137  006f 00            	dc.b	0
 138  0070 49            	dc.b	73
 139  0071 00            	dc.b	0
 140  0072 44            	dc.b	68
 141  0073 00            	dc.b	0
 142  0074 20            	dc.b	32
 143  0075 00            	dc.b	0
 144  0076 4d            	dc.b	77
 145  0077 00            	dc.b	0
 146  0078 75            	dc.b	117
 147  0079 00            	dc.b	0
 148  007a 6c            	dc.b	108
 149  007b 00            	dc.b	0
 150  007c 74            	dc.b	116
 151  007d 00            	dc.b	0
 152  007e 69            	dc.b	105
 153  007f 00            	dc.b	0
 154  0080 6d            	dc.b	109
 155  0081 00            	dc.b	0
 156  0082 65            	dc.b	101
 157  0083 00            	dc.b	0
 158  0084 64            	dc.b	100
 159  0085 00            	dc.b	0
 160  0086 6d            	dc.b	109
 161  0087 00            	dc.b	0
 162  0088 69            	dc.b	105
 163  0089 00            	dc.b	0
 164  008a 61            	dc.b	97
 165  008b 00            	dc.b	0
 166  008c 20            	dc.b	32
 167  008d 00            	dc.b	0
 168  008e 44            	dc.b	68
 169  008f 00            	dc.b	0
 170  0090 69            	dc.b	105
 171  0091 00            	dc.b	0
 172  0092 61            	dc.b	97
 173  0093 00            	dc.b	0
 174  0094 6c            	dc.b	108
 175  0095 00            	dc.b	0
 176  0096               _String_Serial:
 177  0096 0a            	dc.b	10
 178  0097 03            	dc.b	3
 179  0098 30            	dc.b	48
 180  0099 00            	dc.b	0
 181  009a 30            	dc.b	48
 182  009b 00            	dc.b	0
 183  009c 30            	dc.b	48
 184  009d 00            	dc.b	0
 185  009e 32            	dc.b	50
 186  009f 00            	dc.b	0
 187                     	bsct
 188  0000               _USB_String_Descriptors:
 189  0000 0034          	dc.w	_String_LangID
 190  0002 0038          	dc.w	_String_Vendor
 191  0004 006c          	dc.w	_String_Product
 192  0006 0096          	dc.w	_String_Serial
 193                     	switch	.const
 194  00a0               _USB_String_Descriptors_Length:
 195  00a0 04            	dc.b	4
 196  00a1 34            	dc.b	52
 197  00a2 2a            	dc.b	42
 198  00a3 0a            	dc.b	10
 199  00a4               _HID_ReportDescriptor:
 200  00a4 05            	dc.b	5
 201  00a5 0c            	dc.b	12
 202  00a6 09            	dc.b	9
 203  00a7 01            	dc.b	1
 204  00a8 a1            	dc.b	161
 205  00a9 01            	dc.b	1
 206  00aa 85            	dc.b	133
 207  00ab 01            	dc.b	1
 208  00ac 15            	dc.b	21
 209  00ad 00            	dc.b	0
 210  00ae 25            	dc.b	37
 211  00af 01            	dc.b	1
 212  00b0 75            	dc.b	117
 213  00b1 01            	dc.b	1
 214  00b2 95            	dc.b	149
 215  00b3 04            	dc.b	4
 216  00b4 19            	dc.b	25
 217  00b5 b5            	dc.b	181
 218  00b6 29            	dc.b	41
 219  00b7 b7            	dc.b	183
 220  00b8 09            	dc.b	9
 221  00b9 cd            	dc.b	205
 222  00ba 81            	dc.b	129
 223  00bb 02            	dc.b	2
 224  00bc 95            	dc.b	149
 225  00bd 01            	dc.b	1
 226  00be 09            	dc.b	9
 227  00bf e2            	dc.b	226
 228  00c0 81            	dc.b	129
 229  00c1 06            	dc.b	6
 230  00c2 95            	dc.b	149
 231  00c3 02            	dc.b	2
 232  00c4 09            	dc.b	9
 233  00c5 e9            	dc.b	233
 234  00c6 09            	dc.b	9
 235  00c7 ea            	dc.b	234
 236  00c8 81            	dc.b	129
 237  00c9 02            	dc.b	2
 238  00ca 95            	dc.b	149
 239  00cb 01            	dc.b	1
 240  00cc 81            	dc.b	129
 241  00cd 03            	dc.b	3
 242  00ce c0            	dc.b	192
 359                     	xdef	_String_Serial
 360                     	xdef	_String_Product
 361                     	xdef	_String_Vendor
 362                     	xdef	_String_LangID
 363                     	xdef	_HID_ReportDescriptor
 364                     	xdef	_USB_String_Descriptors_Length
 365                     	xdef	_USB_String_Descriptors
 366                     	xdef	_usb_configuration_descriptor
 367                     	xdef	_usb_device_descriptor
 386                     	end
