#--------------------Tarea 2. Estructuras de computadoras digitales---------------
#-------------------Carlos Andres Alvarado Salazar, B50339, grupo 1---------------
#---------Programa que contiene un rutina que revisa si frases guardadas----------
#---------en un arreglo de la memoria es palindromo o no, es decir si-------------
#---------se lee igual por la izquierda y la derecha sin importar mayusculas------
#---------minusculas o espacios.--------------------------------------------------
#---------------------------------------------------------------------------------
#Para realizar esto el programa cuenta con una funcion externa el numero de 
#caracteres que contiene el String. En base a esta informacion establece un puntero
#hacia el primer caracter y otro al ultimo caracter. Compara si es un espacio y lo
#ignora y luego compara si los caracteres son iguales. En caso de ser iguales la frase 
#es palindromo, entonces continua revizando moviendo el puntero de la izquierda una posicion
#a la derecha y el puntero de la derecho una posicion a la izquierda y revisa nuevamente si 
#los caracteres son iguales. Cuando los caracteres dejan de ser iguales establece un 0 
#en $v0 y termina la rutina.Cuando los punteros llegan a la misma posicion termina la rutina. 
#Si $v0 = 0 no es palindromo.
#Si $v0 = 1 es palindromo.
#---------------------------------------------------------------------------------

.data #Declaracion de los datos necesarios para los ejercicios
	  #Comentarios introductorios	
	Intro: .asciiz "A continuacion se evaluara si las siguientes frases son palindromos:"	
	Intro2: .asciiz "(Si se imprime debajo de la frase un 1, es palindromo. Si se imprime 0 no lo es)"
	  #frases por revisar
	Frase1: .asciiz "La ruta natural" 
	Frase2: .asciiz "Se VAN sus naves"
	Frase3: .asciiz "La ruta nos aporto Otro paso natural"
	Frase4: .asciiz "Estructuras de computadoras ed sarutcurtsE"
	Return: .asciiz "\n" #retorno de linea
.text

#------------------------------------MAIN-----------------------------------------
main:
#------------------------Imprime la introduccion----------------------------------

	la $a0, Intro #Carga en $a0 el comentario introductorio
	li $a1, 1 	  #Decide imprimir String
	li $a2, 1	  #Decide imprimir un retorno al final
	jal Print	  #Llama a la funcion print	

	la $a0, Intro2 #Carga en $a0 el comentario introductorio 2
	li $a1, 1 	  #Decide imprimir String
	li $a2, 1	  #Decide imprimir un retorno al final
	jal Print	  #Llama a la funcion print	

#------------------------Revisa e imprime la Frase1-------------------------------

	la $a0, Frase1 #Carga en $a0 la direccion de la Frase1
	li $a1, 1 	  #Decide imprimir String
	li $a2, 1	  #Decide imprimir un retorno al final
	jal Print	  #Llama a la funcion print
	
	la $a0, Frase1 #Carga en $a0 la direccion de la Frase
	jal IdentPali #llama a la funcion para identificar si es palindromo
	move $a0,$v0 #mueve a $a0 el resultado de la funcion en $v0
	li $a1,0 #imprime el resultado
	li $a2,1
	jal Print

#------------------------Revisa e imprime la Frase2-------------------------------

	la $a0, Frase2 #Carga en $a0 la direccion de la Frase2
	li $a1, 1 	  #Decide imprimir String
	li $a2, 1	  #Decide imprimir un retorno al final
	jal Print	  #Llama a la funcion print
	
	la $a0, Frase2 #Carga en $a0 la direccion de la Frase2
	jal IdentPali #llama a la funcion para identificar si es palindromo
	move $a0,$v0 #mueve a $a0 el resultado de la funcion en $v0
	li $a1,0 #imprime el resultado
	li $a2,1
	jal Print

#------------------------Revisa e imprime la Frase3-------------------------------

	la $a0, Frase3 #Carga en $a0 la direccion de la Frase3
	li $a1, 1 	  #Decide imprimir String
	li $a2, 1	  #Decide imprimir un retorno al final
	jal Print	  #Llama a la funcion print
	
	la $a0, Frase3 #Carga en $a0 la direccion de la Frase3
	jal IdentPali #llama a la funcion para identificar si es palindromo
	move $a0,$v0 #mueve a $a0 el resultado de la funcion en $v0
	li $a1,0 #imprime el resultado
	li $a2,1
	jal Print

#------------------------Revisa e imprime la Frase4-------------------------------


	la $a0, Frase4 #Carga en $a0 la direccion de la Frase4
	li $a1, 1 	  #Decide imprimir String
	li $a2, 1	  #Decide imprimir un retorno al final
	jal Print	  #Llama a la funcion print
	
	la $a0, Frase4 #Carga en $a0 la direccion de la Frase4
	jal IdentPali #llama a la funcion para identificar si es palindromo
	move $a0,$v0 #mueve a $a0 el resultado de la funcion en $v0
	li $a1,0 #imprime el resultado
	li $a2,1
	jal Print

#------------------------Termina el programa--------------------------------------
	jal finProg		#llama a la funcion para finalizar el programa
#---------------------------------------------------------------------------------



