.ifndef data_s
.equ data_s, 0

/*
    En este archivo seteamos todas las constantes y variables globales
 */

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
	delay_time: .dword 0x8fff8
	.equ ancho, 100
	.equ alto, 100
	.equ color_cuadrado, 0xCC00
	.equ ancho2, 200
	.equ alto2, 200
	color_cuadrado2: .dword 0x646282
	.equ color_cielo, 0x9999
	.equ color_pasto, 0x9900
	color_techo: .dword 0xCC000

	

registers:

	// x29 se usa para la posicion del cuadrado actual
    mov x28,5000		//posicion del cuadrado 
    mov x27,0xffff		//posicion del cuadrado2 
	mov x29,x28

	mov x26,xzr 		//x26 se usa para definir que figura se mueve

	// x25 se usa para el color del cuadrado actual
	mov x25, color_cuadrado // empezamos en el cuadrado 1
	// x24 se usa para el ancho del cuadrado actual
	mov x24, ancho 			// empezamos con el cuadrado 1
	// x23 se usa para el ancho del cuadrado actual
	mov x23, alto 			// empezamos con el cuadrado 1


    ret

.endif
