const inp = @embedFile("inp.txt");
const std = @import("std");
const tokenize = std.mem.tokenize;
const split = std.mem.split;
const print = std.debug.print;
const parseInt = std.fmt.parseInt;
const eql = std.mem.eql;

fn cmp(context: void, lhs: i64, rhs: i64) bool {
    return lhs < rhs;
}

fn findSum(arr: std.ArrayList(i64), sum: i64) !void {
    var s: i64 = 0;
    var end: usize = 0;
    var start: usize = 0;

    while (end < arr.items.len or s > sum) {
        if (s < sum) {
            s += arr.items[end];
            end += 1;
        } else if (s > sum) {
            s -= arr.items[start];
            start += 1;
        } else {
            var tmp = arr.items[start..end];
            std.sort.sort(i64, tmp, {}, cmp);
            print("part2 :: {}\n", .{tmp[0] + tmp[tmp.len - 1]});
            break;
        }
    }
}

pub fn main() !void {
    var lines = split(inp, "\n");
    var part1: i64 = 0;

    var tmp = std.ArrayList(i64).init(std.testing.allocator);
    defer tmp.deinit();

    var i: usize = 25;
    var indx: usize = 0;
    while (lines.next()) |line| {
        try tmp.append(parseInt(i64, line, 10) catch unreachable);

        if (indx > 24 and part1 == 0) {
            var p = tmp.items[i];
            var last25 = tmp.items[i - 25 .. i];
            var isOut = false;
            for (last25) |t, k| {
                for (last25) |s, j| {
                    if (k != j and (t + s == p)) {
                        isOut = true;
                    }
                }
            }
            if (!isOut) {
                print("part1 :: {}\n", .{p});
                part1 = p;
            }
            i += 1;
        }
        indx += 1;
    }

    try findSum(tmp, part1);
}
