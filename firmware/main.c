#include "main.h"
#include "usb.h"
#include "hardware.h"

/*
	USB_EP0_RxReady_callback is pre-assigned for data processing,
	EP0 in the Data stage process.
*/

void USB_EP0_RxReady_callback(uint8_t *p_data, uint8_t length)
{
}

/*
USB_Class_Init_callback is called upon initiation
USB powered device.
*/
int8_t USB_Class_Init_callback(uint8_t dev_config)
{
	return 0;
}

/*
	USB_Class_DeInit_callback is called upon reset.
	USB powered device.
*/
int8_t USB_Class_DeInit_callback(void)
{
	return 0;
}

/*
	USB_Setup_Request_callback is called for processing USB requests,
	Not included in the standard USB stack.
*/

int8_t USB_Setup_Request_callback(t_USB_SetupReq *p_req)
{	
	// HID Class GetReport
  if (((p_req->bmRequest&USB_REQ_TYPE_MASK)==USB_REQ_TYPE_CLASS) && 
			(p_req->bRequest==HID_REQ_GET_REPORT))
  { 
		// send empty packet
		USB_Send_Data(NULL,0,0); 
	}

	return -1;
}

/*
	USB_EP1_RxReady_callback is pre-assigned for data processing,
  Pins EP1. In this example, it is not used.
*/
void USB_EP1_RxReady_callback(uint8_t *p_data, uint8_t length)
{
	// Nothing. Really.
}

/// MAIN ///////////////////////////////////////////////////

void main(void)
{
	uint8_t counter = TIM4_CNTMAX;
	
	Init_Hardware();

	while(1)
	{
		USB_loop(); // A "quick" USB loop for processing requests
		HID_Task();

		if (TIM4->SR1 && TIM4_SR1_UIF)	// poll for TIM4 update
		{ 
			// clear update flag
			TIM4->SR1 = (uint8_t) ~TIM4_SR1_UIF;
			
			if (counter)
			{
				counter--;
				
				if(!counter)
				{
					// 100Hz call at different clock phase
					Encoder_Task();				
					Encoder_Switch_Task();
				}			
			}
			else
			{	// 100 Hz call
				USB_slow_loop(); // "slow" USB loop for setting HSI generator and EP1 watchdog
				counter = TIM4_CNTMAX;		
			}
		}
	}
}
