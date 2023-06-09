.ifndef ejec_s
.equ ejec_s, 0

/*
    En este archivo manejamos que sucede cuando la funcion leer manda 
    una ejecucion de alguna tecla
 */

.include "data.s"
.include "shapes.s"




//----------- DELAY -----------

/*
Esta funcion delay hace que la pc no nos detecte un monton de inputs con uno solo
Si al correr el programa te los detecta muy rapido o muy lento, podes cambiar la constante delay_time en data.s
*/

delay:
        ldr x9, delay_time
    delay_loop:
        subs x9, x9, 1
        bne delay_loop
    ret	

//----------- EJECUCION DE W ----------- 

ejec_w:
	//cargo la direccion de retorno en el stack pointer
	sub sp, sp, 8
	stur x30, [sp]

	bl check_next_w


	mov x1,x24						//x1 = ancho de la figura actual
	mov x2,x23						//x2 = alto de la figura actual
	mov x3, x25						//le damos a square el color del cuadrado actual
	sub x29,x29,SCREEN_WIDTH
	mov x0, x29
				
	bl casa

	mov x3, color_cielo

	bl rastro_w

    hit_w:

	bl delay

	ldur x30,[sp]
	add sp,sp,8
	ret

    check_next_w:
	    mov x14,SCREEN_WIDTH			
		mov x9,x29						//x9 = posicion de la figura
	    sub x9,x9,x14					//x9 = un pixel arriba de la posicion de la figura
	    lsl x9,x9,2						
	    add x9,x9,x20					//convierto x9 en posiciond el FB
	    mov x12,x1						//x12 = el ancho de la figura

	    mov x10,xzr						//x10 = color negro

        checkloop_w:
	        ldur w11,[x9]
	        cmp x11,x10
	        beq hit_w
	        sub x12,x12,1
	        add x9,x9,4
	        cbnz x12,checkloop_w

	    ret

    rastro_w:
	    mov x11, SCREEN_WIDTH
	    mov x9,x2
	    mul x11,x11,x9
	    add x9,x29,x11
	    lsl x9,x9,2
	    add x9,x9,x20
	    mov x10,x1

        rloop_w:
	        stur w3,[x9]
	        sub x10,x10,1
	        add x9,x9,4
	        cbnz x10,rloop_w
	    ret


//----------- EJECUCION DE A ----------- 

ejec_a:
	//cargo la direccion de retorno en el stack pointer
	sub sp, sp, 8
	stur x30, [sp]

	bl check_next_a

	mov x1,x24						//le doy el ancho de la figura
	mov x2,x23						//le doy el alto de la figura
	mov x3, x25						//le damos a square el color del cuadrado actual
	sub x29,x29,1
	mov x0, x29
	
	bl square	

	mov x3, color_cielo

	bl rastro_a

    hit_a:

	bl delay

	ldur x30,[sp]
	add sp,sp,8
	ret

    rastro_a:
	    add x9,x29,x1
	    lsl x9,x9,2
	    add x9,x9,x20
	    mov x10,x2
	    mov x11, SCREEN_WIDTH
	    mov x12,4
        rloop_a:
	        stur w3,[x9]
	        sub x10,x10,1
	        madd x9,x11,x12,x9
	        cbnz x10,rloop_a
	    ret

    check_next_a:
	    mov x10,xzr
	    mov x9,x29
	    sub x9,x9,1
	    //add x9,x9,1
	    lsl x9,x9,2
	    add x9,x9,x20
	    mov x12,x2

	    mov x13,4
	    mov x14,SCREEN_WIDTH
	    mul x13,x13,x14

        checkloop_a:
	        ldur w11,[x9]
	        cmp x11,x10
	        beq hit_a
	        sub x12,x12,1
	        add x9,x13,x9
	        cbnz x12,checkloop_a

	    ret

//----------- EJECUCION DE S ----------- 

ejec_s:
	//cargo la direccion de retorno en el stack pointer
	sub sp, sp, 0x8
	stur lr, [sp, #0]

	bl check_next_s

	mov x1,x24
	mov x2,x23
	mov x3, x25						//le damos a square el color del cuadrado actual
	add x29,x29,SCREEN_WIDTH
	mov x0, x29
	
	bl square	

	mov x3, color_cielo

	bl rastro_s

    hit_s:
	
	bl delay
	
	ldur lr,[sp]
	add sp,sp,8

	ret


    rastro_s:
	
	    sub x9,x29,SCREEN_WIDTH
	    lsl x9,x9,2
	    add x9,x9,x20
	    mov x10,x1

        rloop_s:
	        stur w3,[x9]
	        sub x10,x10,1
	        add x9,x9,4
	        cbnz x10,rloop_s
	    ret

    check_next_s:
	    mov x14,SCREEN_WIDTH
	    mov x13,x2
	    mul x13,x13,x14
	    //add x13,x13,SCREEN_WIDTH
	    mov x9,x29
	    add x9,x9,x13
	    lsl x9,x9,2
	    add x9,x9,x20
	    mov x12,x1

	    mov x10,color_pasto

        checkloop_s:
	        ldur w11,[x9]
	        cmp x11,x10
	        beq hit_s
	        sub x12,x12,1
	        add x9,x9,4
	        cbnz x12,checkloop_s

	    ret


//----------- EJECUCION DE D ----------- 

ejec_d:
	//cargo la direccion de retorno en el stack pointer
	sub sp, sp, 8
	stur lr, [sp]

	bl check_next_d

	mov x1,x24
	mov x2,x23
	mov x3, x25						//le damos a square el color del cuadrado actual
	add x29,x29,1					//le sumo 4 a la posicion donde empiezo el cuadrado
	mov x0, x29
				
	bl square

	mov x3, color_cielo

	bl rastro_d

    hit_d:

	bl delay

	ldur lr,[sp]
	add sp,sp,8

	ret

    check_next_d:
	    mov x10,xzr
	    mov x9,x29
	    add x9,x9,x1
	    //add x9,x9,1
	    lsl x9,x9,2
	    add x9,x9,x20
	    mov x12,x2

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

//----------- EJECUCION DE SPACE ----------- 

ejec_space:
	sub sp, sp, 8
	stur x30, [sp]

	cmp x26,xzr
	beq set_1
	b set_0

	set_1:
		mov x28,x29 				//le actualizamos la posicion a figura1
		mov x29,x27					//le cargamos a x29 la posicion de figura2
		mov x25,color_cuadrado2		//cargamos el color de figura 2
		mov x24,ancho2
		mov x23,alto2
		mov x26,1
		
		b retorno_space
	set_0:
		mov x27,x29 				//le actualizamos la posicion a figura1
		mov x29,x28					//le cargamos a x29 la posicion de figura2
		mov x25, color_cuadrado		//cargamos el color de figura 2
		mov x24,ancho
		mov x23,alto
		mov x26,xzr				
		b retorno_space

	retorno_space:
	bl delay

	ldur x30,[sp]
	add sp,sp,8
	ret

//----------- FINAL ----------- 


.endif
