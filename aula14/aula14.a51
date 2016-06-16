;
 ;  Curso de Assembly para 8051 WR Kits
 ;
 ;  Aula 014 - Sequencial de LEDs
 ;
 ;  Objetivo: Através de um botão, controlar a direção de acionamento de 8 LEDs no Port P2
 ;
 ;  MCU: AT89S51   Clock: 12MHz   Ciclo de Máquina = 1µs
 ;
 ;  Autor: Eng. Wagner Rambo    Data: Setembro de 2015
 ;
 ; www.wrkits.com.br | facebook.com/wrkits | youtube.com/user/canalwrkits
 ;
  
         org     0000h                   ; Origem no endereço 0000h de memória
 
 init:
         mov     a,#0ffh                 ; Carrega o acumulador com o valor ffh
         mov     P2,a                    ; Escreve valor do acumulador no Port P2
         
         mov     a,#7fh                  ; Carrega o acumulador com o valor 7fh
                                         ; 7fh = 0111 1111b
 main:
         mov     P2,a                    ; Escreve o valor de acc no Port P2        
         acall   delay500ms              ; Chama sub rotina de delay   
         jb      P1.0,left               ; P1.0 foi setado?         
                                         ; Sim, desvia para sub rotina left
                                         ; Não, continua o código...
 
 right:
         rr      a                       ; Rotate right em acc
         ajmp    main                    ; Pula para rotina "main"
  
 left:
         rl      a                       ; Rotate left em acc
         ajmp    main                    ; Pula para rotina "main"
  
 delay500ms:
                                         ; 2                             | Ciclos de máquina instruçaõ acall
         mov     R1,#0fah                ; 1                             | Move o valor 250 decimal para o registrador R1
  
 aux1:
         mov     R2,#0f9h                ; 1 x 250                       | Move o valor 249 decimal para o registrador R2
         nop                             ; 1 x 250                       | No operation
         nop                             ; 1 x 250                       | No operation
         nop                             ; 1 x 250                       | No operation
         nop                             ; 1 x 250                       | No operation
         nop                             ; 1 x 250                       | No operation
  
 aux2:
         nop                             ; 1 x 250 x 249 = 62250         | No operation
         nop                             ; 1 x 250 x 249 = 62250         | No operation
         nop                             ; 1 x 250 x 249 = 62250         | No operation
         nop                             ; 1 x 250 x 249 = 62250         | No operation
         nop                             ; 1 x 250 x 249 = 62250         | No operation
         nop                             ; 1 x 250 x 249 = 62250         | No operation
  
         djnz    R2,aux2                 ; 2 x 250 x 249 = 124500        | Decrementa o R2 até chegar a zero
         djnz    R1,aux1                 ; 2 x 250                       | Decrementa o R1 até chegar a zero
  
         ret                             ; 2                             | Retorna para a rotina main
                                         ; -----------------------------------
                                         ; Total = 500005µs ~~ 500ms = 0,5 seg
  
         end                             ; Final do programa