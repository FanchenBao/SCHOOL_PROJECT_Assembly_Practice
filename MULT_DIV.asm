;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
;			mov.b	#127, R4					; initialize R4
;			mov.b	#1, R5					; initialize R5
;			call	#MULT					; do R4 x R5 --> &0x020A
;			mov.b	#0, R4					; initialize R4
;			mov.b	#127, R5					; initialize R5
;			call	#MULT					; do R4 x R5 --> &0x020A
;			mov.b	#11, R4					; initialize R4
;			mov.b	#11, R5					; initialize R5
;			call	#MULT					; do R4 x R5 --> &0x020A
;			mov.b	#-5, R4					; initialize R4
;			mov.b	#2, R5					; initialize R5
;			call	#MULT					; do R4 x R5 --> &0x020A
;			mov.b	#-2, R4					; initialize R4
;			mov.b	#-5, R5					; initialize R5
;			call	#MULT					; do R4 x R5 --> &0x020A
;			mov.b	#-1, R4					; initialize R4
;			mov.b	#-127, R5					; initialize R5
;			call	#MULT					; do R4 x R5 --> &0x020A
;			mov.b	#1, R4					; initialize R4
;			mov.b	#-128, R5					; initialize R5
;			call	#MULT					; do R4 x R5 --> &0x020A


			mov.b	#127, R6
			mov.b	#1, R5
			call	#DIV					; do R6 / R5 --> &0x021F
			mov.b	#4, R6
			mov.b	#34, R5
			call	#DIV					; do R6 / R5 --> &0x021F
			mov.b	#0, R6
			mov.b	#15, R5
			call	#DIV					; do R6 / R5 --> &0x021F
			mov.b	#12, R6
			mov.b	#3, R5
			call	#DIV					; do R6 / R5 --> &0x021F
			mov.b	#17, R6
			mov.b	#6, R5
			call	#DIV					; do R6 / R5 --> &0x021F
			mov.b	#113, R6
			mov.b	#7, R5
			call	#DIV					; do R6 / R5 --> &0x021F
MAIN		jmp		MAIN

; The following MULT subroutine supports multiplication of 8-bit signed integer R4 * R5.
; The major concept is to repeated addition. Iteration is based on the smaller value of R4 and R5
; NOTE: overflow is NOT handled in this subroutine. User must supply multiplicants that will not cause overflow.
MULT		clr		R7						; R7 = 0, R7 records the product of R5 * R4 throughout multiplication process
			mov.b	#8, R6					; R6 is counter
			and.w	#00FFh, R5				; clear higher bytes of R5 and R4
			and.w	#00FFh, R4
LOOP		rrc.b	R5						; R5 /= 2
			jnc		EVEN					; If R5 was even before, skip the next addition
			add.b	R4, R7					; if R5	was odd before, do the addition
EVEN		rla.b	R4						; R4 *= 2
			dec.b	R6						; counter--
			jnz		LOOP
STORE1		mov.b	R7, &0x020A				; store result in 0x020A
END			ret


; The following DIV subroutine support integer division of 8-bit positive int R6 / R5.
; Algorithm is based on shift and subtract. Basically, the idea is to get R5 as big as possible but still smaller
; than R6 using left shift. Then do R6 - R5 and then shift R5 back one bit at a time. If there is enough R6 to subtract
; R5, then the quotient has 1 at that bit, else 0. When R5 completely shifts back to the beginning, the quotient is derived.
; To keep track whether R6 has enough R5 to subtract at each right shift, a separate R8 is used. It serves two purposes:
; 1. It keeps track how many times R5 has shifted left, so it can shift the same number of times to the right.
; 2. It keeps shifting with R5, thus when R6 has enough R5 to subtract, the 1 in R8 is at the correct bit position. So add R8
; to the result R7, we can keep track the quotient.
; Note that overflow and arithmetic error in division
; are not notified in the subroutine. User is responsible for not generating overflow or arithmetic error.
DIV			clr		R7						; R7 = 0, R7 records the product of R6 / R5 throughout division process
			mov.b	#1, R8					; R8 stores the temporary quotient result, and helps determine how many times R5 needs to shift back
			and.w	#00FFh, R5				; clear higher bytes of R5 and R6
			and.w	#00FFh, R6
SHIFTL		rla.b	R5						; R5 left shifts to make it bigger than R6
			rla.b	R8						; R8 left shifts with R5
			bit		#40h, R5				; check whether R5 is about to overflow (test bit6)
			jnz		SHIFTR					; if bit6 of R5 is set, R5 has reached the max, no more doubling
			cmp.b	R5, R6					; R6 >= R5 ?
			jhs		SHIFTL					; R6 > R5, keep doubling R5
SHIFTR		cmp.b	R5, R6					; R6 < R5 ?
			jlo		SKIP					; R6 < R5, cannot subtract current R5 from R6
			sub.b	R5, R6					; R6 >= R5, then do R6 - R5 -> R6
			add.b	R8, R7					; add temporary quotient to R7
SKIP		rra.b	R5						; shifting R5 right bit by bit
			rra.b	R8						; R8 shifts right with R5
			tst.b	R8						; R8 == 0?
			jne		SHIFTR					; R8 > 0, still more to shift back
STORE2		mov.b	R7, &0x021F				; store result in 0x020A
END2		ret
;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
