#include "usb.h"

#define BIT(NUMBER)						(1 << (NUMBER))

uint8_t ll_usb_rx_buffer[16];
uint8_t* ll_usb_tx_buffer_pointer;
uint8_t ll_usb_tx_count;
uint8_t ll_usb_rx_count;
struct usb_type usb;

#if (USB_CLOCK_HSI == 1)
uint8_t *p_HSI_TRIM_VAL = (uint8_t*)EEPROM_START_ADDR;
uint8_t *p_HSI_TRIMING_DONE = (uint8_t*)(EEPROM_START_ADDR + 1);
#endif

extern void ll_usb_tx(void); // from usb_tx.s

void USB_Reset(void)
{
	if (usb.dev_state == USB_STATE_CONFIGURED) 
		USB_Class_DeInit_callback();
		
	usb.device_address = 0;
	usb.setup_address  = 0;
	usb.dev_state = USB_STATE_DEFAULT;
	usb.stage = USB_STAGE_NONE;
	usb.dev_config = 0;
	usb.active_EP_num = 0;
	usb.reset_counter = 0;
	usb.EP[0].tx_length = 0;
	usb.EP[0].rx_length = 0;
	usb.EP[0].rx_state = USB_EP_NO_DATA;
	usb.EP[0].tx_state = USB_EP_NO_DATA;
	usb.EP[1].tx_length = 0;
	usb.EP[1].rx_length = 0;
	usb.EP[1].rx_state = USB_EP_NO_DATA;
	usb.EP[1].tx_state = USB_EP_NO_DATA;
}

void USB_Init(void)
{
#if (USB_CLOCK_HSI == 1)
	usb.delay_counter = 0;
	
	if (*p_HSI_TRIMING_DONE == MAGIC_VAL)
		usb.trimming_stage = HSI_TRIMMER_DISABLE;
	else
		usb.trimming_stage = HSI_TRIMMER_ENABLE;
		
	usb.HSI_Trim_val = (uint8_t)(*p_HSI_TRIM_VAL & 0x0F);
	CLK->HSITRIMR = (uint8_t)((CLK->HSITRIMR & (~0x0F)) | usb.HSI_Trim_val);
#else
	//CLK_ClockSwitchConfig(CLK_SWITCHMODE_AUTO, CLK_SOURCE_HSE, DISABLE, CLK_CURRENTCLOCKSTATE_DISABLE); // 16 MHz external XTAL
	
	// Switch clock enable
	CLK->SWCR |= CLK_SWCR_SWEN;
	// Select HSE
	CLK->SWR = 0xb4;
	// wait for switching
	while(CLK->SWCR & CLK_SWCR_SWBSY)
	  /* */ ;
#endif

	usb.dev_state = USB_STATE_DEFAULT;
#if (USB_EP_WATCHDOG_ENABLE == 1)
	usb.WDG_EP_timeout = USB_EP_WATCHDOG_TIMEOUT+1;
#endif

	USB_Reset();

	// Init TIMER1
	// CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, ENABLE);
	
	// TIM1_TimeBaseInit(0, TIM1_PSCRELOADMODE_UPDATE, 1000, 0);  //
	// dead code as TIM1 is actually not counting!
	//TIM1->ARRH = 1000 >>8;
	//TIM1->ARRL = 1000 & 0xff;
	
	// TIM1_ICInit(TIM1_CHANNEL_2, TIM1_ICPOLARITY_FALLING, TIM1_ICSELECTION_DIRECTTI,TIM1_ICPSC_DIV1, 0x02); // ������ ������� �� ����� USB D-
	// CH2:Falling edge, capture enable
	TIM1->CCER1 = TIM1_CCER1_CC2P|TIM1_CCER1_CC2E;
	// CH2:fs=fMaster, N=4, input, IC1 is mapped on TI1FP1
	TIM1->CCMR2 = 0x21;

	// TIM1_SelectInputTrigger(TIM1_TS_TI2FP2);
	// TIM1_SelectSlaveMode(TIM1_SLAVEMODE_TRIGGER);
	//  Filtered timer input 2 (TI2FP2), Trigger standard mode
	TIM1->SMCR = 0x66;
	
	//TIM1_ClearFlag(TIM1_FLAG_CC2);
	
	//TIM1_ITConfig(TIM1_IT_CC2, ENABLE);
	TIM1->IER = TIM1_IER_CC2IE;
	
	// TIM1 is not counting!!
	
}

