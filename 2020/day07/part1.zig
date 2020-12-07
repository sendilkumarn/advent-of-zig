const inp = @embedFile("inp.txt");
const std = @import("std");
const tokenize = std.mem.tokenize;
const split = std.mem.split;
const print = std.debug.print;

fn concat(allocator: *std.mem.Allocator, a: []const u8, b: []const u8) ![]u8 {
    const result = try allocator.alloc(u8, a.len + b.len);
    std.mem.copy(u8, result, a);
    std.mem.copy(u8, result[a.len..], b);
    return result;
}

fn checkGoldBag(map: std.StringHashMap(std.ArrayList([]u8)), kv: std.ArrayList([]u8), parent: []const u8) bool {
    for (kv.items) |kvv| {
        if (std.mem.eql(u8, kvv, "shinygold")) {
            return true;
        }
        var t = map.get(kvv).?;
        if (checkGoldBag(map, t, kvv)) {
            return true;
        }
    }
    return false;
}

pub fn main() !void {
    var lines = split(inp, "\n");
    var count: usize = 0;
    var map = std.StringHashMap(std.ArrayList([]u8)).init(std.testing.allocator);
    defer map.deinit();

    while (lines.next()) |line| {
        var words = split(line, " ");
        var parentBag = try concat(std.testing.allocator, words.next().?, words.next().?);

        _ = words.next();
        _ = words.next();
        var isNo = words.next();
        var list = std.ArrayList([]u8).init(std.testing.allocator);
        if (isNo) |no| {
            if (!std.mem.eql(u8, no, "no")) {
                while (words.next()) |w| {
                    if (!(std.mem.eql(u8, w[0 .. w.len - 1], "bags") or std.mem.eql(u8, w[0 .. w.len - 1], "bag"))) {
                        var childBag = try concat(std.testing.allocator, w, words.next().?);
                        try list.append(childBag);
                    } else {
                        _ = words.next();
                    }
                }
            }
        }

        try map.put(parentBag, list);
    }
    var it = map.iterator();
    var list1 = std.ArrayList([]u8).init(std.testing.allocator);
    while (it.next()) |kv| {
        if (checkGoldBag(map, kv.value, kv.key)) {
            count += 1;
        }
    }

    print("count {}\n", .{count});
}
