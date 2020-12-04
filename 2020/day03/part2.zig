const inp = @embedFile("inp.txt");
const std = @import("std");

pub fn main() void {
    var counter: usize = 5;
    var total: usize = 1;
    var extraMove: usize = 1;
    var y: usize = 0;

    while (counter > 0) {
        var lines = std.mem.tokenize(inp, "\n");
        var count: usize = 0;
        var x: usize = 0;
        while (lines.next()) |line| {
            var point = line[x];
            var tmpY = y;
            if (line[x] == '#') {
                count += 1;
            }
            while (tmpY > 0) {
                var t = lines.next();
                tmpY = tmpY - 1;
            }
            x = x + extraMove;
        }
        if (extraMove == 7) {
            extraMove = 1;
            y = y + 1;
        } else {
            extraMove = extraMove + 2;
        }
        counter -= 1;
        total *= count;
    }
    std.debug.print("{}", .{total});
}
