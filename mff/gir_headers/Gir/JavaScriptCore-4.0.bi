'            FreeBasic header file, auto-generated by
'                       ### girtobac ###
' LGPLv2.1 (C) 2013-2022 by Thomas{ doT ]Freiherr[ At ]gmx[ DoT }net
' Auto-translated from file /usr/share/gir-1.0/JavaScriptCore-4.0.gir
#INCLUDE ONCE "_GirToBac-0.0.bi"
' Repository version 1.2
#INCLUDE ONCE "GObject-2.0.bi"
TYPE AS LONG JSCCheckSyntaxMode
ENUM
  JSC_CHECK_SYNTAX_MODE_SCRIPT = 0
  JSC_CHECK_SYNTAX_MODE_MODULE = 1
END ENUM
TYPE AS LONG JSCCheckSyntaxResult
ENUM
  JSC_CHECK_SYNTAX_RESULT_SUCCESS = 0
  JSC_CHECK_SYNTAX_RESULT_RECOVERABLE_ERROR = 1
  JSC_CHECK_SYNTAX_RESULT_IRRECOVERABLE_ERROR = 2
  JSC_CHECK_SYNTAX_RESULT_UNTERMINATED_LITERAL_ERROR = 3
  JSC_CHECK_SYNTAX_RESULT_OUT_OF_MEMORY_ERROR = 4
  JSC_CHECK_SYNTAX_RESULT_STACK_OVERFLOW_ERROR = 5
END ENUM
TYPE AS _JSCClass JSCClass
TYPE AS _JSCClassClass JSCClassClass
TYPE AS _JSCClassVTable JSCClassVTable
TYPE AS _JSCContext JSCContext
TYPE AS _JSCContextClass JSCContextClass
TYPE AS _JSCContextPrivate JSCContextPrivate
TYPE AS _JSCException JSCException
TYPE AS _JSCExceptionClass JSCExceptionClass
TYPE AS _JSCExceptionPrivate JSCExceptionPrivate
#DEFINE JSC_MAJOR_VERSION 2
#DEFINE JSC_MICRO_VERSION 2
#DEFINE JSC_MINOR_VERSION 28
#DEFINE JSC_OPTIONS_USE_DFG @!"useDFGJIT"
#DEFINE JSC_OPTIONS_USE_FTL @!"useFTLJIT"
#DEFINE JSC_OPTIONS_USE_JIT @!"useJIT"
#DEFINE JSC_OPTIONS_USE_LLINT @!"useLLInt"
TYPE AS LONG JSCOptionType
ENUM
  JSC_OPTION_BOOLEAN = 0
  JSC_OPTION_INT = 1
  JSC_OPTION_UINT = 2
  JSC_OPTION_SIZE = 3
  JSC_OPTION_DOUBLE = 4
  JSC_OPTION_STRING = 5
  JSC_OPTION_RANGE_STRING = 6
END ENUM
TYPE AS _JSCValue JSCValue
TYPE AS _JSCValueClass JSCValueClass
TYPE AS _JSCValuePrivate JSCValuePrivate
TYPE AS LONG JSCValuePropertyFlags
ENUM
  JSC_VALUE_PROPERTY_CONFIGURABLE = 1
  JSC_VALUE_PROPERTY_ENUMERABLE = 2
  JSC_VALUE_PROPERTY_WRITABLE = 4
END ENUM
TYPE AS _JSCVirtualMachine JSCVirtualMachine
TYPE AS _JSCVirtualMachineClass JSCVirtualMachineClass
TYPE AS _JSCVirtualMachinePrivate JSCVirtualMachinePrivate
TYPE AS _JSCWeakValue JSCWeakValue
TYPE AS _JSCWeakValueClass JSCWeakValueClass
TYPE AS _JSCWeakValuePrivate JSCWeakValuePrivate
EXTERN "C" LIB "javascriptcoregtk-4.0"
' P_X

TYPE JSCExceptionHandler AS SUB CDECL(BYVAL AS JSCContext PTR, BYVAL AS JSCException PTR, BYVAL AS gpointer)
' P_3

