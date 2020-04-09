#line 1 "F:/Windows/Windows 7 (64-bit)/Shared/TCC ELETRÔNICA SERVICE PACK 1-20200324T230135Z-001/TCC ELETRÔNICA SERVICE PACK 1/PROGRAMAÇÃO (1)/TCC.c"
#pragma orgall 0x1000
#line 16 "F:/Windows/Windows 7 (64-bit)/Shared/TCC ELETRÔNICA SERVICE PACK 1-20200324T230135Z-001/TCC ELETRÔNICA SERVICE PACK 1/PROGRAMAÇÃO (1)/TCC.c"
sbit SPORTA at PORTA.B0;
sbit SCHAVE at PORTA.B1;
void board_Init();
void uartcom_init();
void interruptConfig();
char *pointer;
char option;
char output[64];

void interrupt(){
 if(INTCON.INT0IF == 1){
 pointer = &option;
 *pointer = 'X';
 INTCON.INT0IF = 0;
 }
}

void main()org 0x1000 {
unsigned int control;
unsigned int i;
unsigned int blink;
 board_Init();
 interruptConfig();
 UART1_Init(9600);
 delay_ms(100);
 UART1_Write_Text( "Iniciando sistema\r\n\0" );
 delay_ms(500);
 while(1){
 if (UART1_Data_Ready() == 1) {
 option = UART1_Read();
 if(!UART1_Data_Ready() && option != 'Z'){
 UART1_Write_Text( "Algum erro ocorreu no processo de conexão\r\n" );
 if (UART1_Data_Ready() == 1) {
 option = UART1_Read();
 }
 for(i = 0; i < 3; i++){
 PORTD.B3 = 1;
 delay_ms(500);
 PORTD.B3 = 0;
 }
 }
 }
 if(option == 'Z'){
 UART1_Write_Text( "O dado de acionamento foi recebido\r\n" );
 UART1_Write_Text(pointer);
 for(blink = 0; blink < 3; blink++){
 PORTD.B0 = 0;
 delay_ms(300);
 PORTD.B0 = 1;
 }
 if(SPORTA || SCHAVE){
 if(!SPORTA){
 UART1_Write_Text( "Aguardando porta... \r\n" );
 }
 else if(!SCHAVE){
 UART1_Write_Text( "Aguardando ignição... \r\n" );
 }
 }
 }
 else{
 for(i = 0; i < 3; i++){
 PORTD.B0 = 1;
 UART1_Write_Text( "Waiting start \r\n" );
 PORTD.B0 = 0;
 delay_ms(500);
 }
 i = 0;
 }
 if(SPORTA == 0 && SCHAVE == 0 && option == 'Z'){
 UART1_Write_Text( "Sistema protegido \r\n" );
 control =  1 ;
 if(control){
 PORTD.B1 = 1;
 PORTD.B2 = 1;
 }
 else{
 PORTD.B1 = 1;
 PORTD.B2 = 1;
 }
 while(control && option != 'X'){
 if (UART1_Data_Ready() == 1) {
 option = UART1_Read();
 }
 UART1_Write_Text( "Sistema em funcionando. \r\n" );
 delay_ms(1000);
 }
 if(option == 'X'){
 control =  0 ;
 UART1_Write_Text( "Sistema em bloqueado. \r\n" );
 }
 }
 else{
 PORTD.B1 = 0;
 PORTD.B2 = 0;
 }
 }
}
void interruptConfig(){
RCON.IPEN = 0;
INTCON.GIE = 1;
INTCON.PEIE = 1;
INTCON.INT0IE = 1;
INTCON.INT0IF = 0;
}
void board_Init(){
 TRISC = 0x80;
 ADCON1 |= 0x0F;
 CMCON |= 7;
 TRISA = 255;
 TRISB = 0b00000000;

 TRISD = 0b00000000;
 TRISE = 0b00000000;
 PORTB = 0;

 PORTD = 0;
 PORTE = 0;
}
