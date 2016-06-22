;
;   Curso de Assembly para 8051 WR Kits
;
;   Aula 47 - Mensagem Via Serial
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
;   Autor: Eng. Wagner Rambo   |   Data: Abril de 2016
;
;

; --- Vetor de RESET ---
        org     0000h                           ;Origem no endereço 0000h de memória

init:
        mov     TMOD,#20h                       ;Configura Timer1 no Modo2
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

        mov     TH1,#-3                         ;9600 baud rate
                                                ;"Cristal"/12*(1/("Baud Rate"/(2^"SMOD"/32)))
                                                ;Cristal: 11,059MHz, Baud Rate: 9600, SMOD:0
                                                ;11059000/12*(1/(9600/(2^0/32))) = 2,9999457... = 3
                                                ;2^8-3 = 253 = FD
                                                ;-3 = FD
                                
        mov     SCON,#50h                       ;8 bit, 1 stop bit, REN habilitado
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

        setb    TR1                             ;Inicia timer1
                                                ;TR1 = 1 -> Liga a contagem do Timer1
                                                ;TR1 = 0 -> Desliga a contagem do Timer1
main:   
        mov     A,#'H'                          ;acc recebe caractere "H"
        acall   transmite                       ;Chama sub rotina de transmissão
        mov     A,#'e'                          ;acc recebe caractere "e"
        acall   transmite       
        mov     A,#'l'                          ;acc recebe caractere "l" duas vezes
        acall   transmite       
        acall   transmite       
        mov     A,#'o'                          ;acc recebe caractere "o"
        acall   transmite       
        mov     A,#','                          ;acc recebe caractere ","
        acall   transmite       

        mov     A,#20h                         ;acc recebe caractere "espaço"
        acall   transmite       

        mov     A,#'W'                          ;acc recebe caractere "W"
        acall   transmite       
        mov     A,#'o'                          ;acc recebe caractere "o"
        acall   transmite       
        mov     A,#'r'                          ;acc recebe caractere "r"
        acall   transmite       
        mov     A,#'l'                          ;acc recebe caractere "l"
        acall   transmite       
        mov     A,#'d'                          ;acc recebe caractere "d"
        acall   transmite              
        mov     A,#'!'                          ;acc recebe caractere "!"
        acall   transmite       
        mov     A,#0Dh                          ;acc recebe caractere "Retorno do carro; retorno ao início da linha"
        acall   transmite 
        mov     A,#0Ah                          ;acc recebe caractere "Alimentação de linha; mudança de linha; nova linha"
        acall   transmite 
      
        acall   delay500ms
        sjmp    main                            ;Loop infinito


; --- Sub Rotina de Transmissão ---
transmite:
        mov     SBUF,A                          ;Carrega sbuf com acc
verifica_transmissao:
        jnb     TI, verifica_transmissao        ;Aguarda o próximo bit
        clr     TI                              ;Limpa TI
        ret                                     ;Retorna

; --- Subrotina de delay ---
delay500ms:                                     ; 2       | ciclos de máquina do mnemônico call
        mov     R1,#0FAh                        ; 1       | move o valor 250 decimal para o registrador R1
  
aux1:
        mov     R2,#0F9h                        ; 1 x 250 | move o valor 249 decimal para o registrador R2
        nop                                     ; 1 x 250
        nop                                     ; 1 x 250
        nop                                     ; 1 x 250
        nop                                     ; 1 x 250
        nop                                     ; 1 x 250
  
aux2:
        nop                                     ; 1 x 250 x 249 = 62250
        nop                                     ; 1 x 250 x 249 = 62250
        nop                                     ; 1 x 250 x 249 = 62250
        nop                                     ; 1 x 250 x 249 = 62250
        nop                                     ; 1 x 250 x 249 = 62250
        nop                                     ; 1 x 250 x 249 = 62250
  
        djnz    R2,aux2                         ; 2 x 250 x 249 = 124500     | decrementa o R2 até chegar a zero
        djnz    R1,aux1                         ; 2 x 250                    | decrementa o R1 até chegar a zero
  
        ret                                     ; 2                          | retorna para a função main
                                                ;------------------------------------
                                                ; Total = 500005 us ~~ 500 ms = 0,5 seg 

        end                                     ;Final do Programa