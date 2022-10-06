;-------------------------------------------------------------------;
TITLE Assignment 1: Lucas sequence Final (3/3)    (Assig1.asm)		;
;-------------------------------------------------------------------;
; Name:		Slim Babay												;
; Student:	0275404													;
;-------------------------------------------------------------------;
;Instructor:    Dr. Frank Allaire									;
;Course: Computer Science 2476-WA-2014								;
;-------------------------------------------------------------------;


INCLUDE Irvine32.inc

.data
seqCount = 240
L1 DWORD 5 dup(0)
L2 DWORD 5 dup(0)
DecCopy BYTE 16 dup("0"),0
TooBig BYTE "*Integer too big",0
ScratchPad DWORD 12 dup(0)

.code
main PROC

	mov L1[0], 1
	mov L2[0], 3
	mov ecx, SeqCount
	JMP Sequence

	First::
		push ecx
		mov edx, ecx
		mov esi, OFFSET L1
		mov ecx, SIZEOF L1
		call DisplayNum
		mov edi, OFFSET DecCopy
		call DisplayDec
		call DoubleDabble
		call crlf
		pop ecx
		dec ecx

	Sequence::
		CMP ecx, SeqCount
		JZ First
		JA Done
		push ecx
		mov edx, ecx
		mov esi, OFFSET L2
		mov ecx, SIZEOF L2
		call DisplayNum 
		mov edi, OFFSET DecCopy
		call DisplayDec
		call DoubleDabble
		call crlf
		pop ecx
	
		CMP ecx,1 ; Displays one ahead
		JZ Done

		push ecx
		mov	esi, OFFSET L1
		mov	edi, OFFSET L2
		mov ecx, SIZEOF L2
		Call Adder
		pop ecx
		loop Sequence

	Done::
	exit
main ENDP

DisplayNum PROC
	pushad
	mov eax, seqCount
	sub eax, edx
	inc eax
	call writeDec
	
	add esi,ecx
	sub esi,TYPE BYTE
	mov ebx,TYPE BYTE
	

	Spacer::
		mov eax, ' '
		call writeChar
		
		mov al,[esi]
		mov ebx, TYPE BYTE
		call WriteHexB
		sub esi,TYPE BYTE
		dec ecx

	HexBytes:
		mov eax, ecx
		mov bx, 4
		div bl
		cmp ah, 0
		jz Spacer


		mov eax, 0
		mov al,[esi]
		mov ebx, TYPE BYTE
		call WriteHexB
		sub esi,TYPE BYTE
		loop hexBytes
	popad
	ret
DisplayNum EndP


DisplayDec PROC
	pushad
		
	mov eax, ' '
	call writeChar
		
	mov eax,DWORD PTR [esi]
	mov edx,DWORD PTR [esi+4]
	
	cmp edx, 9
	JA Int2Big
	
	dec edi
	mov ecx, 16
	
	Lprint:
		mov ebx, 10
		div ebx
		or dl, 30h
		mov ebx, edi
		add ebx, ecx
		mov [ebx], dl
		mov edx, 0
		loop Lprint

	inc edi
	mov edx, edi
	
	WriteQuit:
	call WriteString

	popad
	ret
	
	Int2Big:
		mov edx, OFFSET TooBig
		JMP WriteQuit
DisplayDec ENDP

DoubleDabble PROC
	pushad

	call crlf
	mov edi, OFFSET ScratchPad
	mov ecx, 5
	Setup1: ; moves hex number into scratch pad
		mov eax, DWORD PTR [esi]
		mov [edi], eax
		add esi, TYPE DWORD
		add edi, TYPE DWORD
		loop setup1
	mov ecx, 7
	Setup2:
		mov eax, 0
		mov [edi], eax
		add edi, TYPE DWORD
		loop Setup2
	mov ecx, 160 ;5 DWORDS x 8 bits/byte  x 4 Bytes/DWORD
	
	Shifter:
		clc
		push ecx
		mov edi, OFFSET ScratchPad
		mov ecx, 12 ;
		ShiftLoop:
			RCL DWORD PTR [edi],1
			pushfd
			add edi, 4
			popfd
			loop Shiftloop
		RCL DWORD PTR [edi],1
			
		CheckNibbles:
			mov ecx, 28 ; each byte in the 7 dwords [7*4=21]
			clc
			Nibbleloop:
				mov edi, OFFSET ScratchPad
				add edi, 48 ; last 5 dwords place holder for hex number
				sub edi, ecx
				movzx eax, BYTE PTR [edi]
				mov ebx, eax
				AND al, 0Fh
				cmp al, 4
				JA addlow
			checkhigh:
				mov al, bl
				AND al, 0F0h
				cmp al, 40h
				JA addhigh
			checknext:
				mov [edi], bl
				loop Nibbleloop
		pop ecx
		loop Shifter
	clc

		mov ecx, 28 
		fixer: ; i know this is bad coding practice, but couldnt find a way to control the previous loop
			mov edi, OFFSET ScratchPad
			add edi, 48
			sub edi, ecx
			movzx eax, BYTE PTR [edi]
				mov ebx, eax
				AND al, 0Fh
				cmp al, 8
				JAE fixlow
			hightoohigh:
				mov al, bl
				AND al, 0F0h
				cmp al, 80h
				JAE fixhigh
			itsdone:
				mov [edi], bl
				loop fixer
	
	mov ecx, 7
	printit:
		mov edi, OFFSET ScratchPad
		add edi, 20	
		mov eax, ecx
		dec eax
		mov ebx, 4
		mul bl
		add edi, eax
		mov eax, DWORD PTR [edi]
		call WriteHex
		loop printit
	popad
	ret

	Addlow:
		clc
		add bl, 3h
		JMP checkhigh
	Addhigh:
		add bl, 30h
		JMP checknext
	fixlow:
		clc
		sub bl, 3h
		JMP hightoohigh
	fixhigh:
		sub bl, 30h
		JMP itsdone


DoubleDabble ENDP


Adder PROC
	pushad
	clc

	ByteLoop:
		mov	al,[esi] ;L1
		adc	al,[edi] ;L2
		pushfd
		
		mov bl, [edi]
		mov [esi], bl ; new L1
		mov [edi], al ; new L2
		
		inc esi ; next byte
		inc edi
		popfd
		loop ByteLoop

	;mov	byte ptr [edi],0
	adc	byte ptr [edi],0
	popad
	ret
Adder ENDP
END main