DECLARE FUNCTION jsc_class_get_type() AS GType
#DEFINE JAVASCRIPTCORE_TYPE_CLASS (jsc_class_get_type())
#DEFINE JAVASCRIPTCORE_CLASS(obj) (G_TYPE_CHECK_INSTANCE_CAST((obj), JAVASCRIPTCORE_TYPE_CLASS, JSCClass))
#DEFINE JAVASCRIPTCORE_CLASS_CLASS(obj) (G_TYPE_CHECK_CLASS_CAST((obj), JAVASCRIPTCORE_TYPE_CLASS, JavaScriptCoreClassClass))
#DEFINE JAVASCRIPTCORE_IS_CLASS(obj) (G_TYPE_CHECK_INSTANCE_TYPE((obj), JAVASCRIPTCORE_TYPE_CLASS))
#DEFINE JAVASCRIPTCORE_IS_CLASS_CLASS(obj) (G_TYPE_CHECK_CLASS_TYPE((obj), JAVASCRIPTCORE_TYPE_CLASS))
#DEFINE JAVASCRIPTCORE_CLASS_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS((obj), JAVASCRIPTCORE_TYPE_CLASS, JavaScriptCoreClassClass))
DECLARE FUNCTION jsc_class_add_constructor(BYVAL AS JSCClass PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS GCallback, BYVAL AS gpointer, BYVAL AS GDestroyNotify, BYVAL AS GType, BYVAL AS guint, ...) AS JSCValue PTR
DECLARE FUNCTION jsc_class_add_constructor_variadic(BYVAL AS JSCClass PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS GCallback, BYVAL AS gpointer, BYVAL AS GDestroyNotify, BYVAL AS GType) AS JSCValue PTR
DECLARE FUNCTION jsc_class_add_constructorv(BYVAL AS JSCClass PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS GCallback, BYVAL AS gpointer, BYVAL AS GDestroyNotify, BYVAL AS GType, BYVAL AS guint, BYVAL AS GType PTR) AS JSCValue PTR
DECLARE SUB jsc_class_add_method(BYVAL AS JSCClass PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS GCallback, BYVAL AS gpointer, BYVAL AS GDestroyNotify, BYVAL AS GType, BYVAL AS guint, ...)
DECLARE SUB jsc_class_add_method_variadic(BYVAL AS JSCClass PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS GCallback, BYVAL AS gpointer, BYVAL AS GDestroyNotify, BYVAL AS GType)
DECLARE SUB jsc_class_add_methodv(BYVAL AS JSCClass PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS GCallback, BYVAL AS gpointer, BYVAL AS GDestroyNotify, BYVAL AS GType, BYVAL AS guint, BYVAL AS GType PTR)
DECLARE SUB jsc_class_add_property(BYVAL AS JSCClass PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS GType, BYVAL AS GCallback, BYVAL AS GCallback, BYVAL AS gpointer, BYVAL AS GDestroyNotify)
DECLARE FUNCTION jsc_class_get_name(BYVAL AS JSCClass PTR) AS const gchar /'const char'/ PTR
DECLARE FUNCTION jsc_class_get_parent(BYVAL AS JSCClass PTR) AS JSCClass PTR
TYPE JSCClassDeletePropertyFunction AS FUNCTION CDECL(BYVAL AS JSCClass PTR, BYVAL AS JSCContext PTR, BYVAL AS gpointer, BYVAL AS const gchar /'const char'/ PTR) AS gboolean
TYPE JSCClassEnumeratePropertiesFunction AS FUNCTION CDECL(BYVAL AS JSCClass PTR, BYVAL AS JSCContext PTR, BYVAL AS gpointer) AS gchar PTR PTR
TYPE JSCClassGetPropertyFunction AS FUNCTION CDECL(BYVAL AS JSCClass PTR, BYVAL AS JSCContext PTR, BYVAL AS gpointer, BYVAL AS const gchar /'const char'/ PTR) AS JSCValue PTR
TYPE JSCClassHasPropertyFunction AS FUNCTION CDECL(BYVAL AS JSCClass PTR, BYVAL AS JSCContext PTR, BYVAL AS gpointer, BYVAL AS const gchar /'const char'/ PTR) AS gboolean
TYPE JSCClassSetPropertyFunction AS FUNCTION CDECL(BYVAL AS JSCClass PTR, BYVAL AS JSCContext PTR, BYVAL AS gpointer, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS JSCValue PTR) AS gboolean
TYPE _JSCClassVTable
  AS JSCClassGetPropertyFunction get_property
  AS JSCClassSetPropertyFunction set_property
  AS JSCClassHasPropertyFunction has_property
  AS JSCClassDeletePropertyFunction delete_property
  AS JSCClassEnumeratePropertiesFunction enumerate_properties
  _jsc_reserved0 AS SUB CDECL()
  _jsc_reserved1 AS SUB CDECL()
  _jsc_reserved2 AS SUB CDECL()
  _jsc_reserved3 AS SUB CDECL()
