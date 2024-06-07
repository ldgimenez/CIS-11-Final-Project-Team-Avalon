.ORIG x3000              ; Start of program

; ------------- Main Program -------------

MAIN
    LD R1, SCORES_START_1   ; Load address of first score into R1
    AND R2, R2, #0          ; Initialize SUM to 0
    LD R3, MIN_INIT         ; Initialize MIN with a large value
    LD R4, MAX_INIT         ; Initialize MAX with a small value
    LD R5, #5               ; Initialize COUNT to 5

    ; Input Loop (Subroutine Call)
    JSR GET_SCORES

    ; Calculate Average (Subroutine Call)
    JSR CALCULATE_AVERAGE

    ; Determine Letter Grade (Subroutine Call)
    JSR DETERMINE_GRADE

    ; Display Results (Subroutine Call)
    JSR DISPLAY_RESULTS

    HALT                  ; End program

; ------------- Subroutines -------------

GET_SCORES

    ST R7, SAVE_R7        ; Save R7 (return address)

    LEA R0, PROMPT        ; Load address of prompt message
    PUTS                  ; Display prompt

    LD R6, #5             ; Initialize loop counter (5 scores)
INPUT_LOOP
    GETC                  ; Get character input (score)
    OUT                   ; Echo character to console

    LD R0, NEWLINE        ; Load newline character
    OUT                   ; Display newline

    ADD R0, R1, #0        ; Get address to store score (R0 = R1)
    STR R0, R1, #0        ; Store score at current address

    ADD R2, R2, R0        ; Add score to SUM (R2 += R0)

    ; Check if score is new MIN or MAX
    NOT R0, R0            ; Negate score for comparison
    ADD R0, R0, #1        ; Add 1 (two's complement)
    ADD R0, R0, R3        ; Compare with MIN (R0 = R3 - score)
    BRzp SKIP_MIN_UPDATE  ; If R0 >= 0, score is not smaller than MIN
    ADD R3, R0, #0        ; Update MIN (R3 = score)
SKIP_MIN_UPDATE

    NOT R0, R0            ; Negate score again for comparison
    ADD R0, R0, #1        ; Add 1 (two's complement)
    ADD R0, R0, R4        ; Compare with MAX (R0 = R4 - score)
    BRnz SKIP_MAX_UPDATE  ; If R0 != 0, score is not larger than MAX
    ADD R4, R0, #0        ; Update MAX (R4 = score)

SKIP_MAX_UPDATE

    ADD R1, R1, #1        ; Move to next score address
    ADD R6, R6, #-1       ; Decrement loop counter
    BRp INPUT_LOOP        ; If R6 > 0, get next score

    LD R7, SAVE_R7        ; Restore R7
    RET                   ; Return from subroutine



CALCULATE_AVERAGE

    ST R7, SAVE_R7        ; Save R7 (return address)

    LD R6, #5             ; Load divisor (5)
    STR R2, R2, #2        ; Right shift SUM by 2 to divide by 4
    ADD R2, R2, R2        ; Add SUM to itself to get /2
    ADD R2, R2, R2        ; Add SUM to itself to get /1 
    
    LD R7, SAVE_R7        ; Restore R7
    RET                   ; Return (AVERAGE is in R2)






DETERMINE_GRADE

ST R7, SAVE_R7		; Save R7 (return address)

ADD R0, R2, #0		; Copy AVERAGE(R2) into R0

ADD R0, R0,  #15	; Load #-90 into R0  w/2’s complement and check avg >=90
ADD R0, R0,  #15
ADD R0, R0,  #15
ADD R0, R0,  #15
ADD R0, R0,  #15
ADD R0, R0,  #15
NOT R0, R0
BRzp	GRADE_A		; Branches to GRADE_A

