	.include "data.s"
	.include "ejec.s"
	.include "shapes.s"

	.globl main

main:
	// x0 contiene la direccion base del framebuffer
	mov x20, x0 // Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------


	bl fondo
	
	mov x0, 0xffff
	mov x1, tamaño_casa2
	mov x2, tamaño_casa2

	bl casa

	bl registers
	
	bl draw_borthers
	
	bl leer


//----------- LECTURA DE INPUT -----------

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
