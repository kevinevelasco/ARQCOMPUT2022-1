.data
    dashes: .asciiz "\n-----\n"
    bar: .byte '|'
    symbols: .byte 'X','O'
    text: .asciiz "Player, please type your symbol to use (X, O): "
    found: .asciiz "Letter found!"
    found1: .asciiz " Found at first position of the array"
    found2: .asciiz " Found at SECOND position of the array"
    notfound: .asciiz "Wrong symbol..."
    newline: .asciiz "\n"
    space: .byte ' '
    board: .byte ' ',' ',' ',' ',' ',' ',' ',' ',' '
    false: .asciiz " Las condiciones arrojan un false"
    true: .asciiz " Las condiciones arrojan un true en el primer if"
    trueTwo: .asciiz " Las condiciones arrojan un true en el segundo else if"
    trueThree: .asciiz " Las condiciones arrojan un true en el tercer else if"
    welcomeMessage: .asciiz "Welcome to tic tac toe \n"
    userWins: .asciiz "The user wins!!!\n"
    machineWins: .asciiz "The machine wins!!!\n"
    tieGame: .asciiz "Tie!!!"
    message1: .asciiz "Where do yo want to put your symbol? (1-9): \n"
    message2: .asciiz "Invalid location\n"
.text
    move $s4, $zero #boolean
    addi $s7, $zero,1 #turn
    main:
        li $v0, 4
        la $a0, welcomeMessage
        syscall
        jal players_symbol
        while_not_gamefinish:
            beq $s7, 1, computer_choice
            beq $s7, $zero, symbolLocation           
            exit_symbolLocation:
            exit_computerChoice:
            jal display_board
            j game_finish
            exitGame_finish:
            beq $s4, 1, finish_game
            beq $s4, $zero, tie_game
            not_tie:
            j while_not_gamefinish      
    display_board:
        la $a0, newline
    	li $v0, 4
    	syscall
    	li $v0, 4
    	la $a0, newline
    	syscall
        la $t7,board
        la $a0, newline
    	li $v0, 4
    	syscall  
        #imprimir board[0]
        li $v0, 11
        lb $a0, 6($t7) 
        syscall
        move $a1, $a0 #guardo en $a1 lo que hay en board[0]

        #imprimir 1|
        li $v0,11 
        lb $a0,bar
        syscall 

        #imprimir board[1]
        li $v0, 11
        lb $a0, 7($t7) 
        syscall
        move $a2, $a0 #guardo en $a2 lo que hay en board[1]

        #imprimir 1|2|
        li $v0,11 
        lb $a0,bar
        syscall

        #imprimir board[2]
        li $v0, 11
        lb $a0, 8($t7) 
        syscall
        move $a3, $a0 #guardo en $a3 lo que hay en board[2]

        #imprimir -----
        li $v0,4 
        la $a0,dashes
        syscall

        #imprimir board[3]
        li $v0, 11
        lb $a0, 3($t7) 
        syscall
        move $a1, $a0 #guardo en $a1 lo que hay en board[3]

        #imprimir 4|
        li $v0,11 
        lb $a0,bar
        syscall 

        #imprimir board[4]
        li $v0, 11
        lb $a0, 4($t7) 
        syscall
        move $a2, $a0 #guardo en $a2 lo que hay en board[4]

        #imprimir 4|5|
        li $v0,11 
        lb $a0,bar
        syscall 

        #imprimir board[5]
        li $v0, 11
        lb $a0, 5($t7)
        syscall
        move $a3, $a0 #guardo en $a3 lo que hay en board[5]

        #imprimir -----
        li $v0,4 
        la $a0,dashes
        syscall

        #imprimir board[6]
        li $v0, 11
        lb $a0, 0($t7) 
        syscall
        move $a1, $a0 #guardo en $a1 lo que hay en board[6]

        #imprimir 7|
        li $v0,11 
        lb $a0,bar
        syscall 

        #imprimir board[7]
        li $v0, 11
        lb $a0, 1($t7) 
        syscall
        move $a2, $a0 #guardo en $a2 lo que hay en board[7]

        #imprimir 7|8|
        li $v0,11 
        lb $a0,bar
        syscall 

        #imprimir board[8]
        li $v0, 11
        lb $a0, 2($t7) 
        syscall
        move $a3, $a0 #guardo en $a3 lo que hay en board[8]
        jr $ra
    symbolLocation:       
        #solicita al usuario la posicion a poner el siguiente simbolo
        li $v0, 4
        la $a0, newline
        syscall 
        li $v0, 4
        la $a0, message1
        syscall           
        #obtener la posicion de 1 a 9
        li $v0, 5
        syscall     
        #guarda el valor ingresado en $t1
        move $t1, $v0     
        #resta a playerSymbol-1
        subi $t2, $t1, 1 #t2= numero ingresado por el usuario-1    
        lb $t0,space #guarda el espacio en a0     
        lb $t3, symbols($s7)
        lb $t7, board($t2) #guardo en $a1 lo que hay en board[$t2]
        #si hay un espacio
        beq $t7, $t0, emptyposition # if board[playerSymbol-1] == ' ':
        bne $t7, $t0, fullposition
        emptyposition:
            sb $t3, board($t2) # inTheBoard = True- board[playerSymbol-1] = symbol  
            addi $s7, $zero, 1
            move $s6, $t2  
            j exit_symbolLocation 
        fullposition:
            la $a0, message2
            li $v0,4
            syscall
            j symbolLocation        
    players_symbol:
        #prompt user
        li $t6, 1 #BANDERA CorrectSymbol EN TRUE
        li $t7, 0 #BANDERA CorrectSymbol EN FALSE
        while:
            la $a0, text
            li $v0, 4
            syscall

            #store user input in t0
            li $v0,12
            syscall
            move $t0, $v0
            bne $t6, $t7, procedure #EL CICLO WHILE VA HASTA QUE LA BANDERA EST� EN TRUE
        procedure:
            li $s0, 0 #init counter
            la $a0, newline
            li $v0, 4
            syscall
        loop:
            beq $s0,2,nosuchword #loop counter exit_player_symbols at 2 loops -> 2 elements of the array multiplied by 1 (number of bytes of each one).
            lb $t1,symbols($s0) #load next database entry 
            la $a0, newline
            li $v0, 4
            syscall
            beq  $t0,$t1,foundword # **if playerSymbol in symbols: ** De este se desprenden otros dos ifs
            addu $s0, $s0, 1 #increment counter by 1 (offset size)-> 1 byte because char is 1 byte.
            j loop
        foundword:
            la $a2, symbols #put address of symbols in $a2
            lb $a0, 0($a2) #lo que hay en symbols[0] lo guardo en $t6
            lb $a1, 1($a2) #lo que hay en symbols[1] lo guardo en $a1
            beq $t0, $a0, exit_player_symbol  #primer if.  if playerSymbol == symbols[0]:
            beq $t0, $a1, secondPos #segundo if. if playerSymbol == symbols[1]:
            j exit_player_symbol
        nosuchword:
            la $a0, notfound
            li $v0,4
            syscall
            la $a0, newline
            li $v0, 4
            syscall
            addi $t7, $t7, 1
            j while
        secondPos:
            addi $t6, $zero, 1
            lb $t5, 0($a2)
            sb $t5,symbols($t6) #symbols[1] = symbols[0]
            sb $t0,symbols($zero) #symbols[0] = playerInput            
            j exit_player_symbol		#salida
        exit_player_symbol:
            jr $ra                
    game_finish:
        #if block
	lb $t0,space #guarda el espacio en a0
	la $t7,board 
	lb $a1, 0($t7) #imprimir board[0]
	lb $a2, 1($t7) #imprimir board[1]	
	lb $a3, 2($t7) #imprimir board[2]	
	sne $t1, $t0, $a1 #$t1 = board[0] != ' '
	
	sne $t2, $t0, $a2 #$t2 = board[1] != ' '
	
	sne $t3, $t0, $a3 #$t3 = board[2] != ' '
	
	and $t4, $t2, $t1 #andOne o $t4 = (board[0] != ' ' & board[1] != ' '
	
	and $t5, $t3, $t4 #andTwo o $t5 = andOne o $t4 && board[2] != ' '
	
	seq $s0, $a2, $a1 #zeo o $s0 = board[0] == board[1]

	seq $s1, $a3, $a2 #oet o $s1 = board[1] == board[2]

	and $s2, $s1, $s0 #and1 o $s2 = zeo o $s0 && oet o $s1

	and $s3, $t5, $s2 #and1difspace = and1 && andTwo, es decir $s3 = $s2 && $t5

	#borro lo que hab�a en esos registros para usarlos para los siguientes 3 espacios del array (3,4,5)
	move $a1, $zero
	move $a2, $zero
	move $a3, $zero
	move $t1, $zero
	move $t2, $zero
	move $t3, $zero
	move $t4, $zero
	move $t5, $zero
	move $s0, $zero
	move $s1, $zero
	move $s2, $zero
	#$s3 no se borra porque se usa para una posterior comparaci�n, y $t7 no se borra porque ah� est� el tablero
	
	lb $a1, 3($t7) #imprimir board[3]
	lb $a2, 4($t7) #imprimir board[4]
	lb $a3, 5($t7) #imprimir board[5]	
	sne $t1, $t0, $a1 #$t1 = board[3] != ' '
	sne $t2, $t0, $a2 #$t2 = board[4] != ' '
	sne $t3, $t0, $a3 #$t3 = board[5] != ' '
	and $t4, $t2, $t1 #andThree o $t4 = (board[3] != ' ' && board[4] != ' '
	
	and $t5, $t3, $t4 #andFour o $t5 = andThree o $t4 && board[5] != ' '

	seq $s0, $a2, $a1 #tef o $s0 = board[3] == board[4]
	seq $s1, $a3, $a2 #fefi o $s1 = board[4] == board[5]
	and $s2, $s1, $s0 #and2 o $s2 = tef o $s0 && fefi o $s1
	and $s4, $t5, $s2 #and2difspace = and2 && andFour, es decir $s4 = $s2 && $t5

	or $t6, $s4, $s3 #conditional1 = and1difspace || and2difspace, es decir $t6 = $s3 || $s4

	#borro lo que hab�a en esos registros para usarlos para los siguientes 3 espacios del array (6,7,8)
	move $a1, $zero
	move $a2, $zero
	move $a3, $zero
	move $t1, $zero
	move $t2, $zero
	move $t3, $zero
	move $t4, $zero
	move $t5, $zero
	move $s0, $zero
	move $s1, $zero
	move $s2, $zero
	move $s3, $zero
	move $s4, $zero
	#borro todos excepto el conditional1 es decir el $t6, y tampoco el $t7, que tiene el tablero

	lb $a1, 6($t7) #imprimir board[6]
	lb $a2, 7($t7) #imprimir board[7]
	lb $a3, 8($t7) #imprimir board[8]
	sne $t1, $t0, $a1 #$t1 = board[6] != ' '
	sne $t2, $t0, $a2 #$t2 = board[7] != ' '
	sne $t3, $t0, $a3 #$t3 = board[8] != ' '
	and $t4, $t2, $t1 #andFive o $t4 = (board[6] != ' ' && board[7] != ' '
	
	and $t5, $t3, $t4 #andSix o $t5 = andFive o $t4 && board[8] != ' '
	
	seq $s0, $a2, $a1 #sese o $s0 = board[6] == board[7]
	seq $s1, $a3, $a2 #seee o $s1 = board[7] == board[8]
	and $s2, $s1, $s0 #and3 o $s2 = sese o $s0 && seee o $s1
	and $s3, $t5, $s2 #and3difspace = and3 && andSix, es decir $s3 = $s2 && $t5

	or $s4, $s3, $t6 #condition = conditional1 || and3difspace, es decir $s4 = $t6 || $s3

	#quedo if (condition) -> if($s4)

	beqz $s4, elifOne #si es falsa, es decir 0, que vaya al siguiente else-if
	#si no es falsa, que haga:
	#return true
	#la $a0, true
	#li $v0, 4
	#syscall
	j exitGame_finish	
	
	elifOne:
            #borro lo que hab�a en esos registros para usarlos en el else if
            move $a1, $zero
            move $a2, $zero
            move $a3, $zero
            move $t1, $zero
            move $t2, $zero
            move $t3, $zero
            move $t4, $zero
            move $t5, $zero
            move $t6, $zero
            move $s0, $zero
            move $s1, $zero
            move $s2, $zero
            move $s3, $zero
            move $s4, $zero
            #borro todos excepto el $t7, que tiene el tablero

            lb $a1, 0($t7) #imprimir board[0]
            lb $a2, 3($t7) #imprimir board[3]
            lb $a3, 6($t7) #imprimir board[6]

            sne $t1, $t0, $a1 #$t1 = board[0] != ' '

            sne $t2, $t0, $a2 #$t2 = board[3] != ' '

            sne $t3, $t0, $a3 #$t3 = board[6] != ' '

            and $t4, $t2, $t1 #andOne o $t4 = (board[0] != ' ' & board[3] != ' '

            and $t5, $t3, $t4 #andTwo o $t5 = andOne o $t4 && board[6] != ' '

            seq $s0, $a2, $a1 #zeo o $s0 = board[0] == board[3]

            seq $s1, $a3, $a2 #oet o $s1 = board[3] == board[6]

            and $s2, $s1, $s0 #and1 o $s2 = zeo o $s0 && oet o $s1

            and $s3, $t5, $s2 #and1difspace = and1 && andTwo, es decir $s3 = $s2 && $t5

            #borro lo que hab�a en esos registros para usarlos para los siguientes 3 espacios del array (3,4,5)
            move $a1, $zero
            move $a2, $zero
            move $a3, $zero
            move $t1, $zero
            move $t2, $zero
            move $t3, $zero
            move $t4, $zero
            move $t5, $zero
            move $s0, $zero
            move $s1, $zero
            move $s2, $zero
            #$s3 no se borra porque se usa para una posterior comparaci�n, y $t7 no se borra porque ah� est� el tablero
            lb $a0, 1($t7) #imprimir board[1]
            move $a1, $a0 #guardo en $a1 lo que hay en board[1]
            lb $a0, 4($t7) #imprimir board[4]
            move $a2, $a0 #guardo en $a2 lo que hay en board[4]
            lb $a0, 7($t7) #imprimir board[7]
            move $a3, $a0 #guardo en $a3 lo que hay en board[7]

            sne $t1, $t0, $a1 #$t1 = board[1] != ' '
            sne $t2, $t0, $a2 #$t2 = board[4] != ' '
            sne $t3, $t0, $a3 #$t3 = board[7] != ' '
            and $t4, $t2, $t1 #andThree o $t4 = (board[1] != ' ' && board[4] != ' '

            and $t5, $t3, $t4 #andFour o $t5 = andThree o $t4 && board[7] != ' '

            seq $s0, $a2, $a1 #tef o $s0 = board[1] == board[4]
            seq $s1, $a3, $a2 #fefi o $s1 = board[4] == board[7]
            and $s2, $s1, $s0 #and2 o $s2 = tef o $s0 && fefi o $s1
            and $s4, $t5, $s2 #and2difspace = and2 && andFour, es decir $s4 = $s2 && $t5

            or $t6, $s4, $s3 #conditional1 = and1difspace || and2difspace, es decir $t6 = $s3 || $s4

            #borro lo que hab�a en esos registros para usarlos para los siguientes 3 espacios del array (6,7,8)
            move $a1, $zero
            move $a2, $zero
            move $a3, $zero
            move $t1, $zero
            move $t2, $zero
            move $t3, $zero
            move $t4, $zero
            move $t5, $zero
            move $s0, $zero
            move $s1, $zero
            move $s2, $zero
            move $s3, $zero
            move $s4, $zero
            #borro todos excepto el conditional1 es decir el $t6, y tampoco el $t7, que tiene el tablero
            lb $a1, 2($t7) #imprimir board[2]
            lb $a2, 5($t7) #imprimir board[5]
            lb $a3, 8($t7) #imprimir board[8]

            sne $t1, $t0, $a1 #$t1 = board[2] != ' '
            sne $t2, $t0, $a2 #$t2 = board[5] != ' '
            sne $t3, $t0, $a3 #$t3 = board[8] != ' '
            and $t4, $t2, $t1 #andFive o $t4 = (board[2] != ' ' && board[5] != ' '

            and $t5, $t3, $t4 #andSix o $t5 = andFive o $t4 && board[8] != ' '

            seq $s0, $a2, $a1 #sese o $s0 = board[2] == board[5]
            seq $s1, $a3, $a2 #seee o $s1 = board[5] == board[8]
            and $s2, $s1, $s0 #and3 o $s2 = sese o $s0 && seee o $s1
            and $s3, $t5, $s2 #and3difspace = and3 && andSix, es decir $s3 = $s2 && $t5

            or $s4, $s3, $t6 #condition = conditional1 || and3difspace, es decir $s4 = $t6 || $s3

            #quedo if (condition) -> if($s4)

            beqz $s4, elifTwo #si es falsa, es decir 0, que vaya al siguiente else-if
            #si no es falsa, que haga:
            #return true
            #la $a0, trueTwo
            #li $v0, 4
            j exitGame_finish

        elifTwo:
            #borro lo que hab�a en esos registros para usarlos en el else if
            move $a1, $zero
            move $a2, $zero
            move $a3, $zero
            move $t1, $zero
            move $t2, $zero
            move $t3, $zero
            move $t4, $zero
            move $t5, $zero
            move $t6, $zero
            move $s0, $zero
            move $s1, $zero
            move $s2, $zero
            move $s3, $zero
            move $s4, $zero
            #borro todos excepto el $t7, que tiene el tablero
            lb $a1, 6($t7) #imprimir board[6]
            lb $a2, 4($t7) #imprimir board[4]
            lb $a3, 2($t7) #imprimir board[2]

            sne $t1, $t0, $a1 #$t1 = board[6] != ' '

            sne $t2, $t0, $a2 #$t2 = board[4] != ' '

            sne $t3, $t0, $a3 #$t3 = board[2] != ' '

            and $t4, $t2, $t1 #andOne o $t4 = (board[6] != ' ' & board[4] != ' '

            and $t5, $t3, $t4 #andTwo o $t5 = andOne o $t4 && board[2] != ' '

            seq $s0, $a2, $a1 #zeo o $s0 = board[6] == board[4]

            seq $s1, $a3, $a2 #oet o $s1 = board[4] == board[2]

            and $s2, $s1, $s0 #and1 o $s2 = zeo o $s0 && oet o $s1

            and $s3, $t5, $s2 #and1difspace = and1 && andTwo, es decir $s3 = $s2 && $t5

            #borro lo que hab�a en esos registros para usarlos para los siguientes 3 espacios del array (3,4,5)
            move $a1, $zero
            move $a2, $zero
            move $a3, $zero
            move $t1, $zero
            move $t2, $zero
            move $t3, $zero
            move $t4, $zero
            move $t5, $zero
            move $s0, $zero
            move $s1, $zero
            move $s2, $zero
            #$s3 no se borra porque se usa para una posterior comparaci�n, y $t7 no se borra porque ah� est� el tablero
            lb $a1, 0($t7) #imprimir board[0]
            lb $a2, 4($t7) #imprimir board[4]
            lb $a3, 8($t7) #imprimir board[8]

            sne $t1, $t0, $a1 #$t1 = board[0] != ' '
            sne $t2, $t0, $a2 #$t2 = board[4] != ' '
            sne $t3, $t0, $a3 #$t3 = board[8] != ' '
            and $t4, $t2, $t1 #andThree o $t4 = (board[0] != ' ' && board[4] != ' '

            and $t5, $t3, $t4 #andFour o $t5 = andThree o $t4 && board[8] != ' '

            seq $s0, $a2, $a1 #tef o $s0 = board[0] == board[4]
            seq $s1, $a3, $a2 #fefi o $s1 = board[4] == board[8]
            and $s2, $s1, $s0 #and2 o $s2 = tef o $s0 && fefi o $s1
            and $s4, $t5, $s2 #and2difspace = and2 && andFour, es decir $s4 = $s2 && $t5

            or $t6, $s4, $s3 #conditional = and1difspace || and2difspace, es decir $t6 = $s3 || $s4

            #quedo if (condition) -> if($t6)
            move $s4, $t6
            beqz $s4, else #si es falsa, es decir 0, que vaya al else
            #si no es falsa, que haga:
            #return true
            #la $a0, trueThree
            #li $v0, 4
            #syscall
            j exitGame_finish
        else: 
            #return false
            move $s4, $zero
            #la $a0, false
            #li $v0, 4
            #syscall
            j exitGame_finish
    computer_choice:
    	lb $t0, space
    	la $t7, board
    	lb $a0, 0($t7)
    	move $t1, $a0
    	bne $t1, $t0, not_first_turn
    	lb $a0,1($t7)
    	move $t1, $a0
    	bne $t1, $t0, not_first_turn  
    	lb $a0,2($t7)
    	move $t1, $a0
    	bne $t1, $t0, not_first_turn  
    	lb $a0,3($t7)
    	move $t1, $a0
    	bne $t1, $t0, not_first_turn   
    	lb $a0,4($t7)
    	move $t1, $a0
    	bne $t1, $t0, not_first_turn  
    	lb $a0,5($t7)
    	move $t1, $a0
    	bne $t1, $t0, not_first_turn 
    	lb $a0,6($t7)
    	move $t1, $a0
    	bne $t1, $t0, not_first_turn   
    	lb $a0,7($t7)
    	move $t1, $a0
    	bne $t1, $t0, not_first_turn
    	lb $a0,8($t7)
    	move $t1, $a0
    	bne $t1, $t0, not_first_turn
    	lb $t0, symbols($s7)
    	addi $t2, $zero, 4
    	sb $t0, board($t2)
    	move $s7, $zero
    	j exit_computerChoice
    	not_first_turn:
    	    move $t0, $zero
    	    loop_0_8: 
    	    	lb $t3, board($t0)
    	    	lb $t4, symbols($s7)
    	    	addi $t5, $zero, 8
    	    	sub $t5, $t5, $t0
    	    	sne $t1, $t0, 4
    	    	seq $t2, $t3, $t4
    	    	lb $t6, board($t5)
    	    	lb $t8, space
    	    	seq $t3, $t6, $t8
    	    	and $t1, $t1, $t2
    	    	and $t1, $t1, $t3
    	    	beq $t1, 1, winable
    	    	addi $t0, $t0, 1
    	    	sgt $t1, $t0, 8
    	    	beq $t1, 1, not_winable
    	    	j loop_0_8
    	    	winable:
    	    	    sb $t4, board($t5)
    	    	    move $s7, $zero
    	    	    j exit_computerChoice
    	    	not_winable:
    	    	    sne $t1, $s6, 2
    	    	    sne $t2, $s6, 5
    	    	    sne $t3, $s6, 8
    	    	    addi $t8, $s6, 1
    	    	    lb $t6, board($t8)
    	    	    lb $t7, space
    	    	    seq $t4, $t6, $t7
    	    	    and $t1, $t1, $t2
    	    	    and $t1, $t1, $t3
    	    	    and $t1, $t1, $t4
    	    	    beqz $t1, elif_1
    	    	    lb $t2, symbols($s7)
    	    	    sb $t2, board($t8)
    	    	    move $s7, $zero
    	    	    j exit_computerChoice
    	    	    elif_1:
    	    	        sgt $t1, $s6, 2
                        subi $t8, $s6, 3
                        lb $t6, board($t8)
                        lb $t7, space
                        seq $t4, $t6, $t7
                        and $t1, $t1, $t4
                        beqz $t1, elif_2
                        lb $t2, symbols($s7)
                        sb $t2, board($t8)
                        move $s7, $zero
                        j exit_computerChoice
                    elif_2:
                        sne $t1, $s6, 0
                        sne $t2, $s6, 3
                        sne $t3, $s6, 6
                        subi $t8, $s6, 1
                        lb $t6, board($t8)
                        lb $t7, space
                        seq $t4, $t6, $t7
                        and $t1, $t1, $t2
                        and $t1, $t1, $t3
                        and $t1, $t1, $t4
                        beqz $t1, elif_3
                        lb $t2, symbols($s7)
                        sb $t2, board($t8)
                        move $s7, $zero
                        j exit_computerChoice
                    elif_3:
                    	addi $t3, $zero, 6
    	    	        slt $t1, $s6, $t3
                        addi $t8, $s6, 3
                        lb $t6, board($t8)
                        lb $t7, space
                        seq $t4, $t6, $t7
                        and $t1, $t1, $t4
                        beqz $t1, else_board_is_full
                        lb $t2, symbols($s7)
                        sb $t2, board($t8)
                        move $s7, $zero
                        j exit_computerChoice
                    else_board_is_full:
                        move $t0, $zero
                        loop_find_space:
                            lb $t2, board($t0)
                            lb $t3, space
                            seq $t1, $t2, $t3
                            addi $t0, $t0, 1
                            beq $t1, 1, save_final_value
                            bgt $t0, 8, exit	
                            j loop_find_space
                            save_final_value:
                                lb $t6, symbols($s7)
                                subi $t0, $t0, 1
                                sb $t6, board($t0)
                                move $s7, $zero
                                j exit_computerChoice  	    
    finish_game:
        jal display_board
        beq $s7, 1, user_wins
        beq $s7, $zero, machine_wins
        j exit
    machine_wins:
    	la $a0, newline
    	li $v0, 4
    	syscall
        la $a0, machineWins
        li $v0, 4
        syscall
        j exit
    user_wins:
    	la $a0, newline
    	li $v0, 4
    	syscall
        la $a0, userWins
        li $v0, 4
        syscall
        j exit 
    tie_game:
    	lb $t0, space
    	la $t7, board
    	lb $a0,0($t7)
    	move $t1, $a0
    	beq $t1, $t0, not_tie
    	lb $a0,1($t7)
    	move $t1, $a0
    	beq $t1, $t0, not_tie  
    	lb $a0,2($t7)
    	move $t1, $a0
    	beq $t1, $t0, not_tie  
    	lb $a0,3($t7)
    	move $t1, $a0
    	beq $t1, $t0, not_tie   
    	lb $a0,4($t7)
    	move $t1, $a0
    	beq $t1, $t0, not_tie  
    	lb $a0,5($t7)
    	move $t1, $a0
    	beq $t1, $t0, not_tie 
    	lb $a0,6($t7)
    	move $t1, $a0
    	beq $t1, $t0, not_tie   
    	lb $a0,7($t7)
    	move $t1, $a0
    	beq $t1, $t0, not_tie
    	lb $a0,8($t7)
    	move $t1, $a0
    	beq $t1, $t0, not_tie  
    	jal display_board
    	la $a0, newline
    	li $v0, 4
    	syscall
    	la $a0, tieGame
    	li $v0, 4
    	syscall
    	j exit  
    exit:
    	li $v0, 10
    	syscall	

