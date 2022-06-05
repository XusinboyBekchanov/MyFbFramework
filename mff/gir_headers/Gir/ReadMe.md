Folder Gir
==========

This folder contains the library bindings (header files) and some
special files, which names are starting by an underscore character:

- the fundamental header `*._GirToBac-0.0.bi` (root of header tree)
- manually translated macros
    * `*._GLibMacros-2.0.bi`
    * `*._GObjectMacros-2.0.bi`
    * `*._GdkMacros-2.0.bi`

Since the GObjectIntrospection source files `*.gir` contain the main
part of a language binding (type definitions, constants, functions and
external variables), but cannot contain complex macros, those macros get
manually translated to a separat file (and hopefuly do not change much).

So when the compiler throughs an `undefined symbol` error, it may be
caused by calling a macro needing the extra header. Example:

If you want to use `g_signal_connect` in a Gtk application, you'll need

    #INCLUDE ONCE "Gir/Gtk-3.0.bi" '        the library header
    #INCLUDE ONCE "Gir/_GObjectMacros.bi" ' additional macros
