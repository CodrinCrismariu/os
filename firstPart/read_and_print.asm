[org 0x7c00]

jmp start

READ_ERROR:
    db "Reading error encountered, get fucked", 0

OK:
    db "OK", 0

buffer:
    times 100 db 0

BOOT_DISK:
    db 0

ReadString:
    rloop:
        ; read 
        mov ah, 0x00
        int 0x16

        ; if enter jump to end
        cmp al, 0x0d
        je rend

        ; print
        mov ah, 0x0e
        int 0x10

        mov [bx], al
        inc bx

        jmp rloop
    
    rend:
        mov ah, 0x0e
        mov al, 0x0a
        int 0x10
        
        mov al, 0x0d
        int 0x10

        mov al, 0
        mov [bx], al
        mov bx, buffer

        ret

PrintString:
    mov ah, 0x0e ; tty mode

    prloop:
        mov al, [bx]
        cmp al, 0
        je prend

        int 0x10
        inc bx
        jmp prloop

    prend:
        ret

ReadDrive:
    xor ax, ax                          
    mov es, ax
    mov ds, ax
    mov bp, 0x8000
    mov sp, bp

    mov bx, 0x7e00

    mov ah, 2
    mov al, 1
    mov ch, 0
    mov dh, 0
    mov cl, 2
    mov dl, [BOOT_DISK]
    int 0x13

    jnc endRead
    mov bx, READ_ERROR
    call PrintString

    jmp ReadDrive

endRead:
    mov ah, 0x0e
    mov al, [0x7e00]
    int 0x10

    ret

start:

mov [BOOT_DISK], dl ; set diskNum to boot disk

call ReadDrive

jmp $
times 510-($-$$) db 0
db 0x55, 0xaa

times 512 db 'A'