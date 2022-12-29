
const builtin = @import("builtin");
const std = @import("std");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    const stdin = std.io.getStdIn();

    try stdout.print("This program calculates Pi via MonteCarlo\n", .{});
    try stdout.print("Enter the number of desired iterations(1-65535): ", .{});

    try bw.flush(); // don't forget to flush!

    var line_buf: [20]u8 = undefined;
    const amt = try stdin.read(&line_buf);
    if (amt == line_buf.len) {
        try stdout.print("Input too long.\n", .{});
        try bw.flush();
    }
    const line = std.mem.trimRight(u8, line_buf[0..amt], "\r\n");

    const iterations = std.fmt.parseUnsigned(u16, line, 10) catch {
            try stdout.print("Invalid number.\n", .{});
            try bw.flush();
            return;
        };
    try stdout.print("You desire {d} iterations.\n", .{iterations});
    try stdout.print("Here we go.\n", .{});
    try bw.flush(); // don't forget to flush!

    // Now we should loop generating random numbers X and Y
    // If X*X + Y*Y <= 1 then increment counter for in circle point
    var i: u16 = 0;
    var in_circle: u16 = 0;
    const rand = std.crypto.random;
    while(i < iterations) {
        const x = rand.float(f32);
        const y = rand.float(f32);
        const d = (x * x) + (y * y);
        if(d <= 1) {
            in_circle += 1;
        }
        i +=1 ;
    }

    const pie = 4 * (@intToFloat(f32, in_circle) / @intToFloat(f32, iterations));
    try stdout.print("In circle points: {}\n", .{in_circle});
    try stdout.print("I estimate Pi to be = {}\n", .{pie});
    try bw.flush();
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
