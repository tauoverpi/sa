
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MACRO

link = 0

macro prim name, ident, len, flag=0 {
	link__#ident:
		dq link
		link = link__#ident
		db flag, len, name
		align 8
		dq prim__#ident
}

macro forth name, ident, len, flag=0 {
	link__#ident:
		dq link
		link = link__#ident
		db flag, len, name
		align 8
		dq docol
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MACRO FORTH

; TOS = rbx
; RSTK = rbp
macro m_nip { sub [rbp], 8 }
macro m_swap {
	mov rax, [rbp]
	mov [rts.sp], rbx
	mov rbx, rax
}
macro m_drop {
	mov rbx, [rbp]
	m_nip
}
macro m_dup {
	add rbp, 8
	mov [rbp], rbx
}

macro m_over {
	mov rax, [rbp]
	m_dup
	mov rbx, rax
}

macro m_one_plus { inc rbx }
macro m_one_minus { dec rbx }
macro m_two_plus { add rbx, 2 }
macro m_two_minus { sub rbx, 2 }
macro m_four_plus { add rbx, 4 }
macro m_four_minus { sub rbx, 4 }

macro m_two_star { sal rbx, 1 }
macro m_two_slash { sar rbx, 1 }
macro m_four_star { sal rax, 2 }
macro m_four_slash { sar rbx, 2 }

macro m_negate { neg rbx }

macro m_plus {
	add rbx, [rbp]
	sub rbp, 8
}
macro m_minus {
	sub [rbp], rbx
	m_drop
}

macro m_star {
	imul rbx, [rbp]
	sub rbp, 8
}

macro m_slash_mod {
	xor rdx, rdx
	mov rax, [rbp]
	idiv rbx
	mov rbx, rax
	mov [rbp], rdx
}

macro m_star_slash {
	sub rbp, 8
	mov rax, [rbp+8]
	imul [rbp+8]
	idiv rbx
	mov rbx, rax
}

macro m_and {
	and rbx, [rbp]
	sub rbp, 8
}

macro m_or {
	or rbx, [rbp]
	sub rbp, 8
}

macro m_xor {
	xor rbx, [rbp]
	sub rbp, 8
}

macro m_invert {
	not rbx
}

macro m_to_rcx {
	mov rcx, rbx
}

macro m_shl {
	m_to_rcx
	m_drop
	shl, rbx, cl
}

macro m_shr {
	m_to_rcx
	m_drop
	shr, rbx, cl
}

macro m_sar {
	m_to_rcx
	m_drop
	sar, rbx, cl
}

macro m_push {
	push rbx
	m_drop
}

macro m_pop {
	m_dup
	pop rbx
}

macro m_rdrop {
	pop rcx
}

macro m_rdrop_many {
	m_four_star
	add rsp, rbx
	m_drop
}

macro m_push_many {
	local start
	local done
	start:
		cmp rbx, 0
		jle done
		pushq [rbp]
		dec rbx
		sub rbp, 8
		jmp start
	done:
}

macro m_fetch { mov rbx, [rbx] }

macro m_cfetch {
	mov bl, [rbx]
	movzx rbx, bl
}

macro m_store {
	mov rax, [rbp]
	mov [rbx], rax
	sub rbp, 16
	mov rbx, [rbp+8]
}

macro m_cstore {
	mov al, [rbp]
	mov [rbx], al
	sub, rbp, 16
	mov rbx, [rbp+8]
}

macro _compare0 set_ {
	cmp rbx, 0
	set_ bl
	movzx rbx, bl
}

macro m_zero_eq { _compare0 sete }
macro m_zero_neq { _compare0 setne }
macro m_zero_lt { _compare0 setl }
macro m_zero_gt { _compare0 setg }
macro m_zero_le { _compare0 setle }
macro m_zero_ge { _compare0 setge }

macro _compare set_ {
	cmp [rbp], rbx
	set_ bl
	movzx rbx, bl
}

macro m_eq { _compare sete }
macro m_neq { _compare setne }
macro m_lt { _compare setl }
macro m_gt { _compare setg }
macro m_le { _compare setle }
macro m_ge { _compare setge }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CODE

docol:
	push r15
	add r15, 8
	jmp qword [r15]

macro next {
	add rax, [r15]
	add r15, 8
	jmp qword [rax]
}

prim__exit:
	pop r15
	next

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PRIMITIVES

prim__nip:
	m_nip
	next

prim__swap:
	m_swap
	next

prim__drop:
	m_drop
	next

prim__dup_:
	m_dup
	next

prim__over:
	m_over
	next

prim__one_plus:
	m_one_plus
	next

prim__one_minus:
	m_one_minus
	next

prim__two_plus:
	m_two_plus
	next

prim__two_minus:
	m_two_minus
	next

prim__four_plus:
	m_four_plus
	next

prim__four_minus:
	m_four_minus
	next

prim__two_star:
	m_two_star
	next

prim__two_slash:
	m_two_slash
	next

prim__negate:
	m_negate
	next

prim__plus:
	m_plus
	next

prim__minus:
	m_minus
	next

prim__star:
	m_star
	next

prim__slash_mod:
	m_slash_mod
	next

prim__star_slash:
	m_star_slash
	next

prim__and_:
	m_and
	next

prim__or_:
	m_or
	next

prim__xor_:
	m_xor
	next

prim__invert:
	m_invert
	next

prim__shl:
	m_shl
	next

prim__shr:
	m_shr
	next

prim__sar:
	m_sar
	next

prim__rpush:
	m_push
	next

prim__rpop:
	m_pop
	next

prim__rdrop:
	m_rdrop
	next

prim__rdrop_many:
	m_rdrop_many
	next

prim__rpush_many:
	m_push_many
	next

prim__fetch:
	m_fetch
	next

prim__cfetch:
	m_cfetch
	next

prim__store_:
	m_store
	next

prim__cstore:
	m_cstore
	next

prim__zero_eq:
	m_zero_eq
	next

prim__zero_neq:
	m_zero_neq
	next

prim__zero_lt:
	m_zero_lt
	next

prim__zero_gt:
	m_zero_gt
	next

prim__zero_le:
	m_zero_le
	next

prim__zero_ge:
	m_zero_ge
	next

prim__eq:
	m_eq
	next

prim__neq:
	m_neq
	next

prim__lt:
	m_lt
	next

prim__gt:
	m_gt
	next

prim__le:
	m_le
	next

prim__ge:
	m_ge
	next

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; HEADERS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VARIABLES

var.here: dq 0
var.state: dq 0
var.key: dq 0
var.key.current: dq 0
vzr.word: dq 0
buf.key: rb 4096