END TYPE
TYPE _JSCContext
  AS GObject parent
  AS JSCContextPrivate PTR priv
END TYPE
DECLARE FUNCTION jsc_context_get_type() AS GType
#DEFINE JAVASCRIPTCORE_TYPE_CONTEXT (jsc_context_get_type())
#DEFINE JAVASCRIPTCORE_CONTEXT(obj) (G_TYPE_CHECK_INSTANCE_CAST((obj), JAVASCRIPTCORE_TYPE_CONTEXT, JSCContext))
#DEFINE JAVASCRIPTCORE_CONTEXT_CLASS(obj) (G_TYPE_CHECK_CLASS_CAST((obj), JAVASCRIPTCORE_TYPE_CONTEXT, JavaScriptCoreContextClass))
#DEFINE JAVASCRIPTCORE_IS_CONTEXT(obj) (G_TYPE_CHECK_INSTANCE_TYPE((obj), JAVASCRIPTCORE_TYPE_CONTEXT))
#DEFINE JAVASCRIPTCORE_IS_CLASS_CONTEXT(obj) (G_TYPE_CHECK_CLASS_TYPE((obj), JAVASCRIPTCORE_TYPE_CONTEXT))
#DEFINE JAVASCRIPTCORE_CONTEXT_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS((obj), JAVASCRIPTCORE_TYPE_CONTEXT, JavaScriptCoreContextClass))
DECLARE FUNCTION jsc_context_new() AS JSCContext PTR
DECLARE FUNCTION jsc_context_new_with_virtual_machine(BYVAL AS JSCVirtualMachine PTR) AS JSCContext PTR
DECLARE FUNCTION jsc_context_get_current() AS JSCContext PTR
DECLARE FUNCTION jsc_context_check_syntax(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS gssize, BYVAL AS JSCCheckSyntaxMode, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS guint /'unsigned'/, BYVAL AS JSCException PTR PTR) AS JSCCheckSyntaxResult
DECLARE SUB jsc_context_clear_exception(BYVAL AS JSCContext PTR)
DECLARE FUNCTION jsc_context_evaluate(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS gssize) AS JSCValue PTR
DECLARE FUNCTION jsc_context_evaluate_in_object(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS gssize, BYVAL AS gpointer, BYVAL AS JSCClass PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS guint, BYVAL AS JSCValue PTR PTR) AS JSCValue PTR
DECLARE FUNCTION jsc_context_evaluate_with_source_uri(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS gssize, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS guint) AS JSCValue PTR
DECLARE FUNCTION jsc_context_get_exception(BYVAL AS JSCContext PTR) AS JSCException PTR
DECLARE FUNCTION jsc_context_get_global_object(BYVAL AS JSCContext PTR) AS JSCValue PTR
DECLARE FUNCTION jsc_context_get_value(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR) AS JSCValue PTR
DECLARE FUNCTION jsc_context_get_virtual_machine(BYVAL AS JSCContext PTR) AS JSCVirtualMachine PTR
DECLARE SUB jsc_context_pop_exception_handler(BYVAL AS JSCContext PTR)
DECLARE SUB jsc_context_push_exception_handler(BYVAL AS JSCContext PTR, BYVAL AS JSCExceptionHandler, BYVAL AS gpointer, BYVAL AS GDestroyNotify)
DECLARE FUNCTION jsc_context_register_class(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS JSCClass PTR, BYVAL AS JSCClassVTable PTR, BYVAL AS GDestroyNotify) AS JSCClass PTR
DECLARE SUB jsc_context_set_value(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS JSCValue PTR)
DECLARE SUB jsc_context_throw(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR)
DECLARE SUB jsc_context_throw_exception(BYVAL AS JSCContext PTR, BYVAL AS JSCException PTR)
DECLARE SUB jsc_context_throw_printf(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR, ...)
DECLARE SUB jsc_context_throw_with_name(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS const gchar /'const char'/ PTR)
DECLARE SUB jsc_context_throw_with_name_printf(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS const gchar /'const char'/ PTR, ...)
TYPE _JSCContextClass
  AS GObjectClass parent_class
  _jsc_reserved0 AS SUB CDECL()
  _jsc_reserved1 AS SUB CDECL()
  _jsc_reserved2 AS SUB CDECL()
  _jsc_reserved3 AS SUB CDECL()
