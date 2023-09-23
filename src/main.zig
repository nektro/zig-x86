const std = @import("std");
const string = []const u8;
const x86 = @import("x86");

fn Cases(comptime hex_long: string, comptime asm_long: string) type {
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
            const asm_short = comptime blk: {
                var result: string = &.{};
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
            try std.testing.expectFmt(asm_short, "{}", .{instr.?});
            try std.testing.expect((try iter.next()) == null);
        }

        // test {
        //     // hex -> hex
        // }

        // test {
        //     // asm -> hex
        // }

        // test {
        //     // asm -> asm
        // }
    };
}

// zig fmt: off

// 00000000 <add>:
// comptime { _ = Cases("83 ec 0c               ", "sub    esp,0xc                  "); }
comptime { _ = Cases("8b 44 24 10            ", "mov    eax,DWORD PTR [esp+0x10] "); }
// comptime { _ = Cases("03 44 24 14            ", "add    eax,DWORD PTR [esp+0x14] "); }
// comptime { _ = Cases("70 04                  ", "jo     11 <add+0x11>            "); }
// comptime { _ = Cases("83 c4 0c               ", "add    esp,0xc                  "); }
comptime { _ = Cases("c3                     ", "ret                             "); }
// comptime { _ = Cases("b9 25 00 00 00         ", "mov    ecx,0x25                 "); }
// comptime { _ = Cases("ba 10 00 00 00         ", "mov    edx,0x10                 "); }
// comptime { _ = Cases("c7 44 24 04 00 00 00 00", "mov    DWORD PTR [esp+0x4],0x0  "); }
// comptime { _ = Cases("e8 fc ff ff ff         ", "call   24 <add+0x24>            "); }
// comptime { _ = Cases("0f 1f 84 00 00 00 00 00", "nop    DWORD PTR [eax+eax*1+0x0]"); }
