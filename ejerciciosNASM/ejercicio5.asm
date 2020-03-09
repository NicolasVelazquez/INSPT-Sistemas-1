;Se ingresa una cadena. La computadora muestra las subcadenas formadas por las posiciones pares e impares de la cadena. ;Ej: FAISANSACRO : ASNAR FIASCO

        global main              ; ETIQUETAS QUE MARCAN EL PUNTO DE INICIO DE LA EJECUCION
        global _start

        extern printf            ;
        extern scanf             ; FUNCIONES DE C (IMPORTADAS)
        extern exit              ;
        extern gets              ; GETS ES MUY PELIGROSA. SOLO USARLA EN EJERCICIOS BASICOS, JAMAS EN EL TRABAJO!!!

section .bss                     ; SECCION DE LAS VARIABLES

numero:
        resd    1                ; 1 dword (4 bytes)

cadena:
        resb    0x0100           ; 256 bytes

caracter:
        resb    1                ; 1 byte (dato)
        resb    3                ; 3 bytes (relleno)


section .data                    ; SECCION DE LAS CONSTANTES

fmtInt:
        db    "%d", 0            ; FORMATO PARA NUMEROS ENTEROS

fmtString:
        db    "%s", 0            ; FORMATO PARA CADENAS

fmtChar:
        db    "%c", 0            ; FORMATO PARA CARACTERES

fmtLF:
        db    0xA, 0             ; SALTO DE LINEA (LF)



section .text                    ; SECCION DE LAS INSTRUCCIONES
 
leerCadena:                      ; RUTINA PARA LEER UNA CADENA USANDO GETS
        push cadena
        call gets
        add esp, 4
        ret

leerNumero:                      ; RUTINA PARA LEER UN NUMERO ENTERO USANDO SCANF
        push numero
        push fmtInt
        call scanf
        add esp, 8
        ret
    
mostrarCadena:                   ; RUTINA PARA MOSTRAR UNA CADENA USANDO PRINTF
        push cadena
        push fmtString
        call printf
        add esp, 8
        ret

mostrarNumero:                   ; RUTINA PARA MOSTRAR UN NUMERO ENTERO USANDO PRINTF
        push dword [numero]
        push fmtInt
        call printf
        add esp, 8
        ret

mostrarCaracter:                 ; RUTINA PARA MOSTRAR UN CARACTER USANDO PRINTF
        push dword [caracter]
        push fmtChar
        call printf
        add esp, 8
        ret

mostrarSaltoDeLinea:             ; RUTINA PARA MOSTRAR UN SALTO DE LINEA USANDO PRINTF
        push fmtLF
        call printf
        add esp, 4
        ret

salirDelPrograma:                ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
        push 0
        call exit




_start:
main:                            ; PUNTO DE INICIO DEL PROGRAMA
	call leerCadena
        mov ebx, 1               ; EBX servirá para movernos dentro de la cadena
        mov edi, 0
        mov esi, 0               ; ESI usamos esi como flag para saber cuándo parar
imprimir:
        mov eax, [cadena+ebx]
        mov [caracter], eax
        call mostrarCaracter
        add ebx, 2
        inc edi
        mov al, [cadena+edi]
        cmp al, 0                ; Si llego al final de la cadena voy a imprimir los impares
        jne imprimir

imprimirEspacioYReiniciar:
        cmp esi, 1               ; Si ESI es 1 ya pasó por acá y el programa terminó
        je finPrograma
        mov esi, 1
        mov edi, 0
        mov ebx, 0
        mov eax, 32
        mov [caracter], eax
        call mostrarCaracter
        jmp imprimir

finPrograma:
        call mostrarSaltoDeLinea
        jmp salirDelPrograma