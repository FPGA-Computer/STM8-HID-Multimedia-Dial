/*
 * hardware.h
 *
 * Created: October 31, 2019, 12:33:01 PM
 *  Author: K. C. Lee
 * Copyright (c) 2019 by K. C. Lee
 
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

#ifndef __CSMC__
#define __CSMC__
#endif
#ifndef STM8S003
#define STM8S003
#endif

#ifndef HARDWARE_H_
#define HARDWARE_H_

#include "stm8s.h"
#include <stdio.h>

// STM8S003F3P6
enum _PA { PA1=0x02, PA2=0x04, PA3=0x08 };
enum _PB { PB4=0x10, PB5=0x20 };
enum _PC { PC3=0x08, PC4=0x10, PC5=0x20, PC6=0x40, PC7=0x80 };
enum _PD { PD1=0x02, PD2=0x04, PD3=0x08, PD4=0x10, PD5=0x20, PD6=0x40 };

#define GPIO(X)					((GPIO_TypeDef *)(X))

#define CPU_CLOCK				16000000UL
#define EE_Addr					0x4000

enum _OPT2 { AFR0 = 0x01, AFR1=0x02, AFR2=0x04, AFR3=0x08, AFR4=0x10, AFR5=0x20, AFR6=0x40, AFR7 = 0x80 };
enum _OPT3 { HSITRIM = 0x10, LSI_EN = 0x08, IWDG_HW = 0x04, WWDG_HW = 0x02, WWDG_HALT = 0x01 };

#define FLASH_RASS_KEY1 ((uint8_t)0x56) /*!< First RASS key */
#define FLASH_RASS_KEY2 ((uint8_t)0xAE)

#define TIM4_PRSC				7
#define TIM4_FREQ				500
#define TIM4_Slow				100
#define TIM4_RELOAD			(CPU_CLOCK/(1<<TIM4_PRSC)/TIM4_FREQ)
#define TIM4_CNTMAX			(TIM4_FREQ/TIM4_Slow)

#define LED_R_PORT			GPIOD
#define LED_R						PD1
#define LED_G_PORT			GPIOB
#define LED_G						PB5
#define LED_B_PORT			GPIOB
#define LED_B						PB4

enum _LED
{
	LED_OFF = 0x00,	LED_RED = 0x01, LED_GREEN = 0x02, LED_BLUE = 0x04,
	LED_YELLOW = LED_RED|LED_GREEN, 
	LED_MAGENTA = LED_RED|LED_BLUE,
	LED_AQUA = LED_GREEN|LED_BLUE, 
	LED_WHITE = LED_RED|LED_GREEN|LED_BLUE
};

#define ENC_PORT				GPIOC
#define ENC_CLK					PC5
#define ENC_DIR					PC4
#define ENC_SW_PORT			GPIOC
#define ENC_SW					PC3

#define EXTI_CR1				0x30

extern volatile uint8_t TIM4_Update_Flag;


// Delays in us.  The delay has been calibrated for 16MHz
// Maximum delay is about 100ms (16-bit)

#define DELAY_TWEAK			0.63
#define US_DELAY(X)			((uint16_t)(X*DELAY_TWEAK))

// Switch status is a shift register that shift left every 16.38ms
#define SW_RISING_EDGE        0x07      // 00000111  <- turned high for 49ms 
#define SW_FALLING_EDGE       0xf8      // 11111000  <- turned low for 49ms 
#define SW_EDGE_MASK          0x0f
#define SW_DEBOUNCE_MASK      0x03

#define SW_AT_MAKE            ((Switch_Status & SW_EDGE_MASK) == (SW_FALLING_EDGE & SW_EDGE_MASK))
#define SW_AT_BREAK           ((Switch_Status & SW_EDGE_MASK) == (SW_RISING_EDGE & SW_EDGE_MASK))
#define SW_MAKE               ((Switch_Status & SW_DEBOUNCE_MASK) == (SW_FALLING_EDGE & SW_DEBOUNCE_MASK))
#define SW_BREAK              ((Switch_Status & SW_DEBOUNCE_MASK) == (SW_RISING_EDGE & SW_DEBOUNCE_MASK))

#define ms_TO_TICKS(X)				((X)/10)

#define TIMER_DBL_BREAK       ms_TO_TICKS(250)
#define TIMER_CLICK_MAKE		  ms_TO_TICKS(150)
#define TIMER_LONG            ms_TO_TICKS(400)

enum SW_STATE
{
  SW_NONE, SW_PRESS, SW_DBL_BREAK, SW_DBL_CLICK, SW_HOLD, SW_BREAK_WAIT
 };

enum ENC_STATES
{
  ENC_VOLUME, ENC_PLAYCTRL
 };

#define ENC_LAST  ENC_PLAYCTRL
#define ENC_FIRST ENC_VOLUME 

#define REPORT_SIZE		    2

enum REPORT_ID
{
  ID_CONSUMER = 0x01
 };

#define ENC_LAST  ENC_PLAYCTRL
#define ENC_FIRST ENC_VOLUME 

enum REPORT_STATE
{
  REPORT_RDY, REPORT_CMD_RELEASE, REPORT_CMD
 };

enum REPORT_BITMAP
{
  Cmd_Next_Track =0x01, Cmd_Prev_Track = 0x02, Cmd_Stop = 0x04, Cmd_Play_Pause = 0x08, 
  Cmd_Mute = 0x10, Cmd_Volume_Up = 0x20, Cmd_Volume_Down = 0x40
 };

void Init_Hardware(void);
void RESET_CHIP(void);
void Check_OPTION_BYTE(void);
void TIM4_Init(void);
void Delay(uint16_t t);
void LED(uint8_t Colour);
void Encoder_Init(void);
void Encoder_Switch_Task(void);
void Encoder_Task(void);
void HID_Task(void);
void FLASH_Data_lock(uint8_t lock);
void FLASH_Wait(void);
#endif
