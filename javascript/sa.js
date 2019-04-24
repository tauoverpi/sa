// 32bit FORTH in Javascript
const stack_size  = 64
const rstack_size = 64
const memory_size = 0xffff

const kernel            = {}
kernel.stack            = Array(stack_size)
kernel.rstack           = Array(rstack_size)
kernel.memory           = Array(memory_size)
kernel.rsp              = 0
kernel.psp              = 0
kernel.ip               = 0
kernel.wordlist         = {}
kernel.wordlist.core    = 0
kernel.wordlist.coreext = 0
kernel.wordlist.double  = 0
kernel.wordlist.except  = 0
kernel.wordlist.web     = 0
kernel.variable         = {}
kernel.variable.here    = 0
kernel.variable.base    = 10
kernel.variable.state   = 0
kernel.variable.latest  = 0

const core      = 'core'
const coreext   = 'coreext'
const double    = 'double'
const exception = 'exception'
const web       = 'web'

// UTILITY

function code(wl, name, prim){
	kernel.memory[kernel.variable.here] = kernel.variable.latest
	kernel.variable.latest = kernel.variable.here
	kernel.wordlist[wl] = kernel.variable.latest
	kernel.variable.here += 1
	kernel.memory[kernel.variable.here] = name
	kernel.variable.here += 1
	kernel.memory[kernel.variable.here] = prim
	const r = kernel.variable.here
	kernel.variable.here += 1
	return r
}

function dq(lst){
	for(e in lst){
		kernel.memory[kernel.variable.here] = e
		kernel.variable.here += 1
	}
}

function docol(){
	pushrsp(kernel.ip)
	kernel.ip = kernel.memory[kernel.ip]
}

function forth(wl, name, prim){
	kernel.memory[kernel.variable.here] = kernel.variable.latest
	kernel.variable.latest = kernel.variable.here
	kernel.wordlist[wl] = kernel.variable.latest
	kernel.variable.here += 1
	kernel.memory[kernel.variable.here] = name
	kernel.variable.here += 1
	kernel.memory[kernel.variable.here] = docol
	const r = kernel.variable.here
	kernel.variable.here += 1
	dq(prim)
	return r
}

function push(val){
	kernel.stack[kernel.psp] = val
	kernel.psp += 1
}

function pushrsp(val){
	kernel.rstack[kernel.rsp] = val
	kernel.rsp += 1
}

function pop(){
	kernel.psp -= 1
	return kernel.stack[kernel.psp]
}

function poprsp(){
	kernel.rsp -= 1
	return kernel.rstack[kernel.rsp]
}

function next(){
	kernel.ip += 1
}

function binop(op){
	kernel.psp -= 1
	kernel.stack[kernel.psp-1] = op(kernel.stack[kernel.psp]) (kernel.stack[kernel.psp-1])
	next()
}

// WORDS

function prim__drop(){pop();next}

function prim__pick(){
	push(kernel.stack[-pop()])
	next()
}

