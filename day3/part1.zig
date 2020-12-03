const inp = @embedFile("inp.txt");
const std = @import("std");

pub fn main() void {
    var lines = std.mem.tokenize(inp, "\n");

    var x: usize = 0;
    var y: usize = 0;
    var count: usize = 0;

    while (lines.next()) |line| {
        var points = line[x];
        if (line[x] == '#') {
            count += 1;
        }
        x += 3;
    }

    std.debug.print("{}", .{count});
}
