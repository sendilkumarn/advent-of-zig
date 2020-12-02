const std = @import("std");
const inp = @embedFile("inp.txt");
const fmt = std.fmt;
const mem = std.mem;

pub fn main() void {
    var lines = mem.tokenize(inp, "\n");
    var totalCount: usize = 0;
    while (lines.next()) |line| {
        var count: i32 = -1;
        var words = mem.tokenize(line, " ");
        var occurences = mem.tokenize(words.next().?, "-");
        const min = fmt.parseInt(usize, occurences.next().?, 10) catch unreachable;
        const max = fmt.parseInt(usize, occurences.next().?, 10) catch unreachable;
        const charWithSeparator = words.next().?;
        const char = (mem.tokenize(charWithSeparator, ":")).next().?;
        const value = words.next().?;
        var d = mem.split(value, char);

        while (d.next()) |dd| {
            count = count + 1;
        }

        if (count <= max and count >= min) {
            totalCount = totalCount + 1;
        }
    }

    std.debug.print("totalCount: {}\n", .{totalCount});
}
