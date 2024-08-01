pub const c = @cImport({
    @cInclude("windows.h");
    @cInclude("winuser.h");
});

pub fn isKeyDown(key: c_ushort) bool {
    return @as(i32, c.GetAsyncKeyState(key)) & 0x8000 != 0;
}

pub fn sendKeyDown(key: c_ushort) void {
    var input: c.INPUT = c.INPUT{
        .type = c.INPUT_KEYBOARD,
    };

    input.unnamed_0.ki = c.KEYBDINPUT{
        .wScan = 0,
        .time = 0,
        .wVk = key,
        .dwFlags = c.KEYEVENTF_EXTENDEDKEY,
        .dwExtraInfo = 0,
    };

    _ = c.SendInput(1, &input, @sizeOf(c.INPUT));
}

pub fn sendKeyUp(key: c_ushort) void {
    var input: c.INPUT = c.INPUT{
        .type = c.INPUT_KEYBOARD,
    };

    input.unnamed_0.ki = c.KEYBDINPUT{
        .wScan = 0,
        .time = 0,
        .wVk = key,
        .dwFlags = c.KEYEVENTF_KEYUP | c.KEYEVENTF_EXTENDEDKEY,
        .dwExtraInfo = 0,
    };

    _ = c.SendInput(1, &input, @sizeOf(c.INPUT));
}
