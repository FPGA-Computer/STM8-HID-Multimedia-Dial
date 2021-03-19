   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.13 - 05 Feb 2019
   3                     ; Generator (Limited) V4.4.10 - 25 Sep 2019
   4                     ; Optimizer V4.4.10 - 25 Sep 2019
  80                     ; 87 void FLASH_Unlock(FLASH_MemType_TypeDef FLASH_MemType)
  80                     ; 88 {
  82                     	switch	.text
  83  0000               _FLASH_Unlock:
  87                     ; 90   assert_param(IS_MEMORY_TYPE_OK(FLASH_MemType));
  89                     ; 93   if(FLASH_MemType == FLASH_MEMTYPE_PROG)
  91  0000 a1fd          	cp	a,#253
  92  0002 2609          	jrne	L73
  93                     ; 95     FLASH->PUKR = FLASH_RASS_KEY1;
  95  0004 35565062      	mov	20578,#86
  96                     ; 96     FLASH->PUKR = FLASH_RASS_KEY2;
  98  0008 35ae5062      	mov	20578,#174
 101  000c 81            	ret	
 102  000d               L73:
 103                     ; 101     FLASH->DUKR = FLASH_RASS_KEY2; /* Warning: keys are reversed on data memory !!! */
 105  000d 35ae5064      	mov	20580,#174
 106                     ; 102     FLASH->DUKR = FLASH_RASS_KEY1;
 108  0011 35565064      	mov	20580,#86
 109                     ; 104 }
 112  0015 81            	ret	
 147                     ; 112 void FLASH_Lock(FLASH_MemType_TypeDef FLASH_MemType)
 147                     ; 113 {
 148                     	switch	.text
 149  0016               _FLASH_Lock:
 153                     ; 115   assert_param(IS_MEMORY_TYPE_OK(FLASH_MemType));
 155                     ; 118   FLASH->IAPSR &= (uint8_t)FLASH_MemType;
 157  0016 c4505f        	and	a,20575
 158  0019 c7505f        	ld	20575,a
 159                     ; 119 }
 162  001c 81            	ret	
 185                     ; 126 void FLASH_DeInit(void)
 185                     ; 127 {
 186                     	switch	.text
 187  001d               _FLASH_DeInit:
 191                     ; 128   FLASH->CR1 = FLASH_CR1_RESET_VALUE;
 193  001d 725f505a      	clr	20570
 194                     ; 129   FLASH->CR2 = FLASH_CR2_RESET_VALUE;
 196  0021 725f505b      	clr	20571
 197                     ; 130   FLASH->NCR2 = FLASH_NCR2_RESET_VALUE;
 199  0025 35ff505c      	mov	20572,#255
 200                     ; 131   FLASH->IAPSR &= (uint8_t)(~FLASH_IAPSR_DUL);
 202  0029 7217505f      	bres	20575,#3
 203                     ; 132   FLASH->IAPSR &= (uint8_t)(~FLASH_IAPSR_PUL);
 205  002d 7213505f      	bres	20575,#1
 206                     ; 133   (void) FLASH->IAPSR; /* Reading of this register causes the clearing of status flags */
 208  0031 c6505f        	ld	a,20575
 209                     ; 134 }
 212  0034 81            	ret	
 267                     ; 142 void FLASH_ITConfig(FunctionalState NewState)
 267                     ; 143 {
 268                     	switch	.text
 269  0035               _FLASH_ITConfig:
 273                     ; 145   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 275                     ; 147   if(NewState != DISABLE)
 277  0035 4d            	tnz	a
 278  0036 2705          	jreq	L711
 279                     ; 149     FLASH->CR1 |= FLASH_CR1_IE; /* Enables the interrupt sources */
 281  0038 7212505a      	bset	20570,#1
 284  003c 81            	ret	
 285  003d               L711:
 286                     ; 153     FLASH->CR1 &= (uint8_t)(~FLASH_CR1_IE); /* Disables the interrupt sources */
 288  003d 7213505a      	bres	20570,#1
 289                     ; 155 }
 292  0041 81            	ret	
 326                     ; 164 void FLASH_EraseByte(uint32_t Address)
 326                     ; 165 {
 327                     	switch	.text
 328  0042               _FLASH_EraseByte:
 330       00000000      OFST:	set	0
 333                     ; 167   assert_param(IS_FLASH_ADDRESS_OK(Address));
 335                     ; 170   *(PointerAttr uint8_t*) (MemoryAddressCast)Address = FLASH_CLEAR_BYTE; 
 337  0042 1e05          	ldw	x,(OFST+5,sp)
 338  0044 7f            	clr	(x)
 339                     ; 171 }
 342  0045 81            	ret	
 385                     ; 181 void FLASH_ProgramByte(uint32_t Address, uint8_t Data)
 385                     ; 182 {
 386                     	switch	.text
 387  0046               _FLASH_ProgramByte:
 389       00000000      OFST:	set	0
 392                     ; 184   assert_param(IS_FLASH_ADDRESS_OK(Address));
 394                     ; 185   *(PointerAttr uint8_t*) (MemoryAddressCast)Address = Data;
 396  0046 1e05          	ldw	x,(OFST+5,sp)
 397  0048 7b07          	ld	a,(OFST+7,sp)
 398  004a f7            	ld	(x),a
 399                     ; 186 }
 402  004b 81            	ret	
 436                     ; 195 uint8_t FLASH_ReadByte(uint32_t Address)
 436                     ; 196 {
 437                     	switch	.text
 438  004c               _FLASH_ReadByte:
 440       00000000      OFST:	set	0
 443                     ; 198   assert_param(IS_FLASH_ADDRESS_OK(Address));
 445                     ; 201   return(*(PointerAttr uint8_t *) (MemoryAddressCast)Address); 
 447  004c 1e05          	ldw	x,(OFST+5,sp)
 448  004e f6            	ld	a,(x)
 451  004f 81            	ret	
 494                     ; 212 void FLASH_ProgramWord(uint32_t Address, uint32_t Data)
 494                     ; 213 {
 495                     	switch	.text
 496  0050               _FLASH_ProgramWord:
 498       00000000      OFST:	set	0
 501                     ; 215   assert_param(IS_FLASH_ADDRESS_OK(Address));
 503                     ; 218   FLASH->CR2 |= FLASH_CR2_WPRG;
 505  0050 721c505b      	bset	20571,#6
 506                     ; 219   FLASH->NCR2 &= (uint8_t)(~FLASH_NCR2_NWPRG);
 508  0054 721d505c      	bres	20572,#6
 509                     ; 222   *((PointerAttr uint8_t*)(MemoryAddressCast)Address)       = *((uint8_t*)(&Data));
 511  0058 1e05          	ldw	x,(OFST+5,sp)
 512  005a 7b07          	ld	a,(OFST+7,sp)
 513  005c f7            	ld	(x),a
 514                     ; 224   *(((PointerAttr uint8_t*)(MemoryAddressCast)Address) + 1) = *((uint8_t*)(&Data)+1); 
 516  005d 7b08          	ld	a,(OFST+8,sp)
 517  005f e701          	ld	(1,x),a
 518                     ; 226   *(((PointerAttr uint8_t*)(MemoryAddressCast)Address) + 2) = *((uint8_t*)(&Data)+2); 
 520  0061 7b09          	ld	a,(OFST+9,sp)
 521  0063 e702          	ld	(2,x),a
 522                     ; 228   *(((PointerAttr uint8_t*)(MemoryAddressCast)Address) + 3) = *((uint8_t*)(&Data)+3); 
 524  0065 7b0a          	ld	a,(OFST+10,sp)
 525  0067 e703          	ld	(3,x),a
 526                     ; 229 }
 529  0069 81            	ret	
 574                     ; 237 void FLASH_ProgramOptionByte(uint16_t Address, uint8_t Data)
 574                     ; 238 {
 575                     	switch	.text
 576  006a               _FLASH_ProgramOptionByte:
 578  006a 89            	pushw	x
 579       00000000      OFST:	set	0
 582                     ; 240   assert_param(IS_OPTION_BYTE_ADDRESS_OK(Address));
 584                     ; 243   FLASH->CR2 |= FLASH_CR2_OPT;
 586  006b 721e505b      	bset	20571,#7
 587                     ; 244   FLASH->NCR2 &= (uint8_t)(~FLASH_NCR2_NOPT);
 589  006f 721f505c      	bres	20572,#7
 590                     ; 247   if(Address == 0x4800)
 592  0073 a34800        	cpw	x,#18432
 593  0076 2605          	jrne	L542
 594                     ; 250     *((NEAR uint8_t*)Address) = Data;
 596  0078 7b05          	ld	a,(OFST+5,sp)
 597  007a f7            	ld	(x),a
 599  007b 2006          	jra	L742
 600  007d               L542:
 601                     ; 255     *((NEAR uint8_t*)Address) = Data;
 603  007d 7b05          	ld	a,(OFST+5,sp)
 604  007f f7            	ld	(x),a
 605                     ; 256     *((NEAR uint8_t*)((uint16_t)(Address + 1))) = (uint8_t)(~Data);
 607  0080 43            	cpl	a
 608  0081 e701          	ld	(1,x),a
 609  0083               L742:
 610                     ; 258   FLASH_WaitForLastOperation(FLASH_MEMTYPE_PROG);
 612  0083 a6fd          	ld	a,#253
 613  0085 cd014a        	call	_FLASH_WaitForLastOperation
 615                     ; 261   FLASH->CR2 &= (uint8_t)(~FLASH_CR2_OPT);
 617  0088 721f505b      	bres	20571,#7
 618                     ; 262   FLASH->NCR2 |= FLASH_NCR2_NOPT;
 620  008c 721e505c      	bset	20572,#7
 621                     ; 263 }
 624  0090 85            	popw	x
 625  0091 81            	ret	
 661                     ; 270 void FLASH_EraseOptionByte(uint16_t Address)
 661                     ; 271 {
 662                     	switch	.text
 663  0092               _FLASH_EraseOptionByte:
 665  0092 89            	pushw	x
 666       00000000      OFST:	set	0
 669                     ; 273   assert_param(IS_OPTION_BYTE_ADDRESS_OK(Address));
 671                     ; 276   FLASH->CR2 |= FLASH_CR2_OPT;
 673  0093 721e505b      	bset	20571,#7
 674                     ; 277   FLASH->NCR2 &= (uint8_t)(~FLASH_NCR2_NOPT);
 676  0097 721f505c      	bres	20572,#7
 677                     ; 280   if(Address == 0x4800)
 679  009b a34800        	cpw	x,#18432
 680  009e 2603          	jrne	L762
 681                     ; 283     *((NEAR uint8_t*)Address) = FLASH_CLEAR_BYTE;
 683  00a0 7f            	clr	(x)
 685  00a1 2005          	jra	L172
 686  00a3               L762:
 687                     ; 288     *((NEAR uint8_t*)Address) = FLASH_CLEAR_BYTE;
 689  00a3 7f            	clr	(x)
 690                     ; 289     *((NEAR uint8_t*)((uint16_t)(Address + (uint16_t)1 ))) = FLASH_SET_BYTE;
 692  00a4 a6ff          	ld	a,#255
 693  00a6 e701          	ld	(1,x),a
 694  00a8               L172:
 695                     ; 291   FLASH_WaitForLastOperation(FLASH_MEMTYPE_PROG);
 697  00a8 a6fd          	ld	a,#253
 698  00aa cd014a        	call	_FLASH_WaitForLastOperation
 700                     ; 294   FLASH->CR2 &= (uint8_t)(~FLASH_CR2_OPT);
 702  00ad 721f505b      	bres	20571,#7
 703                     ; 295   FLASH->NCR2 |= FLASH_NCR2_NOPT;
 705  00b1 721e505c      	bset	20572,#7
 706                     ; 296 }
 709  00b5 85            	popw	x
 710  00b6 81            	ret	
 773                     ; 303 uint16_t FLASH_ReadOptionByte(uint16_t Address)
 773                     ; 304 {
 774                     	switch	.text
 775  00b7               _FLASH_ReadOptionByte:
 777  00b7 5204          	subw	sp,#4
 778       00000004      OFST:	set	4
 781                     ; 305   uint8_t value_optbyte, value_optbyte_complement = 0;
 783                     ; 306   uint16_t res_value = 0;
 785                     ; 309   assert_param(IS_OPTION_BYTE_ADDRESS_OK(Address));
 787                     ; 311   value_optbyte = *((NEAR uint8_t*)Address); /* Read option byte */
 789  00b9 f6            	ld	a,(x)
 790  00ba 6b01          	ld	(OFST-3,sp),a
 792                     ; 312   value_optbyte_complement = *(((NEAR uint8_t*)Address) + 1); /* Read option byte complement */
 794  00bc e601          	ld	a,(1,x)
 795  00be 6b02          	ld	(OFST-2,sp),a
 797                     ; 315   if(Address == 0x4800)	 
 799  00c0 a34800        	cpw	x,#18432
 800  00c3 2606          	jrne	L523
 801                     ; 317     res_value =	 value_optbyte;
 803  00c5 7b01          	ld	a,(OFST-3,sp)
 804  00c7 5f            	clrw	x
 805  00c8 97            	ld	xl,a
 808  00c9 201c          	jra	L723
 809  00cb               L523:
 810                     ; 321     if(value_optbyte == (uint8_t)(~value_optbyte_complement))
 812  00cb 43            	cpl	a
 813  00cc 1101          	cp	a,(OFST-3,sp)
 814  00ce 2614          	jrne	L133
 815                     ; 323       res_value = (uint16_t)((uint16_t)value_optbyte << 8);
 817  00d0 7b01          	ld	a,(OFST-3,sp)
 818  00d2 97            	ld	xl,a
 819  00d3 4f            	clr	a
 820  00d4 02            	rlwa	x,a
 821  00d5 1f03          	ldw	(OFST-1,sp),x
 823                     ; 324       res_value = res_value | (uint16_t)value_optbyte_complement;
 825  00d7 5f            	clrw	x
 826  00d8 7b02          	ld	a,(OFST-2,sp)
 827  00da 97            	ld	xl,a
 828  00db 01            	rrwa	x,a
 829  00dc 1a04          	or	a,(OFST+0,sp)
 830  00de 01            	rrwa	x,a
 831  00df 1a03          	or	a,(OFST-1,sp)
 832  00e1 01            	rrwa	x,a
 835  00e2 2003          	jra	L723
 836  00e4               L133:
 837                     ; 328       res_value = FLASH_OPTIONBYTE_ERROR;
 839  00e4 ae5555        	ldw	x,#21845
 841  00e7               L723:
 842                     ; 331   return(res_value);
 846  00e7 5b04          	addw	sp,#4
 847  00e9 81            	ret	
 921                     ; 340 void FLASH_SetLowPowerMode(FLASH_LPMode_TypeDef FLASH_LPMode)
 921                     ; 341 {
 922                     	switch	.text
 923  00ea               _FLASH_SetLowPowerMode:
 925  00ea 88            	push	a
 926       00000000      OFST:	set	0
 929                     ; 343   assert_param(IS_FLASH_LOW_POWER_MODE_OK(FLASH_LPMode));
 931                     ; 346   FLASH->CR1 &= (uint8_t)(~(FLASH_CR1_HALT | FLASH_CR1_AHALT)); 
 933  00eb c6505a        	ld	a,20570
 934  00ee a4f3          	and	a,#243
 935  00f0 c7505a        	ld	20570,a
 936                     ; 349   FLASH->CR1 |= (uint8_t)FLASH_LPMode; 
 938  00f3 c6505a        	ld	a,20570
 939  00f6 1a01          	or	a,(OFST+1,sp)
 940  00f8 c7505a        	ld	20570,a
 941                     ; 350 }
 944  00fb 84            	pop	a
 945  00fc 81            	ret	
1003                     ; 358 void FLASH_SetProgrammingTime(FLASH_ProgramTime_TypeDef FLASH_ProgTime)
1003                     ; 359 {
1004                     	switch	.text
1005  00fd               _FLASH_SetProgrammingTime:
1009                     ; 361   assert_param(IS_FLASH_PROGRAM_TIME_OK(FLASH_ProgTime));
1011                     ; 363   FLASH->CR1 &= (uint8_t)(~FLASH_CR1_FIX);
1013  00fd 7211505a      	bres	20570,#0
1014                     ; 364   FLASH->CR1 |= (uint8_t)FLASH_ProgTime;
1016  0101 ca505a        	or	a,20570
1017  0104 c7505a        	ld	20570,a
1018                     ; 365 }
1021  0107 81            	ret	
1046                     ; 372 FLASH_LPMode_TypeDef FLASH_GetLowPowerMode(void)
1046                     ; 373 {
1047                     	switch	.text
1048  0108               _FLASH_GetLowPowerMode:
1052                     ; 374   return((FLASH_LPMode_TypeDef)(FLASH->CR1 & (uint8_t)(FLASH_CR1_HALT | FLASH_CR1_AHALT)));
1054  0108 c6505a        	ld	a,20570
1055  010b a40c          	and	a,#12
1058  010d 81            	ret	
1083                     ; 382 FLASH_ProgramTime_TypeDef FLASH_GetProgrammingTime(void)
1083                     ; 383 {
1084                     	switch	.text
1085  010e               _FLASH_GetProgrammingTime:
1089                     ; 384   return((FLASH_ProgramTime_TypeDef)(FLASH->CR1 & FLASH_CR1_FIX));
1091  010e c6505a        	ld	a,20570
1092  0111 a401          	and	a,#1
1095  0113 81            	ret	
1129                     ; 392 uint32_t FLASH_GetBootSize(void)
1129                     ; 393 {
1130                     	switch	.text
1131  0114               _FLASH_GetBootSize:
1133  0114 5204          	subw	sp,#4
1134       00000004      OFST:	set	4
1137                     ; 394   uint32_t temp = 0;
1139                     ; 397   temp = (uint32_t)((uint32_t)FLASH->FPR * (uint32_t)512);
1141  0116 c6505d        	ld	a,20573
1142  0119 5f            	clrw	x
1143  011a 97            	ld	xl,a
1144  011b 90ae0200      	ldw	y,#512
1145  011f cd0000        	call	c_umul
1147  0122 96            	ldw	x,sp
1148  0123 5c            	incw	x
1149  0124 cd0000        	call	c_rtol
1152                     ; 400   if(FLASH->FPR == 0xFF)
1154  0127 c6505d        	ld	a,20573
1155  012a 4c            	inc	a
1156  012b 260d          	jrne	L354
1157                     ; 402     temp += 512;
1159  012d ae0200        	ldw	x,#512
1160  0130 bf02          	ldw	c_lreg+2,x
1161  0132 5f            	clrw	x
1162  0133 bf00          	ldw	c_lreg,x
1163  0135 96            	ldw	x,sp
1164  0136 5c            	incw	x
1165  0137 cd0000        	call	c_lgadd
1168  013a               L354:
1169                     ; 406   return(temp);
1171  013a 96            	ldw	x,sp
1172  013b 5c            	incw	x
1173  013c cd0000        	call	c_ltor
1177  013f 5b04          	addw	sp,#4
1178  0141 81            	ret	
1280                     ; 417 FlagStatus FLASH_GetFlagStatus(FLASH_Flag_TypeDef FLASH_FLAG)
1280                     ; 418 {
1281                     	switch	.text
1282  0142               _FLASH_GetFlagStatus:
1284       00000001      OFST:	set	1
1287                     ; 419   FlagStatus status = RESET;
1289                     ; 421   assert_param(IS_FLASH_FLAGS_OK(FLASH_FLAG));
1291                     ; 424   if((FLASH->IAPSR & (uint8_t)FLASH_FLAG) != (uint8_t)RESET)
1293  0142 c4505f        	and	a,20575
1294  0145 2702          	jreq	L325
1295                     ; 426     status = SET; /* FLASH_FLAG is set */
1297  0147 a601          	ld	a,#1
1300  0149               L325:
1301                     ; 430     status = RESET; /* FLASH_FLAG is reset*/
1304                     ; 434   return status;
1308  0149 81            	ret	
1393                     ; 549 IN_RAM(FLASH_Status_TypeDef FLASH_WaitForLastOperation(FLASH_MemType_TypeDef FLASH_MemType)) 
1393                     ; 550 {
1394                     	switch	.text
1395  014a               _FLASH_WaitForLastOperation:
1397  014a 5203          	subw	sp,#3
1398       00000003      OFST:	set	3
1401                     ; 551   uint8_t flagstatus = 0x00;
1403  014c 0f03          	clr	(OFST+0,sp)
1405                     ; 552   uint16_t timeout = OPERATION_TIMEOUT;
1407  014e aeffff        	ldw	x,#65535
1409  0151 2008          	jra	L375
1410  0153               L765:
1411                     ; 578     flagstatus = (uint8_t)(FLASH->IAPSR & (FLASH_IAPSR_EOP | FLASH_IAPSR_WR_PG_DIS));
1413  0153 c6505f        	ld	a,20575
1414  0156 a405          	and	a,#5
1415  0158 6b03          	ld	(OFST+0,sp),a
1417                     ; 579     timeout--;
1419  015a 5a            	decw	x
1420  015b               L375:
1421  015b 1f01          	ldw	(OFST-2,sp),x
1423                     ; 576   while((flagstatus == 0x00) && (timeout != 0x00))
1425  015d 7b03          	ld	a,(OFST+0,sp)
1426  015f 2604          	jrne	L775
1428  0161 1e01          	ldw	x,(OFST-2,sp)
1429  0163 26ee          	jrne	L765
1430  0165               L775:
1431                     ; 583   if(timeout == 0x00 )
1433  0165 1e01          	ldw	x,(OFST-2,sp)
1434  0167 2602          	jrne	L106
1435                     ; 585     flagstatus = FLASH_STATUS_TIMEOUT;
1437  0169 a602          	ld	a,#2
1439  016b               L106:
1440                     ; 588   return((FLASH_Status_TypeDef)flagstatus);
1444  016b 5b03          	addw	sp,#3
1445  016d 81            	ret	
1508                     ; 598 IN_RAM(void FLASH_EraseBlock(uint16_t BlockNum, FLASH_MemType_TypeDef FLASH_MemType))
1508                     ; 599 {
1509                     	switch	.text
1510  016e               _FLASH_EraseBlock:
1512  016e 89            	pushw	x
1513  016f 5206          	subw	sp,#6
1514       00000006      OFST:	set	6
1517                     ; 600   uint32_t startaddress = 0;
1519                     ; 610   assert_param(IS_MEMORY_TYPE_OK(FLASH_MemType));
1521                     ; 611   if(FLASH_MemType == FLASH_MEMTYPE_PROG)
1523  0171 7b0b          	ld	a,(OFST+5,sp)
1524  0173 a1fd          	cp	a,#253
1525  0175 2605          	jrne	L536
1526                     ; 613     assert_param(IS_FLASH_PROG_BLOCK_NUMBER_OK(BlockNum));
1528                     ; 614     startaddress = FLASH_PROG_START_PHYSICAL_ADDRESS;
1530  0177 ae8000        	ldw	x,#32768
1532  017a 2003          	jra	L736
1533  017c               L536:
1534                     ; 618     assert_param(IS_FLASH_DATA_BLOCK_NUMBER_OK(BlockNum));
1536                     ; 619     startaddress = FLASH_DATA_START_PHYSICAL_ADDRESS;
1538  017c ae4000        	ldw	x,#16384
1539  017f               L736:
1540  017f 1f05          	ldw	(OFST-1,sp),x
1541  0181 5f            	clrw	x
1542  0182 1f03          	ldw	(OFST-3,sp),x
1544                     ; 627     pwFlash = (PointerAttr uint32_t *)(MemoryAddressCast)(startaddress + ((uint32_t)BlockNum * FLASH_BLOCK_SIZE));
1546  0184 a640          	ld	a,#64
1547  0186 1e07          	ldw	x,(OFST+1,sp)
1548  0188 cd0000        	call	c_cmulx
1550  018b 96            	ldw	x,sp
1551  018c 1c0003        	addw	x,#OFST-3
1552  018f cd0000        	call	c_ladd
1554  0192 be02          	ldw	x,c_lreg+2
1555  0194 1f01          	ldw	(OFST-5,sp),x
1557                     ; 631   FLASH->CR2 |= FLASH_CR2_ERASE;
1559  0196 721a505b      	bset	20571,#5
1560                     ; 632   FLASH->NCR2 &= (uint8_t)(~FLASH_NCR2_NERASE);
1562  019a 721b505c      	bres	20572,#5
1563                     ; 636     *pwFlash = (uint32_t)0;
1565  019e 4f            	clr	a
1566  019f e703          	ld	(3,x),a
1567  01a1 e702          	ld	(2,x),a
1568  01a3 e701          	ld	(1,x),a
1569  01a5 f7            	ld	(x),a
1570                     ; 644 }
1573  01a6 5b08          	addw	sp,#8
1574  01a8 81            	ret	
1678                     ; 655 IN_RAM(void FLASH_ProgramBlock(uint16_t BlockNum, FLASH_MemType_TypeDef FLASH_MemType, 
1678                     ; 656                         FLASH_ProgramMode_TypeDef FLASH_ProgMode, uint8_t *Buffer))
1678                     ; 657 {
1679                     	switch	.text
1680  01a9               _FLASH_ProgramBlock:
1682  01a9 89            	pushw	x
1683  01aa 5206          	subw	sp,#6
1684       00000006      OFST:	set	6
1687                     ; 658   uint16_t Count = 0;
1689                     ; 659   uint32_t startaddress = 0;
1691                     ; 662   assert_param(IS_MEMORY_TYPE_OK(FLASH_MemType));
1693                     ; 663   assert_param(IS_FLASH_PROGRAM_MODE_OK(FLASH_ProgMode));
1695                     ; 664   if(FLASH_MemType == FLASH_MEMTYPE_PROG)
1697  01ac 7b0b          	ld	a,(OFST+5,sp)
1698  01ae a1fd          	cp	a,#253
1699  01b0 2605          	jrne	L317
1700                     ; 666     assert_param(IS_FLASH_PROG_BLOCK_NUMBER_OK(BlockNum));
1702                     ; 667     startaddress = FLASH_PROG_START_PHYSICAL_ADDRESS;
1704  01b2 ae8000        	ldw	x,#32768
1706  01b5 2003          	jra	L517
1707  01b7               L317:
1708                     ; 671     assert_param(IS_FLASH_DATA_BLOCK_NUMBER_OK(BlockNum));
1710                     ; 672     startaddress = FLASH_DATA_START_PHYSICAL_ADDRESS;
1712  01b7 ae4000        	ldw	x,#16384
1713  01ba               L517:
1714  01ba 1f03          	ldw	(OFST-3,sp),x
1715  01bc 5f            	clrw	x
1716  01bd 1f01          	ldw	(OFST-5,sp),x
1718                     ; 676   startaddress = startaddress + ((uint32_t)BlockNum * FLASH_BLOCK_SIZE);
1720  01bf a640          	ld	a,#64
1721  01c1 1e07          	ldw	x,(OFST+1,sp)
1722  01c3 cd0000        	call	c_cmulx
1724  01c6 96            	ldw	x,sp
1725  01c7 5c            	incw	x
1726  01c8 cd0000        	call	c_lgadd
1729                     ; 679   if(FLASH_ProgMode == FLASH_PROGRAMMODE_STANDARD)
1731  01cb 7b0c          	ld	a,(OFST+6,sp)
1732  01cd 260a          	jrne	L717
1733                     ; 682     FLASH->CR2 |= FLASH_CR2_PRG;
1735  01cf 7210505b      	bset	20571,#0
1736                     ; 683     FLASH->NCR2 &= (uint8_t)(~FLASH_NCR2_NPRG);
1738  01d3 7211505c      	bres	20572,#0
1740  01d7 2008          	jra	L127
1741  01d9               L717:
1742                     ; 688     FLASH->CR2 |= FLASH_CR2_FPRG;
1744  01d9 7218505b      	bset	20571,#4
1745                     ; 689     FLASH->NCR2 &= (uint8_t)(~FLASH_NCR2_NFPRG);
1747  01dd 7219505c      	bres	20572,#4
1748  01e1               L127:
1749                     ; 693   for(Count = 0; Count < FLASH_BLOCK_SIZE; Count++)
1751  01e1 5f            	clrw	x
1752  01e2 1f05          	ldw	(OFST-1,sp),x
1754  01e4               L327:
1755                     ; 695     *((PointerAttr uint8_t*) (MemoryAddressCast)startaddress + Count) = ((uint8_t)(Buffer[Count]));
1757  01e4 1e0d          	ldw	x,(OFST+7,sp)
1758  01e6 72fb05        	addw	x,(OFST-1,sp)
1759  01e9 f6            	ld	a,(x)
1760  01ea 1e03          	ldw	x,(OFST-3,sp)
1761  01ec 72fb05        	addw	x,(OFST-1,sp)
1762  01ef f7            	ld	(x),a
1763                     ; 693   for(Count = 0; Count < FLASH_BLOCK_SIZE; Count++)
1765  01f0 1e05          	ldw	x,(OFST-1,sp)
1766  01f2 5c            	incw	x
1767  01f3 1f05          	ldw	(OFST-1,sp),x
1771  01f5 a30040        	cpw	x,#64
1772  01f8 25ea          	jrult	L327
1773                     ; 697 }
1776  01fa 5b08          	addw	sp,#8
1777  01fc 81            	ret	
1790                     	xdef	_FLASH_WaitForLastOperation
1791                     	xdef	_FLASH_ProgramBlock
1792                     	xdef	_FLASH_EraseBlock
1793                     	xdef	_FLASH_GetFlagStatus
1794                     	xdef	_FLASH_GetBootSize
1795                     	xdef	_FLASH_GetProgrammingTime
1796                     	xdef	_FLASH_GetLowPowerMode
1797                     	xdef	_FLASH_SetProgrammingTime
1798                     	xdef	_FLASH_SetLowPowerMode
1799                     	xdef	_FLASH_EraseOptionByte
1800                     	xdef	_FLASH_ProgramOptionByte
1801                     	xdef	_FLASH_ReadOptionByte
1802                     	xdef	_FLASH_ProgramWord
1803                     	xdef	_FLASH_ReadByte
1804                     	xdef	_FLASH_ProgramByte
1805                     	xdef	_FLASH_EraseByte
1806                     	xdef	_FLASH_ITConfig
1807                     	xdef	_FLASH_DeInit
1808                     	xdef	_FLASH_Lock
1809                     	xdef	_FLASH_Unlock
1810                     	xref.b	c_lreg
1811                     	xref.b	c_x
1812                     	xref.b	c_y
1831                     	xref	c_ladd
1832                     	xref	c_cmulx
1833                     	xref	c_ltor
1834                     	xref	c_lgadd
1835                     	xref	c_rtol
1836                     	xref	c_umul
1837                     	end
