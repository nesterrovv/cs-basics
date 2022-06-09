		ORG 0x584	;Program start address
ADDR:		WORD $RES	;Link to result
MEM:		NOP		;Cell to write odd characters
START:		CLA		;Accumulator cleaning
S1:		IN 0x5		;Waiting for odd character input
		AND #0x40	;Check for the entered character
		BEQ S1		;None - "Spin Loop"
		IN 0x4		;Output byte to AC
		OUT 0x6		;Output byte to ED-3
		ST (ADDR)	;Save character to result
		ST $MEM		;Save character to "cache"
		CMP #0x00	;Check for a stop character
		BEQ EXIT	;If stop character is an exit
		CLA		;Accumulator cleaning
S2:		IN 0x5		;Waiting for even character input
		AND #0x40	;Check for the entered character
		BEQ S2		;None - "Spin Loop"
		IN 0x4		;Output byte to AC
		OUT 0x6		;Output byte to ED-3
		SWAB		;Move even character to high byte
		OR $MEM		;Match with 1st character
		ST (ADDR)	;Save to memory with auto-increment links
		SUB $MEM	;Subtract 1st character
		SWAB		;Move even character to low byte
		CMP #0x00	;Check for a stop character
		BEQ EXIT	;If stop character is an exit
		LD (ADDR)+	;Increment the link to the result
		CLA		;Accumulator cleaning
		JUMP S1		;Return to the beginning of the loop
EXIT:		LD (ADDR)+	;Increment link to result
		CLA		;Accumulator cleaning
		HLT		;Stop program
		ORG 0x5AC	;Address to start storing the result
RES:		NOP
