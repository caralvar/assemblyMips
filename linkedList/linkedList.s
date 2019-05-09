#--------------------Tarea 5. Estructuras de computadoras digitales-----------------
#-------------------Carlos Andres Alvarado Salazar, B50339, grupo 1-----------------
#---Listas enlazadas. Se realizan funciones en ensamblador para crear y-------------
#---la estructura de datos conocida como lista enlazada. Se realiza una funcion-----
#---para inicializar la lista, creando un puntero hacia el inicio de esta.----------
#---Se realiza una funcion (insert) para generar un nuevo nodo en la lista.---------
#---Cada nodo esta compuesto por 8 bytes, los primero 4 contienen el puntero al-----
#---siguiente nodo y los ultimos 4 contienen un dato flotante de simple precision---
#---el ultimo nodo almacena la palabra 0 (null) como puntero al proximo nodo para---
#---indicar el final de la lista.---------------------------------------------------
#---Se realiza una funcion para eliminar (delete) el ultimo nodo de la lista.-------
#---Tambien se crea una funcion para invertir (invert) el orden de los nodos de-----
#---la lista, esto se realiza recorriendo los nodos de la lista y se intercambia el-
#---del puntero del nodo actual por el puntero al  nodo anterior.-------------------
#---finalmente se crea una funcion que recorre la lista e imprime los datos de cada-
#---nodo. Esto para facilitar la revision del funcionamiento de las operaciones-----
#---aplicadas a la lista.-----------------------------------------------------------

.data #Declaracion de los datos necesarios para los ejercicios
	  
	SinNodos:	.asciiz "Lista vacia! \n" #Mensaje para indicar que la lista esta vacia
	Coma:	.asciiz ", "  	#Coma
	Retorno:	.asciiz "\n" 	#Retorno de linea 
	ptrList: .word 2   		#Se definen los datos que se ingresaran a la lista 
	Data0: .float 0.0
	Data1: .float 1.0
	Data2: .float -1.0
	Data3: .float 3.14
	Data4: .float 2.71
	Data5: .float -1.41
	Data6: .float 4.66 

.text

#------------------------------------MAIN-------------------------------------------------
main:

# A continuacion se aplican las distintas funciones realizadas a una lista enlazada para comprobar
#su correcto funcionamiento. Cada resultado puede ser visto en la consola. El funcionamiento de los
#procedimientos se encuentra comentado en cada uno de estos.

#Se inicializa la lista
la $a0, ptrList
jal initialize

#Se trata de imprimir la lista vacia
la $a0, ptrList
jal printList

#Se agrega un primer dato a la lista 
la $a0, ptrList
la $a1, Data0
jal insert

#Se imprime la lista con ese dato
la $a0, ptrList
jal printList

#Se agregan dos nuevos datos a la lista
la $a0, ptrList
la $a1, Data1
jal insert

la $a0, ptrList
la $a1, Data2
jal insert

#Se imprime de nuevo la lista
la $a0, ptrList
jal printList

#Se agregan dos nuevos datos a la lista 
la $a0, ptrList
la $a1, Data3
jal insert

la $a0, ptrList
la $a1, Data4
jal insert

#Se vuelve a imprimir la lista
la $a0, ptrList
jal printList

#Se agregan dos ultimos datos a la lista 
la $a0, ptrList
la $a1, Data5
jal insert

la $a0, ptrList
la $a1, Data6
jal insert

#Se vuelve a imprimir la lista
la $a0, ptrList
jal printList

#Se borra uno de los datos de la lista 
la $a0, ptrList
jal delete

#Se vuelve a imprimir la lista 
la $a0, ptrList
jal printList

#Se invierte la lista actual
la $a0, ptrList
jal invert

#Se vuelve a imprimir la lista 
la $a0, ptrList
jal printList

#Se eliminan dos datos de la lista 
la $a0, ptrList
jal delete

#Se vuelve a imprimir la lista 
la $a0, ptrList
jal printList

#Se invierte la lista actual
la $a0, ptrList
jal invert

#Se vuelve a imprimir la lista 
la $a0, ptrList
jal printList

#Se eliminan tres datos de la lista 
la $a0, ptrList
jal delete

la $a0, ptrList
jal delete

la $a0, ptrList
jal delete

#Se vuelve a imprimir la lista 
la $a0, ptrList
jal printList

#Se eliminan los ultimos datos de la lista 
la $a0, ptrList
jal delete

la $a0, ptrList
jal delete

