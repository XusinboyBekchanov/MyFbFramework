'       FreeBasic header file, manual-generated file
'              containing types for GLib-2.0
' LGPLv2.1 (C) 2014-2022 by Thomas[ dot }Freiherr[ at ]gmx[ dot }net

Type As  ZString gchar, char
Type As     Byte gint8
Type As    UByte guint8, guchar
Type As    Short gint16, gshort, gunichar2
Type As   UShort guint16, gushort
Type As     Long gint, gint32, gunichar
Type As    ULong guint, guint32, gboolean ', GType

Type As  LongInt gint64, glong
Type As ULongInt guint64, gulong
Type As   Single gfloat
Type As   Double gdouble
Type As  Integer gssize, ssize_t, goffset
Type As UInteger gsize, size_t

#include once "crt/stdio.bi"
#include once "crt/time.bi"
#undef va_list
#if __FB_VERSION__ < "1.07"
 Type As Any Ptr va_list
#else
 Type As Cva_List va_list
#endif
#ifndef FILE
 Type As Any Ptr FILE
#endif
#undef True
#undef False
Const As gboolean True = 1, False = 0
#undef NULL
Const As Any Ptr NULL = 0

Type As   ZString Ptr utf8, filename
Type As       Any Ptr gpointer
Type As Const Any Ptr gconstpointer

'' GLib constants
#define G_MININT G_MININT32
#define G_MAXINT G_MAXINT32
#define G_MAXUINT G_MAXUINT32
#define G_MINFLOAT 1.401298e-45
#define G_MAXFLOAT 3.402823e+38
#define G_MINDOUBLE 4.940656458412465e-324
#define G_MAXDOUBLE 1.797693134862316e+308
#define G_MAXULONG  &hFFFFFFFFul
#define G_MAXLONG   &h7FFFFFFFl
#define G_MAXUSHORT &hFFFF
#define G_MAXSHORT  &h7FFF
#define G_MAXSIZE G_MAXULONG
#define G_MAXSSIZE G_MAXLONG
#define G_MAXOFFSET G_MAXINT64

'' GObject macros
#define G_TYPE_CHECK_INSTANCE_CAST(instance, g_type, c_type) (_G_TYPE_CIC((instance), (g_type), c_type))
#define G_TYPE_CHECK_CLASS_CAST(g_class, g_type, c_type) (_G_TYPE_CCC((g_class), (g_type), c_type))
#define G_TYPE_CHECK_INSTANCE_TYPE(instance, g_type) (_G_TYPE_CIT((instance), (g_type)))
#define G_TYPE_INSTANCE_GET_INTERFACE(instance, g_type, c_type) (_G_TYPE_IGI((instance), (g_type), c_type))
#define G_TYPE_CHECK_CLASS_TYPE(g_class, g_type) (_G_TYPE_CCT ((g_class), (g_type)))
#define G_TYPE_INSTANCE_GET_CLASS(instance, g_type, c_type) (_G_TYPE_IGC((instance), (g_type), c_type))

#ifndef G_DISABLE_CAST_CHECKS
#define _G_TYPE_CIC(ip, gt, ct) _
    (Cast(ct Ptr, g_type_check_instance_cast_(Cast(GTypeInstance Ptr, ip), gt)))
#define _G_TYPE_CCC(cp, gt, ct) _
    (Cast(ct Ptr, g_type_check_class_cast_(Cast(GTypeClass Ptr, cp), gt)))
#else ' G_DISABLE_CAST_CHECKS
#define _G_TYPE_CIC(ip, gt, ct) (Cast(ct Ptr, ip))
#define _G_TYPE_CCC(cp, gt, ct) (Cast(ct Ptr, cp))
#endif ' G_DISABLE_CAST_CHECKS

#define _G_TYPE_CIT(ip, gt) (g_type_check_instance_is_a(Cast(GTypeInstance Ptr, ip), gt))
#define _G_TYPE_CCT(cp, gt) (g_type_check_class_is_a(Cast(GTypeClass Ptr, cp), gt))
#define _G_TYPE_IGI(ip, gt, ct) (Cast(ct Ptr, g_type_interface_peek(Cast(GTypeInstance Ptr, ip)->g_class, gt)))
#define _G_TYPE_IGC(ip, gt, ct) (Cast(ct Ptr, (Cast(GTypeInstance Ptr, ip)->g_class)))
