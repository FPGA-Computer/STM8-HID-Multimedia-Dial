/*
 * hardware.c
 *
 * Created: August 30, 2019, 6:35:08 PM
 *  Author: K. C. Lee
 * Copyright (c) 2016 by K. C. Lee
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.

 If not, see http://www.gnu.org/licenses/gpl-3.0.en.html 
 */ 

#include "hardware.h"
#include "usb.h"

uint8_t ReportIn[REPORT_SIZE]= {ID_CONSUMER }, Report_State = REPORT_RDY;

// Rotary encoder - positive count is clockwise
volatile int8_t Encoder_;
int8_t Encoder = 0;

void Init_Hardware(void)
{	
	Check_OPTION_BYTE();
	CLK->CKDIVR = 0; // HSIDIV = 0; CPUDIV = 0
		
	USB_disconnect();
	TIM4_Init();
	Encoder_Init();
	USB_Init();
	Delay(US_DELAY(90000));
	enableInterrupts();
	USB_connect();
}

#define IWDG_KEY_ENABLE 0xcc

void RESET_CHIP(void)
{
	IWDG->KR = IWDG_KEY_ENABLE; // Reset the CPU: Enable the watchdog and wait until it expires
	while(1);    // Wait until reset occurs from IWDG
}

void Check_OPTION_BYTE(void)
{
	uint8_t option_byte;
	uint8_t option_byte_neg;
	uint16_t option_byte_addr;
	// 0 - ROP
	// 1,2 - UBC
	// 3,4 - AFR
	// 5,6 - options
	
	option_byte_addr = OPTION_BYTE_START_PHYSICAL_ADDRESS + 3; // AFR
	option_byte = *((NEAR uint8_t*)option_byte_addr);
	option_byte_neg = *((NEAR uint8_t*)(option_byte_addr + 1));
	if ((option_byte != (uint8_t)(~option_byte_neg)) ||
	((option_byte & OPTION_BYTE) == 0)) { // check AFR0
		option_byte |= OPTION_BYTE; // set AFR0 = 1 // PORT C[7..5] Alternate Function

		FLASH_Unlock(FLASH_MEMTYPE_DATA);

		FLASH->CR2 |= FLASH_CR2_OPT;
		FLASH->NCR2 &= (uint8_t)(~FLASH_NCR2_NOPT);
		// Program option byte and his complement
		do {
			*((NEAR uint8_t*)option_byte_addr) = option_byte;
			FLASH_WaitForLastOperation(FLASH_MEMTYPE_PROG);
		} while(*((NEAR uint8_t*)option_byte_addr) != option_byte);
		do {
			*((NEAR uint8_t*)((uint16_t)(option_byte_addr + 1))) = (uint8_t)(~option_byte);
			FLASH_WaitForLastOperation(FLASH_MEMTYPE_PROG);
		} while(*((NEAR uint8_t*)((uint16_t)(option_byte_addr + 1))) != (uint8_t)(~option_byte));
		
		// Disable write access to option bytes
		FLASH->CR2 &= (uint8_t)(~FLASH_CR2_OPT);
		FLASH->NCR2 |= FLASH_NCR2_NOPT;

		FLASH_Lock(FLASH_MEMTYPE_DATA);
    RESET_CHIP();
	}

	option_byte_addr = OPTION_BYTE_START_PHYSICAL_ADDRESS + 5; // options
	option_byte = *((NEAR uint8_t*)option_byte_addr);
	option_byte_neg = *((NEAR uint8_t*)(option_byte_addr + 1));
	if ((option_byte != (uint8_t)(~option_byte_neg)) ||
	((option_byte & (1 << 4)) == 0)) { // check HSITRIM
		option_byte |= (1 << 4); // set HSITRIM = 1 // 4 bit on-the-fly trimming
		FLASH_Unlock(FLASH_MEMTYPE_DATA);
		FLASH->CR2 |= FLASH_CR2_OPT;
		FLASH->NCR2 &= (uint8_t)(~FLASH_NCR2_NOPT);
		// Program option byte and his complement
		do {
			*((NEAR uint8_t*)option_byte_addr) = option_byte;
			FLASH_WaitForLastOperation(FLASH_MEMTYPE_PROG);
		} while(*((NEAR uint8_t*)option_byte_addr) != option_byte);
		do {
			*((NEAR uint8_t*)((uint16_t)(option_byte_addr + 1))) = (uint8_t)(~option_byte);
			FLASH_WaitForLastOperation(FLASH_MEMTYPE_PROG);
		} while(*((NEAR uint8_t*)((uint16_t)(option_byte_addr + 1))) != (uint8_t)(~option_byte));
		
		// Disable write access to option bytes
		FLASH->CR2 &= (uint8_t)(~FLASH_CR2_OPT);
		FLASH->NCR2 |= FLASH_NCR2_NOPT;
		FLASH_Lock(FLASH_MEMTYPE_DATA);
    RESET_CHIP();
	}
}

void TIM4_Init(void)
{
	TIM4->ARR = TIM4_RELOAD;
	TIM4->PSCR = TIM4_PRSC;
	// Counter Enable
	TIM4->CR1 = TIM4_CR1_CEN;
}

void LED(uint8_t Colour)
{	
	if(Colour & LED_RED)
		LED_R_PORT->ODR &= (uint8_t)~LED_R;
	else
		LED_R_PORT->ODR |= LED_R;
		
	if(Colour & LED_GREEN)
		LED_G_PORT->ODR &= (uint8_t)~LED_G;
	else
		LED_G_PORT->ODR |= LED_G;
		
	if(Colour & LED_BLUE)
		LED_B_PORT->ODR &= (uint8_t)~LED_B;
	else
		LED_B_PORT->ODR |= LED_B;
}

