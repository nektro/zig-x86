const std = @import("std");
const x86 = @import("./mod.zig");

pub const Mnemonic = enum {
    // AAA—ASCII Adjust After Addition
    // AAD—ASCII Adjust AX Before Division
    // AAM—ASCII Adjust AX After Multiply
    // AAS—ASCII Adjust AL After Subtraction
    // ADC—Add With Carry
    // ADCX—Unsigned Integer Addition of Two Operands With Carry Flag
    // ADD—Add
    // ADDPD—Add Packed Double Precision Floating-Point Values
    // ADDPS—Add Packed Single Precision Floating-Point Values
    // ADDSD—Add Scalar Double Precision Floating-Point Values
    // ADDSS—Add Scalar Single Precision Floating-Point Values
    // ADDSUBPD—Packed Double Precision Floating-Point Add/Subtract
    // ADDSUBPS—Packed Single Precision Floating-Point Add/Subtract
    // ADOX—Unsigned Integer Addition of Two Operands With Overflow Flag
    // AESDEC—Perform One Round of an AES Decryption Flow
    // AESDEC128KL—Perform Ten Rounds of AES Decryption Flow With Key Locker Using 128-Bit Key
    // AESDEC256KL—Perform 14 Rounds of AES Decryption Flow With Key Locker Using 256-Bit Key
    // AESDECLAST—Perform Last Round of an AES Decryption Flows
    // AESDECWIDE128KL—Perform Ten Rounds of AES Decryption Flow With Key Locker on 8 Blocks Using 128-Bit Key
    // AESDECWIDE256KL—Perform 14 Rounds of AES Decryption Flow With Key Locker on 8 Blocks Using 256-Bit Key
    // AESENC—Perform One Round of an AES Encryption Flow
    // AESENC128KL—Perform Ten Rounds of AES Encryption Flow With Key Locker Using 128-Bit Keys
    // AESENC256KL—Perform 14 Rounds of AES Encryption Flow With Key Locker Using 256-Bit Key
    // AESENCLAST—Perform Last Round of an AES Encryption Flow
    // AESENCWIDE128KL—Perform Ten Rounds of AES Encryption Flow With Key Locker on 8 Blocks Using 128-Bit Key
    // AESENCWIDE256KL—Perform 14 Rounds of AES Encryption Flow With Key Locker on 8 Blocks Using 256-Bit Key
    // AESIMC—Perform the AES InvMixColumn Transformation
    // AESKEYGENASSIST—AES Round Key Generation Assist
    // AND—Logical AND
    // ANDN—Logical AND NOT
    // ANDPD—Bitwise Logical AND of Packed Double Precision Floating-Point Values
    // ANDPS—Bitwise Logical AND of Packed Single Precision Floating-Point Values
    // ANDNPD—Bitwise Logical AND NOT of Packed Double Precision Floating-Point Values
    // ANDNPS—Bitwise Logical AND NOT of Packed Single Precision Floating-Point Values
    // ARPL—Adjust RPL Field of Segment Selector
    // BEXTR—Bit Field Extract
    // BLENDPD—Blend Packed Double Precision Floating-Point Values
    // BLENDPS—Blend Packed Single Precision Floating-Point Values
    // BLENDVPD—Variable Blend Packed Double Precision Floating-Point Values
    // BLENDVPS—Variable Blend Packed Single Precision Floating-Point Values
    // BLSI—Extract Lowest Set Isolated Bit
    // BLSMSK—Get Mask Up to Lowest Set Bit
    // BLSR—Reset Lowest Set Bit
    // BNDCL—Check Lower Bound
    // BNDCU/BNDCN—Check Upper Bound
    // BNDLDX—Load Extended Bounds Using Address Translation
    // BNDMK—Make Bounds
    // BNDMOV—Move Bounds
    // BNDSTX—Store Extended Bounds Using Address Translation
    // BOUND—Check Array Index Against Bounds
    // BSF—Bit Scan Forward
    // BSR—Bit Scan Reverse
    // BSWAP—Byte Swap
    // BT—Bit Test
    // BTC—Bit Test and Complement
    // BTR—Bit Test and Reset
    // BTS—Bit Test and Set
    // BZHI—Zero High Bits Starting with Specified Bit Position
    // CALL—Call Procedure
    // CBW/CWDE/CDQE—Convert Byte to Word/Convert Word to Doubleword/Convert Doubleword to Quadword
    // CLAC—Clear AC Flag in EFLAGS Register
    // CLC—Clear Carry Flag
    // CLD—Clear Direction Flag
    // CLDEMOTE—Cache Line Demote
    // CLFLUSH—Flush Cache Line
    // CLFLUSHOPT—Flush Cache Line Optimized
    // CLI—Clear Interrupt Flag
    // CLRSSBSY—Clear Busy Flag in a Supervisor Shadow Stack Token
    // CLTS—Clear Task-Switched Flag in CR0
    // CLUI—Clear User Interrupt Flag
    // CLWB—Cache Line Write Back
    // CMC—Complement Carry Flag
    // CMOVcc—Conditional Move
    // CMP—Compare Two Operands
    // CMPPD—Compare Packed Double Precision Floating-Point Values
    // CMPPS—Compare Packed Single Precision Floating-Point Values
    // CMPS/CMPSB/CMPSW/CMPSD/CMPSQ—Compare String Operands
    // CMPSD—Compare Scalar Double Precision Floating-Point Value
    // CMPSS—Compare Scalar Single Precision Floating-Point Value
    // CMPXCHG—Compare and Exchange
    // CMPXCHG8B/CMPXCHG16B—Compare and Exchange Bytes
    // COMISD—Compare Scalar Ordered Double Precision Floating-Point Values and Set EFLAGS
    // COMISS—Compare Scalar Ordered Single Precision Floating-Point Values and Set EFLAGS
    // CPUID—CPU Identification
    // CRC32—Accumulate CRC32 Value
    // CVTDQ2PD—Convert Packed Doubleword Integers to Packed Double Precision Floating-Point Values
    // CVTDQ2PS—Convert Packed Doubleword Integers to Packed Single Precision Floating-Point Values
    // CVTPD2DQ—Convert Packed Double Precision Floating-Point Values to Packed Doubleword Integers
    // CVTPD2PI—Convert Packed Double Precision Floating-Point Values to Packed Dword Integers
    // CVTPD2PS—Convert Packed Double Precision Floating-Point Values to Packed Single Precision Floating-Point Values
    // CVTPI2PD—Convert Packed Dword Integers to Packed Double Precision Floating-Point Values
    // CVTPI2PS—Convert Packed Dword Integers to Packed Single Precision Floating-Point Values
    // CVTPS2DQ—Convert Packed Single Precision Floating-Point Values to Packed Signed Doubleword Integer Values
    // CVTPS2PD—Convert Packed Single Precision Floating-Point Values to Packed Double Precision Floating-Point Values
    // CVTPS2PI—Convert Packed Single Precision Floating-Point Values to Packed Dword Integers
    // CVTSD2SI—Convert Scalar Double Precision Floating-Point Value to Doubleword Integer
    // CVTSD2SS—Convert Scalar Double Precision Floating-Point Value to Scalar Single Precision Floating-Point Value
    // CVTSI2SD—Convert Doubleword Integer to Scalar Double Precision Floating-Point Value
    // CVTSI2SS—Convert Doubleword Integer to Scalar Single Precision Floating-Point Value
    // CVTSS2SD—Convert Scalar Single Precision Floating-Point Value to Scalar Double Precision Floating-Point Value
    // CVTSS2SI—Convert Scalar Single Precision Floating-Point Value to Doubleword Integer
    // CVTTPD2DQ—Convert with Truncation Packed Double Precision Floating-Point Values to Packed Doubleword Integers
    // CVTTPD2PI—Convert With Truncation Packed Double Precision Floating-Point Values to Packed Dword Integers
    // CVTTPS2DQ—Convert With Truncation Packed Single Precision Floating-Point Values to Packed Signed Doubleword Integer Values
    // CVTTPS2PI—Convert With Truncation Packed Single Precision Floating-Point Values to Packed Dword Integers
    // CVTTSD2SI—Convert With Truncation Scalar Double Precision Floating-Point Value to Signed Integer
    // CVTTSS2SI—Convert With Truncation Scalar Single Precision Floating-Point Value to Integer
    // CWD/CDQ/CQO—Convert Word to Doubleword/Convert Doubleword to Quadword
    // DAA—Decimal Adjust AL After Addition
    // DAS—Decimal Adjust AL After Subtraction
    // DEC—Decrement by 1
    // DIV—Unsigned Divide
    // DIVPD—Divide Packed Double Precision Floating-Point Values
    // DIVPS—Divide Packed Single Precision Floating-Point Values
    // DIVSD—Divide Scalar Double Precision Floating-Point Value
    // DIVSS—Divide Scalar Single Precision Floating-Point Values
    // DPPD—Dot Product of Packed Double Precision Floating-Point Values
    // DPPS—Dot Product of Packed Single Precision Floating-Point Values
    // EMMS—Empty MMX Technology State
    // ENCODEKEY128—Encode 128-Bit Key With Key Locker
    // ENCODEKEY256—Encode 256-Bit Key With Key Locker
    // ENDBR32—Terminate an Indirect Branch in 32-bit and Compatibility Mode
    // ENDBR64—Terminate an Indirect Branch in 64-bit Mode
    // ENTER—Make Stack Frame for Procedure Parameters
    // ENQCMD—Enqueue Command
    // ENQCMDS—Enqueue Command Supervisor
    // EXTRACTPS—Extract Packed Floating-Point Values
    // F2XM1—Compute 2^x - 1
    // FABS—Absolute Value
    // FADD/FADDP/FIADD—Add
    // FBLD—Load Binary Coded Decimal
    // FBSTP—Store BCD Integer and Pop
    // FCHS—Change Sign
    // FCLEX/FNCLEX—Clear Exceptions
    // FCMOVcc—Floating-Point Conditional Move
    // FCOM/FCOMP/FCOMPP—Compare Floating-Point Values
    // FUCOMI/FUCOMIP—Compare Floating-Point Values and Set EFLAGS
    // FCOS—Cosine
    // FDECSTP—Decrement Stack-Top Pointer
    // FDIV/FDIVP/FIDIV—Divide
    // FDIVR/FDIVRP/FIDIVR—Reverse Divide
    // FFREE—Free Floating-Point Register
    // FICOM/FICOMP—Compare Integer
    // FILD—Load Integer
    // FINCSTP—Increment Stack-Top Pointer
    // FINIT/FNINIT—Initialize Floating-Point Unit
    // FIST/FISTP—Store Integer
    // FISTTP—Store Integer With Truncation
    // FLD—Load Floating-Point Value
    // FLD1/FLDL2T/FLDL2E/FLDPI/FLDLG2/FLDLN2/FLDZ—Load Constant
    // FLDCW—Load x87 FPU Control Word
    // FLDENV—Load x87 FPU Environment
    // FMUL/FMULP/FIMUL—Multiply
    // FNOP—No Operation
    // FPATAN—Partial Arctangent
    // FPREM—Partial Remainder
    // FPREM1—Partial Remainder
    // FPTAN—Partial Tangent
    // FRNDINT—Round to Integer
    // FRSTOR—Restore x87 FPU State
    // FSAVE/FNSAVE—Store x87 FPU State
    // FSCALE—Scale
    // FSIN—Sine
    // FSINCOS—Sine and Cosine
    // FSQRT—Square Root
    // FST/FSTP—Store Floating-Point Value
    // FSTCW/FNSTCW—Store x87 FPU Control Word
    // FSTENV/FNSTENV—Store x87 FPU Environment
    // FSTSW/FNSTSW—Store x87 FPU Status Word
    // FSUB/FSUBP/FISUB—Subtract
    // FSUBR/FSUBRP/FISUBR—Reverse Subtract
    // FTST—TEST
    // FUCOM/FUCOMP/FUCOMPP—Unordered Compare Floating-Point Values
    // FXAM—Examine Floating-Point
    // FXCH—Exchange Register Contents
    // FXRSTOR—Restore x87 FPU, MMX, XMM, and MXCSR State
    // FXSAVE—Save x87 FPU, MMX Technology, and SSE State
    // FXTRACT—Extract Exponent and Significand
    // FYL2X—Compute y * log2(x)
    // FYL2XP1—Compute y * log2 (x +1)
    // GF2P8AFFINEINVQB—Galois Field Affine Transformation Inverse
    // GF2P8AFFINEQB—Galois Field Affine Transformation
    // GF2P8MULB—Galois Field Multiply Bytes
    // HADDPD—Packed Double Precision Floating-Point Horizontal Add
    // HADDPS—Packed Single Precision Floating-Point Horizontal Add
    // HLT—Halt
    // HRESET—History Reset
    // HSUBPD—Packed Double Precision Floating-Point Horizontal Subtract
    // HSUBPS—Packed Single Precision Floating-Point Horizontal Subtract
    // IDIV—Signed Divide
    // IMUL—Signed Multiply
    // IN—Input From Port
    // INC—Increment by 1
    // INCSSPD/INCSSPQ—Increment Shadow Stack Pointer
    // INS/INSB/INSW/INSD—Input from Port to String
    // INSERTPS—Insert Scalar Single Precision Floating-Point Value
    // INT n/INTO/INT3/INT1—Call to Interrupt Procedure
    // INVD—Invalidate Internal Caches
    // INVLPG—Invalidate TLB Entries
    // INVPCID—Invalidate Process-Context Identifier
    // IRET/IRETD/IRETQ—Interrupt Return
    // Jcc—Jump if Condition Is Met
    // JMP—Jump
    // KADDW/KADDB/KADDQ/KADDD—ADD Two Masks
    // KANDW/KANDB/KANDQ/KANDD—Bitwise Logical AND Masks
    // KANDNW/KANDNB/KANDNQ/KANDND—Bitwise Logical AND NOT Masks
    // KMOVW/KMOVB/KMOVQ/KMOVD—Move From and to Mask Registers
    // KNOTW/KNOTB/KNOTQ/KNOTD—NOT Mask Register
    // KORW/KORB/KORQ/KORD—Bitwise Logical OR Masks
    // KORTESTW/KORTESTB/KORTESTQ/KORTESTD—OR Masks and Set Flags
    // KSHIFTLW/KSHIFTLB/KSHIFTLQ/KSHIFTLD—Shift Left Mask Registers
    // KSHIFTRW/KSHIFTRB/KSHIFTRQ/KSHIFTRD—Shift Right Mask Registers
    // KTESTW/KTESTB/KTESTQ/KTESTD—Packed Bit Test Masks and Set Flags
    // KUNPCKBW/KUNPCKWD/KUNPCKDQ—Unpack for Mask Registers
    // KXNORW/KXNORB/KXNORQ/KXNORD—Bitwise Logical XNOR Masks
    // KXORW/KXORB/KXORQ/KXORD—Bitwise Logical XOR Masks
    // LAHF—Load Status Flags Into AH Register
    // LAR—Load Access Rights Byte
    // LDDQU—Load Unaligned Integer 128 Bits
    // LDMXCSR—Load MXCSR Register
    // LDS/LES/LFS/LGS/LSS—Load Far Pointer
    // LDTILECFG—Load Tile Configuration
    // LEA—Load Effective Address
    // LEAVE—High Level Procedure Exit
    // LFENCE—Load Fence
    // LGDT/LIDT—Load Global/Interrupt Descriptor Table Register
    // LLDT—Load Local Descriptor Table Register
    // LMSW—Load Machine Status Word
    // LOADIWKEY—Load Internal Wrapping Key With Key Locker
    // LOCK—Assert LOCK# Signal Prefix
    // LODS/LODSB/LODSW/LODSD/LODSQ—Load String
    // LOOP/LOOPcc—Loop According to ECX Counter
    // LSL—Load Segment Limit
    // LTR—Load Task Register
    // LZCNT—Count the Number of Leading Zero Bits

    // MASKMOVDQU—Store Selected Bytes of Double Quadword
    // MASKMOVQ—Store Selected Bytes of Quadword
    // MAXPD—Maximum of Packed Double Precision Floating-Point Values
    // MAXPS—Maximum of Packed Single Precision Floating-Point Values
    // MAXSD—Return Maximum Scalar Double Precision Floating-Point Value
    // MAXSS—Return Maximum Scalar Single Precision Floating-Point Value
    // MFENCE—Memory Fence
    // MINPD—Minimum of Packed Double Precision Floating-Point Values
    // MINPS—Minimum of Packed Single Precision Floating-Point Values
    // MINSD—Return Minimum Scalar Double Precision Floating-Point Value
    // MINSS—Return Minimum Scalar Single Precision Floating-Point Value
    // MONITOR—Set Up Monitor Address
    // MOV—Move
    // MOV—Move to/from Control Registers
    // MOV—Move to/from Debug Registers
    // MOVAPD—Move Aligned Packed Double Precision Floating-Point Values
    // MOVAPS—Move Aligned Packed Single Precision Floating-Point Values
    // MOVBE—Move Data After Swapping Bytes
    // MOVD/MOVQ—Move Doubleword/Move Quadword
    // MOVDDUP—Replicate Double Precision Floating-Point Values
    // MOVDIRI—Move Doubleword as Direct Store
    // MOVDIR64B—Move 64 Bytes as Direct Store
    // MOVDQA,VMOVDQA32/64—Move Aligned Packed Integer Values
    // MOVDQU,VMOVDQU8/16/32/64—Move Unaligned Packed Integer Values
    // MOVDQ2Q—Move Quadword from XMM to MMX Technology Register
    // MOVHLPS—Move Packed Single Precision Floating-Point Values High to Low
    // MOVHPD—Move High Packed Double Precision Floating-Point Value
    // MOVHPS—Move High Packed Single Precision Floating-Point Values
    // MOVLHPS—Move Packed Single Precision Floating-Point Values Low to High
    // MOVLPD—Move Low Packed Double Precision Floating-Point Value
    // MOVLPS—Move Low Packed Single Precision Floating-Point Values
    // MOVMSKPD—Extract Packed Double Precision Floating-Point Sign Mask
    // MOVMSKPS—Extract Packed Single Precision Floating-Point Sign Mask
    // MOVNTDQA—Load Double Quadword Non-Temporal Aligned Hint
    // MOVNTDQ—Store Packed Integers Using Non-Temporal Hint
    // MOVNTI—Store Doubleword Using Non-Temporal Hint
    // MOVNTPD—Store Packed Double Precision Floating-Point Values Using Non-Temporal Hint
    // MOVNTPS—Store Packed Single Precision Floating-Point Values Using Non-Temporal Hint
    // MOVNTQ—Store of Quadword Using Non-Temporal Hint
    // MOVQ—Move Quadword
    // MOVQ2DQ—Move Quadword from MMX Technology to XMM Register
    // MOVS/MOVSB/MOVSW/MOVSD/MOVSQ—Move Data From String to String
    // MOVSD—Move or Merge Scalar Double Precision Floating-Point Value
    // MOVSHDUP—Replicate Single Precision Floating-Point Values
    // MOVSLDUP—Replicate Single Precision Floating-Point Values
    // MOVSS—Move or Merge Scalar Single Precision Floating-Point Value
    // MOVSX/MOVSXD—Move With Sign-Extension
    // MOVUPD—Move Unaligned Packed Double Precision Floating-Point Values
    // MOVUPS—Move Unaligned Packed Single Precision Floating-Point Values
    // MOVZX—Move With Zero-Extend
    // MPSADBW—Compute Multiple Packed Sums of Absolute Difference
    // MUL—Unsigned Multiply
    // MULPD—Multiply Packed Double Precision Floating-Point Values
    // MULPS—Multiply Packed Single Precision Floating-Point Values
    // MULSD—Multiply Scalar Double Precision Floating-Point Value
    // MULSS—Multiply Scalar Single Precision Floating-Point Values
    // MULX—Unsigned Multiply Without Affecting Flags
    // MWAIT—Monitor Wait
    // NEG—Two's Complement Negation
    // NOP—No Operation
    // NOT—One's Complement Negation
    // OR—Logical Inclusive OR
    // ORPD—Bitwise Logical OR of Packed Double Precision Floating-Point Values
    // ORPS—Bitwise Logical OR of Packed Single Precision Floating-Point Values
    // OUT—Output to Port
    // OUTS/OUTSB/OUTSW/OUTSD—Output String to Port
    // PABSB/PABSW/PABSD/PABSQ—Packed Absolute Value
    // PACKSSWB/PACKSSDW—Pack With Signed Saturation
    // PACKUSDW—Pack With Unsigned Saturation
    // PACKUSWB—Pack With Unsigned Saturation
    // PADDB/PADDW/PADDD/PADDQ—Add Packed Integers
    // PADDSB/PADDSW—Add Packed Signed Integers with Signed Saturation
    // PADDUSB/PADDUSW—Add Packed Unsigned Integers With Unsigned Saturation
    // PALIGNR—Packed Align Right
    // PAND—Logical AND
    // PANDN—Logical AND NOT
    // PAUSE—Spin Loop Hint
    // PAVGB/PAVGW—Average Packed Integers
    // PBLENDVB—Variable Blend Packed Bytes
    // PBLENDW—Blend Packed Words
    // PCLMULQDQ—Carry-Less Multiplication Quadword
    // PCMPEQB/PCMPEQW/PCMPEQD— Compare Packed Data for Equal
    // PCMPEQQ—Compare Packed Qword Data for Equal
    // PCMPESTRI—Packed Compare Explicit Length Strings, Return Index
    // PCMPESTRM—Packed Compare Explicit Length Strings, Return Mask
    // PCMPGTB/PCMPGTW/PCMPGTD—Compare Packed Signed Integers for Greater Than
    // PCMPGTQ—Compare Packed Data for Greater Than
    // PCMPISTRI—Packed Compare Implicit Length Strings, Return Index
    // PCMPISTRM—Packed Compare Implicit Length Strings, Return Mask
    // PCONFIG—Platform Configuration
    // PDEP—Parallel Bits Deposit
    // PEXT—Parallel Bits Extract
    // PEXTRB/PEXTRD/PEXTRQ—Extract Byte/Dword/Qword
    // PEXTRW—Extract Word
    // PHADDW/PHADDD—Packed Horizontal Add
    // PHADDSW—Packed Horizontal Add and Saturate
    // PHMINPOSUW—Packed Horizontal Word Minimum
    // PHSUBW/PHSUBD—Packed Horizontal Subtract
    // PHSUBSW—Packed Horizontal Subtract and Saturate
    // PINSRB/PINSRD/PINSRQ—Insert Byte/Dword/Qword
    // PINSRW—Insert Word
    // PMADDUBSW—Multiply and Add Packed Signed and Unsigned Bytes
    // PMADDWD—Multiply and Add Packed Integers
    // PMAXSB/PMAXSW/PMAXSD/PMAXSQ—Maximum of Packed Signed Integers
    // PMAXUB/PMAXUW—Maximum of Packed Unsigned Integers
    // PMAXUD/PMAXUQ—Maximum of Packed Unsigned Integers
    // PMINSB/PMINSW—Minimum of Packed Signed Integers
    // PMINSD/PMINSQ—Minimum of Packed Signed Integers
    // PMINUB/PMINUW—Minimum of Packed Unsigned Integers
    // PMINUD/PMINUQ—Minimum of Packed Unsigned Integers
    // PMOVMSKB—Move Byte Mask
    // PMOVSX—Packed Move With Sign Extend
    // PMOVZX—Packed Move With Zero Extend
    // PMULDQ—Multiply Packed Doubleword Integers
    // PMULHRSW—Packed Multiply High With Round and Scale
    // PMULHUW—Multiply Packed Unsigned Integers and Store High Result
    // PMULHW—Multiply Packed Signed Integers and Store High Result
    // PMULLD/PMULLQ—Multiply Packed Integers and Store Low Result
    // PMULLW—Multiply Packed Signed Integers and Store Low Result
    // PMULUDQ—Multiply Packed Unsigned Doubleword Integers
    // POP—Pop a Value From the Stack
    // POPA/POPAD—Pop All General-Purpose Registers
    // POPCNT—Return the Count of Number of Bits Set to 1
    // POPF/POPFD/POPFQ—Pop Stack Into EFLAGS Register
    // POR—Bitwise Logical OR
    // PREFETCHh—Prefetch Data Into Caches
    // PREFETCHW—Prefetch Data Into Caches in Anticipation of a Write
    // PSADBW—Compute Sum of Absolute Differences
    // PSHUFB—Packed Shuffle Bytes
    // PSHUFD—Shuffle Packed Doublewords
    // PSHUFHW—Shuffle Packed High Words
    // PSHUFLW—Shuffle Packed Low Words
    // PSHUFW—Shuffle Packed Words
    // PSIGNB/PSIGNW/PSIGND—Packed SIGN
    // PSLLDQ—Shift Double Quadword Left Logical
    // PSLLW/PSLLD/PSLLQ—Shift Packed Data Left Logical
    // PSRAW/PSRAD/PSRAQ—Shift Packed Data Right Arithmetic
    // PSRLDQ—Shift Double Quadword Right Logical
    // PSRLW/PSRLD/PSRLQ—Shift Packed Data Right Logical
    // PSUBB/PSUBW/PSUBD—Subtract Packed Integers
    // PSUBQ—Subtract Packed Quadword Integers
    // PSUBSB/PSUBSW—Subtract Packed Signed Integers With Signed Saturation
    // PSUBUSB/PSUBUSW—Subtract Packed Unsigned Integers With Unsigned Saturation
    // PTEST—Logical Compare
    // PTWRITE—Write Data to a Processor Trace Packet
    // PUNPCKHBW/PUNPCKHWD/PUNPCKHDQ/PUNPCKHQDQ— Unpack High Data
    // PUNPCKLBW/PUNPCKLWD/PUNPCKLDQ/PUNPCKLQDQ—Unpack Low Data
    // PUSH—Push Word, Doubleword, or Quadword Onto the Stack
    // PUSHA/PUSHAD—Push All General-Purpose Registers
    // PUSHF/PUSHFD/PUSHFQ—Push EFLAGS Register Onto the Stack
    // PXOR—Logical Exclusive OR
    // RCL/RCR/ROL/ROR—Rotate
    // RCPPS—Compute Reciprocals of Packed Single Precision Floating-Point Values
    // RCPSS—Compute Reciprocal of Scalar Single Precision Floating-Point Values
    // RDFSBASE/RDGSBASE—Read FS/GS Segment Base
    // RDMSR—Read From Model Specific Register
    // RDPID—Read Processor ID
    // RDPKRU—Read Protection Key Rights for User Pages
    // RDPMC—Read Performance-Monitoring Counters
    // RDRAND—Read Random Number
    // RDSEED—Read Random SEED
    // RDSSPD/RDSSPQ—Read Shadow Stack Pointer
    // RDTSC—Read Time-Stamp Counter
    // RDTSCP—Read Time-Stamp Counter and Processor ID
    // REP/REPE/REPZ/REPNE/REPNZ—Repeat String Operation Prefix

    /// Return From Procedure
    RET,

    // RORX — Rotate Right Logical Without Affecting Flags
    // ROUNDPD—Round Packed Double Precision Floating-Point Values
    // ROUNDPS—Round Packed Single Precision Floating-Point Values
    // ROUNDSD—Round Scalar Double Precision Floating-Point Values
    // ROUNDSS—Round Scalar Single Precision Floating-Point Values
    // RSM—Resume From System Management Mode
    // RSQRTPS—Compute Reciprocals of Square Roots of Packed Single Precision Floating-Point Values
    // RSQRTSS—Compute Reciprocal of Square Root of Scalar Single Precision Floating-Point Value
    // RSTORSSP—Restore Saved Shadow Stack Pointer
    // SAHF—Store AH Into Flags
    // SAL/SAR/SHL/SHR—Shift
    // SARX/SHLX/SHRX—Shift Without Affecting Flags
    // SAVEPREVSSP—Save Previous Shadow Stack Pointer
    // SBB—Integer Subtraction With Borrow
    // SCAS/SCASB/SCASW/SCASD—Scan String
    // SENDUIPI—Send User Interprocessor Interrupt
    // SERIALIZE—Serialize Instruction Execution
    // SETcc—Set Byte on Condition
    // SETSSBSY—Mark Shadow Stack Busy
    // SFENCE—Store Fence
    // SGDT—Store Global Descriptor Table Register
    // SHA1RNDS4—Perform Four Rounds of SHA1 Operation
    // SHA1NEXTE—Calculate SHA1 State Variable E After Four Rounds
    // SHA1MSG1—Perform an Intermediate Calculation for the Next Four SHA1 Message Dwords
    // SHA1MSG2—Perform a Final Calculation for the Next Four SHA1 Message Dwords
    // SHA256RNDS2—Perform Two Rounds of SHA256 Operation
    // SHA256MSG1—Perform an Intermediate Calculation for the Next Four SHA256 Message Dwords
    // SHA256MSG2—Perform a Final Calculation for the Next Four SHA256 Message Dwords
    // SHLD—Double Precision Shift Left
    // SHRD—Double Precision Shift Right
    // SHUFPD—Packed Interleave Shuffle of Pairs of Double Precision Floating-Point Values
    // SHUFPS—Packed Interleave Shuffle of Quadruplets of Single Precision Floating-Point Values
    // SIDT—Store Interrupt Descriptor Table Register
    // SLDT—Store Local Descriptor Table Register
    // SMSW—Store Machine Status Word
    // SQRTPD—Square Root of Double Precision Floating-Point Values
    // SQRTPS—Square Root of Single Precision Floating-Point Values
    // SQRTSD—Compute Square Root of Scalar Double Precision Floating-Point Value
    // SQRTSS—Compute Square Root of Scalar Single Precision Value
    // STAC—Set AC Flag in EFLAGS Register
    // STC—Set Carry Flag
    // STD—Set Direction Flag
    // STI—Set Interrupt Flag
    // STMXCSR—Store MXCSR Register State
    // STOS/STOSB/STOSW/STOSD/STOSQ—Store String
    // STR—Store Task Register
    // STTILECFG—Store Tile Configuration
    // STUI—Set User Interrupt Flag
    // SUB—Subtract
    // SUBPD—Subtract Packed Double Precision Floating-Point Values
    // SUBPS—Subtract Packed Single Precision Floating-Point Values
    // SUBSD—Subtract Scalar Double Precision Floating-Point Value
    // SUBSS—Subtract Scalar Single Precision Floating-Point Value
    // SWAPGS—Swap GS Base Register
    // SYSCALL—Fast System Call
    // SYSENTER—Fast System Call
    // SYSEXIT—Fast Return from Fast System Call
    // SYSRET—Return From Fast System Call
    // TDPBF16PS—Dot Product of BF16 Tiles Accumulated into Packed Single Precision Tile
    // TDPBSSD/TDPBSUD/TDPBUSD/TDPBUUD—Dot Product of Signed/Unsigned Bytes with Dword Accumulation
    // TEST—Logical Compare
    // TESTUI—Determine User Interrupt Flag
    // TILELOADD/TILELOADDT1—Load Tile
    // TILERELEASE—Release Tile
    // TILESTORED—Store Tile
    // TILEZERO—Zero Tile
    // TPAUSE—Timed PAUSE
    // TZCNT—Count the Number of Trailing Zero Bits
    // UCOMISD—Unordered Compare Scalar Double Precision Floating-Point Values and Set EFLAGS
    // UCOMISS—Unordered Compare Scalar Single Precision Floating-Point Values and Set EFLAGS
    // UD—Undefined Instruction
    // UIRET—User-Interrupt Return
    // UMONITOR—User Level Set Up Monitor Address
    // UMWAIT—User Level Monitor Wait
    // UNPCKHPD—Unpack and Interleave High Packed Double Precision Floating-Point Values
    // UNPCKHPS—Unpack and Interleave High Packed Single Precision Floating-Point Values
    // UNPCKLPD—Unpack and Interleave Low Packed Double Precision Floating-Point Values
    // UNPCKLPS—Unpack and Interleave Low Packed Single Precision Floating-Point Values

    // TODO: V

    // WAIT/FWAIT—Wait
    // WBINVD—Write Back and Invalidate Cache
    // WBNOINVD—Write Back and Do Not Invalidate Cache
    // WRFSBASE/WRGSBASE—Write FS/GS Segment Base
    // WRMSR—Write to Model Specific Register
    // WRPKRU—Write Data to User Page Key Register
    // WRSSD/WRSSQ—Write to Shadow Stack
    // WRUSSD/WRUSSQ—Write to User Shadow Stack
    // XABORT—Transactional Abort
    // XACQUIRE/XRELEASE—Hardware Lock Elision Prefix Hints
    // XADD—Exchange and Add
    // XBEGIN—Transactional Begin
    // XCHG—Exchange Register/Memory With Register
    // XEND—Transactional End
    // XGETBV—Get Value of Extended Control Register
    // XLAT/XLATB—Table Look-up Translation
    // XOR—Logical Exclusive OR
    // XORPD—Bitwise Logical XOR of Packed Double Precision Floating-Point Values
    // XORPS—Bitwise Logical XOR of Packed Single Precision Floating-Point Values
    // XRESLDTRK—Resume Tracking Load Addresses
    // XRSTOR—Restore Processor Extended States
    // XRSTORS—Restore Processor Extended States Supervisor
    // XSAVE—Save Processor Extended States
    // XSAVEC—Save Processor Extended States With Compaction
    // XSAVEOPT—Save Processor Extended States Optimized
    // XSAVES—Save Processor Extended States Supervisor
    // XSETBV—Set Extended Control Register
    // XSUSLDTRK—Suspend Tracking Load Addresses
    // XTEST—Test if in Transactional Execution
};
