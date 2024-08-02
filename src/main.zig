const std = @import("std");

const utils = @import("./utils.zig");

const VK_A = 0x41;
const VK_D = 0x44;

// Tracks actual physical keyboard state
var phys_a_down = false;
var phys_d_down = false;

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

                if (p.*.dwExtraInfo != utils.SEND_INPUT_EXTRA_INFO) {
                    switch (p.*.vkCode) {
                        VK_A => {
                            switch (wParam) {
                                utils.c.WM_KEYDOWN => {
                                    phys_a_down = true;
                                    onADown();
                                },
                                utils.c.WM_KEYUP => {
                                    phys_a_down = false;
                                    onAUp();
                                },
                                else => {},
                            }
                        },
                        VK_D => {
                            switch (wParam) {
                                utils.c.WM_KEYDOWN => {
                                    phys_d_down = true;
                                    onDDown();
                                },
                                utils.c.WM_KEYUP => {
                                    phys_d_down = false;
                                    onDUp();
                                },
                                else => {},
                            }
                        },
                        else => {},
                    }
                }
            },
            else => {},
        }
    }

    return utils.c.CallNextHookEx(null, nCode, wParam, lParam);
}

fn onADown() void {
    if (phys_d_down) {
        utils.sendKeyUp(VK_D);
    }
}

fn onAUp() void {
    if (phys_d_down) {
        utils.sendKeyDown(VK_D);
    }
}

fn onDDown() void {
    if (phys_a_down) {
        utils.sendKeyUp(VK_A);
    }
}

fn onDUp() void {
    if (phys_a_down) {
        utils.sendKeyDown(VK_A);
    }
}
