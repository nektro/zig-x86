const std = @import("std");
const string = []const u8;
const BytesToInstructionIter = @This();
const x86 = @import("./mod.zig");
const Reader = @import("./Reader.zig");

reader: Reader,

pub fn init(reader: anytype) BytesToInstructionIter {
    return .{
        .reader = Reader.from(reader),
    };
}

pub fn next(iter: BytesToInstructionIter) !?x86.Instruction {
    const b = iter.reader.readByte() catch |err| switch (err) {
        error.EndOfStream => return null,
        else => |e| return e,
    };
    switch (b) {
        // ZO
        0xC3 => return .{ .mnemonic = .RET },

        // RM
        0x8B => return try foo1(iter, .MOV, .@"32", 1),
        0x03 => return try foo1(iter, .ADD, .@"32", 1),

        0xB8 => return .{ .mnemonic = .MOV, .op1 = .{ .reg = .EAX }, .op2 = .{ .imm32 = try iter.reader.readInt(u32, .Little) } },
        0xB9 => return .{ .mnemonic = .MOV, .op1 = .{ .reg = .ECX }, .op2 = .{ .imm32 = try iter.reader.readInt(u32, .Little) } },
        0xBA => return .{ .mnemonic = .MOV, .op1 = .{ .reg = .EDX }, .op2 = .{ .imm32 = try iter.reader.readInt(u32, .Little) } },
        0xBB => return .{ .mnemonic = .MOV, .op1 = .{ .reg = .EBX }, .op2 = .{ .imm32 = try iter.reader.readInt(u32, .Little) } },
        0xBC => return .{ .mnemonic = .MOV, .op1 = .{ .reg = .ESP }, .op2 = .{ .imm32 = try iter.reader.readInt(u32, .Little) } },
        0xBD => return .{ .mnemonic = .MOV, .op1 = .{ .reg = .EBP }, .op2 = .{ .imm32 = try iter.reader.readInt(u32, .Little) } },
        0xBE => return .{ .mnemonic = .MOV, .op1 = .{ .reg = .ESI }, .op2 = .{ .imm32 = try iter.reader.readInt(u32, .Little) } },
        0xBF => return .{ .mnemonic = .MOV, .op1 = .{ .reg = .EDI }, .op2 = .{ .imm32 = try iter.reader.readInt(u32, .Little) } },

        // MI
        0xC7 => {
            const modrm: ModRM = @bitCast(try iter.reader.readByte());
            if (modrm.sib_follows()) _ = try iter.reader.readByte();
            const disp = try iter.reader.readByte();
            const imm = try iter.reader.readInt(u32, .Little);
            return .{ .mnemonic = .MOV, .op1 = .{ .reg_disp8 = .{ foo2(false, .@"32", null, modrm.rm), disp } }, .op2 = .{ .imm32 = imm } };
        },

        0x50 => return .{ .mnemonic = .PUSH, .op1 = .{ .reg = .EAX } },
        0x51 => return .{ .mnemonic = .PUSH, .op1 = .{ .reg = .ECX } },
        0x52 => return .{ .mnemonic = .PUSH, .op1 = .{ .reg = .EDX } },
        0x53 => return .{ .mnemonic = .PUSH, .op1 = .{ .reg = .EBX } },
        0x54 => return .{ .mnemonic = .PUSH, .op1 = .{ .reg = .ESP } },
        0x55 => return .{ .mnemonic = .PUSH, .op1 = .{ .reg = .EBP } },
        0x56 => return .{ .mnemonic = .PUSH, .op1 = .{ .reg = .ESI } },
        0x57 => return .{ .mnemonic = .PUSH, .op1 = .{ .reg = .EDI } },

        else => std.debug.panic("TODO opcode: {b}", .{std.fmt.fmtSliceHexLower(&.{b})}),
    }
}

// TODO: give this a better name once we understand the full context better
fn foo1(iter: BytesToInstructionIter, mnem: x86.Mnemonic, opsize: x86.OperandSize, w: ?u1) !x86.Instruction {
    const modrm: ModRM = @bitCast(try iter.reader.readByte());
    const reg = foo2(false, opsize, w, modrm.reg);
    const op2 = try foo3(@bitCast(modrm), iter.reader);
    return .{
        .mnemonic = mnem,
        .op1 = .{ .reg = reg },
        .op2 = op2,
    };
}

