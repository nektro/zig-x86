const std = @import("std");
const Reader = @This();

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

/// Reads 1 byte from the stream or returns `error.EndOfStream`.
pub fn readByte(self: Reader) !u8 {
    var result: [1]u8 = undefined;
    const amt_read = try self.read(result[0..]);
    if (amt_read < 1) return error.EndOfStream;
    return result[0];
}
