#--------------------Tarea 4. Estructuras de computadoras digitales-----------------
#-------------------Carlos Andres Alvarado Salazar, B50339, grupo 1-----------------
#---------Programa que contiene una rutina que pueden realizar la multiplicacion----
#---------algebraica de dos matrices y otra rutina que puede imprimir en la consola-
#---------los valores en las celdas de una matriz. ---------------------------------
#---------Para realizar esto se recorren las filas y columnas de la matriz----------
#---------usando loops con una respectiva variable de iteracion---------------------
#---------Para multiplicar se ubica en una fila de la primer matriz y --------------
#---------en una columna de la segunda matriz---------------------------------------
#---------Posteriormente se multiplican y suman las celdas respectivas a esa--------
#---------fila y columna------------------------------------------------------------
#---------Para guardar la matriz resultante se utiliza la asignacion dinamica-------
#---------de memoria con syscall 9. ------------------------------------------------


.data #Declaracion de los datos necesarios para los ejercicios
	  #Comentarios introductorios	
	  #cada arreglo con palabras tiene un 0 al final para indicar el final de esta.
	Intro:	.asciiz "A continuacion se muestran los resultados de multipliaciones de matrices: \n"
	Intro1: .asciiz "Matriz A: \n"
	Intro2: .asciiz "Matriz B: \n"
	Intro3: .asciiz "Siguiente multiplicacion: \n"
	Resultado: .asciiz "AxB = \n"
	Error:	.asciiz "No se puede realizar la multipliacion. \n"
	Coma:	.asciiz ", "
	Retorno:	.asciiz "\n"  

.data 0x10000020 #los datos float se deben guardar en posiciones de memoria multiplos de 8
				 # por eso se define una ubicacion especifica 
	Matriz1:
    		.word 3, 2
    		.double 2.5, 8.1, 420.024, -14.0, -5.5, 0.0
.data 0x10000060
	Matriz2: .word 2, 4
			 .double 3.0, 1.0, 7.0, -2.0, 6.0, 5.0, -1.0, 0.0
.data 0x100000b0
	Matriz3: .word 3, 3
		     .double 1.0, 1.3, 1.0, 1.0, 1.0, 1.41, 2.0, 2.0, 2.0
.data 0x10000100
	Matriz4: .word 3, 2
			 .double 3.0, 3.14, 5.0, 5.0, 8.0, 8.0
.text

#------------------------------------MAIN-----------------------------------------
main:

#A continuacion se muestra un ejemplo del uso de la funcion multMatriz
la $a0, Intro 	# Introduccion inicial
jal imprimirString

la $a0, Intro1  #String matriz A 
jal imprimirString

la $a0, Matriz1 #Imprime matriz A
jal imprimirMatriz

la $a0, Intro2 #String matriz B
jal imprimirString

la $a0, Matriz2 #Imprime Matriz B
jal imprimirMatriz

la $a0, Resultado #String resultado
jal imprimirString

la $a0, Matriz1
la $a1, Matriz2
jal multMatriz  # Matriz1 x Matriz2
move $a0,$v0    # Imprime la matriz
jal imprimirMatriz

la $a0, Intro3		#nueva multiplicacion
jal imprimirString	#Se realiza lo mismo para otras matrices

la $a0, Intro1
jal imprimirString

la $a0, Matriz3
jal imprimirMatriz

la $a0, Intro2
jal imprimirString

la $a0, Matriz4
jal imprimirMatriz

la $a0, Resultado
jal imprimirString

la $a0, Matriz3   #Segunda multiplicacion
la $a1, Matriz4
jal multMatriz
move $a0, $v0
jal imprimirMatriz

la $a0, Intro3
jal imprimirString

la $a0, Intro1
jal imprimirString

la $a0, Matriz3
jal imprimirMatriz

la $a0, Intro2
jal imprimirString

la $a0, Matriz1
jal imprimirMatriz

la $a0, Resultado
jal imprimirString

la $a0, Matriz3
la $a1, Matriz1
jal multMatriz 		#Tercera multiplicacion
move $a0, $v0
jal imprimirMatriz

la $a0, Intro3
jal imprimirString

la $a0, Intro1
jal imprimirString

la $a0, Matriz2
jal imprimirMatriz

la $a0, Intro2
jal imprimirString

la $a0, Matriz3
jal imprimirMatriz

la $a0, Resultado
jal imprimirString

la $a0, Matriz2   #Cuarta multiplicacion
la $a0, Matriz3
jal multMatriz


#------------------------Termina el programa---------------------------------------------
	jal finProg		#llama a la funcion para finalizar el programa
#----------------------------------------------------------------------------------------