END TYPE
TYPE _JSCException
  AS GObject parent
  AS JSCExceptionPrivate PTR priv
END TYPE
DECLARE FUNCTION jsc_exception_get_type() AS GType
#DEFINE JAVASCRIPTCORE_TYPE_EXCEPTION (jsc_exception_get_type())
#DEFINE JAVASCRIPTCORE_EXCEPTION(obj) (G_TYPE_CHECK_INSTANCE_CAST((obj), JAVASCRIPTCORE_TYPE_EXCEPTION, JSCException))
#DEFINE JAVASCRIPTCORE_EXCEPTION_CLASS(obj) (G_TYPE_CHECK_CLASS_CAST((obj), JAVASCRIPTCORE_TYPE_EXCEPTION, JavaScriptCoreExceptionClass))
#DEFINE JAVASCRIPTCORE_IS_EXCEPTION(obj) (G_TYPE_CHECK_INSTANCE_TYPE((obj), JAVASCRIPTCORE_TYPE_EXCEPTION))
#DEFINE JAVASCRIPTCORE_IS_CLASS_EXCEPTION(obj) (G_TYPE_CHECK_CLASS_TYPE((obj), JAVASCRIPTCORE_TYPE_EXCEPTION))
#DEFINE JAVASCRIPTCORE_EXCEPTION_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS((obj), JAVASCRIPTCORE_TYPE_EXCEPTION, JavaScriptCoreExceptionClass))
DECLARE FUNCTION jsc_exception_new(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR) AS JSCException PTR
DECLARE FUNCTION jsc_exception_new_printf(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR, ...) AS JSCException PTR
DECLARE FUNCTION jsc_exception_new_vprintf(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS va_list) AS JSCException PTR
DECLARE FUNCTION jsc_exception_new_with_name(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS const gchar /'const char'/ PTR) AS JSCException PTR
DECLARE FUNCTION jsc_exception_new_with_name_printf(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS const gchar /'const char'/ PTR, ...) AS JSCException PTR
DECLARE FUNCTION jsc_exception_new_with_name_vprintf(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS va_list) AS JSCException PTR
DECLARE FUNCTION jsc_exception_get_backtrace_string(BYVAL AS JSCException PTR) AS const gchar /'const char'/ PTR
DECLARE FUNCTION jsc_exception_get_column_number(BYVAL AS JSCException PTR) AS guint
DECLARE FUNCTION jsc_exception_get_line_number(BYVAL AS JSCException PTR) AS guint
DECLARE FUNCTION jsc_exception_get_message(BYVAL AS JSCException PTR) AS const gchar /'const char'/ PTR
DECLARE FUNCTION jsc_exception_get_name(BYVAL AS JSCException PTR) AS const gchar /'const char'/ PTR
DECLARE FUNCTION jsc_exception_get_source_uri(BYVAL AS JSCException PTR) AS const gchar /'const char'/ PTR
DECLARE FUNCTION jsc_exception_report(BYVAL AS JSCException PTR) AS char PTR
DECLARE FUNCTION jsc_exception_to_string(BYVAL AS JSCException PTR) AS char PTR
TYPE _JSCExceptionClass
  AS GObjectClass parent_class
  _jsc_reserved0 AS SUB CDECL()
  _jsc_reserved1 AS SUB CDECL()
  _jsc_reserved2 AS SUB CDECL()
  _jsc_reserved3 AS SUB CDECL()
