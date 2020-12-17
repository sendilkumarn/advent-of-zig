const inp = @embedFile("inp.txt");
const std = @import("std");
const split = std.mem.split;
const print = std.debug.print;
const parseInt = std.fmt.parseInt;

pub fn main() !void {
    var lines = split(inp, "\n");

    var jolts = std.ArrayList(i64).init(std.testing.allocator);
    defer jolts.deinit();

    try jolts.append(0);
    while (lines.next()) |line| {
        try jolts.append(parseInt(i64, line, 10) catch unreachable);
    }
    std.sort.sort(i64, jolts.items, {}, comptime std.sort.desc(i64));
    try jolts.insert(0, jolts.items[jolts.items.len - 1] + 3);

    const len = jolts.items.len;
    var counter = try std.testing.allocator.alloc(i64, len);
    var k: usize = 0;
    while (k < counter.len) {
        counter[k] = 0;
        k += 1;
    }
    counter[len - 1] = 1;
    var i: usize = len - 2;
    while (i != 0) {
        var count: i64 = 0;
        var jolt = jolts.items[i];
        if (i + 1 < len and jolt - jolts.items[i + 1] <= 3) {
            count += counter[i + 1];
        }
        if (i + 2 < len and jolt - jolts.items[i + 2] <= 3) {
            count += counter[i + 2];
        }
        if (i + 3 < len and jolt - jolts.items[i + 3] <= 3) {
            count += counter[i + 3];
        }
        counter[i] = count;
        i -= 1;
    }

    print("part2 :: {}\n", .{counter[1]});
}
