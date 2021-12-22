mov ah, 0x0e ; teletype mode (to print on screen)
mov al, 'A' ; moving char 'A' in al register
int 0x10 ; BIOS interupt to print on screen (print value in al)

loop:
    add al, 1
    int 0x10

    cmp al, 'Z' ; compare al with 'Z'
    jne loop


mov al, 10 ; endl
int 0x10
mov al, 'A'
int 0x10
mov al, 'M'
int 0x10
mov al, 'O'
int 0x10
mov al, 'G'
int 0x10
mov al, ' '
int 0x10
mov al, 'O'
int 0x10
mov al, 'S'
int 0x10

; basic 512 boot sector

jmp $
times 510-($-$$) db 0
db 0x55, 0xaa