format ELF64 executable 3
link = 0

macro prim ident, name, len, flag=0 {
	link__#ident:
		dq link
		link = link__#ident
		db flag, len, name
		align 8
	ident:
		dq prim__#ident
}

macro forth ident, name, len, flag=0 {
	link__#ident:
		dq link
		link = link__#ident
		db flag, len, name
		align 8
		dq docol
}

flag.hidden       equ 10000000b ; hidden word, not visible to the compiler or interpreter
flag.immed        equ 01000000b ; compile-time word, runs during compilation
flag.compile_only equ 00100000b ; compile-only word, it's an error to run this in the interpreter
flag.inline       equ 00010000b ; [code 0] inlinable word, definition inlined instead of referenced
;flag.????        equ 00010000b ; [code 1] undefined
flag.pure         equ 00001000b ; pure word, may transformed via algebraic properties
flag.code         equ 00000100b ; code word, routine in assembly
;flag.????        equ 00000010b ; undefined
;flag.????        equ 00000001b ; undefined

sys.exit  equ 60
sys.read  equ 0
sys.write equ 1
sys.open  equ 2
sys.close equ 3
sys.brk   equ 12

;;
segment readable executable

entry main

;; r15 IP
;; r14 UP
;; r13
;; r12
;; rbp PSP
;; rsi RSP
;; rbx TOS
;; rax X

main:
	cld
	mov [var.s0], rsp

  xor rbx, rbx
  mov rax, sys.brk
  syscall
  mov r14, rax
  add rax, 0xffff
  mov rbx, rax
  mov rax, sys.brk
  syscall

	xor rbx, rbx
	mov r15, int.entry
	mov rbp, rsp
	jmp next

docol:
	push r15                             ; push current position to rstack
	add r15, 8
next:
	mov rax, [r15]                       ; move pointer of word to TMP
	add r15, 8                           ; advance instruction pointer
	jmp qword [rax]                      ; jump to code word

prim__exit:
	pop r15                              ; pop address from rstack
	jmp next                             ; next (jump to it)

prim__bye:
	mov rdi, rbx
	mov rax, sys.exit
	syscall

prim__nip:
	sub rbp, 8                           ; decrement stack pointer
	jmp next                             ; next

prim__noop:
	jmp next

prim__lit:
	add rbp, 8
	mov [rbp], rbx                       ; copy TOS to 2nd parameter
	mov rbx, [r15]
	add r15, 8
	jmp next

prim__swap:
	mov rax, [rbp]                       ; move 2nd parameter to TMP
	mov [rbp], rbx                       ; move TOS to 2nd parameter
	mov rbx, rax                         ; move tmp to TOS
	jmp next                             ; next

prim__drop:
	mov rbx, [rbp]                       ; move 2nd parameter to TOS
	sub rbp, 8                           ; decrement stack pointer
	jmp next                             ; next

prim__dup_:
	add rbp, 8                           ; increment stack pointer
	mov [rbp], rbx                       ; copy TOS to 2nd parameter
	jmp next                             ; next

prim__over:
	mov rax, [rbp]                       ; copy 2nd parameter to TMP
	add rbp, 8                           ; increment stack pointer
	mov [rbp], rbx                       ; copy TOS to 2nd parameter
	mov rbx, rax                         ; move TMP to TOS
	jmp next                             ; next

prim__one_plus:
	inc rbx                              ; increment TOS
	jmp next                             ; next

prim__one_minus:
	dec rbx                              ; decrement TOS
	jmp next                             ; next

prim__two_plus:
	add rbx, 2                           ; increment TOS by 2
	jmp next                             ; next

prim__two_minus:
	sub rbx, 2                           ; decrement TOS by 2
	jmp next                             ; next

prim__four_plus:
	add rbx, 4                           ; increment TOS by 4
	jmp next                             ; next

prim__four_minus:
	sub rbx, 4                           ; decrement TOS by 4
	jmp next                             ; next

prim__eight_plus:
	add rbx, 8                           ; increment TOS by 8
	jmp next                             ; next

prim__eight_minus:
	sub rbx, 8                           ; decrement TOS by 8
	jmp next                             ; next

prim__two_star:
	sal rbx, 1                           ;
	jmp next                             ; next

prim__two_slash:
	sar rbx, 1                           ;
	jmp next                             ; next

