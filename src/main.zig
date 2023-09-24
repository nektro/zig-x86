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

fn Cases2(comptime baseaddr_str: string, comptime hex_long: string, comptime asm_expected: string) type {
    return struct {
        // hex -> asm
        test {
            const baseaddr = try std.fmt.parseUnsigned(u64, baseaddr_str, 16);
            const hex = comptime blk: {
                var result: []const u8 = &.{};
                var iter = std.mem.window(u8, std.mem.trimRight(u8, hex_long, " "), 2, 2);
                while (iter.next()) |item| {
                    result = result ++ &[_]u8{try std.fmt.parseInt(u8, item, 16)};
                }
                break :blk result;
            };
            var fbs = std.io.fixedBufferStream(hex);
            const iter = x86.BytesToInstructionIter.init(fbs.reader());
            const instr = try iter.next();
            const allocator = std.testing.allocator;
            var list = std.ArrayList(u8).init(allocator);
            defer list.deinit();
            try instr.?.renderNasm(baseaddr, list.writer());
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

comptime { _ = Cases("8b 44 24 10", "mov eax,DWORD PTR [esp+0x10]"); }
comptime { _ = Cases("03 44 24 14", "add eax,DWORD PTR [esp+0x14]"); }
comptime { _ = Cases("c3", "ret"); }
comptime { _ = Cases("b9 25 00 00 00", "mov ecx,0x25"); }
comptime { _ = Cases("ba 10 00 00 00", "mov edx,0x10"); }
comptime { _ = Cases("c7 44 24 04 00 00 00 00", "mov DWORD PTR [esp+0x4],0x0"); }
comptime { _ = Cases("55", "push ebp"); }
comptime { _ = Cases("53", "push ebx"); }
comptime { _ = Cases("57", "push edi"); }
comptime { _ = Cases("56", "push esi"); }
comptime { _ = Cases("8b 44 24 08", "mov eax,DWORD PTR [esp+0x8]"); }
comptime { _ = Cases("03 44 24 04", "add eax,DWORD PTR [esp+0x4]"); }
comptime { _ = Cases("c7 44 24 04 00 00 00 00", "mov DWORD PTR [esp+0x4],0x0"); }
comptime { _ = Cases("b9 25 00 00 00", "mov ecx,0x25"); }
comptime { _ = Cases("ba 10 00 00 00", "mov edx,0x10"); }
comptime { _ = Cases("90", "nop"); }

comptime { _ = Cases2("00000010", "C3              ", "ret"); }
comptime { _ = Cases2("00000011", "C744240400000000", "mov dword [esp+0x4],0x0"); }
comptime { _ = Cases2("00000019", "B925000000      ", "mov ecx,0x25"); }
comptime { _ = Cases2("0000001E", "BA10000000      ", "mov edx,0x10"); }
comptime { _ = Cases2("00000028", "90              ", "nop"); }
comptime { _ = Cases2("00000029", "90              ", "nop"); }
comptime { _ = Cases2("0000002A", "90              ", "nop"); }
comptime { _ = Cases2("0000002B", "90              ", "nop"); }
comptime { _ = Cases2("0000002C", "90              ", "nop"); }
comptime { _ = Cases2("0000002D", "90              ", "nop"); }
comptime { _ = Cases2("0000002E", "90              ", "nop"); }
comptime { _ = Cases2("0000002F", "90              ", "nop"); }
comptime { _ = Cases2("00000030", "55              ", "push ebp"); }
comptime { _ = Cases2("00000031", "53              ", "push ebx"); }
comptime { _ = Cases2("00000032", "57              ", "push edi"); }
comptime { _ = Cases2("00000033", "56              ", "push esi"); }
