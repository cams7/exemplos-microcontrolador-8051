;
;  Curso de Assembly para 8051 WR Kits
;
;  Aula 29 - Programar o Timer0, no Modo 1 
;
; Deseja-se programar o serviço de interrupção do Timer0 para o microcontrolador AT89S51:
;
; - Timer no modo 1 (contador de 16 bits);
; - Timer0 com alta prioridade de interrupção;
; - Configurar o estouro de T0 para ocorrer a cada 20ms
; - Utilizando o Timer0, complementar o barramento do PORT P0 a cada 400ms
;
; www.wrkits.com.br | facebook.com/wrkits | youtube.com/user/canalwrkits
;
; Autor: Eng. Wagner Rambo   |   Data: Dezembro de 2015
;
 
; --- Vetor de RESET (Externa - RST) ---
        org             0000h                   ;Origem no endereço 00h de memória
        ajmp            main                    ;Desvia das rotinas de interrupção
 
; --- Rotinas de Interrupção (Interna - Periférico) ---
        org             000Bh                   ;A interrupção do Timer0 aponta para este endereço
        
        acall           reinicia_contagem       ;Chama a subrotina (reinicia_contagem)        

        djnz            R0, exit_time0          ;Decrementa R0. R0 igual a zero? Não, desvia.
        acall           acende_proxima_led      ;Chama a subrotina (acende_proxima_led)

exit_time0:              
        reti                                    ;Retorna da interrupção
 
; --- Programa Principal ---
main:
        acall           inicializa_contador     ;Chama a subrotina (inicializa_contador)

        mov             a,#00h                  ;Move a constante 00h para o acc
        mov             P2,a                    ;Configurando o P2 como saída

        mov             a,#0FEh                 ;Move a constante FEh para o acc  1111 1110b
        mov             P2,a                    ;P2 inicia em 0000 0001

        mov             IE,#82h                 ;Habilita a interrupção do Timer0 e a global
                                                ;IE - Interrupt Enable
                                                ;EA .. ES ET1 EX1 ET0 EX0
                                                ;1  00 0  0   0   1   0

        mov             IP,#02h                 ;Configura timer0 com alta prioridade de interrupção
                                                ;IP - Interrupt Priority
                                                ;... PS PT1 PX1 PT0 PX0
                                                ;000 0  0   0   1   0

        mov             TCON,#10h               ;Habilita a contagem do Timer0
                                                ;TCON - Timer Control
                                                ;TF1 TR1 TF0 TR0 IE1 IT1 IE0 IT0
                                                ;0   0   0   1   0   0   0   0 

                                                ;TRx = 1 -> Liga a contagem      (x)
                                                ;TRx = 0 -> Desliga a contagem
                                                ;TFx = 1 -> Ocorreu overflow
                                                ;TFx = 0 -> Não ocorreu overflow (x)

        mov             TMOD,#01h               ;Configura o Timer0 para incrementar com ciclo de máquina
                                                ;Configura o Timer0 no modo 1 (16 bits)
                                                ;TMOD – Timer Mode
                                                ;Timer 1        Timer 0
                                                ;Gate C/T M1 M0 Gate C/T M1 M0
                                                ;0    0   0  0  0    0   0  1
        
        acall          reinicia_contagem        ;Chama a subrotina (reinicia_contagem) 
 
 
        ajmp            $                       ;Aguarda a interrupção...

inicializa_contador:
        mov             R0,#10h                 ;Move o valor 10h(16) para o contador (R0)
        ret

reinicia_contagem:                              ;Reinicia a contagem após 62,5 ms

                                                ;1 seg (delay)/16(contador) = 0,0625 seg = 62,5 ms
                                                ;0,0625/1e-6(ciclo de maquina) = 62500
                                                ;65536(2^16) - 62500 = 3036 => T0 = 3036 = 0BDC = 0000 1011 1101 1100

        mov             TH0,#0Bh                ;Inicializa TH0 em 0Bh
        mov             TL0,#0DCh               ;Inicializa TL0 em DCh
        ret                                     ;Retorna

acende_proxima_led:
        rr              a                       ;Rotaciona acc à direita
        mov             P2,a                    ;Move o valor acc para P2
         
        acall           inicializa_contador     ;Chama a subrotina (inicializa_contador)         
        ret                                     ;Retorna 
 
        end                                     ;Final do programa