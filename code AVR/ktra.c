/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : Bai Thi Cuoi Ki
mssv    : N21DCVT040
Date    : 23/12/2023
Author  : Dang Thu Huyen
Company : ptit
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/
//khai bao thu vien
#include <mega16.h>
#include <stdio.h>
#include <string.h>
#include <delay.h>
#define LED PORTB
#define SW PIND.2
#define ADC_VREF_TYPE 0x00
// khai bao bien
unsigned long adc_out=0;
unsigned long dienap;
unsigned long chuc,dvi, a, b;
unsigned long nhietdo, k;
//khai bao timemer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];
unsigned int index=0;
unsigned int thoigian0 = 240, thoigian1 = 189;

//ham doc adc 
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}


// chuong trinh con phat mot chuoi ki tu
void uart_char_send(unsigned char chr){
while(!(UCSRA&(1<<UDRE))) {}; 
//ktra khi nao udre bang 1 de thanh ghi trong de bo du lieu vao
   UDR=chr;  //khi udre =1 cho phep du lieu vào
   }
//cho nhieu ki tu
void uart_string_send(unsigned char *txt){
   unsigned char n,i;
   n=strlen(txt); 
   //dem có bn ki tu n so luong
   for(i=0;i<n;i++){
   uart_char_send(txt[i]);}
}

//ngat uart
interrupt[USART_RXC] void usart_rx_isr(void) {
    char data;
    data = UDR; 
    // bat den
    if (data == 'l') {
        PORTB.0 = 1;
    }
    if (data == 'm') {
        PORTB.1 = 1;
    }
    if (data == 'n') {
        PORTB.2 = 1;
    }
    if (data == 'o') {
        PORTB.3 = 1;
    }
    if (data == 'u') {
        PORTB.4 = 1;
    }
    if (data == 'i') {
        PORTB.5 = 1;
    }
    if (data == 'v') {
        PORTB.6 = 1;
    }
    if (data == 'x') {
        PORTB.7 = 1;
    }
    // bat quat
    if (data == 'y'){ 
        PORTC.1=1;
    }
    // tat den
    if (data == 'a') {
        PORTB.0 = 0; 
    }  
    if (data == 'b') {
        PORTB.1 = 0; 
    }
    if (data == 'c') {
        PORTB.2 = 0; 
    } 
    if (data == 'd') {
        PORTB.3 = 0; 
    } 
    if (data == 'e') {
        PORTB.4 = 0; 
    } 
    if (data == 'f') {
        PORTB.5 = 0; 
    }
    if (data == 'g') {
        PORTB.6 = 0; 
    }
    if (data == 'h') {
        PORTB.7 = 0; 
    }     
    // tat Quat
    if (data == 'j'){ 
        PORTC.1=0;
    } 
    //timer 
    if ((data >= 'A' && data <= 'Z') || (data >= '0' && data <= '9')){    
    rx_buffer[index++] = data;      
    }
    if (index==4){
        if(strcmp(rx_buffer, "FOBD") == 0){
              thoigian0 = 240;
              thoigian1 = 189; 
        }
        if(strcmp(rx_buffer, "E17B") == 0){
              thoigian0 = 225;
              thoigian1 = 123; 
        }
        if(strcmp(rx_buffer, "D239") == 0){
              thoigian0 = 210;
              thoigian1 = 57; 
        }
        if(strcmp(rx_buffer, "C2F6") == 0){
              thoigian0 = 194;
              thoigian1 = 246; 
        }
        if(strcmp(rx_buffer, "B3B4") == 0){
              thoigian0 = 179;
              thoigian1 = 180; 
        }
        if(strcmp(rx_buffer, "A472") == 0){
              thoigian0 = 164;
              thoigian1 = 114; 
        }
        if(strcmp(rx_buffer, "9530") == 0){
              thoigian0 = 149;
              thoigian1 = 48; 
        }
        if(strcmp(rx_buffer, "85ED") == 0){
              thoigian0 = 133;
              thoigian1 = 237; 
        }
        if(strcmp(rx_buffer, "76AB") == 0){
              thoigian0 = 118;
              thoigian1 = 171; 
        }
        if(strcmp(rx_buffer, "6769") == 0){
              thoigian0 = 103;
              thoigian1 = 105; 
        }
        index=0;
    }  
}

//NGAT TIME 
interrupt [TIM1_OVF] void timer1_ovf_isr(void){
   TCNT1H=thoigian0;
   TCNT1L=thoigian1;
   PORTC.0=~PORTC.0;    
}

interrupt [EXT_INT0] void ext_int0_isr(void) {
  a= k/10;
  b= k%10;
  k++; 
  uart_string_send("Counter: "); 
  uart_char_send(a+0x30);
  uart_char_send(b+0x30); 
  uart_char_send(10);
  uart_char_send(13);   
}
void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0xff;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0xff;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0xff;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x02;


//khoi tao timer/counter 0
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

//khoi tao timer/counter 1
TCCR1A=0x00;
//CHOP NHAY
TCCR1B=0X05;         
TIMSK=0X04;

ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

//cai dat tg diem bd cho bo dem
TCNT1H=thoigian0;
TCNT1L=thoigian1;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

GICR|=0x40;
MCUCR=0x02;
MCUCSR=0x00;
GIFR=0x40;
// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

//khoi tao adc
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x83;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
//khoi tao usart
UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;

//
//// Analog Comparator initialization
//// Analog Comparator: Off
//// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

SPCR=0x00;

TWCR=0x00;

//bat ngat toan cuc
#asm("sei")
while (1)
      {      
      //nhiet do
      adc_out=read_adc(0);
      dienap=adc_out*5000/1023;
      nhietdo=dienap/10;
      
      chuc=nhietdo/10;
      dvi=nhietdo%10; 
      uart_char_send(chuc+0x30);
      uart_char_send(dvi+0x30); 
      uart_char_send(10);    
      uart_char_send(13);  
     //xuong hang
      delay_ms(200);
      }    
     
}
