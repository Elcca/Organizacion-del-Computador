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
	.equ ancho, 100
	.equ alto, 100

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
	mov x29,5000		//posicion del cuadrado de w
	mov x28,10000		//posicion del cuadrado de s
	mov x27,1000		//posicion del cuadrado de d
	mov x26,3000		//posicion del cuadrado de space
	b leer
	
ejec_w:
	//cargo la direccion de retorno en el stack pointer
	sub sp, sp, 8
	stur lr, [sp]

	movz x3, 0xCC00, lsl 00			//seteo el color
	add x29,x29,20					//le sumo 4 a la posicion donde empiezo el cuadrado
	mov x0, x29
	
	bl square
	//bl delay	

	ldur lr,[sp]
	add sp,sp,8
	br lr

ejec_s:
	//cargo la direccion de retorno en el stack pointer
	sub sp, sp, 8
	stur x30, [sp]

	movz x3, 0x4400, lsl 00
	add x28,x28,4
	mov x0, x28
	
	bl square
	//bl delay	

	ldur x30,[sp]
	add sp,sp,8
	ret

ejec_d:
	//cargo la direccion de retorno en el stack pointer
	sub sp, sp, 8
	stur x30, [sp]

	movz x3, 0x1160, lsl 00
	add x27,x27,4
	mov x0, x27
	
	bl square
	//bl delay	

	ldur x30,[sp]
	add sp,sp,8
	ret

ejec_space:
	//cargo la direccion de retorno en el stack pointer
	sub sp, sp, 8
	stur x30, [sp]

	movz x3, 0x1160, lsl 16
	add x26,x26,4
	mov x0, x26
	
	bl square
	//bl delay	

	ldur x30,[sp]
	add sp,sp,8
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
	ret

ejec_a:
	//cargo la direccion de retorno en el stack pointer
	sub sp, sp, 8
	stur x30, [sp]

	mov x3, 0x00
	mov x0, xzr
	bl square

	ldur x30,[sp]
	add sp,sp,8
	ret
	

leer:
	mov x9, GPIO_BASE			//Seteo x9 en la direccion base de gpio
	
	// Setea gpios 0 - 9 como lectura
	str wzr, [x9, GPIO_GPFSEL0]

	// Lee el estado de los GPIO 0 - 31
	ldr w10, [x9, GPIO_GPLEV0]
	
	and w11, w10, key_w	//Mascara de W
	and w12, w10, key_a 	//Mascara de A
	and w13, w10, key_s 	//Mascara de S
	and w14, w10, key_d 	//Mascara de D
	and w15, w10, key_space //Mascara de space


	cmp w11, key_w
	beq ejec_w

	cmp w12, key_a
	beq ejec_a

	cmp w13, key_s
	beq ejec_s

	cmp w14, key_d
	beq ejec_d

	cmp w15, key_space
	beq ejec_space

	b leer

	

InfLoop:
	b InfLoop
