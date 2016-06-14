;
; Aula 003
;
; Demonstração do ciclo de máquina (ciclo de instrução)
;
; Autor: Wagner Rambo
;
; Data: Junho de 2015
; 12MHz / 12 = 1MHz = 1us


            org         0000h            ;Origem no endereço 00h

inicio:

            mov         a,#01h          ;Move a constante 1h para o acumulador
            mov         p2,#00h         ;Move o valor 00h para o PORT2
            mov         p2,#0FFh        ;Move o valor FFh para o PORT2
            mov         a,#02h          ;Move a constante 2h para o acumulador
            jmp         inicio          ;Loop infinito

            end                         ;Final do programa