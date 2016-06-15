;
;  Aula 009 exemplo 02
;

        org     0000h
        clr     a

inicio:
        jz      aux2            ;a == 0?
        jnz     aux1            ;a != 0?

aux2:        
        mov     p0,#01h         ;move o valor 01h para p0
        mov     a, p0           ;carrega o valor de p0 para acc
        nop                     ;sem operação atrasar um ciclo de máquina
        nop                     ;sem operação atrasar um ciclo de máquina
        jmp     inicio          ;desvia para label inicio

aux1:
        mov     p0,#00h         ;move o valor 00h para p0
        mov     a, p0           ;carrega o valor de p0 para acc
        nop                     ;sem operação atrasar um ciclo de máquina
        jmp     inicio          ;desvia para label inicio

        end                     ;final do programa
