const inp = @embedFile("inp.txt");
const std = @import("std");
const split = std.mem.split;
const print = std.debug.print;
const parseInt = std.fmt.parseInt;

const rowLen = 93;
const colLen = 94;
const Grid = [rowLen][colLen]u8;

fn calcAdjacent(grid: Grid, rowIndex: usize, colIndex: usize) u32 {
    var count: u32 = 0;
    if (rowIndex + 1 < rowLen and grid[rowIndex + 1][colIndex] == '#') {
        count += 1;
    }
    if (rowIndex + 1 < rowLen and colIndex > 0 and grid[rowIndex + 1][colIndex - 1] == '#') {
        count += 1;
    }

    if (rowIndex + 1 < rowLen and colIndex + 1 < colLen and grid[rowIndex + 1][colIndex + 1] == '#') {
        count += 1;
    }

    if (rowIndex > 0 and grid[rowIndex - 1][colIndex] == '#') {
        count += 1;
    }

    if (rowIndex > 0 and colIndex > 0 and grid[rowIndex - 1][colIndex - 1] == '#') {
        count += 1;
    }

    if (rowIndex > 0 and colIndex + 1 < colLen and grid[rowIndex - 1][colIndex + 1] == '#') {
        count += 1;
    }

    if (colIndex > 0 and grid[rowIndex][colIndex - 1] == '#') {
        count += 1;
    }

    if (colIndex + 1 < colLen and grid[rowIndex][colIndex + 1] == '#') {
        count += 1;
    }

    return count;
}

fn runLoop(grid: Grid) Grid {
    var newGrid = [_][94]u8{undefined} ** rowLen;
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
                if (calcAdjacent(grid, rowIndex, colIndex) > 3) {
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
    var arr = [_][94]u8{undefined} ** rowLen;
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
