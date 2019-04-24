;;; filename : sa-core.inc
;;; copyright: (c) Simon Nielsen Knights <tauoverpi@yandex.com>
;;; license  : GPLv3
;;; synopsis : 64bit Forth system written in FASM
; vim: ft=fasm et
exit:
  poprsp kernel.ip
  next

prim__syscall5:
  pop rax
  pop rdi
  pop rsi
  pop rdx
  pop r8
  pop r9
  syscall
  push rax
  next

prim__syscall4:
  pop rax
  pop rdi
  pop rsi
  pop rdx
  pop r8
  syscall
  push rax
  next

prim__syscall3:
  pop rax
  pop rdi
  pop rsi
  pop rdx
  syscall
  push rax
  next

prim__syscall2:
  pop rax
  pop rdi
  pop rsi
  syscall
  push rax
  next

prim__syscall1:
  pop rax
  pop rdi
  syscall
  push rax
  next

prim__syscall0:
  pop rax
  syscall
  push rax
  next

prim__literal:
  mov rax, [kernel.ip]
  add kernel.ip, 8
  push rax
  next

prim__drop:
  pop rax
  next

prim__swap:
  pop rax
  pop rbx
  push rax
  push rbx
  next

prim__dup_:
  mov rax, [kernel.sp]
  push rax
  next

prim__qdup:
  mov rax, [kernel.sp]
  test rax, rax
  jz @f
  push rax
@@:
  next

prim__twodup:
  push qword [kernel.sp - 8]
  push qword [kernel.sp - 8]
  next

prim__rot:
  pop rax
  pop rbx
  pop rcx
  push rcx
  push rax
  push rbx
  next

prim__nrot:
  pop rax
  pop rbx
  pop rcx
  push rbx
  push rcx
  push rax
  next

prim__over:
  push qword [kernel.sp - 8]
  next

prim__plus:
  pop rax
  add qword [kernel.sp], rax
  next

prim__minus:
  pop rax
  sub qword [kernel.sp], rax
  next

prim__mult:
  pop rax
  pop rbx
  imul rax, rbx
  push rax
  next

prim__divmod:
  xor rdx, rdx
  pop rbx
  pop rax
  idiv rbx
  push rdx
  push rax
  next

prim__increment:
  inc qword [kernel.sp]
  next

prim__decrement:
  dec qword [kernel.sp]
  next

prim__and_:
  pop rax
  and qword [kernel.sp], rax
  next

prim__or_:
  pop rax
  or qword [kernel.sp], rax
  next

prim__xor_:
  pop rax
  xor qword [kernel.sp], rax
  next

prim__not_:
  not qword [kernel.sp]
  next

prim__rshift:
  pop rcx
  shr qword [kernel.sp], cl
  next

prim__lshift:
  pop rcx
  shl qword [kernel.sp], cl
  next

prim__ror_:
  pop rcx
  ror qword [kernel.sp], cl
  next

prim__rol_:
  pop rcx
  rol qword [kernel.sp], cl
  next

prim__store_:
  pop rbx
  pop rax
  mov [rbx], rax
  next

prim__cstore:
  pop rbx
  pop rax
  mov [rbx], al
  next

prim__twostore:
  pop rbx
  pop rax
  pop rdx
  mov [rbx], rax
  mov [rbx + 8], rdx
  next

prim__plusstore:
  pop rbx
  pop rax
  add [rbx], rax
  next

prim__minusstore:
  pop rbx
  pop rax
  sub [rbx], rax
  next

prim__fetch:
  pop rax
  push qword [rax]
  next

prim__cfetch:
  xor rax, rax
  pop rbx
  mov al, [rbx]
  push rax
  next

prim__twofetch:
  pop rax
  push qword [rax]
  push qword [rax + 8]
  next

prim__branch:
  add kernel.ip, [kernel.ip]
  next

prim__qbranch:
  pop rax
  test rax, rax
  jnz prim__branch
  add kernel.ip, 8
  next

prim__r2d:
  poprsp rax
  push rax
  next

prim__d2r:
  pop rax
  pushrsp rax
  next

prim__comma:
  pop rax
  mov rdi, variable.here
  stosq
  mov [variable.here], rdi
  next

prim__ccomma:
  pop rax
  mov rdi, variable.here
  stosb
  mov [variable.here], rdi
  next

prim__key:
  call __key
  push rax
  next
__key:
  mov r8, [variable.key.current]
  mov r9, [variable.key.buffered]
  cmp r8, r9
  je .buffer_more
  add r8, kernel.tib
  mov rax, [r8]
  inc qword [variable.key.current]
  ret
.buffer_more:
  mov rax, sys.read
  mov rdi, fd.stdin
  mov rsi, kernel.tib
  mov rdx, 4096
  syscall
  test rax, rax
  jz .die
  mov qword [variable.key.current], 0
  mov [variable.key.buffered], rax
  jmp __key
.die:
  mov rdi, 1
  mov rax, sys.exit
  syscall

prim__emit:
  pop rax
  call __emit
  next
__emit:
  mov [kernel.emit.scratch], al
  mov rax, sys.write
  mov rdi, fd.stdout
  mov rsi, kernel.emit.scratch
  mov rdx, 1
  syscall
  ret

prim__word_:
  call __word
  pushq kernel.wb
  push r13
  next
__word:
.eat:
  call __key
  cmp rax, ascii.space
  jle .eat
  cmp rax, ascii.del
  je .eat
  mov r13, kernel.wb
.read:
  mov [r13], al
  inc r13
  call __key
  cmp rax, ascii.del
  je .done
  cmp rax, ascii.space
  jg .read
  sub r13, kernel.wb
.done:
  ret

prim__type:
  mov rax, sys.write
  mov rdi, fd.stdout
  pop rdx
  pop rsi
  syscall
  next

prim__fill:
  pop rdx
  pop rsi

prim__source:
  push kernel.tib
  pushq [variable.key.buffered]
  next

prim__decimal:
  mov byte [variable.base], 10
  next

prim__number:
  pop rcx
  pop rdi
  call __number
  push rax
  push rcx
  next
__number:

ddiadicPred eq_, sete
diadicPred le, setle
diadicPred lt, setl
diadicPred ge, setge
diadicPred gt, setg
zeroPred zeq, sete
zeroPred zlt, setl

constant cell, 8
prim__cellplus:
  add qword [kernel.sp], 8
  next

variable here
variable state
variable base
variable s0
variable latest


