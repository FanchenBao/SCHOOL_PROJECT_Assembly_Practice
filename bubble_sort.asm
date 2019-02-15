;R6 stores the address to the array. The first element of the array is its size, followed by the actual elements.
;Sorting is done in place. 

SORT
			clr.w	R5				; R5 is the counter for outerloop, start from 0 counting up
			mov.b	@R6, R10		; R10 is the outerloop boundary, counting from n - 1 down
			dec		R10				; R10 = n - 1
OUTLP		mov.w	R6, R8			; copy R6 to R8 to preserve R6
			mov.b	@R8+, R7		; R7 is the counter for innerloop
			sub.b	R5, R7			; counting from n - 1 - R5 down
			dec		R7
INLP		cmp.b	@R8+, 0(R8)		; compare the adjacent array element values R6[n] and R6[n+1]
			jge		SKIP			; if R6[n+1] >= R6[n], skip the swap
			mov.b	@R8, R9			; R9 is temp. temp = R6[n+1]
			mov.b	-1(R8), 0(R8)	; R6[n+1] = R6[n]
			mov.b	R9, -1(R8)		; R6[n] = temp
SKIP		dec		R7				; R7--
			jnz		INLP
			inc		R5				; R5++, after each innerloop
			dec		R10				; R10--
			jnz		OUTLP
			ret