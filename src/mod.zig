const std = @import("std");

const OperandSize = enum(u8) {
    @"16" = 16,
    @"32" = 32,
    @"64" = 64,
};

const AddressSize = enum(u8) {
    @"16" = 16,
    @"32" = 32,
    @"64" = 64,
};

const StackAddrSize = enum(u8) {
    @"16" = 16,
    @"32" = 32,
    @"64" = 64,
};

const AddressingMethod = enum {
    /// Direct address: the instruction has no ModR/M byte; the address of the operand is encoded in the instruction. No base register, index register, or scaling factor can be applied (for example, far JMP (EA)).
    A,
    /// The VEX.vvvv field of the VEX prefix selects a general purpose register.
    B,
    /// The reg field of the ModR/M byte selects a control register (for example, MOV (0F20, 0F22)).
    C,
    /// The reg field of the ModR/M byte selects a debug register (for example, MOV (0F21,0F23)).
    D,
    /// A ModR/M byte follows the opcode and specifies the operand. The operand is either a general-purpose register or a memory address. If it is a memory address, the address is computed from a segment register and any of the following values: a base register, an index register, a scaling factor, a displacement.
    E,
    /// EFLAGS/RFLAGS Register.
    F,
    /// The reg field of the ModR/M byte selects a general register (for example, AX (000)).
    G,
    /// The VEX.vvvv field of the VEX prefix selects a 128-bit XMM register or a 256-bit YMM register, determined by operand type. For legacy SSE encodings this operand does not exist, changing the instruction to destructive form.
    H,
    /// Immediate data: the operand value is encoded in subsequent bytes of the instruction.
    I,
    /// The instruction contains a relative offset to be added to the instruction pointer register (for example, JMP (0E9), LOOP).
    J,
    /// The upper 4 bits of the 8-bit immediate selects a 128-bit XMM register or a 256-bit YMM register, determined by operand type. (the MSB is ignored in 32-bit mode)
    L,
    /// The ModR/M byte may refer only to memory (for example, BOUND, LES, LDS, LSS, LFS, LGS, CMPXCHG8B).
    M,
    /// The R/M field of the ModR/M byte selects a packed-quadword, MMX technology register.
    N,
    /// The instruction has no ModR/M byte. The offset of the operand is coded as a word or double word (depending on address size attribute) in the instruction. No base register, index register, or scaling factor can be applied (for example, MOV (A0–A3)).
    O,
    /// The reg field of the ModR/M byte selects a packed quadword MMX technology register.
    P,
    /// A ModR/M byte follows the opcode and specifies the operand. The operand is either an MMX technology register or a memory address. If it is a memory address, the address is computed from a segment register and any of the following values: a base register, an index register, a scaling factor, and a displacement.
    Q,
    /// The R/M field of the ModR/M byte may refer only to a general register (for example, MOV (0F20-0F23)).
    R,
    /// The reg field of the ModR/M byte selects a segment register (for example, MOV (8C,8E)).
    S,
    /// The R/M field of the ModR/M byte selects a 128-bit XMM register or a 256-bit YMM register, determined by operand type.
    U,
    /// The reg field of the ModR/M byte selects a 128-bit XMM register or a 256-bit YMM register, determined by operand type.
    V,
    /// A ModR/M byte follows the opcode and specifies the operand. The operand is either a 128-bit XMM register, a 256-bit YMM register (determined by operand type), or a memory address. If it is a memory address, the address is computed from a segment register and any of the following values: a base register, an index register, a scaling factor, and a displacement.
    W,
    /// Memory addressed by the DS:rSI register pair (for example, MOVS, CMPS, OUTS, or LODS).
    X,
    /// Memory addressed by the ES:rDI register pair (for example, MOVS, CMPS, INS, STOS, or SCAS).
    Y,
};

const OperandType = enum {
    /// Two one-word operands in memory or two double-word operands in memory, depending on operand-size attribute (used only by the BOUND instruction).
    a,
    /// Byte, regardless of operand-size attribute.
    b,
    /// Byte or word, depending on operand-size attribute.
    c,
    /// Doubleword, regardless of operand-size attribute.
    d,
    /// Double-quadword, regardless of operand-size attribute.
    dq,
    /// 32-bit, 48-bit, or 80-bit pointer, depending on operand-size attribute.
    p,
    /// 128-bit or 256-bit packed double precision floating-point data.
    pd,
    /// Quadword MMX technology register (for example: mm0).
    pi,
    /// 128-bit or 256-bit packed single-precision floating-point data.
    ps,
    /// Quadword, regardless of operand-size attribute.
    q,
    /// Quad-Quadword (256-bits), regardless of operand-size attribute.
    qq,
    /// 6-byte or 10-byte pseudo-descriptor.
    s,
    /// Scalar element of a 128-bit double precision floating data.
    sd,
    /// Scalar element of a 128-bit single-precision floating data.
    ss,
    /// Doubleword integer register (for example: eax).
    si,
    /// Word, doubleword or quadword (in 64-bit mode), depending on operand-size attribute.
    v,
    /// Word, regardless of operand-size attribute.
    w,
    /// dq or qq based on the operand-size attribute.
    x,
    /// Doubleword or quadword (in 64-bit mode), depending on operand-size attribute.
    y,
    /// Word for 16-bit operand-size or doubleword for 32 or 64-bit operand-size.
    z,
};

const InstructionKind = enum {
    //
};
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
