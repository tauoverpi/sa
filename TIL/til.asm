; vim: ft=fasm et

option.data_segment.size = 4096
option.scratch.size      = 4096
option.word.length       = 256
option.rstack.size       = 64
option.tib.size          = 4096

; HEADER
;        LINK 64 bits
link.last = 0
wordlist.core     = 0
wordlist.coreext  = 0
wordlist.string   = 0
wordlist.floating = 0
wordlist.task     = 0
wordlist.linux    = 0

;        FLAGS 8 bits
flag.hidden       equ 10000000b ; hidden word, not visible to the compiler or interpreter
flag.immed        equ 01000000b ; compile-time word, runs during compilation
flag.compile_only equ 00100000b ; compile-only word, it's an error to run this in the interpreter
flag.inline       equ 00010000b ; [code 0] inlinable word, definition inlined instead of referenced
;flag.????        equ 00010000b ; [code 1] undefined
flag.pure         equ 00001000b ; pure word, may transformed via algebraic properties
flag.code         equ 00000100b ; code word, routine in assembly
;flag.????        equ 00000010b ; undefined
;flag.????        equ 00000001b ; undefined
;        LEN 8 bits
;        NAME 8 * LEN bits
;        PAD (alignment)
;        PARAMETERS 64 * N bits
; END OF HEADER

rts.ip  equ r15 ; instruction pointer
rts.rsp equ r14 ; return stack pointer
rts.psp equ rsp ; parameter stack pointer

mode.immediate equ 0
mode.compile   equ 1

sys.exit  equ 60
sys.read  equ 0
sys.write equ 1
sys.open  equ 2
sys.close equ 3
sys.brk   equ 12

fd.stdin  equ 0
fd.stdout equ 1
fd.stderr equ 2

ascii.space   equ 20h
ascii.newline equ 0Ah
ascii.del     equ 7Fh

syscall.arg1 equ rdi
syscall.arg2 equ rsi
syscall.arg3 equ rdx
syscall.arg4 equ r8
syscall.arg5 equ r9

macro defcode link, ident, len, name, flags=0 {
link__#ident:
  dq link                              ; set pointer to last word
  db flags, len, name                  ; set flags, length of name, and name
  link = link__#ident                  ; set fasm link variable pointing to this header
  link.last = link
  align 8                              ; align to 8 bytes
  dq prim__#ident                      ; set location of native word
}

macro def link, ident, len, name, flags=0 {
link__#ident:
  dq link                              ; set pointer to last word
  db flags, len, name                  ; set flags, length of name, and name
  link = link__#ident                  ; set fasm link variable pointing to this header
  link.last = link
  align 8                              ; align to 8 bytes
ident:
  dq docol                             ; set location of high level code interpreter
}

macro var ident {
ident:
  push variable.#ident                 ; push variable address to stack
  next                                 ; end of code word
}

format ELF64 executable 3
segment readable executable

entry main

main:
  cld
  mov [variable.s0], rsp
  mov rts.rsp, buffer.rstack

  xor syscall.arg1, syscall.arg1       ; clear parameter
  mov rax, sys.brk                     ; sys.brk
  syscall                              ; get start of the data segment
  mov [variable.here], rax             ; store pointer to start in HERE
  add rax, option.data_segment.size    ; reserve bytes of memory for the initial data segment
  mov arg1, rax                        ; set first parameter to number of bytes
  mov rax, sys.brk                     ; sys.brk
  syscall                              ; commit change

  mov rts.ip, interpreter.entry        ; set entry point
  next                                 ; enter high level code

docol:

prim__exit:                            ; (n -- )
prim__literal:                         ; ( -- n)
  pushq [rts.ip]                       ; push the next cell value to stack
  add rts.ip, 8                        ; advance ip past the next cell
  next                                 ; end of code word

prim__syscall5:                        ; (x5 x4 x3 x2 x1 sys -- x)
  pop rax
  pop arg1
  pop arg2
  pop arg3
  pop arg4
  pop arg5
  syscall                              ; call
  push rax                             ; push result in rax to the stack
  next                                 ; end of code word

prim__syscall4:                        ; (x4 x3 x2 x1 sys -- x)
  pop rax
  pop arg1
  pop arg2
  pop arg3
  pop arg4
  syscall                              ; call
  push rax                             ; push result in rax to the stack
  next                                 ; end of code word

prim__syscall3:                        ; (x3 x2 x1 sys -- x)
  pop rax
  pop arg1
  pop arg2
  pop arg3
  syscall                              ; call
  push rax                             ; push result in rax to the stack
  next                                 ; end of code word

