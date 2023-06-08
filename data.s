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
	delay_time: .dword 0x8fffff
	.equ ancho, 50
	.equ alto, 50
	.equ color_cuadrado, 0xCC00
	.equ ancho2, 50
	.equ alto2, 50
	.equ color_cuadrado2, 0xF08241

registers:
    mov x29,5000		//posicion del cuadrado 
    mov x28,0xffff		//posicion del cuadrado2 

    ret

.endif
