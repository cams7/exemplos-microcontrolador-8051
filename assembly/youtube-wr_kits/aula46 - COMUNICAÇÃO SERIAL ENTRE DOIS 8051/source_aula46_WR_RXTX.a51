;
;   Curso de Assembly para 8051 WR Kits
;
;   Aula 46 - Comunicação Serial entre dois 8051
;
;   
;   MCU: AT89S51    Clock: 12MHz    Ciclo de Máquina: 1µs
;
;  
;   Sistema Sugerido: PARADOXUS 8051
;
;   Disponível a venda em https://wrkits.com.br/catalog/show/140
;
;
; www.wrkits.com.br | facebook.com/wrkits | youtube.com/user/canalwrkits
;
;   Autor: Eng. Wagner Rambo   |   Data: Abril de 2016
;
;

; --- Vetor de RESET (Externa - RST) ---
        org     0000h                   ;Origem no endereço 00h de memória
        ajmp    init                    ;Devia para a subrotina "init"

; --- Vetor de Interrupção (Interna - Periférico) ---
        org     0023h                   ;Vetor de interrupção serial
        ajmp    trata_recepcao          ;Devia para a subrotina "trata_recepcao"

init:
        mov     P2,#0FFh

        mov     IE,#90h                 ;Habilita interrupção Serial
                                        ;Registrador IE (Interrupt Enable) - Habilita Interrupção
                                        ;EA .. ES ET1 EX1 ET0 EX0
                                        ;1  00 1  0   0   0   0
                               
                                        ;EA (Enable All) – habilita todas interrupções
                                        ;ES (Enable Serial) – habilita interrupção serial
                                        ;ET1 (Enable Timer1) – habilita interrupção do Timer1
                                        ;EX1 (Enable external1) – habilita interrupção externa INT1
                                        ;ET0 (Enable Timer0) – habilita interrupção do Timer0
                                        ;EX0 (Enable external0) – habilita interrupção externa INT0

        mov     IP,#10h                 ;Registrador IP (Interrupt Priority) - Seleciona prioridade de interrupção
                                        ;... PS PT1 PX1 PT0 PX0
                                        ;000 1  0   0   0   0
 
                                        ;PS (Priority Serial) – prioridade da serial
                                        ;PT1 (Priority Timer1) – prioridade do Timer1
                                        ;PX1 (Priority External1) – prioridade INT1
                                        ;PT0 (Priority Timer0) – prioridade Timer0
                                        ;PX0 (Priority External0) – prioridade INT0

        mov     TCON,#40h               ;Registrador TCON (Timer Control) - Configura os tipos de interrupção e contém as flags de indicação
                                        ;TF1 TR1 TF0 TR0 IE1 IT1 IE0 IT0
                                        ;0   1   0   0   0   0   0   0
 
                                        ;TRx = 1 -> Liga a contagem
                                        ;TRx = 0 -> Desliga a contagem
                                        ;TFx = 1 -> Flag de indicação: ocorreu overflow
                                        ;TFx = 0 -> Flag de indicação: não ocorreu overflow
                                        ;IEx = 0 -> Flag de indicação: não houve interrupção externa
                                        ;IEx = 1 –> Flag de indicação: houve interrupção externa
                                        ;ITx = 0 –> Interrupção externa sensível a nível
                                        ;ITx = 1 –> Interrupção externa sensível à borda

        mov     TMOD,#20h               ;Registrador TMOD (Timer Mode) - Seleciona o Modo de Operação dos Timers
                                        ;Timer 1        Timer 0
                                        ;Gate C/T M1 M0 Gate C/T M1 M0
                                        ;0    0   1  0  0    0   0  0

                                        ;C/T = 0 –> Incremento do Timer pelo clock do microcontrolador
                                        ;C/T = 1 –> Incremento do Timer por evento externo (pino T0 do PORT P3 para o Timer0 e pino T1 do PORT P3 para o Timer1)
                                        ;Gate = 0 – Ativa a contagem em conjunto com o bit TR de TCON
                                        ;Gate = 1 – Contagem condicionado aos pinos INT0 para o Timer0 ou INT1 para o Timer1, ambos presentes no barramento do PORT P3

                                        ;Modo M1 M0 Definição
                                        ;0 -  0  0  Contador de 32 bits
                                        ;1 -  0  1  Contador de 16 bits
                                        ;2 -  1  0  Contador de 8 bits com auto-reload
                                        ;3 -  1  1  Time misto

        mov     PCON,#80h               ;Registrador PCON (Power Control Register)
                                        ;SMOD ... GF1 GF0 PD IDL
                                        ;1    000 0   0   0  0
                          
                                        ;SMOD – Dobra relação de divisão de frequência na Serial
                                        ;GF1 – Bit de uso geral
                                        ;GF0 – Bit de uso geral
                                        ;PD – Bit de Power-Down, onde o microcontrolador suspende suas atividades
                                        ;IDL – Bit de Idle, onde o microcontrolador suspende suas atividades

        mov     TH1,#0FAh               ;Gera baud rate de 9600
        mov     TL1,TH1                 ;valor inicial para um baud rate de 9600
                                        ;"Cristal"/12*(1/("Baud Rate"/(2^"SMOD"/32)))
                                        ;Cristal: 11,059MHz, Baud Rate: 9600, SMOD:1
                                        ;11059000/12*(1/(9600/(2^1/32))) = 5,99989... = 6
                                        ;2^8-6 = 250 = FA
        

        mov     SCON,#50h               ;Registrador SCON (Serial Control) - Controle da serial                                                
                                        ;SM0 SM1 SM2 REN TB8 RB8 TI RI
                                        ;0   1   0   1   0   0   0  0
                                   
                                        ;SM0 – Combinado com SM1, configura um dos 4 modos de operação
                                        ;SM1 – Combinado com SM0, configura um dos 4 modos de operação
                                        ;SM2 – Utilizado para multiprocessamento para os modos 2 e 3
                                        ;REN – Inicia a recepção de dados
                                        ;TB8 – Transmissão de um nono bit junto com cada byte transmitido
                                        ;RB8 – Recepção de um novo bit junto com cada byte transmitido
                                        ;TI – Flag de interrupção para transmissão
                                        ;RI – Flag de interrupção para recepção

                                        ;Modo SM0 SM1 Comunicação Tamanho Baud-Rate
                                        ;0 -  0   0   Síncrona    8bits   Fclock/12
                                        ;1 -  0   1   Assíncrona  8bits   Dado por Timer1
                                        ;2 -  1   0   Assíncrona  9bits   Fclock/32 ou /64
                                        ;3 -  1   1   Assíncrona  9bits   Dado por Timer1

main: 
        mov     A,P2                    ;Move o conteúdo de P2 para acc
        mov     SBUF,A                  ;Move o conteúdo de acc para SBUF                           

verifica_transmissao:                   ;Subrotina que verfifica se tem uma tranmissão ativa
        jnb     TI,verifica_transmissao ;Se o bit de transmissão for igual a igual a 0, volta a subrotina "verifica_transmissao" até que o valor desse bit seja 1
        clr     TI                      ;Limpa bit de interrupção da trnsmissão
        jmp     main                    ;Loop infinito         

trata_recepcao:                         ;Subrotina que processa os dados da serial         
        clr     RI                      ;Limpa bit de interrupção da recepção
        mov     A,SBUF                  ;Lê o conteúdo de SBUF e carrega em acc
        mov     P1,A                    ;Move o conteúdo de acc para P1
                   
sai_trata_recepcao:
        reti                            ;Retorna da rotina de interrupção

        end