void USB_connect(void)
{
	// Set D- to input
	USB_PORT->DDR &= (uint8_t)~USB_DM;
}

void USB_disconnect(void)
{
	// Set D- to Low
	USB_PORT->ODR &= (uint8_t)~USB_DM;
	// Set D- to output
	USB_PORT->DDR |= USB_DM;	
}

// consolidate common GPIO code for send in ll_usb_tx(); (usb_tx.S)
@inline void usb_send_nack(void)
{
	const uint8_t data[2] = {USB_SYNC_BYTE, USB_PID_NACK};

	ll_usb_tx_count = 2;
	ll_usb_tx_buffer_pointer = data;
	ll_usb_tx();
}

@inline void usb_send_ack(void)
{
	const uint8_t data[2] = {USB_SYNC_BYTE, USB_PID_ACK};
	
	ll_usb_tx_count = 2;
	ll_usb_tx_buffer_pointer = data;
	ll_usb_tx();
}

@inline void usb_send_packet(uint8_t EP_num)
{
	ll_usb_tx_count = usb.EP[EP_num].tx_length;
	ll_usb_tx_buffer_pointer = usb.EP[EP_num].tx_buffer;
	ll_usb_tx();
}

@inline void usb_copy_rx_packet(uint8_t EP_num)
{
	usb.EP[EP_num].rx_buffer[0] = ll_usb_rx_buffer[2];
	usb.EP[EP_num].rx_buffer[1] = ll_usb_rx_buffer[3];
	usb.EP[EP_num].rx_buffer[2] = ll_usb_rx_buffer[4];
	usb.EP[EP_num].rx_buffer[3] = ll_usb_rx_buffer[5];
	usb.EP[EP_num].rx_buffer[4] = ll_usb_rx_buffer[6];
	usb.EP[EP_num].rx_buffer[5] = ll_usb_rx_buffer[7];
	usb.EP[EP_num].rx_buffer[6] = ll_usb_rx_buffer[8];
	usb.EP[EP_num].rx_buffer[7] = ll_usb_rx_buffer[9];
	usb.EP[EP_num].rx_buffer[8] = ll_usb_rx_buffer[10];
}

void usb_rx_ok(void)
{
	switch (ll_usb_rx_buffer[1])
	{
		case USB_PID_SETUP:
			if ((ll_usb_rx_buffer[2] & 0x7F) == usb.device_address)
			{
				usb.stage = USB_STAGE_SETUP;
				usb.active_EP_num = 0;//(usb_rx_buffer[2] & 0x80)?1:0;
			}
			else
				usb.stage = USB_STAGE_NONE;
			break;
		
		case USB_PID_OUT:
			if ((ll_usb_rx_buffer[2] & 0x7F) == usb.device_address)
			{
				usb.stage = USB_STAGE_OUT;
				usb.active_EP_num = (uint8_t)((ll_usb_rx_buffer[2] & 0x80)?1:0);
			}
			else
				usb.stage = USB_STAGE_NONE;
			break;
		
		case USB_PID_IN:
			if ((ll_usb_rx_buffer[2] & 0x7F) == usb.device_address)
			{
				usb.active_EP_num = (uint8_t)((ll_usb_rx_buffer[2] & 0x80)?1:0);
				if (usb.EP[usb.active_EP_num].tx_state == USB_EP_DATA_READY)
				{
					usb_send_packet(usb.active_EP_num);
					usb.EP[usb.active_EP_num].tx_state = USB_EP_NO_DATA;
					
					if (usb.setup_address)
					{
						usb.device_address = usb.setup_address;
						usb.setup_address = 0;
					}
				}
				else
				{
					usb_send_nack();
				}
#if (USB_EP_WATCHDOG_ENABLE == 1)
				if (usb.WDG_EP_timeout > 0) usb.WDG_EP_timeout = 0;
#endif
			}
			usb.stage = USB_STAGE_NONE;
			break;
		
		case USB_PID_DATA0: // Data received
		case USB_PID_DATA1: // Data received
			if (usb.stage != USB_STAGE_NONE)
			{
				if (usb.EP[usb.active_EP_num].rx_state == USB_EP_NO_DATA) // if EP ready
				{
					usb.EP[usb.active_EP_num].rx_state = USB_EP_DATA_READY;
					usb_send_ack();
					
					if (usb.active_EP_num == 0)
						usb.EP0_data_stage = usb.stage; // USB_STAGE_SETUP or USB_STAGE_OUT
						
					usb.EP[usb.active_EP_num].rx_length = (uint8_t)(14 - ll_usb_rx_count);
					if (usb.EP[usb.active_EP_num].rx_length > 3)
					{
						usb.EP[usb.active_EP_num].rx_length -= 3; // 1..9
						usb_copy_rx_packet(usb.active_EP_num);
					}
					else
						usb.EP[usb.active_EP_num].rx_length = 0;
				}
				usb.stage = USB_STAGE_NONE;
			}
			break;

		//case USB_PID_ACK:
		//case USB_PID_NACK:		
		default:
			break;
	}
#if (USB_CLOCK_HSI == 1)
	if (usb.trimming_stage == HSI_TRIMMER_ENABLE)
		usb.trimming_stage = HSI_TRIMMER_STARTED;
#endif
}

