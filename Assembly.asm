 
     .data
INPUT: .space 200  # 8 characters + 1 null byte
numbers: .word 200
firstmsg: .asciiz "This is a calculator which can convert binary to hexa decimal and vice versa: "
secondmsg: .asciiz " binary = "
thirdmsg: .asciiz " hexa = "
nextt: .asciiz "\n"
forth: .asciiz " Decimal = "
beforewords: .word 0

inputBinaryMsg: .asciiz "\nEnter binary Number  (less than 33 digits): "
inputDecimalMsg: .asciiz "\nEnter deciaml Number (less than 429496725d): "
inputHexadecimalMsg: .asciiz "\nEnter hexa Number (less than 0FFFFFFFFh): "
invalidInputMsg: .asciiz "\nInvalid/Wrong input - Try again please  "
longInputMsg: .asciiz "\nInput too long large - Try again please  "
menuMsg: .asciiz "\n\n1) Enter a Binary Number \n2) Enter a Decimal Number \n3) Enter a Hexa number \n4) Quit\n"
choiceMsg: .asciiz "\n Enter your choice --> "
errorMsg: .asciiz " Error :Invaild input.\n"
.globl main

.text
main:

la $a0,firstmsg  #printing msg
li $v0,4
syscall

mainLoop:

la $a0,menuMsg   #printing msg
li $v0,4
syscall

askUser:

sw $zero, beforewords
sw $zero, numbers
li $a0, 0
li $a1, 0
li $a2, 0
li $a3, 0

li $t0, 0
li $t1, 0
li $t2, 0
li $t3, 0
li $t4, 0
li $t5, 0
li $t6, 0
li $t7, 0

li $s0, 0
li $s1, 0
li $s2, 0
li $s3, 0
li $s4, 0
li $s5, 0
li $s6, 0
li $s7, 0

la $a0,choiceMsg   #printing msg
li $v0,4
syscall

li $v0,5
syscall            #input character

move $a0,$v0
beq $a0,1,binaryInput         #menu
beq $a0,2,decimalInput
beq $a0,3,hexadecimalInput
beq $a0,4,exitProgram
la $a0,errorMsg   #printing msg
li $v0,4
syscall
j askUser

################################ BINARY ####################################

binaryInput:

la $a0,inputBinaryMsg
li $v0,4       #printing msg
syscall

li $s0,0
la $t0,numbers

binaryInputLoop:
li $v0,12
syscall          #input character
beq $v0,10,endBinaryInput
ble $v0,47,endBinaryInput1
bge $v0,50,endBinaryInput1
addi $s0,$s0,1
beq $s0,32,endBinaryInput11         #checking length
move $a0,$v0
andi $a0,$a0,0x0F      #converting character into integer
sw $a0,0($t0)
addi $t0,$t0,4
j binaryInputLoop

endBinaryInput11:
la $a0,longInputMsg
li $v0,4
syscall
j binaryInput

endBinaryInput1:
la $a0,invalidInputMsg
li $v0,4
syscall
j binaryInput

endBinaryInput:
la $a0,secondmsg
li $v0,4        #printing msg
syscall
la $t0,numbers
li $t3,0

printBinary:
beq $s0,$t3,endPrintBinary
addi $t3,$t3,1
lw $a0,0($t0)
li $v0,1
syscall
addi $t0,$t0,4
j printBinary

endPrintBinary:
la $t0,numbers
li $t3,0
mul $t3,$s0,4          #s0 has input number
subi $t3,$t3,4        #code to get last position in array
add $t0,$t0,$t3

#converting into decimal
li $t1,0
li $t7,1

startBinaryToDecimal:
beq $t1,$s0,endBinaryToDecimal
addi $t1,$t1,1
lw $a0,0($t0)
mul $a0,$a0,$t7
mul $t7,$t7,2
add $s1,$s1,$a0
addi $t0,$t0,-4
j startBinaryToDecimal

endBinaryToDecimal:
la $a0,forth
li $v0,4
syscall    #printing msg

move $a0,$s1
li $v0,1
syscall

move $s7,$s1

la $a0,thirdmsg   #printing msg
li $v0,4
syscall

#converting into hexa
la $s0,numbers
li $t0,16
li $t7,1

startBinaryToHex:
div $s7,$t0
mfhi $s1
mflo $s7
sw $s1,0($s0)
addi $s0,$s0,4
addi $t7,$t7,1
ble $s7,15,endBinaryToHex
j startBinaryToHex

endBinaryToHex:
sw $s7,0($s0)
la $t0,numbers
li $t3,0
mul $t3,$t7,4
subi $t3,$t3,4       
add $t0,$t0,$t3     #code to get last position in array
li $s1,0
lw $a2, 0($t0)
ble $a2, 9, startBinaryToHexLoop
move $a1, $a0
li $v0, 11
li $a0, '0'
syscall

move $a0, $a1
li $s1,0

startBinaryToHexLoop:
bge $s1,$t7,endBinaryToHexLoop
addi $s1,$s1,1
lw $a0,0($t0)
addi $t0,$t0,-4
beq $a0,10,Aa9
beq $a0,11,Bb9
beq $a0,12,Cc9
beq $a0,13,Dd9
beq $a0,14,Ee9
beq $a0,15,Ff9
li $v0,1
syscall
j startBinaryToHexLoop

Aa9:
li $a0,'A'
li $v0,11
syscall
j startBinaryToHexLoop

Bb9:
li $a0,'B'
li $v0,11
syscall
j startBinaryToHexLoop

Cc9:
li $a0,'C'
li $v0,11
syscall
j startBinaryToHexLoop

Dd9:
li $a0,'D'
li $v0,11
syscall
j startBinaryToHexLoop

Ee9:
li $a0,'E'
li $v0,11
syscall
j startBinaryToHexLoop

Ff9:
li $a0,'F'
li $v0,11
syscall
j startBinaryToHexLoop

endBinaryToHexLoop:
j exitt

################################ DECIMAL ####################################

decimalInput:

la $a0,inputDecimalMsg
li $v0,4
syscall      #printing msg

li $s0,0
la $t0,numbers

startDecimalInput:
li $v0,12
syscall

beq $v0,10,endDecimalInput
ble $v0,47,endDecimalInput1
bge $v0,58,endDecimalInput1
addi $s0,$s0,1
beq $s0,10,endDecimalInput11     #checking length
move $a0,$v0
andi $a0,$a0,0x0F   #converting character into integer
sw $a0,0($t0)
addi $t0,$t0,4
j startDecimalInput

endDecimalInput11:
la $a0,longInputMsg
li $v0,4
syscall
j decimalInput

endDecimalInput1:
la $a0,invalidInputMsg
li $v0,4
syscall
j decimalInput

endDecimalInput:
la $a0,forth
li $v0,4        #printing msg
syscall
la $t0,numbers
li $t3,0

printDecimalInput:
beq $s0,$t3,endPrintDecimalInput
addi $t3,$t3,1
lw $a0,0($t0)
li $v0,1
syscall
addi $t0,$t0,4
j printDecimalInput

endPrintDecimalInput:
#converting character into decimal
li $s1,0
la $t0,numbers
li $t1,0
li $t3,0
li $t7,1
mul $t3,$s0,4
subi $t3,$t3,4    #code to get last position in array
add $t0,$t0,$t3

startDecimalToBinary:
beq $t1,$s0,endDecimalToBinary
addi $t1,$t1,1
lw $a0,0($t0)          #getting bit
mul $a0,$a0,$t7
mul $t7,$t7,10
add $s1,$s1,$a0
addi $t0,$t0,-4
j startDecimalToBinary

endDecimalToBinary:
move $s7,$s1     #saving decimal for further use

#convert decima into binary
move $t3,$s1              #this is value which is converted
sw $t3, beforewords
li $s3, 31 
j repeatDecimalToBinary1

repeatDecimalToBinary1:
lw $t0, beforewords
srlv $s1, $t0, $s3 
bnez $s1, exitDecimalToBinary1
beqz $s3, exitDecimalToBinary1
addi $s3, $s3, -1
j repeatDecimalToBinary1
        
exitDecimalToBinary1: 
move $t4, $s3 
li $v0, 4
li $v0, 4
la $a0, secondmsg
syscall

li $v0, 1
li $t6, 32 
sub $s3, $t6, $s3 
j repeatDecimalToBinary2

repeatDecimalToBinary2:
move $a0, $s1
syscall
beq $s3, $t6, exitDecimalToBinary2 
lw $t0, beforewords
sllv $t0, $t0, $s3 
srl $s1, $t0, 31 
addi $s3, $s3, 1 
j repeatDecimalToBinary2

exitDecimalToBinary2:
la $a0,thirdmsg
li $v0,4
syscall

#convert decimal into hexa
la $s0,numbers
li $t0,16
li $t7,1

startDecimalToHex1:
div $s7,$t0
mfhi $s1
mflo $s7
sw $s1,0($s0)
addi $s0,$s0,4
addi $t7,$t7,1
ble $s7,15,endDecimalToHex1
j startDecimalToHex1

endDecimalToHex1:
sw $s7,0($s0)
la $t0,numbers
li $t3,0
mul $t3,$t7,4
subi $t3,$t3,4
add $t0,$t0,$t3
li $s1,0
lw $a2, 0($t0)
ble $a2, 9, startDecimalToHex2
move $a1, $a0
li $v0, 11
li $a0, '0'
syscall
move $a0, $a1
li $s1,0

startDecimalToHex2:
bge $s1,$t7,endDecimalToHex2
addi $s1,$s1,1
lw $a0,0($t0)
addi $t0,$t0,-4
beq $a0,10,Ab
beq $a0,11,Bb
beq $a0,12,Cb
beq $a0,13,Db
beq $a0,14,Eb
beq $a0,15,Fb
li $v0,1
syscall
j startDecimalToHex2

Ab:
li $a0,'A'
li $v0,11
syscall
j startDecimalToHex2

Bb:
li $a0,'B'
li $v0,11
syscall
j startDecimalToHex2

Cb:
li $a0,'C'
li $v0,11
syscall
j startDecimalToHex2

Db:
li $a0,'D'
li $v0,11
syscall
j startDecimalToHex2

Eb:
li $a0,'E'
li $v0,11
syscall
j startDecimalToHex2

Fb:
li $a0,'F'
li $v0,11
syscall
j startDecimalToHex2

endDecimalToHex2:
j exitt

################################ HEXADECIMAL ####################################

hexadecimalInput:

la $a0,inputHexadecimalMsg
li $v0,4
syscall      #printing msg

li $s0,0
la $t0,numbers

hexInputLoop:
li $v0,12
syscall              #input character
beq $v0,10,endHexInputLoop1
addi $s0,$s0,1
beq $s0,10,endHexInputLoop2     #checking length

move $a0,$v0
beq $a0,'a',A
beq $a0,'A',A
beq $a0,'b',B
beq $a0,'B',B
beq $a0,'c',C
beq $a0,'C',C
beq $a0,'d',D
beq $a0,'D',D
beq $a0,'e',E
beq $a0,'E',E
beq $a0,'f',F
beq $a0,'F',F
blt $a0, '0', endHexInputLoop3
bgt $a0, '9', endHexInputLoop3
andi $a0,$a0,0x0F     #converting character into integer
sw $a0,0($t0)
addi $t0,$t0,4
j hexInputLoop

A:
li $a0,10
sw $a0,0($t0)
addi $t0,$t0,4
j hexInputLoop

B:
li $a0,11
sw $a0,0($t0)
addi $t0,$t0,4
j hexInputLoop

C:
li $a0,12
sw $a0,0($t0)
addi $t0,$t0,4
j hexInputLoop

D:
li $a0,13
sw $a0,0($t0)
addi $t0,$t0,4
j hexInputLoop

E:
li $a0,14
sw $a0,0($t0)
addi $t0,$t0,4
j hexInputLoop

F:
li $a0,15
sw $a0,0($t0)
addi $t0,$t0,4
j hexInputLoop

endHexInputLoop2:
la $a0,longInputMsg
li $v0,4
syscall
j hexadecimalInput

endHexInputLoop3:
la $a0,invalidInputMsg
li $v0,4
syscall
j hexadecimalInput

endHexInputLoop1:
la $a0,thirdmsg
li $v0,4
syscall          #printing msg

la $t0,numbers
li $t3,0

lw $a2, 0($t0)
ble $a2, 9, printHexDigits

move $a1, $a0
li $v0, 11
li $a0, '0'
syscall
move $a0, $a1

printHexDigits:
beq $s0,$t3,endPrintHex
addi $t3,$t3,1
lw $a0,0($t0)
addi $t0,$t0,4
beq $a0,10,Ab8
beq $a0,11,Bb8
beq $a0,12,Cb8
beq $a0,13,Db8
beq $a0,14,Eb8
beq $a0,15,Fb8
li $v0,1
syscall
j printHexDigits

Ab8:
li $a0,'A'
li $v0,11
syscall
j printHexDigits

Bb8:
li $a0,'B'
li $v0,11
syscall
j printHexDigits

Cb8:
li $a0,'C'
li $v0,11
syscall
j printHexDigits

Db8:
li $a0,'D'
li $v0,11
syscall
j printHexDigits

Eb8:
li $a0,'E'
li $v0,11
syscall
j printHexDigits

Fb8:
li $a0,'F'
li $v0,11
syscall
j printHexDigits

endPrintHex:
#converting hexa into decimal
la $t0,numbers
li $t3,0
mul $t3,$s0,4
subi $t3,$t3,4
add $t0,$t0,$t3
li $t1,0
li $t7,1

hexToDecLoop:
beq $t1,$s0,endHexToDec
addi $t1,$t1,1
lw $a0,0($t0)
mul $a0,$a0,$t7
mul $t7,$t7,16
add $s1,$s1,$a0
addi $t0,$t0,-4
j hexToDecLoop

endHexToDec:

la $a0,forth
li $v0,4          #printing msg
syscall

beq $s1,-1412567125,printdo
move $a0,$s1
li $v0,1
syscall
j printk

printdo:
li $t3,2
li $v0,1
mul $a0,$t3,144
syscall
mul $a0,$t3,1200
syscall
li $a0,171
syscall

printk:
#converting decimal into binary
move $t3,$s1              #this is value which is converted
sw $t3, beforewords
li $s3, 31 
j decToBinRepeat

decToBinRepeat:
lw $t0, beforewords
srlv $s1, $t0, $s3 
bnez $s1, decToBinExit
beqz $s3, decToBinExit
addi $s3, $s3, -1
j decToBinRepeat
        
decToBinExit: 
move $t4, $s3 
li $v0, 4
li $v0, 4
la $a0, secondmsg
syscall
li $v0, 1
li $t6, 32 
sub $s3, $t6, $s3 
j decToBinRepeat2

decToBinRepeat2:
move $a0, $s1
syscall
beq $s3, $t6, decToBinExit2 
lw $t0, beforewords
sllv $t0, $t0, $s3 
srl $s1, $t0, 31 
addi $s3, $s3, 1 
j decToBinRepeat2

decToBinExit2:

exitt:
li $t0, 0
sw $t0, beforewords
j mainLoop
 
exitProgram:	
li $v0, 10
syscall

