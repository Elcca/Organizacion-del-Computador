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

	bl check_next_w

	mov x1,x24						//x1 = ancho de la figura actual
	mov x2,x23						//x2 = alto de la figura actual
	sub x29,x29,SCREEN_WIDTH
	mov x0, x29

	bl casa

	mov x1,x24						
	mov x2,x23

	bl rastro_w

    hit_w:

	bl delay
	
	b leer

    check_next_w:
	    mov x9,x29						//x9 = posicion de la figura
	    sub x9,x9,SCREEN_WIDTH			//x9 = un pixel arriba de la posicion de la figura
	    lsl x9,x9,2						
	    add x9,x9,x20					//convierto x9 en posicion del FB
	    mov x12,x1						//x12 = el ancho de la figura

        checkloop_w:
	        ldur w11,[x9]
	        mov x10,xzr					//x10 = color negro
			cmp x11,x10					//si el proximo es negro "hit", no avanzo
	        beq hit_w

			mov x10,color_cielo
			cmp x11,x10					//si el color no es el del cielo comparo con el del pasto
	        bne next_color_w
			continue_w:

	        sub x12,x12,1
	        add x9,x9,4
	        cbnz x12,checkloop_w

		mov x14,SCREEN_WIDTH			
		mov x9,x29						//x9 = posicion de la figura
		sub x9,x9,x14
		mov x13,x2
		mul x13,x13,x14
		add x9,x9,x13					//aca estamos parados en el pixel de abajo a la izq de la figura, 
		lsl x9,x9,2						//todas nuestras figuras rellenan este pixel con el color del fondo
		add x9,x9,x20

		ldur w11,[x9]
	    mov x10,color_pasto				//x10 = color negro
		cmp x11,x10						//si el proximo es negro "hit", no avanzo
	    bne hit_w

	    ret

		next_color_w:
			mov x10,color_pasto
			cmp x11,x10					//si tampoco es el del pasto, es el color de algun dibujo (no avanzo)
	        bne hit_w
			b continue_w


    rastro_w:
		sub sp, sp, 8
		stur x30, [sp, 8]

	    mov x11, SCREEN_WIDTH
	    mov x0,x2
	    mul x11,x11,x0
	    add x0,x29,x11
	    lsl x0,x0,2
	    add x0,x0,x20
	    mov x10,x1

        rloop_w:
	        bl fill_background
	        sub x10,x10,1
	        add x0,x0,4
	        cbnz x10,rloop_w
		
		ldur x30,[sp, 8]
		add sp,sp,8
	    ret


//----------- EJECUCION DE A ----------- 

ejec_a:
	
	bl check_next_a

	mov x1,x24						//le doy el ancho de la figura
	mov x2,x23						//le doy el alto de la figura
	sub x29,x29,1
	mov x0, x29
	
	bl casa

	mov x1,x24						
	mov x2,x23

	bl rastro_a

    hit_a:

	bl delay
	
	b leer

    rastro_a:
		sub sp, sp, 8
		stur x30, [sp, 8]

	    add x0,x29,x1					//me paro a la derecha de la figura
	    lsl x0,x0,2
	    add x0,x0,x20
	    mov x10,x2
	    mov x11, SCREEN_WIDTH
	    mov x12,4
        rloop_a:
	        bl fill_background
	        sub x10,x10,1
	        madd x0,x11,x12,x0
	        cbnz x10,rloop_a
		
		ldur x30,[sp, 8]
		add sp, sp, 8
	    ret

    check_next_a:
	    mov x9,x29
	    sub x9,x9,1
	    lsl x9,x9,2
	    add x9,x9,x20
	    mov x12,x2

	    mov x13,4
	    mov x14,SCREEN_WIDTH
	    mul x13,x13,x14

        checkloop_a:
	        ldur w11,[x9]
			mov x10,xzr
	        cmp x11,x10
	        beq hit_a

			mov x10,color_cielo
			cmp x11,x10
	        bne next_color_a
			continue_a:

	        sub x12,x12,1
	        add x9,x13,x9
	        cbnz x12,checkloop_a

	    ret

		next_color_a:
			mov x10,color_pasto
			cmp x11,x10
			bne hit_a
			b continue_a

