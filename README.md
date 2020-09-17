# STM8 HID Multimedia Dial

This is a USB HID with a rotatory encoder. This is used to supplement old keyboard layouts by providing a more natural alternative.

Details: https://hw-by-design.blogspot.com/2018/07/hid-multimedia-dial.html

This is a port of my [HID Dial project](https://github.com/FPGA-Computer/HID-Multimedia-Dial) (ATMega8) to STM8S003 using STM8 VUSB library.

# STM8 VUSB

The firmware only USB stack is an unofficial fork from STM8S-VUSB-KEYBOARD at https://github.com/BBS215/STM8S-VUSB-KEYBOARD

- Works with current special edition of Cosmic C (4.4.10) and current version of STVD (4.3.12)

- USB stack logic is modified for this tech demo. HID is now working.

- Code reformatted/refractored.  Using my own IRQ files for STM8S003 for a much cleaner organization. Some code logic changed.

- No longer need a separate GPIO for the 1.5K pull up to connect/disconnect USB.  See schematic.

- Device library calls have been changed to bare metal to minimized dependancy and reduce code size.  stm8s_flash.c is the only library needed.

Note: 

The USB stack calibrates the HSI clock while connected to the PC. The calibration is store in EEPROM. It can take a couple of minutes the first time before it functions correctly.

Timer 1 is used by the USB stack for filtering and interrupt. It is not actually used for counting.

Install a 10K into R1 and 3 0.1uF capacitors to the Rotary Encoder module (made in China).