#------------------------Funcion para multiplicar matrices-------------------------------
#------------La funcion recive en $a0 el arreglo de memoria que contiene los-------------
#------------datos de la matriz 1 yen $a1 el arreglo correspondiente a la matriz 2.------
#---------- Devuelve en $v0 un 0 si no se puede realizar la multiplicacion---------------
#---------- devuelve en $v0 la direccion base de la matriz resultante en-----------------
#---------- caso de poder multiplicar las matrices --------------------------------------
#----------------------------------------------------------------------------------------
#---------- Formato del arreglo con la informacion de las matrices: ---------------------
#----------las primeras dos palabras almacenas el numero de filas y columnas-------------
#----------en el resto de palabras se almacenan de manera lineal los datos (float)-------
#----------en las celdas de la matriz.---------------------------------------------------
#----------la direccion de cada celda en el arreglo es determinada mediante -------------
#----------la siguiente relacion.--------------------------------------------------------
#----------Dir = dirBase + [(fila*(#columnas)+columna)*8]--------------------------------

multMatriz:
addi $sp, $sp, -8	#Guarda registros importantes en el stack (push stack)
sw	$s0, 4($sp)		#Guarda el dato que recibe en $s0
sw	$s1, 0($sp)		#Guarda el dato que recibe en $s1 para utilizar estos 
					#registros dentro de la funcion
li $v0, 0	# Asume que no se puede realizar la multiplicacion 

lw $t0, 0($a0)	# $t0 = #filas1 #filas resultante
lw $t1, 4($a0)	# $t1 = #columnas1
lw $t2, 0($a1)	# $t2 = #filas2
lw $t3, 4($a1)  # $t3 = #columnas2 #columnas resultante

bne $t1, $t2, finmultMatriz # si el numero de columnas de la primer matriz es distinto
							# al numero de filas de la segunda, termina la funcion
							#En caso de poder realizarla continua con la funcion 

move $s0, $a0 	# $s0 = $a0 = dir primer matriz
addi $s0, $s0, 8	# $s0 = dir primer celda primer matriz
move $s1, $a1 	# $s1 = $a1	= dir segunda matriz
addi $s1, $s1, 8	# $s1 = dir segunda celda segunda matriz

#Primero se calcula el numero de bytes en memoria que requiere la matriz para asignar su posicion
#en la memoria.
#La matriz resultante tendra la misma cantidad de filas que la matriz 1 y la misma cantidad
#de columnas que la matriz 2. El dato de la fila y columna necesita 8 bytes y cada celda
# de la matriz necesita 8 bytes.

mult $t0, $t3
mflo $a0 	# $a0 = filasresultante x columnasresultante
sll $a0, $a0, 3 	# $a0 = (filasresultante x columnasresultante) x 8	
addi $a0, $a0, 8 	# $a0 = (filasresultante x columnasresultante) x 8	+ 8 = total de bytes necesarios
li $v0, 9 			# $v0 = 9 para determinar la direccion de la nueva matriz
syscall				# $v0 = direccion de la nueva matriz 

sw $t0, 0($v0) 		# Guarda el numero de filas y columnas en el nuevo arreglo
sw $t3, 4($v0)

move $a0,$v0 		# $a0 = dir nuevo arreglo
addi $a0, $a0, 8    # $a0 = dir nuevo arreglo + 8 = dir primer dato de la matriz

# Ahora se realiza la multiplicacion y los resultados se almacenan a partir de $a0
# en $t0 esta el numero total de filas resultante 
# en $t3 esta el numero total de columnas resultante\
#en $t1 esta el numero total de multiplicacione que hay que realizar par obtener
#el resultado de la cela celda

li $t6, 0	# i = 0 puntero de fila

