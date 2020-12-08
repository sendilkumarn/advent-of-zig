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

const Out = struct {
    count: i32, isDone: bool
};

fn findRegisterVal(list: std.ArrayList(InstructionSet)) !Out {
    var i32Map = std.AutoHashMap(i32, void).init(std.testing.allocator);
    defer i32Map.deinit();
    var i: i32 = 0;
    var count: i32 = 0;

    while (!i32Map.contains(i) and i >= 0 and i < list.items.len) {
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
    return Out{
        .count = count,
        .isDone = i >= list.items.len,
    };
}

fn swapInstruction(list: std.ArrayList(InstructionSet), i: usize) void {
    switch (list.items[i].instruction) {
        .ACC => {},
        .JMP => {
            list.items[i].instruction = Instruction.NOP;
        },
        .NOP => {
            list.items[i].instruction = Instruction.JMP;
        },
    }
}

pub fn main() !void {
    var lines = split(inp, "\n");
    var i: i32 = 0;

    var list = std.ArrayList(InstructionSet).init(std.testing.allocator);
    defer list.deinit();

    var items = std.ArrayList(usize).init(std.testing.allocator);
    defer items.deinit();

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

        if (std.mem.eql(u8, ins, "jmp") or std.mem.eql(u8, ins, "nop")) {
            try items.append(list.items.len - 1);
        }
    }

    for (items.items) |item, indx| {
        swapInstruction(list, @intCast(usize, item));
        if (indx != 0) {
            swapInstruction(list, items.items[indx - 1]);
        }

        var count = try findRegisterVal(list);
        if (count.isDone) {
            print("count {}\n", .{count.count});
            return;
        }
    }
}
