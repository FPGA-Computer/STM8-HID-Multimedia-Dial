#ifndef USB_CONFIG_H_
#define USB_CONFIG_H_

/// SETTINGS ///////////////////////////////////////////////
#define USB_MAX_NUM_CONFIGURATION 	1 // device configuration
#define USB_MAX_NUM_INTERFACES 			1 // device interfaces
#define USB_SELF_POWERED						0 // 0 - power from USB, 1 - dedicated power supply
#define USB_CLOCK_HSI								1	// 0 - external frequency to 16 MHz (PA1, PA2); 1 - from the internal RC generator (HSI)
#define USB_CONNECT_TIMEOUT					700 // connection timeout before reset // 100Hz * 7 sec = 700
#define USB_RECONNECT_DELAY					100 // 100Hz * 1 sec = 100

#define USB_RESET_DELAY							2000		// time to detect "USB RESET" // 5-7ms
//#define USB_EP_WATCHDOG_ENABLE			1 		// when EP is unavailable
#define USB_EP_WATCHDOG_TIMEOUT			300 		// timeout 3 sec
#define USB_EP_WATCHDOG_RECONNECT_DELAY	100 // Delay between switching off and on // 100Hz * 1 sec = 100

#define EEPROM_START_ADDR						0x4000 	// EEPROM location where the HSI flask and HSITRIM value are written (2 bytes)

#define MAGIC_VAL										0x11 		// HSI setup flag. If the EEPROM contains a different value, the HSI setting will start at zero.

// Optional features
#define USB_CFG_HID_DESCRIPTORS							// handle USB HID descriptors
//#define USB_CFG_FEATURES_SUPPORT					// Support Set/Clear feature


#endif