prim__syscall2:                        ; (x2 x1 sys -- x)
  pop rax                              ; prepare syscall
  pop arg1                             ; set first argument
  pop arg2                             ; set decond argument
  syscall                              ; call
  push rax                             ; push result in rax to the stack
  next                                 ; end of code word

prim__syscall1:                        ; (x1 sys -- x)
  pop rax                              ; prepare syscall
  pop arg1                             ; set first argument
  syscall                              ; call
  push rax                             ; push result in rax to the stack
  next                                 ; end of code word

prim__syscall0:                        ; (sys -- x)
  pop rax                              ; prepare syscall
  syscall                              ; call
  push rax                             ; push result in rax to the stack
  next                                 ; end of code word

prim__swap:                            ; (x y -- y x)
  pop rax
  pop rbx
  push rax
  push rbx
  next

prim__drop:                            ; (x y -- x)
  pop rax
  next

prim__nip:                             ; (x y -- y)
  pop rax
  mov [rts.sp], rax
  next

prim__dup_:                            ; (x -- x x)
  mov rax, [rts.sp]
  push rax
  next

prim__qdup:                            ; (x -- x x | x)
  mov rax, [rts.sp]
  test rax, rax
  jz @f
  push rax
@@:
  next

prim__rot:                             ; (x y z -- z x y)
  pop rax
  pop rbx
  pop rcx
  push rcx
  push rax
  push rbx

prim__tuck:                            ; (x y -- y x y)
  pop rax
  pop rbx
  push rax
  push rbx
  push rax
  next

prim__over:                            ; (x y -- x y x)
  pushq [rts.sp - 8]
  next

prim__pick:                            ; (n -- x)
  pop rax
  imul rax, 8
  sub rax, kernel.sp
  pushq [rax]
  next

prim__plus:                            ; (n n - n)
  pop rax
  add [rts.sp], rax
  next

prim__minus:                           ; (n n - n)
  pop rax
  sub [rts.sp], rax
  next

prim__mult:                            ; (n n - n)
  pop rax
  pop rbx
  imul rax, rbx
  push rax
  next

prim__divmod:                          ; (n n -- rem quot)
  xor rdx, rdx
  pop rbx
  pop rax
  idiv rbx
  push rdx                             ; push remainder
  push rax                             ; push quotient
  next

prim__increment:                       ; (n -- n)
  inc qword [rts.sp]
  next

prim__decrement:                       ; (n -- n)
  dec qword [rts.sp]
  next

prim__invert:                          ; (n -- n)
  not qword [rts.sp]
  next

prim__rshift:                          ; (n n -- n)
  pop rcx
  rsh [rts.sp], rcx
  next

prim__lshift:                          ; (n n -- n)
  pop rcx
  lsh [rts.sp], rcx
  next

prim__store_:                          ; (x a -- )
  pop rax
  pop rbx
  mov [rax], rbx
  next

prim__fetch:                           ; (a -- n)
  pop rax
  mov rbx, [rax]
  push rbx
  next

prim__plusstore:                       ; (n a -- )
  pop rax
  pop rbx
  add [rax], rbx
  next

prim__minusstore:                      ; (n a -- )
  pop rax
  pop rbx
  sub [rax], rbx
  next

prim__cstore:                          ; (c a -- )
  pop rax
  pop rbx
  mov [rax], bl
  next

prim__cfetch:                          ; (a -- c)
  xor rbx, rbx
  pop rax
  mov bl, [rax]
  push rbx
  next

prim__branch:                          ; ( -- )
  add rts.ip, [rts.ip]
  next

prim__qbranch:                         ; (n -- )
  pop rax
  test rax, rax
  jnz prim__branch
  add rts.ip, 8
  next

prim__type:                            ; (a n -- )
  mov rax, sys.write
  mov arg1, fd.stdout                  ; set file descriptor
  pop arg2                             ; set length of string
  pop arg3                             ; set address of string
  syscall                              ; write
  next

prim__litstring:                       ; ( -- a n)
  mov rax, [rts.ip]                    ; copy length
  add rts.ip, 8                        ; advance ip
  push rts.ip                          ; push address of string
  push rax                             ; push length of string
  add rts.sp, rax                      ; skip length of string
  add rts.sp, 7                        ; align to 8 byte boundary
  and rts.sp, ~7
  next

prim__execute:                         ; (xt -- )
  pop rax                              ; pop xt
  jmp qword [rax]                      ; execute xt

prim__lbrac:
  xor rax, rax
  mov [variable.state], rax
  next

prim__rbrac:
  mov [variable.state], 1
  next

prim__comma:                           ; (n -- )
  pop rax
  call __comma
  next
__comma:
  mov rdi, [variable.here]
  stosq
  mov [variable.here], rdi
  ret

