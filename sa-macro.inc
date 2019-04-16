;;; filename : sa-macro.inc
;;; copyright: (c) Simon Nielsen Knights <tauoverpi@yandex.com>
;;; license  : GPLv3
;;; synopsis : 64bit Forth system written in FASM
; vim: ft=fasm
macro makeHeader link, init, name, ident, len, flags=0 {
	link__#ident:
		dq link
		db (flags+len), name
		link = link__#ident
    kernel.latest = link__#ident
		align 8
	ident:
		dq init
}

macro code link, name, ident, len, flags=0 {
	makeHeader link, prim__#ident, name, ident, len, flags
}

macro forth link, name, ident, len, flags=0 {
	makeHeader link, docol, name, ident, len, flags
}

macro next {
	mov rax, [kernel.ip]
	add kernel.ip, 8
	jmp qword [rax]

}

macro pushrsp reg {
	mov [kernel.rsp], reg
	add kernel.rsp, 8
}

macro poprsp reg {
	sub kernel.rsp, 8
	mov reg, [kernel.rsp]
}

macro variable ident {
	prim__#ident:
		push variable.#ident
		next
}

macro constant ident, val {
	prim__#ident:
		push val
		next
}

macro zeroPred name, set {
	prim__#name:
		pop rax
		test rax, rax
		set al
		movsx rax, al
		dec rax
		not rax
		push rax
		next
}

macro diadicPred name, set {
	prim__#name:
		pop rax
		pop rbx
		cmp rax, rbx
		set al
		movsx rax, al
		dec rax
		not rax
		push rax
		next
}


