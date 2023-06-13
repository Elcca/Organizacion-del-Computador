.ifndef shapes_s
.equ shapes_s, 0

/*
    En este archivo tenemos todas las funciones para printear figuras geometricas
 */

.include "data.s"

 
//----------- FONDO -----------

fondo:
	sub sp, sp, #8
	stur lr, [sp, #0]

	mov x3,color_cielo
	mov x1,SCREEN_WIDTH
	mov x2,SCREEN_HEIGH
	lsr x2,x2,1							//mitad del ancho de la pantalla 
	mov x0,xzr

	bl square

	mov x3,color_pasto
	mul x0,x1,x2						//empieza en el pixel del medio a la izq
	
	bl square

	bl Sol
	bl flores

	ldur lr,[sp, #0]
	add sp,sp,#8
	ret


//----------- CUADRADO -----------

/*
	Parametros: x0 pixel donde empieza el cuadrado
				x1 ancho
				x2 alto
				x3 color
*/
 
square:
	lsl x0,x0,2								//avanzo al nro de la direccion
	add x0,x0,x20 							//direccion +x20
	mov x13,x2								//alto del cuadrado
	mov x16,SCREEN_WIDTH
	sub x16,x16,x1 							//pixeles - ancho del cuadrado
	lsl x16,x16,2
	mov x11,x3

    square1:
	    mov x12,x1							//ancho del cuadrado
    square2:	
	    stur w11,[x0]
	    add x0,x0,4
	    sub x12,x12,1
	    cbnz x12,square2
	    add x0,x0,x16
	    sub x13,x13,1
	    cbnz x13,square1
	ret


square_fill:
	sub sp, sp, 8
	stur lr, [sp]

	lsl x0,x0,2								//avanzo al nro de la direccion
	add x0,x0,x20 							//direccion +x20
	mov x13,x2								//alto del cuadrado
	mov x16,SCREEN_WIDTH
	sub x16,x16,x1							 //pixeles - ancho del cuadrado
	lsl x16,x16,2

    squarefill1:
	    mov x12,x1							//ancho del cuadrado
    squarefill2:	
	    bl fill_background					//esta funcion detecta en que zona del fondo esta el pixel a dibujar, y elige de que color pintarlo para que matchee
	    add x0,x0,4
	    sub x12,x12,1
	    cbnz x12,squarefill2
	    add x0,x0,x16
	    sub x13,x13,1
	    cbnz x13,squarefill1

	ldur lr,[sp]
	add sp,sp,8
	ret

//----------- DIBUJO DE CASA -----------

/*
	A casa le paso x0: pixel donde empiezo el dibujo (arriba izq)
				   x1,x2: ancho y alto de la figura, en este caso es lo mismo
*/

casa:
	sub sp, sp, #8
	stur lr, [sp, #0]

	//en este bloque guardo valores utiles para calculos mas adelante
	mov x4,x0						//guardo x0 para usarlo en la funcion
	mov x6,x1						//guardo x1 para usarlo
	lsr x9,x2,1						//x9 = mitad del tamaño del dibujo
	mov x10,SCREEN_WIDTH			
	madd x5,x10,x9,x0				//x5 = el pixel del medio a la izq

	//bloque para tapar techo izq 
	mov x0,x5						//x0 = pixel del medio a la izq	
	mov x1,x9						//seteo tamaño del triangulo
	mov x2,x9
	bl trianguloc

	//bloque para dibujar techo izq
	mov x0, x5						//x0 = pixel del medio a la izq
	movz x3, 0xDF, lsl 16			//color del triangulo
	movk x3, 0x1F1F, lsl 0
	mov x1,x9						//seteo tamaño del triangulo
	mov x2,x9
	bl trianguloa

	//bloque para tapar el cuadrado de la casa izq
	mov x0, x5						//x0 = pixel del medio a la izq
	lsr x1,x9,1 					//ancho del cuadrado
	mov x2,x9						//alto
	bl square_fill
	
	//bloque para tapar el cuadrado de la casa der
	mov x0, x5						//x0 = pixel del medio a la izq
	add x0,x0,x9					//x0 = pixel de la izq medio + media figura
	lsr x10,x6,2					//x10 = un cuarto de la figura
	add x0,x0,x10					//x0 = x0 + 1/4 de la figura
	lsr x1,x9,1 					//ancho del cuadrado
	mov x2,x9						//alto del cuadrado
	bl square_fill
	
	//bloque para dibujar el cuadrado de la casa
	mov x0, x5						//x0 = pixel del medio a la izq
	lsr x10,x6,2					//x10 = un cuarto de la figura
	add x0,x0,x10
	mov x1,x9						//tamaño del cuadrado
	mov x2,x9
	movz x3, 0xFF, lsl 16
	movk x3, 0x9933, lsl 0
	bl square

	//bloque para dibujar la puerta de la casa
	mov x0, 3						
	lsr x10,x6,3
	madd x0,x0,x10,x5 				//1/8 del ancho * 3 + el pixel del medio a la izq (x5)
	mov x7, SCREEN_WIDTH
	madd x0,x10,x7,x0				//bajo 1/8 del alto en pixeles
	sub x2,x9,x10
	lsr x10,x6,2
	mov x1,x10
	movz x3, 0x72, lsl 16
	movk x3, 0x3208, lsl 0
	bl square

	//bloque para dibujar la manija de la puerta
	mov x0, 3						
	lsr x10,x6,3
	madd x0,x0,x10,x5 				//1/8 del ancho * 3 + el pixel del medio a la izq (x5)
	lsr x10,x6,2
	mov x7, SCREEN_WIDTH
	madd x0,x10,x7,x0				//bajo 1/8 del alto en pixeles
	add x0,x0,1						//lo muevo un poco por razones esteticas
	lsr x10,x6,5					//le doy a la manija 1/32 del grosor
	mov x1,x10
	mov x2,x10
	movz x3, 0xD2, lsl 16
	movk x3, 0xAE1C, lsl 0
	bl square

	//bloque para dibujar techo der
	add x0,x4,x9					//x0 = el pixel de arriba al medio
	movz x3, 0xDF, lsl 16			
	movk x3, 0x321F, lsl 0
	mov x1,x9
	mov x2,x9
	bl triangulob

	//bloque para tapar techo der
	add x0,x4,x9					 		
	mov x1,x9
	mov x2,x9
	bl triangulo



	

	ldur lr,[sp, #0]
	add sp,sp,#8
	ret

//----------- DIBUJO DE BORDES -----------

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

// --------------------- relleno de fondo -----------------------------

fill_background:
	mov x15,SCREEN_WIDTH
	mov x17,SCREEN_HEIGH
	lsr x17,x17,1
	mul x14,x15,x17				//pixel de inicio del pasto / final del cielo
	lsl x14,x14,2
	add x14,x14,x20


	cmp x0,x14
	b.ge pasto
	b cielo

	cielo:
		mov x3, color_cielo 
		stur w3,[x0]
		b endfill
	pasto:
		mov x3, color_pasto
		stur w3,[x0]
		b endfill
	endfill:
	ret

// --------------------- triangulos -----------------------------

triangulo:
	sub sp, sp, 8
	stur lr, [sp]

	mov x11,xzr
	mov x16,xzr
	mov x13, x2        		// salvo Y Size
	lsl x0,x0,2		//avanzo al nro de la direccion
	add x0,x0,x20 	//direccion +x20
	mov x21, SCREEN_WIDTH
	mov x19,4

	loop5:

    	mov x8, x1         	// salvo X Size
		sub x8,x8,x16

	loop6:

    	bl fill_background 				// Colorear el pixel N
   		add x0,x0,4   				// Siguiente pixel
    	sub x8,x8,1    			// Decrementar contador X
    	cbnz x8,loop6  			// Si no terminó la fila, salto
		
		sub x13,x13,1    			// Decrementar contador Y
		msub x0,x19,x1,x0			//vuelvo al princio de la linea que estoy pintado x0=x0-x1*4
		madd x0,x21,x19,x0  	//x0=x0+640*4
		add x16,x16,1
	 	mul x11,x16,x19
		add x0,x0,x11
	 	cbnz x13,loop5  			// Si no es la última fila, saltostur w11,[x20]
	
	ldur lr,[sp]
	add sp,sp,8
	
	ret

trianguloa:

	lsl x0,x0,2		//avanzo al nro de la direccion
	add x0,x0,x20 	//direccion +x20
	mov x11,xzr
	mov x16,xzr
	mov x13, x2        		// salvo Y Size
	mov x21, SCREEN_WIDTH
	mov x19,4

	loop5a:

    	mov x8, x1         	// salvo X Size
		sub x8,x8,x16

	loop6a:

    	stur w3,[x0] 				// Colorear el pixel N
    	add x0,x0,4   				// Siguiente pixel
    	sub x8,x8,1    			// Decrementar contador X
    	cbnz x8,loop6a  			// Si no terminó la fila, salto
		
		sub x13,x13,1    			// Decrementar contador Y
		msub x0,x19,x1,x0			//vuelvo al princio de la linea que estoy pintado x0=x0-x1*4
		msub x0,x21,x19,x0  	//x0=x0+640*4
		add x16,x16,1
	    mul x11,x16,x19
		add x0,x0,x11
	    cbnz x13,loop5a  			// Si no es la última fila, saltostur w11,[x20]

	ret

triangulob:

	lsl x0,x0,2		//avanzo al nro de la direccion
	add x0,x0,x20 	//direccion +x20
	mov x11,xzr
	mov x16,x1
	mov x13, x2        		// salvo Y Size
	mov x18,1
	mov x21, SCREEN_WIDTH
	mov x19,4

	loop5b:

    	mov x8, x18         	// salvo X Size

	loop6b:

    	stur w3,[x0] 				// Colorear el pixel N
    	add x0,x0,4   				// Siguiente pixel
    	sub x8,x8,1    			// Decrementar contador X
    	cbnz x8,loop6b  			// Si no terminó la fila, salto
		
		sub x13,x13,1    			// Decrementar contador Y
		msub x0,x19,x18,x0			//vuelvo al princio de la linea que estoy pintado x0=x0-x1*4
		madd x0,x21,x19,x0  	//x0=x0+640*4
		add x18,x18,1
	  
	  	cbnz x13,loop5b  			// Si no es la última fila, saltostur w11,[x20]

	ret


trianguloc:
	sub sp, sp, 8
	stur lr, [sp]

	lsl x0,x0,2		//avanzo al nro de la direccion
	add x0,x0,x20 	//direccion +x20
	mov x11,xzr
	mov x16,x1
	mov x13, x2        		// salvo Y Size
	mov x18,1
	mov x21, SCREEN_WIDTH
	mov x19,4

	loop5c:

    	mov x8, x18         	// salvo X Size

	loop6c:

    	bl fill_background 				// Colorear el pixel N
    	add x0,x0,4   				// Siguiente pixel
    	sub x8,x8,1    			// Decrementar contador X
    	cbnz x8,loop6c  			// Si no terminó la fila, salto
		
		sub x13,x13,1    			// Decrementar contador Y
		msub x0,x19,x18,x0			//vuelvo al princio de la linea que estoy pintado x0=x0-x1*4
		msub x0,x21,x19,x0  	//x0=x0+640*4
		add x18,x18,1
	  
	  	cbnz x13,loop5c  			// Si no es la última fila, saltostur w11,[x20]

		mov x0,x20

	ldur lr,[sp]
	add sp,sp,8

	ret


// --------------------- circulo -----------------------------


circuloF:				//x14=X0  x15=Y0	x16=X1 x17=Y1		x23=Xsize x24=Ysize
			mov x14,xzr
			mov x15,xzr
			mov x16,xzr
			mov x17,xzr
			mov x23,xzr
			mov x24,xzr
			mov x25,xzr
			mov x26,xzr
			mov x14,x4		//guardo mis coordenadas del centro
			mov x15,x3


			sub x16,x4,x1	//x16 y x17 tienen mis coordenadas del incio del cuadrado
			sub x17,x3,x1
			sub sp,sp, #8  //elimino mis 2 ultimos elementos de la pila
			str x30,[sp,#0]	//guardo x3 y x4



			
			//"pinto el cuadrado dependiendo si cumple las condiciones" de aca en adelante es muy parecido a la funcion cuadrado solo que pregunto si cumple la condicion de calculo para pintar el pixel
			lsl x24,x1,1		//Ysize

			loop7F:
			mov x4,x16
			mov x3,x17



			bl direccion

			lsl x23,x1,1		//Xsize

			loop8F:

			bl calculoF				//hago los calculos necesarios con pitagora para ver si la hipotenusa geenerada por la linea entre el centro del circulo y el pixel que estoy viendo 
			b.le colorearF			//coloreo el circulo
			bl direccion			//calculo la direccion de mi x0
			
			siguienteF:	
   		add x0,x0,4  			// Siguiente pixel
			add x16,x16,1			//siguiente coordenada en x
    	sub x23,x23,1  	  // Decrementar contador de mi diametro
		
    	cbnz x23,loop8F 		// Si no terminó la fila, salto
		
			sub x24,x24,1   		// Decrementar contador Y
			add x17,x17,1				//siguiente pixel en Y
			sub x16,x14,x1 			//pongo devuelta mi coordenadad de x En 0
			msub x0,x19,x1,x0		//vuelvo al princio de la linea que estoy pintado x0=x0-x1*4
			madd x0,x21,x19,x0  //x0=x0+640*4
	  	cbnz x24,loop7F  		// Si no es la última fila, saltostur w11,[x20]


			ldr x30,[sp,#0]  				//cargo x3 y x4 a sus valores originales y decremento la pila en 2  
			add sp,sp, #8 


			ret

			colorearF:
			stur w11,[x0]  		// Colorear el pixel N
			b siguienteF				//sigo viendo mis demas pixeles

			calculoF:						
			//x25 x26 x27 auxiliares
		 	mov x25,x16			//salvo mis x1 y1
		 	mov x26,x17
			

			sub x25,x25,x14		// x25=x1-x0
			mul x25,x25,x25		//x25=x25 al cuadrado
			sub x26,x26,x15		//x26=y1-y0
			mul x26,x26,x26		//x26=x26 al cuadrado

			add x25,x26,x25		//x25=x26+x25
			mov x26,x1				//x26 ahora es el radio

			mul x26,x26,x26		//x26 es radio cuadrado
			cmp x25,x26		//x25 = x25 - diametro
			stur w10,[x0]  		// Colorear el pixel N
			b.gt siguienteF		//si mi radio cuadrado en mayor extricto que mi x25 NO pinto ese pixel
			b colorearF				//si es menor lo pinto
		
//--------------------------------------------------------FIN-CIRCULO-FONDO--------------------------------------------------------------//

direccion:

	sub sp,sp, #16  //elimino mis 2 ultimos elementos de la pila
	str x3,[sp,#0]	//guardo x3 y x4
	str x4,[sp,#8]



		mov x21,SCREEN_WIDTH
		mov x13,xzr  				//auxiliar
		mov x0,x20					//seteo x0 al principio asi me muevo hasta las coordenadas deseadas
		madd x13,x3,x21,x4			// mi x3 y x4 son las coordenadas que deseo para ello utilizo la formula x13=x4+x3*640 siendo x3=a mi coordenada Y x21=ancho de pantalla x4=cooredana x 
		lsl x13,x13,2				//multiplico mi auxiliar por 4 para pasarlo a bits
		add x0,x0,x13				//cargo en x0 mi valor auxiliar o el punto donde empiezo a dibujar

	ldr x4,[sp,#8]  				//cargo x3 y x4 a sus valores originales y decremento la pila en 2 
	ldr x3, [sp,#0] 
	add sp,sp, #16  

	ret
 
coordenadas:
			sub sp,sp, #8  //elimino mis 2 ultimos elementos de la pila
			str x28,[sp,#0]	//guardo x3 y x4

			mov x27,x0
			sub x27,x27,640
			add x3,x3,1
			b.lt coordenadas
			mov x4,x0
			ldr x28,[sp,#0]  				//cargo x3 y x4 a sus valores originales y decremento la pila en 2  
			add sp,sp, #8 
			ret


//-----------------------------COSAS ESTETICAS
Sol:

		sub sp,sp, #8  
		str x30,[sp,#0]

		mov x8,50							//radio
		mov x15,80							//centro
		mov x14,70		
		movz x10, 0xFF, lsl 16	    
		movk x10, 0xAF00, lsl 00 
		bl Calcular_Direccion
		bl circulo

		mov x8,40							//radio
		mov x15,80							//centro
		mov x14,70		
		movz x10, 0xFF, lsl 16	    
		movk x10, 0xE200, lsl 00 
		bl Calcular_Direccion
		bl circulo

		ldr x30,[sp,#0]  				  
		add sp,sp, #8

	ret

circulo:	
				
		mov x27, xzr
		mov x26, xzr
		mov x25, xzr
		mov x24, xzr
		mov x23, xzr
		mov x22, xzr
		mov x11, xzr
		mov x12, xzr

		mov x24, x14					//guardo mis coordenadas del centro
		mov x25, x15

		sub x12, x14, x8				//x16 y x17 tienen mis coordenadas del incio del cuadrado
		sub x11, x15, x8

		sub sp,sp, #8  					//elimino mis 2 ultimos elementos de la pila
		str x30,[sp,#0]					//guardo x15 y x14
			
		//"pinto el cuadrado dependiendo si cumple las condiciones" de aca en adelante es muy parecido a la funcion cuadrado solo que pregunto si cumple la condicion de Calculo para pintar el pixel
		lsl x22, x8, 1					//Ysize

		loop_circ1:

		mov x14, x12
		mov x15, x11
		bl Calcular_Direccion
		lsl x23, x8, 1					//Xsize

		loop_circ2:

		bl Calculo						//hago los Calculos necesarios con pitagora para ver si la hipotenusa geenerada por la linea entre el centro del circulo y el pixel que estoy viendo 
		b.le Colorear					//coloreo el circulo
		bl Calcular_Direccion			//Calculo la Calcular_Direccion de mi x0

		Siguiente:

   		add x0, x0, 4					// Siguiente pixel
		add x12, x12, 1					//Siguiente coordenada en x
    	sub x23, x23, 1					// Decrementar contador de mi diametro
		
    	cbnz x23,loop_circ2 			// Si no terminó la fila, salto
		
		sub x22, x22, 1   				// Decrementar contador Y
		add x11, x11, 1					//Siguiente pixel en Y
		sub x12, x24, x8 				//pongo devuelta mi coordenadad de x En 0
		msub x0, x3, x8, x0				//vuelvo al princio de la linea que estoy pintado x0=x0-x1*4
		madd x0, x1, x3, x0  			//x0=x0+640*4
	  	cbnz x22, loop_circ1  			// Si no es la última fila, saltostur w11,[x20]


		ldr x30,[sp,#0]  				//cargo x15 y x14 a sus valores originales y decremento la pila en 2  
		add sp,sp, #8 

		mov x0,x20

		ret


Calcular_Direccion:

		sub sp,sp, #16  				//elimino mis 2 ultimos elementos de la pila
		str x15,[sp,#0]					// guardo y 
		str x14,[sp,#8]					// guardo x

		mov x1, SCREEN_WIDTH 			// Seteo x1 con el largo de pantalla 640
		mov x0, x20						// Seteo x0 en el primer pixel de la pantalla
		mov x3, xzr						// Seteo x3 en vacio

		madd x3, x15, x1, x14			// x3 = (x14 * 640) + x15, donde x14 = y, x15 = x 
		lsl x3, x3, 2					// x3 = x3 * 4
		add x0, x0, x3

		ldr x4,[sp,#8]  				//cargo x15 y x14 a sus valores originales y decremento la pila en 2 
		ldr x3, [sp,#0] 
		add sp,sp, #16 

	ret

Colorear:

		stur w10,[x0]  					// Colorear el pixel N
		b Siguiente						//sigo viendo mis demas pixeles

Calculo:						
			
		mov x26,x12						//salvo mis x1 y1
		mov x27,x11
			

		sub x26, x26, x24				// x26=x1-x0
		mul x26, x26, x26				//x26=x26 al cuadrado
		sub x27, x27, x25				//x27=y1-y0
		mul x27, x27, x27				//x27=x27 al cuadrado

		add x26, x27, x26				//x26=x27+x26
		mov x27, x8						//x27 ahora es el radio

		mul x27, x27, x27				//x27 es radio cuadrado
		cmp x26, x27					//x26 = x26 - diametro

		b.gt Siguiente					//si mi radio cuadrado en mayor extricto que mi x26 NO pinto ese pixel
		b Colorear						//si es menor lo pinto

flores:
		sub sp,sp, #8  
		str x30,[sp,#0]

		mov x16, 100					// Posicion 00 de Flor de x
		mov x17, 330					// Posicion 00 de Flor de y
		bl Flor

		mov x16, 510					// Posicion 00 de Flor de x
		mov x17, 360					// Posicion 00 de Flor de y
		bl Flor

		mov x16, 0						// Posicion 00 de Flor de x
		mov x17, 360					// Posicion 00 de Flor de y
		bl Flor

		ldr x30,[sp,#0]  				  
		add sp,sp, #8

	ret

Flor:

		sub sp,sp, #8  
		str x30,[sp,#0]

		mov x8, 7						//radio
		add x19, x17, 50
		add x18, x16, 63
		mov x15, x19					// Cordenada de y
		mov x14, x18					// Cordenada de x
		movz x10, 0xCC, lsl 16	    
		movk x10, 0x0086, lsl 00 
		bl Calcular_Direccion
		bl circulo

		mov x8, 7						//radio
		add x19, x17, 50
		add x18, x16, 37
		mov x15, x19					// Cordenada de y
		mov x14, x18					// Cordenada de x
		movz x10, 0xCC, lsl 16	    
		movk x10, 0x0086, lsl 00 
		bl Calcular_Direccion
		bl circulo

		mov x8, 7						//radio
		add x19, x17, 63
		add x18, x16, 50
		mov x15, x19					// Cordenada de y
		mov x14, x18					// Cordenada de x	
		movz x10, 0xCC, lsl 16	    
		movk x10, 0x0086, lsl 00 
		bl Calcular_Direccion
		bl circulo

		mov x8, 7						//radio
		add x19, x17, 37
		add x18, x16, 50
		mov x15, x19					// Cordenada de y
		mov x14, x18					// Cordenada de x
		movz x10, 0xCC, lsl 16	    
		movk x10, 0x0086, lsl 00 
		bl Calcular_Direccion
		bl circulo

		mov x8, 8						//radio
		add x19, x17, 42
		add x18, x16, 41
		mov x15, x19					// Cordenada de y
		mov x14, x18					// Cordenada de x
		movz x10, 0x80, lsl 16	    
		movk x10, 0x0054, lsl 00 
		bl Calcular_Direccion
		bl circulo

		mov x8, 8						//radio
		add x19, x17, 57
		add x18, x16, 41
		mov x15, x19					// Cordenada de y
		mov x14, x18					// Cordenada de x
		movz x10, 0x80, lsl 16	    
		movk x10, 0x0054, lsl 00 
		bl Calcular_Direccion
		bl circulo

		mov x8, 8						//radio
		add x19, x17, 42
		add x18, x16, 57
		mov x15, x19					// Cordenada de y
		mov x14, x18					// Cordenada de x
		movz x10, 0x80, lsl 16	    
		movk x10, 0x0054, lsl 00 
		bl Calcular_Direccion
		bl circulo

		mov x8, 8						//radio
		add x19, x17, 57
		add x18, x16, 57
		mov x15, x19					// Cordenada de y
		mov x14, x18					// Cordenada de x
		movz x10, 0x80, lsl 16	    
		movk x10, 0x0054, lsl 00 
		bl Calcular_Direccion
		bl circulo

		mov x8, 8						//radio
		add x19, x17, 50
		add x18, x16, 50
		mov x15, x19					// Cordenada de y
		mov x14, x18					// Cordenada de x
		movz x10, 0xFF, lsl 16	    
		movk x10, 0xF300, lsl 00 
		bl Calcular_Direccion
		bl circulo

		ldr x30,[sp,#0]  				  
		add sp,sp, #8

	ret


.endif
