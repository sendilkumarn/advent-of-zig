const inp = @embedFile("inp.txt");
const std = @import("std");
const split = std.mem.split;
const print = std.debug.print;
const parseInt = std.fmt.parseInt;

pub fn main() !void {
    var lines = split(inp, "\n");
    var part1: i64 = 0;

    var jolts = std.ArrayList(i64).init(std.testing.allocator);
    defer jolts.deinit();

    while (lines.next()) |line| {
        try jolts.append(parseInt(i64, line, 10) catch unreachable);
    }
    std.sort.sort(i64, jolts.items, {}, comptime std.sort.asc(i64));

    var currentJolt: i64 = 0;
    var one: i64 = 0;
    var three: i64 = 0;

    for (jolts.items) |jolt, i| {
        if (jolt - currentJolt == 1) {
            one += 1;
        } else if (jolt - currentJolt == 3) {
            three += 1;
        }
        currentJolt = jolt;
    }

    part1 = one * (three + 1);
    print("part1 :: {}\n", .{part1});
}