ADD R0, R0,  #15	; Load #-80 into R0  w/2’s complement and check avg >=80
ADD R0, R0,  #15
ADD R0, R0,  #15
ADD R0, R0,  #15
ADD R0, R0,  #15
ADD R0, R0,  #5
NOT R0, R0
BRzp	GRADE_B		; Branches to GRADE_B

ADD R0, R0, #15		; Load #-70 into R0  w/2’s complement and check  avg >=70
ADD R0, R0, #15
ADD R0, R0, #15
ADD R0, R0, #15
ADD R0, R0, #5
NOT R0, R0
BRzp GRADE_C		; Branches to GRADE_C

ADD R0, R0, #15		; Load #-60 into R0  w/2’s complement and check  avg >=60
ADD R0, R0, #15 
ADD R0, R0, #15
ADD R0, R0, #15
NOT R0, R0
BRzp	GRADE_D		; Branches to GRADE_D

LD R0, LETTER_GRADE_F
ST R0, LETTER_GRADE

LD R7, SAVE_R7     	; Restore R7
RET                 	; Return 



GRADE_A
	LD R0, LETTER_GRADE_A		;Loads grade A into R0
	ST R0, LETTER_GRADE		;Store grade in LETTER_GRADE
	RET

GRADE_B
	LD R0, LETTER_GRADE_B		;Loads grade B into R0
	ST R0, LETTER_GRADE		;Store grade in LETTER_GRADE
	RET

GRADE_C
	LD R0, LETTER_GRADE_C		;Loads grade C into R0
	ST R0, LETTER_GRADE		;Store grade in LETTER_GRADE
	RET

GRADE_D
	LD R0, LETTER_GRADE_D		;Loads grade D into R0
	ST R0, LETTER_GRADE		;Store grade in LETTER_GRADE
	RET

GRADE_F
	LD R0, LETTER_GRADE_F		;Loads grade F into R0
	ST R0, LETTER_GRADE		;Store grade in LETTER_GRADE
	RET



DISPLAY_RESULTS

;MIN result
LEA R0, MIN_RESULT 	; Loads address of Min
PUTS			; Display 
LDR R0, R3		; Loads min score from R3
OUT			; Display Min


;Max result
LEA R0, MAX_RESULT 	; Loads address of Max
PUTS			; Display 
LDR R0, R4		; Loads max score from R4
OUT 			; Display Max                                         

;Average result
LEA R0, AVG_RESULT 	; Loads address of Max
PUTS			; Display 
LDR R0, R2	 	; Loads avg score from R2
OUT 			; Display Average 

;Grade result
LEA R0, GRD_RESULT 	; Loads address of Grade
PUTS			; Display 
LDR R0, LETTER_GRADE	; Loads letter grade
OUT 			; Display Grade 

LD R7, SAVE_R7     	; Restore R7
RET                  	; Return 




; ------------- Data Section -------------

SCORES_START_1 .FILL x4000      	; Address of first score
SCORES_START_2 .FILL x4001
SCORES_START_3 .FILL x4002
SCORES_START_4 .FILL x4003
SCORES_START_5 .FILL x4004
MIN_INIT       .FILL xFF        	; High initial value
MAX_INIT       .FILL x00        	; Low initial value

SAVE_R7        .BLKW #1        		; Space to save R7
PROMPT         .STRINGZ "Enter 5 scores:\n"
NEWLINE        .FILL x0A

LETTER_GRADE_A	.FILL x41	    	; ASCII x code for letters A-F
LETTER_GRADE_B	.FILL x42
LETTER_GRADE_C	.FILL x43
LETTER_GRADE_D	.FILL x44
LETTER_GRADE_F	.FILL x46
LETTER_GRADE 	.BLKW 		    	; Space for letter grade

MIN_RESULT	.STRINGZ "Min: " 	; Display Min result
MAX_RESULT	.STRINGZ "Max: " 	; Display Max result
AVG_RESULT	.STRINGZ "Avg: " 	; Display Average result
GRD_RESULT	.STRINGZ "Grade: " 	; Display Letter Grade result


.END

