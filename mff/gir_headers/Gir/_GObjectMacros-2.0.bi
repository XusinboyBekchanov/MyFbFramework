'       FreeBasic header file, manual-generated file
' containing additional code-generating macros for GObject-2.0
' LGPLv2.1 (C) 2014-2022 by Thomas[ dot }Freiherr[ at ]gmx[ dot }net

#DEFINE G_TYPE_FUNDAMENTAL(type) (g_type_fundamental_(type))
#DEFINE G_TYPE_INVALID G_TYPE_MAKE_FUNDAMENTAL (0)
#DEFINE G_TYPE_NONE G_TYPE_MAKE_FUNDAMENTAL (1)
#DEFINE G_TYPE_INTERFACE G_TYPE_MAKE_FUNDAMENTAL (2)
#DEFINE G_TYPE_CHAR G_TYPE_MAKE_FUNDAMENTAL (3)
#DEFINE G_TYPE_UCHAR G_TYPE_MAKE_FUNDAMENTAL (4)
#DEFINE G_TYPE_BOOLEAN G_TYPE_MAKE_FUNDAMENTAL (5)
#DEFINE G_TYPE_INT G_TYPE_MAKE_FUNDAMENTAL (6)
#DEFINE G_TYPE_UINT G_TYPE_MAKE_FUNDAMENTAL (7)
#DEFINE G_TYPE_LONG G_TYPE_MAKE_FUNDAMENTAL (8)
#DEFINE G_TYPE_ULONG G_TYPE_MAKE_FUNDAMENTAL (9)
#DEFINE G_TYPE_INT64 G_TYPE_MAKE_FUNDAMENTAL (10)
#DEFINE G_TYPE_UINT64 G_TYPE_MAKE_FUNDAMENTAL (11)
#DEFINE G_TYPE_ENUM G_TYPE_MAKE_FUNDAMENTAL (12)
#DEFINE G_TYPE_FLAGS G_TYPE_MAKE_FUNDAMENTAL (13)
#DEFINE G_TYPE_FLOAT G_TYPE_MAKE_FUNDAMENTAL (14)
#DEFINE G_TYPE_DOUBLE G_TYPE_MAKE_FUNDAMENTAL (15)
#DEFINE G_TYPE_STRING G_TYPE_MAKE_FUNDAMENTAL (16)
#DEFINE G_TYPE_POINTER G_TYPE_MAKE_FUNDAMENTAL (17)
#DEFINE G_TYPE_BOXED G_TYPE_MAKE_FUNDAMENTAL (18)
#DEFINE G_TYPE_PARAM G_TYPE_MAKE_FUNDAMENTAL (19)
#DEFINE G_TYPE_VARIANT G_TYPE_MAKE_FUNDAMENTAL (21)
#DEFINE G_TYPE_MAKE_FUNDAMENTAL(x) (CAST(GType, ((x) SHL G_TYPE_FUNDAMENTAL_SHIFT)))
#DEFINE G_TYPE_IS_FUNDAMENTAL(type) ((type) <= G_TYPE_FUNDAMENTAL_MAX)
#DEFINE G_TYPE_IS_DERIVED(type) ((type) > G_TYPE_FUNDAMENTAL_MAX)
#DEFINE G_TYPE_IS_INTERFACE(type) (G_TYPE_FUNDAMENTAL(type) = G_TYPE_INTERFACE)
#DEFINE G_TYPE_IS_CLASSED(type) (g_type_test_flags((type), G_TYPE_FLAG_CLASSED))
#DEFINE G_TYPE_IS_INSTANTIATABLE(type) (g_type_test_flags((type), G_TYPE_FLAG_INSTANTIATABLE))
#DEFINE G_TYPE_IS_DERIVABLE(type) (g_type_test_flags((type), G_TYPE_FLAG_DERIVABLE))
#DEFINE G_TYPE_IS_DEEP_DERIVABLE(type) (g_type_test_flags((type), G_TYPE_FLAG_DEEP_DERIVABLE))
#DEFINE G_TYPE_IS_ABSTRACT(type) (g_type_test_flags((type), G_TYPE_FLAG_ABSTRACT))
#DEFINE G_TYPE_IS_VALUE_ABSTRACT(type) (g_type_test_flags((type), G_TYPE_FLAG_VALUE_ABSTRACT))
#DEFINE G_TYPE_IS_VALUE_TYPE(type) (g_type_check_is_value_type(type))
#DEFINE G_TYPE_HAS_VALUE_TABLE(type) (g_type_value_table_peek(type) <> NULL)

