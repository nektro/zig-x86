const std = @import("std");
const Reader = @This();
const assert = std.debug.assert;

readFn: *const fn (*anyopaque, []u8) anyerror!usize,
state: *anyopaque,

pub fn from(reader: anytype) Reader {
    const R = @TypeOf(reader);
    const ctx = reader.context;
    const Ctx = @TypeOf(ctx);
    comptime std.debug.assert(std.meta.trait.is(.Pointer)(Ctx));
    const S = struct {
        fn foo(s: *anyopaque, buffer: []u8) anyerror!usize {
            const r = R{ .context = @ptrCast(@alignCast(s)) };
            return r.read(buffer);
        }
    };
    return .{
        .readFn = S.foo,
        .state = ctx,
    };
}

pub fn read(r: Reader, buffer: []u8) anyerror!usize {
    return r.readFn(r.state, buffer);
}

pub fn readByte(self: Reader) !u8 {
    var result: [1]u8 = undefined;
    const amt_read = try self.read(result[0..]);
    if (amt_read < 1) return error.EndOfStream;
    return result[0];
}

pub fn readInt(self: Reader, comptime T: type, endian: std.builtin.Endian) !T {
    const bytes = try self.readBytesNoEof(@as(u16, @intCast((@as(u17, @typeInfo(T).Int.bits) + 7) / 8)));
    return std.mem.readInt(T, &bytes, endian);
}

pub fn readBytesNoEof(self: Reader, comptime num_bytes: usize) ![num_bytes]u8 {
    var bytes: [num_bytes]u8 = undefined;
    try self.readNoEof(&bytes);
    return bytes;
}

pub fn readNoEof(self: Reader, buf: []u8) !void {
    const amt_read = try self.readAll(buf);
    if (amt_read < buf.len) return error.EndOfStream;
}

pub fn readAll(self: Reader, buffer: []u8) !usize {
    return self.readAtLeast(buffer, buffer.len);
}

pub fn readAtLeast(self: Reader, buffer: []u8, len: usize) !usize {
    assert(len <= buffer.len);
    var index: usize = 0;
    while (index < len) {
        const amt = try self.read(buffer[index..]);
        if (amt == 0) break;
        index += amt;
    }
    return index;
}
