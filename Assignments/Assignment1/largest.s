     AREA     appcode, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION	
         ;first number
         MOV r1 , #88 
		 ;second number
         MOV r2 , #53 
		 ;third number
         MOV r3 , #12 
         CMP r1 , r2
         IT HI
         MOVHI r2 , r1
		 CMP r2 , r3
         IT HI
         MOVHI r3 , r2
		 ; moving final result in r4
         MOV r4 , r3
STOP B STOP ; stop program
    endfunc
    end