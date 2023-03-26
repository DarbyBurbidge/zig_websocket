const std = @import("std");
const http = @import("http.zig");
const WebSocket = @import("socket.zig");

pub fn main() void {
    http.shout();
}
