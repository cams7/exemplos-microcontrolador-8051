;
;  Aula 009 exemplo 03
;
;

        org     0000h
inicio:
        mov     r0,#0FFh        ; move a constante FF hex (255) para r0
loop:
        mov     p0,r0           ; move o conteúdo de r0 para p0
        djnz    r0,loop         ; r0 = r0-1 (r0--)
                                ; r0 = 0?
                                ; Não, desvia start
        jmp     inicio          ; desvia para label inicio

        end                     ; Final do programa
