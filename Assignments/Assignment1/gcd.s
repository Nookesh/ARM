  AREA     GCD, CODE, READONLY
	 export __main	 
	 ENTRY 
__main  function
	          MOV r0 , #25	  ; 1st numbeer		
			  MOV r1 , #10    ; 2nd number
LOOP			  CMP r0 , r1
              IT EQ 
              BEQ STOP	
              ITE HI			  
			  SUBHI r0 , r0 , r1 			  
			  SUBLS r1 , r1 , r0
              B LOOP			  
STOP		      B STOP  ; stop program
        endfunc
      end