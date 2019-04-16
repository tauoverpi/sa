;;; filename : sa-coreext.inc
;;; copyright: (c) Simon Nielsen Knights <tauoverpi@yandex.com>
;;; license  : GPLv3
;;; synopsis : 64bit Forth system written in FASM
; vim: ft=fasm
prim__pick:
	pop rax
	imul rax, 8
	add rax, kernel.sp
	push qword [rax]
	next

prim__hex:
  mov byte [variable.base], 16
  next

diadicPred neq, setne
zeroPred zneq, setne
zeroPred zle, setle
zeroPred zge, setge
zeroPred zgt, setg
