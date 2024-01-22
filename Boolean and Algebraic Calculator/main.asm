; include lib\Irvine32.inc

.386
.model flat, stdcall
.stack 4096

ExitProcess PROTO, dwExitCode:DWORD
	
INCLUDE Irvine32.inc

.data
	msgMenu BYTE "---- Boolean Calculator ----------", 0dh, 0ah
	BYTE 0dh, 0ah
	BYTE "1. x AND y", 0dh, 0ah
	BYTE "2. x OR y", 0dh, 0ah
	BYTE "3. NOT x", 0dh, 0ah
	BYTE "4. NOT y", 0dh, 0ah
	BYTE "5. x XOR y", 0dh, 0ah
	BYTE "6. x XOR y XOR x", 0dh, 0ah
	BYTE "7. x XOR y XOR y", 0dh, 0ah
	BYTE "8. x + y", 0dh, 0ah
	BYTE "9. x - y", 0dh, 0ah
	BYTE "0. Exit program", 0dh, 0ah, 0dh, 0ah

	BYTE "Enter integer > ", 0

	msgAND BYTE "Boolean AND:", 0
	msgOR  BYTE "Boolean OR:", 0
	msgNOT BYTE "Boolean NOT:", 0
	msgXOR BYTE "Boolean XOR:", 0
	msgXORX BYTE "Boolean X XOR Y XOR X:", 0
	msgXORY BYTE "Boolean X XOR Y XOR Y:", 0
	msgADD BYTE "Hexadecimal Addition:", 0
	msgSUB BYTE "Hexadecimal Subtraction:", 0

	msgOperand1 BYTE "Input the first 32-bit hexadecimal operand:  ", 0
	msgOperand2 BYTE "Input the second 32-bit hexadecimal operand: ", 0
	msgOperand3 BYTE "Input a 32-bit hexadecimal operand: ", 0 ; for single-input commands
	msgResult   BYTE "The 32-bit hexadecimal result is:            ", 0

	caseTable BYTE '1'	;// lookup value
		DWORD AND_op	;// address of procedure
	EntrySize = ($ - caseTable)
	BYTE '2'
		DWORD OR_op
	BYTE '3'
		DWORD NOT_op
	BYTE '4'
		DWORD NOT_op
	BYTE '5'
		DWORD XOR_op
	BYTE '6'
		DWORD XORX_op
	BYTE '7'
		DWORD XORY_op
	BYTE '8'
		DWORD ADD_op
	BYTE '9'
		DWORD SUB_op
	BYTE '0'
		DWORD ExitProgram
	NumberOfEntries = ($ - caseTable) / EntrySize

.code
main PROC
	call Clrscr

Menu:
	mov	EDX, OFFSET msgMenu	;// menu choices
	call WriteString

L1: call ReadChar
	cmp  al, '9'	;// is selection valid (1 - 9) ?
		ja   L1			;// if above 9, go back

	cmp  al, '0'
		jb   L1			;// if below 0, go back

	call Crlf
	call ChooseProcedure
	jc   quit		;// if CF = 1 exit

	call Crlf
	jmp  Menu		;// display menu again

quit :
exit
main ENDP

ChooseProcedure PROC

	push EBX
	push ECX

	mov  EBX, OFFSET caseTable	;// pointer to the table
	mov  ECX, NumberOfEntries	;// loop counter

L1 : cmp  al, [EBX]				;// match found ?
	jne  L2						;// no: continue
	call NEAR PTR[EBX + 1]		;// yes: call the procedure
	jmp  L3

L2 : add  EBX, EntrySize;// point to the next entry
	loop L1;// repeat until ECX = 0

L3:	pop  ECX
	pop  EBX

ret
ChooseProcedure ENDP

AND_op PROC
	pushad;// save registers

	mov	EDX, OFFSET msgAND;// name of the operation
	call WriteString;// display message
	call Crlf
	call Crlf

	mov  EDX, OFFSET msgOperand1;// ask for first operand
	call WriteString
	call ReadHex;// get hexadecimal integer
	mov  EBX, EAX;// move first operand to EBX

	mov  EDX, OFFSET msgOperand2;// ask for second operand
	call WriteString
	call ReadHex;// EAX = second operand

	and EAX, EBX;// operand1 AND operand2

	mov  EDX, OFFSET msgResult;// result of operation
	call WriteString
	call WriteHex;// EAX = result
	call Crlf

	popad;// restore registers
	ret
AND_op ENDP

OR_op PROC
	pushad;// save registers

	mov	EDX, OFFSET msgOR;// name of the operation
	call WriteString;// display message
	call Crlf
	call Crlf

	mov  EDX, OFFSET msgOperand1;// ask for first operand
	call WriteString
	call ReadHex;// get hexadecimal integer
	mov  EBX, EAX;// move first operand to EBX

	mov  EDX, OFFSET msgOperand2;// ask for second operand
	call WriteString
	call ReadHex;// EAX = second operand

	or EAX, EBX;// operand1 OR operand2

	mov  EDX, OFFSET msgResult;// result of operation
	call WriteString
	call WriteHex;// EAX = result
	call Crlf

	popad;// restore registers
	ret
