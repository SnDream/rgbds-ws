IF !DEF(MACROS_INC)
DEF MACROS_INC EQU 1

; 

MACRO lb ; r, hi, lo
	ld \1, ((\2) & $ff) << 8 | ((\3) & $ff)
ENDM

; 简单定义 db dw的方法，一般用于编写地址

MACRO dbw
	db \1
	dw \2
ENDM

; 简单定义符号位置的方法

MACRO dba
	db BANK(\1)
	dw \1
ENDM

ENDC ; MACROS_INC