void usb_calc_crc16(uint8_t * buffer, uint8_t length)
{
	uint16_t crc = 0xFFFF;
	uint8_t i;

	for (;length;length--)
	{
		crc ^= *buffer++;

		for (i = 8; i--;)
		{
			if ((crc & BIT(0)) != 0)
			{
				crc >>= 1;
				crc ^= 0xA001;
			}
			else
			{
				crc >>= 1;
			}
		}
	}

	crc = ~crc;

	*buffer++ = (uint8_t) crc;
	*buffer = (uint8_t) (crc >> 8);
}

int8_t USB_Send_Data(uint8_t * buffer, uint16_t length, uint8_t EP_num)
{
	uint8_t i;
	uint8_t flag = 0;
	uint16_t timeout = 30000;
	
	if (EP_num == 0)
	{ // EP 0 - CONTROL
		//while (usb.EP[0].tx_state == USB_EP_DATA_READY) {} // wait for prev transmission 
		while ((usb.EP[0].tx_state == USB_EP_DATA_READY)&&(timeout)) // wait for prev transmission 
		{ timeout--;
		}
		if (timeout == 0)
		{
			usb.EP[0].tx_state = USB_EP_NO_DATA; // drop old packet

#if (USB_EP_WATCHDOG_ENABLE == 1)
			USB_disconnect();
			USB_Reset();
			usb.WDG_EP_timeout = -USB_EP_WATCHDOG_RECONNECT_DELAY;
			return -1;
#endif

		}
		
		usb.EP[0].tx_data_sync = USB_PID_DATA1;
	} 
	else
	{ // EP 1 - INTR
		if (usb.dev_state != USB_STATE_CONFIGURED)
			return -2;
		if (length > 8) 
			return -3; 				// 8 bytes max for INTR EP
			
		//usb.EP[1].tx_state = USB_EP_NO_DATA; // drop old packet
		if (usb.EP[1].tx_state != USB_EP_NO_DATA)
			return -4;
	}
	
	if (length == 0)
		flag = 1;	// Just send an empty packet
	else
		while (length > 0)
		{
			usb.EP[EP_num].tx_buffer[0] = USB_SYNC_BYTE;
			usb.EP[EP_num].tx_buffer[1] = usb.EP[EP_num].tx_data_sync;
			
			if ((length == 8)&&(EP_num == 0)) 
				flag = 1;	// If the length of last DATA packet is 8, then finialize the transaction by an empty packet
			
			if (length > 8)
			{
				usb.EP[EP_num].tx_length = 12; // 2+8+2
	
				for (i = 2; i < 10; i++)
					usb.EP[EP_num].tx_buffer[i] = *buffer++;
					
				length -= 8;
			}
			else
			{
				usb.EP[EP_num].tx_length = (uint8_t)(4 + length);

				for (i = 2; i < 2 + length; i++)
					usb.EP[EP_num].tx_buffer[i] = *buffer++;
					
				length = 0;
			}
	
			// calculate CRC
			usb_calc_crc16(&usb.EP[EP_num].tx_buffer[2], (uint8_t) (usb.EP[EP_num].tx_length - 4));
	
			// toggle data0 data1
			if (usb.EP[EP_num].tx_data_sync == USB_PID_DATA1) 
				usb.EP[EP_num].tx_data_sync = USB_PID_DATA0;
			else
				usb.EP[EP_num].tx_data_sync = USB_PID_DATA1;
	
			// data is available to send out 
			usb.EP[EP_num].tx_state = USB_EP_DATA_READY;
			// wait for transmission and then start the next
			if (EP_num == 0)
			{
				//while (usb.EP[EP_num].tx_state == USB_EP_DATA_READY) {}
				timeout = 60000;
				while ((usb.EP[0].tx_state == USB_EP_DATA_READY)&&(timeout)) // wait for prev transmission 
				{ timeout--;
				}
				
				if (!timeout)
				{
					usb.EP[0].tx_state = USB_EP_NO_DATA; // drop old packet
	
	#if (USB_EP_WATCHDOG_ENABLE == 1)
					USB_disconnect();
					USB_Reset();
					usb.WDG_EP_timeout = -USB_EP_WATCHDOG_RECONNECT_DELAY;
					return -1;
	#endif
				}
			}
		}
	
	if (flag)
	{ // Send an empty packet
		usb.EP[EP_num].tx_length = 4;
		usb.EP[EP_num].tx_buffer[0] = USB_SYNC_BYTE;
		usb.EP[EP_num].tx_buffer[1] = usb.EP[EP_num].tx_data_sync;
		usb.EP[EP_num].tx_buffer[2] = 0;
		usb.EP[EP_num].tx_buffer[3] = 0;
	
		if (usb.EP[EP_num].tx_data_sync == USB_PID_DATA1)
			usb.EP[EP_num].tx_data_sync = USB_PID_DATA0;
		else
			usb.EP[EP_num].tx_data_sync = USB_PID_DATA1;
	
		usb.EP[EP_num].tx_state = USB_EP_DATA_READY;
	}
	return 0;
}