OR_op ENDP

NOT_op PROC
	pushad;// save registers

	mov	EDX, OFFSET msgNOT;// name of the operation
	call WriteString;// display message
	call Crlf
	call Crlf

	mov  EDX, OFFSET msgOperand3;// ask for single operand
	call WriteString
	call ReadHex;// get hexadecimal integer

	not EAX
	and EAX, 0FFh	; only includes LSB

	mov  EDX, OFFSET msgResult;// result of operation
	call WriteString
	call WriteHex;// EAX = result
	call Crlf

	popad;// restore registers
	ret
NOT_op ENDP

XOR_op PROC
	pushad;// save registers

	mov	EDX, OFFSET msgXOR;// name of the operation
	call WriteString;// display message
	call Crlf
	call Crlf

	mov  EDX, OFFSET msgOperand1;// ask for first operand
	call WriteString
	call ReadHex;// get hexadecimal integer
	mov  EBX, EAX;// move first operand to EBX

	mov  EDX, OFFSET msgOperand2;// ask for second operand
	call WriteString
	call ReadHex;// EAX = second operand

	xor EAX, EBX;// operand1 OR operand2

	mov  EDX, OFFSET msgResult;// result of operation
	call WriteString
	call WriteHex;// EAX = result
	call Crlf

	popad;// restore registers
	ret
XOR_op ENDP

XORX_op PROC
	pushad;// save registers

	mov	EDX, OFFSET msgXORX;// name of the operation
	call WriteString;// display message
	call Crlf
	call Crlf

	mov  EDX, OFFSET msgOperand1;// ask for first operand
	call WriteString
	call ReadHex;// get hexadecimal integer
	mov  EBX, EAX;// move first operand to EBX

	mov  EDX, OFFSET msgOperand2;// ask for second operand
	call WriteString
	call ReadHex;// EAX = second operand

	; X XOR Y XOR X will always end up as Y

	mov  EDX, OFFSET msgResult;// result of operation
	call WriteString
	call WriteHex;// EAX = result
	call Crlf

	popad;// restore registers
	ret
XORX_op ENDP

XORY_op PROC
	pushad;// save registers

	mov	EDX, OFFSET msgXORY;// name of the operation
	call WriteString;// display message
	call Crlf
	call Crlf

	mov  EDX, OFFSET msgOperand1;// ask for first operand
	call WriteString
	call ReadHex;// get hexadecimal integer
	mov  EBX, EAX;// move first operand to EBX

	mov  EDX, OFFSET msgOperand2;// ask for second operand
	call WriteString
	call ReadHex;// EAX = second operand

	; X XOR Y XOR Y will always end up as X
	mov EAX, EBX

	mov  EDX, OFFSET msgResult;// result of operation
	call WriteString
	call WriteHex;// EAX = result
	call Crlf

	popad;// restore registers
	ret
XORY_op ENDP

ADD_op PROC
	pushad;// save registers

	mov	EDX, OFFSET msgADD;// name of the operation
	call WriteString;// display message
	call Crlf
	call Crlf

	mov  EDX, OFFSET msgOperand1;// ask for first operand
	call WriteString
	call ReadHex;// get hexadecimal integer
	mov  EBX, EAX;// move first operand to EBX

	mov  EDX, OFFSET msgOperand2;// ask for second operand
	call WriteString
	call ReadHex;// EAX = second operand

	add EAX, EBX;// operand1 + operand2

	mov  EDX, OFFSET msgResult;// result of operation
	call WriteString
	call WriteHex;// EAX = result
	call Crlf

	popad;// restore registers
	ret
ADD_op ENDP

SUB_op PROC
	pushad;// save registers

	mov	EDX, OFFSET msgSUB;// name of the operation
	call WriteString;// display message
	call Crlf
	call Crlf

	mov  EDX, OFFSET msgOperand1;// ask for first operand
	call WriteString
	call ReadHex;// get hexadecimal integer
	mov  EBX, EAX;// move first operand to EBX

	mov  EDX, OFFSET msgOperand2;// ask for second operand
	call WriteString
	call ReadHex;// EAX = second operand

	sub EAX, EBX	; for some reason this does op2 - op1
	imul EAX, -1	; answer comes out backwards, so this fixes it

	mov  EDX, OFFSET msgResult;// result of operation
	call WriteString
	call WriteHex;// EAX = result
	call Crlf

	popad;// restore registers
	ret
SUB_op ENDP

ExitProgram PROC
	stc ;// CF = 1
	ret
ExitProgram ENDP

END main