#DEFINE G_TYPE_CHECK_INSTANCE(instance) (_G_TYPE_CHI(CAST(GTypeInstance PTR, instance)))
#DEFINE G_TYPE_CHECK_VALUE(value) (_G_TYPE_CHV((value)))
#DEFINE G_TYPE_CHECK_VALUE_TYPE(value, g_type) (_G_TYPE_CVH((value), (g_type)))
#DEFINE G_TYPE_FROM_INSTANCE(instance) (G_TYPE_FROM_CLASS((CAST(GTypeInstance PTR, instance))->g_class))
#DEFINE G_TYPE_FROM_CLASS(g_class) (CAST(GTypeClass PTR, g_class)->g_type)
#DEFINE G_TYPE_FROM_INTERFACE(g_iface) (CAST(GTypeInterface PTR, g_iface)->g_type)
#DEFINE G_TYPE_INSTANCE_GET_PRIVATE(instance, g_type, c_type) (CAST(c_type PTR, g_type_instance_get_private_(CAST(GTypeInstance PTR, instance), g_type)))
#DEFINE G_TYPE_CLASS_GET_PRIVATE(klass, g_type, c_type) (CAST(c_type PTR, g_type_class_get_private_(CAST(GTypeClass PTR, klass), (g_type)))

#DEFINE G_DEFINE_TYPE(TN, t_n, T_P) G_DEFINE_TYPE_EXTENDED(TN, t_n, T_P, 0, )
#MACRO G_DEFINE_TYPE_WITH_CODE(TN, t_n, T_P, _C_)
 _G_DEFINE_TYPE_EXTENDED_BEGIN(TN, t_n, T_P, 0)
 _C_
 _G_DEFINE_TYPE_EXTENDED_END()
#ENDMACRO

#DEFINE G_DEFINE_ABSTRACT_TYPE(TN, t_n, T_P) G_DEFINE_TYPE_EXTENDED(TN, t_n, T_P, G_TYPE_FLAG_ABSTRACT, )
#MACRO G_DEFINE_ABSTRACT_TYPE_WITH_CODE(TN, t_n, T_P, _C_)
 _G_DEFINE_TYPE_EXTENDED_BEGIN(TN, t_n, T_P, G_TYPE_FLAG_ABSTRACT)
 _C_
 _G_DEFINE_TYPE_EXTENDED_END()
#ENDMACRO

#MACRO G_DEFINE_TYPE_EXTENDED(TN, t_n, T_P, _f_, _C_)
 _G_DEFINE_TYPE_EXTENDED_BEGIN(TN, t_n, T_P, _f_)
 _C_
 _G_DEFINE_TYPE_EXTENDED_END()
#ENDMACRO

#DEFINE G_DEFINE_INTERFACE(TN, t_n, T_P) G_DEFINE_INTERFACE_WITH_CODE(TN, t_n, T_P, )
#MACRO G_DEFINE_INTERFACE_WITH_CODE(TN, t_n, T_P, _C_)
 _G_DEFINE_INTERFACE_EXTENDED_BEGIN(TN, t_n, T_P)
 _C_
 _G_DEFINE_TYPE_EXTENDED_END()
#ENDMACRO

#DEFINE G_IMPLEMENT_INTERFACE(TYPE_IFACE, iface_init) g_type_add_interface_static(g_define_type_id, TYPE_IFACE, @TYPE<CONST GInterfaceInfo>( CAST(GInterfaceInitFunc, @iface_init), NULL, NULL ))

#MACRO _G_DEFINE_INTERFACE_EXTENDED_BEGIN(TypeName, type_name)
 DECLARE SUB type_name##_default_init CDECL(BYVAL AS TypeName##Interface PTR)

 FUNCTION type_name##_get_type CDECL()AS GType
  STATIC AS gsize static_g_define_type_id = 0
  IF g_once_init_enter(@static_g_define_type_id) THEN
   VAR g_define_type_id = _
    g_type_register_static_simple( _
      G_TYPE_INTERFACE _
    , g_intern_static_string(@#TypeName) _
    , SIZEOF(TypeName##Interface) _
    , CAST(GClassInitFunc, @type_name##_default_init) _
    , 0 _
    , CAST(GInstanceInitFunc, NULL) _
    , CAST(GTypeFlags, 0))
   IF TYPE_PREREQ <> G_TYPE_INVALID THEN _
    g_type_interface_add_prerequisite(g_define_type_id, TYPE_PREREQ)
#ENDMACRO
#MACRO _G_DEFINE_INTERFACE_EXTENDED_END()
'/* following custom code
   END IF
   g_once_init_leave (@static_g_define_type_id, g_define_type_id)
  END IF
  RETURN static_g_define_type_id
 END FUNCTION
#ENDMACRO

#DEFINE G_DEFINE_BOXED_TYPE(TypeName, type_name, copy_func, free_func) G_DEFINE_BOXED_TYPE_WITH_CODE(TypeName, type_name, copy_func, free_func, )

#MACRO G_DEFINE_BOXED_TYPE_WITH_CODE(TypeName, type_name, copy_func, free_func, _C_)
 _G_DEFINE_BOXED_TYPE_BEGIN(TypeName, type_name, copy_func, free_func)
 _C_
 _G_DEFINE_TYPE_EXTENDED_END()
#ENDMACRO

#MACRO _G_DEFINE_BOXED_TYPE_BEGIN(TypeName, type_name, copy_func, free_func)
 DECLARE FUNCTION type_name##_get_type_once()AS GType
 FUNCTION type_name##_get_type CDECL()AS GType
  STATIC AS gsize static_g_define_type_id = 0
  IF g_once_init_enter(@static_g_define_type_id) THEN
   VAR g_define_type_id = type_name##_get_type_once()
   g_once_init_leave(@static_g_define_type_id, g_define_type_id)
  END IF
  RETURN static_g_define_type_id
 END FUNCTION

 FUNCTION type_name##_get_type_once()AS GType
  VAR g_define_type_id = _
   g_boxed_type_register_static( _
     g_intern_static_string(#TypeName) _
   , CAST(GBoxedCopyFunc, copy_func) _
   , CAST(GBoxedFreeFunc, free_func))
' /* custom code follows */
#ENDMACRO

#DEFINE G_DEFINE_POINTER_TYPE(TypeName, type_name) G_DEFINE_POINTER_TYPE_WITH_CODE(TypeName, type_name, )

#MACRO G_DEFINE_POINTER_TYPE_WITH_CODE(TypeName, type_name, _C_)
 _G_DEFINE_POINTER_TYPE_BEGIN(TypeName, type_name)
 _C_
 _G_DEFINE_TYPE_EXTENDED_END()
#ENDMACRO

#MACRO _G_DEFINE_POINTER_TYPE_BEGIN(TypeName, type_name)
 DECLARE FUNCTION type_name##_get_type_once()AS GType
 FUNCTION type_name##_get_type CDECL()AS GType
   STATIC AS gsize static_g_define_type_id = 0
   IF g_once_init_enter(@static_g_define_type_id) THEN
    VAR g_define_type_id = _
     g_pointer_type_register_static(g_intern_static_string(@#TypeName))
    g_once_init_leave (&static_g_define_type_id, g_define_type_id)
   END IF
  RETURN static_g_define_type_id
 END FUNCTION
 FUNCTION type_name##_get_type_once()AS GType
 VAR g_define_type_id = _
  g_pointer_type_register_static(g_intern_static_string(#TypeName))
  '{ /* custom code follows */
#ENDMACRO

#DEFINE _G_TYPE_CHI(ip) (g_type_check_instance_(CAST(GTypeInstance PTR, ip)))
#DEFINE _G_TYPE_CHV(vl) (g_type_check_value_(CAST(GValue PTR, vl)))
#DEFINE _G_TYPE_CVH(vl, gt) (g_type_check_value_holds(CAST(GValue PTR, vl), gt))

#DEFINE G_TYPE_IS_VALUE(type) (g_type_check_is_value_type(type))
#DEFINE G_IS_VALUE(value) (G_TYPE_CHECK_VALUE(value))
#DEFINE G_VALUE_TYPE(value) (CAST(GValue PTR, value)->g_type)
#DEFINE G_VALUE_TYPE_NAME(value) (g_type_name(G_VALUE_TYPE(value)))
#DEFINE G_VALUE_HOLDS(value,type) (G_TYPE_CHECK_VALUE_TYPE((value), (type)))

#DEFINE G_VALUE_INIT_ (0, {0, 0})

#DEFINE G_TYPE_IS_PARAM(type) (G_TYPE_FUNDAMENTAL(type) = G_TYPE_PARAM)
#DEFINE G_PARAM_SPEC(pspec) (G_TYPE_CHECK_INSTANCE_CAST((pspec), G_TYPE_PARAM, GParamSpec))
#DEFINE G_IS_PARAM_SPEC(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM))
#DEFINE G_PARAM_SPEC_CLASS(pclass) (G_TYPE_CHECK_CLASS_CAST((pclass), G_TYPE_PARAM, GParamSpecClass))
#DEFINE G_IS_PARAM_SPEC_CLASS(pclass) (G_TYPE_CHECK_CLASS_TYPE((pclass), G_TYPE_PARAM))
#DEFINE G_PARAM_SPEC_GET_CLASS(pspec) (G_TYPE_INSTANCE_GET_CLASS((pspec), G_TYPE_PARAM, GParamSpecClass))
#DEFINE G_PARAM_SPEC_TYPE(pspec) (G_TYPE_FROM_INSTANCE(pspec))
#DEFINE G_PARAM_SPEC_TYPE_NAME(pspec) (g_type_name(G_PARAM_SPEC_TYPE(pspec)))
#DEFINE G_PARAM_SPEC_VALUE_TYPE(pspec) (G_PARAM_SPEC(pspec)->value_type)
#DEFINE G_VALUE_HOLDS_PARAM(value) (G_TYPE_CHECK_VALUE_TYPE((value), G_TYPE_PARAM))

#DEFINE G_CLOSURE_NEEDS_MARSHAL(closure) (CAST(GClosure PTR, closure)->marshal = NULL)
#DEFINE G_CLOSURE_N_NOTIFIERS(cl) (((cl)->n_guards SHL 1L) _
                                  + (cl)->n_fnotifiers + (cl)->n_inotifiers)
#DEFINE G_CCLOSURE_SWAP_DATA(cclosure) (CAST(GClosure PTR, cclosure)->derivative_flag)
#DEFINE G_CALLBACK(f) CAST(GCallback, f)

#DEFINE g_cclosure_marshal_BOOL__FLAGS g_cclosure_marshal_BOOLEAN__FLAGS
#DEFINE g_cclosure_marshal_BOOL__BOXED_BOXED g_cclosure_marshal_BOOLEAN__BOXED_BOXED

#DEFINE G_SIGNAL_TYPE_STATIC_SCOPE (G_TYPE_FLAG_RESERVED_ID_BIT)

#DEFINE g_signal_connect(instance, detailed_signal, c_handler, data) _
    g_signal_connect_data((instance), (detailed_signal), (c_handler), (data), NULL, CAST(GConnectFlags, 0))
#DEFINE g_signal_connect_after(instance, detailed_signal, c_handler, data) _
    g_signal_connect_data((instance), (detailed_signal), (c_handler), (data), NULL, G_CONNECT_AFTER)
#DEFINE g_signal_connect_swapped(instance, detailed_signal, c_handler, data) _
    g_signal_connect_data((instance), (detailed_signal), (c_handler), (data), NULL, G_CONNECT_SWAPPED)
#DEFINE g_signal_handlers_disconnect_by_func(instance, func, data) _
    g_signal_handlers_disconnect_matched((instance), _
       CAST(GSignalMatchType, (G_SIGNAL_MATCH_FUNC OR G_SIGNAL_MATCH_DATA)), _
       0, 0, NULL, (func), (data))
#DEFINE g_signal_handlers_disconnect_by_data(instance, data) _
    g_signal_handlers_disconnect_matched((instance), G_SIGNAL_MATCH_DATA, 0, 0, NULL, NULL, (data))
#DEFINE g_signal_handlers_block_by_func(instance, func, data) _
    g_signal_handlers_block_matched((instance), _
              CAST(GSignalMatchType, (G_SIGNAL_MATCH_FUNC OR G_SIGNAL_MATCH_DATA)), _
              0, 0, NULL, (func), (data))
#DEFINE g_signal_handlers_unblock_by_func(instance, func, data) _
    g_signal_handlers_unblock_matched((instance), _
              CAST(GSignalMatchType, (G_SIGNAL_MATCH_FUNC OR G_SIGNAL_MATCH_DATA)), _
              0, 0, NULL, (func), (data))

#DEFINE G_TYPE_IS_OBJECT(type) (G_TYPE_FUNDAMENTAL(type) = G_TYPE_OBJECT)
#DEFINE G_IS_OBJECT_CLASS(class) (G_TYPE_CHECK_CLASS_TYPE((class), G_TYPE_OBJECT))
#DEFINE G_OBJECT_TYPE(object) (G_TYPE_FROM_INSTANCE(object))
#DEFINE G_OBJECT_TYPE_NAME(object) (g_type_name(G_OBJECT_TYPE(object)))
#DEFINE G_OBJECT_CLASS_TYPE(class) (G_TYPE_FROM_CLASS(class))
#DEFINE G_OBJECT_CLASS_NAME(class) (g_type_name(G_OBJECT_CLASS_TYPE(class)))
#DEFINE G_VALUE_HOLDS_OBJECT(value) (G_TYPE_CHECK_VALUE_TYPE((value), G_TYPE_OBJECT))
#DEFINE G_TYPE_INITIALLY_UNOWNED (g_initially_unowned_get_type())
#DEFINE G_IS_INITIALLY_UNOWNED_CLASS(class) (G_TYPE_CHECK_CLASS_TYPE((class), G_TYPE_INITIALLY_UNOWNED))

#DEFINE G_OBJECT_WARN_INVALID_PSPEC(object, pname, property_id, pspec) _
   g_warning(!"%s: invalid %s id %u for \"%s\" of type `%s' in `%s'" _
           , G_STRLOC _
           , (pname) _
           , (property_id) _
           , CAST(GParamSpec PTR, pspec)->name _
           , g_type_name(G_PARAM_SPEC_TYPE(CAST(GParamSpec PTR, pspec))) _
           , G_OBJECT_TYPE_NAME(CAST(GObject PTR, object)))

#DEFINE G_OBJECT_WARN_INVALID_PROPERTY_ID(object, property_id, pspec) _
    G_OBJECT_WARN_INVALID_PSPEC((object), !"property", (property_id), (pspec))

#DEFINE G_TYPE_BINDING_FLAGS (g_binding_flags_get_type())

#DEFINE G_TYPE_DATE (g_date_get_type())
#DEFINE G_TYPE_STRV (g_strv_get_typ ())
#DEFINE G_TYPE_GSTRING (g_gstring_get_type())
#DEFINE G_TYPE_HASH_TABLE (g_hash_table_get_type())
#DEFINE G_TYPE_REGEX (g_regex_get_type())
#DEFINE G_TYPE_MATCH_INFO (g_match_info_get_type())
#DEFINE G_TYPE_ARRAY (g_array_get_type())
#DEFINE G_TYPE_BYTE_ARRAY (g_byte_array_get_type())
#DEFINE G_TYPE_PTR_ARRAY (g_ptr_array_get_type())
#DEFINE G_TYPE_BYTES (g_bytes_get_type())
#DEFINE G_TYPE_VARIANT_TYPE (g_variant_type_get_gtype())
#DEFINE G_TYPE_ERROR (g_error_get_type())
#DEFINE G_TYPE_DATE_TIME (g_date_time_get_type())
#DEFINE G_TYPE_IO_CHANNEL (g_io_channel_get_type())
#DEFINE G_TYPE_IO_CONDITION (g_io_condition_get_type())
#DEFINE G_TYPE_VARIANT_BUILDER (g_variant_builder_get_type())
#DEFINE G_TYPE_MAIN_LOOP (g_main_loop_get_type())
#DEFINE G_TYPE_MAIN_CONTEXT (g_main_context_get_type())
#DEFINE G_TYPE_SOURCE (g_source_get_type())
#DEFINE G_TYPE_KEY_FILE (g_key_file_get_type())

#DEFINE G_TYPE_IS_BOXED(type) (G_TYPE_FUNDAMENTAL(type) = G_TYPE_BOXED)
#DEFINE G_VALUE_HOLDS_BOXED(value) (G_TYPE_CHECK_VALUE_TYPE((value), G_TYPE_BOXED))

#DEFINE G_TYPE_CLOSURE (g_closure_get_type())
#DEFINE G_TYPE_VALUE (g_value_get_type())

#DEFINE G_TYPE_IS_ENUM(type) (G_TYPE_FUNDAMENTAL(type) = G_TYPE_ENUM)
#DEFINE G_ENUM_CLASS(class) (G_TYPE_CHECK_CLASS_CAST((class), G_TYPE_ENUM, GEnumClass))
#DEFINE G_IS_ENUM_CLASS(class) (G_TYPE_CHECK_CLASS_TYPE((class), G_TYPE_ENUM))
#DEFINE G_ENUM_CLASS_TYPE(class) (G_TYPE_FROM_CLASS(class))
#DEFINE G_ENUM_CLASS_TYPE_NAME(class) (g_type_name(G_ENUM_CLASS_TYPE (class)))
#DEFINE G_TYPE_IS_FLAGS(type) (G_TYPE_FUNDAMENTAL(type) = G_TYPE_FLAGS)
#DEFINE G_FLAGS_CLASS(class) (G_TYPE_CHECK_CLASS_CAST((class), G_TYPE_FLAGS, GFlagsClass))
#DEFINE G_IS_FLAGS_CLASS(class) (G_TYPE_CHECK_CLASS_TYPE((class), G_TYPE_FLAGS))
#DEFINE G_FLAGS_CLASS_TYPE(class) (G_TYPE_FROM_CLASS(class))
#DEFINE G_FLAGS_CLASS_TYPE_NAME(class) (g_type_name(G_FLAGS_CLASS_TYPE (class)))
#DEFINE G_VALUE_HOLDS_ENUM(value) (G_TYPE_CHECK_VALUE_TYPE((value), G_TYPE_ENUM))
#DEFINE G_VALUE_HOLDS_FLAGS(value) (G_TYPE_CHECK_VALUE_TYPE((value), G_TYPE_FLAGS))

#DEFINE G_TYPE_PARAM_CHAR (g_param_spec_types[0])
#DEFINE G_IS_PARAM_SPEC_CHAR(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_CHAR))
#DEFINE G_TYPE_PARAM_UCHAR (g_param_spec_types[1])
#DEFINE G_IS_PARAM_SPEC_UCHAR(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_UCHAR))
#DEFINE G_TYPE_PARAM_BOOLEAN (g_param_spec_types[2])
#DEFINE G_IS_PARAM_SPEC_BOOLEAN(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_BOOLEAN))
#DEFINE G_TYPE_PARAM_INT (g_param_spec_types[3])
#DEFINE G_IS_PARAM_SPEC_INT(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_INT))
#DEFINE G_TYPE_PARAM_UINT (g_param_spec_types[4])
#DEFINE G_IS_PARAM_SPEC_UINT(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_UINT))
#DEFINE G_TYPE_PARAM_LONG (g_param_spec_types[5])
#DEFINE G_IS_PARAM_SPEC_LONG(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_LONG))
#DEFINE G_TYPE_PARAM_ULONG (g_param_spec_types[6])
#DEFINE G_IS_PARAM_SPEC_ULONG(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_ULONG))
#DEFINE G_TYPE_PARAM_INT64 (g_param_spec_types[7])
#DEFINE G_IS_PARAM_SPEC_INT64(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_INT64))
#DEFINE G_TYPE_PARAM_UINT64 (g_param_spec_types[8])
#DEFINE G_IS_PARAM_SPEC_UINT64(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_UINT64))
#DEFINE G_TYPE_PARAM_UNICHAR (g_param_spec_types[9])
#DEFINE G_IS_PARAM_SPEC_UNICHAR(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_UNICHAR))
#DEFINE G_TYPE_PARAM_ENUM (g_param_spec_types[10])
#DEFINE G_IS_PARAM_SPEC_ENUM(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_ENUM))
#DEFINE G_TYPE_PARAM_FLAGS (g_param_spec_types[11])
#DEFINE G_IS_PARAM_SPEC_FLAGS(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_FLAGS))
#DEFINE G_TYPE_PARAM_FLOAT (g_param_spec_types[12])
#DEFINE G_IS_PARAM_SPEC_FLOAT(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_FLOAT))
#DEFINE G_TYPE_PARAM_DOUBLE (g_param_spec_types[13])
#DEFINE G_IS_PARAM_SPEC_DOUBLE(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_DOUBLE))
#DEFINE G_TYPE_PARAM_STRING (g_param_spec_types[14])
#DEFINE G_IS_PARAM_SPEC_STRING(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_STRING))
#DEFINE G_TYPE_PARAM_PARAM (g_param_spec_types[15])
#DEFINE G_IS_PARAM_SPEC_PARAM(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_PARAM))
#DEFINE G_TYPE_PARAM_BOXED (g_param_spec_types[16])
#DEFINE G_IS_PARAM_SPEC_BOXED(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_BOXED))
#DEFINE G_TYPE_PARAM_POINTER (g_param_spec_types[17])
#DEFINE G_IS_PARAM_SPEC_POINTER(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_POINTER))
#DEFINE G_TYPE_PARAM_VALUE_ARRAY (g_param_spec_types[18])
#DEFINE G_IS_PARAM_SPEC_VALUE_ARRAY(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_VALUE_ARRAY))
#DEFINE G_TYPE_PARAM_OBJECT (g_param_spec_types[19])
#DEFINE G_IS_PARAM_SPEC_OBJECT(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_OBJECT))
#DEFINE G_TYPE_PARAM_OVERRIDE (g_param_spec_types[20])
#DEFINE G_IS_PARAM_SPEC_OVERRIDE(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_OVERRIDE))
#DEFINE G_TYPE_PARAM_GTYPE (g_param_spec_types[21])
#DEFINE G_IS_PARAM_SPEC_GTYPE(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_GTYPE))
#DEFINE G_TYPE_PARAM_VARIANT (g_param_spec_types[22])
#DEFINE G_IS_PARAM_SPEC_VARIANT(pspec) (G_TYPE_CHECK_INSTANCE_TYPE((pspec), G_TYPE_PARAM_VARIANT))

#DEFINE G_IS_TYPE_MODULE_CLASS(class) (G_TYPE_CHECK_CLASS_TYPE((class), G_TYPE_TYPE_MODULE))

#DEFINE G_DEFINE_DYNAMIC_TYPE(TN, t_n, T_P) G_DEFINE_DYNAMIC_TYPE_EXTENDED(TN, t_n, T_P, 0, {})

#MACRO G_DEFINE_DYNAMIC_TYPE_EXTENDED(TypeName, type_name, TYPE_PARENT, flags, CODE)
 DECLARE SUB type_name##_init CDECL(BYVAL self AS TypeName PTR)
 DECLARE SUB type_name##_class_init CDECL(BYVAL klass AS TypeName##Class PTR)
 DECLARE SUB type_name##_class_finalize CDECL(BYVAL klass AS TypeName##Class PTR)
 STATIC SHARED AS gpointer type_name##_parent_class = NULL
 STATIC SHARED AS GType type_name##_type_id = 0
 SUB type_name##_class_intern_init CDECL(BYVAL klass AS gpointer)
   type_name##_parent_class = g_type_class_peek_parent(klass)
   type_name##_class_init(CAST(TypeName##Class PTR, klass))
 END SUB

 FUNCTION type_name##_get_type CDECL()AS GType
   RETURN type_name##_type_id
 END FUNCTION

 SUB type_name##_register_type CDECL(BYVAL type_module AS GTypeModule PTR)
   DIM AS GType g_define_type_id
   CONST AS GTypeInfo g_define_type_info = TYPE<GTypeInfo>( _
     SIZEOF(TypeName##Class), _
     CAST(GBaseInitFunc, NULL), _
     CAST(GBaseFinalizeFunc, NULL), _
     CAST(GClassInitFunc, @type_name##_class_intern_init), _
     CAST(GClassFinalizeFunc, @type_name##_class_finalize), _
     NULL, _
     SIZEOF(TypeName), _
     0, _
     CAST(GInstanceInitFunc, @type_name##_init), _
     NULL )
   type_name##_type_id = g_type_module_register_type(type_module, TYPE_PARENT, #TypeName, @g_define_type_info, CAST(GTypeFlags, flags))
   g_define_type_id = type_name##_type_id
   CODE
 END SUB
#ENDMACRO

#MACRO G_IMPLEMENT_INTERFACE_DYNAMIC(TYPE_IFACE, iface_init)
 SCOPE
  CONST AS GInterfaceInfo g_implement_interface_info = TYPE<GInterfaceInfo>(CAST(GInterfaceInitFunc, iface_init), NULL, NULL )
  g_type_module_add_interface(type_module, g_define_type_id, TYPE_IFACE, @g_implement_interface_info)
 END SCOPE
#ENDMACRO

#DEFINE G_IS_TYPE_PLUGIN_CLASS(vtable) (G_TYPE_CHECK_CLASS_TYPE((vtable), G_TYPE_TYPE_PLUGIN))
#DEFINE G_TYPE_PLUGIN_GET_CLASS(inst) (G_TYPE_INSTANCE_GET_INTERFACE((inst), G_TYPE_TYPE_PLUGIN, GTypePluginClass))

#DEFINE G_TYPE_VALUE_ARRAY (g_value_array_get_type())

#DEFINE G_VALUE_HOLDS_CHAR(value) (G_TYPE_CHECK_VALUE_TYPE((value), G_TYPE_CHAR))
#DEFINE G_VALUE_HOLDS_UCHAR(value) (G_TYPE_CHECK_VALUE_TYPE((value), G_TYPE_UCHAR))
#DEFINE G_VALUE_HOLDS_BOOLEAN(value) (G_TYPE_CHECK_VALUE_TYPE((value), G_TYPE_BOOLEAN))
#DEFINE G_VALUE_HOLDS_INT(value) (G_TYPE_CHECK_VALUE_TYPE((value), G_TYPE_INT))
#DEFINE G_VALUE_HOLDS_UINT(value) (G_TYPE_CHECK_VALUE_TYPE((value), G_TYPE_UINT))
#DEFINE G_VALUE_HOLDS_LONG(value) (G_TYPE_CHECK_VALUE_TYPE((value), G_TYPE_LONG))
#DEFINE G_VALUE_HOLDS_ULONG(value) (G_TYPE_CHECK_VALUE_TYPE((value), G_TYPE_ULONG))
#DEFINE G_VALUE_HOLDS_INT64(value) (G_TYPE_CHECK_VALUE_TYPE((value), G_TYPE_INT64))
#DEFINE G_VALUE_HOLDS_UINT64(value) (G_TYPE_CHECK_VALUE_TYPE((value), G_TYPE_UINT64))
#DEFINE G_VALUE_HOLDS_FLOAT(value) (G_TYPE_CHECK_VALUE_TYPE((value), G_TYPE_FLOAT))
#DEFINE G_VALUE_HOLDS_DOUBLE(value) (G_TYPE_CHECK_VALUE_TYPE((value), G_TYPE_DOUBLE))
#DEFINE G_VALUE_HOLDS_STRING(value) (G_TYPE_CHECK_VALUE_TYPE((value), G_TYPE_STRING))
#DEFINE G_VALUE_HOLDS_POINTER(value) (G_TYPE_CHECK_VALUE_TYPE((value), G_TYPE_POINTER))
#DEFINE G_TYPE_GTYPE (g_gtype_get_type())
#DEFINE G_VALUE_HOLDS_GTYPE(value) (G_TYPE_CHECK_VALUE_TYPE((value), G_TYPE_GTYPE))
#DEFINE G_VALUE_HOLDS_VARIANT(value) (G_TYPE_CHECK_VALUE_TYPE((value), G_TYPE_VARIANT))

#DEFINE G_ADD_PRIVATE(TypeName) TypeName##_private_offset = _
 g_type_add_instance_private(g_define_type_id, SIZEOF(TypeName##Private))

'/* Added for _G_DEFINE_TYPE_EXTENDED_WITH_PRELUDE */
#MACRO _G_DEFINE_TYPE_EXTENDED_BEGIN_PRE(TypeName, type_name, TYPE_PARENT)
DECLARE SUB type_name##_init CDECL(BYVAL AS TypeName PTR)
DECLARE SUB type_name##_class_init CDECL(BYVAL AS TypeName##Class PTR)
DECLARE FUNCTION type_name##_get_type_once()AS GType
STATIC SHARED AS gpointer type_name##_parent_class = NULL
STATIC SHARED AS gint TypeName##_private_offset

_G_DEFINE_TYPE_EXTENDED_CLASS_INIT(TypeName, type_name)

FUNCTION type_name##_get_instance_private(BYVAL self AS TypeName PTR)AS gpointer
 RETURN G_STRUCT_MEMBER_P(self, TypeName##_private_offset)
END FUNCTION

FUNCTION type_name##_get_type()AS GType
 STATIC AS gsize static_g_define_type_id = 0
 '/* Prelude goes here */
#ENDMACRO


'/* Added for _G_DEFINE_TYPE_EXTENDED_WITH_PRELUDE */
#MACRO _G_DEFINE_TYPE_EXTENDED_BEGIN_REGISTER(TypeName, type_name, TYPE_PARENT, flags)
  IF g_once_init_enter(@static_g_define_type_id) THEN
   VAR g_define_type_id = type_name##_get_type_once()
   g_once_init_leave(@static_g_define_type_id, g_define_type_id)
  END IF
  RETURN static_g_define_type_id
 END FUNCTION '/* closes type_name##_get_type()

 FUNCTION type_name##_get_type_once()AS GType
  VAR g_define_type_id = _
   g_type_register_static_simple(TYPE_PARENT _
   , g_intern_static_string(#TypeName) _
   , SIZEOF(TypeName##Class) _
   , CAST(GClassInitFunc, @type_name##_class_intern_init) _
   , SIZEOF(TypeName) _
   , CAST(GInstanceInitFunc, @type_name##_init) _
   , CAST(GTypeFlags, flags))
  '{ /* custom code follows
#ENDMACRO
#MACRO _G_DEFINE_TYPE_EXTENDED_END()
  RETURN g_define_type_id
 END FUNCTION '/* closes type_name##_get_type_once()
#ENDMACRO

#MACRO _G_DEFINE_TYPE_EXTENDED_CLASS_INIT(TypeName, type_name)
SUB type_name##_class_intern_init(BYVAL klass AS gpointer)
 type_name##_parent_class = g_type_class_peek_parent(klass)
 IF TypeName##_private_offset <> 0 THEN _
  g_type_class_adjust_private_offset(klass, @TypeName##_private_offset)
 type_name##_class_init(CAST(TypeName##Class PTR, klass))
END SUB
#ENDMACRO

#MACRO _G_DEFINE_TYPE_EXTENDED_BEGIN(TypeName, type_name, TYPE_PARENT, flags)
  _G_DEFINE_TYPE_EXTENDED_BEGIN_PRE(TypeName, type_name, TYPE_PARENT)
  _G_DEFINE_TYPE_EXTENDED_BEGIN_REGISTER(TypeName, type_name, TYPE_PARENT, flags)
#ENDMACRO

#DEFINE G_DEFINE_TYPE_WITH_PRIVATE(TN, t_n, T_P) _
  G_DEFINE_TYPE_EXTENDED(TN, t_n, T_P, 0, G_ADD_PRIVATE(TN))

#DEFINE G_DEFINE_ABSTRACT_TYPE_WITH_PRIVATE(TN, t_n, T_P) _
  G_DEFINE_TYPE_EXTENDED(TN, t_n, T_P, G_TYPE_FLAG_ABSTRACT, G_ADD_PRIVATE(TN))

#DEFINE G_PRIVATE_OFFSET(TypeName, FIELD) _
  (TypeName##_private_offset + (OFFSETOF(TypeName##Private, FIELD)))

#DEFINE G_PRIVATE_FIELD_P(TypeName, inst, field_name) _
  G_STRUCT_MEMBER_P(inst, G_PRIVATE_OFFSET(TypeName, field_name))

#DEFINE G_PRIVATE_FIELD(TypeName, inst, field_type, field_name) _
  G_STRUCT_MEMBER(field_type, inst, G_PRIVATE_OFFSET(TypeName, field_name))

#DEFINE G_DECLARE_FINAL_TYPE(a,b,c,d,e) #PRINT macro G_DECLARE_FINAL_TYPE() NOT tranlatable
#DEFINE G_DECLARE_DERIVABLE_TYPE(a,b,c,d,e) #PRINT macro G_DECLARE_DERIVABLE_TYPE() NOT tranlatable
#DEFINE G_DECLARE_INTERFACE(a,b,c,d,e) #PRINT macro G_DECLARE_INTERFACE() NOT tranlatable

#define G_DEFINE_FINAL_TYPE(TN, t_n, T_P) _
  G_DEFINE_TYPE_EXTENDED (TN, t_n, T_P, G_TYPE_FLAG_FINAL, ) 'GLIB_AVAILABLE_MACRO_IN_2_70
#define G_DEFINE_FINAL_TYPE_WITH_CODE(TN, t_n, T_P, _C_) _
  _G_DEFINE_TYPE_EXTENDED_BEGIN (TN, t_n, T_P, G_TYPE_FLAG_FINAL) : _C_ : _G_DEFINE_TYPE_EXTENDED_END() 'GLIB_AVAILABLE_MACRO_IN_2_70
#define G_DEFINE_FINAL_TYPE_WITH_PRIVATE(TN, t_n, T_P) _
  G_DEFINE_TYPE_EXTENDED (TN, t_n, T_P, G_TYPE_FLAG_FINAL, G_ADD_PRIVATE (TN)) 'GLIB_AVAILABLE_MACRO_IN_2_70
