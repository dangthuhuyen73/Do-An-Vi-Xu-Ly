
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _index=R4
	.DEF _thoigian0=R6
	.DEF _thoigian1=R8

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x5D:
	.DB  0x0,0x0,0xF0,0x0,0xBD,0x0
_0x0:
	.DB  0x46,0x4F,0x42,0x44,0x0,0x45,0x31,0x37
	.DB  0x42,0x0,0x44,0x32,0x33,0x39,0x0,0x43
	.DB  0x32,0x46,0x36,0x0,0x42,0x33,0x42,0x34
	.DB  0x0,0x41,0x34,0x37,0x32,0x0,0x39,0x35
	.DB  0x33,0x30,0x0,0x38,0x35,0x45,0x44,0x0
	.DB  0x37,0x36,0x41,0x42,0x0,0x36,0x37,0x36
	.DB  0x39,0x0,0x43,0x6F,0x75,0x6E,0x74,0x65
	.DB  0x72,0x3A,0x20,0x0

__GLOBAL_INI_TBL:
	.DW  0x05
	.DW  _0x4B
	.DW  _0x0*2

	.DW  0x05
	.DW  _0x4B+5
	.DW  _0x0*2+5

	.DW  0x05
	.DW  _0x4B+10
	.DW  _0x0*2+10

	.DW  0x05
	.DW  _0x4B+15
	.DW  _0x0*2+15

	.DW  0x05
	.DW  _0x4B+20
	.DW  _0x0*2+20

	.DW  0x05
	.DW  _0x4B+25
	.DW  _0x0*2+25

	.DW  0x05
	.DW  _0x4B+30
	.DW  _0x0*2+30

	.DW  0x05
	.DW  _0x4B+35
	.DW  _0x0*2+35

	.DW  0x05
	.DW  _0x4B+40
	.DW  _0x0*2+40

	.DW  0x05
	.DW  _0x4B+45
	.DW  _0x0*2+45

	.DW  0x0A
	.DW  _0x57
	.DW  _0x0*2+50

	.DW  0x06
	.DW  0x04
	.DW  _0x5D*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : Bai Thi Cuoi Ki
;mssv    : N21DCVT040
;Date    : 23/12/2023
;Author  : Dang Thu Huyen
;Company : ptit
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;//khai bao thu vien
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include <string.h>
;#include <delay.h>
;#define LED PORTB
;#define SW PIND.2
;#define ADC_VREF_TYPE 0x00
;// khai bao bien
;unsigned long adc_out=0;
;unsigned long dienap;
;unsigned long chuc,dvi, a, b;
;unsigned long nhietdo, k;
;//khai bao timemer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;unsigned int index=0;
;unsigned int thoigian0 = 240, thoigian1 = 189;
;
;//ham doc adc
;unsigned int read_adc(unsigned char adc_input)
; 0000 002C {

	.CSEG
_read_adc:
; 0000 002D ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 002E // Delay needed for the stabilization of the ADC input voltage
; 0000 002F delay_us(10);
	__DELAY_USB 27
; 0000 0030 // Start the AD conversion
; 0000 0031 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0032 // Wait for the AD conversion to complete
; 0000 0033 while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0034 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0035 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x2060001
; 0000 0036 }
;
;
;// chuong trinh con phat mot chuoi ki tu
;void uart_char_send(unsigned char chr){
; 0000 003A void uart_char_send(unsigned char chr){
_uart_char_send:
; 0000 003B while(!(UCSRA&(1<<UDRE))) {};
;	chr -> Y+0
_0x6:
	SBIS 0xB,5
	RJMP _0x6
; 0000 003C //ktra khi nao udre bang 1 de thanh ghi trong de bo du lieu vao
; 0000 003D    UDR=chr;  //khi udre =1 cho phep du lieu vào
	LD   R30,Y
	OUT  0xC,R30
; 0000 003E    }
_0x2060001:
	ADIW R28,1
	RET
;//cho nhieu ki tu
;void uart_string_send(unsigned char *txt){
; 0000 0040 void uart_string_send(unsigned char *txt){
_uart_string_send:
; 0000 0041    unsigned char n,i;
; 0000 0042    n=strlen(txt);
	ST   -Y,R17
	ST   -Y,R16
;	*txt -> Y+2
;	n -> R17
;	i -> R16
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
; 0000 0043    //dem có bn ki tu n so luong
; 0000 0044    for(i=0;i<n;i++){
	LDI  R16,LOW(0)
_0xA:
	CP   R16,R17
	BRSH _0xB
; 0000 0045    uart_char_send(txt[i]);}
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	LD   R30,X
	ST   -Y,R30
	RCALL _uart_char_send
	SUBI R16,-1
	RJMP _0xA
_0xB:
; 0000 0046 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
;
;//ngat uart
;interrupt[USART_RXC] void usart_rx_isr(void) {
; 0000 0049 interrupt[12] void usart_rx_isr(void) {
_usart_rx_isr:
	CALL SUBOPT_0x0
; 0000 004A     char data;
; 0000 004B     data = UDR;
	ST   -Y,R17
;	data -> R17
	IN   R17,12
; 0000 004C     // bat den
; 0000 004D     if (data == 'l') {
	CPI  R17,108
	BRNE _0xC
; 0000 004E         PORTB.0 = 1;
	SBI  0x18,0
; 0000 004F     }
; 0000 0050     if (data == 'm') {
_0xC:
	CPI  R17,109
	BRNE _0xF
; 0000 0051         PORTB.1 = 1;
	SBI  0x18,1
; 0000 0052     }
; 0000 0053     if (data == 'n') {
_0xF:
	CPI  R17,110
	BRNE _0x12
; 0000 0054         PORTB.2 = 1;
	SBI  0x18,2
; 0000 0055     }
; 0000 0056     if (data == 'o') {
_0x12:
	CPI  R17,111
	BRNE _0x15
; 0000 0057         PORTB.3 = 1;
	SBI  0x18,3
; 0000 0058     }
; 0000 0059     if (data == 'u') {
_0x15:
	CPI  R17,117
	BRNE _0x18
; 0000 005A         PORTB.4 = 1;
	SBI  0x18,4
; 0000 005B     }
; 0000 005C     if (data == 'i') {
_0x18:
	CPI  R17,105
	BRNE _0x1B
; 0000 005D         PORTB.5 = 1;
	SBI  0x18,5
; 0000 005E     }
; 0000 005F     if (data == 'v') {
_0x1B:
	CPI  R17,118
	BRNE _0x1E
; 0000 0060         PORTB.6 = 1;
	SBI  0x18,6
; 0000 0061     }
; 0000 0062     if (data == 'x') {
_0x1E:
	CPI  R17,120
	BRNE _0x21
; 0000 0063         PORTB.7 = 1;
	SBI  0x18,7
; 0000 0064     }
; 0000 0065     // bat quat
; 0000 0066     if (data == 'y'){
_0x21:
	CPI  R17,121
	BRNE _0x24
; 0000 0067         PORTC.1=1;
	SBI  0x15,1
; 0000 0068     }
; 0000 0069     // tat den
; 0000 006A     if (data == 'a') {
_0x24:
	CPI  R17,97
	BRNE _0x27
; 0000 006B         PORTB.0 = 0;
	CBI  0x18,0
; 0000 006C     }
; 0000 006D     if (data == 'b') {
_0x27:
	CPI  R17,98
	BRNE _0x2A
; 0000 006E         PORTB.1 = 0;
	CBI  0x18,1
; 0000 006F     }
; 0000 0070     if (data == 'c') {
_0x2A:
	CPI  R17,99
	BRNE _0x2D
; 0000 0071         PORTB.2 = 0;
	CBI  0x18,2
; 0000 0072     }
; 0000 0073     if (data == 'd') {
_0x2D:
	CPI  R17,100
	BRNE _0x30
; 0000 0074         PORTB.3 = 0;
	CBI  0x18,3
; 0000 0075     }
; 0000 0076     if (data == 'e') {
_0x30:
	CPI  R17,101
	BRNE _0x33
; 0000 0077         PORTB.4 = 0;
	CBI  0x18,4
; 0000 0078     }
; 0000 0079     if (data == 'f') {
_0x33:
	CPI  R17,102
	BRNE _0x36
; 0000 007A         PORTB.5 = 0;
	CBI  0x18,5
; 0000 007B     }
; 0000 007C     if (data == 'g') {
_0x36:
	CPI  R17,103
	BRNE _0x39
; 0000 007D         PORTB.6 = 0;
	CBI  0x18,6
; 0000 007E     }
; 0000 007F     if (data == 'h') {
_0x39:
	CPI  R17,104
	BRNE _0x3C
; 0000 0080         PORTB.7 = 0;
	CBI  0x18,7
; 0000 0081     }
; 0000 0082     // tat Quat
; 0000 0083     if (data == 'j'){
_0x3C:
	CPI  R17,106
	BRNE _0x3F
; 0000 0084         PORTC.1=0;
	CBI  0x15,1
; 0000 0085     }
; 0000 0086     //timer
; 0000 0087     if ((data >= 'A' && data <= 'Z') || (data >= '0' && data <= '9')){
_0x3F:
	CPI  R17,65
	BRLO _0x43
	CPI  R17,91
	BRLO _0x45
_0x43:
	CPI  R17,48
	BRLO _0x46
	CPI  R17,58
	BRLO _0x45
_0x46:
	RJMP _0x42
_0x45:
; 0000 0088     rx_buffer[index++] = data;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	SBIW R30,1
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R17
; 0000 0089     }
; 0000 008A     if (index==4){
_0x42:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R4
	CPC  R31,R5
	BREQ PC+3
	JMP _0x49
; 0000 008B         if(strcmp(rx_buffer, "FOBD") == 0){
	CALL SUBOPT_0x1
	__POINTW1MN _0x4B,0
	CALL SUBOPT_0x2
	BRNE _0x4A
; 0000 008C               thoigian0 = 240;
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	MOVW R6,R30
; 0000 008D               thoigian1 = 189;
	LDI  R30,LOW(189)
	LDI  R31,HIGH(189)
	MOVW R8,R30
; 0000 008E         }
; 0000 008F         if(strcmp(rx_buffer, "E17B") == 0){
_0x4A:
	CALL SUBOPT_0x1
	__POINTW1MN _0x4B,5
	CALL SUBOPT_0x2
	BRNE _0x4C
; 0000 0090               thoigian0 = 225;
	LDI  R30,LOW(225)
	LDI  R31,HIGH(225)
	MOVW R6,R30
; 0000 0091               thoigian1 = 123;
	LDI  R30,LOW(123)
	LDI  R31,HIGH(123)
	MOVW R8,R30
; 0000 0092         }
; 0000 0093         if(strcmp(rx_buffer, "D239") == 0){
_0x4C:
	CALL SUBOPT_0x1
	__POINTW1MN _0x4B,10
	CALL SUBOPT_0x2
	BRNE _0x4D
; 0000 0094               thoigian0 = 210;
	LDI  R30,LOW(210)
	LDI  R31,HIGH(210)
	MOVW R6,R30
; 0000 0095               thoigian1 = 57;
	LDI  R30,LOW(57)
	LDI  R31,HIGH(57)
	MOVW R8,R30
; 0000 0096         }
; 0000 0097         if(strcmp(rx_buffer, "C2F6") == 0){
_0x4D:
	CALL SUBOPT_0x1
	__POINTW1MN _0x4B,15
	CALL SUBOPT_0x2
	BRNE _0x4E
; 0000 0098               thoigian0 = 194;
	LDI  R30,LOW(194)
	LDI  R31,HIGH(194)
	MOVW R6,R30
; 0000 0099               thoigian1 = 246;
	LDI  R30,LOW(246)
	LDI  R31,HIGH(246)
	MOVW R8,R30
; 0000 009A         }
; 0000 009B         if(strcmp(rx_buffer, "B3B4") == 0){
_0x4E:
	CALL SUBOPT_0x1
	__POINTW1MN _0x4B,20
	CALL SUBOPT_0x2
	BRNE _0x4F
; 0000 009C               thoigian0 = 179;
	LDI  R30,LOW(179)
	LDI  R31,HIGH(179)
	MOVW R6,R30
; 0000 009D               thoigian1 = 180;
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	MOVW R8,R30
; 0000 009E         }
; 0000 009F         if(strcmp(rx_buffer, "A472") == 0){
_0x4F:
	CALL SUBOPT_0x1
	__POINTW1MN _0x4B,25
	CALL SUBOPT_0x2
	BRNE _0x50
; 0000 00A0               thoigian0 = 164;
	LDI  R30,LOW(164)
	LDI  R31,HIGH(164)
	MOVW R6,R30
; 0000 00A1               thoigian1 = 114;
	LDI  R30,LOW(114)
	LDI  R31,HIGH(114)
	MOVW R8,R30
; 0000 00A2         }
; 0000 00A3         if(strcmp(rx_buffer, "9530") == 0){
_0x50:
	CALL SUBOPT_0x1
	__POINTW1MN _0x4B,30
	CALL SUBOPT_0x2
	BRNE _0x51
; 0000 00A4               thoigian0 = 149;
	LDI  R30,LOW(149)
	LDI  R31,HIGH(149)
	MOVW R6,R30
; 0000 00A5               thoigian1 = 48;
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	MOVW R8,R30
; 0000 00A6         }
; 0000 00A7         if(strcmp(rx_buffer, "85ED") == 0){
_0x51:
	CALL SUBOPT_0x1
	__POINTW1MN _0x4B,35
	CALL SUBOPT_0x2
	BRNE _0x52
; 0000 00A8               thoigian0 = 133;
	LDI  R30,LOW(133)
	LDI  R31,HIGH(133)
	MOVW R6,R30
; 0000 00A9               thoigian1 = 237;
	LDI  R30,LOW(237)
	LDI  R31,HIGH(237)
	MOVW R8,R30
; 0000 00AA         }
; 0000 00AB         if(strcmp(rx_buffer, "76AB") == 0){
_0x52:
	CALL SUBOPT_0x1
	__POINTW1MN _0x4B,40
	CALL SUBOPT_0x2
	BRNE _0x53
; 0000 00AC               thoigian0 = 118;
	LDI  R30,LOW(118)
	LDI  R31,HIGH(118)
	MOVW R6,R30
; 0000 00AD               thoigian1 = 171;
	LDI  R30,LOW(171)
	LDI  R31,HIGH(171)
	MOVW R8,R30
; 0000 00AE         }
; 0000 00AF         if(strcmp(rx_buffer, "6769") == 0){
_0x53:
	CALL SUBOPT_0x1
	__POINTW1MN _0x4B,45
	CALL SUBOPT_0x2
	BRNE _0x54
; 0000 00B0               thoigian0 = 103;
	LDI  R30,LOW(103)
	LDI  R31,HIGH(103)
	MOVW R6,R30
; 0000 00B1               thoigian1 = 105;
	LDI  R30,LOW(105)
	LDI  R31,HIGH(105)
	MOVW R8,R30
; 0000 00B2         }
; 0000 00B3         index=0;
_0x54:
	CLR  R4
	CLR  R5
; 0000 00B4     }
; 0000 00B5 }
_0x49:
	LD   R17,Y+
	RJMP _0x5C

	.DSEG
_0x4B:
	.BYTE 0x32
;
;//NGAT TIME
;interrupt [TIM1_OVF] void timer1_ovf_isr(void){
; 0000 00B8 interrupt [9] void timer1_ovf_isr(void){

	.CSEG
_timer1_ovf_isr:
; 0000 00B9    TCNT1H=thoigian0;
	OUT  0x2D,R6
; 0000 00BA    TCNT1L=thoigian1;
	OUT  0x2C,R8
; 0000 00BB    PORTC.0=~PORTC.0;
	SBIS 0x15,0
	RJMP _0x55
	CBI  0x15,0
	RJMP _0x56
_0x55:
	SBI  0x15,0
_0x56:
; 0000 00BC }
	RETI
;
;interrupt [EXT_INT0] void ext_int0_isr(void) {
; 0000 00BE interrupt [2] void ext_int0_isr(void) {
_ext_int0_isr:
	CALL SUBOPT_0x0
; 0000 00BF   a= k/10;
	CALL SUBOPT_0x3
	CALL __DIVD21U
	STS  _a,R30
	STS  _a+1,R31
	STS  _a+2,R22
	STS  _a+3,R23
; 0000 00C0   b= k%10;
	CALL SUBOPT_0x3
	CALL __MODD21U
	STS  _b,R30
	STS  _b+1,R31
	STS  _b+2,R22
	STS  _b+3,R23
; 0000 00C1   k++;
	LDI  R26,LOW(_k)
	LDI  R27,HIGH(_k)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0000 00C2   uart_string_send("Counter: ");
	__POINTW1MN _0x57,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _uart_string_send
; 0000 00C3   uart_char_send(a+0x30);
	LDS  R30,_a
	CALL SUBOPT_0x4
; 0000 00C4   uart_char_send(b+0x30);
	LDS  R30,_b
	CALL SUBOPT_0x4
; 0000 00C5   uart_char_send(10);
	CALL SUBOPT_0x5
; 0000 00C6   uart_char_send(13);
; 0000 00C7 }
_0x5C:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI

	.DSEG
_0x57:
	.BYTE 0xA
;void main(void)
; 0000 00C9 {

	.CSEG
_main:
; 0000 00CA // Declare your local variables here
; 0000 00CB 
; 0000 00CC // Input/Output Ports initialization
; 0000 00CD // Port A initialization
; 0000 00CE // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00CF // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00D0 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00D1 DDRA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 00D2 
; 0000 00D3 // Port B initialization
; 0000 00D4 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00D5 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00D6 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00D7 DDRB=0xff;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00D8 
; 0000 00D9 // Port C initialization
; 0000 00DA // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00DB // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00DC PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00DD DDRC=0xff;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 00DE 
; 0000 00DF // Port D initialization
; 0000 00E0 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00E1 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00E2 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00E3 DDRD=0x02;
	LDI  R30,LOW(2)
	OUT  0x11,R30
; 0000 00E4 
; 0000 00E5 
; 0000 00E6 //khoi tao timer/counter 0
; 0000 00E7 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 00E8 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00E9 OCR0=0x00;
	OUT  0x3C,R30
; 0000 00EA 
; 0000 00EB //khoi tao timer/counter 1
; 0000 00EC TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00ED //CHOP NHAY
; 0000 00EE TCCR1B=0X05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 00EF TIMSK=0X04;
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 00F0 
; 0000 00F1 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 00F2 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00F3 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00F4 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00F5 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00F6 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00F7 
; 0000 00F8 //cai dat tg diem bd cho bo dem
; 0000 00F9 TCNT1H=thoigian0;
	OUT  0x2D,R6
; 0000 00FA TCNT1L=thoigian1;
	OUT  0x2C,R8
; 0000 00FB 
; 0000 00FC // Timer/Counter 2 initialization
; 0000 00FD // Clock source: System Clock
; 0000 00FE // Clock value: Timer2 Stopped
; 0000 00FF // Mode: Normal top=0xFF
; 0000 0100 // OC2 output: Disconnected
; 0000 0101 ASSR=0x00;
	OUT  0x22,R30
; 0000 0102 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0103 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0104 OCR2=0x00;
	OUT  0x23,R30
; 0000 0105 
; 0000 0106 GICR|=0x40;
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 0107 MCUCR=0x02;
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 0108 MCUCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 0109 GIFR=0x40;
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 010A // External Interrupt(s) initialization
; 0000 010B // INT0: Off
; 0000 010C // INT1: Off
; 0000 010D // INT2: Off
; 0000 010E MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 010F MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0110 
; 0000 0111 //khoi tao adc
; 0000 0112 ADMUX=ADC_VREF_TYPE & 0xff;
	OUT  0x7,R30
; 0000 0113 ADCSRA=0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 0114 
; 0000 0115 // USART initialization
; 0000 0116 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0117 // USART Receiver: On
; 0000 0118 // USART Transmitter: On
; 0000 0119 // USART Mode: Asynchronous
; 0000 011A // USART Baud Rate: 9600
; 0000 011B //khoi tao usart
; 0000 011C UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 011D UCSRB=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 011E UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 011F UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0120 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0121 
; 0000 0122 //
; 0000 0123 //// Analog Comparator initialization
; 0000 0124 //// Analog Comparator: Off
; 0000 0125 //// Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0126 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0127 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0128 
; 0000 0129 SPCR=0x00;
	OUT  0xD,R30
; 0000 012A 
; 0000 012B TWCR=0x00;
	OUT  0x36,R30
; 0000 012C 
; 0000 012D //bat ngat toan cuc
; 0000 012E #asm("sei")
	sei
; 0000 012F while (1)
_0x58:
; 0000 0130       {
; 0000 0131       //nhiet do
; 0000 0132       adc_out=read_adc(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	CLR  R22
	CLR  R23
	STS  _adc_out,R30
	STS  _adc_out+1,R31
	STS  _adc_out+2,R22
	STS  _adc_out+3,R23
; 0000 0133       dienap=adc_out*5000/1023;
	__GETD2N 0x1388
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3FF
	CALL __DIVD21U
	STS  _dienap,R30
	STS  _dienap+1,R31
	STS  _dienap+2,R22
	STS  _dienap+3,R23
; 0000 0134       nhietdo=dienap/10;
	LDS  R26,_dienap
	LDS  R27,_dienap+1
	LDS  R24,_dienap+2
	LDS  R25,_dienap+3
	CALL SUBOPT_0x6
	STS  _nhietdo,R30
	STS  _nhietdo+1,R31
	STS  _nhietdo+2,R22
	STS  _nhietdo+3,R23
; 0000 0135 
; 0000 0136       chuc=nhietdo/10;
	CALL SUBOPT_0x7
	CALL SUBOPT_0x6
	STS  _chuc,R30
	STS  _chuc+1,R31
	STS  _chuc+2,R22
	STS  _chuc+3,R23
; 0000 0137       dvi=nhietdo%10;
	CALL SUBOPT_0x7
	__GETD1N 0xA
	CALL __MODD21U
	STS  _dvi,R30
	STS  _dvi+1,R31
	STS  _dvi+2,R22
	STS  _dvi+3,R23
; 0000 0138       uart_char_send(chuc+0x30);
	LDS  R30,_chuc
	CALL SUBOPT_0x4
; 0000 0139       uart_char_send(dvi+0x30);
	LDS  R30,_dvi
	CALL SUBOPT_0x4
; 0000 013A       uart_char_send(10);
	CALL SUBOPT_0x5
; 0000 013B       uart_char_send(13);
; 0000 013C      //xuong hang
; 0000 013D       delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 013E       }
	RJMP _0x58
; 0000 013F 
; 0000 0140 }
_0x5B:
	RJMP _0x5B
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG
_strcmp:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret

	.CSEG

	.DSEG
_adc_out:
	.BYTE 0x4
_dienap:
	.BYTE 0x4
_chuc:
	.BYTE 0x4
_dvi:
	.BYTE 0x4
_a:
	.BYTE 0x4
_b:
	.BYTE 0x4
_nhietdo:
	.BYTE 0x4
_k:
	.BYTE 0x4
_rx_buffer:
	.BYTE 0x8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x0:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(_rx_buffer)
	LDI  R31,HIGH(_rx_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcmp
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	LDS  R26,_k
	LDS  R27,_k+1
	LDS  R24,_k+2
	LDS  R25,_k+3
	__GETD1N 0xA
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	SUBI R30,-LOW(48)
	ST   -Y,R30
	JMP  _uart_char_send

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _uart_char_send
	LDI  R30,LOW(13)
	ST   -Y,R30
	JMP  _uart_char_send

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	__GETD1N 0xA
	CALL __DIVD21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDS  R26,_nhietdo
	LDS  R27,_nhietdo+1
	LDS  R24,_nhietdo+2
	LDS  R25,_nhietdo+3
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

;END OF CODE MARKER
__END_OF_CODE:
