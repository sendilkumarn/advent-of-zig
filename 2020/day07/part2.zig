const inp = @embedFile("inp.txt");
const std = @import("std");
const tokenize = std.mem.tokenize;
const split = std.mem.split;
const print = std.debug.print;

const BagWithCount = struct {
    bag: []const u8,
    count: u8,
};

fn concat(allocator: *std.mem.Allocator, a: []const u8, b: []const u8) ![]u8 {
    const result = try allocator.alloc(u8, a.len + b.len);
    std.mem.copy(u8, result, a);
    std.mem.copy(u8, result[a.len..], b);
    return result;
}

fn countGoldBag(map: std.StringHashMap(std.ArrayList(BagWithCount)), parent: []const u8) usize {
    var items = map.get(parent).?;
    var count: usize = 0;
    for (items.items) |i| {
        count += i.count + (i.count * countGoldBag(map, i.bag));
    }
    return count;
}

pub fn main() !void {
    var lines = split(inp, "\n");
    var count: usize = 0;
    var map = std.StringHashMap(std.ArrayList(BagWithCount)).init(std.testing.allocator);
    defer map.deinit();

    while (lines.next()) |line| {
        var words = split(line, " ");
        var parentBag = try concat(std.testing.allocator, words.next().?, words.next().?);

        _ = words.next();
        _ = words.next();
        var list = std.ArrayList(BagWithCount).init(std.testing.allocator);

        while (words.next()) |no| {
            if (!std.mem.eql(u8, no, "no")) {
                var w = words.next().?;
                if (!(std.mem.eql(u8, w[0 .. w.len - 1], "bags") or std.mem.eql(u8, w[0 .. w.len - 1], "bag"))) {
                    var childBag = try concat(std.testing.allocator, w, words.next().?);
                    var bagWithCount = BagWithCount{
                        .bag = childBag,
                        .count = std.fmt.parseInt(u8, no, 10) catch unreachable,
                    };

                    try list.append(bagWithCount);
                }
                _ = words.next();
            } else {
                _ = words.next();
                _ = words.next();
            }
        }

        try map.put(parentBag, list);
    }

    count = countGoldBag(map, "shinygold");

    print("count {}\n", .{count});
}
