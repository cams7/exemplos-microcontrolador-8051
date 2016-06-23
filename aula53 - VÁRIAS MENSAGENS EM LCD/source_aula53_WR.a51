;
;   Curso de Assembly para 8051 WR Kits
;
;   Aula 53 - Escrita na segunda linha do LCD modo 8 bits (padrão Hitachi HD44780U)
;
;
;       Mais de uma mensagem. Diversas mensagens no display LCD modo 8 bits
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
;   Autor: Eng. Wagner Rambo   |   Data: Junho de 2016
;
;


; --- Mapeamento de Hardware (PARADOXUS 8051) ---
         rs      equ     P1.5    ;Reg Select ligado em P1.7
         rw      equ     P1.6    ;Read/Write ligado em P1.6
         en      equ     P1.7    ;Enable ligado em P1.5
         dat     equ     P2      ;Bits de dados em todo P2


; --- Vetor de RESET ---
        org     0000h           ;origem no endereço 00h de memória
        acall   delay500ms      ;aguarda 500ms para estabilizar



; --- Programa Principal ---
inicio:

        acall   lcd_init        ;Chama sub rotina de inicialização

loop:
        
        mov     dptr,#LCD1      ;Move mensagem para DPTR
        acall   send_lcd        ;Chama sub rotina para enviar mensagem para LCD

        acall   new_line        ;Chama sub rotina para ir para próxima linha

        mov     dptr,#LCD2      ;Move mensagem para DPTR
        acall   send_lcd        ;Chama sub rotina para enviar mensagem para LCD

        acall   delay500ms      ;aguarda 500ms
        acall   delay500ms      ;aguarda 500ms

        acall   lcd_home        ;Chama sub rotina para voltar ao início do lcd

        mov     dptr,#LCD3      ;Move mensagem para DPTR
        acall   send_lcd        ;Chama sub rotina para enviar mensagem para LCD

        acall   new_line        ;Chama sub rotina para ir para próxima linha

        mov     dptr,#LCD4      ;Move mensagem para DPTR
        acall   send_lcd        ;Chama sub rotina para enviar mensagem para LCD

        acall   delay500ms      ;aguarda 500ms
        acall   delay500ms      ;aguarda 500ms

        acall   lcd_home        ;Chama sub rotina para voltar ao início do lcd
       
        ajmp    loop            ;Loop infinito


; --- Desenvolvimento das Sub Rotinas Auxiliares ---

;================================================================================
lcd_init:                       ;Sub Rotina para Inicialização do Display
 
        mov      a,#60d         ;move literal 00111100b para acc
        acall    config         ;chama sub rotina config
        mov      a,#14d         ;move literal 00001110b para acc
        acall    config         ;chama sub rotina config
        mov      a,#1d          ;move literal 00000001b para acc
        acall    config         ;chama sub rotina config
        mov      a,#6d          ;move literal 00000110b para acc
        acall    config         ;chama sub rotina config
        ret                     ;retorna

;================================================================================
config:                         ;Sub Rotina de Configuração

        clr      en             ;limpa pino en
        clr      rs             ;limpa pino rs
        clr      rw             ;limpa pino rw
        acall    wait           ;aguarda 55us
        setb     en             ;aciona enable
        acall    wait           ;aguarda 55us
        mov      dat,a          ;carrega dados em Port P2
        acall    wait           ;aguarda 55us com barramento igual ao valor de acc
        clr      en             ;limpa pino en
        acall    wait           ;aguarda 55us
        ret                     ;retorna

;================================================================================
send_lcd:                       ;Sub Rotina para Enviar dados ao LCD

        mov      R0,#0d         ;Move valor 0d para R0
send:
        mov      a,R0           ;Move conteúdo de R0 para acc
        inc      R0             ;Incrementa acc
        movc     a,@a+dptr      ;Move o byte relativo de dptr somado
                                ;com o valor de acc para acc
        acall    w_dat          ;chama sub rotina para escrita de dados
        cjne     R0,#16d,send   ;compara R0 com valor de colunas e desvia se for diferente
        ret                     ;retorna

;================================================================================
w_dat:                          ;Sub Rotina para preparar para escrita de mensagem

        clr      en             ;limpa enable
        setb     rs             ;seta rs
        clr      rw             ;limpa rw (escrita)
        acall    wait           ;aguarda 55us
        setb     en             ;seta enable
        acall    wait           ;aguarda 55us
        mov      dat,a          ;carrega mensagem
        acall    wait           ;aguarda 55us
        clr      en             ;limpa enable
        acall    wait           ;aguarda 55us
        ret                     ;retorna
  
;================================================================================
wait:                           ;Sub Rotina para atraso de 55us

        mov     R5,#055d        ;Carrega 55d em R5
aux0:           
        djnz    R5,aux0         ;Decrementa R5. R5 igual a zero? Não, desvia para aux
        ret                     ;Sim, retorna

;================================================================================
new_line:                       ;Sub Rotina para ir para nova linha

        mov      a,#0C0h        ;Carrega 192d em acc
        acall    config         ;chama sub rotina config
        ret                     ;retorna

;================================================================================
lcd_home:                       ;Sub Rotina para ir para o início do LCD

        mov      a,#02d         ;Carrega 2d em acc
        acall    config         ;chama sub rotina config
        ret                     ;retorna

;================================================================================


delay500ms:                     ;Sub Rotina para atraso de 500ms
                                ; 2       | ciclos de máquina do mnemônico call
        mov     R1,#0fah        ; 1       | move o valor 250 decimal para o registrador R1
 
aux1:
        mov     R2,#0f9h        ; 1 x 250 | move o valor 249 decimal para o registrador R2
        nop                     ; 1 x 250
        nop                     ; 1 x 250
        nop                     ; 1 x 250
        nop                     ; 1 x 250
        nop                     ; 1 x 250

aux2:
        nop                     ; 1 x 250 x 249 = 62250
        nop                     ; 1 x 250 x 249 = 62250
        nop                     ; 1 x 250 x 249 = 62250
        nop                     ; 1 x 250 x 249 = 62250
        nop                     ; 1 x 250 x 249 = 62250
        nop                     ; 1 x 250 x 249 = 62250

        djnz    R2,aux2         ; 2 x 250 x 249 = 124500     | decrementa o R2 até chegar a zero
        djnz    R1,aux1         ; 2 x 250                    | decrementa o R1 até chegar a zero

        ret                     ; 2                          | retorna para a função main
                                ;------------------------------------
                                ; Total = 500005 us ~~ 500 ms = 0,5 seg 


;================================================================================
; Definição de Mensagens para Enviar ao LCD
LCD1:
        db    '  PARADOXUS 8051'

LCD2:
        db    'Curso d Assembly'

LCD3:
        db    ' Comprar em     '

LCD4:
        db    ' www.wrkits.com '


        end                     ;Final do programa
   
   
   
   
   
   
   
   
   
   
   