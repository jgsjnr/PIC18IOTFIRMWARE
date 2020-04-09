#define ERROR "Algum erro ocorreu no processo de conexão\r\n"
#define INIT "Iniciando sistema\r\n\0"
#define ACEPTED "O dado de acionamento foi recebido\r\n"
#define WAITING "Waiting start \r\n"
#define KEYORPORT "Aguardando porta ou chave\r\n"
#define PORTAX "Aguardando porta... \r\n"
#define CHAVEX "Aguardando ignição... \r\n"
#define PROTECTED "Sistema protegido \r\n"
#define STARTED "Sistema em funcionando. \r\n"
#define BLOCKED "Sistema em bloqueado. \r\n"
#define OFF 0
#define ON 1
#define OPEN 0
#define CLOSED 1
#pragma orgall 0x1000 //Envia o programa para o endereço 0x1000, logo após o bootloader.
sbit SPORTA   at        PORTA.B0; //Define a entrada 1 como sensor da porta
sbit SCHAVE   at        PORTA.B1; //Define a entrada 2 como sensor da chave
void board_Init();//Declaração da função de inicialização da placa
void uartcom_init();//Declaração da função de inicialização da caomunicação UART.
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

void main()org 0x1000 { //faz a função main ir para o enderço 0x1000 de memória.
unsigned int control;
unsigned int i;
unsigned int blink;
     board_Init(); //Função de "inicialização" da placa e configuração dos bits.
     interruptConfig();
     UART1_Init(9600); // Inicializa a comunicação serial UART com baudrate de 9600bps
     delay_ms(100); // Tempo para o módulo UART estabilizar a conexão.
     UART1_Write_Text(INIT); //Envia uma mensagem de inicialização.
     delay_ms(500);
     while(1){//Inicia o loop infinito.
              if (UART1_Data_Ready() == 1) {
                 option = UART1_Read();
                 if(!UART1_Data_Ready() && option != 'Z'){
                      UART1_Write_Text(ERROR);
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
                   UART1_Write_Text(ACEPTED);
                   UART1_Write_Text(pointer);
                    for(blink = 0; blink < 3; blink++){
                          PORTD.B0 = 0;
                          delay_ms(300);
                          PORTD.B0 = 1;
                    }
                    if(SPORTA || SCHAVE){
                           if(!SPORTA){
                           UART1_Write_Text(PORTAX);
                           }
                           else if(!SCHAVE){
                           UART1_Write_Text(CHAVEX);
                           }
                    }
              }
              else{
              for(i = 0; i < 3; i++){
                     PORTD.B0 = 1;
                     UART1_Write_Text(WAITING);
                     PORTD.B0 = 0;
                     delay_ms(500);
                   }
                   i = 0;
              }
              if(SPORTA == 0 && SCHAVE == 0 && option == 'Z'){//Realizaa verificação dos sensores.
                   UART1_Write_Text(PROTECTED);
                   control = ON;
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
                        UART1_Write_Text(STARTED);
                        delay_ms(1000);
                   }
                   if(option == 'X'){
                        control = OFF;
                        UART1_Write_Text(BLOCKED);
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
void board_Init(){//Função de configuração dos bits.
        TRISC = 0x80;
        ADCON1 |= 0x0F;
        CMCON  |= 7;
        TRISA = 255;
        TRISB = 0b00000000;//define PORTB como saída em todas as portas.
        //TRISC = 0b11111100;//define PORTC como saída em todas as portas, menos na porta 7, define ela como entrada por conta do RX.
        TRISD = 0b00000000;//define PORTD como saída em todas as portas.
        TRISE = 0b00000000;//define PORTE como saída em todas as portas.
        PORTB = 0;//define PORTB recebendo 0 na entrada.
        //PORTC = 0;//define PORTB recebendo 0 na entrada.
        PORTD = 0;//define PORTB recebendo 0 na entrada.
        PORTE = 0;//define PORTB recebendo 0 na entrada.
}