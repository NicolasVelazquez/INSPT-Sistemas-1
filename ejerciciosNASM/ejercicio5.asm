;Se ingresan 100 caracteres. La computadora los muestra ordenados sin repeticiones.


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

valorAscii:
        resd    1               ; 1 dword (4 bytes)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


section .data                    ; SECCION DE LAS CONSTANTES

fmtInt:
        db    "%d", 0            ; FORMATO PARA NUMEROS ENTEROS

fmtString:
        db    "%s", 0            ; FORMATO PARA CADENAS

fmtChar:
        db    "%c", 0            ; FORMATO PARA CARACTERES

fmtLF:
        db    0xA, 0             ; SALTO DE LINEA (LF)

nStr:
        db    "Cantidad de N: ", 0           ; Cadena "N: "



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
        mov ebx, 100             ; Pongo el tope en ebx, no quiero que varíe
        mov esi, 0               ; Inicio contador en esi
        mov edi, 0
        mov ecx, 65
        mov [valorAscii], ecx      ; inicio ascii en 97
        call leerCadena

compararCaracterSiguiente:
        ;mov al, [cadena + esi]
        ;mov [caracter], al
        ;call mostrarCaracter
        ;call mostrarSaltoDeLinea
        
        mov al, [cadena + esi]                          ; Pongo el caracter cadena[esi] en al
        mov [numero], al                                ; Copio el valor ASCII de dicho caracter en numero
        mov eax, [numero]                               ; Copio el valor de numero en eax
        cmp eax, [valorAscii]                           ; Comparo eax con el ascii que quiero saber (primero a, luego b, luego c...)
        je mostrarAsciiEIncrementar                     ; Si son iguales, muestro el ascii e incremento el valor ascii en 1 (es decir, ahora busco b)
        inc esi                                         ; sino, incremento esi en 1
        cmp ebx, esi                                    ; Si esi llegó al limite, salgo
        je incrementarAscii      
        jmp compararCaracterSiguiente                   ; Sino, sigo iterando


mostrarAsciiEIncrementar:
        mov eax, [valorAscii]                           ; Copio el ascii en eax (eax = 97)
        mov [caracter], eax                             ; Pongo 97 en caracter
        call mostrarCaracter                            ; Invoco mostrarCaracter (muestra un 'a')
        mov eax, [valorAscii]                           ; Copio nuevamente el ascii en eax (eax = 97)
        inc eax                                         ; Sumo 1 a eax (98)
        cmp eax, 91                                    ; Comparo si terminé con los ascii, si terminé salgo
        je reiniciarMinusculas
        cmp eax, 123
        je finPrograma
        mov [valorAscii], eax                           ; Copio en valorAscii el nuevo valor (98)
        mov esi, 0                                      ; Reinicio esi para recorrer nuevamente la cadena
        jmp compararCaracterSiguiente                   ; Vuelvo a repetir el ciclo

reiniciarMinusculas:
        mov eax, 97
        mov [valorAscii], eax
        mov esi, 0
        jmp compararCaracterSiguiente

incrementarAscii:
        mov eax, [valorAscii]
        inc eax
        cmp eax, 123
        je finPrograma
        mov [valorAscii], eax
        mov esi, 0
        jmp compararCaracterSiguiente        

finPrograma:       
        call mostrarSaltoDeLinea
        jmp salirDelPrograma