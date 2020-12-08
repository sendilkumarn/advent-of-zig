const inp = @embedFile("inp.txt");
const std = @import("std");
const tokenize = std.mem.tokenize;
const split = std.mem.split;
const print = std.debug.print;

const Instruction = enum {
    JMP,
    ACC,
    NOP,
};

const InstructionSet = struct {
    instruction: Instruction,
    val: i32,
};

pub fn main() !void {
    var lines = split(inp, "\n");
    var count: i32 = 0;
    var i: i32 = 0;
    var i32Map = std.AutoHashMap(i32, void).init(std.testing.allocator);
    defer i32Map.deinit();
    var list = std.ArrayList(InstructionSet).init(std.testing.allocator);
    defer list.deinit();

    while (lines.next()) |line| {
        var words = split(line, " ");
        var ins = words.next().?;
        var val = words.next().?;
        var value: i32 = std.fmt.parseInt(i32, if (val[0] == '-') val else val[1..], 10) catch unreachable;
        const instruction = if (std.mem.eql(u8, ins, "jmp")) Instruction.JMP else if (std.mem.eql(u8, ins, "acc")) Instruction.ACC else Instruction.NOP;

        try list.append(InstructionSet{
            .instruction = instruction,
            .val = value,
        });
    }

    while (!i32Map.contains(i) and i >= 0) {
        var inst = list.items[@intCast(usize, i)];
        try i32Map.put(i, {});

        switch (inst.instruction) {
            .ACC => {
                count += inst.val;
                i += 1;
            },
            .JMP => {
                i += inst.val;
            },
            .NOP => {
                i += 1;
            },
        }
    }
    print("count {}\n", .{count});
}
