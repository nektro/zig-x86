const std = @import("std");

const OperandSize = enum(u8) {
    @"16" = 16,
    @"32" = 32,
    @"64" = 64,
};