#Finalmente se trata de invertir la lista vacia 
la $a0, ptrList
jal invert
#------------------------Termina el programa-----------------------------------------------
	jal finProg		#llama a la funcion para finalizar el programa
#------------------------------------------------------------------------------------------



#-----------------------------------Funciones---------------------------------------------


#----------------------------------initialize----------------------------------------------
#------Funcion para inicializar la lista enlazada sin elementos----------------------------
#------por lo que almacena en la direccion del puntero ptrList la palabra 0----------------
#------Recibe en $a0 el puntero ptrList.
initialize:
	sw $0, 0($a0)	#Se almacena un 0 en la direccion que apunta PtrList
endInitilize:
	li $v0, 1  #Devuelve 1 en el resultado 
	jr $ra
#------------------------------------------------------------------------------------------

#----------------------------------insert--------------------------------------------------
#------Funcion que introduce un elemento al final de la lista enlazada---------------------
#------Recibe en $a0 el puntero ptrList y en $a1 un dato tipo float de simple precision----
#------Debe recorrer la lista hasta llegar al elemento que contenga como siguiente---------
#------puntero el valor 0, solicitar nueva memoria para el siguiente elemento mediante-----
#------la funcion syscall 9, guarda en el ptr del elemento final anterior la direccion-----
#------donde se almacena el nuevo elemento. El nuevo elemento contiene en su primer--------
#------palabra el nuevo ptr con valor 0 y en la segunda palabra el dato--------------------

# $a0 = ptrList
# $a1 = dir del dato 
insert:
l.s $f0, 0($a1)		# Guarda en $f0 el dato del nuevo nodo
loopInsert:
	lw $t0, 0($a0)  # Carga en $t0 el dato del Ptr del nodo respectivo
	beqz $t0, endInsert #Si Ptr = 0 se llego al final de la cola
	move $a0, $t0	# En caso de no llegar al final el nuevo pointer pasa a ser $a0 y se repite el algoritmo
j loopInsert       #Loop 
endInsert:
	#Cuando llega al final $a0 contiene el puntero al ultimo nodo
	move $t0, $a0  # Se almacena el puntero al ultimo nodo en $t0
	li $a0, 8	#A continuacion se llama a syscall 9 para asignar dinamicamente
	li $v0, 9   #8 bytes para el nuevo nodo
	syscall     # en $v0 se encuentra el puntero al nuevo nodo que debe ser almacenado en el ultimo nodo   
	sw $v0, 0($t0) #Se guarda el puntero al nuevo nodo en el Ptr del ultimo nodo
	s.s $f0, 4($v0) #Se almacena en el ultimo nodo el dato respectivo en los ultimos 4 bytes
	sw $0, 0($v0)  #Se guarda un 0 en el ptr del nuevo nodo para establecer el final de la lista 
	li $v0, 1 	  # La funcion devuelve un 1 en caso de efectuar el insert 	
	jr $ra        #Terina la funcion y regresa PCTime + 4
#-----------------------------------------------------------------------------------------

#---------------------------------------delete--------------------------------------------
#------Funcion para eliminar el ultimo elemento de la lista enlazada----------------------
#------Recibe en $a0 el puntero ptrList y posteriormente recorre la lista enlazada--------
#------hasta llegar al ultimo elemento, finalmente cambia el ptr del penultimo elemento---
#------a 0 para que este sea el nuevo final de la lista.----------------------------------

delete:
	lw $t0, 0($a0) # $t0 = puntero al primer nodo de la lista 
	beqz $t0, noNodosDelete  #en caso de que ptrList apunte a 0 se tiene una lista vacia
loopDelete: 		#En caso de que hayan nodos empieza a recorrer la lista.
					#En cada loop $a0 posee el puntero al nodo anterior
					#$t0 posee el puntero al nodo actual
					#t1 tendra el puntero al nodo siguiente
	lw $t1, 0($t0)  #Guarda en $t1 el puntero al proximo nodo 
	beqz $t1, endDelete # si $t1 =  0/ se llega al dato final y $a0 = posee el puntero al nodo 
						# anterior donde se debe almacenar un 0 en caso de llegar al final de la lista
	move $a0, $t0 		# en caso de no llegar al dato final $t0 pasa a ser $a0
	move $t0, $t1		# y $t1 pasa a ser $t0 para la proxima iteracion (proximo nodo)
	j loopDelete		# y se repite el loop (se avanza al siguiente nodo)
