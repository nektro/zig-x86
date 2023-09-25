const std = @import("std");
const string = []const u8;
const x86 = @import("x86");

fn Cases2(comptime baseaddr_str: string, comptime hex_long: string, comptime asm_long: string) type {
    return struct {
        // hex -> asm
        test {
            const hex = comptime blk: {
                var result: []const u8 = &.{};
                var iter = std.mem.tokenizeScalar(u8, hex_long, ' ');
                while (iter.next()) |item| {
                    result = result ++ &[_]u8{try std.fmt.parseInt(u8, item, 16)};
                }
                break :blk result;
            };
            const asm_expected = comptime blk: {
                var result: string = "";
                var iter = std.mem.tokenizeScalar(u8, asm_long, ' ');
                while (iter.next()) |item| {
                    if (result.len > 0) result = result ++ " ";
                    result = result ++ item;
                }
                break :blk result;
            };

            var fbs = std.io.fixedBufferStream(hex);
            const iter = x86.BytesToInstructionIter.init(fbs.reader());
            const instr = try iter.next();
            const allocator = std.testing.allocator;
            var list = std.ArrayList(u8).init(allocator);
            defer list.deinit();
            try instr.?.format(std.mem.trimLeft(u8, baseaddr_str, " "), .{}, list.writer());
            try std.testing.expectEqualStrings(asm_expected, list.items);
            try std.testing.expect((try iter.next()) == null);
        }

        // hex -> hex
        // test {
        // }

        // asm -> hex
        // test {
        // }

        // asm -> asm
        // test {
        // }
    };
}

// zig fmt: off

comptime { _ = Cases2("   0", "83 ec 0c               ", "sub    esp,0xc"); }
comptime { _ = Cases2("   3", "8b 44 24 10            ", "mov    eax,DWORD PTR [esp+0x10]"); }
comptime { _ = Cases2("   7", "03 44 24 14            ", "add    eax,DWORD PTR [esp+0x14]"); }
comptime { _ = Cases2("   b", "70 04                  ", "jo     11"); }
comptime { _ = Cases2("   d", "83 c4 0c               ", "add    esp,0xc"); }
comptime { _ = Cases2("  10", "c3                     ", "ret"); }
comptime { _ = Cases2("  11", "c7 44 24 04 00 00 00 00", "mov    DWORD PTR [esp+0x4],0x0"); }
comptime { _ = Cases2("  19", "b9 25 00 00 00         ", "mov    ecx,0x25"); }
comptime { _ = Cases2("  1e", "ba 10 00 00 00         ", "mov    edx,0x10"); }
comptime { _ = Cases2("  23", "e8 fc ff ff ff         ", "call   24"); }
comptime { _ = Cases2("  28", "90                     ", "nop"); }
comptime { _ = Cases2("  29", "90                     ", "nop"); }
comptime { _ = Cases2("  2a", "90                     ", "nop"); }
comptime { _ = Cases2("  2b", "90                     ", "nop"); }
comptime { _ = Cases2("  2c", "90                     ", "nop"); }
comptime { _ = Cases2("  2d", "90                     ", "nop"); }
comptime { _ = Cases2("  2e", "90                     ", "nop"); }
comptime { _ = Cases2("  2f", "90                     ", "nop"); }
