const inp = @embedFile("inp.txt");
const std = @import("std");
const print = std.debug.print;
const tokenize = std.mem.tokenize;

pub fn main() !void {
    var groups = tokenize(inp, "$$$");
    var count: u32 = 0;

    while (groups.next()) |group| {
        var map = std.AutoHashMap(u8, void).init(std.testing.allocator);
        var lines = tokenize(group, "\n");
        while (lines.next()) |line| {
            for (line) |char| {
                try map.put(char, {});
            }
        }
        count += map.count();
    }

    print("count: {}\n", .{count});
}