void USB_Send_STALL(uint8_t EP_num)
{
	usb.EP[EP_num].tx_length = 2;
	usb.EP[EP_num].tx_buffer[0] = USB_SYNC_BYTE;
	usb.EP[EP_num].tx_buffer[1] = USB_PID_STALL;
	usb.EP[EP_num].tx_state = USB_EP_DATA_READY;
}

@inline void usb_control_error(void)
{
	USB_Send_STALL(0);
}

void USB_NRZI_RX_Decode(uint8_t *p_data, uint8_t length)
{
	uint8_t i,j;
	uint8_t byte;
	uint16_t word = p_data[0] << 8;
	uint8_t offset = 0;
	uint8_t cnt = 0;
	
	for(i=0; i<length; i++) 
	{
		word >>=8;
		word |= (p_data[i+1] << 8);
		byte = 0;
	
		for(j=0;j<8;j++) 
		{
			if (word & (1 << (j+offset)))
			{
				byte |= (uint8_t)(1 << j);
				cnt++;
				
				if (cnt == 6)
				{
					offset++;
					cnt=0;
				}
			} 
			else
			{
				cnt=0;
			}
		}
		p_data[i] = byte;
	}
}

void USB_Device_Request(t_USB_SetupReq *p_USB_SetupReq)
{
	switch (p_USB_SetupReq->bRequest)
	{			
		case USB_REQ_SET_ADDRESS:	// SET_ADDRESS
		
			if ((p_USB_SetupReq->wIndex_LO == 0) && 
					(p_USB_SetupReq->wLength_LO == 0) &&
					(usb.dev_state != USB_STATE_CONFIGURED))
			{
				usb.setup_address = (uint8_t)(p_USB_SetupReq->wValue_LO & 0x7F);
				USB_Send_Data(NULL, 0, 0);
				
				if (usb.setup_address)
					usb.dev_state  = USB_STATE_ADDRESSED;
				else
					usb.dev_state  = USB_STATE_DEFAULT; 
			}
			else
			{
				usb_control_error();
			}

			break;
			
		case USB_REQ_SET_CONFIGURATION:	// SET_CONFIGURATION
			if (p_USB_SetupReq->wValue_LO <= USB_MAX_NUM_CONFIGURATION)
			{
				switch (usb.dev_state)
				{
					case USB_STATE_ADDRESSED:
					
						if (p_USB_SetupReq->wValue_LO) 
						{
							usb.dev_config = p_USB_SetupReq->wValue_LO; // set new configuration
							usb.dev_state = USB_STATE_CONFIGURED;
							
							if (USB_Class_Init_callback(usb.dev_config) < 0)
								usb_control_error();
							else
								USB_Send_Data(NULL, 0, 0);
								
#if (USB_CLOCK_HSI == 1)
							if (usb.trimming_stage == HSI_TRIMMER_STARTED) 
								usb.trimming_stage = HSI_TRIMMER_WRITE_TRIM_VAL;
#endif
						}
						else
						{
							USB_Send_Data(NULL, 0, 0);
						}
						break;
						
					case USB_STATE_CONFIGURED:
					
						if (p_USB_SetupReq->wValue_LO == 0) 
						{
							usb.dev_state = USB_STATE_ADDRESSED;
							usb.dev_config = 0;
							USB_Class_DeInit_callback();
							USB_Send_Data(NULL, 0, 0);
						}
						else if (p_USB_SetupReq->wValue_LO != usb.dev_config) 
						{
							USB_Class_DeInit_callback();
							usb.dev_config = p_USB_SetupReq->wValue_LO; // set new configuration
							
							if (USB_Class_Init_callback(usb.dev_config) < 0)
								usb_control_error();
							else
								USB_Send_Data(NULL, 0, 0);
						}
						else
						{
							USB_Send_Data(NULL, 0, 0);
						}
						break;

					default:
						usb_control_error();
						break;
				}
			} 
			else
				usb_control_error();
			break;

		case USB_REQ_GET_CONFIGURATION: // GET_CONFIGURATION
			if (p_USB_SetupReq->wLength_LO == 1) 
			{
				switch (usb.dev_state)  
				{
					case USB_STATE_ADDRESSED:
					case USB_STATE_CONFIGURED:
						USB_Send_Data(&usb.dev_config, 1, 0);
						break;
						
					default:
						usb_control_error();
						break;
				}
			} 
			else 
				usb_control_error();
			break;
		
		case USB_REQ_GET_STATUS: // GET_STATUS
			switch (usb.dev_state) 
			{
				case USB_STATE_ADDRESSED:
				case USB_STATE_CONFIGURED:
				
					usb.dev_config_status = 0;
					#if (USB_SELF_POWERED == 1)
						usb.dev_config_status |= USB_CONFIG_SELF_POWERED;
					#endif
					if (usb.dev_remote_wakeup)
						usb.dev_config_status |= USB_CONFIG_REMOTE_WAKEUP;
						
					USB_Send_Data((uint8_t*)&usb.dev_config_status, 2, 0);
					break;
				
				default :
					usb_control_error();
					break;
			}
			break;

#ifdef USB_CFG_FEATURES_SUPPORT

		case USB_REQ_SET_FEATURE: // SET_FEATURE
			if (p_USB_SetupReq->wValue_LO == USB_FEATURE_REMOTE_WAKEUP)
			{
				usb.dev_remote_wakeup = 1;  
				USB_Setup_Request_callback(p_USB_SetupReq);
				USB_Send_Data(NULL, 0, 0);
			}
			break;

		case USB_REQ_CLEAR_FEATURE: // CLEAR_FEATURE
			switch (usb.dev_state)
			{
				case USB_STATE_ADDRESSED:
				case USB_STATE_CONFIGURED:
					if (p_USB_SetupReq->wValue_LO == USB_FEATURE_REMOTE_WAKEUP) 
					{
						usb.dev_remote_wakeup = 0; 
						USB_Setup_Request_callback(p_USB_SetupReq);
						USB_Send_Data(NULL, 0, 0);
					}
					break;
					
				default :
					 usb_control_error();
					break;
			}
			break;
			
#endif

		default:
			usb_control_error();
			break;
	}
}

