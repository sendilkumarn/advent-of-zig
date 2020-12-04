const inp = @embedFile("inp.txt");
const std = @import("std");
const parseInt = std.fmt.parseInt;

fn rangeCheck(num: usize, min: usize, max: usize) bool {
    return num >= min and num <= max;
}

fn birthCheck(num: usize) bool {
    return rangeCheck(num, 1920, 2002);
}

fn issueCheck(num: usize) bool {
    return rangeCheck(num, 2010, 2020);
}

fn expiryCheck(num: usize) bool {
    return rangeCheck(num, 2020, 2030);
}

fn heightCheck(num: usize, unit: []const u8) bool {
    if (std.mem.eql(u8, unit, "cm")) {
        return rangeCheck(num, 150, 193);
    }
    return rangeCheck(num, 59, 76);
}

fn colorCheck(num: []const u8) bool {
    if (num[0] == '#' and num.len == 7) {
        return true;
    }
    return false;
}

fn eclCheck(val: []const u8) bool {
    var possibleEcl = [_][]const u8{ "amb", "blu", "brn", "gry", "grn", "hzl", "oth" };
    for (possibleEcl) |ecl| {
        if (std.mem.eql(u8, val, ecl)) {
            return true;
        }
    }
    return false;
}

fn pidCheck(num: []const u8) bool {
    return num.len == 9;
}

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
            var value = tagValue.next().?;
            for (givenTags) |tags| {
                if (std.mem.eql(u8, tags, tag)) {
                    var b: bool = false;
                    if (std.mem.eql(u8, tag, "byr")) {
                        b = birthCheck(parseInt(usize, value, 10) catch unreachable);
                    }

                    if (std.mem.eql(u8, tag, "iyr")) {
                        b = issueCheck(parseInt(usize, value, 10) catch unreachable);
                    }

                    if (std.mem.eql(u8, tag, "eyr")) {
                        b = expiryCheck(parseInt(usize, value, 10) catch unreachable);
                    }

                    if (std.mem.eql(u8, tag, "hgt")) {
                        if (value.len > 3) {
                            b = heightCheck(parseInt(usize, value[0 .. value.len - 2], 10) catch unreachable, value[value.len - 2 ..]);
                        }
                    }

                    if (std.mem.eql(u8, tag, "hcl")) {
                        b = colorCheck(value);
                    }

                    if (std.mem.eql(u8, tag, "ecl")) {
                        b = eclCheck(value);
                    }

                    if (std.mem.eql(u8, tag, "pid")) {
                        b = pidCheck(value);
                    }

                    if (std.mem.eql(u8, tag, "cid")) {
                        b = true;
                    }

                    if (b) {
                        count += 1;
                    }
                }
            }
        }
        if (count >= 7) {
            valid += 1;
        }
    }
    std.debug.print("valid: {}\n", .{valid});
}
