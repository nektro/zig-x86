const std = @import("std");
const x86 = @This();

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
