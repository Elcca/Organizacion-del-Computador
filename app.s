	.equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGH,   480
	.equ BITS_PER_PIXEL, 32

	.equ GPIO_BASE,    0x3f200000
	.equ GPIO_GPFSEL0, 0x00
	.equ GPIO_GPLEV0,  0x34
	.equ key_w, 0x2
	.equ key_a, 0x4
	.equ key_s, 0x8
	.equ key_d, 0x10
	.equ key_space, 0x20
	delay_time: .dword 0x8fffff

	.globl main

main:
	// x0 contiene la direccion base del framebuffer
	mov x20, x0 // Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------

	movz x10, 0xC7, lsl 16
	movk x10, 0x1585, lsl 00

	bl fondo

	mov x1,100
	mov x2,100
	mov x29,5000
	b leer
	//bl square
ejec_w:
	movz x3, 0xCC00, lsl 00
	add x29,x29,4
	mov x0, x29
	
	bl square
	bl delay	

	ret


fondo:
	mov x2, SCREEN_HEIGH         // Y Size
loop1:
	mov x1, SCREEN_WIDTH         // X Size
loop0:
	stur w10,[x0]  // Colorear el pixel N
	add x0,x0,4    // Siguiente pixel
	sub x1,x1,1    // Decrementar contador X
	cbnz x1,loop0  // Si no terminó la fila, salto
	sub x2,x2,1    // Decrementar contador Y
	cbnz x2,loop1  // Si no es la última fila, salto
	ret

square:
	lsl x0,x0,4		//avanzo al nro de la direccion
	add x0,x0,x20 	//direccion +x20
	mov x13,x2		//alto del cuadrado
	mov x14,SCREEN_WIDTH
	sub x14,x14,x1 //pixeles - ancho del cuadrado
	add x14,x14,x14
	add x14,x14,x14
	mov x11,x3

square1:
	mov x12,x1		//ancho del cuadrado
square2:	
	stur w11,[x0]
	add x0,x0,4
	sub x12,x12,1
	cbnz x12,square2
	add x0,x0,x14
	sub x13,x13,1
	cbnz x13,square1
	b leer

change:
	mov x3, 0x00
	mov x0, xzr
	bl square
	
delay:
        mov x9, delay_time
    delay_loop:
        subs x9, x9, 1
        cbnz x9, delay_loop
		ret

leer:
	mov x9, GPIO_BASE			//Seteo x9 en la direccion base de gpio
	
	// Setea gpios 0 - 9 como lectura
	str wzr, [x9, GPIO_GPFSEL0]

	// Lee el estado de los GPIO 0 - 31
	ldr w10, [x9, GPIO_GPLEV0]
	
	and w11, w10, 0b00000010	//Mascara de W
	and w12, w10, 0b00000100 	//Mascara de A

	cmp w11, key_w
	beq ejec_w

	cmp w12, key_a
	beq change

	b leer

	// si w11 es 0 entonces el GPIO 1 estaba liberado
	// de lo contrario será distinto de 0, (en este caso particular 2)
	// significando que el GPIO 1 fue presionado

	//---------------------------------------------------------------
	// Infinite Loop

InfLoop:
	b InfLoop
