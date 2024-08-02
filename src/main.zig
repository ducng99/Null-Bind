const std = @import("std");

const utils = @import("./utils.zig");

const VK_A = 0x41;
const VK_D = 0x44;

pub fn main() void {
    const hhkLowLevelKybd: utils.c.HHOOK = utils.c.SetWindowsHookExA(utils.c.WH_KEYBOARD_LL, LowLevelKeyboardProc, 0, 0);

    // Keep this app running until we're told to stop
    var msg: utils.c.MSG = std.mem.zeroes(utils.c.MSG);
    while (utils.c.GetMessageA(&msg, null, 0, 0) == 0) {
        _ = utils.c.TranslateMessage(&msg);
        _ = utils.c.DispatchMessageA(&msg);
    }

    _ = utils.c.UnhookWindowsHookEx(hhkLowLevelKybd);
}

fn LowLevelKeyboardProc(nCode: c_int, wParam: utils.c.WPARAM, lParam: utils.c.LPARAM) callconv(.C) utils.c.LRESULT {
    if (nCode == utils.c.HC_ACTION) {
        switch (wParam) {
            utils.c.WM_KEYDOWN,
            utils.c.WM_KEYUP,
            => {
                const p: utils.c.PKBDLLHOOKSTRUCT = @as(utils.c.PKBDLLHOOKSTRUCT, lParam);
                switch (p.*.vkCode) {
                    VK_A => {
                        switch (wParam) {
                            utils.c.WM_KEYDOWN => {
                                onADown();
                            },
                            utils.c.WM_KEYUP => {
                                onAUp();
                            },
                            else => {},
                        }
                    },
                    VK_D => {
                        switch (wParam) {
                            utils.c.WM_KEYDOWN => {
                                onDDown();
                            },
                            utils.c.WM_KEYUP => {
                                onDUp();
                            },
                            else => {},
                        }
                    },
                    else => {},
                }
            },
            else => {},
        }
    }

    return utils.c.CallNextHookEx(null, nCode, wParam, lParam);
}

fn onADown() void {
    if (utils.isKeyDown(utils.c.VK_RIGHT)) {
        utils.sendKeyUp(utils.c.VK_RIGHT);
    }

    utils.sendKeyDown(utils.c.VK_LEFT);
}

fn onAUp() void {
    if (utils.isKeyDown(utils.c.VK_LEFT)) {
        utils.sendKeyUp(utils.c.VK_LEFT);
    }

    if (utils.isKeyDown(VK_D)) {
        utils.sendKeyDown(utils.c.VK_RIGHT);
    }
}

fn onDDown() void {
    if (utils.isKeyDown(utils.c.VK_LEFT)) {
        utils.sendKeyUp(utils.c.VK_LEFT);
    }

    utils.sendKeyDown(utils.c.VK_RIGHT);
}

fn onDUp() void {
    if (utils.isKeyDown(utils.c.VK_RIGHT)) {
        utils.sendKeyUp(utils.c.VK_RIGHT);
    }

    if (utils.isKeyDown(VK_A)) {
        utils.sendKeyDown(utils.c.VK_LEFT);
    }
}
