;;;
;;; fileTable.asm: 
;;;
        ;; sector padding magic
        times 512-($-$$) db 0       ; pad rest of the file to 0s till 512th byte/end of sector