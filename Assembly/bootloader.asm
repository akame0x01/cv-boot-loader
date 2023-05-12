jmp short main
nop ;preencher espaço

OEMName: 		db "MORAESOS"
bytePerSector: 		dw 512
sectorPerCluster: 	db 1
reservedSectors: 	dw 1
numberFats: 		db 2
numberRootEntries:	dw 224
numberOfSmallSectors:   dw 2880
mediaType: 		db 0xf0
numberFatsSectors:      dw 9
sectorPerTracker:       dw 18
numberOfHeades:         dw 2
hiddenSectors:          dd 0
numberOfLargeSectors:   dd 0
driveNumber:            db 0
reserved:               db 0
extendedBootSignature:  db 0x29
volumeSerialNumber:     dd 0xa1b2c3d4
volumeLabel:            db "MORAESOS   "
fileSysType:            db "FAT12   " 

nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
 

;----------------------------------------------------------------------

main:
mov[driveNumber],dl

mov ax,0x7c00  ;deixando predefinido o valor do reg de dados
mov ds,ax

mov ax,0x7c0 ;é passado 7c0 para quando ocorrer o bit shift resultar no valor correto
mov es, ax

sub ax,0x200 ;definindo espaço para pilha
mov sp,ax
mov bp,ax

;----------------------------------------------------------------------
;13h  G   40x25  8x8   320x200  256/256K  1   A000  VGA,MCGA
;----------------------------------------------------------------------

xor ax,ax
mov al, 0x13  ; Definindo modo ded video
int 0x10


call whiteBack

call addFrase

call goToSecondStage


jmp $

;----------------------------------------------------------------------
;AH = 0Ch
;AL = Pixel color
;CX = Horizontal position of pixel
;DX = Vertical position of pixel
;BH = Display page number (graphics modes with more
;            than 1 page)
;----------------------------------------------------------------------

whiteBack:
push bp
mov bp,sp
pusha

xor cx,cx ;horizontal
mov dx,0x1c ;vertical em baixo da frase
mov ah,0x0c
mov al,0x0f
restart:
int 0x10
inc cx
cmp cx, 0x140
je zerarHorizontal
jmp restart

zerarHorizontal:
xor cx,cx
inc dx
cmp dx, 0xc8
je fim
jmp restart

fim:
popa
mov sp,bp
pop bp
ret

;----------------------------------------------------------------------
;AH    = 13h
;AL    = Subservice (0-3)
;BH    = Display page number
;BL    = Attribute (Subservices 0 and 1)
;CX    = Length of string
;DH    = Row position where string is to be written
;DL    = Column position where string is to be written
;ES:BP = Pointer to string to write
;----------------------------------------------------------------------

addFrase:
push bp
mov bp,sp
pusha

mov ah,0x13
mov al,0x01
xor bx,bx
mov bh,0x00
mov bl,0x0d
mov cx, 0x10
mov dh,0x10
mov dl,0x04
mov bp,mensagem
int 0x10 
 
popa
mov sp,bp
pop bp
ret

;----------------------------------------------------------------------

;AH    = 02h
;AL    = Number of sectors to read
;CH    = Cylinder number (10 bit value; upper 2 bits in CL)
;CL    = Starting sector number
;DH    = Head number
;DL    = Drive number
;ES:BX = Address of memory buffer

;----------------------------------------------------------------------

goToSecondStage:
mov ah,0x02
mov al, 3 ;number of sectors to read
mov ch, 0 ;Cylinder number
mov cl, 2 ;starting sector number,2 because 1 was already loaded in memory
mov dh, 0 ;head number
mov dl, [driveNumber]
mov bx, stage2
int 0x13
jmp stage2

;----------------------------------------------------------------------
;------------------------Stage1 Finish!--------------------------------
;----------------------------------------------------------------------


;----------------------------------------------------------------------
;------------------------Stage2 Started!-------------------------------
;----------------------------------------------------------------------

stage2:
call paint

final:
jmp $

