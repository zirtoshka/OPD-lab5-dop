ORG		0x0
NUMBER:			WORD		0x0000
MASK:			WORD		0x00FF
MASK_M:			WORD		0x7FFF
TO_ADD:			WORD		0x170
MASK_R:			WORD		0xCFCF			;маска чтобы не выводить 00
STATUS_M:			WORD 	0x0003			;для проверки больших секунд
F_ZERO:			WORD		0x0001			;для проверки первого нуля при выводе	
BIG:				WORD		0x0000
LITTLE:			WORD		0x0000
HOUR:			WORD		0xE10				;ОДИН ЧАС В СЕКУНДАХ
MINUTE:			WORD		0x3C				;одна минута в секцндах
DECI:       		WORD  	0xA				;десять в секундах
RES:				WORD		0x0000			;формируется ответ
HOURS:			WORD		0x0000
MINUTES:			WORD		0x0000
SEC:				WORD		0x0000		
START:			CLA
				OUT 		12
				ST		HOURS
				ST		SEC	
				ST		MINUTES
				ST		RES
				ST 		STATUS_M
S1:				IN		7
				AND		#0x40
				BEQ		S1
				IN		6
				AND		MASK
				SWAB	
				ST		BIG
S2:				IN		7
				AND		#0x40
				BEQ		S2
				IN		6
				AND		MASK
				ST		LITTLE
N:				CLA
				LD		BIG
				ADD		LITTLE
				ST			NUMBER
				BPL		H
H_MI:			LD			STATUS_M
				SUB		#0x20
				ST 			STATUS_M
				LD			#0x9
				ST			HOURS
				LD			NUMBER
				AND		MASK_M
				ST			NUMBER
H:        		LD			NUMBER
				SUB		HOUR
				CMP		#0x0
				BGE		H_CO
				JUMP		M_1
H_CO:			ST			NUMBER
				LD			HOURS
				INC
				ST			HOURS
				JUMP		H
M_1:				LD		STATUS_M
				BPL	M							
				ld		NUMBER
				add		TO_ADD
				st			NUMBER	
M:				LD			NUMBER
				SUB		MINUTE
				CMP		#0x0
				BGE		M_CO
				JUMP		S
M_CO:			LD			NUMBER
				SUB		MINUTE
				ST			NUMBER
				LD			MINUTES
				INC
				ST			MINUTES
				JUMP		M
S:				LD			NUMBER
				ADD		SEC
				ST			SEC
CHECK_MIN:		LD			STATUS_M
				BPL		D_H	
				LD			MINUTES
				SUB		MINUTE
				CMP		#0x0
				BGE		CH
				JUMP		D_H
CH:				LD			MINUTES
				SUB		MINUTE
				ST			MINUTES
				LD			HOURS
				INC		
				ST 			HOURS
D_H:			
				LD			HOURS
				CMP		DECI
				BLT		HH
				LD			HOURS
				SUB		DECI
				ST			HOURS
				LD			RES
				INC
				ST			RES
				JUMP		D_H
HH:				LD			RES
				ST			F_ZERO 
				OR			#0x30
				SWAB
				OR			#0x30
				ADD   		HOURS
				ST			RES
				AND    	MASK_R
				beq		D_M 			;checking zero
				LD			F_ZERO
				BEQ		H_OUT2
H_OUT1:			IN			13	
				AND		#0x40
				BEQ		H_OUT1
				LD			RES
				SWAB
				OUT		12
H_OUT2:			IN			13	
				AND		#0x40
				BEQ		H_OUT2
				LD			RES
				OUT		12	
H_OUT:			IN			13	
				LD			#0x40
				BEQ		H_OUT
				LD			#0xDE
				OUT		12		
				CLA		
				ST 			$RES		
D_M:				CLA
				ST			$RES	
D_MM:  			LD			MINUTES
				CMP		$DECI
				BLT		MM
				LD			$MINUTES
				SUB		$DECI
				ST			$MINUTES
				LD			$RES
				INC
				ST			$RES
				JUMP		D_MM
MM:				LD			$RES
				st			$F_ZERO 
				OR			#0x30
				SWAB
				OR			#0x30
				ADD        $MINUTES
				ST			$RES
				AND    	$MASK_R
				beq		D_S					 ;checking zero
				LD			$F_ZERO
				BEQ		M_OUT2
M_OUT1:			IN			13	
				AND		#0x40
				BEQ		M_OUT1
				LD			$RES
				SWAB
				OUT		12
M_OUT2:			IN			13	
				AND		#0x40
				BEQ		M_OUT2
				LD			$RES
				OUT		12	
				CLA
				ST			$RES
M_OUT:			IN			13	
				LD			#0x40
				BEQ		M_OUT
				LD			#0xCD
				OUT		12	
D_S:				CLA
				ST			$RES
D_SSS: 			LD           $SEC
				CMP		$DECI
				BLT		SS
				LD			$SEC
				SUB		$DECI
				ST			$SEC
				LD			$RES
				INC
				ST			$RES
				JUMP		D_SSS
SS:				LD			$RES
				st			$F_ZERO 
				OR			#0x30
				SWAB
				OR			#0x30
				ADD        $SEC
				ST			$RES
				AND   	 	$MASK_R
				beq		FINISH 			;checking zero
				LD			$F_ZERO
				BEQ		S_OUT2
S_OUT1:			IN			13	
				AND		#0x40
				BEQ		S_OUT1
				LD			$RES
				SWAB
				OUT		12
S_OUT2:			IN			13	
				AND		#0x40
				BEQ		S_OUT2
				LD			$RES
				OUT		12	
S_OUT:			IN			13	
				LD			#0x40
				BEQ		S_OUT
				LD			#0xD3
				OUT		12	
FINISH:			HLT
