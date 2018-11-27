 AREA     appcode, CODE, READONLY
   export __main  
   ENTRY
__main function
    MOV R7, #0X20000000; starting address where we write co-ordinate values of cross wire
    B GetOriginValues;
GetOriginValues  MOV R5,#15 ;X VALUE
                 MOV R6,#1         ;Y VALUE
B Gen_Cross_wire;

Gen_Cross_wire   MOV R0, #0; INTILIALIZE 
MOV R1, #240; VERTICAL LINE boundary

LOOPX   CMP R0,R1;Compare '0' and '240'  
        BLE LOOPX1;if R0 < 240 goto LOOP 
        B LOOP_INIT;else goto loop_init for horizontal line
LOOPX1  STR R5, [R7], #4;  STORING X CO-0ORDINATE. Incrementing by 4 bcz we can observe clearly the co-ordinates while debugging
        STR R0, [R7], #4;  STORING Y CO-0ORDINATE
ADD R0,R0,#1 ;Increment the counter variable 'R0' 
B LOOPX
LOOP_INIT  MOV R0, #0; INTILIALIZE 
MOV R1, #320; HORIZONTAL LINE boundary
            B LOOPY; 
LOOPY   CMP R0,R1;Compare '0' and '320'  
        BLE LOOPY1;if R0 < 320 goto LOOP 
        B DrawCrossWire;
LOOPY1  STR R0, [R7], #4; STORING X CO-0ORDINATE. Incrementing by 4 bcz we can observe clearly the co-ordinates while debugging
        STR R6, [R7], #4; STORING Y CO-0ORDINATE        
ADD R0,R0,#1 ;Increment the counter variable 'R0' 
B LOOPY
DrawCrossWire
        ; this function will be taken care of by the h/w
B Initialize_pixel_values;
Initialize_pixel_values
        LDR R2, =0X200011A0; starting address where pixel values are stored
MOV R5, #20;total number of pixels
MOV R6, #1; counter for initializing all pixels
B LOOP_Pixel_values;
LOOP_Pixel_values   CMP R6,R5; Compare 'r6' and 'r5'  
        BLE LOOP_Pixels;if R6 < 20 goto LOOP
B EncryptData_Init; call procedure for encrypting raw image

LOOP_Pixels STR R6, [R2], #1; each pixels is of 1 byte. So incrementing by 1
                ADD R6,R6,#1 ;Increment the pixel counter
                B LOOP_Pixel_values; 

EncryptData_Init
MOV R0, #0xAA; INITIAL KEY VALUE
MOV R6, #2; counter for iterating through all pixels
LDR R2, =0X200011A0; starting address where pixel values are stored
LDRB R1, [R2]; R1 IS LOADED WITH R2. R2 IS THE STARTTING ADDRESS OF RAW IMAGE
ADD R2,R2,#1 ;Increment the counter variable 'R0' 
EOR R4, R0, R1; R4=R0 EXOR R1
LDR R3, =0X200011C0; starting address from where we write encrypted values
STR R4, [R3], #1; STORING encrypted data to a location
B EncryptData;
 
EncryptData  CMP R6,R5; 
        BLE LoopEnc;
        B  Send_CRC; Error correction and detection

LoopEnc  LDRB R1, [R2]; R1 IS LOADED WITH R2. R2 IS THE STARTTING ADDRESS OF RAW IMAGE
ADD R2,R2,#1 ;Increment the counter variable 'R0' 
EOR R4, R4, R1; R4=R4 EXOR R1 
STR R4, [R3], #1; STORING encrypted data to a location
ADD R6,R6,#1 
B EncryptData;

Send_CRC 
; this function implements error correctioin and detection
B SendDataToNetwork;

SendDataToNetwork
B RcvDataFromNetwork;
; this function sends data through N/W..Taken care by others

RcvDataFromNetwork
        B Recv_CRC;
Recv_CRC 
        B DecryptData_Init;
DecryptData_Init
        LDR R3, =0X200011C0; starting address from where Encypted data is stored at this address
LDR R9, =0X200011E0; Decrypted data will be stored at this address
        MOV R6, #2; counter for iterating through all pixels
LDRB R1, [R3]; R1 IS LOADED WITH R3. R3 IS THE STARTTING ADDRESS OF encrypted RAW IMAGE
ADD R3,R3,#1 ;Increment base address by 1 
EOR R4, R1, R0; R4=R0 EXOR R1 (Initaial Key value)
STR R4, [R9], #1; STORING decrypted data to a location
B DecryptData;
DecryptData  CMP R6,R5; check if r6 is < no: of pixels
        BLE LoopDecrypt;
        B  stop; else stop

LoopDecrypt  LDRB R8, [R3]; R8 IS LOADED WITH encrypted data
ADD R3,R3,#1 ;Increment base address by 1  
EOR R4, R1, R8; R4=previous sample EXOR present sample 
STR R4, [R9], #1; STORING decrypted data to a location
ADD R6,R6,#1;
        MOV R1, R8; copying present sample to previous sample 
B DecryptData;    

stop    B stop 
        ENDFUNC 
END

