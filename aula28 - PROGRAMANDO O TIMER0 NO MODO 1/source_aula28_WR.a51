;
;  Curso de Assembly para 8051 WR Kits
;
;  Aula 28 - Programar o Timer0, no Modo 1 
;
; Deseja-se programar o serviço de interrupção do Timer0 para o microcontrolador AT89S51:
;
; - Timer no modo 1 (contador de 16 bits);
; - Timer0 com alta prioridade de interrupção;
; - Configurar o estouro de T0 para ocorrer a cada 20ms
;
; www.wrkits.com.br | facebook.com/wrkits | youtube.com/user/canalwrkits
;
; Autor: Eng. Wagner Rambo   |   Data: Dezembro de 2015
;

; --- Vetor de RESET (Externa - RST) ---
        org             0000h                   ;Origem no endereço 00h de memória
        ajmp            main                    ;Desvia das rotinas de interrupção

; --- Rotina de Interrupção do TIMER0 (Interna - Periférico) ---
        org             000Bh                   ;A interrupção do Timer0 aponta para este endereço
                
        acall            acende_proxima_led     ;Chama a subrotina (acende_proxima_led)
        
        reti                                    ;Retorna da interrupção
; --- Programa Principal ---

main:
        mov             R0,#14h                 ;Move o valor 14h(20) para o contador (R0)

        mov             a,#0FEh                 ;Move a constante 11111110b para acc
        mov             P2,a                    ;Configurando P2.0 como saída
        
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
;Modo M1 M0 Definição
;0 -  0  0  Contador de 32 bits
;1 -  0  1  Contador de 16 bits  (x)
;2 -  1  0  Contador de 8 bits com auto-reload
;3 -  1  1  Time misto

        acall          reinicia_contagem        ;Chama a subrotina (reinicia_contagem) 

        ajmp            $                       ;Aguarda a interrupção...

;T0 = 15536, contagem 65536 - 15536 = 50000 = 50ms
;65535 + 1 => 65536 x 1e-6 = 0,065536 seg = 65,536 ms (tempo máximo)
;15536     => 15536 x 1e-6 = 0,015536 seg = 15,536 ms
;Obs.: TH0 é o byte mais significativo, devido a isso, o TL0 é o menos significativo
reinicia_contagem:
        mov             TH0,#3Ch                ;Inicializa TH0 em 3Ch (0011 1100)                                      
        mov             TL0,#0B0h               ;Inicializa TL0 em B0h (1011 0000) 
                                                ;1111 1111 1111 1111 = 65535
                                                ;0011 1100 1011 0000 = 15536
        ret                                     ;Retorno da subrotina

acende_proxima_led:
        djnz            R0,reinicia_contagem    ;Sim. Decrementa o contador (R0). R0 igual a zero? Não, desvia para a subrotina (reinicia_contagem)

        mov             a,P2                    ;Move o valor de P2 para acc
        rl              a                       ;Rotaciona acc à esquerda
        mov             P2,a                    ;Move o valor acc para P2
        
        mov             R0,#14h                 ;Move o valor 14h(20) para o contador (R0)
        acall           reinicia_contagem       ;Chama a subrotina (reinicia_contagem)
        
        ret                                     ;Retorna da subrotina (acende_proxima_led)        

        end                                     ;Final do programa