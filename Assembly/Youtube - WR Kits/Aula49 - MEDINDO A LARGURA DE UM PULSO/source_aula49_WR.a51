;
;   Curso de Assembly para 8051 WR Kits
;
;   Aula 49 - Medindo a Largura de um Pulso. 
;
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
;   Autor: Eng. Wagner Rambo   |   Data: Maio de 2016
;
;

; --- Vetor de RESET ---
        org     0000h           ;origem no endereço 00h de memória
        mov     a,#00h
        mov     P3,a
        sjmp    inicio          ;desvia dos vetores de interrupção

; --- Programa Principal ---
inicio:
        setb    TR0             ;Liga Timer0
                                ;TR0 = 1 -> Liga a contagem do Timer0
                                ;TR0 = 0 -> Desliga a contagem do Timer0

        mov     TMOD,#09h       ;Timer0 no Modo 1 (16 bits)
                                ;Seleciona o controle da contagem através de INT0
                                ;Registrador TMOD (Timer Mode) - Seleciona o Modo de Operação dos Timers
                                ;Timer 1        Timer 0
                                ;Gate C/T M1 M0 Gate C/T M1 M0
                                ;0    0   0  0  1    0   0  1

                                ;C/T = 0 –> Incremento do Timer pelo clock do microcontrolador
                                ;C/T = 1 –> Incremento do Timer por evento externo (pino T0 do PORT P3 para o Timer0 e pino T1 do PORT P3 para o Timer1)
                                ;Gate = 0 – Ativa a contagem em conjunto com o bit TR de TCON
                                ;Gate = 1 – Contagem condicionado aos pinos INT0 para o Timer0 ou INT1 para o Timer1, ambos presentes no barramento do PORT P3

                                ;Modo M1 M0 Definição
                                ;0 -  0  0  Contador de 32 bits
                                ;1 -  0  1  Contador de 16 bits
                                ;2 -  1  0  Contador de 8 bits com auto-reload
                                ;3 -  1  1  Time misto
        mov     R0,TL0
        mov     P1,TL0
        mov     R1,TH0

        ajmp    inicio


        end