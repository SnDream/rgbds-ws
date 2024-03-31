IF !DEF(W_CHARMAP_INC)
DEF W_CHARMAP_INC EQU 1

; 初始化Wide Charmap
; w_init length
; 定义一种charmap，长度为length。允许charmap的长度小于等于length

MACRO w_init
	PUSHC
	DEF W_PLANE_MAX = \1
	newcharmap w_length
	FOR i, 0, \1
		newcharmap w_plane_{d:i}
	ENDR
	POPC
ENDM

; 定义Wide Charmap
; w_charmap "text", $xx, $yy ...
; 定义w_charmap，类似于原生的charmap，但是支持多个参数

MACRO w_charmap
	PUSHC
	IF _NARG >= 2 && _NARG < W_PLANE_MAX + 2
		setcharmap w_length
		charmap \1, _NARG - 1
		FOR i, 0, W_PLANE_MAX
			setcharmap w_plane_{d:i}
			IF i < _NARG - 1
				DEF j = i + 2
				charmap \1, \<{d:j}>
			ELSE
				charmap \1, 0
			ENDC
		ENDR
	ELSE
		WARN "Define w_char failed."
	ENDC
	POPC
ENDM

; 使用Wide Charmap
; w_text "text"
; 用于替代原生的db "text"的写法

MACRO w_text
	PUSHC
	REPT _NARG
		setcharmap w_length
		FOR i, 1, charlen(\1) + 1
			setcharmap w_length
			DEF j = charsub(\1, i)
			IF j <= W_PLANE_MAX
				FOR k, 0, j
					setcharmap w_plane_{d:k}
					db charsub(\1, i)
				ENDR
			ELSE
				WARN strcat("Get w_char failed: ", charsub(\1, i))
			ENDC
		ENDR
		SHIFT
	ENDR
	POPC
ENDM

ENDC ; W_CHARMAP_INC