void USB_Handle_Standard_Request(t_USB_SetupReq *p_USB_SetupReq)
{
	switch (p_USB_SetupReq->bmRequest & USB_RECIP_MASK)
	{
		case USB_REQ_RECIPIENT_DEVICE: 		// Device request
			USB_Device_Request(p_USB_SetupReq);
			break;
			
		case USB_REQ_RECIPIENT_INTERFACE: // Interface request
			if ((usb.dev_state != USB_STATE_CONFIGURED)||
				  (p_USB_SetupReq->wIndex_LO > USB_MAX_NUM_INTERFACES)||
					(USB_Setup_Request_callback(p_USB_SetupReq)>= 0)	)		// <--  Callback
				return;
			else	
				usb_control_error();
			break;

#ifdef USB_CFG_FEATURES_SUPPORT

		case USB_REQ_RECIPIENT_ENDPOINT: // Endpoint request

			if(p_USB_SetupReq->bRequest==USB_REQ_CLEAR_FEATURE)
			{
					switch (usb.dev_state) 
					{
						case USB_STATE_ADDRESSED:          
							//if ((p_USB_SetupReq->wIndex_LO != 0x00) && (p_USB_SetupReq->wIndex_LO != 0x80))
							if ((p_USB_SetupReq->wIndex_LO & 0x7F) == 0x1) // EP 1 
							{
								//USBD_LL_StallEP(pdev , p_USB_SetupReq->wIndex_LO);
								USB_Send_Data(NULL, 0, 0);
							} 
							else 
								usb_control_error();
							break;	
							
						case USB_STATE_CONFIGURED:   
							if (p_USB_SetupReq->wValue_LO == USB_FEATURE_EP_HALT)
							{
								//if ((p_USB_SetupReq->wIndex_LO & 0x7F) != 0x00)
								if ((p_USB_SetupReq->wIndex_LO & 0x7F) == 0x1) // EP 1 
								{
									//USBD_LL_ClearStallEP(pdev , p_USB_SetupReq->wIndex_LO);
									//USB_Setup_Request_callback(p_USB_SetupReq);
									USB_Send_Data(NULL, 0, 0);
								} 
								else 
									usb_control_error();
							}
							break;
							
						default:                         
							usb_control_error();
							break;    
					}
			}
			else
				usb_control_error();
				
			break;
			
#endif

		default:
			usb_control_error();
			break;
	}
}

