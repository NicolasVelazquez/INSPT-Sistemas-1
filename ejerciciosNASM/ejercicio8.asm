; Se ingresa una matriz. La computadora muestra los valores en su diagonal segundaria y debajo el producto de éstos números.

        global main              ; ETIQUETAS QUE MARCAN EL PUNTO DE INICIO DE LA EJECUCION
        global _start

        extern printf            ;
        extern scanf             ; FUNCIONES DE C (IMPORTADAS)
        extern exit              ;
        extern gets              ; GETS ES MUY PELIGROSA. SOLO USARLA EN EJERCICIOS BASICOS, JAMAS EN EL TRABAJO!!!



section .bss                     ; SECCION DE LAS VARIABLES

numero:
        resd    1                ; 1 dword (4 bytes)
numero2:
        resd    1

cadena:
        resb    0x0100           ; 256 bytes

caracter:
        resb    1                ; 1 byte (dato)
        resb    3                ; 3 bytes (relleno)

matriz:
	resd	100		 ;  matriz como maximo de 10x10
		
n:
	resd	1		 ;  lado de la matriz (cuadrada)

f:
	resd	1		 ; fila
		
c:
	resd	1		 ; columna

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

_start:
main:                            ; PUNTO DE INICIO DEL PROGRAMA
	mov esi, 0
	mov ebx, 0
	mov eax, 1
	mov [numero2], eax
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
seguir2:		
	mov [n], eax
		
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
		
	inc dword [c]
	mov eax, [c]
	cmp eax, [n]
	jb proximoC
		
	inc dword [f]
	mov eax, [f]
	cmp eax, [n]
	jb proximoF

	call mostrarSaltoDeLinea
	
	mov edi, 0
	mov esi, matriz
cicloDiagonal:
	add esi, [n]
	add esi, [n]
	add esi, [n]
	add esi, [n]
	sub esi, 4

	mov eax, [esi]
	mov [numero], eax
	call mostrarNumero

	mov eax, [esi]
	mov ebx, [numero2]					; En numero2 vamos a estar acumulando la multiplicación
	mul ebx
	mov [numero2], eax

	mov eax, 32
	mov [caracter], eax
	call mostrarCaracter
	
	inc edi
	cmp edi, [n]
	jl cicloDiagonal

	call mostrarSaltoDeLinea
	call mostrarSaltoDeLinea

	mov eax, [numero2]
	mov [numero], eax
	call mostrarNumero
		
    jmp salirDelPrograma