END TYPE
TYPE JSCOptionsFunc AS FUNCTION CDECL(BYVAL AS const gchar /'const char'/ PTR, BYVAL AS JSCOptionType, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS gpointer) AS gboolean
TYPE _JSCValue
  AS GObject parent
  AS JSCValuePrivate PTR priv
END TYPE
DECLARE FUNCTION jsc_value_get_type() AS GType
#DEFINE JAVASCRIPTCORE_TYPE_VALUE (jsc_value_get_type())
#DEFINE JAVASCRIPTCORE_VALUE(obj) (G_TYPE_CHECK_INSTANCE_CAST((obj), JAVASCRIPTCORE_TYPE_VALUE, JSCValue))
#DEFINE JAVASCRIPTCORE_VALUE_CLASS(obj) (G_TYPE_CHECK_CLASS_CAST((obj), JAVASCRIPTCORE_TYPE_VALUE, JavaScriptCoreValueClass))
#DEFINE JAVASCRIPTCORE_IS_VALUE(obj) (G_TYPE_CHECK_INSTANCE_TYPE((obj), JAVASCRIPTCORE_TYPE_VALUE))
#DEFINE JAVASCRIPTCORE_IS_CLASS_VALUE(obj) (G_TYPE_CHECK_CLASS_TYPE((obj), JAVASCRIPTCORE_TYPE_VALUE))
#DEFINE JAVASCRIPTCORE_VALUE_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS((obj), JAVASCRIPTCORE_TYPE_VALUE, JavaScriptCoreValueClass))
DECLARE FUNCTION jsc_value_new_array(BYVAL AS JSCContext PTR, BYVAL AS GType, ...) AS JSCValue PTR
DECLARE FUNCTION jsc_value_new_array_from_garray(BYVAL AS JSCContext PTR, BYVAL AS GPtrArray PTR) AS JSCValue PTR
DECLARE FUNCTION jsc_value_new_array_from_strv(BYVAL AS JSCContext PTR, BYVAL AS const gchar ptr const /'const char* const'/ PTR) AS JSCValue PTR
DECLARE FUNCTION jsc_value_new_boolean(BYVAL AS JSCContext PTR, BYVAL AS gboolean) AS JSCValue PTR
DECLARE FUNCTION jsc_value_new_from_json(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR) AS JSCValue PTR
DECLARE FUNCTION jsc_value_new_function(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS GCallback, BYVAL AS gpointer, BYVAL AS GDestroyNotify, BYVAL AS GType, BYVAL AS guint, ...) AS JSCValue PTR
DECLARE FUNCTION jsc_value_new_function_variadic(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS GCallback, BYVAL AS gpointer, BYVAL AS GDestroyNotify, BYVAL AS GType) AS JSCValue PTR
DECLARE FUNCTION jsc_value_new_functionv(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS GCallback, BYVAL AS gpointer, BYVAL AS GDestroyNotify, BYVAL AS GType, BYVAL AS guint, BYVAL AS GType PTR) AS JSCValue PTR
DECLARE FUNCTION jsc_value_new_null(BYVAL AS JSCContext PTR) AS JSCValue PTR
DECLARE FUNCTION jsc_value_new_number(BYVAL AS JSCContext PTR, BYVAL AS double) AS JSCValue PTR
DECLARE FUNCTION jsc_value_new_object(BYVAL AS JSCContext PTR, BYVAL AS gpointer, BYVAL AS JSCClass PTR) AS JSCValue PTR
DECLARE FUNCTION jsc_value_new_string(BYVAL AS JSCContext PTR, BYVAL AS const gchar /'const char'/ PTR) AS JSCValue PTR
DECLARE FUNCTION jsc_value_new_string_from_bytes(BYVAL AS JSCContext PTR, BYVAL AS GBytes PTR) AS JSCValue PTR
DECLARE FUNCTION jsc_value_new_undefined(BYVAL AS JSCContext PTR) AS JSCValue PTR
DECLARE FUNCTION jsc_value_constructor_call(BYVAL AS JSCValue PTR, BYVAL AS GType, ...) AS JSCValue PTR
DECLARE FUNCTION jsc_value_constructor_callv(BYVAL AS JSCValue PTR, BYVAL AS guint, BYVAL AS JSCValue PTR PTR) AS JSCValue PTR
DECLARE FUNCTION jsc_value_function_call(BYVAL AS JSCValue PTR, BYVAL AS GType, ...) AS JSCValue PTR
DECLARE FUNCTION jsc_value_function_callv(BYVAL AS JSCValue PTR, BYVAL AS guint, BYVAL AS JSCValue PTR PTR) AS JSCValue PTR
DECLARE FUNCTION jsc_value_get_context(BYVAL AS JSCValue PTR) AS JSCContext PTR
DECLARE FUNCTION jsc_value_is_array(BYVAL AS JSCValue PTR) AS gboolean
DECLARE FUNCTION jsc_value_is_boolean(BYVAL AS JSCValue PTR) AS gboolean
DECLARE FUNCTION jsc_value_is_constructor(BYVAL AS JSCValue PTR) AS gboolean
DECLARE FUNCTION jsc_value_is_function(BYVAL AS JSCValue PTR) AS gboolean
DECLARE FUNCTION jsc_value_is_null(BYVAL AS JSCValue PTR) AS gboolean
DECLARE FUNCTION jsc_value_is_number(BYVAL AS JSCValue PTR) AS gboolean
DECLARE FUNCTION jsc_value_is_object(BYVAL AS JSCValue PTR) AS gboolean
DECLARE FUNCTION jsc_value_is_string(BYVAL AS JSCValue PTR) AS gboolean
DECLARE FUNCTION jsc_value_is_undefined(BYVAL AS JSCValue PTR) AS gboolean
DECLARE SUB jsc_value_object_define_property_accessor(BYVAL AS JSCValue PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS JSCValuePropertyFlags, BYVAL AS GType, BYVAL AS GCallback, BYVAL AS GCallback, BYVAL AS gpointer, BYVAL AS GDestroyNotify)
DECLARE SUB jsc_value_object_define_property_data(BYVAL AS JSCValue PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS JSCValuePropertyFlags, BYVAL AS JSCValue PTR)
DECLARE FUNCTION jsc_value_object_delete_property(BYVAL AS JSCValue PTR, BYVAL AS const gchar /'const char'/ PTR) AS gboolean
DECLARE FUNCTION jsc_value_object_enumerate_properties(BYVAL AS JSCValue PTR) AS gchar PTR PTR
DECLARE FUNCTION jsc_value_object_get_property(BYVAL AS JSCValue PTR, BYVAL AS const gchar /'const char'/ PTR) AS JSCValue PTR
DECLARE FUNCTION jsc_value_object_get_property_at_index(BYVAL AS JSCValue PTR, BYVAL AS guint) AS JSCValue PTR
DECLARE FUNCTION jsc_value_object_has_property(BYVAL AS JSCValue PTR, BYVAL AS const gchar /'const char'/ PTR) AS gboolean
DECLARE FUNCTION jsc_value_object_invoke_method(BYVAL AS JSCValue PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS GType, ...) AS JSCValue PTR
DECLARE FUNCTION jsc_value_object_invoke_methodv(BYVAL AS JSCValue PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS guint, BYVAL AS JSCValue PTR PTR) AS JSCValue PTR
DECLARE FUNCTION jsc_value_object_is_instance_of(BYVAL AS JSCValue PTR, BYVAL AS const gchar /'const char'/ PTR) AS gboolean
DECLARE SUB jsc_value_object_set_property(BYVAL AS JSCValue PTR, BYVAL AS const gchar /'const char'/ PTR, BYVAL AS JSCValue PTR)
DECLARE SUB jsc_value_object_set_property_at_index(BYVAL AS JSCValue PTR, BYVAL AS guint, BYVAL AS JSCValue PTR)
DECLARE FUNCTION jsc_value_to_boolean(BYVAL AS JSCValue PTR) AS gboolean
DECLARE FUNCTION jsc_value_to_double(BYVAL AS JSCValue PTR) AS double
DECLARE FUNCTION jsc_value_to_int32(BYVAL AS JSCValue PTR) AS gint32
DECLARE FUNCTION jsc_value_to_json(BYVAL AS JSCValue PTR, BYVAL AS guint) AS char PTR
DECLARE FUNCTION jsc_value_to_string(BYVAL AS JSCValue PTR) AS char PTR
DECLARE FUNCTION jsc_value_to_string_as_bytes(BYVAL AS JSCValue PTR) AS GBytes PTR
TYPE _JSCValueClass
  AS GObjectClass parent_class
  _jsc_reserved0 AS SUB CDECL()
  _jsc_reserved1 AS SUB CDECL()
  _jsc_reserved2 AS SUB CDECL()
  _jsc_reserved3 AS SUB CDECL()
