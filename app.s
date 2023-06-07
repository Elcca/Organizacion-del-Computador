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
	.equ ancho, 50
	.equ alto, 50

	.globl main

main:
	// x0 contiene la direccion base del framebuffer
	mov x20, x0 // Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------

	movz x10, 0xC7, lsl 16
	movk x10, 0x1585, lsl 00

	bl fondo

	mov x1,ancho
	mov x2,alto
	mov x29,5000		//posicion del cuadrado de d
	mov x28,10000		//posicion del cuadrado de s
	mov x27,0xffff		//posicion del cuadrado de w
	mov x26,3000		//posicion del cuadrado de space

	bl linea_random
	bl linea_random2

	b leer

linea_random:
	mov x10,SCREEN_WIDTH
	lsl x9,x10,2
	add x11, x29, 60 		//que la linea arranque 60 pixeles a la derecha del cuadrado de d
	add x11,x11,x9			//que arranque unos pixeles mas abajo, para asegurarnos que la hitbox este bien hecha
	lsl x11, x11, 2			
	add x11,x11,x20			//lo convierto en direeciond el framebuffer
	mov x12,100				
lloop1:
	stur wzr,[x11]
	sub x12,x12,1
	add x11,x11,x9
	cbnz x12,lloop1
	ret

linea_random2:
	mov x11, x27
	mov x10,SCREEN_WIDTH
	lsl x10,x10,4
	sub x11,x11,x10
	lsl x11, x11, 2			
	add x11,x11,x20			//lo convierto en direeciond el framebuffer
	mov x12,100
lloop2:
	stur wzr,[x11]
	sub x12,x12,1
	add x11,x11,4
	cbnz x12,lloop2
	ret

rastro_d:
	sub x9,x29,1
	lsl x9,x9,2
	add x9,x9,x20
	mov x10,x2
	mov x11, SCREEN_WIDTH
	mov x12,4
rloop_d:
	stur w3,[x9]
	sub x10,x10,1
	madd x9,x11,x12,x9
	cbnz x10,rloop_d
	ret

check_next_d:
	mov x10,xzr
	mov x9,x29
	add x9,x9,ancho
	//add x9,x9,1
	lsl x9,x9,2
	add x9,x9,x20
	mov x12,alto

	mov x13,4
	mov x14,SCREEN_WIDTH
	mul x13,x13,x14

checkloop_d:
	ldur w11,[x9]
	cmp x11,x10
	beq hit_d
	sub x12,x12,1
	add x9,x13,x9
	cbnz x12,checkloop_d

	ret
	
ejec_d:
	//cargo la direccion de retorno en el stack pointer
	sub sp, sp, 8
	stur lr, [sp]

	bl check_next_d

	movz x3, 0xCC00, lsl 00			//seteo el color
	add x29,x29,1					//le sumo 4 a la posicion donde empiezo el cuadrado
	mov x0, x29

	bl square

	movz x3, 0xC7, lsl 16
	movk x3, 0x1585, lsl 00

	bl rastro_d

hit_d:

	bl delay

	ldur lr,[sp]
	add sp,sp,8

	ret

ejec_s:
	//cargo la direccion de retorno en el stack pointer
	//sub sp, sp, 0x8
	//stur lr, [sp, #0]

	movz x3, 0x4400, lsl 00
	add x28,x28,1
	mov x0, x28
	
	bl square	
	
	bl delay
	
	//ldur lr,[sp]
	//add sp,sp,8
	
	b leer

	ret


rastro_w:
	mov x11, SCREEN_WIDTH
	mov x9,alto
	mul x11,x11,x9
	add x9,x27,x11
	lsl x9,x9,2
	add x9,x9,x20
	mov x10,x2

rloop_w:
	stur w3,[x9]
	sub x10,x10,1
	add x9,x9,4
	cbnz x10,rloop_w
	ret

check_next_w:
	mov x14,SCREEN_WIDTH
	//lsl x14,x14,2
	mov x9,x27
	sub x9,x9,x14
	lsl x9,x9,2
	add x9,x9,x20
	mov x12,ancho

	mov x10,xzr

checkloop_w:
	ldur w11,[x9]
	cmp x11,x10
	beq hit_w
	sub x12,x12,1
	add x9,x9,4
	cbnz x12,checkloop_w

	ret

ejec_w:
	//cargo la direccion de retorno en el stack pointer
	sub sp, sp, 8
	stur x30, [sp]

	bl check_next_w

	movz x3, 0x1160, lsl 00
	sub x27,x27,SCREEN_WIDTH
	mov x0, x27
	
	bl square

	movz x3, 0xC7, lsl 16
	movk x3, 0x1585, lsl 00

	bl rastro_w

hit_w:

	bl delay

	ldur x30,[sp]
	add sp,sp,8
	ret

ejec_space:
	//cargo la direccion de retorno en el stack pointer
	sub sp, sp, 8
	stur x30, [sp]

	movz x3, 0x1160, lsl 16
	add x26,x26,1
	mov x0, x26
	
	bl square	

	bl delay

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
	lsl x0,x0,2		//avanzo al nro de la direccion
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

delay:
        ldr x9, delay_time
    delay_loop:
        subs x9, x9, 1
        bne delay_loop
        ret	

leer:
	mov x9, GPIO_BASE			//Seteo x9 en la direccion base de gpio
	
	// Setea gpios 0 - 9 como lectura
	str wzr, [x9, GPIO_GPFSEL0]

	// Lee el estado de los GPIO 0 - 31
	ldr w10, [x9, GPIO_GPLEV0]
	
	and w11, w10, key_w	//Mascara de w

	cmp w11, key_w
	beq ejec_w
	
	and w11, w10, key_a	//Mascara de a

	cmp w11, key_a
	beq ejec_a

	and w11, w10, key_s	//Mascara de s

	cmp w11, key_s
	beq ejec_s

	and w11, w10, key_d	//Mascara de d

	cmp w11, key_d
	beq ejec_d

	and w11, w10, key_space	//Mascara de space

	cmp w11, key_space
	beq ejec_space

	b leer

	

InfLoop:
	b InfLoop
