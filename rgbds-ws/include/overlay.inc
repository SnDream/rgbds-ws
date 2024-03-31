IF !DEF(OVERLAY_INC)
DEF OVERLAY_INC EQU 1

; 定义偏移量
; 用法 org 地址 [BANK号]
; 后续的代码将从定义的位置开始编写

MACRO org
	if \1 < $4000
		section "org_\1", rom0[\1]
	elif \1 < $8000
	if _NARG >= 2
		section "org_\1_\2", romx[\1], bank[\2]
	else
		section "org_\1", romx[\1], bank[1]
	endc
	elif \1 < $a000
	if _NARG >= 2
		section "org_\1_\2", vram[\1], bank[\2]
	else
		section "org_\1", vram[\1], bank[0]
	endc
	elif \1 < $c000
		section "org_\1", sram[\1]
	elif \1 < $d000
		section "org_\1", wram0[\1]
	elif \1 < $e000
	if _NARG >= 2
		section "org_\1_\2", wramx[\1], bank[\2]
	else
		section "org_\1", wramx[\1], bank[1]
	endc
	elif \1 >= $ff80
		section "org_\1", hram[\1]
	endc
endm

; 清除代码
; 从当前位置开始，直到特定位置（不包含），设置为0x00

MACRO cleartill
	REPT \1 - @
		nop
	ENDR
ENDM

ENDC ; OVERLAY_INC