void USB_Handle_GetDescriptor(t_USB_SetupReq *p_USB_SetupReq)
{
	uint16_t wLength = p_USB_SetupReq->wLength_LO|(p_USB_SetupReq->wLength_HI << 8);

	switch (p_USB_SetupReq->wValue_HI)
	{
		case USB_DESC_TYPE_DEVICE:	// Device desc
			USB_Send_Data(usb_device_descriptor,MIN(wLength, SIZE_DEVICE_DESCRIPTOR),0);
			break;

		case USB_DESC_TYPE_CONFIGURATION:	// Configuration desc
			USB_Send_Data(usb_configuration_descriptor,MIN(wLength, SIZE_CONFIGURATION_DESCRIPTOR),0);
			break;

		case USB_DESC_TYPE_STRING: // String desc
			if (p_USB_SetupReq->wValue_LO < LENGTH_STRING_DESCRIPTOR) 
			{
				USB_Send_Data(USB_String_Descriptors[p_USB_SetupReq->wValue_LO], 
						MIN(wLength,USB_String_Descriptors_Length[p_USB_SetupReq->wValue_LO]),0);
			} 
			else 
				usb_control_error();
			break;

#ifdef USB_CFG_HID_DESCRIPTORS

		case HID_DESCRIPTOR_REPORT: // handle HID class report descriptor
			USB_Send_Data(HID_ReportDescriptor,MIN(wLength,SIZE_REPORT_DESCRIPTOR),0);
			break;
			
		case HID_DESCRIPTOR:				// HID Descriptor
			USB_Send_Data(USB_HID_descriptor,MIN(wLength,SIZE_HID_DESCRIPTOR),0);
			break;	
#endif

		default:
			usb_control_error();
			break;
	}
}		

