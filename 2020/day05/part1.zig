const inp = @embedFile("inp.txt");
const std = @import("std");

fn cal(row: [2]i32, isUp: bool) [2]i32 {
    const mid = @divFloor((row[0] + row[1]), 2);

    if (isUp) {
        return [2]i32{ mid + 1, row[1] };
    } else {
        return [2]i32{ row[0], mid };
    }
}

fn getVal(row: [2]i32, isUp: bool) i32 {
    if (isUp) {
        return row[1];
    } else {
        return row[0];
    }
}

pub fn main() void {
    var lines = std.mem.tokenize(inp, "\n");
    var min: i32 = 1000;
    var max: i32 = 0;
    var actualSum: i32 = 0;

    while (lines.next()) |line| {
        var seatID: i32 = 0;

        var row: [2]i32 = [2]i32{ 0, 127 };
        var col: [2]i32 = [2]i32{ 0, 7 };
        var r: i32 = 0;
        var c: i32 = 0;

        for (line) |l, i| {
            if (i < 6) {
                row = cal(row, l == 'B');
            }

            if (i == 6) {
                r = getVal(row, l == 'B');
            }

            if (i > 6) {
                col = cal(col, l == 'R');
            }

            if (i == 9) {
                c = getVal(col, l == 'R');
            }

            seatID = (r * 8) + c;

            if (max < seatID) {
                max = seatID;
            }
        }
    }
    std.debug.print("max seat id: {}\n", .{max});
}
