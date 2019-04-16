;;; filename : sa-forth-words.inc
;;; copyright: (c) Simon Nielsen Knights <tauoverpi@yandex.com>
;;; license  : GPLv3
;;; synopsis : 64bit Forth system written in FASM
; vim: ft=fasm
forth  kernel.link.core, "BYE", bye, 3 ; ( -- )
dq lit, 60, syscall1