prim__ccomma:                          ; (n -- )
  pop rax
  call __ccomma
  next
__ccomma:
  mov rdi, [variable.here]
  stosb
  mov [variable.here], rdi
  ret

var wordlist.core
var wordlist.coreext
var wordlist.string
var wordlist.floating
var wordlist.task
var wordlist.linux

segment readable writable

defcode wordlist.core, exit, 4, "exit", flag.code
defcode wordlist.core, literal, 7, "literal", flag.code+flag.compile_only+flag.pure
defcode wordlist.linux, syscall5, 8, "syscall5", flag.code
defcode wordlist.linux, syscall4, 8, "syscall4", flag.code
defcode wordlist.linux, syscall3, 8, "syscall3", flag.code
defcode wordlist.linux, syscall2, 8, "syscall2", flag.code
defcode wordlist.linux, syscall1, 8, "syscall1", flag.code
defcode wordlist.linux, syscall0, 8, "syscall0", flag.code
defcode wordlist.core, swap, 4, "swap", flag.code+flag.pure
defcode wordlist.core, drop, 4, "drop", flag.code+flag.pure
defcode wordlist.core, dup_, 3, "dup", flag.code+flag.pure
defcode wordlist.coreext, nip, 3, "nip", flag.code+flag.pure
defcode wordlist.core, rot, 3, "rot", flag.code+flag.pure
defcode wordlist.core, tuck, 4, "tuck", flag.code+flag.pure
defcode wordlist.core, over, 4, "over", flag.code+flag.pure
defcode wordlist.coreext, pick, 4, "pick", flag.code+flag.pure
defcode wordlist.core, plus, 1, "+", flag.code+flag.pure
defcode wordlist.core, minus, 1, "-", flag.code+flag.pure
defcode wordlist.core, mult, 1, "*", flag.code+flag.pure
defcode wordlist.core, divmod, 4, "/mod", flag.code+flag.pure
defcode wordlist.core, and_, 3, "and", flag.code+flag.pure
defcode wordlist.core, or_, 2, "or", flag.code+flag.pure
defcode wordlist.core, xor_, 3, "xor", flag.code+flag.pure
defcode wordlist.core, increment, 2, "1+", flag.code+flag.pure
defcode wordlist.core, decrement, 2, "1-", flag.code+flag.pure
defcode wordlist.core, invert, 6, "invert", flag.code+flag.pure
defcode wordlist.core, rshift, 6, "rshift", flag.code+flag.pure
defcode wordlist.core, lshift, 6, "lshift", flag.code+flag.pure
defcode wordlist.core, store_, 1, "!", flag.code
defcode wordlist.core, fetch, 1, "@", flag.code
defcode wordlist.core, plusstore, 2, "+!", flag.code
defcode wordlist.core, minusstore, 2, "-!", flag.code
defcode wordlist.core, cstore, 2, "c!", flag.code
defcode wordlist.core, cfetch, 2, "c@", flag.code
defcode wordlist.core, branch, 5, "branch", flag.code
defcode wordlist.core, qbranch, 6, "qbranch", flag.code
defcode wordlist.core, type, 4, "type", flag.code
defcode wordlist.core, litstring, 4, 'lit"', flag.code+flag.pure+flag.compile_only
defcode wordlist.core, execute, 7, "execute", flag.code+flag.pure
defcode wordlist.core, lbrac, 1, "[", flag.compile_only+flag.code+flag.immed
defcode wordlist.core, rbrac, 1, "]", flag.code
defcode wordlist.core, comma, 1, ",", flag.code
defcode wordlist.core, ccomma, 2, "c,", flag.code

def wordlist.core, create, 6, "create", 0

interpreter.entry: dq literal, 80, syscall1

variable.s0:     dq 0                  ; hardware stack base pointer
variable.r0:     dq buffer.rstack      ; return stack base pointer
variable.here:   dq 0                  ; user memory cursor
variable.state:  dq 0                  ; compiler state variable
variable.base:   db 10                 ; radix
variable.latest: dq link.last          ; latest definition pointer

; built-in word lists (namespaces)
variable.wordlist.core:     dq wordlist.core
variable.wordlist.coreext:  dq wordlist.coreext
variable.wordlist.string:   dq wordlist.string
variable.wordlist.floating: dq wordlist.floating
variable.wordlist.task:     dq wordlist.task
variable.wordlist.linux:    dq wordlist.linux

buffer.scratch: rb option.scratch.size ; general temp work area not guaranteed to presist
buffer.word:    rb option.word.length  ; word buffer, stores a single word
buffer.tib:     rb option.tib.size     ; text input buffer
buffer.rstack:  rq option.rstack.size  ; return stack