;----------------------------------------------------------------------
;AH = 0Ch
;AL = Pixel color
;CX = Horizontal position of pixel
;DX = Vertical position of pixel
;BH = Display page number (graphics modes with more
;            than 1 page)
;----------------------------------------------------------------------
paint:
push bp
mov bp,sp
pusha

xor ax,ax
mov ds,ax
mov si,ax

push 0x0f ; color -> first == [sp + 6]  
push 0x00 ; X value -> second == [sp + 0x04]
push 0xc7 ; Y value -> third == [sp + 0x02]
push 0x00 ; reps -> fourth == [sp]

mov di,sp ;em 16bits,não é possivel fazer algumas operaçoes com sp e por isso usaremos outro registrador para guardar dados
mov bl, byte [0x7c00 + dados + si] ;repetiçoes	

inicio:
mov dx,[di + 0x02] ;Posiçao Vertical

backOne:
xor bh,bh
mov dx,[di + 0x04]
mov al, [di + 0x06]
mov ah, 0x0c
int 0x10
dec bl ; Diminui uma repetiçao
mov [di],bl ;salvando reps que falta 
cmp bl,0
je changeColor
volta2:
xor ax,ax 
mov ax, word[di + 0x04]
inc ax
cmp ax, 0x13f ;319
je prepararRetorno
mov [di + 0x04],ax
jmp backOne


changeColor:
mov al,[di + 0x06]
cmp al, 0x0f
je preto
mov al,0x0f
jmp salvar


preto: 
mov al,0x00
jmp salvar


salvar:
mov [di + 0x06],al
inc si
mov bl, byte [0x7c00 + dados + si]
cmp bl,0xff
je fim
mov [di],bl
jmp volta2


prepararRetorno:
xor ax,ax
mov [di + 0x04],ax ; X
mov ax, [di + 0x02] ; Y
dec ax
mov [di + 0x02], ax
inc si
mov bl, byte[0x7c00 + dados + si]
cmp bl, 0xff
je fim
jmp inicio


popa
mov sp,bp
pop bp
ret

