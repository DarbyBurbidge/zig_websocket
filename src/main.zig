const std = @import("std");
const http = @import("http.zig");
const WebSocket = @import("socket.zig");
pub const io_mode = .evented;

const net = std.net;
const StreamServer = net.StreamServer;
const Address = net.Address;

pub fn main() anyerror!void {
    var server = StreamServer.init(.{});
    defer server.close();
    const address = try Address.resolveIp("127.0.0.1", 8080);
    try server.listen(address);

    while(true) {
        const connection = try server.accept();
        try handler(connection.stream);
    }
}

fn handler(stream: net.Stream) !void {
    defer stream.close();
    try stream.writer().print("Hello World", .{});
}
