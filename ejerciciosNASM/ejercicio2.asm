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

x:    
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

mostrarEspacio:             ; RUTINA PARA MOSTRAR UN SALTO DE LINEA USANDO PRINTF
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

top:
        call leerNumero
        mov eax, [numero]
        mov [x+edi], eax
        add edi, 4
        add ebx, 1
        cmp ebx, 10
        jne top

        mov eax, 0
        mov ebx, 0
        mov edi, 0


ordenar:
		mov ecx, [x+esi]
		cmp ecx, [x+esi+4]
		ja ubicarMayor
		add esi, 4
		cmp esi, 40
		je reiniciar
		jmp ordenar

ubicarMayor:
		mov ebp, [x+esi+4]
		mov [x+esi], ebp
		mov [x+esi+4], ecx
		add esi, 4
		add edx, 1
		jmp ordenar

reiniciar:
		cmp edx, 0
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