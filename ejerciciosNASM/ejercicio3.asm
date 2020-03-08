; Se ingresan los 10 números ganadores de un sorteo. A continuación, se ingresan números. La computadora indica si los números ingresados están entre los sorteados y en qué posición.

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

arrayGanador:    
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

inicioStr:
    db    "Buscar numeros ganadores del sorteo. Ingrese 0 para finalizar:", 0

encontradoStr:
    db    "Encontrado en la posicion:", 0

noEncontradoStr:
    db    "No encontrado", 0


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

mostrarEspacio:             ; RUTINA PARA MOSTRAR UN SALTO DE LINEA USANDO PRINTF
        mov [caracter], byte ' '
        call mostrarCaracter
        ret

salirDelPrograma:                ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
        push 0
        call exit

_start:
main:                            ; PUNTO DE INICIO DEL PROGRAMA
        mov esi, 0
        
imprimirMsjInicio:
        mov ecx, [esi+inicioStr]
        mov [esi+cadena], ecx
        inc esi
        cmp ecx, 0
        jne imprimirMsjInicio
        call mostrarCadena
        call mostrarSaltoDeLinea
top:
        mov edi,0
        mov eax, 0
        mov ecx, 0
        mov ebx, 0
        mov esi, 0
        mov ebp, 0
        mov edx, 0

        call leerNumero
mid:
        mov eax, [numero]                  ; PASO EL NÚMERO RECIÉN LEÍDO A EAX
        mov ecx, [arrayGanador+edi]        ; PASO EL NÚMERO EN EL ARRAY DE GANADORES A ECX
        cmp eax, 0                         ; COMPARO SI EL NÚMERO INGRESADO ES 0 ENTONCES SALGO
        je finPrograma
        cmp ecx, eax                       ; COMPARO EL NÚMERO INGRESADO CON EL DEL ARRAY DE GANADORES
        je encontrado
        add edi, 4                         ; SALTO DE 4 EN 4 PORQUE ES UN DWORD
        add ebx, 1                         ; EBX NOS SIRVE COMO CONTADOR Y COMO POSICIÓN DEL NÚMERO EN CASO DE GANADOR
        cmp ebx, 10
        jne mid
        jmp noEncontrado

encontrado:
        mov ecx, [esi+encontradoStr]       ; ME MUEVO POR LA CADENA PARA MOSTRARLA COMPLETA
        mov [esi+cadena], ecx
        inc esi
        cmp ecx, 0
        jne encontrado
        call mostrarCadena
        add ebx, 1                         ; SUNMAMOS 1 AL CONTADOR PORQUE SE INICIALIZA EN 0
        mov [numero], ebx
        call mostrarNumero
        call mostrarSaltoDeLinea
        jmp top                            ; VOLVEMOS A EMPEZAR HASTA QUE SE INGRESA UN 0

noEncontrado:
        mov ecx, [esi+noEncontradoStr]
        mov [esi+cadena], ecx
        inc esi
        cmp ecx, 0
        jne noEncontrado
        call mostrarCadena
        call mostrarSaltoDeLinea
        jmp top                            ; VOLVEMOS A EMPEZAR HASTA QUE SE INGRESA UN 0

finPrograma:
        call mostrarSaltoDeLinea
        jmp salirDelPrograma