;;; filename : sa-code-words.inc
;;; copyright: (c) Simon Nielsen Knights <tauoverpi@yandex.com>
;;; license  : GPLv3
;;; synopsis : 64bit Forth system written in FASM
; vim: ft=fasm et
code   kernel.link.core,      "SYSCALL5",   syscall5,     8 ; (n5 n4 n3 n2 n1 sys -- x)
code   kernel.link.core,      "SYSCALL4",   syscall4,     8 ; (n4 n3 n2 n1 sys -- x)
code   kernel.link.core,      "SYSCALL3",   syscall3,     8 ; (n3 n2 n1 sys -- x)
code   kernel.link.core,      "SYSCALL2",   syscall2,     8 ; (n2 n1 sys -- x)
code   kernel.link.core,      "SYSCALL1",   syscall1,     8 ; (n1 sys -- x)
code   kernel.link.core,      "SYSCALL0",   syscall0,     8 ; (sys -- x)
code   kernel.link.core,      "LITERAL",    literal,      7 ; ( -- n)
code   kernel.link.core,      "DROP",       drop,         4 ; (x -- )
code   kernel.link.core,      "SWAP",       swap,         4 ; (x y -- y     x)
code   kernel.link.core,      "DUP",        dup_,         3 ; (x -- x x)
code   kernel.link.core,      "?DUP",       qdup,         4 ; (x -- x | x x)
code   kernel.link.core,      "2DUP",       twodup,       4 ; (x y -- x y x y)
code   kernel.link.core,      "ROT",        rot,          3 ; (x y z -- y z x)
code   kernel.link.core,      "-ROT",       nrot,         3 ; (x y z -- z x y)
code   kernel.link.core,      "OVER",       over,         4 ; (x y -- x y x)
code   kernel.link.core,      "+",          plus,         1 ; (n n -- n)
code   kernel.link.core,      "-",          minus,        1 ; (n n -- n)
code   kernel.link.core,      "*",          mult,         1 ; (n n -- n)
code   kernel.link.core,      "/MOD",       divmod,       4 ; (n n -- n n)
code   kernel.link.core,      "1+",         increment,    2 ; (n -- n)
code   kernel.link.core,      "1-",         decrement,    2 ; (n -- n)
code   kernel.link.core,      "AND",        and_,         3 ;
code   kernel.link.core,      "OR",         or_,          3 ;
code   kernel.link.core,      "XOR",        xor_,         3 ;
code   kernel.link.core,      "INVERT",     not_,         6 ;
code   kernel.link.core,      "RSHIFT",     rshift,       6 ;
code   kernel.link.core,      "LSHIFT",     lshift,       6 ;
code   kernel.link.core,      "ROR",        ror_,         3 ;
code   kernel.link.core,      "ROL",        rol_,         3 ;
code   kernel.link.core,      "!",          store_,       1 ; (x addr -- )
code   kernel.link.core,      "C!",         cstore,       2 ; (c addr -- )
code   kernel.link.core,      "2!",         twostore,     2 ; (x x addr -- )
code   kernel.link.core,      "+!",         plusstore,    2 ; (n addr -- )
code   kernel.link.core,      "-!",         minusstore,   2 ; (n addr -- )
code   kernel.link.core,      "@",          fetch,        1 ;
code   kernel.link.core,      "C@",         cfetch,       2 ;
code   kernel.link.core,      "2@",         twofetch,     2 ;
code   kernel.link.core,      "BRANCH",     branch,       6 ;
code   kernel.link.core,      "?BRANCH",    qbranch,      7 ;
code   kernel.link.core,      "R>",         r2d,          2 ;
code   kernel.link.core,      ">R",         d2r,          2 ;
code   kernel.link.core,      ",",          comma,        1 ;
code   kernel.link.core,      "C,",         ccomma,       2 ;
code   kernel.link.core,      "KEY",        key,          3 ;
code   kernel.link.core,      "EMIT",       emit,         4 ;
code   kernel.link.core,      "WORD",       word_,        4 ;
code   kernel.link.core,      "DECIMAL",    decimal,      7 ;
code   kernel.link.core,      "TYPE",       type,         4 ;
code   kernel.link.core,      "SOURCE",     source,       6 ;
code   kernel.link.core,      "=",          eq_,          1 ;
code   kernel.link.core,      "<=",         le,           2 ;
code   kernel.link.core,      "<",          lt,           1 ;
code   kernel.link.core,      ">=",         ge,           2 ;
code   kernel.link.core,      ">",          gt,           1 ;
code   kernel.link.core,      "0=",         zeq,          2 ;
code   kernel.link.core,      "0<",         zlt,          2 ;
code   kernel.link.core,      "CELL",       cell,         4 ;
code   kernel.link.core,      "CELL+",      cellplus,     4 ;
code   kernel.link.core,      "HERE",       here,         4 ;
code   kernel.link.core,      "STATE",      state,        5 ;
code   kernel.link.core,      "S0",         s0,           2 ;
code   kernel.link.core,      "LATEST",     latest,       6 ;
if wordlist.coreext eq true
  code   kernel.link.coreext,   "PICK",       pick,         4 ; (n -- x)
  code   kernel.link.coreext,   "HEX",        hex,          3 ;
  code   kernel.link.coreext,   "<>",         neq,          2 ;
  code   kernel.link.coreext,   "0<>",        zneq,         3 ;
  code   kernel.link.coreext,   "0<=",        zle,          3 ;
  code   kernel.link.coreext,   "0>=",        zge,          3 ;
  code   kernel.link.coreext,   "0>",         zgt,          2 ;
end if
if wordlist.double eq true
  code   kernel.link.double,   "2LITERAL",   twoliteral,   8 ;
  code   kernel.link.double,   "DPLUS",      dplus,        5
end if
if wordlist.except eq true
  code   kernel.link.except,    "CATCH",      catch,        5 ;
  code   kernel.link.except,    "THROW",      throw,        5 ;
  code   kernel.link.except,    "ABORT",      abort,        5 ;
  code   kernel.link.except,    'ABORT"',     abort_str,    6 ;
end if