void Encoder_Init(void)
{
	EXTI->CR1 = EXTI_CR1;			// Rising and falling edges
	// Encoder GPIO interrupt mask
	ENC_CLK_PORT->CR2 |=  ENC_CLK;
	// pull up on Switch
	ENC_SW_PORT->CR1 |= ENC_SW;
	
	LED(LED_OFF);
	// Check for debugger
	if(!(RST->SR & RST_SR_SWIMF))
		LED_R_PORT->DDR |= LED_R;
	
	LED_G_PORT->DDR |= LED_G;
	LED_B_PORT->DDR |= LED_B;
}

@far @interrupt void Encoder_IRQ(void)
{
	static uint8_t Encoder_Prev;
  uint8_t Enc_Status;
	
  Enc_Status = (ENC_CLK_PORT->IDR & ENC_CLK)|(ENC_DIR_PORT->IDR & ENC_DIR);	
	
  if((Encoder_Prev == ENC_DIR) && (Enc_Status == ENC_CLK))
    Encoder_--;    
  else if((!Encoder_Prev) && (Enc_Status == (ENC_CLK|ENC_DIR)))
    Encoder_++;

  Encoder_Prev = Enc_Status;
}

static uint8_t Switch_Status = SW_EDGE_MASK, Sw_Timer, Sw_State = SW_NONE, Enc_State = ENC_VOLUME;

void Encoder_Switch_Task(void)
{
	if(Sw_Timer)
		Sw_Timer--;

	// keep track of switch by storing history in a shift register
	Switch_Status <<= 1;

	if(ENC_SW_PORT->IDR & ENC_SW)
		Switch_Status |= 1;
	
	// key press state machine
	switch(Sw_State)
	{
		case SW_NONE:
			if(SW_AT_MAKE)
			{
				Sw_State = SW_PRESS;
				Sw_Timer = TIMER_CLICK_MAKE;
			}
			break;

		case SW_PRESS:
			if(!Sw_Timer)                                 // Double click times out -> Pressed
			{                                             
				if(Report_State == REPORT_RDY)              // cheat: wait for HID to be ready
				{
					Sw_State = SW_HOLD;
					Sw_Timer = TIMER_LONG;
				
					// normal click
					ReportIn[1] = (Enc_State == ENC_VOLUME)?Cmd_Mute:Cmd_Play_Pause;
					Report_State = REPORT_CMD;
				}          
			}
			else if (SW_BREAK)
			{
				Sw_State = SW_DBL_BREAK;
				Sw_Timer = TIMER_DBL_BREAK;
			}           
			break;
		
		case SW_DBL_BREAK:
			if(!Sw_Timer)                                 // break is too long, treat it as no pressed
				Sw_State = SW_NONE;
			else if(SW_AT_MAKE)
				Sw_State = SW_DBL_CLICK; 
			break;

		case SW_DBL_CLICK:
			// double click switches operating mode
			Enc_State = !Enc_State;
			LED(Enc_State==ENC_VOLUME?LED_OFF:LED_GREEN);
			
			Sw_Timer = TIMER_LONG;
			Sw_State = SW_BREAK_WAIT;        
			break;
		
		case SW_HOLD:
			if(!Sw_Timer)                                 // Long press
			{
				if(Report_State == REPORT_RDY)              // cheat: wait to HID to be ready
				{
					ReportIn[1] = (Enc_State == ENC_VOLUME)?Cmd_Play_Pause:Cmd_Stop;
					Sw_State = SW_BREAK_WAIT;          
					Report_State = REPORT_CMD;
				}                     
			}
			else if (SW_BREAK)
				Sw_State = SW_NONE;
			break;
			
		case SW_BREAK_WAIT:
			if (SW_BREAK)
				Sw_State = SW_NONE;
		break;                
	} 
}

void Encoder_Task(void)
{
  if(Report_State == REPORT_RDY)
  {
    if(Encoder_)              // Update Encoder from IRQ value
    {
      uint8_t Encoder_IRQ;
      
      sim();                  // disable interrupt and gain access to Encoder_Count
      Encoder_IRQ = Encoder_; // Keep it very short
      Encoder_ = 0;
			rim();
      
      Encoder += Encoder_IRQ;
    }
    
    // report delta value as a series of Inc/Dec events
    if(Encoder >0)
    {
      Encoder--;
      ReportIn[1]|= (Enc_State == ENC_VOLUME)?Cmd_Volume_Up:Cmd_Next_Track;
      Report_State = REPORT_CMD;
    }
    else if (Encoder <0)
    {
      Encoder++;
      ReportIn[1]|= (Enc_State == ENC_VOLUME)?Cmd_Volume_Down:Cmd_Prev_Track;
      Report_State = REPORT_CMD;
    }
  }    
}    

void HID_Task(void)
{
  if ((Report_State != REPORT_RDY) && USB_Tx_Ready(1))
  {
    switch(Report_State)
    {
      case REPORT_CMD:
				USB_Send_Data(ReportIn,REPORT_SIZE,1);
        Report_State = REPORT_CMD_RELEASE;
        break;
        
      case REPORT_CMD_RELEASE:
        // clear all bits in report
        ReportIn[1] = 0;
				USB_Send_Data(ReportIn,REPORT_SIZE,1);
        Report_State = REPORT_RDY;
        break;
    }
  }
}

void Short_Delay(void)
{
		_asm("nop");
		_asm("nop");
		_asm("nop");
		_asm("nop");
		_asm("nop");	
		_asm("nop");		
}

// Use US_DELAY(X) to set value in us.  Maximum is ~104ms
void Delay(uint16_t t)
{
	for(;t;t--)
		Short_Delay();
}