dados: 	db 109,62,149,109,62,149,109,62,149,109,62,149,109,62,149,82,83,6,23,126,82,83,6,23,126,82,83,6,23,126,82,83,6
	db 23,126,82,83,6,23,126,63,102,6,23,126,63,102,6,23,126,63,102,6,23,126,63,102,6,23,126,63,102,6,23,126,54,43,6
	db 55,7,6,5,18,10,24,92,54,43,6,55,7,6,5,18,10,24,92,54,43,6,55,7,6,5,18,10,24,92,54,43,6,55,7,6,5,18,10,24,92,54
	db 43,6,55,7,6,5,18,10,24,92,54,43,6,55,7,6,5,18,10,24,92,54,43,12,49,7,29,10,19,5,4,88,54,43,12,49,7,29,10,19,5,4
	db 88,54,43,12,49,7,29,10,19,5,4,88,54,43,12,49,7,29,10,19,5,4,88,54,43,12,49,7,29,10,19,5,4,88,47,40,10,12,6,43,7
	db 73,82,47,40,10,12,6,43,7,73,82,47,40,10,12,6,43,7,73,82,47,40,10,12,6,43,7,73,82,47,40,10,12,6,43,7,73,82,58,16
	db 8,27,6,43,7,44,6,23,82,58,16,8,27,6,43,7,44,6,23,82,58,16,8,27,6,43,7,44,6,23,82,58,16,8,27,6,43,7,44,6,23,82,58
	db 16,8,27,6,43,7,44,6,23,82,58,57,5,38,7,39,5,29,82,58,57,5,38,7,39,5,29,82,58,57,5,38,7,39,5,29,82,58,57,5,38,7,39
	db 5,29,82,58,57,5,38,7,39,5,29,82,30,85,5,38,7,33,6,34,5,7,70,30,85,5,38,7,33,6,34,5,7,70,30,85,5,38,7,33,6,34,5,7,70
	db 30,85,5,38,7,33,6,34,5,7,70,30,85,5,38,7,33,6,34,5,7,70,25,169,4,40,5,7,70,25,169,4,40,5,7,70,25,169,4,40,5,7,70,25,169
	db 4,40,5,7,70,25,169,4,40,5,7,70,36,84,5,40,6,15,8,66,60,36,84,5,40,6,15,8,66,60,36,84,5,40,6,15,8,66,60,36,84,5,40,6,15,8
	db 66,60,25,11,11,73,5,118,7,15,55,25,11,11,73,5,118,7,15,55,25,11,11,73,5,118,7,15,55,25,11,11,73,5,118,7,15,55,25,11,11,73
	db 5,118,7,15,55,18,36,4,62,5,146,49,18,36,4,62,5,146,49,18,36,4,62,5,146,49,18,36,4,62,5,146,49,18,36,4,62,5,146,49,18,12,6
	db 22,5,57,5,125,6,22,42,18,12,6,22,5,57,5,125,6,22,42,18,12,6,22,5,57,5,125,6,22,42,18,12,6,22,5,57,5,125,6,22,42,18,12,6,22
	db 5,57,5,125,6,22,42,18,45,6,51,5,131,4,18,42,18,45,6,51,5,131,4,18,42,18,45,6,51,5,131,4,18,42,18,45,6,51,5,131,4,18,42,18,45
	db 6,51,5,131,4,18,42,30,230,60,30,230,60,30,230,60,30,230,60,30,230,60,41,28,5,135,6,41,4,18,42,41,28,5,135,6,41,4,18,42,41,28
	db 5,135,6,41,4,18,42,41,28,5,135,6,41,4,18,42,41,28,5,135,6,41,4,18,42,47,196,7,21,49,47,196,7,21,49,47,196,7,21,49,47,196,7,21
	db 49,58,16,8,100,4,18,5,29,5,17,60,58,16,8,100,4,18,5,29,5,17,60,58,16,8,100,4,18,5,29,5,17,60,58,16,8,100,4,18,5,29,5,17,60,58,16
	db 8,100,4,18,5,29,5,17,60,58,16,8,100,4,18,5,23,6,18,64,58,16,8,100,4,18,5,23,6,18,64,58,16,8,100,4,18,5,23,6,18,64,58,16,8,100,4,18
	db 5,23,6,18,64,63,165,4,18,70,63,165,4,18,70,63,165,4,18,70,63,165,4,18,70,63,165,4,18,70,63,180,77,63,180,77,63,180,77,63,180,77,63
	db 180,77,63,19,5,151,82,63,19,5,151,82,63,19,5,151,82,63,19,5,151,82,63,19,5,151,82,69,13,5,145,88,69,13,5,145,88,69,13,5,145,88,69,13
	db 5,145,88,69,13,5,145,88,69,13,5,16,17,23,9,71,97,69,13,5,16,17,23,9,71,97,69,13,5,16,17,23,9,71,97,69,13,5,16,17,23,9,71,97,69,13,5,16
	db 17,23,9,71,97,69,28,28,12,28,17,4,29,105,69,28,28,12,28,17,4,29,105,69,28,28,12,28,17,4,29,105,69,28,28,12,28,17,4,29,105,69,28,28,12
	db 28,17,4,29,105,69,28,28,12,28,17,4,23,111,69,28,28,12,28,17,4,23,111,69,28,28,12,28,17,4,23,111,69,28,28,12,28,17,4,23,111,69,28,28,12
	db 28,17,4,23,111,69,34,17,17,21,46,116,69,34,17,17,21,46,116,69,34,17,17,21,46,116,69,34,17,17,21,46,116,69,34,17,17,21,46,116,74,124,122
	db 74,124,122,74,124,122,74,124,122,74,124,122,82,112,126,82,112,126,82,112,126,82,112,126,82,112,126,87,99,134,87,99,134,87,99,134,87,99
	db 134,87,99,134,87,99,134,97,79,144,97,79,144,97,79,144,97,79,144,97,79,144,115,43,162,115,43,162,115,43,162,115,43,255

;Variaveis
mensagem: db 'Me contrata! \o/'

dw 0xAA55