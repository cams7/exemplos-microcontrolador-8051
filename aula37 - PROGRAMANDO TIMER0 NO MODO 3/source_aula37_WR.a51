;
;   Curso de Assembly para 8051 WR Kits
;
;   Aula 37 - Programando o Timer0 no Modo 3 (8 bits misto)
;
;
;   Programar o Timer0 no Modo 3. 
;   
;   TL0 deverá ser responsável por gerar uma frequência aproximada de 2kHz em P2.0 _ T = 500µs, ton = toff = 250µs
;
;   TH0 deverá ser responsável por gerar uma frequência aproximada de 10kHz em P2.7 _ T = 100µs, ton = toff = 50µs
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
;   Autor: Eng. Wagner Rambo   |   Data: Fevereiro de 2016
;
;

; --- Constantes ---
        FREQ1   equ     P2.0    ;cria uma constante para o pino P2.0
        FREQ2   equ     P2.7    ;cria uma constante para o pino P2.7


; --- Vetor de RESET (Externa - RST) ---
        org     0000h           ;origem no endereço 00h de memória
        ajmp    main            ;desvia das rotinas de interrupção


; --- Vetor de Interrupção ---

; -- Vetor de Interrupção do TL0 (Modo 3) (Interna - Periférico) --
        org     000Bh           ;aponta para o endereço do Timer0 (TL0 em modo 3)
        mov     TL0,#06h        ;inicia o TL0 em 06h(6d)
                                ;2^8-6     = 250us * 2 = 500us => 1/(500 * 1e-6) = 2e3 => f=2KHz
                               
        cpl     FREQ1           ;inverte o estado de FREQ1 a cada interrupção

exit_timer0:
        reti                    ;retorna da interrupção


; -- Vetor de Interrupção do TH0 (Modo 3) (Interna - Periférico) --
        org     001Bh           ;aponta para o endereço do Timer1 (TH0 no modo 3)
        mov     TH0,#0CEh       ;inicia o TH0 em CEh(206d)
                                ;2^8-206   = 50us  * 2 = 100us => 1/(100 * 1e-6) = 1e4 => f=10KHz
                               
        cpl     FREQ2           ;inverte o estado de FREQ2 a cada interrupção

exit_timer1:
        reti                    ;retorna da interrupção


; --- Programa Principal ---
main:        
        mov     a,#00h          ;move a constante 00h no acc
        mov     P2,a            ;inicia P2 todo low (configura como saída)

        mov     IE,#8Ah         ;habilita interrupção do Timer0 e do Timer1
                                ;Registrador IE (Interrupt Enable) - Habilita Interrupção
                                ;EA .. ES ET1 EX1 ET0 EX0
                                ;1  00 0  1   0   1   0
                                    
                                ;EA (Enable All) – habilita todas interrupções
                                ;ES (Enable Serial) – habilita interrupção serial
                                ;ET1 (Enable Timer1) – habilita interrupção do Timer1
                                ;EX1 (Enable external1) – habilita interrupção externa INT1
                                ;ET0 (Enable Timer0) – habilita interrupção do Timer0
                                ;EX0 (Enable external0) – habilita interrupção externa INT0

        mov     IP,#00h         ;sem prioridade de interrupção
                                ;Registrador IP (Interrupt Priority) - Seleciona prioridade de interrupção
                                ;... PS PT1 PX1 PT0 PX0
                                ;000 0  0   0   0   0

                                ;PS (Priority Serial) – prioridade da serial
                                ;PT1 (Priority Timer1) – prioridade do Timer1
                                ;PX1 (Priority External1) – prioridade INT1
                                ;PT0 (Priority Timer0) – prioridade Timer0
                                ;PX0 (Priority External0) – prioridade INT0

        mov     TCON,#50h       ;habilita contagem de TH0 e TL0 (Modo3)
                                ;Registrador TCON (Timer Control) - Configura os tipos de interrupção e contém as flags de indicação
                                ;TF1 TR1 TF0 TR0 IE1 IT1 IE0 IT0
                                ;0   1   0   1   0   0   0   0

                                ;TRx = 1 -> Liga a contagem
                                ;TRx = 0 -> Desliga a contagem
                                ;TFx = 1 -> Flag de indicação: ocorreu overflow
                                ;TFx = 0 -> Flag de indicação: não ocorreu overflow
                                ;IEx = 0 -> Flag de indicação: não houve interrupção externa
                                ;IEx = 1 –> Flag de indicação: houve interrupção externa
                                ;ITx = 0 –> Interrupção externa sensível a nível
                                ;ITx = 1 –> Interrupção externa sensível à borda

        mov     TMOD,#03h       ;Configura modo 3 para o Timer0
                                ;Registrador TMOD (Timer Mode) - Seleciona o Modo de Operação dos Timers
                                ;Timer 1        Timer 0
                                ;Gate C/T M1 M0 Gate C/T M1 M0
                                ;0    0   0  0  0    0   1  1

                                ;C/T = 0 –> Incremento do Timer pelo clock do microcontrolador
                                ;C/T = 1 –> Incremento do Timer por evento externo (pino T0 do PORT P3 para o Timer0 e pino T1 do PORT P3 para o Timer1)
                                ;Gate = 0 – Ativa a contagem em conjunto com o bit TR de TCON
                                ;Gate = 1 – Contagem condicionado aos pinos INT0 para o Timer0 ou INT1 para o Timer1, ambos presentes no barramento do PORT P3

                                ;Modo M1 M0 Definição
                                ;0 -  0  0  Contador de 32 bits
                                ;1 -  0  1  Contador de 16 bits
                                ;2 -  1  0  Contador de 8 bits com auto-reload
                                ;3 -  1  1  Time misto

        mov     TL0,#06h        ;inicia o TL0 em 06h(6d)
        mov     TH0,#0CEh       ;inicia o TH0 em CEh(206d)
                                ;06 = 6(TL0), CE = 206(TH0)
                                ;2^8-6     = 250us * 2 = 500us => 1/(500 * 1e-6) = 2e3 => f=2KHz
                                ;2^8-206   = 50us  * 2 = 100us => 1/(100 * 1e-6) = 1e4 => f=10KHz                                                      
                                
        ajmp    $               ;Loop Infinito. Aguarda a interrupção...


        end                     ;Final do Programa