;;; =================================================================================================================================================
;;; print_hex: Prints hexadecimal values using register DX and print_string.asm
;;; =================================================================================================================================================
;;; Ascii '0'-'9' = hex 0x30-0x39
;;; Ascii 'A'-'F' = hex 0x41-0x46
;;; Ascii 'a'-'f' = hex 0x61-0x66
;;; =================================================================================================================================================

print_hex:
        pusha                       ; save all registers to the stack
        mov cx, 0                   ; init loop counter

        ;; ------------------------------------------------------------------------------------------------------------------------------------------
        ;; Convert DX hex values to ascii
        ;; here we simply check if the digit is <=0x39 or >0x39
        ;; if it is inferior or equal it is already an ascii number 0-9 since we added 0x30 to it
        ;; if it is superior it is an ascii letter A-F we have to add 0x7 to get the right ascii number
        ;; ------------------------------------------------------------------------------------------------------------------------------------------
hex_loop:
        cmp cx, 4                   ; are we at end of loop? ; for 1 - 4
        je end_hexloop

        mov ax, dx                  ; save dx to ax and work with ax
        and ax, 0x000F              ; turn 1st 3 hex to 0, keep final digit to convert ; 0xABCD -> 0x000D
        add al, 0x30                ; get ascii number or letter value
        cmp al, 0x39                ; is hex value 0-9 (<=0x39) or A-F (> 0x39)
        jle mov_intoSI
        add al, 0x7                 ; to get ascii 'A'-'F'

        ;; ------------------------------------------------------------------------------------------------------------------------------------------
        ;; Move ascii characters to SI register
        ;; ------------------------------------------------------------------------------------------------------------------------------------------
mov_intoSI:
        mov si, hexString + 5       ; base address of hexString + length of string
        sub si, cx                  ; substract loop counter
        mov [si], al
        ror dx, 4                   ; rotate right by 4 bits ; 0xABCD -> 0xDABC

        inc cx                      ; increment counter
        jmp hex_loop                ; loop for next hex digit in DX

end_hexloop:
        mov si, hexString
        call print_string

        popa                        ; restore all registers from the stack
        ret                         ; return to caller

        ;; ------------------------------------------------------------------------------------------------------------------------------------------
        ;; Data
        ;; ------------------------------------------------------------------------------------------------------------------------------------------
hexString:      db "0x0000", 0