noNodosDelete:
	la $a0, SinNodos  #En caso de tener una lista vacia se imprime en consola "Lista vacia!"
	li $v0, 4
	syscall
endDelete:
    sw $0, 0($a0)   #Guarda un 0 en el Ptr del penultimo nodo para eliminar el ultimo
    l.s $f0, 4($t0) #Devuelve en $f0 el dato del nodo eliminado
	jr $ra 			#Regresa a PCTime + 4
#------------------------------------------------------------------------------------------

#---------------------------------invert---------------------------------------------------
#--------Funcion que establece como ptrList (inicio de la lista enlazada) el---------------
#--------ultimo nodo de la lista ----------------------------------------------------------
invert:
lw $t0, 0($a0)  # $t0 = puntero al primer nodo 
beqz $t0, noNodosInvert  #en caso de que PtrList apunte a 0 la lista esta vacia 
move $t2, $t0			#se almacena el puntero al primer nodo en $t2
move $t3, $a0   		#se almacena el puntero a PtrList en $t3
loopInvert:
	#Al inicio de cada loop (Para cada nodo)
	# $a0 = puntero al nodo anterior
	# $t0 = puntero al nodo actual
	# $t1 = puntero al nodo siguiente
	lw $t1, 0($t0) # $t1 = ptr perteneciente al nodo actual
	beqz $t1, endInvert #si el ptr del nodo actual es 0 ya se llego al ultimo nodo
						#y se debe terminar la funcion
	sw $a0, 0($t0) # ahora el puntero del nodo actual apunta al nodo anterior
	# para el siguiente nodo:
	move $a0, $t0  # puntero al nodo actual ($t0) pasa a ser el puntero al nodo anterior ($a0)
	move $t0, $t1  # puntero al nodo siguiente ($t1) pasa a serl el puntero al nodo actual ($t0)
	j loopInvert # se continua realizando los cambios de punteros hasta llegar al ultimo nodo.
endInvert:
	sw $0, 0($t2)  #Se guarda un 0 en el ptr del primer nodo para indicar el nuevo final de la lista
	sw $t0, 0($t3) #Se guarda donde apunta PtrList el puntero al ultimo nodo.
	sw $a0, 0($t0) #se guarda el pointer al penultimo nodo como ptr del ultimo nodo
	jr $ra          # regresa a PCTime + 4
noNodosInvert:
	la $a0, SinNodos #En caso de no tener nodos se imprime en consola "Lista vacia!"
	li $v0, 4
	syscall
	jr $ra 			# regresa a PCTime + 4
#------------------------------------------------------------------------------------------

#----------------------------------------printList-----------------------------------------
#----------------Funcion para improimir una lista enlazada---------------------------------
#----------Se recorre la lista hasta llegar al ultimo nodo y se imprime cada uno-----------
#----------de los datos del nodo-----------------------------------------------------------
#----------recibe en $a0 ptrList-----------------------------------------------------------
printList:
	lw $t0, 0($a0) 		# $t0 = puntero al primer nodo 
	beqz $t0, noNodosPrint #se determina si la lista esta vacia 
loopPrint: 				# En caso de que la lista no este vacia se recorren los nodos 
						# Para cada iteracion se tiene en $t0 el puntero al nodo actual
	l.s $f12, 4($t0)    #Se carga en $f12 el dato del nodo actual
	li $v0, 2           #Se llama a syscall 2 para imprimir .flotante de precision simple
	syscall
	la $a0, Coma        #Se imprime una coma y un espacio para diferenciar los datos 
	li $v0, 4
	syscall
	lw $t0, 0($t0)     #Se carga en $t0 el puntero al nodo siguiente para la proxima iteracion
	beqz $t0, finPrintList #Si el puntero al nodo siguiente es 0 se llego al final de la lista 
	j loopPrint        # En caso de no haber llegado al final se sigue recorriendo la lista 
finPrintList:
	la $a0, Retorno    #Cuando se termina de imprimir la lista se imprime un retorno
	li $v0, 4
	syscall
	jr $ra             # Regresa a PCTime + 4
noNodosPrint:
	la $a0, SinNodos #En caso de no tener nodos se imprime en consola "Lista vacia!"
	li $v0, 4
	syscall
	jr $ra # regresa a PCTime + 4
#---------------------------------------------------------------------------------------------

#------------------------Funcion para Finalizar el Programa-------------------------------
finProg:	
	li $v0, 10 #Llama a syscall 10 para terminar el programa
	syscall
##########################################################################################