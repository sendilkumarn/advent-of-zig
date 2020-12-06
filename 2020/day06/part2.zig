const inp = @embedFile("inp.txt");
const std = @import("std");
const print = std.debug.print;
const tokenize = std.mem.tokenize;

pub fn main() !void {
    var groups = tokenize(inp, "$$$");
    var count: i32 = 0;

    while (groups.next()) |group| {
        var members: i32 = 0;
        var map = std.AutoHashMap(u8, i32).init(std.testing.allocator);
        var lines = tokenize(group, "\n");
        while (lines.next()) |line| {
            for (line) |char| {
                if (map.get(char)) |co| {
                    var t: i32 = co + 1;
                    try map.put(char, t);
                } else {
                    try map.put(char, 1);
                }
            }
            members += 1;
        }

        var it = map.iterator();

        while (it.next()) |m| {
            if (m.value == members) {
                count += 1;
            }
        }
    }

    print("count: {}\n", .{count});
}
