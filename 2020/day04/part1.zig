const inp = @embedFile("inp.txt");
const std = @import("std");

pub fn main() void {
    var lines = std.mem.tokenize(inp, "%%%");
    var valid: usize = 0;
    var givenTags = [_][]const u8{ "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid" };

    while (lines.next()) |line| {
        var attributes = std.mem.tokenize(line, " ");
        var count: usize = 0;
        while (attributes.next()) |attr| {
            var tagValue = std.mem.tokenize(attr, ":");
            var tag = tagValue.next().?;
            for (givenTags) |tags| {
                if (std.mem.eql(u8, tags, tag)) {
                    count += 1;
                }
            }
        }
        if (count >= 7) {
            valid += 1;
        }
    }
    std.debug.print("valid: {}\n", .{valid});
}