void USB_loop(void)
{
	if (GPIOC->IDR&(USB_DP|USB_DM))
		usb.reset_counter = 0;	
	else if (usb.reset_counter++ > USB_RESET_DELAY) 
	{
		USB_Reset();
		return;
	}

	if (usb.EP[0].rx_state == USB_EP_DATA_READY)
	{
		if (usb.EP0_data_stage == USB_STAGE_SETUP) // EP0 Setup stage
		{
			t_USB_SetupReq *p_USB_SetupReq = (t_USB_SetupReq*)(usb.EP[0].rx_buffer);

			if((p_USB_SetupReq->bmRequest & USB_REQ_TYPE_MASK)==USB_REQ_TYPE_STANDARD)
			{
				if(p_USB_SetupReq->bRequest==USB_REQ_GET_DESCRIPTOR)	// GET_DESCRIPTOR			
					USB_Handle_GetDescriptor(p_USB_SetupReq);
				else
					USB_Handle_Standard_Request(p_USB_SetupReq);
			}
			else
			{
				// test
				if(USB_Setup_Request_callback(p_USB_SetupReq)<0)
					usb_control_error();
			}
			usb.EP[0].rx_state = USB_EP_NO_DATA;	
		}
		else
		{ // EP0 Data stage
			USB_NRZI_RX_Decode(usb.EP[0].rx_buffer, usb.EP[0].rx_length);
			USB_EP0_RxReady_callback(usb.EP[0].rx_buffer, usb.EP[0].rx_length);
			usb.EP[0].rx_state = USB_EP_NO_DATA;
		}
	}
	
	if (usb.EP[1].rx_state == USB_EP_DATA_READY)
	{
		USB_NRZI_RX_Decode(usb.EP[1].rx_buffer, usb.EP[1].rx_length);
		USB_EP1_RxReady_callback(usb.EP[1].rx_buffer, usb.EP[1].rx_length);
		usb.EP[1].rx_state = USB_EP_NO_DATA;
	}
}

void USB_slow_loop(void)
{
#if (USB_CLOCK_HSI == 1)
	if (usb.trimming_stage != HSI_TRIMMER_DISABLE)
	{
		if (usb.trimming_stage == HSI_TRIMMER_STARTED)
		{
			usb.delay_counter++;
			if (usb.delay_counter == USB_CONNECT_TIMEOUT)
			{
				usb.delay_counter = 0;
				usb.HSI_Trim_val++;
				usb.HSI_Trim_val &= 0x0F;
				CLK->HSITRIMR = (uint8_t)((CLK->HSITRIMR & (~0x0F)) | usb.HSI_Trim_val);
				USB_disconnect();
				USB_Reset();
				usb.trimming_stage = HSI_TRIMMER_RECONNECT_DELAY;
			}
		}
		else if (usb.trimming_stage == HSI_TRIMMER_RECONNECT_DELAY)
		{
			usb.delay_counter++;
			
			if (usb.delay_counter == USB_RECONNECT_DELAY)
			{
				usb.delay_counter = 0;
				usb.trimming_stage = HSI_TRIMMER_ENABLE;
				USB_connect();
			}
		} 
		else if (usb.trimming_stage == HSI_TRIMMER_WRITE_TRIM_VAL)
		{
			FLASH_Data_lock(0);
			*p_HSI_TRIM_VAL = usb.HSI_Trim_val;
			*p_HSI_TRIMING_DONE = MAGIC_VAL;
			usb.trimming_stage = HSI_TRIMMER_DISABLE;
		}
	}
#endif
#if (USB_EP_WATCHDOG_ENABLE == 1)
	//if ((usb.dev_state == USB_STATE_CONFIGURED)||(usb.WDG_EP_timeout < 0)) {
	if ((usb.dev_state != USB_STATE_DEFAULT)||(usb.WDG_EP_timeout < 0))
	{
		if (usb.WDG_EP_timeout < USB_EP_WATCHDOG_TIMEOUT)
			usb.WDG_EP_timeout++;
		if (usb.WDG_EP_timeout == USB_EP_WATCHDOG_TIMEOUT)
		{
			USB_disconnect();
			USB_Reset();
			usb.WDG_EP_timeout = -USB_EP_WATCHDOG_RECONNECT_DELAY;
		}
		else if (usb.WDG_EP_timeout == 0)
		{ // Connect
			USB_connect();
		}
	}
#endif
}
