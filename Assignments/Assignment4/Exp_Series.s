        AREA    |.text|,CODE,READONLY
        EXPORT __main
        ENTRY
__main    FUNCTION
        MOV R0,#6;total terms 'n' in series
        MOV R1,#1;Counting Variable 'i'
        VLDR.F32 S1,=1;Holds final sum 's'
        VLDR.F32 S2,=1;Temp Variable 't'
        VLDR.F32 S3,=0;Holds x value
LOOP1    CMP R1,R0;Compare 'i' and 'n' 
        BLE LOOP;if i < n branch to LOOP
        B stop;else branch to stop
LOOP      VMUL.F32 S2,S2,S3; t = t*x
        VMOV.F32 S5,R1;Move the binarynumber in R1('i') to S5(floating point register)
        VCVT.F32.U32 S5,S5;Convert the binarynumber into unsigned fp Number 32 bit
        VDIV.F32 S2,S2,S5;Divide t by 'i' and store it back in 't'
        VADD.F32 S1,S1,S2;Finally add 's' to 't' and store it in 's'
        ADD R1,R1,#1;Increment the counter variable 'i'
        B LOOP1;Again branch to comparision
stop    B stop
        ENDFUNC
    END
