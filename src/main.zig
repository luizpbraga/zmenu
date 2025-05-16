//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const c = @cImport(@cInclude("gtk-4.0/gtk/gtk.h"));
const std = @import("std");

/// Could not get `g_signal_connect` to work. Zig says "use of undeclared identifier". Reimplemented here
pub fn gSignalConnect(instance: c.gpointer, detailed_signal: [*c]const c.gchar, c_handler: c.GCallback, data: c.gpointer) c.gulong {
    var zero: u32 = 0;
    const flags: *c.GConnectFlags = @ptrCast(&zero);
    return c.g_signal_connect_data(instance, detailed_signal, c_handler, data, null, flags.*);
}

/// Could not get `g_signal_connect_swapped` to work. Zig says "use of undeclared identifier". Reimplemented here
pub fn gSignalConnectSwapped(instance: c.gpointer, detailed_signal: [*c]const c.gchar, c_handler: c.GCallback, data: c.gpointer) c.gulong {
    return c.g_signal_connect_data(instance, detailed_signal, c_handler, data, null, c.G_CONNECT_SWAPPED);
}

fn onAnctivate(app: *c.GtkApplication, user_data: c.gpointer) callconv(.C) void {
    _ = user_data;
    const window = c.gtk_application_window_new(app);
    const button = c.gtk_button_new_with_label("Hello!");

    _ = gSignalConnectSwapped(button, "clicked", @ptrCast(&c.gtk_window_close), window);

    c.gtk_window_set_child(@ptrCast(window), button);
    c.gtk_window_present(@ptrCast(window));
}

pub fn main() !void {
    const app = c.gtk_application_new("com.example.GTK", c.G_APPLICATION_FLAGS_NONE);
    defer c.g_object_unref(app);
    _ = gSignalConnect(app, "activate", @ptrCast(&activateWindow), null);
    const stats = c.g_application_run(@ptrCast(app), 0, 0);
    std.debug.print("STATUS: {}", .{stats});

    // window whith a button
    // const app = c.gtk_application_new("com.example.GTK", c.G_APPLICATION_FLAGS_NONE);
    // defer c.g_object_unref(app);
    // _ = gSignalConnect(app, "activate", @ptrCast(&onAnctivate), null);
    // _ = c.g_application_run(@ptrCast(app), 0, 0);
}

fn activateWindow(app: *c.GtkApplication, user_data: c.gpointer) callconv(.C) void {
    _ = user_data;
    // c.g_print("GtkApplication is activated.\n");
    //
    // * the window will only bee desplayed with gtk_window_set_application
    // const window = c.gtk_window_new();
    // c.gtk_window_set_application(@ptrCast(window), @ptrCast(app));

    // the fallowing will display the window automatically
    const window = c.gtk_application_window_new(app);

    // style
    c.gtk_window_set_title(@ptrCast(window), "Test");
    c.gtk_window_set_default_size(@ptrCast(window), 400, 300);

    c.gtk_window_present(@ptrCast(window));
}

test "signals" {}
