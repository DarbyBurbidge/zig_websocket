const std = @import("std");
const http = @import("http.zig");
const WebSocket = @import("socket.zig");
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;
pub const io_mode = .evented;

const net = std.net;
const StreamServer = net.StreamServer;
const Address = net.Address;

pub fn main() anyerror!void {
    var server = StreamServer.init(.{});
    var gpa = GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer server.close();
    const address = try Address.resolveIp("127.0.0.1", 8080);
    try server.listen(address);

    while(true) {
        const connection = try server.accept();
        try handler(allocator, connection.stream);
    }
}

fn handler(allocator: std.mem.Allocator, stream: net.Stream) !void {
    defer stream.close();
    var first_line = try stream.reader().readUntilDelimiterAlloc(allocator, '\n', std.math.maxInt(usize));
    first_line = first_line[0..first_line.len];
    var first_line_iter = std.mem.split(u8, first_line, " ");
    
    const method = first_line_iter.next().?;
    const uri = first_line_iter.next().?;
    const version = first_line_iter.next().?;

    var headers = std.StringHashMap([]const u8).init(allocator);

    while(true) {
        var line = try stream.reader().readUntilDelimiterAlloc(allocator, '\n', std.math.maxInt(usize));
        line = line[0..line.len];
        if (line.len == 1 and std.mem.eql(u8, line, "\r")) break;
            var line_iter = std.mem.split(u8, line, ":");
            const key = line_iter.next().?;
            var value = line_iter.next().?;
        if (value[0] == ' ') value = value[1..];
        try headers.put(key, value);
    }
    std.debug.print("method: {s}\nuri: {s}\nversion: {s}\n", .{method, uri, version});

    var headers_iter = headers.iterator();
    while(headers_iter.next()) |entry| {
        std.debug.print("{s}: {s}\n", .{entry.key_ptr.*, entry.value_ptr.*});
    }
}
