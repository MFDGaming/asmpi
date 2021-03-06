section .data
	asmpi db "    _    ____  __  __ ____  _ ", 0x0a, "   / \  / ___||  \/  |  _ \(_)", 0x0a, "  / _ \ \___ \| |\/| | |_) | |", 0x0a, " / ___ \ ___) | |  | |  __/| |", 0x0a, "/_/   \_\____/|_|  |_|_|   |_|", 0x0a, 0x0a
	asmpi_len equ $ - asmpi
	strtmsg db "Starting ASMPi...", 0x0a
	strtmsg_len equ $ - strtmsg
	donemsg db "Done. Type help to view all available commands.", 0x0a
	donemsg_len equ $ - donemsg
	imh db 0x1b, "[0;33m", "[", 0x1b, "[0;1;32m", "INFO", 0x1b, "[0;33m", "]", 0x1b, "[0;1;35m", " > ", 0x1b, "[0m"
	imh_len equ $ - imh
	helpmsg db "----- HELP: ----", 0x0a, "stop: shuts down the server", 0x0a, "help: views all available commands", 0x0a
	helpmsg_len equ $ - helpmsg
	cmdstop db "stop", 0x0a
	cmdhelp db "help", 0x0a
	stpmsg1 db "Stopping Server...", 0x0a
	stpmsg1_len equ $ - stpmsg1
	stpmsg2 db "Server stopped.", 0x0a
	stpmsg2_len equ $ - stpmsg2

section .bss
	usrin resb 16
	socket resb 16
	

section .text
	global _start

_stdnonblock:
	mov eax, 55
	mov ebx, 0
	mov ecx, 4
	mov edx, 2048
	int 0x80
	ret
	
_stdblock:
	mov eax, 55
	mov ebx, 0
	mov ecx, 4
	mov edx, -2049
	int 0x80
	ret

_socket:
	mov eax, 359
	mov ebx, 2
	mov ecx, 2
	mov edx, 17
	int 0x80
	mov eax, socket

_exit:
	mov eax, 1               ; syscall exit
	mov ebx, 0               ; exit type
	int 0x80                 ; execute sys call

_printinfo:
	mov ecx, imh             ; define output
	mov edx, imh_len         ; define output length
	call _print
	ret

_print:
	mov eax, 4               ; syscall write
	mov ebx, 1               ; stdout
	int 0x80                 ; execute sys call
	ret

_stop:
	call _printinfo
	mov ecx, stpmsg1         ; define output
	mov edx, stpmsg1_len     ; define output length
	call _print
	call _printinfo
	mov ecx, stpmsg2         ; define output
	mov edx, stpmsg2_len     ; define output length
	call _print
	call _exit

_help:
	call _printinfo
	mov ecx, helpmsg         ; define output
	mov edx, helpmsg_len     ; define output length
	call _print

_mainloop:
	;call _stdnonblock
	mov eax, 3               ; syscall read
	mov ebx, 0               ; stdin
	mov ecx, usrin           ; define output
	mov edx, 16              ; define output length
	int 0x80                 ; execute sys call
	;call _stdblock
	mov eax, [cmdstop]
	mov ebx, [usrin]
	cmp eax, ebx
	mov eax, 0
	mov eax, usrin
	je _stop
	mov eax, [cmdhelp]
	mov ebx, [usrin]
	cmp eax, ebx
	mov eax, 0
	mov eax, usrin
	je _help
	mov eax, 0
	mov eax, usrin
	jmp _mainloop            ; loop for ever

_start:
	mov ecx, asmpi           ; define output
	mov edx, asmpi_len       ; define output length
	call _print

	call _printinfo
	mov ecx, strtmsg         ; define output
	mov edx, strtmsg_len     ; define output length
	call _print
	
	call _printinfo
	mov ecx, donemsg         ; define output
	mov edx, donemsg_len     ; define output length
	call _print

	call _mainloop

	call _exit