// TODO: give this a better name once we understand the full context better
fn foo2(is64bit: bool, opsize: x86.OperandSize, w: ?u1, reg: u3) x86.Register {
    // zig fmt: off
    return switch (is64bit) {
        false => switch (opsize) {
            .@"16" => switch (ww(w)) {
                .n => ([_]x86.Register{ .AX, .CX, .DX, .BX, .SP, .BP, .SI, .DI })[reg],
                .z => ([_]x86.Register{ .AL, .CL, .DL, .BL, .AH, .CH, .DH, .BH })[reg],
                .o => ([_]x86.Register{ .AX, .CX, .DX, .BX, .SP, .BP, .SI, .DI })[reg],
            },
            .@"32" => switch (ww(w)) {
                .n => ([_]x86.Register{ .EAX, .ECX, .EDX, .EBX, .ESP, .EBP, .ESI, .EDI })[reg],
                .z => ([_]x86.Register{  .AL,  .CL,  .DL,  .BL,  .AH,  .CH,  .DH,  .BH })[reg],
                .o => ([_]x86.Register{ .EAX, .ECX, .EDX, .EBX, .ESP, .EBP, .ESI, .EDI })[reg],
            },
            .@"64" => unreachable,
        },
        else => @panic("TODO"),
    };
    // zig fmt: on
}

// TODO: give this a better name once we understand the full context better
fn foo3(modrm: u8, reader: Reader) !x86.Operand {
    return switch (modrm) {
        0x00, 0x08, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38 => .{ .reg = .EAX },
        0x01, 0x09, 0x11, 0x19, 0x21, 0x29, 0x31, 0x39 => .{ .reg = .ECX },
        0x02, 0x0A, 0x12, 0x1A, 0x22, 0x2A, 0x32, 0x3A => .{ .reg = .EDX },
        0x03, 0x0B, 0x13, 0x1B, 0x23, 0x2B, 0x33, 0x3B => .{ .reg = .EBX },
        // [--][--]           |     | 100 |  04  |  0C  |  14  |  1C  |  24  |  2C  |  34  |  3C  |
        // disp32             |     | 101 |  05  |  0D  |  15  |  1D  |  25  |  2D  |  35  |  3D  |
        0x06, 0x0E, 0x16, 0x1E, 0x26, 0x2E, 0x36, 0x3E => .{ .reg = .ESI },
        0x07, 0x0F, 0x17, 0x1F, 0x27, 0x2F, 0x37, 0x3F => .{ .reg = .EDI },

        0x40, 0x48, 0x50, 0x58, 0x60, 0x68, 0x70, 0x78 => .{ .reg_disp8 = .{ .EAX, try reader.readByte() } },
        0x41, 0x49, 0x51, 0x59, 0x61, 0x69, 0x71, 0x79 => .{ .reg_disp8 = .{ .ECX, try reader.readByte() } },
        0x42, 0x4A, 0x52, 0x5A, 0x62, 0x6A, 0x72, 0x7A => .{ .reg_disp8 = .{ .EDX, try reader.readByte() } },
        0x43, 0x4B, 0x53, 0x5B, 0x63, 0x6B, 0x73, 0x7B => .{ .reg_disp8 = .{ .EBX, try reader.readByte() } },
        0x44, 0x4C, 0x54, 0x5C, 0x64, 0x6C, 0x74, 0x7C => .{ .reg_disp8 = .{ try foo4(reader), try reader.readByte() } },
        0x45, 0x4D, 0x55, 0x5D, 0x65, 0x6D, 0x75, 0x7D => .{ .reg_disp8 = .{ .EBP, try reader.readByte() } },
        0x46, 0x4E, 0x56, 0x5E, 0x66, 0x6E, 0x76, 0x7E => .{ .reg_disp8 = .{ .ESI, try reader.readByte() } },
        0x47, 0x4F, 0x57, 0x5F, 0x67, 0x6F, 0x77, 0x7F => .{ .reg_disp8 = .{ .EDI, try reader.readByte() } },

        // [EAX]+disp32       | 10  | 000 |  80  |  88  |  90  |  98  |  A0  |  A8  |  B0  |  B8  |
        // [ECX]+disp32       |     | 001 |  81  |  89  |  91  |  99  |  A1  |  A9  |  B1  |  B9  |
        // [EDX]+disp32       |     | 010 |  82  |  8A  |  92  |  9A  |  A2  |  AA  |  B2  |  BA  |
        // [EBX]+disp32       |     | 011 |  83  |  8B  |  93  |  9B  |  A3  |  AB  |  B3  |  BB  |
        // [--][--]+disp32    |     | 100 |  84  |  8C  |  94  |  9C  |  A4  |  AC  |  B4  |  BC  |
        // [EBP]+disp32       |     | 101 |  85  |  8D  |  95  |  9D  |  A5  |  AD  |  B5  |  BD  |
        // [ESI]+disp32       |     | 110 |  86  |  8E  |  96  |  9E  |  A6  |  AE  |  B6  |  BE  |
        // [EDI]+disp32       |     | 111 |  87  |  8F  |  97  |  9F  |  A7  |  AF  |  B7  |  BF  |

        // EAX/AX/AL/MM0/XMM0 | 11  | 000 |  C0  |  C8  |  D0  |  D8  |  E0  |  E8  |  F0  |  F8  |
        // ECX/CX/CL/MM/XMM1  |     | 001 |  C1  |  C9  |  D1  |  D9  |  E1  |  E9  |  F1  |  F9  |
        // EDX/DX/DL/MM2/XMM2 |     | 010 |  C2  |  CA  |  D2  |  DA  |  E2  |  EA  |  F2  |  FA  |
        // EBX/BX/BL/MM3/XMM3 |     | 011 |  C3  |  CB  |  D3  |  DB  |  E3  |  EB  |  F3  |  FB  |
        // ESP/SP/AH/MM4/XMM4 |     | 100 |  C4  |  CC  |  D4  |  DC  |  E4  |  EC  |  F4  |  FC  |
        // EBP/BP/CH/MM5/XMM5 |     | 101 |  C5  |  CD  |  D5  |  DD  |  E5  |  ED  |  F5  |  FD  |
        // ESI/SI/DH/MM6/XMM6 |     | 110 |  C6  |  CE  |  D6  |  DE  |  E6  |  EE  |  F6  |  FE  |
        // EDI/DI/BH/MM7/XMM7 |     | 111 |  C7  |  CF  |  D7  |  DF  |  E7  |  EF  |  F7  |  FF  |

        else => std.debug.panic("TODO {b}", .{std.fmt.fmtSliceHexLower(&.{modrm})}),
    };
}

