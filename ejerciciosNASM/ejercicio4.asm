; Se ingresa una cadena. La computadora la muestra en mayusculas.
;
;
; En Windows (1 en la consola de NASM; 2 y 3 en la consola de Visual Studio):
; 1) nasm -f win32 ej3.asm --PREFIX _
; 2) link /out:ej3.exe ej3.obj libcmt.lib
; 3) ej3
;
; En Windows (1 en la consola de NASM; 2 y 3 en la consola de Windows, dentro de la carpeta [ajustando los nros. de version]: C:\Qt\Qt5.3.1\Tools\mingw482_32\bin ):
; 1) nasm -f win32 ej3.asm --PREFIX _
; 2) gcc ej3.obj -o ej3.exe
; 3) ej3
;
; En GNU/Linux:
; 1) nasm -f elf ej3.asm
; 2) ld -s -o ej3 ej3.o -lc -I /lib/ld-linux.so.2
; 3) ./ej3
;
; En GNU/Linux de 64 bits (Previamente, en Ubuntu, hay que ejecutar: sudo apt-get install libc6-dev-i386):
; 1) nasm -f elf ej3.asm
; 2) ld -m elf_i386 -s -o ej3 ej3.o -lc -I /lib/ld-linux.so.2
; 3) ./ej3


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

inicioStr:
    db    "Ingrese la cadena a revisar si es un palindromo:", 0

siStr:
    db    "Es palindromo", 0

noStr:
    db    "No es palindromo", 0


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
        mov esi, 0
        mov ebx, 0

        mov ecx, 0
        mov ebp, 0
        mov edx, 0

        call leerCadena

medirCadena:
        mov al, [edi + cadena]
        cmp al, 0
        je mid
        inc edi
        jmp medirCadena
mid:
        mov [numero], edi                  ; PASO EL NÚMERO RECIÉN LEÍDO A EAX
        call mostrarNumero
        call mostrarSaltoDeLinea

dividirPor2:
        mov eax, [numero]
        mov ebx, 2
        div ebx
        cmp edx, 0
        je recorrer

recorrer:
        
        mov [numero], eax
        call mostrarNumero
        call mostrarSaltoDeLinea
        mov [numero], esi
        call mostrarNumero
        call mostrarSaltoDeLinea

        cmp esi, eax
        je esPalindromo

        mov ah, [esi + cadena]
        mov [caracter], ah
        mov ah, [caracter]

        mov al, [edi - 1 + cadena]
        mov [caracter], al
        call mostrarCaracter
        call mostrarSaltoDeLinea

        cmp [caracter], ah
        je esPalindromo
        jmp finPrograma

esPalindromo:
        mov [caracter], byte 'S'
        call mostrarCaracter
        call mostrarSaltoDeLinea                

finPrograma:
        call mostrarSaltoDeLinea
        jmp salirDelPrograma