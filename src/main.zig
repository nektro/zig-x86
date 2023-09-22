const std = @import("std");
const string = []const u8;
const x86 = @import("x86");

pub fn expectFmt(arg: anytype, comptime expected: string) !void {
    const real_expected = comptime blk: {
        var result: string = "";
        var iter = std.mem.tokenizeScalar(u8, expected, ' ');
        while (iter.next()) |item| {
            if (result.len > 0) result = result ++ " ";
            result = result ++ item;
        }
        break :blk result;
    };
    return std.testing.expectFmt(real_expected, "{}", .{arg});
}

pub fn parse(comptime hex_str: string) void {
    // TODO: trim spaces from right and middle of hex_str
    _ = hex_str;
}

// zig fmt: off

// 0000000000000000 <add>:
test { try expectFmt(parse("55                              "), "push   %rbp                      "); }
test { try expectFmt(parse("48 89 e5                        "), "mov    %rsp,%rbp                 "); }
test { try expectFmt(parse("48 83 ec 10                     "), "sub    $0x10,%rsp                "); }
test { try expectFmt(parse("89 7d f8                        "), "mov    %edi,-0x8(%rbp)           "); }
test { try expectFmt(parse("89 75 fc                        "), "mov    %esi,-0x4(%rbp)           "); }
test { try expectFmt(parse("01 f7                           "), "add    %esi,%edi                 "); }
test { try expectFmt(parse("89 7d f4                        "), "mov    %edi,-0xc(%rbp)           "); }
test { try expectFmt(parse("0f 90 c0                        "), "seto   %al                       "); }
test { try expectFmt(parse("70 02                           "), "jo     1a <add+0x1a>             "); }
test { try expectFmt(parse("eb 22                           "), "jmp    3c <add+0x3c>             "); }
test { try expectFmt(parse("48 bf 00 00 00 00 00 00 00 00   "), "movabs $0x0,%rdi                 "); }
test { try expectFmt(parse("be 10 00 00 00                  "), "mov    $0x10,%esi                "); }
test { try expectFmt(parse("31 c0                           "), "xor    %eax,%eax                 "); }
test { try expectFmt(parse("89 c2                           "), "mov    %eax,%edx                 "); }
test { try expectFmt(parse("48 b9 00 00 00 00 00 00 00 00   "), "movabs $0x0,%rcx                 "); }
test { try expectFmt(parse("e8 14 00 00 00                  "), "call   50 <builtin.default_panic>"); }
test { try expectFmt(parse("8b 45 f4                        "), "mov    -0xc(%rbp),%eax           "); }
test { try expectFmt(parse("48 83 c4 10                     "), "add    $0x10,%rsp                "); }
test { try expectFmt(parse("5d                              "), "pop    %rbp                      "); }
test { try expectFmt(parse("c3                              "), "ret                              "); }
test { try expectFmt(parse("66 66 2e 0f 1f 84 00 00 00 00 00"), "data16 cs nopw 0x0(%rax,%rax,1)  "); }


// 0000000000000000 <add>:
test { try expectFmt(parse("01 f7               "), "add    %esi,%edi    "); }
test { try expectFmt(parse("70 03               "), "jo     7 <add+0x7>  "); }
test { try expectFmt(parse("89 f8               "), "mov    %edi,%eax    "); }
test { try expectFmt(parse("c3                  "), "ret                 "); }
test { try expectFmt(parse("50                  "), "push   %rax         "); }
test { try expectFmt(parse("bf 00 00 00 00      "), "mov    $0x0,%edi    "); }
test { try expectFmt(parse("be 10 00 00 00      "), "mov    $0x10,%esi   "); }
test { try expectFmt(parse("31 c9               "), "xor    %ecx,%ecx    "); }
test { try expectFmt(parse("e8 00 00 00 00      "), "call   19 <add+0x19>"); }
test { try expectFmt(parse("0f 1f 80 00 00 00 00"), "nopl   0x0(%rax)    "); }
