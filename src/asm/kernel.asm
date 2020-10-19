;;;
;;; kernel.asm: Simple Kernel loaded from our bootloader/bootsector
;;;

        ;; Sets video mode
        mov ah, 0x00            ; Video mode interupt
        mov al, 0x03            ; 80x25, textmode, coloured
        int 0x10                ; calls BIOS video service

        ;; sets border color/palete
        mov ah, 0x0B            ; ah/0B border color
        mov bh, 0x00            ; bh set background / border color
        mov bl, 0x01            ; bl set color blue
        int 0x10

        ;; Print Screen Heading and Menu options
        mov si, welcomeString
        call print_string

        ;; Get user inputs, print to screen & run command
get_input:
        mov di, commandString   ; di now pointing to commandString

keyloop:
        mov ah, 0x00            ; Get user input ah=00h
        int 0x16                ; BIOS Keyboard service

        mov ah, 0x0E            ; TTY output
        cmp al, 0xD             ; did user press 'enter' key ?
        je run_command          ; run the command
        int 0x10                ; BIOS Video service write screen
        mov [di], al            ; store input character to string
        inc di                  ; go to next byte at di/commandString
        jmp keyloop             ; loop for next characters

run_command:
        mov byte [di], 0        ; null terminate commandString from di
        mov al, [commandString]
        cmp al, "R"             ; 'warm' reboot
        je reboot
        cmp al, "E"             ; e(n)d our current program
        je end_program
        mov si, failure         ; command found
        call print_string 
        jmp get_input

reboot:
        jmp 0xFFFF:0x0000

end_program:
        ;; End prgm
        cli                     ; clear interrupts
        hlt                     ; halt the cpu

        ;; Included files
        include "../print/print_string.asm"
        include "../print/print_hex.asm"

        ;; Data
welcomeString:  db "-----------------------------------", 0xA, 0xD,\
                "Kernel Booted, Welcome to SimpleOS!", 0xA, 0xD,\
                "-----------------------------------", 0xA, 0xD, 0xA, 0xD,\
                "F) File Table", 0xA, 0xD,\
                "R) Reboot", 0xA, 0xD, 0xA, 0xD, 0
failure:        db 0xA, 0xD,"Command not found!", 0xA, 0xD, 0
commandString:  db ""

        ;; Sector padding magic
        times 512-($-$$) db 0   ; fills out 0s until we reach 512th byte