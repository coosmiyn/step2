; Real-Mode Part of the Boot Loader
;
; When the PC starts, the processor is essentially emulating an 8086 processor, i.e. 
; a 16-bit processor.  So our initial boot loader code is 16-bit code that will 
; eventually switch the processor into 32-bit mode.

BITS 16

; Tell the assembler that we will be loaded at 7C00 (That's where the BIOS loads boot loader code).
ORG 7C00h

start:
	jmp 	Real_Mode_Start				; Jump past our sub-routines]
	
%include "functions_16.asm"
%include "a20.asm"

;	Start of the actual boot loader code

	
Real_Mode_Start:
    xor 	ax, ax						; Set stack segment (SS) to 0 and set stack size to top of segment
    mov 	ss, ax
    mov 	sp, 0FFFFh

    mov 	ds, ax						; Set data segment registers (DS and ES) to 0.
	mov		es, ax	

	mov 	si, boot_message
	call 	Console_WriteLine_16		

    call Test_A20_Enabled
    cmp     ax, 1
    jne     Failed   

    mov     si, success
    call    Console_WriteLine_16

    jmp     9000h

    hlt

Failed:
    mov     si, boot_message
    call    Console_WriteLine_16


    
boot_message:		db	'Boooom!', 0
success:            db  'Success', 0