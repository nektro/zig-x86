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

comptime { _ = Cases2("  30", "55                     ", "push   ebp"); }
comptime { _ = Cases2("  31", "53                     ", "push   ebx"); }
comptime { _ = Cases2("  32", "57                     ", "push   edi"); }
comptime { _ = Cases2("  33", "56                     ", "push   esi"); }
comptime { _ = Cases2("  44", "b8 aa aa aa aa         ", "mov    eax,0xaaaaaaaa"); }
comptime { _ = Cases2("  49", "b9 20 00 00 00         ", "mov    ecx,0x20"); }
comptime { _ = Cases2("  52", "b8 af 00 00 00         ", "mov    eax,0xaf"); }
comptime { _ = Cases2("  59", "b9 f0 05 00 00         ", "mov    ecx,0x5f0"); }
comptime { _ = Cases2("  5e", "be 08 00 00 00         ", "mov    esi,0x8"); }
comptime { _ = Cases2("  77", "b8 e0 00 00 00         ", "mov    eax,0xe0"); }
comptime { _ = Cases2("  85", "b8 ee 00 00 00         ", "mov    eax,0xee"); }
comptime { _ = Cases2("  94", "b8 af 00 00 00         ", "mov    eax,0xaf"); }
comptime { _ = Cases2("  99", "bb 02 00 00 00         ", "mov    ebx,0x2"); }
comptime { _ = Cases2("  cd", "c3                     ", "ret"); }
comptime { _ = Cases2("  ce", "8b 74 24 08            ", "mov    esi,DWORD PTR [esp+0x8]"); }
comptime { _ = Cases2("  d4", "e8 9c 0c 00 00         ", "call   d75"); }
comptime { _ = Cases2("  db", "e8 9c 0c 00 00         ", "call   d7c"); }
comptime { _ = Cases2("  f6", "c7 44 24 04 00 00 00 00", "mov    DWORD PTR [esp+0x4],0x0"); }
comptime { _ = Cases2("  fe", "b9 e1 00 00 00         ", "mov    ecx,0xe1"); }
comptime { _ = Cases2(" 103", "ba 18 00 00 00         ", "mov    edx,0x18"); }
comptime { _ = Cases2(" 108", "e8 fc ff ff ff         ", "call   109"); }
comptime { _ = Cases2(" 10d", "90                     ", "nop"); }
comptime { _ = Cases2(" 10e", "90                     ", "nop"); }
comptime { _ = Cases2(" 10f", "90                     ", "nop"); }
