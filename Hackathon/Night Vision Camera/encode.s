
  PRESERVE8
     THUMB
     AREA     appcode, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION
	
	LDR	R1, =0xAC

	; Begin by expanding the 8-bit value to 12-bits, inserting
	; zeros in the positions for the four check bits (bit 0, bit 1, bit 3
	; and bit 7).
	
	AND	R2, R1, #0x1		; Clear all bits apart from d0
	MOV	R0, R2, LSL #2		; Align data bit d0
	
	AND	R2, R1, #0xE		; Clear all bits apart from d1, d2, & d3
	ORR	R0, R0, R2, LSL #3	; Align data bits d1, d2 & d3 and combine with d0
	
	AND	R2, R1, #0xF0		; Clear all bits apart from d3-d7
	ORR	R0, R0, R2, LSL #4	; Align data bits d4-d7 and combine with d0-d3
	
	; We now have a 12-bit value in R0 with empty (0) check bits in
	; the correct positions
	

	; Generate check bit c0
	
	EOR	R2, R0, R0, LSR #2	; Generate c0 parity bit using parity tree
	EOR	R2, R2, R2, LSR #4	; ... second iteration ...
	EOR	R2, R2, R2, LSR #8	; ... final iteration
	
	AND	R2, R2, #0x1		; Clear all but check bit c0
	ORR	R0, R0, R2		; Combine check bit c0 with result
	
	; Generate check bit c1
	
	EOR	R2, R0, R0, LSR #1	; Generate c1 parity bit using parity tree
	EOR	R2, R2, R2, LSR #4	; ... second iteration ...
	EOR	R2, R2, R2, LSR #8	; ... final iteration
	
	AND	R2, R2, #0x2		; Clear all but check bit c1
	ORR	R0, R0, R2		; Combine check bit c1 with result
	
	; Generate check bit c2
	
	EOR	R2, R0, R0, LSR #1	; Generate c2 parity bit using parity tree
	EOR	R2, R2, R2, LSR #2	; ... second iteration ...
	EOR	R2, R2, R2, LSR #8	; ... final iteration
	
	AND	R2, R2, #0x8		; Clear all but check bit c2
	ORR	R0, R0, R2		; Combine check bit c2 with result	
	
	; Generate check bit c3
	
	EOR	R2, R0, R0, LSR #1	; Generate c3 parity bit using parity tree
	EOR	R2, R2, R2, LSR #2	; ... second iteration ...
	EOR	R2, R2, R2, LSR #4	; ... final iteration
	
	AND	R2, R2, #0x80		; Clear all but check bit c3
	ORR	R0, R0, R2		; Combine check bit c3 with result
	
stop B stop ; stop program
     ENDFUNC
     END
