;Factorial subroutine takes 16-bit number n form R5 and compute and save n! in R6
;Assume value of R5 needs to be preserved after subroutine call
FACTO
			push.w	R5			; temporarily store R5
			tst		R5
			jnz		LOOP		; R5 != 0, enter the factorial loop
			mov.w	#1, R6		; R5 = 0, its factorial is 1, store in R6
			jmp		FACTOend	; end subroutine
LOOPF		dec 	R5			; R5--
			jz		FACTOend	; when R5 reaches 0, factorial ends
			call	#MULT		; R5 x R6 --> R6
			jmp		LOOPF
FACTOend	pop.w	R5
			ret



; The following MULT subroutine supports multiplication of 16-bit signed integer R5 * R6.
; The major concept is to repeated addition.
; NOTE: overflow is NOT handled in this subroutine. User must supply multiplicants that will not cause overflow.
MULT		clr.w 	R8						; R8 = 0, temporarily stores the product
			mov.w	#16, R7					; R7 is counter
LOOPM		rrc.w	R5						; R5 /= 2
			jnc		EVEN					; If R5 was even before, skip the next addition
			add.w	R6, R8					; if R5	was odd before, do the addition
EVEN		rla.b	R6						; R6 *= 2
			dec.b	R7						; counter--
			jnz		LOOPM
STORE		mov.b	R8, R6					; store result in R6
END			ret
