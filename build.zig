const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .x86_64,
        .os_tag = .windows,
    });

    const exe = b.addExecutable(.{
        .name = "null-bind",
        .version = .{
            .major = 0,
            .minor = 1,
            .patch = 0,
        },
        .root_source_file = b.path("./src/main.zig"),
        .target = target,
        .optimize = .ReleaseSafe,
    });
    exe.linkLibC();

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
