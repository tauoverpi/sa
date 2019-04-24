;;; filename : sa-double.inc
;;; copyright: (c) Simon Nielsen Knights <tauoverpi@yandex.com>
;;; license  : GPLv3
;;; synopsis : 64bit Forth system written in FASM
; vim: ft=fasm et
prim__twoliteral:
  mov rax, [kernel.ip]
  mov rbx, [kernel.ip + 8]
  push rax
  push rbx
  next

prim__dplus:
  pop rax ; ud
  pop rbx ; d
  pop rcx ; ud
  pop rdx ; d
  add rax, rcx
  add rbx, rdx
  push rbx
  push rax
  next

prim__dminus:
prim__d0lt:
prim__d0eq:
prim__d2star:
prim__d2div:
prim__dlt:
prim__deq:
prim__dtos:
prim__dabs:
prim__dmax:
prim__dmin:
prim__dnegate:
prim__mstardiv:
prim__mplus:
prim__tworot:

