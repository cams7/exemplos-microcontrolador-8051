;
;  Curso de Assembly para 8051 WR Kits
;
;  Aula 22 - Utilizando a Interrupção Externa INT0 
;
; Deseja-se programar o serviço de interrupção externa no INT0 para o microcontrolador AT89S51:
;
; - INT0 em baixa prioridade, sensível à borda 
; - Quando houver borda de descida complementar o PORT0 no serviço de interrupção
;
; www.wrkits.com.br | facebook.com/wrkits | youtube.com/user/canalwrkits
;
; Autor: Eng. Wagner Rambo   |   Data: Outubro de 2015
;

; --- Vetor da RESET --- 
        org     0000h           ;Origem no endereço 0000h de memória
        ajmp    inicio          ;Desvia das interrupções

; --- Rotina de Interrupção INT0 (Externa - P3.2) --- 
        org     0003h           ;Endereço da interrupção do INT0
        rr      a               ;Rotaciona acc à direita
        mov     P2,a            ;Move conteúdo do acumulador para a PORTA P2
        reti                    ;Retorna da interrupção

; --- Rotina de Interrupção INT1 (Externa - P3.3) ---
        org     0013h           ;Endereço da interrupção do INT1
        rl      a               ;Rotaciona acc à esquerda
        mov     P2,a            ;Move conteúdo do acumulador para a PORTA P2
        reti                    ;Retorna da interrupção

; --- Final das Rotinas de Interrupção ---

; --- Configurações Iniciais ---
inicio:
        mov     a, #00h         ;Move constante 00h para acc
        mov     P2,a            ;Configura a PORTA P2 como saída
        
        mov     a,#0FFh         ;Move constante FFh para acc
        mov     P2,a            ;inicializa a PORTA P2
        
        mov     a,#10000101b    ;Move a constante 10000101b para acc
        mov     ie,a            ;Habilita interrupção INT0 e INT1
                                ;IE - Interrupt Enable
                                ;EA .. ES ET1 EX1 ET0 EX0
                                ;1  00 0  0   1   0   1

        mov     a,#00000101b    ;Move a constante 00000101b para acc
        mov     ip,a            ;INT0 e INT1 são de alta prioridade
                                ;IP - Interrupt Priority
                                ;... PS PT1 PX1 PT0 PX0
                                ;000 0  0   1   0   1

        mov     a,#00000101b    ;Move a constante 00000101b para acc
        mov     tcon,a          ;INT0 e INT1 são sensíveis à borda
                                ;TCON - Timer Control
                                ;TF1 TR1 TF0 TR0 IE1 IT1 IE0 IT0
                                ;0   0   0   0   0   1   0   1

        mov     a,#0FEh          ;Move constante FEh (1111 1110 b) para acc

        ajmp    $               ;Loop

        end                     ;Final do programa     