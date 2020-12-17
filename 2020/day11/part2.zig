const inp = @embedFile("inp.txt");
const std = @import("std");
const split = std.mem.split;
const print = std.debug.print;
const parseInt = std.fmt.parseInt;

const rowLen = 93;
const colLen = 94;
const Grid = [rowLen][colLen]u8;

fn leftCheck(grid: Grid, rowIndex: usize, colIndex: usize) u32 {
    if (colIndex > 0) {
        var left = grid[rowIndex];
        var indx = colIndex - 1;
        while (indx >= 0) {
            var l = left[indx];
            if (l == '#') {
                return 1;
            }
            if (l == 'L') {
                return 0;
            }
            if (indx == 0) {
                return 0;
            }
            indx -= 1;
        }
    }
    return 0;
}

fn rightCheck(grid: Grid, rowIndex: usize, colIndex: usize) u32 {
    var right = grid[rowIndex][colIndex + 1 ..];
    for (right) |l| {
        if (l == '#') {
            return 1;
        }
        if (l == 'L') {
            return 0;
        }
    }
    return 0;
}

fn topCheck(grid: Grid, rowIndex: usize, colIndex: usize) u32 {
    if (rowIndex > 0) {
        var top = rowIndex - 1;
        while (top >= 0) {
            if (grid[top][colIndex] == '#') {
                return 1;
            }

            if (grid[top][colIndex] == 'L') {
                return 0;
            }

            if (top == 0) {
                return 0;
            }
            top -= 1;
        }
    }
    return 0;
}

fn bottomCheck(grid: Grid, rowIndex: usize, colIndex: usize) u32 {
    var bottom = rowIndex + 1;
    while (bottom < rowLen) {
        if (grid[bottom][colIndex] == '#') {
            return 1;
        }
        if (grid[bottom][colIndex] == 'L') {
            return 0;
        }
        if (bottom == 0) {
            return 0;
        }
        bottom += 1;
    }
    return 0;
}
fn diaLeftUpCheck(grid: Grid, rowIndex: usize, colIndex: usize) u32 {
    if (rowIndex > 0 and colIndex > 0) {
        var diaLeftUp = rowIndex - 1;
        var diaLeftUpCol = colIndex - 1;
        while (diaLeftUp >= 0 and diaLeftUpCol >= 0) {
            if (grid[diaLeftUp][diaLeftUpCol] == '#') {
                return 1;
            }
            if (grid[diaLeftUp][diaLeftUpCol] == 'L') {
                return 0;
            }
            if (diaLeftUp == 0 or diaLeftUpCol == 0) {
                return 0;
            }
            diaLeftUp -= 1;
            diaLeftUpCol -= 1;
        }
    }
    return 0;
}
fn diaLeftDownCheck(grid: Grid, rowIndex: usize, colIndex: usize) u32 {
    if (colIndex > 0) {
        var diaLeftDown = rowIndex + 1;
        var diaLeftDownCol = colIndex - 1;
        while (diaLeftDown < rowLen and diaLeftDownCol >= 0) {
            if (grid[diaLeftDown][diaLeftDownCol] == '#') {
                return 1;
            }
            if (grid[diaLeftDown][diaLeftDownCol] == 'L') {
                return 0;
            }
            if (diaLeftDownCol == 0) {
                return 0;
            }
            diaLeftDown += 1;
            diaLeftDownCol -= 1;
        }
    }
    return 0;
}

fn diaRightUpCheck(grid: Grid, rowIndex: usize, colIndex: usize) u32 {
    if (rowIndex > 0) {
        var diaRightUp = rowIndex - 1;
        var diaRightUpCol = colIndex + 1;
        while (diaRightUp >= 0 and diaRightUpCol < colLen) {
            if (grid[diaRightUp][diaRightUpCol] == '#') {
                return 1;
            }
            if (grid[diaRightUp][diaRightUpCol] == 'L') {
                return 0;
            }
            if (diaRightUp == 0) {
                return 0;
            }
            diaRightUp -= 1;
            diaRightUpCol += 1;
        }
    }
    return 0;
}
fn diaRightDownCheck(grid: Grid, rowIndex: usize, colIndex: usize) u32 {
    var diaRightDown = rowIndex + 1;
    var diaRightDownCol = colIndex + 1;
    while (diaRightDown < rowLen and diaRightDownCol < colLen) {
        if (grid[diaRightDown][diaRightDownCol] == '#') {
            return 1;
        }
        if (grid[diaRightDown][diaRightDownCol] == 'L') {
            return 0;
        }
        diaRightDown += 1;
        diaRightDownCol += 1;
    }
    return 0;
}

fn calcAdjacent(grid: Grid, rowIndex: usize, colIndex: usize) u32 {
    var count: u32 = 0;

    count += leftCheck(grid, rowIndex, colIndex);
    count += rightCheck(grid, rowIndex, colIndex);

    count += topCheck(grid, rowIndex, colIndex);
    count += bottomCheck(grid, rowIndex, colIndex);

    count += diaLeftUpCheck(grid, rowIndex, colIndex);
    count += diaLeftDownCheck(grid, rowIndex, colIndex);

    count += diaRightUpCheck(grid, rowIndex, colIndex);
    count += diaRightDownCheck(grid, rowIndex, colIndex);

    return count;
}

fn runLoop(grid: Grid) Grid {
    var newGrid = [_][colLen]u8{undefined} ** rowLen;
    for (grid) |row, rowIndex| {
        for (row) |col, colIndex| {
            var val = col;
            if (col == 'L') {
                if (calcAdjacent(grid, rowIndex, colIndex) == 0) {
                    val = '#';
                } else {
                    val = 'L';
                }
            } else if (col == '#') {
                if (calcAdjacent(grid, rowIndex, colIndex) > 4) {
                    val = 'L';
                } else {
                    val = '#';
                }
            }
            newGrid[rowIndex][colIndex] = val;
        }
    }
    return newGrid;
}

fn printGrid(grid: Grid) void {
    for (grid) |row| {
        print("{}\n", .{row});
    }
}

fn countGrid(grid: Grid) u32 {
    var count: u32 = 0;
    for (grid) |row| {
        for (row) |col| {
            if (col == '#') {
                count += 1;
            }
        }
    }
    return count;
}

pub fn main() !void {
    var lines = split(inp, "\n");
    var arr = [_][colLen]u8{undefined} ** rowLen;
    var i: usize = 0;
    while (lines.next()) |line| {
        for (line) |col, ci| {
            arr[i][ci] = col;
        }
        i += 1;
    }

    var prevCount: u32 = 0;
    var tmp = arr[0..].*;
    while (true) {
        tmp = runLoop(tmp);
        var c = countGrid(tmp);
        if (c == prevCount) {
            print("c :: {}\n", .{c});
            break;
        }
        prevCount = c;
    }
}
