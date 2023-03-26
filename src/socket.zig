const WebSocketMessageType = enum {
    Text,
    Binary,
};

const WebSocketMessage = struct {
    type: WebSocketMessageType,
    payload: []const u8,
};

const WebSocketFrameType = enum {
    Continuation,
    Text,
    Binary,
    Close,
    Ping,
    Pong,
};

const WebSocketFrame = struct {
    fin: bool,
    rsv1: bool,
    rsv2: bool,
    rsv3: bool,
    opcode: WebSocketFrameType,
    mask: bool,
    payload_length: u64,
    masking_key: ?[4]u8,
    payload: []const u8,
};
