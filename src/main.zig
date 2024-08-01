const std = @import("std");

const utils = @import("./utils.zig");

const VK_A = 0x41;
const VK_D = 0x44;

pub fn main() void {
    var a_down = false;
    var d_down = false;

    while (true) {
        if (utils.isKeyDown(VK_A)) {
            if (!a_down) {
                a_down = true;
                onADown();
            }
        } else {
            if (a_down) {
                a_down = false;
                onAUp();
            }
        }

        if (utils.isKeyDown(VK_D)) {
            if (!d_down) {
                d_down = true;
                onDDown();
            }
        } else {
            if (d_down) {
                d_down = false;
                onDUp();
            }
        }

        std.os.windows.kernel32.Sleep(1);
    }
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