function prim__swap(){
	const eax = pop()
	const ebx = pop()
	push(eax)
	push(ebx)
	next()
}
function prim__qdup(){
	const eax = kernel.stack[kernel.psp-1]
	if (eax != 0) { push(eax) }
	next()
}
function prim__rot(){
	const eax = pop()
	const ebx = pop()
	const ecx = pop()
	push(ecx)
	push(eax)
	push(ebx)
	next()
}
function prim__over(){push(kernel.stack[kernel.psp-2])}
function prim__dup(){push(kernel.stack[kernel.psp-1])}
function prim__plus(){binop(x => y => y + x)}
function prim__minus(){binop(x => y => y - x)}
function prim__mul(){binop(x => y => y * x)}
function prim__div(){binop(x => y => y / x)}
function prim__mod(){binop(x => y => y % x)}
function prim__or(){binop(x => y => y | x)}
function prim__and(){binop(x => y => y & x)}
function prim__xor(){binop(x => y => y ^ x)}
function prim__invert(){kernel.stack[kernel.psp-1] = kernel.stack[kernel.psp-1] ^ 0xffffffff;next()}
function prim__rshift(){binop(x => y => y >> x)}
function prim__lshift(){binop(x => y => y << x)}
function prim__eq(){binop(x => y => y == x ? 0xffffffff : 0)}
function prim__neq(){binop(x => y => y != x ? 0xffffffff : 0)}
function prim__lt(){binop(x => y => y < x ? 0xffffffff : 0)}
function prim__gt(){binop(x => y => y > x ? 0xffffffff : 0)}
function prim__le(){binop(x => y => y <= x ? 0xffffffff : 0)}
function prim__ge(){binop(x => y => y >= x ? 0xffffffff : 0)}
function prim__eq0(){kernel.stack[kernel.psp-1] = 0 == kernel.stack[kernel.psp-1]? 0xffffffff|0 : 0|0;next()}
function prim__neq0(){kernel.stack[kernel.psp-1] = 0 != kernel.stack[kernel.psp-1]? 0xffffffff|0 : 0|0;next()}
function prim__lt0(){kernel.stack[kernel.psp-1] = 0 < kernel.stack[kernel.psp-1]? 0xffffffff|0 : 0|0;next()}
function prim__gt0(){kernel.stack[kernel.psp-1] = 0 > kernel.stack[kernel.psp-1]? 0xffffffff|0 : 0|0;next()}
function prim__le0(){kernel.stack[kernel.psp-1] = 0 <= kernel.stack[kernel.psp-1]? 0xffffffff|0 : 0|0;next()}
function prim__ge0(){kernel.stack[kernel.psp-1] = 0 >= kernel.stack[kernel.psp-1]? 0xffffffff|0 : 0|0;next()}
function prim__store(){
	const addr = pop()
	kernel.memory[addr] = pop()
	next()
}
function prim__fetch(){
	push(kernel.memory[addr])
	next()
}
function prim__branch(){
	kernel.ip = kernel.memory[kernel.ip]
}
function prim__qbranch(){
	if (pop() === 0) { prim__branch() }
	next()
}
function prim__r2d(){
	push(poprsp())
	next()
}
function prim__d2r(){
	pushrsp(pop())
	next()
}
function prim__comma(){
	kernel.memory[kernel.variable.here] = pop()
	kernel.variable.here += 1
	next()
}
function prim__hex(){
	kernel.variable.base = 16
	next()
}
function prim__decimal(){
	kernel.variable.base = 10
	next()
}
function prim__literal(){
	push(kernel.memory[kernel.ip]|0)
	kernel.ip += 1
	next()
}

function prim__create_element(){
	push(document.createElement(pop()))
	next()
}

function prim__exit(){
	kernel.ip = poprsp()
}

const drop = code(core, "drop", prim__drop)
const swap = code(core, "swap", prim__swap)
const qdup = code(core, "?dup", prim__qdup)
const rot  = code(core, "rot", prim__rot)
const over = code(core, "over", prim__over)
const dup = code(core, "dup", prim__dup)
const plus = code(core, "+", prim__plus)
const minus = code(core, "-", prim__minus)
const mul = code(core, "*", prim__mul)
const div = code(core, "/", prim__div)
const mod = code(core, "mod", prim__mod)
const or = code(core, "or", prim__or)
const and = code(core, "and", prim__and)
const xor = code(core, "xor", prim__xor)
const invert = code(core, "invert", prim__invert)
const rshift = code(core, "rshift", prim__rshift)
const lshift = code(core, "lshift", prim__lshift)
const eq = code(core, "=", prim__eq)
const lt = code(core, "<", prim__lt)
const gt = code(core, ">", prim__gt)
const le = code(core, "<=", prim__le)
const ge = code(core, ">=", prim__ge)
const eq0 = code(core, "0=", prim__eq0)
const lt0 = code(core, "0<", prim__lt0)
const store = code(core, "!", prim__store)
const fetch = code(core, "@", prim__fetch)
const branch = code(core, "branch", prim__branch)
const qbranch = code(core, "qbranch", prim__qbranch)
const r2d = code(core, "r>d", prim__r2d)
const d2r = code(core, "d>r", prim__d2r)
const comma = code(core, ",", prim__comma)
const decimal = code(core, "decimal", prim__decimal)
const literal = code(core, "literal", prim__literal)
const neq = code(coreext, "<>", prim__neq)
const neq0 = code(coreext, "0<>", prim__neq0)
const gt0 = code(coreext, "0>", prim__gt0)
const le0 = code(coreext, "0<=", prim__le0)
const ge0 = code(coreext, "0>=", prim__ge0)
const hex = code(coreext, "hex", prim__hex)
const entry = forth(web, "entry", [literal, 4, dup, mul])

kernel.ip = entry

while(kernel.memory[kernel.ip] != undefined){
	const op = kernel.memory[kernel.ip]
	op()
}