#----------------------Funcion para Identificador de palindromos-------------------------
#--------------------revisa si la frase en la direccion en $a0 es un palindromo----------
#-------------------en caso de ser palindromo devuelve en $v0 un 1-----------------------
#-------------------en caso de no ser palindromo devuelve en $v0 un 0--------------------
IdentPali:
	addi $sp, $sp, -4	#Realiza push al stack para guardar $ra
	sw	$ra, 0($sp)		#Guarda $ra
	jal LargoString 	#llama a la funcion que cuenta el largo en caracteres del string
	addi $t1, $v0, -1   #Guarda en $t1 el largo del string -1 para acceder al ultimo byte
						#y usarlo como puntero de los bytes a la derecha.
	li $t0, 0		#establece $t0=0 como el puntero para los bytes a la izquierda
	li $v0, 1		#Establece $v0=1 asumiendo que la frase inicialmente es palindromo
	li $t2, 0xDF	#mascara para no diferenciar mayusculas de minusculas (segun ascii)
	li $t3, 0x20	#mascara para identificar espacios					  (segun ascii)
	add $t0, $a0, $t0 	# $t0 = direccion del primer caracter
	add $t1, $a0, $t1	# $t1 = direccion del ultimo caracter
LoopIdentPali:			#loop de la funcion
	lb $t4, 0($t0)		# carga en $t4 el caracter mas a la izquierda
	lb $t5, 0($t1)		# carga en $t5 el caracter  mas a la derecha
	beq $t0, $t1, finIdentPali #antes de modificar los punteros revisan si son son son iguales 
							   #en caso de ser iguales termina la rutina porque ya 
							   #termino de revisar la frase 
	bne $t4, $t3, noEspacioIzq #revisa si el caracter de la izquierda es un espacio
	addi $t0, 1	  #en caso de ser espacio agrega uno al puntero para ignorar espacios
noEspacioIzq:
	bne $t5, $t3, noEspacioDer #revisa si el caracter de la derecha es un espacio
	addi $t1, $t1, -1    #en caso de ser espacio resta uno al puntero para ignorar espacios
noEspacioDer:
	lb $t4, 0($t0)		#carga los caracteres nuevamente despues de modificar los punteros
	lb $t5, 0($t1)
	and $t4, $t4, $t2   #aplica a los caracteres la mascara para no diferenciar 
	and $t5, $t5, $t2   #si es mayuscula o minuscula.
	beq $t4,$t5,sonIguales #revisa si los caracteres son iguales
	addi $v0, $v0, -1	   #en caso de no ser iguales resta uno a $v0, es decir $v0 = 0
sonIguales:
	beq $t0, $t1, finIdentPali #revisa si los punteros son iguales para terminar la rutina
	addi $t0, $t0, 1	#mueve el puntero de la izquierda
	addi $t1, $t1, -1   #mueve el puntero de la derecha
	beq $v0, $0, finIdentPali #si $v0 = 0 quiere decir que no es palindromo y termina la rutina
	j LoopIdentPali     #si no ha terminado regresa al inicio del loop
finIdentPali:
	lw $ra, 0($sp)		#carga el valor de $ra 
	addi $sp,$sp,4		#hace pop al stack
	jr $ra #regresa PCTime + 4 
#------------------------------------------------------------------------------------------

#----------------Funcion para contar la cantidad de caracteres en un String(asciiz)--------
#------------------Recibe en $a0 la direccion del string y devuelve en $v0-----------------
#-------------------------el numero de caracteres que contiene-----------------------------
LargoString:
	li $v0, 0	#carga un 0 en $v0 que servira como contador y puntero
Cuenta:
	add $t0, $a0, $v0 	# $t0 = $a0 + $v0
	lb $t0, 0($t0)		# carga el byte en la direccion $t0
	beqz $t0,finLargoString	# si el byte cargado es igual a null termina la funcion
	addi $v0, $v0, 1	#si el byte cargado no es null aumenta en uno la cuenta
	j Cuenta  			#y regresa al loop cuenta
finLargoString:
	jr $ra 				#cuando termina la rutina regresa PC TIME + 4
#------------------------------------------------------------------------------------------


#-----------------------Funcion para Imprimir Enteros o String-----------------------------
#-------------Esta rutina necesita la definicion del string: Return: .asciiz "\n"----------
#-------------Recibe en $a0 la direccion del arreglo por imprimir--------------------------
#-------------Si el registro $a1 recibe un 0 imprime un entero,----------------------------
#-------------Si el registro $a1 recibe un 1 imprime un String,----------------------------
#-------------Si el registro $a2 recibe un 1 imprime un retorno, --------------------------
#--------------de lo contrario no lo imprime-----------------------------------------------
Print:
	li $t0,1 # guarda en $t0 el 1
	bne $a1, $t0, NoString #si $a1 es distinto a 1 no imprime string
	li $v0,4	#Carga 4 en v0 para imprimir string
	syscall		#Imprime el String en $a0
NoString:
	bne $a1, $0, NoInt #si $a1 es distito a 0 no imprime entero
	li $v0,1 	#carga en v0 1 para imprimir entero
	syscall		#imprime el valor en $a0
NoInt:
	bne $a2, $t0, NoReturn #si $a3 es distinto a 1 no imprime retorno
	li $v0,4	#Carga 4 en v0 para imprimir string
	la $a0, Return #Carga la direccion del retorno de linea
	syscall		#Imprime el retorno de linea
NoReturn:
	jr $ra  	#Regresa a pc time + 4
#-----------------------------------------------------------------------------------------


#------------------------Funcion para Finalizar el Programa-------------------------------
finProg:	
	li $v0, 10 #Llama en syscall el 10 para terminar el programa
	syscall
##########################################################################################