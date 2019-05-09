#--------------------Tarea 2. Estructuras de computadoras digitales---------------
#-------------------Carlos Andres Alvarado Salazar, B50339, grupo 1---------------
#---------Programa que contiene un rutina que puede realizar un desplazamiento----
# a la derecha de multiple precision de un arreglo de palabras. Expliacion de la 
#logica se encuentra dentro del codigo
#---------------------------------------------------------------------------------

.data #Declaracion de los datos necesarios para los ejercicios
	  #Comentarios introductorios	
	  #cada arreglo con palabras tiene un 0 al final para indicar el final de esta.
	Intro: .asciiz "Ahora se muestran los resultados de las operaciones en el main:\n"
	Palabra1: .word -128, -8, 23, 0 # Null termina la palabra
	Palabra2: .word 1024, -17, 0 
	Palabra3: .word 25000, 14, 12, 80, 0
	Return: .asciiz "\n"
	Space: .asciiz " " 
	Error: .asciiz "No se puede realizar el desplazamiento \n"
.text

#------------------------------------MAIN-----------------------------------------
main:

la $a0, Intro
li $v0, 4
syscall

la $a0, Palabra1
#Cuenta el numero de palabras en el arreglo
jal LargoPalabra #funcion que cuenta el numero de palabras
move $a1,$v0	#Numero de palabras dentro del arreglo
				#Imprime el arreglo original
la $a0, Palabra1
jal ImpArregloInt #funcion que imprime un arreglo de palabras como int

#Se prueban corrimientos dentro del rango permitido
la $a0, Palabra1 # a0 = direccion arreglo
jal LargoPalabra 
move $a1,$v0    # a1 = numero de palabras
li $a2, 34		#numero de bits por desplazar
jal sra_MP

#Se imprime el arreglo obtenido

la $a0, Palabra1
jal LargoPalabra
move $a1, $v0
jal ImpArregloInt

#Ahora se realizan pruebas para la palabra2 

#Se imprime el arreglo original

la $a0, Palabra2
jal LargoPalabra
move $a1, $v0
jal ImpArregloInt

#desplazamiento fuera del rango 
la $a0, Palabra2 # a0 = direccion arreglo
jal LargoPalabra 
move $a1,$v0    # a1 = numero de palabras
li $a2, 65		#numero de bits por desplazar
jal sra_MP


#Ahora se realizan pruebas para la palabra3 

#Se imprime el arreglo original

la $a0, Palabra3
jal LargoPalabra
move $a1, $v0
jal ImpArregloInt


la $a0, Palabra3 # a0 = direccion arreglo
jal LargoPalabra 
move $a1,$v0    # a1 = numero de palabras
li $a2, 12		#numero de bits por desplazar
jal sra_MP


#Se imprime el arreglo obtenido


la $a0, Palabra3
jal LargoPalabra
move $a1, $v0
jal ImpArregloInt



#------------------------Termina el programa--------------------------------------
	jal finProg		#llama a la funcion para finalizar el programa
#---------------------------------------------------------------------------------






#-------------Desplazamiento a la derecha de multiple precision-------------------
#-----------Funcion que es capaz de realizar un desplazamiento a la derecha-------
#-----------de un arreglo de palabras---------------------------------------------
#------------el desplazamiento que realiza es aritmetico por lo tanto-------------
#------------conserva el signo.---------------------------------------------------
# Para realizar esto se utiliza el codigo desarrollado en las lecturas del -------
# curso estructuras de computadoras digitales EIE-UCR-IE0321 impartidas por ------
# el  profesor Roberto Rodriguez. ------------------------------------------------
#El codigo inicial era capaz de rotar a la derecha 1 bit de un arreglo de palabras
#para este caso se empieza a rotar desde la palabra mas significativa que se -----
#encuentra en la menor direccion del arreglo. 

# Corre un bit a la derecha y luego suma el acarreo. Antes de realizar el corrimiento
# determina si el corrimiento produce un acarreo para la palabra siguiente y lo define.
#Para poder desplazar n bits se escribe un loop sobre el codigo original el cual correra
#el corrimiento de 1 bit a la derecha n veces.

#Para realizar el corrimiento aritmetico se aprovecha de la opcion de establecer un 
#acarreo inicial. Si este acarreo inicial siempre es 1 para la palabra mas significativa
#entonces cada vez que se realice un corrimiento se introducira un 1 a la izquierda.
#Si el acarreo inicial es 0 entonces se realiza un corrimiento normal. 
#Para determinar el valor del acarreo inicial se aplica una mascara que obtiene el 
#valor del bit mas significativo de la palabra mas significativa. Si este es distinto a 0
#se establece el acarreo inicial como 1, sino como 0.
					#Pal esta en $a1
					#La direccion de la palabra mas significativa esta en $a0
					#Numero de bits a desplazar esta en $a2
# la funcion devuelve un 1 si puede realizar el corrimiento, en caso contrario un 0. El resultado
#lo guarda en la direccion del arreglo original.