END TYPE
TYPE _JSCVirtualMachine
  AS GObject parent
  AS JSCVirtualMachinePrivate PTR priv
END TYPE
DECLARE FUNCTION jsc_virtual_machine_get_type() AS GType
#DEFINE JAVASCRIPTCORE_TYPE_VIRTUAL_MACHINE (jsc_virtual_machine_get_type())
#DEFINE JAVASCRIPTCORE_VIRTUAL_MACHINE(obj) (G_TYPE_CHECK_INSTANCE_CAST((obj), JAVASCRIPTCORE_TYPE_VIRTUAL_MACHINE, JSCVirtualMachine))
#DEFINE JAVASCRIPTCORE_VIRTUAL_MACHINE_CLASS(obj) (G_TYPE_CHECK_CLASS_CAST((obj), JAVASCRIPTCORE_TYPE_VIRTUAL_MACHINE, JavaScriptCoreVirtualMachineClass))
#DEFINE JAVASCRIPTCORE_IS_VIRTUAL_MACHINE(obj) (G_TYPE_CHECK_INSTANCE_TYPE((obj), JAVASCRIPTCORE_TYPE_VIRTUAL_MACHINE))
#DEFINE JAVASCRIPTCORE_IS_CLASS_VIRTUAL_MACHINE(obj) (G_TYPE_CHECK_CLASS_TYPE((obj), JAVASCRIPTCORE_TYPE_VIRTUAL_MACHINE))
#DEFINE JAVASCRIPTCORE_VIRTUAL_MACHINE_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS((obj), JAVASCRIPTCORE_TYPE_VIRTUAL_MACHINE, JavaScriptCoreVirtualMachineClass))
DECLARE FUNCTION jsc_virtual_machine_new() AS JSCVirtualMachine PTR
TYPE _JSCVirtualMachineClass
  AS GObjectClass parent_class
  _jsc_reserved0 AS SUB CDECL()
  _jsc_reserved1 AS SUB CDECL()
  _jsc_reserved2 AS SUB CDECL()
  _jsc_reserved3 AS SUB CDECL()