prim__four_star:
	sal rbx, 2                           ;
	jmp next                             ; next

prim__four_slash:
	sar rbx, 2                           ;
	jmp next                             ; next

prim__negate:
	neg rbx                              ;
	jmp next                             ; next

prim__plus:
	add rbx, [rbp]                       ;
	sub rbp, 8                           ;
	jmp next                             ; next

prim__minus:
	sub [rbp], rbx
	mov rbx, [rbp]                       ; move 2nd parameter to TOS
	sub rbp, 8                           ; decrement stack pointer
	jmp next                             ; next

prim__star:
	imul rbx, [rbp]                      ; multiply TOS by 2nd parameter
	sub rbp, 8                           ; decrement stack pointer
	jmp next                             ; next

prim__slash_mod:
	xor rdx, rdx
	mov rax, [rbp]
	idiv rbx
	mov rbx, rax
	mov [rbp], rdx
	jmp next                             ; next

prim__star_slash:
	sub rbp, 8
	mov rax, [rbp+8]
	imul qword [rbp+8]
	idiv rbx
	mov rbx, rax
	jmp next

prim__or_:
	or rbx, [rbp]
	sub rbp, 8
	jmp next

prim__and_:
	and rbx, [rbp]
	sub rbp, 8
	jmp next

prim__xor_:
	xor rbx, [rbp]
	sub rbp, 8
	jmp next

prim__invert:
	not rbx
	jmp next

prim__shl_:
	mov rcx, rbx
	mov rbx, [rbp]                       ; move 2nd parameter to TOS
	sub rbp, 8                           ; decrement stack pointer
	shl rbx, cl
	jmp next

prim__sar_:
	mov rcx, rbx
	mov rbx, [rbp]                       ; move 2nd parameter to TOS
	sub rbp, 8                           ; decrement stack pointer
	sar rbx, cl
	jmp next

prim__shr_:
	mov rcx, rbx
	mov rbx, [rbp]                       ; move 2nd parameter to TOS
	sub rbp, 8                           ; decrement stack pointer
	shr rbx, cl
	jmp next

prim__d2r:
	push rbx
	mov rbx, [rbp]                       ; move 2nd parameter to TOS
	sub rbp, 8                           ; decrement stack pointer
	jmp next

prim__r2d:
	add rbp, 8                           ; increment stack pointer
	mov [rbp], rbx                       ; copy TOS to 2nd parameter
	pop rbx
	jmp next

prim__rdrop:
	pop rcx
	jmp next

prim__fetch:
	mov rbx, [rbx]
	jmp next

prim__cfetch:
	mov bl, [rbx]
	movzx rbx, bl
	jmp next

prim__store_:
	mov rax, [rbp]
	mov [rbx], rax
	sub rbp, 16
	mov rbx, [rbp+8]
	jmp next

prim__cstore:
	mov al, [rbp]
	mov [rbx], al
	sub rbp, 16
	mov rbx, [rbp+8]
	jmp next

macro _compare0 s_ {
	test rbx, rbx
	s_ bl
	movsx rbx, bl
}

prim__zero_eq:
	_compare0 sete
	jmp next

prim__zero_neq:
	_compare0 setne
	jmp next

prim__zero_lt:
	_compare0 setl
	jmp next

prim__zero_gt:
	_compare0 setg
	jmp next

prim__zero_le:
	_compare0 setle
	jmp next

prim__zero_ge:
	_compare0 setge
	jmp next

macro _compare s_ {
	cmp rax, [rbp]
	s_ bl
	movsx rbx, bl
	sub rbp, 8
}

prim__eq_:
	_compare sete
	jmp next

prim__neq:
	_compare setne
	jmp next

prim__lt:
	_compare setl
	jmp next

prim__gt:
	_compare setg
	jmp next

prim__le:
	_compare setle
	jmp next

prim__ge:
	_compare setge
	jmp next

prim__lbrac:
	xor rax, rax
	mov qword [var.state], rax
	jmp next

prim__rbrac:
	mov qword [var.state], 1
	jmp next

prim__execute:
	mov rax, rbx
	mov rbx, [rbp]                       ; move 2nd parameter to TOS
	sub rbp, 8                           ; decrement stack pointer
	jmp qword [rax]

prim__comma:
	mov rax, rbx
	mov rdi, r14
	stosq
	mov r14, rdi
	mov rbx, [rbp]                       ; move 2nd parameter to TOS
	sub rbp, 8                           ; decrement stack pointer
	jmp next

prim__ccomma:
	mov rax, rbx
	mov rdi, r14
	stosb
	mov r14, rdi
	mov rbx, [rbp]                       ; move 2nd parameter to TOS
	sub rbp, 8                           ; decrement stack pointer
	jmp next

;;
segment readable writable

prim exit        , "exit"   , 4 , flag.code
prim bye         , "bye"    , 3 , flag.code
prim noop        , "noop"   , 4 , flag.code
prim lit         , "lit"    , 3 , flag.code
prim nip         , "nip"    , 3 , flag.code+flag.pure
prim swap        , "swap"   , 4 , flag.code+flag.pure
prim drop        , "drop"   , 4 , flag.code+flag.pure
prim dup_        , "dup"    , 3 , flag.code+flag.pure
prim over        , "over"   , 4 , flag.code+flag.pure
prim one_plus    , "1+"     , 2 , flag.code+flag.pure
prim one_minus   , "1-"     , 2 , flag.code+flag.pure
prim two_plus    , "2+"     , 2 , flag.code+flag.pure
prim two_minus   , "2-"     , 2 , flag.code+flag.pure
prim four_plus   , "4+"     , 4 , flag.code+flag.pure
prim four_minus  , "4-"     , 4 , flag.code+flag.pure
prim eight_plus  , "8+"     , 2 , flag.code+flag.pure
prim eight_minus , "8-"     , 2 , flag.code+flag.pure
prim two_star    , "2*"     , 2 , flag.code+flag.pure
prim two_slash   , "2/"     , 2 , flag.code+flag.pure
prim four_star   , "4*"     , 2 , flag.code+flag.pure
prim four_slash  , "4/"     , 2 , flag.code+flag.pure
prim negate      , "negate" , 6 , flag.code+flag.pure
prim plus        , "+"      , 1 , flag.code+flag.pure
prim minus       , "-"      , 1 , flag.code+flag.pure
prim star        , "*"      , 1 , flag.code+flag.pure
prim slash_mod   , "/mod"   , 4 , flag.code+flag.pure
prim star_slash  , "*/"     , 2 , flag.code+flag.pure
prim or_         , "or"     , 2 , flag.code+flag.pure
prim and_        , "and"    , 3 , flag.code+flag.pure
prim xor_        , "xor"    , 3 , flag.code+flag.pure
prim invert      , "invert" , 6 , flag.code+flag.pure
prim shl_        , "shl"    , 3 , flag.code+flag.pure
prim sar_        , "sar"    , 3 , flag.code+flag.pure
prim shr_        , "shr"    , 3 , flag.code+flag.pure
prim d2r         , ">r"     , 2 , flag.code
prim r2d         , "r>"     , 2 , flag.code
prim rdrop       , "rdrop"  , 5 , flag.code
prim fetch       , "@"      , 1 , flag.code
prim cfetch      , "c@"     , 2 , flag.code
prim store_      , "!"      , 1 , flag.code
prim cstore      , "c!"     , 2 , flag.code
prim zero_eq     , "0="     , 2 , flag.code+flag.pure
prim zero_neq    , "0<>"    , 3 , flag.code+flag.pure
prim zero_lt     , "0<"     , 2 , flag.code+flag.pure
prim zero_gt     , "0>"     , 2 , flag.code+flag.pure
prim zero_le     , "0<="    , 3 , flag.code+flag.pure
prim zero_ge     , "0>="    , 3 , flag.code+flag.pure
prim eq_         , "="      , 1 , flag.code+flag.pure
prim neq         , "<>"     , 2 , flag.code+flag.pure
prim lt          , "<"      , 1 , flag.code+flag.pure
prim gt          , ">"      , 1 , flag.code+flag.pure
prim le          , "<="     , 2 , flag.code+flag.pure
prim ge          , ">="     , 2 , flag.code+flag.pure

int.entry:
	dq lit, 8, dup_, star, bye

var.s0: dq 0
var.key: dq 0
var.key.curr: dq 0
var.state: dq 0
var.base: dq 10
var.latest: dq link

buf.tib: rq 4096
buf.word: rq 256