sra_MP:
	addi $sp, $sp, -8	#Guarda registros importantes en el stack (push stack)
	sw	$s1, 4($sp)		#Para poder utilizar los registros $s1 y $s0
	sw	$s0, 0($sp)

	#Inicialmente revisa si puede realizar el corrimiento 
	# Lo puede hacer si 0 <= (Numero de bits a desplazar) < (NumeroPalabras * 32)
	li $v0, 0		# $v0 = 0
	move $t0, $a1	# $t0 = NumeroPalabras 
	sll $t0, $t0, 5 # $t0 = NumeroPalabras * 32
	bge $a2,$t0,Finsra_MP # Si (Numero de bits a desplazar) > (NumeroPalabras * 32) => termina
	blt $a2,$0,Finsra_MP # Si (Numero de bits a desplazar) < 0 => termina

	#En caso de poder hacer el corrimiento continua
	li $v0, 1	#Carga 1 en $v0
	li $t1, 0  #Variable de iteracio j=0
	
	#El desplazamiento con signo se establece a partir del acarreo inicial
	#si el acarreo inicial es 1 entonces siempre introducira un 1 en el bit MSB 
	#cada vez que realice el corrimiento de un bit a la derecha 

	li $s0, 0x80000000 # mascara para revisar el bit mas significativo
	lw $s1, 0($a0)
	and $s1, $s0, $s1  # aplica la mascara and en $s0 a la palabra mas significativa
	loopNbitsD:
		beq $t1, $a2, Finsra_MP  #Cuando j = Numero de bits a desplazar, termina el loop
		li $t0, 0  		# i = 0
		li $t7, 0 		#acarreo inicial = 0
		beq $s1,$0, noNegativo #Se tiene que el numero no es negativo
		li $t7, 0x80000000 	#En caso de ser negativo establece el acarreo inicial como 0x80000000
		noNegativo:
		li $t2, 1 		#mascara = 1
		loop:					#Este loop desplaza un bit en todas las palabras
			beq $t0, $a1, finloop #Finaliza el loop cuando haya movido un bit en todas las palabras
			sll $t4, $t0, 2		# i *4
			addu $t5, $t4, $a0	# $t5 = (direccion arreglo) + i*4
			lw $t6,0($t5)		# $t6 = Arreglo[i*4]
			and $t4, $t6, $t2   # Revisa si tiene acarreo
			beq $t4, $0, next	#Si no tiene entonces continua a next
			li $t4, 0x80000000  #En caso de tener acarreo crea una nueva mascara para 
								#sumarle el acarreo a la palabra siguiente
			next:
				srl $t6,$t6,1 # Corre la palabra un bit a la derecha
				or $t6, $t6, $t7	#Suma el acarreo
				move $t7, $t4	#Establece el nuevo acarreo obtenido de la mascara $t2
				sw $t6, 0($t5)	#Guarda la palabra en Arreglo[ix4]
				addi $t0, $t0, 1 #Suma uno a la variable de iteracion
				j loop 			#Continua con el 
		finloop:
		addi $t1, $t1, 1   #Suma 1 a la variable de iteracion j. 
		j loopNbitsD       #Continua con el loop
Finsra_MP:
	lw	$s1, 4($sp)		#Hace pop de los registros guardados
	lw	$s0, 0($sp)
	addi $sp, $sp, 8
	bne $v0, $0, corrimientoPosible #si v0 es distinto de 0 significa que no se realizo el corrimiento
	la $a0, Error 	#Carga la frase de error
	move $t1, $v0	#guarda el resultado temporalmente en t1
	li $v0, 4		#imprime la frase de error
	syscall
	move $v0, $t1	#devuelve el resultado a v0
corrimientoPosible: #si el corrimiento fue posible no imprime el error
	jr $ra
#------------------------------------------------------------------------------------------




#----------------Funcion para contar la cantidad de caracteres en un String(asciiz)--------
#------------------Recibe en $a0 la direccion del string y devuelve en $v0-----------------
#-------------------------el numero de caracteres que contiene-----------------------------
LargoPalabra:
	li $v0, 0	#carga un 0 en $v0 que servira como contador y puntero
Cuenta:
	sll $t0, $v0, 2
	add $t0, $a0, $t0 	# $t0 = $a0 + $v0
	lw $t0, 0($t0)		# carga el byte en la direccion $t0
	beqz $t0,finLargoPalabra	# si el byte cargado es igual a null termina la funcion
	addi $v0, $v0, 1	#si el byte cargado no es null aumenta en uno la cuenta
	j Cuenta  			#y regresa al loop cuenta
finLargoPalabra:
	jr $ra 				#cuando termina la rutina regresa PC TIME + 4
#------------------------------------------------------------------------------------------


#--------------Funcion para imprimir las palabras de un arreglo como Int-------------------
#------------------Recibe en $a0 la direccion base del arreglo ----------------------------
#------------------Recibe en $a1 el numero de palabras del arreglo-------------------------
ImpArregloInt:
	move $t2,$a0  #$a0 = $t2
	li $t0, 0 # i # i = 0
	LoopImprimir:
		beq $t0, $a1, FinImpArregloInt #si se llega a la ultima palabra se termina
		sll $t1, $t0, 2	 # ix4	
		add $t1, $t1, $t2 # dirarreglo + ix4
		lw $a0, 0($t1) # a0 = arreglo[ix3]
		li $v0,1 	#carga en v0 1 para imprimir entero
		syscall	
		li $v0,4	#imprime un espacio
		la $a0, Space
		syscall
		addi $t0,$t0,1
		j LoopImprimir
FinImpArregloInt:
	la $a0, Return # al final imprime un retorno
	li $v0, 4 
	syscall
	move $a0,$t2
	jr $ra
#------------------------------------------------------------------------------------------

#------------------------Funcion para Finalizar el Programa-------------------------------
finProg:	
	li $v0, 10 #Llama en syscall el 10 para terminar el programa
	syscall
##########################################################################################