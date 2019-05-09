###############Tarea 1. Estructuras de computadoras digitales#################
################Carlos Andres Alvarado Salazar, B50339, grupo 1.##############
##############################################################################
#A continuacion se presenta la solucion implementada para obtener el valor
#maximo y minimo de un array y finalmente imprimir el arreglo en el que estan
#y su valor en la consola. El codigo esta hecho en codigo ensamblador para correr
#en un simulador del procesador MIPS. La metodologia base es la declaracion de 
#funciones que posteriormente son llamadas para cumplir el objetivo.
#############################################################################


.data #Declaracion de los datos necesarios para los ejercicios
	Intro: .asciiz "El arreglo original es:\n"	#Comentarios introductorios
	StringMin: .asciiz "El numero minimo es:\n"
	StringMax: .asciiz "El numero maximo es:\n"	#Datos del arreglo
	Array: .word 87 , 216 , -54, 751 , 1 , 36 , 1225 , -446, -6695, -8741, 101 , 9635 , -9896, 4 , 2008 , -99,	6, 1 , 544 , 6 , 7899 , 74 , -42, -9, 0 
	Return: .asciiz "\n"	#Retorno de linea

.text


main: 		#Label del main
	la $a0, Intro #Carga la direccion en memoria de Array en $a0
	jal PrintString	#Imprime el primer comentario
	la $a0, Array   #Carga el array en $a0
	jal PrintArrayColumna 	#funcion que imprime array como columna
	jal Maxmin 				#Llama la funcion para encontrar el maximo y minimo
	move $s0,$v0  #Guarda el maximo y el minimo
	move $s1,$v1
	la $a0, StringMin  #Carga la introduccion del minimo
	jal PrintString		#Imrpime la introduccion
	move $a0,$s0		#Carga el minimo
	jal PrintInteger	#Imprime el minimo
	la $a0, StringMax	#Carga la introduccion del maximo
	jal PrintString		#Imprime la introduccion
	move $a0,$s1		#Carga el numero maximo
	jal PrintInteger	#Imprime el maximo
	jal finProg			#Va a la funcion que termina el programa

########################################Maxmin##############################################

Maxmin: #Rutina que determina el maximo y minimo
	add $t0, $0, $0 #Creacion de un contador i
	sll $t2, $t0, 2	  #ix4
	add $t2, $a0, $t2 #Suma $a0 + $t0
	lw $t2, 0($t2)	  #Carga t2=array[ix4]
	move $v0,$t2	  #Establece el valor minimo y maximo inicial
	move $v1,$t2
Loop:
	sll $t3, $t0, 2	  #ix4
	add $t2, $a0, $t3 #Suma $a0 + ix4
	lw $t1, 0($t2)		#Carga la palabra en la direccion $a0 + ix4
	beq $t1, $0, EndMaxmin	#Si es igual a 0 termina la rutina
	bge $t1,$v0,Nmenor		#Si el numero no es menor ignora la siguiente instruccion
	move $v0, $t1			#Si es menor define nuevo valor minimo
Nmenor:
	ble $t1,$v1,Nmayor		#Si el numero no es mayor ignora la siguiente instruccion
	move $v1,$t1			#Si es mayor define nuevo valor maximo
Nmayor:
	addi $t0, $t0, 1		#Aumenta en 1 la variable de iteracion
	j Loop					#Regresa al inicio del loop
EndMaxmin:
	jr $ra 					#Se devuelve al pc + 4

####################################Imprimir array columna####################################

PrintArrayColumna:	#Rutina que imprime un array como columna, cuyo ultimo valor es 0
	addi $sp, $sp, -8	#Guarda registros importantes en el stack (push stack)
	sw	$a0, 4($sp)		#Guarda el dato que recibe en $a0
	sw	$ra, 0($sp)		#Guarda la direccion de Pc time + 4
	move $t2,$a0		#Guarda la direccion del array en t2
	add $t0, $0, $0  # $t0 = i = 0 #define una variable i de iteracion
While:
	sll $t1, $t0, 2  # $t1 = i*4	
	add $t1, $t1, $t2	# ix4 + $t2 = ix4 + $a0
	lw $a0, 0($t1)		#Carga en $a0 array[ix4]
	beq $a0, $0, EndPrintArray #Si la palabra es igual a 0 se termina la rutina
	jal PrintInteger	#Si no es igual a 0 llama a la funcion para imprimir entero
	addi $t0,$t0,1		#Aumenta la variable de iteracion en 1
	j While				#Regresa al inicio del loop
EndPrintArray:			#Rutina para terminar la funcion de PrintArrayColumna
	move $a0,$0			#Carga en a0 el 0
	jal PrintInteger	#Imprime el 0 que es el valor final
	lw	$a0, 4($sp)		#Hace pop de los registros guardados
	lw	$ra, 0($sp)
	addi $sp, $sp, 8
	jr $ra  			#Regresa a pc time + 4


#################################Imprimir enteros#########################################


PrintInteger:
	li $v0,1 	#carga en v0 1 para imprimir entero
	syscall		#imprime el valor en $a0
	li $v0,4	#Carga 4 en v0 para imprimir string
	la $a0, Return #Carga el retorno de linea
	syscall			#Imprime el retorno de linea
	jr $ra  		#Regresa a pc time + 4

##################################Imprimir string######################################

PrintString:
	li $v0,4 #Carga 4 en v0 para imprimir string
	syscall  #Imrpime el string en a0
	jr $ra   #Regresa a pc time + 4

##################################Finalizar el programa#################################
finProg:	#Subrutina para finalizar el programa
	li $v0, 10 #Llama en syscall el 10 para terminar el programa
	syscall
#######################################################################################
