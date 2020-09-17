#include "usb.h"

const unsigned char usb_device_descriptor[SIZE_DEVICE_DESCRIPTOR] =
{
	SIZE_DEVICE_DESCRIPTOR, // Size of the Descriptor in Bytes
	USB_DESC_TYPE_DEVICE, // Device Descriptor (0x01)
	0x10, 
	0x01, // USB 1.1 = 0x0110; USB 1.0 = 0x0100
	0x00, // Class Code
	0x00, // Subclass Code
	0x00, // Protocol Code
	0x08, // Maximum Packet Size for Zero Endpoint
	0xc0, // VID_L
	0x16, // VID_H
	0xdf, // PID_L
	0x05,	// PID_H
	0x00, // bcdDevice rel. 2.00
	0x02,	// bcdDevice rel. 2.00
	0x01, // Index of Manufacturer String Descriptor
	0x02, // Index of Product String Descriptor
	0x03, // Index of Serial Number String Descriptor
	0x01, // Number of Possible Configurations
};

const unsigned char usb_configuration_descriptor[SIZE_CONFIGURATION_DESCRIPTOR] =
{ 
	0x09, // Size of Descriptor in Bytes
	USB_DESC_TYPE_CONFIGURATION, // Configuration Descriptor (0x02)
	LOBYTE(SIZE_CONFIGURATION_DESCRIPTOR), // Total length of config desc in bytes - LO
	HIBYTE(SIZE_CONFIGURATION_DESCRIPTOR), // Total length of config desc in bytes - HI
	0x01, // Number of Interfaces
	0x01, // Value to use as an argument to select this configuration
	0x00, // Index of String Descriptor describing this configuration
#if (USB_SELF_POWERED == 1)
	0xC0, // D7 Reserved, set to 1.(USB 1.0 Bus Powered),D6 Self Powered,D5 Remote Wakeup,D4..0 Reserved, set to 0.
#else
	0x80, // D7 Reserved, set to 1.(USB 1.0 Bus Powered),D6 Self Powered,D5 Remote Wakeup,D4..0 Reserved, set to 0.
#endif
	0x05, // Maximum Power Consumption in 2mA units

	// Interface descriptor
	0x09, // Size of Descriptor in Bytes (9 Bytes)
	USB_DESC_TYPE_INTERFACE, // Interface Descriptor (0x04)
	1, 		// Number of Interface
	0x00, // Value used to select alternative setting
	0x01, // Number of Endpoints used for this interface
	0x03, // Class Code
	0x00, // Subclass Code
	0x00, // Protocol Code
	0x00, // Index of String Descriptor Describing this interface

	// HID descriptor
	SIZE_HID_DESCRIPTOR, // Size of Descriptor in Bytes (9 Bytes)
	TYPE_HID_DESCRIPTOR, // HID descriptor (0x21)
	0x10, // BCD representation of HID version - LO
	0x01, // BCD representation of HID version - HI
	0x00, // Target country code
	0x01, // Number of HID Report (or other HID class) Descriptor infos to follow
	TYPE_REPORT_DESCRIPTOR, // Descriptor type: report
	LOBYTE(SIZE_REPORT_DESCRIPTOR), // total length of report descriptor - LO
	HIBYTE(SIZE_REPORT_DESCRIPTOR),  // total length of report descriptor - HI

	// Endpoint descriptor
	0x07, // Size of Descriptor in Bytes (7 Bytes)
	USB_DESC_TYPE_ENDPOINT, // Endpoint descriptor (0x05)
	0x81, // IN endpoint number 1 (0x81)
	0x03, // attrib: Interrupt endpoint
	0x08, // maximum packet size - LO
	0x00, // maximum packet size - HI
	0x0a, // poll interval (ms)
};

const unsigned char String_LangID[SIZE_STRING_LANGID] = {
	SIZE_STRING_LANGID,
	USB_DESC_TYPE_STRING,
	0x09, 0x04	//En-US
};

const unsigned char String_Vendor[SIZE_STRING_VENDOR] =
{
    SIZE_STRING_VENDOR, // Size of Vendor string
    USB_DESC_TYPE_STRING,  // bDescriptorType
		'h',0,'w',0,'-',0,'b',0,'y',0,'-',0,'d',0,'e',0,'s',0,'i',0,
		'g',0,'n',0,'.',0,'b',0,'l',0,'o',0,'g',0,'s',0,'p',0,'o',0,
		't',0,'.',0,'c',0,'o',0,'m',0
};

const uint8_t String_Product[SIZE_STRING_PRODUCT] =
{
    SIZE_STRING_PRODUCT,USB_DESC_TYPE_STRING,	// bLength,bDescriptorType
		'H',0,'I',0,'D',0,' ',0,'M',0,'u',0,'l',0,'t',0,'i',0,'m',0,
		'e',0,'d',0,'m',0,'i',0,'a',0,' ',0,'D',0,'i',0,'a',0,'l',0
};

const unsigned char String_Serial[SIZE_STRING_SERIAL] =
{
    SIZE_STRING_SERIAL,           // bLength
    USB_DESC_TYPE_STRING,       // bDescriptorType
    '0',0,'0',0,'0',0,'2',0
};

const unsigned char* USB_String_Descriptors[LENGTH_STRING_DESCRIPTOR] = {
	String_LangID,
	String_Vendor,
	String_Product,
	String_Serial
};

const unsigned char USB_String_Descriptors_Length[LENGTH_STRING_DESCRIPTOR] = {
	SIZE_STRING_LANGID,
	SIZE_STRING_VENDOR,
	SIZE_STRING_PRODUCT,
	SIZE_STRING_SERIAL
};

// generated from HID Descriptor Tool (DT): http://www.usb.org/developers/hidpage/dt2_4.zip

const unsigned char HID_ReportDescriptor[SIZE_REPORT_DESCRIPTOR] =
 {
    0x05, 0x0c,                    // USAGE_PAGE (Consumer Devices)
    0x09, 0x01,                    // USAGE (Consumer Control)
    0xa1, 0x01,                    // COLLECTION (Application)
    0x85, 0x01,                    //   REPORT_ID (1)
    0x15, 0x00,                    //   LOGICAL_MINIMUM (0)
    0x25, 0x01,                    //   LOGICAL_MAXIMUM (1)
    0x75, 0x01,                    //   REPORT_SIZE (1)
    0x95, 0x04,                    //   REPORT_COUNT (4)
    0x19, 0xb5,                    //   USAGE_MINIMUM (Scan Next Track)
    0x29, 0xb7,                    //   USAGE_MAXIMUM (Stop)
    0x09, 0xcd,                    //   USAGE (Unassigned)
    0x81, 0x02,                    //   INPUT (Data,Var,Abs)
    0x95, 0x01,                    //   REPORT_COUNT (1)
    0x09, 0xe2,                    //   USAGE (Mute)
    0x81, 0x06,                    //   INPUT (Data,Var,Rel)
    0x95, 0x02,                    //   REPORT_COUNT (2)
    0x09, 0xe9,                    //   USAGE (Volume Up)
    0x09, 0xea,                    //   USAGE (Volume Down)
    0x81, 0x02,                    //   INPUT (Data,Var,Abs)
    0x95, 0x01,                    //   REPORT_COUNT (1)
    0x81, 0x03,                    //   INPUT (Cnst,Var,Abs)
    0xc0                           // END_COLLECTION
  };

