	AREA     Fibonacci, CODE, READONLY
	 export __main	 
	 ENTRY 
__main  function
	          MOV r1 , #0  ;  1st number
	          MOV r2 , #1    ; 2nd number 
              MOV r4 , #10	   ;  nth number in the Fibonacci series
              SUB r5 , r4 ,#2
			  MOV r6 , #0	 ;  		  
              CMP r5 , r6
              IT EQ 
              BEQ STOP				  
			  
LOOP              ADD r3 , r2 , r1  ;R2 stores final value of nth number
                  MOV r1 ,r2
                  MOV r2 ,r3
				  ADD r6,r6, #1
                  CMP r5 ,r6
                  BNE LOOP					  
STOP		      B STOP  ; stop program
        endfunc
      end