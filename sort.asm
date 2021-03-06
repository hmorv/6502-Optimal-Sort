;SORTING SUBROUTINE
;
; INPUT:
;ZPADD  - START ADDRESS OF SEQUENCE TO BE SORTED SHALL BE PUT IN ZPADD, ZPADD+1 (ZERO PAGE)
;         SHOULD POINT TO THE BYTE JUST BEFORE THE FIRST BYTE TO BE SORTED
;         ( "LDA (ZPADD),Y" WITH 1<=Y<=255)
;NVAL   - NUMBER OF VALUES,  1<= NVAL <= 255
;         VALUE WILL BE DESTROYED (SET TO ZERO)
;
ZPADD  = $30            ;2 BYTE POINTER IN PAGE ZERO. SET BY CALLING PROGRAM
NVAL   = $32            ;SET BY CALLING PROGRAM
WORK1  = $33            ;3 BYTES USED AS WORKING AREA
WORK2  = $34   
WORK3  = $35
        *=$6000         ;CODE ANYWHERE IN RAM OR ROM
SORT LDY NVAL           ;START OF SUBROUTINE SORT
     LDA (ZPADD),Y      ;LAST VALUE IN (WHAT IS LEFT OF) SEQUENCE TO BE SORTED
     STA WORK3          ;SAVE VALUE. WILL BE OVER-WRITTEN BY LARGEST NUMBER
     BRA L2
L1   DEY
     BEQ L3
     LDA (ZPADD),Y
     CMP WORK2
     BCC L1
L2   STY WORK1          ;INDEX OF POTENTIALLY LARGEST VALUE
     STA WORK2          ;POTENTIALLY LARGEST VALUE
     BRA L1
L3   LDY NVAL           ;WHERE THE LARGEST VALUE SHALL BE PUT
     LDA WORK2          ;THE LARGEST VALUE
     STA (ZPADD),Y      ;PUT LARGEST VALUE IN PLACE
     LDY WORK1          ;INDEX OF FREE SPACE
     LDA WORK3          ;THE OVER-WRITTEN VALUE
     STA (ZPADD),Y      ;PUT THE OVER-WRITTEN VALUE IN THE FREE SPACE
     DEC NVAL           ;END OF THE SHORTER SEQUENCE STILL LEFT
     BNE SORT           ;START WORKING WITH THE SHORTER SEQUENCE
     RTS
