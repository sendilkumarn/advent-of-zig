const std = @import("std");
const inp = @embedFile("inp.txt");
const parseInt = std.fmt.parseInt;
const tokenize = std.mem.tokenize;
const Vector = std.meta.Vector;

pub fn main() void {
    var lines = tokenize(inp, "\n");
    var totalCount: usize = 0;
    while (lines.next()) |line| {
        var words = tokenize(line, " ");
        var occurences = tokenize(words.next().?, "-");
        const min = (parseInt(usize, occurences.next().?, 10) catch unreachable) - 1;
        const max = (parseInt(usize, occurences.next().?, 10) catch unreachable) - 1;
        const charWithSeparator = words.next().?;
        const char = (tokenize(charWithSeparator, ":")).next().?[0];
        const value = words.next().?;
        const out: Vector(2, bool) = [_]bool{ (value[min] == char), (value[max] == char) };

        if (@reduce(.Xor, out)) {
            totalCount = totalCount + 1;
        }
    }

    std.debug.print("totalCount: {}\n", .{totalCount});
}