END TYPE
TYPE _JSCWeakValue
  AS GObject parent
  AS JSCWeakValuePrivate PTR priv
END TYPE
DECLARE FUNCTION jsc_weak_value_get_type() AS GType
#DEFINE JAVASCRIPTCORE_TYPE_WEAK_VALUE (jsc_weak_value_get_type())
#DEFINE JAVASCRIPTCORE_WEAK_VALUE(obj) (G_TYPE_CHECK_INSTANCE_CAST((obj), JAVASCRIPTCORE_TYPE_WEAK_VALUE, JSCWeakValue))
#DEFINE JAVASCRIPTCORE_WEAK_VALUE_CLASS(obj) (G_TYPE_CHECK_CLASS_CAST((obj), JAVASCRIPTCORE_TYPE_WEAK_VALUE, JavaScriptCoreWeakValueClass))
#DEFINE JAVASCRIPTCORE_IS_WEAK_VALUE(obj) (G_TYPE_CHECK_INSTANCE_TYPE((obj), JAVASCRIPTCORE_TYPE_WEAK_VALUE))
#DEFINE JAVASCRIPTCORE_IS_CLASS_WEAK_VALUE(obj) (G_TYPE_CHECK_CLASS_TYPE((obj), JAVASCRIPTCORE_TYPE_WEAK_VALUE))
#DEFINE JAVASCRIPTCORE_WEAK_VALUE_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS((obj), JAVASCRIPTCORE_TYPE_WEAK_VALUE, JavaScriptCoreWeakValueClass))
DECLARE FUNCTION jsc_weak_value_new(BYVAL AS JSCValue PTR) AS JSCWeakValue PTR
DECLARE FUNCTION jsc_weak_value_get_value(BYVAL AS JSCWeakValue PTR) AS JSCValue PTR
TYPE _JSCWeakValueClass
  AS GObjectClass parent_class
  _jsc_reserved0 AS SUB CDECL()
  _jsc_reserved1 AS SUB CDECL()
  _jsc_reserved2 AS SUB CDECL()
  _jsc_reserved3 AS SUB CDECL()
