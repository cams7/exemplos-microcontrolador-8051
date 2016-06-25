;
; Curso de Assembly para 8051 WR Kits Channel
;
; Utilizando botões para acionar saídas
;
; MCU: AT89S51   Clock: 12MHz   Ciclo de Máquina: 1us
;
; Autor: Eng. Wagner Rambo    Data: Setembro de 2015
;
; www.wrkits.com.br | facebook.com/wrkits | youtube.com/user/canalwrkits


        org     0000h                   ;Origem no endereço 0000h de memória

init:
        mov     A,#0Fh                  ;Move a constante 0Fh para acc  0000 1111b
        mov     P2,a                    ;Configura P2<0..3> como entrada
        ajmp    main                    ;Desvia para inicio

main:
        mov     a,#0FFh                 ;Move a constante FFh para acc
        mov     P2,a                    ;Inicializa PORTA P2 (LEDs desligados)

verifica_botao1:
        jb      P2.0,verifica_botao2    ;Botão 1 pressionado? Não, pula para "verifica_botao2"
        setb    B.0                     ;Sim, seta flag0
        sjmp    acende_led1             ;Desvia para "acende_led1"

verifica_botao2:
        jb      P2.1,verifica_botao3    ;Botão 2 pressionado? Não, pula para "verifica_botao3"
        setb    B.1                     ;Sim, seta flag1
        sjmp    acende_led2             ;Desvia para "acende_led2"

verifica_botao3:
        jb      P2.2,verifica_botao4    ;Botão 3 pressionado? Não, pula para "verifica_botao4"
        setb    B.2                     ;Sim, seta flag2
        sjmp    acende_led3             ;Desvia para "acende_led3"

verifica_botao4:
        jb      P2.3,verifica_botao1    ;Botão 4 pressionado? Não, pula para "verifica_botao1"
        setb    B.3                     ;Sim, seta flag3
        sjmp    acende_led4             ;Desvia para "acende_led4"

acende_led1:
        jnb     P2.0,$                  ;Botão 1 solto? Não, aguarda soltar... 
        clr     B.0                     ;Sim, limpa flag0
        mov     a,#0EFh                 ;Move constante EFh para acc  1110 1111b
        mov     P2,a                    ;Liga LED1
        sjmp    verifica_botao1         ;Volta para "verifica_botao1"

acende_led2:
        jnb     P2.1,$                  ;Botão 2 solto? Não, aguarda soltar...
        clr     B.1                     ;Sim, limpa flag1
        mov     a,#0DFh                 ;Move constante DFh para acc
        mov     P2,a                    ;Liga LED2
        sjmp    verifica_botao1         ;Volta para "verifica_botao1"

acende_led3:
        jnb     P2.2,$                  ;Botão 3 solto? Não, aguarda soltar...
        clr     B.2                     ;Sim, limpa flag2
        mov     a,#0BFh                 ;Move constante BFh para acc
        mov     P2,a                    ;Liga LED3
        sjmp    verifica_botao1         ;Volta para "verifica_botao1"

acende_led4:
        jnb     P2.3,$                  ;Botão 4 solto? Não, aguarda soltar...
        clr     B.3                     ;Sim, limpa flag3
        mov     a,#7Fh                  ;Move constante 7Fh para acc
        mov     P2,a                    ;Liga LED4
        sjmp    verifica_botao1         ;Volta para "verifica_botao1"
       

        end                             ;Final do programa

















