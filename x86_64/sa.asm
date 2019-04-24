;;; filename : sa.asm
;;; copyright: (c) Simon Nielsen Knights <tauoverpi@yandex.com>
;;; license  : GPLv3
;;; synopsis : 64bit Forth system written in FASM
; vim: ft=fasm et

include "sa-macro.inc"

true  equ 1
false equ 0

; Syscalls
sys.exit  = 60
sys.read  = 0
sys.write = 1
sys.open  = 2
sys.close = 3
sys.brk   = 12

; File descriptors
fd.stdin  = 0
fd.stdout = 1
fd.stderr = 2

; Character constants
ascii.space   = 20h
ascii.newline = 0Ah
ascii.del     = 7Fh

; Flag constants
flag.immed   = 64
flag.hidden  = 32
flag.lenmask = 31

; Kernel registers
kernel.ip  equ r15
kernel.rsp equ r14
kernel.sp  equ rsp

; Wordlist pointers
kernel.link.core     = 0
kernel.link.coreext  = 0
kernel.link.block    = 0
kernel.link.double   = 0
kernel.link.except   = 0
kernel.link.facility = 0
kernel.link.files    = 0
kernel.link.floating = 0
kernel.link.memory   = 0
kernel.link.tools    = 0
kernel.link.search   = 0
kernel.link.string   = 0
kernel.link.xchar    = 0
kernel.link.task     = 0

; Misc
kernel.latest = 0

include "sa-options.inc"

format ELF64 executable 3
segment readable executable

entry main

main:
  cld
  mov [variable.s0], rsp
  mov kernel.rsp, kernel.rstack

  xor rbx, rbx
  mov rax, sys.brk
  syscall
  mov [variable.here], rax
  add rax, kernel.data_segment_size
  mov rbx, rax
  mov rax, sys.brk
  syscall

  mov kernel.ip, kernel.entry
  next

docol:
  pushrsp kernel.ip
  add rax, 8
  mov kernel.ip, rax
  next

include "sa-core.inc"
if wordlist.coreext eq true
  include "sa-coreext.inc"
end if
if wordlist.block eq true
  ;include "sa-block.inc"
end if
if wordlist.double eq true
  ;include "sa-double.inc"
end if
if wordlist.except eq true
  include "sa-except.inc"
end if
if wordlist.facility eq true
  ;include "sa-facility.inc"
end if
if wordlist.files eq true
  ;include "sa-files.inc"
end if
if wordlist.floating eq true
  ;include "sa-floating.inc"
end if
if wordlist.memory eq true
  ;include "sa-memory.inc"
end if
if wordlist.tools eq true
  ;include "sa-tools.inc"
end if
if wordlist.search eq true
  ;include "sa-search.inc"
end if
if wordlist.string eq true
  ;include "sa-string.inc"
end if
if wordlist.xchar eq true
  ;include "sa-xchar.inc"
end if
if wordlist.task eq true
  ;include "sa-task.inc"
end if

segment readable
include "sa-code-words.inc"
include "sa-forth-words.inc"

kernel.entry: dq word_, type, bye

segment readable writable
variable.s0:           dq 0
variable.here:         dq 0
variable.state:        dq 0
variable.base:         db 10
variable.latest:       dq kernel.latest
variable.key.current:  dq 0
variable.key.buffered: dq 0
variable.wb.current:   dq 0

variable.wordlist.core:     dq kernel.link.core
variable.wordlist.coreext:  dq kernel.link.coreext
variable.wordlist.block:    dq kernel.link.block
variable.wordlist.double:   dq kernel.link.double
variable.wordlist.except:   dq kernel.link.except
variable.wordlist.facility: dq kernel.link.facility
variable.wordlist.files:    dq kernel.link.files
variable.wordlist.floating: dq kernel.link.floating
variable.wordlist.memory:   dq kernel.link.memory
variable.wordlist.tools:    dq kernel.link.tools
variable.wordlist.search:   dq kernel.link.search
variable.wordlist.string:   dq kernel.link.string
variable.wordlist.xchar:    dq kernel.link.xchar

kernel.emit.scratch:   db 0
kernel.wb:             rb kernel.wb.size
kernel.tib:            rb kernel.tib.size
kernel.tob:            rb kernel.tob.size
kernel.rstack:         rq kernel.rstack.size
kernel.fstack:         rq kernel.fstack.size
