
_interrupt:

;TCC.c,25 :: 		void interrupt(){
;TCC.c,26 :: 		if(INTCON.INT0IF == 1){
	BTFSS       INTCON+0, 1 
	GOTO        L_interrupt0
;TCC.c,27 :: 		pointer = &option;
	MOVLW       _option+0
	MOVWF       _pointer+0 
	MOVLW       hi_addr(_option+0)
	MOVWF       _pointer+1 
;TCC.c,28 :: 		*pointer = 'X';
	MOVFF       _pointer+0, FSR1
	MOVFF       _pointer+1, FSR1H
	MOVLW       88
	MOVWF       POSTINC1+0 
;TCC.c,29 :: 		INTCON.INT0IF = 0;
	BCF         INTCON+0, 1 
;TCC.c,30 :: 		}
L_interrupt0:
;TCC.c,31 :: 		}
L_end_interrupt:
L__interrupt48:
	RETFIE      1
; end of _interrupt

_main:

;TCC.c,33 :: 		void main()org 0x1000 { //faz a função main ir para o enderço 0x1000 de memória.
;TCC.c,37 :: 		board_Init(); //Função de "inicialização" da placa e configuração dos bits.
	CALL        _board_Init+0, 0
;TCC.c,38 :: 		interruptConfig();
	CALL        _interruptConfig+0, 0
;TCC.c,39 :: 		UART1_Init(9600); // Inicializa a comunicação serial UART com baudrate de 9600bps
	BSF         BAUDCON+0, 3, 0
	MOVLW       2
	MOVWF       SPBRGH+0 
	MOVLW       8
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;TCC.c,40 :: 		delay_ms(100); // Tempo para o módulo UART estabilizar a conexão.
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_main1:
	DECFSZ      R13, 1, 1
	BRA         L_main1
	DECFSZ      R12, 1, 1
	BRA         L_main1
	DECFSZ      R11, 1, 1
	BRA         L_main1
	NOP
	NOP
;TCC.c,41 :: 		UART1_Write_Text(INIT); //Envia uma mensagem de inicialização.
	MOVLW       ?lstr1_TCC+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr1_TCC+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TCC.c,42 :: 		delay_ms(500);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_main2:
	DECFSZ      R13, 1, 1
	BRA         L_main2
	DECFSZ      R12, 1, 1
	BRA         L_main2
	DECFSZ      R11, 1, 1
	BRA         L_main2
	NOP
;TCC.c,43 :: 		while(1){//Inicia o loop infinito.
L_main3:
;TCC.c,44 :: 		if (UART1_Data_Ready() == 1) {
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main5
;TCC.c,45 :: 		option = UART1_Read();
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _option+0 
;TCC.c,46 :: 		if(!UART1_Data_Ready() && option != 'Z'){
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main8
	MOVF        _option+0, 0 
	XORLW       90
	BTFSC       STATUS+0, 2 
	GOTO        L_main8
L__main46:
;TCC.c,47 :: 		UART1_Write_Text(ERROR);
	MOVLW       ?lstr2_TCC+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_TCC+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TCC.c,48 :: 		if (UART1_Data_Ready() == 1) {
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main9
;TCC.c,49 :: 		option = UART1_Read();
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _option+0 
;TCC.c,50 :: 		}
L_main9:
;TCC.c,51 :: 		for(i = 0; i < 3; i++){
	CLRF        main_i_L0+0 
	CLRF        main_i_L0+1 
L_main10:
	MOVLW       0
	SUBWF       main_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main50
	MOVLW       3
	SUBWF       main_i_L0+0, 0 
L__main50:
	BTFSC       STATUS+0, 0 
	GOTO        L_main11
;TCC.c,52 :: 		PORTD.B3 = 1;
	BSF         PORTD+0, 3 
;TCC.c,53 :: 		delay_ms(500);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_main13:
	DECFSZ      R13, 1, 1
	BRA         L_main13
	DECFSZ      R12, 1, 1
	BRA         L_main13
	DECFSZ      R11, 1, 1
	BRA         L_main13
	NOP
;TCC.c,54 :: 		PORTD.B3 = 0;
	BCF         PORTD+0, 3 
;TCC.c,51 :: 		for(i = 0; i < 3; i++){
	INFSNZ      main_i_L0+0, 1 
	INCF        main_i_L0+1, 1 
;TCC.c,55 :: 		}
	GOTO        L_main10
L_main11:
;TCC.c,56 :: 		}
L_main8:
;TCC.c,57 :: 		}
L_main5:
;TCC.c,58 :: 		if(option == 'Z'){
	MOVF        _option+0, 0 
	XORLW       90
	BTFSS       STATUS+0, 2 
	GOTO        L_main14
;TCC.c,59 :: 		UART1_Write_Text(ACEPTED);
	MOVLW       ?lstr3_TCC+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_TCC+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TCC.c,60 :: 		UART1_Write_Text(pointer);
	MOVF        _pointer+0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        _pointer+1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TCC.c,61 :: 		for(blink = 0; blink < 3; blink++){
	CLRF        main_blink_L0+0 
	CLRF        main_blink_L0+1 
L_main15:
	MOVLW       0
	SUBWF       main_blink_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main51
	MOVLW       3
	SUBWF       main_blink_L0+0, 0 
L__main51:
	BTFSC       STATUS+0, 0 
	GOTO        L_main16
;TCC.c,62 :: 		PORTD.B0 = 0;
	BCF         PORTD+0, 0 
;TCC.c,63 :: 		delay_ms(300);
	MOVLW       8
	MOVWF       R11, 0
	MOVLW       157
	MOVWF       R12, 0
	MOVLW       5
	MOVWF       R13, 0
L_main18:
	DECFSZ      R13, 1, 1
	BRA         L_main18
	DECFSZ      R12, 1, 1
	BRA         L_main18
	DECFSZ      R11, 1, 1
	BRA         L_main18
	NOP
	NOP
;TCC.c,64 :: 		PORTD.B0 = 1;
	BSF         PORTD+0, 0 
;TCC.c,61 :: 		for(blink = 0; blink < 3; blink++){
	INFSNZ      main_blink_L0+0, 1 
	INCF        main_blink_L0+1, 1 
;TCC.c,65 :: 		}
	GOTO        L_main15
L_main16:
;TCC.c,66 :: 		if(SPORTA || SCHAVE){
	BTFSC       PORTA+0, 0 
	GOTO        L__main45
	BTFSC       PORTA+0, 1 
	GOTO        L__main45
	GOTO        L_main21
L__main45:
;TCC.c,67 :: 		if(!SPORTA){
	BTFSC       PORTA+0, 0 
	GOTO        L_main22
;TCC.c,68 :: 		UART1_Write_Text(PORTAX);
	MOVLW       ?lstr4_TCC+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr4_TCC+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TCC.c,69 :: 		}
	GOTO        L_main23
L_main22:
;TCC.c,70 :: 		else if(!SCHAVE){
	BTFSC       PORTA+0, 1 
	GOTO        L_main24
;TCC.c,71 :: 		UART1_Write_Text(CHAVEX);
	MOVLW       ?lstr5_TCC+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr5_TCC+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TCC.c,72 :: 		}
L_main24:
L_main23:
;TCC.c,73 :: 		}
L_main21:
;TCC.c,74 :: 		}
	GOTO        L_main25
L_main14:
;TCC.c,76 :: 		for(i = 0; i < 3; i++){
	CLRF        main_i_L0+0 
	CLRF        main_i_L0+1 
L_main26:
	MOVLW       0
	SUBWF       main_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main52
	MOVLW       3
	SUBWF       main_i_L0+0, 0 
L__main52:
	BTFSC       STATUS+0, 0 
	GOTO        L_main27
;TCC.c,77 :: 		PORTD.B0 = 1;
	BSF         PORTD+0, 0 
;TCC.c,78 :: 		UART1_Write_Text(WAITING);
	MOVLW       ?lstr6_TCC+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr6_TCC+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TCC.c,79 :: 		PORTD.B0 = 0;
	BCF         PORTD+0, 0 
;TCC.c,80 :: 		delay_ms(500);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_main29:
	DECFSZ      R13, 1, 1
	BRA         L_main29
	DECFSZ      R12, 1, 1
	BRA         L_main29
	DECFSZ      R11, 1, 1
	BRA         L_main29
	NOP
;TCC.c,76 :: 		for(i = 0; i < 3; i++){
	INFSNZ      main_i_L0+0, 1 
	INCF        main_i_L0+1, 1 
;TCC.c,81 :: 		}
	GOTO        L_main26
L_main27:
;TCC.c,82 :: 		i = 0;
	CLRF        main_i_L0+0 
	CLRF        main_i_L0+1 
;TCC.c,83 :: 		}
L_main25:
;TCC.c,84 :: 		if(SPORTA == 0 && SCHAVE == 0 && option == 'Z'){//Realizaa verificação dos sensores.
	BTFSC       PORTA+0, 0 
	GOTO        L_main32
	BTFSC       PORTA+0, 1 
	GOTO        L_main32
	MOVF        _option+0, 0 
	XORLW       90
	BTFSS       STATUS+0, 2 
	GOTO        L_main32
L__main44:
;TCC.c,85 :: 		UART1_Write_Text(PROTECTED);
	MOVLW       ?lstr7_TCC+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr7_TCC+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TCC.c,86 :: 		control = ON;
	MOVLW       1
	MOVWF       main_control_L0+0 
	MOVLW       0
	MOVWF       main_control_L0+1 
;TCC.c,88 :: 		PORTD.B1 = 1;
	BSF         PORTD+0, 1 
;TCC.c,89 :: 		PORTD.B2 = 1;
	BSF         PORTD+0, 2 
;TCC.c,94 :: 		}
L_main34:
;TCC.c,95 :: 		while(control && option != 'X'){
L_main35:
	MOVF        main_control_L0+0, 0 
	IORWF       main_control_L0+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main36
	MOVF        _option+0, 0 
	XORLW       88
	BTFSC       STATUS+0, 2 
	GOTO        L_main36
L__main43:
;TCC.c,96 :: 		if (UART1_Data_Ready() == 1) {
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main39
;TCC.c,97 :: 		option = UART1_Read();
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _option+0 
;TCC.c,98 :: 		}
L_main39:
;TCC.c,99 :: 		UART1_Write_Text(STARTED);
	MOVLW       ?lstr8_TCC+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr8_TCC+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TCC.c,100 :: 		delay_ms(1000);
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_main40:
	DECFSZ      R13, 1, 1
	BRA         L_main40
	DECFSZ      R12, 1, 1
	BRA         L_main40
	DECFSZ      R11, 1, 1
	BRA         L_main40
	NOP
;TCC.c,101 :: 		}
	GOTO        L_main35
L_main36:
;TCC.c,102 :: 		if(option == 'X'){
	MOVF        _option+0, 0 
	XORLW       88
	BTFSS       STATUS+0, 2 
	GOTO        L_main41
;TCC.c,103 :: 		control = OFF;
	CLRF        main_control_L0+0 
	CLRF        main_control_L0+1 
;TCC.c,104 :: 		UART1_Write_Text(BLOCKED);
	MOVLW       ?lstr9_TCC+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr9_TCC+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TCC.c,105 :: 		}
L_main41:
;TCC.c,106 :: 		}
	GOTO        L_main42
L_main32:
;TCC.c,108 :: 		PORTD.B1 = 0;
	BCF         PORTD+0, 1 
;TCC.c,109 :: 		PORTD.B2 = 0;
	BCF         PORTD+0, 2 
;TCC.c,110 :: 		}
L_main42:
;TCC.c,111 :: 		}
	GOTO        L_main3
;TCC.c,112 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interruptConfig:

;TCC.c,113 :: 		void interruptConfig(){
;TCC.c,114 :: 		RCON.IPEN = 0;
	BCF         RCON+0, 7 
;TCC.c,115 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;TCC.c,116 :: 		INTCON.PEIE = 1;
	BSF         INTCON+0, 6 
;TCC.c,117 :: 		INTCON.INT0IE = 1;
	BSF         INTCON+0, 4 
;TCC.c,118 :: 		INTCON.INT0IF = 0;
	BCF         INTCON+0, 1 
;TCC.c,119 :: 		}
L_end_interruptConfig:
	RETURN      0
; end of _interruptConfig

_board_Init:

;TCC.c,120 :: 		void board_Init(){//Função de configuração dos bits.
;TCC.c,121 :: 		TRISC = 0x80;
	MOVLW       128
	MOVWF       TRISC+0 
;TCC.c,122 :: 		ADCON1 |= 0x0F;
	MOVLW       15
	IORWF       ADCON1+0, 1 
;TCC.c,123 :: 		CMCON  |= 7;
	MOVLW       7
	IORWF       CMCON+0, 1 
;TCC.c,124 :: 		TRISA = 255;
	MOVLW       255
	MOVWF       TRISA+0 
;TCC.c,125 :: 		TRISB = 0b00000000;//define PORTB como saída em todas as portas.
	CLRF        TRISB+0 
;TCC.c,127 :: 		TRISD = 0b00000000;//define PORTD como saída em todas as portas.
	CLRF        TRISD+0 
;TCC.c,128 :: 		TRISE = 0b00000000;//define PORTE como saída em todas as portas.
	CLRF        TRISE+0 
;TCC.c,129 :: 		PORTB = 0;//define PORTB recebendo 0 na entrada.
	CLRF        PORTB+0 
;TCC.c,131 :: 		PORTD = 0;//define PORTB recebendo 0 na entrada.
	CLRF        PORTD+0 
;TCC.c,132 :: 		PORTE = 0;//define PORTB recebendo 0 na entrada.
	CLRF        PORTE+0 
;TCC.c,133 :: 		}
L_end_board_Init:
	RETURN      0
; end of _board_Init
