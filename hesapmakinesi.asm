

# Assembly Hesap Makinesi

  .data
  
string1: .asciiz "Birinci sayiyi yaziniz: \n"
opMesaj: .asciiz "Islem tipini giriniz: \n"
string2: .asciiz "Ikinci sayiyi yaziniz: \n"
sonucMsj: .asciiz "Hesap sonucu: \n"
hataMsj: .asciiz "Hatali operator girdiniz, secenekler: +, -, *, / \n"
newLine: .asciiz "\n"
carryMsj: .asciiz "Bölme isleminden kalan sayi: \n"

  
operand1: .word 1
operand2: .word 1
operator: .word 2

out: .word 1    #cikti icin bellek lokasyonu
kalan: .word 1  #kalan icin bellek lokasyonu



.text

main:
# Operand-1 mesaji:
li $v0, 4
la $a0, string1
syscall
# Input operand-1
li $v0, 5
syscall 
sw $v0, operand1 # Operand-1 inputu bellege kaydetme

optpye:
# Islem mesaji:
li $v0, 4
la $a0, opMesaj
syscall

# Operator sembolunu alma
la $a0, operator
la $a1, 2
li $v0, 8
syscall
lw $t0, 0($a0)

# NewLine
li $v0, 4
la $a0, newLine
syscall

# Islem kontrolu
li $t1, '+'
li $t2, '-'
li $t3, '*'
li $t4, '/'

beq $t0, $t1, ikinciOp
beq $t0, $t2, ikinciOp
beq $t0, $t3, ikinciOp
beq $t0, $t4, ikinciOp

j Hata

##
ikinciOp:
# Operand-2 mesaji:
li $v0, 4
la $a0, string2
syscall
# Input operand-2
li $v0, 5
syscall
sw $v0, operand2 # Operand-2 inputu bellege kaydet

lw $s1, operand1
lw $s2, operand2
lw $s0, out
lw $s4, kalan

# Islem tipini belirle:
beq $t0, $t1, toplama
beq $t0, $t2, cikarma
beq $t0, $t3, carpma
beq $t0, $t4, bolme



toplama:
add $s0, $s1, $s2
sw $s0, out
j print

cikarma:
sub $s0, $s1, $s2
sw $s0, out
j print

carpma:
mult $s1, $s2
mflo $s0
sw $s0, out
j print

bolme:
div $s1, $s2
mflo $s0 # Bolum sonucu
mfhi $s4 # Kalan sayi sonucu
sw $s4, kalan
# Kalan sayiyi yazdir
li $v0, 4
la $a0, carryMsj
syscall
li $v0, 1
lw $a0, kalan
syscall

# NewLine
li $v0, 4
la $a0, newLine
syscall

sw $s0, out
j print



##
print:
li $v0, 4
la $a0, sonucMsj
syscall

li $v0, 1
lw $a0, out
syscall

# NewLine
li $v0, 4
la $a0, newLine
syscall


j main





##
Hata:
# Hata mesaji
li $v0, 4
la $a0, hataMsj
syscall

j optpye


