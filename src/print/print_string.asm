;;;
;;; print_string: Prints character strings in SI register
;;;

print_string:
        pusha                   ; store all register values onto the stack
        mov ah, 0x0e            ; ah 0xOe BIOS teletype output
        mov bh, 0x0             ; page number
        mov bl, 0x07            ; color

print_char:
        mov al, [si]            ; move character value to address in si into al
        cmp al, 0               ; compare al to 0
        je end_print            ; jump if equal (al == 0)
        int 0x10                ; print character stored in al
        inc si                  ; move 1 byte forward ; get next character
        jmp print_char          ; loop

end_print:
        popa                    ; restore registers from the stack before returning
        ret                     ; return to caller