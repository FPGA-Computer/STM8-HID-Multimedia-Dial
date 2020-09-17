/*
 * irq.h
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

// IRQ handler in assembly as xdef	_ll_usb_rx

void ll_usb_rx(void);
#define IRQ12 ((void @far (*)(void))ll_usb_rx)

@far @interrupt void Encoder_IRQ(void);

// IRQ on pin encoder Clk change
#if (ENC_CLK_PORT==GPIOB)
#define IRQ4 Encoder_IRQ
#endif
#if (ENC_CLK_PORT==GPIOC)
#define IRQ5 Encoder_IRQ
#endif
#if (ENC_CLK_PORT==GPIOD)
#define IRQ6 Encoder_IRQ
#endif

