.ifndef shapes_s
.equ shapes_s, 0

/*
    En este archivo tenemos todas las funciones para printear figuras geometricas
 */

.include "data.s"

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


draw_borthers:
	mov x9,x20
	mov x10,xzr
	mov x12,SCREEN_WIDTH

	dloop1:
		stur wzr,[x9]
		sub x12,x12,1
		add x9,x9,4
		cbnz x12,dloop1

		mov x12, SCREEN_WIDTH
		mov x11, SCREEN_HEIGH
		sub x11,x11,1
		mul x9,x12,x11
		lsl x9,x9,2
		add x9,x9,x20

	dloop2:
		stur wzr,[x9]
		sub x12,x12,1
		add x9,x9,4
		cbnz x12,dloop2

		mov x9, SCREEN_WIDTH
		lsl x9,x9,2
		add x9,x9,x20
		sub x11,x9,4
		mov x12,SCREEN_HEIGH
		mov x10,SCREEN_WIDTH
		lsl x10,x10,2
	
	dloop3:
		stur wzr,[x9]
		stur wzr,[x11]
		sub x12,x12,1
		add x9,x9,x10
		add x11,x11,x10
		cbnz x12,dloop3
	ret

.endif
