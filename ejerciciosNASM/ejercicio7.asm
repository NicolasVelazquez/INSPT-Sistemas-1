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

matriz:
	resd	100		 ;  matriz como maximo de 10x10
		
n:
	resd	1		 ;  lado de la matriz
m:
	resd	1		 ;  lado de la matriz

f:
	resd	1		 ; fila
		
c:
	resd	1		 ; columna

max:
	resd	1		 ; Donde vamos a guardar el número Máximo

fMax:
	resd	1		 ; columna Max

cMax:
	resd	1		 ; fila Max

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
	db    "N: ", 0		 ; Cadena "N: "

filaStr:
	db    "Fila:", 0	 ;  Cadena "Fila:"
	
columnaStr:
	db    " Columna:", 0	 ;  Cadena "Columna:"

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
imprimirM:						 ; Me pareció más limpio imprimir así
		mov [caracter], byte 'M'
		call mostrarCaracter
		mov [caracter], byte ':'
		call mostrarCaracter
		mov [caracter], byte ' '
		call mostrarCaracter
		ret
imprimirMax:						 
		mov [caracter], byte 'M'
		call mostrarCaracter
		mov [caracter], byte 'A'
		call mostrarCaracter
		mov [caracter], byte 'X'
		call mostrarCaracter
		mov [caracter], byte ':'
		call mostrarCaracter
		mov [caracter], byte ' '
		call mostrarCaracter
		ret
imprimirMaxPosF:						 
		mov [caracter], byte 'F'
		call mostrarCaracter
		mov [caracter], byte ':'
		call mostrarCaracter
		mov [caracter], byte ' '
		call mostrarCaracter
		ret
imprimirMaxPosC:						 
		mov [caracter], byte 'C'
		call mostrarCaracter
		mov [caracter], byte ':'
		call mostrarCaracter
		mov [caracter], byte ' '
		call mostrarCaracter
		ret

_start:
main:                            ; PUNTO DE INICIO DEL PROGRAMA
	mov esi, 0
	mov ebx, 0
	mov ecx, -9999
	mov [max], ecx
copiaAcadena1:
	mov al, [ebx+nStr]
	mov [ebx+cadena], al
	inc ebx
	cmp al, 0
	jne copiaAcadena1
	call mostrarCadena
	call leerNumero
		
	mov eax, [numero]
	cmp eax, 0
	jg seguir1
	jmp main
seguir1:
	cmp eax, 11
	jl seguir2
	jmp main
seguir2:						; Hago lo mismo que arriba pero on char en vez de cadena
	mov [n], eax				; n serán las filas

	call imprimirM
	call leerNumero
	mov eax, [numero]
	cmp eax, 0
	jg seguir3
	jmp main
seguir3:
	cmp eax, 11
	jl seguir4
	jmp main
seguir4:
	mov [m], eax				; Guardo en m el segundo valor ingresado que serán las columnas
		
	mov [f], dword 0
proximoF:
	mov [c], dword 0
proximoC:
	mov ebx, 0
copiaAcadena2:
	mov al, [ebx+filaStr]
	mov [ebx+cadena], al
	inc ebx
	cmp al, 0
	jne copiaAcadena2
	call mostrarCadena
		
	mov eax, [f]
	mov [numero], eax
	call mostrarNumero
	
	mov ebx, 0
copiaAcadena3:
	mov al, [ebx+columnaStr]
	mov [ebx+cadena], al
	inc ebx
	cmp al, 0
	jne copiaAcadena3
	call mostrarCadena

	mov eax, [c]
	mov [numero], eax
	call mostrarNumero

	mov eax, 32
	mov [caracter], eax
	call mostrarCaracter
	call mostrarCaracter
	call leerNumero
	mov eax, [numero]
	mov [esi+matriz], eax
	add esi, 4

	cmp eax, [max]
	jg colocarMax

volverColocar:
	inc dword [c]
	mov eax, [c]
	cmp eax, [m]
	jb proximoC
		
	inc dword [f]
	mov eax, [f]
	cmp eax, [n]
	jb proximoF

	call mostrarSaltoDeLinea
	
mostrarMax:
	mov eax, [max]
	mov [numero], eax
	call imprimirMax
	call mostrarNumero
	call mostrarSaltoDeLinea

	mov eax, [fMax]
	mov [numero], eax
	call imprimirMaxPosF
	call mostrarNumero
	call mostrarSaltoDeLinea

	mov eax, [cMax]
	mov [numero], eax
	call imprimirMaxPosC
	call mostrarNumero
	call mostrarSaltoDeLinea
	
    jmp salirDelPrograma
colocarMax:
	mov [max], eax
	mov eax, [f]
	mov [fMax], eax
	mov eax, [c]
	mov [cMax], eax
	jmp volverColocar