const std = @import("std");
const string = []const u8;
const x86 = @import("x86");

fn Cases(comptime hex_long: string, comptime asm_long: string) type {
    _ = hex_long;
    _ = asm_long;

    return struct {
        // test {
        //     // hex -> asm
        // }

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

// 0000000000000000 <add>:
comptime { _ = Cases("55                              ", "push   %rbp                      "); }
comptime { _ = Cases("48 89 e5                        ", "mov    %rsp,%rbp                 "); }
comptime { _ = Cases("48 83 ec 10                     ", "sub    $0x10,%rsp                "); }
comptime { _ = Cases("89 7d f8                        ", "mov    %edi,-0x8(%rbp)           "); }
comptime { _ = Cases("89 75 fc                        ", "mov    %esi,-0x4(%rbp)           "); }
comptime { _ = Cases("01 f7                           ", "add    %esi,%edi                 "); }
comptime { _ = Cases("89 7d f4                        ", "mov    %edi,-0xc(%rbp)           "); }
comptime { _ = Cases("0f 90 c0                        ", "seto   %al                       "); }
comptime { _ = Cases("70 02                           ", "jo     1a <add+0x1a>             "); }
comptime { _ = Cases("eb 22                           ", "jmp    3c <add+0x3c>             "); }
comptime { _ = Cases("48 bf 00 00 00 00 00 00 00 00   ", "movabs $0x0,%rdi                 "); }
comptime { _ = Cases("be 10 00 00 00                  ", "mov    $0x10,%esi                "); }
comptime { _ = Cases("31 c0                           ", "xor    %eax,%eax                 "); }
comptime { _ = Cases("89 c2                           ", "mov    %eax,%edx                 "); }
comptime { _ = Cases("48 b9 00 00 00 00 00 00 00 00   ", "movabs $0x0,%rcx                 "); }
comptime { _ = Cases("e8 14 00 00 00                  ", "call   50 <builtin.default_panic>"); }
comptime { _ = Cases("8b 45 f4                        ", "mov    -0xc(%rbp),%eax           "); }
comptime { _ = Cases("48 83 c4 10                     ", "add    $0x10,%rsp                "); }
comptime { _ = Cases("5d                              ", "pop    %rbp                      "); }
comptime { _ = Cases("c3                              ", "ret                              "); }
comptime { _ = Cases("66 66 2e 0f 1f 84 00 00 00 00 00", "data16 cs nopw 0x0(%rax,%rax,1)  "); }


// 0000000000000000 <add>:
comptime { _ = Cases("01 f7               ", "add    %esi,%edi    "); }
comptime { _ = Cases("70 03               ", "jo     7 <add+0x7>  "); }
comptime { _ = Cases("89 f8               ", "mov    %edi,%eax    "); }
comptime { _ = Cases("c3                  ", "ret                 "); }
comptime { _ = Cases("50                  ", "push   %rax         "); }
comptime { _ = Cases("bf 00 00 00 00      ", "mov    $0x0,%edi    "); }
comptime { _ = Cases("be 10 00 00 00      ", "mov    $0x10,%esi   "); }
comptime { _ = Cases("31 c9               ", "xor    %ecx,%ecx    "); }
comptime { _ = Cases("e8 00 00 00 00      ", "call   19 <add+0x19>"); }
comptime { _ = Cases("0f 1f 80 00 00 00 00", "nopl   0x0(%rax)    "); }
