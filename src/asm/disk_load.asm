;;;
;;; disk_load.asm: Read DH sectors into ES:BX memory location from drive DL
;;; https://stanislavs.org/helppc/int_13-2.html
;;;

disk_load:
        push dx                 ; store DX on the stack so we can check number of sectors actually read later
        mov ah, 0x02            ; int 13/ah=02h, BIOS read disk sectors in memory
        mov al, dh              ; number of sectors we want to read ex. 1
        
        ;; Setup disk read
        mov cl, dl              ; starting sector to read from disk
        mov dh, 0x00            ; head 0
        mov dl, 0x00            ; drive 0
        mov ch, 0x00            ; cylinder 0
        
        int 0x13                ; BIOS interrupts for low level disk services

        jc disk_error           ; jump if disk read error (carry flag set/= 1)

        pop dx                  ; restore DX from the stack
        cmp dh, al              ; if AL(# of sectors actually read) != DH(sectors we wanted to read)
        jne disk_error          ; error, sectors read not equal to sectors we wanted to read
        ret

        include "../print/print_string.asm"

disk_error:
    mov si, DISK_ERROR_MESSAGE
    call print_string
    hlt                         ; halt the cpu (https://fr.wikipedia.org/wiki/HLT_(instruction))

DISK_ERROR_MESSAGE:     db "Disk read error!", 0