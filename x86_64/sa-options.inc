;;; filename : sa-options.inc
;;; copyright: (c) Simon Nielsen Knights <tauoverpi@yandex.com>
;;; license  : GPLv3
;;; synopsis : 64bit Forth system written in FASM
; vim: ft=fasm et
kernel.data_segment_size = 0xffff
kernel.tib.size = 4096
kernel.tob.size = 4096
kernel.wb.size = 32
kernel.rstack.size = 64
kernel.fstack.size = 64

wordlist.coreext  equ true
wordlist.block    equ true ; TBD
wordlist.double   equ true ; TBD
wordlist.except   equ true ; TBD
wordlist.facility equ true ; TBD
wordlist.files    equ true ; TBD
wordlist.floating equ true ; TBD
wordlist.memory   equ true ; TBD
wordlist.tools    equ true ; TBD
wordlist.search   equ true ; TBD
wordlist.string   equ true ; TBD
wordlist.xchar    equ true ; TBD
wordlist.task     equ true ; TBD