//----------- EJECUCION DE S ----------- 

ejec_s:

	bl check_next_s
	
	mov x1,x24
	mov x2,x23
	add x29,x29,SCREEN_WIDTH
	mov x0, x29

	bl casa

	mov x1,x24						
	mov x2,x23

	bl rastro_s

    hit_s:
	
	bl delay

	b leer


    rastro_s:
		sub sp, sp, 8
		stur x30, [sp, 8]

	    sub x0,x29,SCREEN_WIDTH
	    lsl x0,x0,2
	    add x0,x0,x20
	    mov x10,x1

        rloop_s:
	        bl fill_background
	        sub x10,x10,1
	        add x0,x0,4
	        cbnz x10,rloop_s

		ldur x30, [sp, 8]
		add sp, sp, 8
	    ret

    check_next_s:
	    mov x14,SCREEN_WIDTH
	    mov x13,x2
	    mul x13,x13,x14
	    mov x9,x29
	    add x9,x9,x13
	    lsl x9,x9,2
	    add x9,x9,x20
	    mov x12,x1

        checkloop_s:
	        ldur w11,[x9]
			mov x10,xzr
	        cmp x11,x10
	        beq hit_s

			mov x10,color_cielo
			cmp x11,x10
			bne next_color_s
			continue_s:

	        sub x12,x12,1
	        add x9,x9,4
	        cbnz x12,checkloop_s

	    ret

		next_color_s:
			mov x10,color_pasto
			cmp x11,x10
			bne hit_s
			b continue_s


//----------- EJECUCION DE D ----------- 

ejec_d:

	bl check_next_d

	mov x1,x24
	mov x2,x23
	add x29,x29,1					//le sumo 4 a la posicion donde empiezo el cuadrado
	mov x0, x29		
	
	bl casa

	mov x1,x24						
	mov x2,x23

	bl rastro_d

    hit_d:

	bl delay

	b leer

    check_next_d:
	    mov x9,x29
	    add x9,x9,x1
	    lsl x9,x9,2
	    add x9,x9,x20
	    mov x12,x2

	    mov x13,4
	    mov x14,SCREEN_WIDTH
	    mul x13,x13,x14

        checkloop_d:
	        ldur w11,[x9]
			mov x10,xzr
	        cmp x11,x10
	        beq hit_d

			mov x10,color_cielo
			cmp x11,x10
			bne next_color_d
			continue_d:

	        sub x12,x12,1
	        add x9,x13,x9
	        cbnz x12,checkloop_d

	    ret

		next_color_d:
			mov x10,color_pasto
			cmp x11,x10
			bne hit_d
			b continue_d

    rastro_d:
		sub sp, sp, 8
		stur x30, [sp, 8]

	    sub x0,x29,1
	    lsl x0,x0,2
	    add x0,x0,x20
	    mov x10,x2
	    mov x11, SCREEN_WIDTH
	    mov x12,4
        rloop_d:
	        bl fill_background
	        sub x10,x10,1
	        madd x0,x11,x12,x0
	        cbnz x10,rloop_d

		ldur x30, [sp, 8]
		add sp, sp, 8
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
		mov x24,tamaño_casa2
		mov x23,tamaño_casa2
		mov x26,1
		
		b retorno_space
	set_0:
		mov x27,x29 				//le actualizamos la posicion a figura2
		mov x29,x28					//le cargamos a x29 la posicion de figura1
		mov x24,tamaño_casa1
		mov x23,tamaño_casa1
		mov x26,xzr				
		b retorno_space

	retorno_space:
	bl delay

	ldur x30,[sp]
	add sp,sp,8
	
	b leer



//----------- FINAL ----------- 

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

.endif
