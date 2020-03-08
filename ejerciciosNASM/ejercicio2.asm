;  Se ingresan 10 números enteros. La computadora los muestra en orden creciente.

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

x:                               ; Inicializo el array
   dd  10
   dd  9
   dd  8
   dd  7
   dd  6
   dd  3
   dd  2
   dd  4
   dd  5
   dd  100

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

mostrarEspacio:             ; RUTINA PARA MOSTRAR UN ESPACIO USANDO PRINTF
        mov [caracter], byte ' '
        call mostrarCaracter
        ret

salirDelPrograma:                ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
        push 0
        call exit

_start:
main:                            ; PUNTO DE INICIO DEL PROGRAMA
        mov edi,0
        mov eax, 0
        mov ecx, 0
        mov ebx, 0
        mov esi, 0
        mov ebp, 0
        mov edx, 0

top:                             ; Llenamos el array
        call leerNumero
        mov eax, [numero]
        mov [x+edi], eax
        add edi, 4               ; Aumento de a 4 bytes porque es un dword
        add ebx, 1
        cmp ebx, 10              ; Si llego a 10 ya completé el array
        jne top

        mov eax, 0
        mov ebx, 0
        mov edi, 0

ordenar:
		mov ecx, [x+esi]
		cmp ecx, [x+esi+4]
		jg ubicarMayor
		add esi, 4
		cmp esi, 40               ; Como es un array de 10 números y ESI aumenta de a 4, si llego a 40 llegué al final del array
		je reiniciar
		jmp ordenar

ubicarMayor:
		mov ebp, [x+esi+4]
		mov [x+esi], ebp
		mov [x+esi+4], ecx
		add esi, 4
		add edx, 1                ; EDX será nuestro flag para saber si hubo cambios en el array
		jmp ordenar

reiniciar:
		cmp edx, 0                ; Si EDX es 0 significa que no hubo movimientos en esta vuelta y el array está ordenado
		je mostrar
		mov esi, 0
		mov edx, 0
		jmp ordenar
mostrar:
		mov eax, [x+edi]
		mov [numero], eax
		call mostrarNumero
        call mostrarEspacio
		add edi, 4
		add ebx, 1
		cmp ebx, 10
		jne mostrar
finPrograma:
        call mostrarSaltoDeLinea
        jmp salirDelPrograma