END TYPE
' P_4

DECLARE FUNCTION jsc_get_major_version() AS guint
DECLARE FUNCTION jsc_get_micro_version() AS guint
DECLARE FUNCTION jsc_get_minor_version() AS guint
DECLARE SUB jsc_options_foreach(BYVAL AS JSCOptionsFunc, BYVAL AS gpointer)
DECLARE FUNCTION jsc_options_get_boolean(BYVAL AS const gchar /'const char'/ PTR, BYVAL AS gboolean PTR) AS gboolean
DECLARE FUNCTION jsc_options_get_double(BYVAL AS const gchar /'const char'/ PTR, BYVAL AS gdouble PTR) AS gboolean
DECLARE FUNCTION jsc_options_get_int(BYVAL AS const gchar /'const char'/ PTR, BYVAL AS gint PTR) AS gboolean
DECLARE FUNCTION jsc_options_get_option_group() AS GOptionGroup PTR
DECLARE FUNCTION jsc_options_get_range_string(BYVAL AS const gchar /'const char'/ PTR, BYVAL AS char PTR PTR) AS gboolean
DECLARE FUNCTION jsc_options_get_size(BYVAL AS const gchar /'const char'/ PTR, BYVAL AS gsize PTR) AS gboolean
DECLARE FUNCTION jsc_options_get_string(BYVAL AS const gchar /'const char'/ PTR, BYVAL AS char PTR PTR) AS gboolean
DECLARE FUNCTION jsc_options_get_uint(BYVAL AS const gchar /'const char'/ PTR, BYVAL AS guint PTR) AS gboolean
DECLARE FUNCTION jsc_options_set_boolean(BYVAL AS const gchar /'const char'/ PTR, BYVAL AS gboolean) AS gboolean
DECLARE FUNCTION jsc_options_set_double(BYVAL AS const gchar /'const char'/ PTR, BYVAL AS gdouble) AS gboolean
DECLARE FUNCTION jsc_options_set_int(BYVAL AS const gchar /'const char'/ PTR, BYVAL AS gint) AS gboolean
DECLARE FUNCTION jsc_options_set_range_string(BYVAL AS const gchar /'const char'/ PTR, BYVAL AS const gchar /'const char'/ PTR) AS gboolean
DECLARE FUNCTION jsc_options_set_size(BYVAL AS const gchar /'const char'/ PTR, BYVAL AS gsize) AS gboolean
DECLARE FUNCTION jsc_options_set_string(BYVAL AS const gchar /'const char'/ PTR, BYVAL AS const gchar /'const char'/ PTR) AS gboolean
DECLARE FUNCTION jsc_options_set_uint(BYVAL AS const gchar /'const char'/ PTR, BYVAL AS guint) AS gboolean
END EXTERN