// TODO: give this a better name once we understand the full context better
fn foo4(reader: Reader) !x86.Register {
    const sib: SIB = @bitCast(try reader.readByte());
    const sib_b: u8 = @bitCast(sib);
    return switch (sib_b) {
        // XXX: not totally sure how this function is supposed to work
        0x20 => .EAX,
        0x21 => .ECX,
        0x22 => .EDX,
        0x23 => .EBX,
        0x24 => .ESP,

        else => std.debug.panic("TODO {b}", .{std.fmt.fmtSliceHexLower(&.{sib_b})}),
    };
}

const ModRM = packed struct(u8) {
    rm: u3,
    reg: u3,
    mod: u2,

    fn sib_follows(self: ModRM) bool {
        return switch (@as(u8, @bitCast(self))) {
            0x04, 0x0C, 0x14, 0x1C, 0x24, 0x2C, 0x34, 0x3C => true,
            0x44, 0x4C, 0x54, 0x5C, 0x64, 0x6C, 0x74, 0x7C => true,
            0x84, 0x8C, 0x94, 0x9C, 0xA4, 0xAC, 0xB4, 0xBC => true,
            else => false,
        };
    }
};

const W = enum {
    n,
    z,
    o,
};
fn ww(w: ?u1) W {
    if (w == null) return .n;
    if (w == 0) return .z;
    if (w == 1) return .o;
    unreachable;
}

const SIB = packed struct(u8) {
    base: u3,
    index: u3,
    scale: u2,
};
