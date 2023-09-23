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
        0xC3 => return .{ .mnemonic = .RET },

        else => std.debug.panic("TODO opcode: {b}", .{std.fmt.fmtSliceHexLower(&.{b})}),
    }
}
