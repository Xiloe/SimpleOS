;;;
;;; bootSector.asm: Simple BootLoader that uses 0x13 interupt with ah=2
;;; https://wiki.osdev.org/Boot_Sequence
;;; https://en.wikipedia.org/wiki/BIOS_interrupt_call#Interrupt_table
;;;

        org 0x7C00              ; 'origin' of Boot code; helps make sure addresses don't change

        ;; load filetable
        ;; set up ES:BX address/segment:offset to load sector(s) into
        mov bx, 0x1000          ; load sector to memory address 0x1000
        mov es, bx              ; ES = 0x1000
        mov bx, 0               ; ES:BX = 0x1000:0

        mov dh, 0x01            ; we want to read 1 sector
        mov dl, 0x02            ; we want sector 2
        call disk_load

        ;; load kernel
        mov bx, 0x2000          ; load sector to memory address 0x2000
        mov es, bx              ; ES = 0x2000
        mov bx, 0               ; ES:BX = 0x2000:0

        mov dh, 0x01            ; we want to read 1 sector
        mov dl, 0x03            ; we want sector 3
        call disk_load

        ;; reset segment registers for RAM ; reset them to avoid garbage when in kernel
        mov ax, 0x2000
        mov ds, ax              ; data segment
        mov es, ax              ; extra segment
        mov fs, ax              ; ""
        mov gs, ax              ; ""
        mov ss, ax              ; stack segment
        
        jmp 0x2000:0            ; never return from this! 

        ;; Include files
        include "disk_load.asm"

        ;; Boot Sector magic
        times 510-($-$$) db 0   ; fills out 0s until we reach 510th byte
        dw 0xAA55               ; boot magic number
