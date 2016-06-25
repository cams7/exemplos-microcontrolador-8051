;
;   Curso de Assembly para 8051 WR Kits
;
;   Aula 43 - Exemplo de programação da Serial. 
;   
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
;   Autor: Eng. Wagner Rambo   |   Data: Março de 2016
;
;

; --- Vetor de RESET (Externa - RST) ---
        org     0000h           ;origem no endereço 00h de memória
        sjmp    main            ;desvia dos vetores de interrupção


; --- Vetor de Interrupção Serial (Interna - Periférico) ---
        org     0023h           ;interrupção serial aponta para este endereço
        sjmp    trata_serial    ;desvia para o endereço da rotina de interrupção


; --- Programa Principal ---
main:

        mov     TMOD,#20h       ;Timer1 no modo 2
                                ;Registrador TMOD (Timer Mode) - Seleciona o Modo de Operação dos Timers
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

        mov     TH1,#0F4h       ;Timer1 configurado para gerar baud rate de 2400
                                ;F4(244)
                                ;2^8-244=12us
                                
        setb    TR1             ;Liga Timer1

        mov     IE,#90h         ;Habilita interrupção Serial
                                ;Registrador IE (Interrupt Enable) - Habilita Interrupção
                                ;EA .. ES ET1 EX1 ET0 EX0
                                ;1  00 1  0   0   0   0
                             
                                ;EA (Enable All) – habilita todas interrupções
                                ;ES (Enable Serial) – habilita interrupção serial
                                ;ET1 (Enable Timer1) – habilita interrupção do Timer1
                                ;EX1 (Enable external1) – habilita interrupção externa INT1
                                ;ET0 (Enable Timer0) – habilita interrupção do Timer0
                                ;EX0 (Enable external0) – habilita interrupção externa INT0

        mov     SCON,#50h       ;Serial no Modo 1, liberando o bit REN
                                ;Registrador SCON (Serial Control) - Controle da serial
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

        sjmp    $               ;Loop infinito


; --- Rotina de tratamento da Interrupção ---
trata_serial:
        mov     a,SBUF          ;Lê o conteúdo de SBUF e carrega em acc
        clr     RI              ;limpa bit de interrupção

exit_trata_seral:
        reti                    ;retorna da rotina de interrupção


        end                     ;Final do programa

