loopMultFila:
beq $t6, $t0, finloopMultFila
li $t4, 0	# j = 0 puntero columna 
	loopMultColumna:
	beq $t4, $t3, finloopMultColumna
	li $t5, 0	# k = 0 indica cuales celdas se deben multiplicar
	li.d $f8, 0.0    # $f8 = se guardara el resultado de la multiplicacion actual = mult	
	
		loopMult:
		beq $t5, $t1, finloopMult

		#se realiza la multiplicacion que se guarda en $t6
		# $t6 posee la fila actual = i
		# $t4 posee la columna actual = j 
		# $t5 indica cuales celdas de esa fila y columna multiplicar = k
		# $s0 direccion base de los datos de la primer matriz
		# $s1 direccion base de los datos de la segunda matriz
		# Dir = dirBase + [(fila*(#columnas)+columna)*8]
		# $f8 = mult = mult + matriz1[i][k] x matriz2[k][j]

		#direccion dato de la primer matriz 
		mult $t6, $t1
		mflo $a1 	# $a1 = i*(#columnas1)
		add $a1, $a1, $t5 	# $a1 = i*(#columnas1)+k
		sll $a1, $a1, 3 	# $a1 = (i*(#columnas1)+k)*8
		add $a1, $a1, $s0  # $a1 = (i*(#columnas1)+k)*8 + dirBaseMatriz1

		#direccion dato de la segunda matriz
		mult $t5, $t3
		mflo $a2 	# $a2 = k*(#columnas2)
		add $a2, $a2, $t4 	# $a2 = k*(#columnas2) + j
		sll $a2, $a2, 3 	# $a2 = (k*(#columnas2) + j)*8
		add $a2, $a2, $s1  # $a2 = (k*(#columnas2) + j)*8 + dirBaseMatriz2

		l.d $f0, 0($a1)		# $f0 = matriz1[i][k]
		l.d $f2, 0($a2) 	# $f2 = matriz2[k][j]

		mul.d $f0, $f0, $f2 # $f0 = matriz1[i][k] x matriz2[k][j]
		add.d $f8, $f8, $f0 # $f8 = mult + matriz1[i][k] x matriz2[k][j] = mult

		addi $t5, $t5, 1	# k++
		j loopMult
		finloopMult:

	s.d $f8, 0($a0)		# matrizResultante[i][j] = mult
	addi $a0, $a0, 8 	# se aumenta la direccion en 8 para guardar el resultado de la proxima celda
	addi $t4, $t4, 1	# j++
	j loopMultColumna
	finloopMultColumna:
addi $t6, $t6, 1	# i++
j loopMultFila
finloopMultFila:

finmultMatriz:

lw	$s0, 4($sp)		#Pop stack
lw	$s1, 0($sp)		 
addi $sp, $sp, 8	

bne $v0, $0, noError #En caso de haber error imprime un mensaje de error
la $a0, Error 	 # y conserva $v0 = 0
li $v0, 4
syscall
li $v0, 0  		  # $v0 = 0

noError: 	# En caso de no haber error devuelve la direccion de la matriz resultante
jr $ra 	# regresa a PCTime + 4
#----------------------------------------------------------------------------------------




#------------------------Funcion para imprimir matrices----------------------------------
#------------La funcion recive en $a0 el arreglo de memoria que contiene los-------------
#------------datos de la matriz.---------------------------------------------------------
#------------Formato del arreglo: word(#filas) word(#columnas) float(datos de la matriz)-
#----------las primeras dos palabras almacenas el numero de filas y columnas--------sxdcf-----
#----------en el resto de palabras se almacenan de manera lineal los datos (float)-------
#----------en las celdas de la matriz.---------------------------------------------------
#----------la direccion de cada celda en el arreglo es determinada mediante -------------
#----------la siguiente relacion.--------------------------------------------------------
#----------Dir = dirBase + [(fila*(#columnas)+columna)*8]--------------------------------

imprimirMatriz:
li $t0, 0	# i , puntero para las filas
li $t2, 0	# j , puntero para las columnas

lw $t1, 0($a0)	# $t1 = numero filas
lw $t3, 4($a0)	# $t3 = numero columnas

addi $t5, $a0, 8 # $t5 = dir primer dato

	loopFila:
	beq $t0, $t1, finImprimirMatriz #cuando recorrio todas las filas termina la funcion
	li $t2, 0	# j = 0
		
		loopColumna:
		beq $t2, $t3, finloopColumna #cuando recorrio todas las columnas termina el loop

		mult $t0, $t3		
		mflo $t4			# $t4 = i*#columnas
		add $t4, $t4, $t2	# $t4 = i*#columnas + j
		sll $t4, $t4, 3		# $t4 = (i*#columnas + j)*8
		add $t4, $t4, $t5	# $t4 = (i*#columnas + j)*8 + dirBase = dirDato

		l.d $f12, 0($t4)	#f12 = dato 
		
		li $v0, 3	#Imprime el double en $f12
		syscall

		la $a0, Coma #Imprime una coma y un espacio despues del numero
		li $v0, 4
		syscall

		addi $t2, $t2, 1	# j++
		j loopColumna
	
	finloopColumna:
	la $a0, Retorno		# Imprime un retorno de linea 
	li $v0, 4
	syscall

	addi $t0, $t0, 1	# i++
	j loopFila

finImprimirMatriz:
jr $ra 		#regresa a PCTime + 4
#----------------------------------------------------------------------------------------


#------------------------------Funcion par imprimir String-------------------------------
#--------------------------Imprime el string ubicado en la direccion $a0 ----------------
imprimirString:
	li $v0,4 #Carga 4 en v0 para imprimir string
	syscall  #Imrpime el string en a0
	jr $ra   #Regresa a pc time + 4
#----------------------------------------------------------------------------------------


#------------------------Funcion para Finalizar el Programa-------------------------------
finProg:	
	li $v0, 10 #Llama en syscall el 10 para terminar el programa
	syscall
##########################################################################################

