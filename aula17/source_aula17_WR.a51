;
;  Curso de Assembly para 8051 WR Kits
;
;  Aula 17 - Utilizando Delays Anti-Bouncing para Botões
;          
;
;
;
; www.wrkits.com.br | facebook.com/wrkits | youtube.com/user/canalwrkits
;
; Autor: Eng. Wagner Rambo   |   Data: Setembro de 2015
;

        org     0000h                   ;Origem no endereço 0000h de memória

init:
        mov     a,#0FFh                 ;Move a constante FFh para acc        
        mov     P2,a                    ;Inicializa PORTA P2

        mov     R0,a                    ;Move o conteúdo FFh(255) para o contador 1 (R0) (valor para delay do botão 1)
        mov     R1,a                    ;Move o conteúdo FFh(255) para o contador 2 (R1) (valor para delay do botão 2)
        mov     R2,a                    ;Move o conteúdo FFh(255) para o contador 3 (R2) (valor para delay do botão 3)
        mov     R3,a                    ;Move o conteúdo FFh(255) para o contador 4 (R3) (valor para delay do botão 4)

main:        
        acall   verifica_botao1         ;Chama a subrotina (verifica_botao1) 
        acall   verifica_botao2         ;Chama a subrotina (verifica_botao2) 
        acall   verifica_botao3         ;Chama a subrotina (verifica_botao3)
        acall   verifica_botao4         ;Chama a subrotina (verifica_botao4)     

        sjmp    main                    ;Sim, desvia para "main"

verifica_botao1:
        jb      P2.0,botao1_liberado    ;Botão 1 pressionado? Não, pula para a subrotina (botao1_liberado)
        djnz    R0,verifica_botao1      ;Sim. Decrementa o contador 1 (R0). R0 igual a zero? Não, desvia para a subrotina (verifica_botao1)
        jnb     B.0,led1_acende_apaga   ;Flag do botão 1 setada? Não, efetua ação do botão 1       

        ret

botao1_liberado:
        clr     B.0                     ;Limpa flag do botão 1 (marca como liberado)
        mov     R0,#0FFh                ;Move o conteúdo FFh(255) para o contador 1 (R0) (valor para delay do botão 1)
        sjmp    verifica_botao2         ;Desvia para a subrotina (verifica_botao2)              

led1_acende_apaga:        
        setb    B.0                     ;Seta flag do botão 1 (marca como pressionado)
        cpl     P2.4                    ;Liga LED 1
        sjmp    verifica_botao1         ;Desvia para a subrotina (verifica_botao1)

verifica_botao2:
        jb      P2.1,botao2_liberado    ;Botão 2 pressionado? Não, pula para a subrotina (botao2_liberado)
        djnz    R1,verifica_botao2      ;Sim. Decrementa o contador 2 (R1). R1 igual a zero? Não, desvia para a subrotina (verifica_botao2)
        jnb     B.1,led2_acende_apaga   ;Flag do botão 2 setada? Não, efetua ação do botão 2       

        ret

botao2_liberado:
        clr     B.1                     ;Limpa flag do botão 2 (marca como liberado)
        mov     R1,#0FFh                ;Move o conteúdo FFh(255) para o contador 2 (R1) (valor para delay do botão 2)
        sjmp    verifica_botao3         ;Desvia para a subrotina (verifica_botao3)              

led2_acende_apaga:        
        setb    B.1                     ;Seta flag do botão 2 (marca como pressionado)
        cpl     P2.5                    ;Liga LED 2
        sjmp    verifica_botao2         ;Desvia para a subrotina (verifica_botao2)

verifica_botao3:
        jb      P2.2,botao3_liberado    ;Botão 3 pressionado? Não, pula para a subrotina (botao3_liberado)
        djnz    R2,verifica_botao3      ;Sim. Decrementa o contador 3 (R2). R2 igual a zero? Não, desvia para a subrotina (verifica_botao3)
        jnb     B.2,led3_acende_apaga   ;Flag do botão 3 setada? Não, efetua ação do botão 3       

        ret

botao3_liberado:
        clr     B.2                     ;Limpa flag do botão 3 (marca como liberado)
        mov     R2,#0FFh                ;Move o conteúdo FFh(255) para o contador 3 (R2) (valor para delay do botão 3)
        sjmp    verifica_botao4         ;Desvia para a subrotina (verifica_botao4)              

led3_acende_apaga:        
        setb    B.2                     ;Seta flag do botão 3 (marca como pressionado)
        cpl     P2.6                    ;Liga LED 3
        sjmp    verifica_botao3         ;Desvia para a subrotina (verifica_botao3)

verifica_botao4:
        jb      P2.3,botao4_liberado    ;Botão 4 pressionado? Não, pula para a subrotina (botao4_liberado)
        djnz    R3,verifica_botao4      ;Sim. Decrementa o contador 4 (R3). R3 igual a zero? Não, desvia para a subrotina (verifica_botao4)
        jnb     B.3,led4_acende_apaga   ;Flag do botão 4 setada? Não, efetua ação do botão 4       

        ret

botao4_liberado:
        clr     B.3                     ;Limpa flag do botão 4 (marca como liberado)
        mov     R3,#0FFh                ;Move o conteúdo FFh(255) para o contador 4 (R3) (valor para delay do botão 4)
        sjmp    verifica_botao1         ;Desvia para a subrotina (verifica_botao1)              

led4_acende_apaga:        
        setb    B.3                     ;Seta flag do botão 4 (marca como pressionado)
        cpl     P2.7                    ;Liga LED 4
        sjmp    verifica_botao4         ;Desvia para a subrotina (verifica_botao4)                 

        end                             ;Final do Programa