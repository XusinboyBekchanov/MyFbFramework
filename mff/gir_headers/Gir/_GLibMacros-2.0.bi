'       FreeBasic header file, manual-generated file
' containing additional code-generating macros for GLib-2.0
' LGPLv2.1 (C) 2014-2022 by Thomas[ dot }Freiherr[ at ]gmx[ dot }net

'#IFNDEF G_DISABLE_DEPRECATED
'#DEFINE G_GNUC_FUNCTION __FUNCTION__
'#DEFINE G_GNUC_PRETTY_FUNCTION __FUNCTION__
'#ENDIF ' G_DISABLE_DEPRECATED

#DEFINE G_STRINGIFY(macro_or_string) G_STRINGIFY_ARG (macro_or_string)
#DEFINE G_STRINGIFY_ARG(contents) #contents

#DEFINE G_PASTE_ARGS(identifier1,identifier2) identifier1 ## identifier2
#DEFINE G_PASTE(identifier1,identifier2) G_PASTE_ARGS (identifier1, identifier2)

#MACRO G_STATIC_ASSERT(expr)
 #IF NOT (expr)
  #PRINT ##__LINE__: Compile_Time_Assertion_failed ##expr
 #ENDIF
 #IFDEF __counter__
  #PRINT "Compile_Time_Assertion: __counter__ not availabe!"
 #ENDIF
#ENDMACRO

#DEFINE G_STATIC_ASSERT_EXPR(expr) #ERROR "G_STATIC_ASSERT_EXPR(expr) not implemented"

#DEFINE G_STRLOC __FILE__ & ":" & G_STRINGIFY (__LINE__) & ":" & __FUNCTION__ & "()"

#DEFINE G_STRFUNC (CAST(CONST ZSTRING PTR, SADD(__FUNCTION__)))

#IFNDEF NULL
#DEFINE NULL (CAST(ANY PTR, 0))
#ENDIF ' NULL

#IFNDEF FALSE
#DEFINE FALSE (0)
#ENDIF ' FALSE

#IFNDEF TRUE
'#DEFINE TRUE ( 0 = FALSE)
#DEFINE TRUE (1)
#ENDIF ' TRUE

#UNDEF MAX
#DEFINE MAX(a, b) IIF(((a) > (b)) , (a) , (b))
#UNDEF MIN
#DEFINE MIN(a, b) IIF(((a) < (b)) , (a) , (b))
'#UNDEF ABS
'#DEFINE ABS_(a) IIF(((a) < 0) , -(a) , (a))
#UNDEF CLAMP
#DEFINE CLAMP(x, low, high) IIF(((x) > (high)) , (high) , IIF(((x) < (low)) , (low) , (x)))
#DEFINE G_N_ELEMENTS(arr) (UBOUND(arr) - LBOUND(arr) + 1)
#DEFINE GPOINTER_TO_SIZE(p) (CAST(gsize, p))
#DEFINE GSIZE_TO_POINTER(s) (CAST(gpointer, CAST(gsize, s)))
#DEFINE GINT_TO_POINTER(_V_) CAST(gpointer, CAST(glong, _V_))
#DEFINE GPOINTER_TO_INT(_V_) CAST(gint, CAST(glong, _V_))
#DEFINE GUINT_TO_POINTER(_V_) CAST(gpointer, CAST(gulong, _V_))
#DEFINE GPOINTER_TO_UINT(_V_) CAST(guint, CAST(gulong, _V_))

#DEFINE G_STRUCT_OFFSET(struct_type, member) _
      (CAST(glong, OFFSETOF (struct_type, member)))

#DEFINE G_STRUCT_MEMBER_P(struct_p, struct_offset) _
    (CAST(gpointer, CAST(guint8 PTR, struct_p + CAST(glong, struct_offset))))
#DEFINE G_STRUCT_MEMBER(member_type, struct_p, struct_offset) _
    (*CAST(member_type PTR, G_STRUCT_MEMBER_P ((struct_p), (struct_offset))))

#IF NOT (DEFINED (G_STMT_START) AND DEFINED (G_STMT_END))
#DEFINE G_STMT_START DO
#DEFINE G_STMT_END LOOP
#ENDIF ' NOT (DEFINED (G...

'/* Deprecated -- do not use. */
#IFNDEF G_DISABLE_DEPRECATED
#IFDEF G_DISABLE_CONST_RETURNS
#DEFINE G_CONST_RETURN
#ELSE ' G_DISABLE_CONST_RETURNS
#DEFINE G_CONST_RETURN CONST
#ENDIF ' G_DISABLE_CONST_RETURNS
#ENDIF ' G_DISABLE_DEPRECATED

#DEFINE G_LIKELY(expr) (expr)
#DEFINE G_UNLIKELY(expr) (expr)

#DEFINE G_ENCODE_VERSION(major,minor) ((major) SHL 16 OR (minor) SHL 8)
#DEFINE GLIB_VERSION_2_26 (G_ENCODE_VERSION (2, 26))
#DEFINE GLIB_VERSION_2_28 (G_ENCODE_VERSION (2, 28))
#DEFINE GLIB_VERSION_2_30 (G_ENCODE_VERSION (2, 30))
#DEFINE GLIB_VERSION_2_32 (G_ENCODE_VERSION (2, 32))

#DEFINE G_LITTLE_ENDIAN 1234
#DEFINE G_BIG_ENDIAN 4321
#DEFINE G_PDP_ENDIAN 3412
#DEFINE GUINT16_SWAP_LE_BE_CONSTANT(val) (CAST(guint16, ( _
    CAST(guint16, (CAST(guint16, val) SHR 8)) OR _
    CAST(guint16, (CAST(guint16, val) SHL 8)))))
#DEFINE GUINT32_SWAP_LE_BE_CONSTANT(val) (CAST(guint32, ( _
    ((CAST(guint32, val) AND CAST(guint32, &h000000FFU)) SHL 24) OR _
    ((CAST(guint32, val) AND CAST(guint32, &h0000FF00U)) SHL 8) OR _
    ((CAST(guint32, val) AND CAST(guint32, &h00FF0000U)) SHR 8) OR _
    ((CAST(guint32, val) AND CAST(guint32, &hFF000000U)) SHR 24))))
#DEFINE GUINT64_SWAP_LE_BE_CONSTANT(val) (CAST(guint64, ( _
      ((CAST(guint64, val) AND CAST(guint64, G_GINT64_CONSTANT (&h00000000000000FFU))) SHL 56) OR _
      ((CAST(guint64, val) AND CAST(guint64, G_GINT64_CONSTANT (&h000000000000FF00U))) SHL 40) OR _
      ((CAST(guint64, val) AND CAST(guint64, G_GINT64_CONSTANT (&h0000000000FF0000U))) SHL 24) OR _
      ((CAST(guint64, val) AND CAST(guint64, G_GINT64_CONSTANT (&h00000000FF000000U))) SHL 8) OR _
      ((CAST(guint64, val) AND CAST(guint64, G_GINT64_CONSTANT (&h000000FF00000000U))) SHR 8) OR _
      ((CAST(guint64, val) AND CAST(guint64, G_GINT64_CONSTANT (&h0000FF0000000000U))) SHR 24) OR _
      ((CAST(guint64, val) AND CAST(guint64, G_GINT64_CONSTANT (&h00FF000000000000U))) SHR 40) OR _
      ((CAST(guint64, val) AND CAST(guint64, G_GINT64_CONSTANT (&hFF00000000000000U))) SHR 56))))
#DEFINE GUINT16_SWAP_LE_BE(val) (GUINT16_SWAP_LE_BE_CONSTANT (val))
#DEFINE GUINT32_SWAP_LE_BE(val) (GUINT32_SWAP_LE_BE_CONSTANT (val))
#DEFINE GUINT64_SWAP_LE_BE(val) (GUINT64_SWAP_LE_BE_CONSTANT (val))

#DEFINE GUINT16_SWAP_LE_PDP(val) (CAST(guint16, (val)))
#DEFINE GUINT16_SWAP_BE_PDP(val) (GUINT16_SWAP_LE_BE (val))
#DEFINE GUINT32_SWAP_LE_PDP(val) (CAST(guint32, ( _
    ((CAST(guint32, val) AND CAST(guint32, &h0000FFFFU)) SHL 16) OR _
    ((CAST(guint32, val) AND CAST(guint32, &hFFFF0000U)) SHR 16))))
#DEFINE GUINT32_SWAP_BE_PDP(val) (CAST(guint32, ( _
    ((CAST(guint32, val) AND CAST(guint32, &h00FF00FFU)) SHL 8) OR _
    ((CAST(guint32, val) AND CAST(guint32, &hFF00FF00U)) SHR 8))))

#DEFINE GINT16_FROM_LE(val) (GINT16_TO_LE (val))
#DEFINE GUINT16_FROM_LE(val) (GUINT16_TO_LE (val))
#DEFINE GINT16_FROM_BE(val) (GINT16_TO_BE (val))
#DEFINE GUINT16_FROM_BE(val) (GUINT16_TO_BE (val))
#DEFINE GINT32_FROM_LE(val) (GINT32_TO_LE (val))
#DEFINE GUINT32_FROM_LE(val) (GUINT32_TO_LE (val))
#DEFINE GINT32_FROM_BE(val) (GINT32_TO_BE (val))
#DEFINE GUINT32_FROM_BE(val) (GUINT32_TO_BE (val))
#DEFINE GINT64_FROM_LE(val) (GINT64_TO_LE (val))
#DEFINE GUINT64_FROM_LE(val) (GUINT64_TO_LE (val))
#DEFINE GINT64_FROM_BE(val) (GINT64_TO_BE (val))
#DEFINE GUINT64_FROM_BE(val) (GUINT64_TO_BE (val))
#DEFINE GLONG_FROM_LE(val) (GLONG_TO_LE (val))
#DEFINE GULONG_FROM_LE(val) (GULONG_TO_LE (val))
#DEFINE GLONG_FROM_BE(val) (GLONG_TO_BE (val))
#DEFINE GULONG_FROM_BE(val) (GULONG_TO_BE (val))
#DEFINE GINT_FROM_LE(val) (GINT_TO_LE (val))
#DEFINE GUINT_FROM_LE(val) (GUINT_TO_LE (val))
#DEFINE GINT_FROM_BE(val) (GINT_TO_BE (val))
#DEFINE GUINT_FROM_BE(val) (GUINT_TO_BE (val))
#DEFINE GSIZE_FROM_LE(val) (GSIZE_TO_LE (val))
#DEFINE GSSIZE_FROM_LE(val) (GSSIZE_TO_LE (val))
#DEFINE GSIZE_FROM_BE(val) (GSIZE_TO_BE (val))
#DEFINE GSSIZE_FROM_BE(val) (GSSIZE_TO_BE (val))
#DEFINE g_ntohl(val) (GUINT32_FROM_BE (val))
#DEFINE g_ntohs(val) (GUINT16_FROM_BE (val))
#DEFINE g_htonl(val) (GUINT32_TO_BE (val))
#DEFINE g_htons(val) (GUINT16_TO_BE (val))

#IFDEF __GNUC__
#UNDEF alloca
#DEFINE alloca(size) __builtin_alloca (size)
#ELSEIF DEFINED (GLIB_HAVE_ALLOCA_H)

' file not found: alloca.h

#ELSE ' __GNUC__
#IF DEFINED(_MSC_VER) OR DEFINED(__DMC__)
#INCLUDE ONCE "crt/malloc.bi" '__HEADERS__: malloc.h
#DEFINE alloca _alloca
#ELSE ' DEFINED(_MSC_VE...
#IFDEF _AIX

' #pragma allocac ???

#ELSE ' _AIX
#IFNDEF alloca
DECLARE FUNCTION alloca() AS ZSTRING PTR
#ENDIF ' alloca
#ENDIF ' _AIX
#ENDIF ' DEFINED(_MSC_VE...
#ENDIF ' __GNUC__

#DEFINE g_alloca(size) alloca (size)

#DEFINE g_array_append_val(a,v) g_array_append_vals (a, @(v), 1)
#DEFINE g_array_prepend_val(a,v) g_array_prepend_vals (a, @(v), 1)
#DEFINE g_array_insert_val(a,i,v) g_array_insert_vals (a, i, @(v), 1)
#DEFINE g_array_index(a,t,i) ((CAST(t PTR, CAST(ANY PTR, (a)))->data) [(i)])

#DEFINE g_ptr_array_index(array,index_) ((array)->pdata)[index_]

'#DEFINE g_atomic_int_get(atomic) _
  '(g_atomic_int_get_ (CAST(gint PTR, (atomic))))
'#DEFINE g_atomic_int_set(atomic, newval) _
  '(g_atomic_int_set_ (CAST(gint PTR, (atomic)), CAST(gint, (newval))))
'#DEFINE g_atomic_int_compare_and_exchange(atomic, oldval, newval) _
  '(g_atomic_int_compare_and_exchange_ (CAST(gint PTR, (atomic)), (oldval), (newval)))
'#DEFINE g_atomic_int_add(atomic, val) _
  '(g_atomic_int_add_ (CAST(gint PTR, (atomic)), (val)))
'#DEFINE g_atomic_int_and(atomic, val) _
  '(g_atomic_int_and_ (CAST(guint PTR, (atomic)), (val)))
'#DEFINE g_atomic_int_or(atomic, val) _
  '(g_atomic_int_or_ (CAST(guint PTR, (atomic)), (val)))
'#DEFINE g_atomic_int_xor(atomic, val) _
  '(g_atomic_int_xor_ (CAST(guint PTR, (atomic)), (val)))
'#DEFINE g_atomic_int_inc(atomic) _
  '(g_atomic_int_inc_ (CAST(gint PTR, (atomic))))
'#DEFINE g_atomic_int_dec_and_test(atomic) _
  '(g_atomic_int_dec_and_test_ (CAST(gint PTR, (atomic))))
'#DEFINE g_atomic_pointer_get(atomic) _
  '(g_atomic_pointer_get_ (atomic))
'#DEFINE g_atomic_pointer_set(atomic, newval) _
  '(g_atomic_pointer_set_ ((atomic), CAST(gpointer, (newval))))
'#DEFINE g_atomic_pointer_compare_and_exchange(atomic, oldval, newval) _
  '(g_atomic_pointer_compare_and_exchange_ ((atomic), CAST(gpointer, (oldval)), CAST(gpointer, (newval))))
'#DEFINE g_atomic_pointer_add(atomic, val) _
  '(g_atomic_pointer_add_ ((atomic), CAST(gssize, (val))))
'#DEFINE g_atomic_pointer_and(atomic, val) _
  '(g_atomic_pointer_and_ ((atomic), CAST(gsize, (val))))
'#DEFINE g_atomic_pointer_or(atomic, val) _
  '(g_atomic_pointer_or_ ((atomic), CAST(gsize, (val))))
'#DEFINE g_atomic_pointer_xor(atomic, val) _
  '(g_atomic_pointer_xor_ ((atomic), CAST(gsize, (val))))

#DEFINE G_THREAD_ERROR g_thread_error_quark ()

#DEFINE G_PRIVATE_INIT(notify) TYPE<GPrivate>( NULL, (notify), { NULL, NULL } )

#DEFINE G_ONCE_INIT TYPE<GOnce>( G_ONCE_STATUS_NOTCALLED, NULL )

#DEFINE G_LOCK_NAME(name) g__ ## name ## _lock
#DEFINE G_LOCK_DEFINE_STATIC(name) static G_LOCK_DEFINE (name)
#DEFINE G_LOCK_DEFINE(name) GMutex G_LOCK_NAME (name)
#DEFINE G_LOCK_EXTERN(name) extern GMutex G_LOCK_NAME (name)

#IFDEF G_DEBUG_LOCKS
#DEFINE G_LOCK(name) _
  g_log (G_LOG_DOMAIN, G_LOG_LEVEL_DEBUG, !"file %s: line %d (%s): locking: %s ", __FILE__, __LINE__, G_STRFUNC, #name) : _
  g_static_mutex_lock (@G_LOCK_NAME (name))
#DEFINE G_UNLOCK(name) _
  g_log (G_LOG_DOMAIN, G_LOG_LEVEL_DEBUG, !"file %s: line %d (%s): unlocking: %s ", __FILE__, __LINE__, G_STRFUNC, #name) : _
  g_static_mutex_unlock (@G_LOCK_NAME (name))
#DEFINE G_TRYLOCK(name) _
  g_log (G_LOG_DOMAIN, G_LOG_LEVEL_DEBUG, !"file %s: line %d (%s): try locking: %s ", __FILE__, __LINE__, G_STRFUNC, #name) : _
  g_static_mutex_trylock (@G_LOCK_NAME (name)))
#ELSE ' G_DEBUG_LOCKS
#DEFINE G_LOCK(name) g_static_mutex_lock (@G_LOCK_NAME (name))
#DEFINE G_UNLOCK(name) g_static_mutex_unlock (@G_LOCK_NAME (name))
#DEFINE G_TRYLOCK(name) g_static_mutex_trylock (@G_LOCK_NAME (name))
#ENDIF ' G_DEBUG_LOCKS

#IFDEF G_ATOMIC_OP_MEMORY_BARRIER_NEEDED
#DEFINE g_once(once, func, arg) g_once_impl ((once), (func), (arg))
#ELSE ' G_ATOMIC_OP_MEMORY_BARRIER_NEEDED
#DEFINE g_once(once, func, arg) _
  IIF(((once)->status = G_ONCE_STATUS_READY) , _
   (once)->retval , _
   g_once_impl ((once), (func), (arg)))
#ENDIF ' G_ATOMIC_OP_MEMORY_BARRIER_NEEDED

'#DEFINE g_once_init_enter(location) g_once_init_enter_((location))
'#DEFINE g_once_init_leave(location, result) g_once_init_leave_((location), CAST(gsize, (result)))

#DEFINE G_BREAKPOINT() ASM int 3

#DEFINE G_BOOKMARK_FILE_ERROR (g_bookmark_file_error_quark ())

#DEFINE G_CONVERT_ERROR g_convert_error_quark()

#IFNDEF __GTK_DOC_IGNORE__
#IFDEF G_OS_WIN32
#DEFINE g_filename_to_utf8 g_filename_to_utf8_utf8
#DEFINE g_filename_from_utf8 g_filename_from_utf8_utf8
#DEFINE g_filename_from_uri g_filename_from_uri_utf8
#DEFINE g_filename_to_uri g_filename_to_uri_utf8
#ENDIF ' G_OS_WIN32
#ENDIF ' __GTK_DOC_IGNORE__

'#DEFINE G_DATALIST_FLAGS_MASK &h3

#DEFINE g_datalist_id_set_data(dl, q, d) _
     g_datalist_id_set_data_full ((dl), (q), (d), NULL)
#DEFINE g_datalist_id_remove_data(dl, q) _
     g_datalist_id_set_data ((dl), (q), NULL)
#DEFINE g_datalist_set_data_full(dl, k, d, f) _
     g_datalist_id_set_data_full ((dl), g_quark_from_string (k), (d), (f))
#DEFINE g_datalist_remove_no_notify(dl, k) _
     g_datalist_id_remove_no_notify ((dl), g_quark_try_string (k))
#DEFINE g_datalist_set_data(dl, k, d) _
     g_datalist_set_data_full ((dl), (k), (d), NULL)
#DEFINE g_datalist_remove_data(dl, k) _
     g_datalist_id_set_data ((dl), g_quark_try_string (k), NULL)

#DEFINE g_dataset_id_set_data(l, k, d) _
     g_dataset_id_set_data_full ((l), (k), (d), NULL)
#DEFINE g_dataset_id_remove_data(l, k) _
     g_dataset_id_set_data ((l), (k), NULL)
#DEFINE g_dataset_get_data(l, k) _
     (g_dataset_id_get_data ((l), g_quark_try_string (k)))
#DEFINE g_dataset_set_data_full(l, k, d, f) _
     g_dataset_id_set_data_full ((l), g_quark_from_string (k), (d), (f))
#DEFINE g_dataset_remove_no_notify(l, k) _
     g_dataset_id_remove_no_notify ((l), g_quark_try_string (k))
#DEFINE g_dataset_set_data(l, k, d) _
     g_dataset_set_data_full ((l), (k), (d), NULL)
#DEFINE g_dataset_remove_data(l, k) _
     g_dataset_id_set_data ((l), g_quark_try_string (k), NULL)

'#DEFINE G_DATE_BAD_JULIAN 0U
'#DEFINE G_DATE_BAD_DAY 0U
'#DEFINE G_DATE_BAD_YEAR 0U

#IFNDEF G_DISABLE_DEPRECATED
#DEFINE g_date_weekday g_date_get_weekday
'#DEFINE g_date_month g_date_get_month
'#DEFINE g_date_year g_date_get_year
'#DEFINE g_date_day g_date_get_day
#DEFINE g_date_julian g_date_get_julian
#DEFINE g_date_day_of_year g_date_get_day_of_year
#DEFINE g_date_monday_week_of_year g_date_get_monday_week_of_year
#DEFINE g_date_sunday_week_of_year g_date_get_sunday_week_of_year
#DEFINE g_date_days_in_month g_date_get_days_in_month
#DEFINE g_date_monday_weeks_in_year g_date_get_monday_weeks_in_year
#DEFINE g_date_sunday_weeks_in_year g_date_get_sunday_weeks_in_year
#ENDIF ' G_DISABLE_DEPRECATED

'#DEFINE G_TIME_SPAN_DAY (G_GINT64_CONSTANT (86400000000))
'#DEFINE G_TIME_SPAN_HOUR (G_GINT64_CONSTANT (3600000000))
'#DEFINE G_TIME_SPAN_MINUTE (G_GINT64_CONSTANT (60000000))
'#DEFINE G_TIME_SPAN_SECOND (G_GINT64_CONSTANT (1000000))
'#DEFINE G_TIME_SPAN_MILLISECOND (G_GINT64_CONSTANT (1000))

#IFNDEF __GTK_DOC_IGNORE__
#IFDEF G_OS_WIN32
#DEFINE g_dir_open g_dir_open_utf8
#DEFINE g_dir_read_name g_dir_read_name_utf8
#ENDIF ' G_OS_WIN32
#ENDIF ' __GTK_DOC_IGNORE__

#IFNDEF __GTK_DOC_IGNORE__
#IFDEF G_OS_WIN32
#DEFINE g_getenv g_getenv_utf8
#DEFINE g_setenv g_setenv_utf8
#DEFINE g_unsetenv g_unsetenv_utf8
#ENDIF ' G_OS_WIN32
#ENDIF ' __GTK_DOC_IGNORE__

#DEFINE G_FILE_ERROR g_file_error_quark ()

#IFNDEF __GTK_DOC_IGNORE__
#IFDEF G_OS_WIN32
#DEFINE g_file_test g_file_test_utf8
#DEFINE g_file_get_contents g_file_get_contents_utf8
#DEFINE g_mkstemp g_mkstemp_utf8
#DEFINE g_file_open_tmp g_file_open_tmp_utf8
#ENDIF ' G_OS_WIN32
#ENDIF ' __GTK_DOC_IGNORE__

'#IFDEF G_OS_WIN32
'#DEFINE G_DIR_SEPARATOR ASC(@!"\\")
'#DEFINE G_DIR_SEPARATOR_S @!"\\"
'#DEFINE G_IS_DIR_SEPARATOR(c) ((c) = G_DIR_SEPARATOR ORELSE (c) = ASC(@!"/"))
'#DEFINE G_SEARCHPATH_SEPARATOR ASC(@!";")
'#DEFINE G_SEARCHPATH_SEPARATOR_S @!";"
'#ELSE ' G_OS_WIN32
'#DEFINE G_DIR_SEPARATOR ASC(@!"/")
'#DEFINE G_DIR_SEPARATOR_S @!"/"
'#DEFINE G_IS_DIR_SEPARATOR(c) ((c) = G_DIR_SEPARATOR)
'#DEFINE G_SEARCHPATH_SEPARATOR ASC(@!":")
'#DEFINE G_SEARCHPATH_SEPARATOR_S @!":"
'#ENDIF ' G_OS_WIN32

#IFNDEF G_DISABLE_DEPRECATED
#DEFINE g_dirname g_path_get_dirname
#ENDIF ' G_DISABLE_DEPRECATED

#IFNDEF __GTK_DOC_IGNORE__
#IFDEF G_OS_WIN32
#DEFINE g_get_current_dir g_get_current_dir_utf8
#ENDIF ' G_OS_WIN32
#ENDIF ' __GTK_DOC_IGNORE__

#IF GLIB_SIZEOF_VOID_P > GLIB_SIZEOF_LONG
#DEFINE G_MEM_ALIGN GLIB_SIZEOF_VOID_P
#ELSE ' GLIB_SIZEOF_VOI...
#DEFINE G_MEM_ALIGN GLIB_SIZEOF_LONG
#ENDIF ' GLIB_SIZEOF_VOI...

#DEFINE _G_NEW(struct_type, n_structs, func) _
        (CAST(struct_type PTR, g_##func##_n ((n_structs), SIZEOF (struct_type))))
#DEFINE _G_RENEW(struct_type, mem, n_structs, func) _
        (CAST(struct_type PTR, g_##func##_n (mem, (n_structs), SIZEOF (struct_type))))

#DEFINE g_new(struct_type, n_structs) _G_NEW (struct_type, n_structs, malloc)
#DEFINE g_new0(struct_type, n_structs) _G_NEW (struct_type, n_structs, malloc0)
#DEFINE g_renew(struct_type, mem, n_structs) _G_RENEW (struct_type, mem, n_structs, realloc)
#DEFINE g_try_new(struct_type, n_structs) _G_NEW (struct_type, n_structs, try_malloc)
#DEFINE g_try_new0(struct_type, n_structs) _G_NEW (struct_type, n_structs, try_malloc0)
#DEFINE g_try_renew(struct_type, mem, n_structs) _G_RENEW (struct_type, mem, n_structs, try_realloc)

#DEFINE g_list_free1 g_list_free_1

#DEFINE g_list_previous(list) IIF((list) , ((CAST(GList PTR, (list)))->prev) , NULL)
#DEFINE g_list_next(list) IIF((list) , ((CAST(GList PTR, (list)))->next) , NULL)

#IFNDEF G_DISABLE_DEPRECATED
#DEFINE g_hash_table_freeze(hash_table) (CAST(ANY, 0))
#DEFINE g_hash_table_thaw(hash_table) (CAST(ANY, 0))
#ENDIF ' G_DISABLE_DEPRECATED

'#DEFINE G_HOOK_FLAG_USER_SHIFT (4)

#DEFINE G_HOOK(hook) (CAST(GHook PTR, (hook)))
#DEFINE G_HOOK_FLAGS(hook) (G_HOOK (hook)->flags)
#DEFINE G_HOOK_ACTIVE(hook) ((G_HOOK_FLAGS (hook) AND _
       G_HOOK_FLAG_ACTIVE) <> 0)
#DEFINE G_HOOK_IN_CALL(hook) ((G_HOOK_FLAGS (hook) AND _
       G_HOOK_FLAG_IN_CALL) <> 0)
#DEFINE G_HOOK_IS_VALID(hook) (G_HOOK (hook)->hook_id <> 0 ANDALSO _
      (G_HOOK_FLAGS (hook) AND G_HOOK_FLAG_ACTIVE))
#DEFINE G_HOOK_IS_UNLINKED(hook) (G_HOOK (hook)->next = NULL ANDALSO _
      G_HOOK (hook)->prev = NULL ANDALSO _
      G_HOOK (hook)->hook_id = 0 ANDALSO _
      G_HOOK (hook)->ref_count = 0)

#DEFINE g_hook_append( hook_list, hook ) _
     g_hook_insert_before ((hook_list), NULL, (hook))

'#IFDEF G_OS_WIN32
'#IF GLIB_SIZEOF_VOID_P = 8
'#DEFINE G_POLLFD_FORMAT @!"%#I64x"
'#ELSE ' GLIB_SIZEOF_VOI...
'#DEFINE G_POLLFD_FORMAT @!"%#x"
'#ENDIF ' GLIB_SIZEOF_VOI...
'#ELSE ' G_OS_WIN32
'#DEFINE G_POLLFD_FORMAT @!"%d"
'#ENDIF ' G_OS_WIN32

#DEFINE g_slist_free1 g_slist_free_1

#DEFINE g_slist_next(slist) IIF((slist) , ((CAST(GSList PTR, (slist)))->next) , NULL)

#DEFINE G_PRIORITY_HIGH -100
#DEFINE G_PRIORITY_DEFAULT 0
#DEFINE G_PRIORITY_HIGH_IDLE 100
#DEFINE G_PRIORITY_DEFAULT_IDLE 200
#DEFINE G_PRIORITY_LOW 300
'#DEFINE G_SOURCE_REMOVE FALSE
'#DEFINE G_SOURCE_CONTINUE TRUE

#IFNDEF G_DISABLE_DEPRECATED
#DEFINE G_UNICODE_COMBINING_MARK G_UNICODE_SPACING_MARK
#ENDIF ' G_DISABLE_DEPRECATED

#DEFINE G_UNICHAR_MAX_DECOMPOSITION_LENGTH 18

' #define g_utf8_next_char(p) (char *)((p) + g_utf8_skip[*(const guchar *)(p)])
#DEFINE g_utf8_next_char(p) CAST(ZSTRING PTR, (CAST(p, + g_utf8_skip[*CAST(CONST guchar PTR, (p))]))) '??? unsave CAST

#IF NOT DEFINED (G_VA_COPY)
#IF DEFINED (__GNUC__) AND DEFINED (__PPC__) AND (DEFINED (_CALL_SYSV) OR DEFINED (_WIN32))
#DEFINE G_VA_COPY(ap1, ap2) (*(ap1) = *(ap2))
#ELSEIF DEFINED (G_VA_COPY_AS_ARRAY)
#DEFINE G_VA_COPY(ap1, ap2) g_memmove ((ap1), (ap2), SIZEOF (va_list))
#ELSE ' DEFINED (__GNUC...
#DEFINE G_VA_COPY(ap1, ap2) ((ap1) = (ap2))
#ENDIF ' DEFINED (__GNUC...
#ENDIF ' NOT DEFINED (G_...

#IFNDEF __GTK_DOC_IGNORE__
#IFDEF G_OS_WIN32
#DEFINE g_get_user_name g_get_user_name_utf8
#DEFINE g_get_real_name g_get_real_name_utf8
#DEFINE g_get_home_dir g_get_home_dir_utf8
#DEFINE g_get_tmp_dir g_get_tmp_dir_utf8
#ENDIF ' G_OS_WIN32
#ENDIF ' __GTK_DOC_IGNORE__

#IF DEFINED (G_OS_WIN32) AND DEFINED (G_CAN_INLINE) AND NOT DEFINED (__cplusplus)
#DEFINE g_get_system_data_dirs _g_win32_get_system_data_dirs
#ENDIF ' DEFINED (G_OS_W...

#IFNDEF G_DISABLE_DEPRECATED
#IFNDEF ATEXIT
#DEFINE ATEXIT(proc) g_ATEXIT(proc)
#ELSE ' ATEXIT
#DEFINE G_NATIVE_ATEXIT
#ENDIF ' ATEXIT
#IFDEF G_OS_WIN32
#DEFINE g_atexit(func) atexit(func)
#ENDIF ' G_OS_WIN32
#ENDIF ' G_DISABLE_DEPRECATED

#IFNDEF __GTK_DOC_IGNORE__
#IFDEF G_OS_WIN32
#DEFINE g_find_program_in_path g_find_program_in_path_utf8
#ENDIF ' G_OS_WIN32
#ENDIF ' __GTK_DOC_IGNORE__

#IFNDEF G_DISABLE_DEPRECATED
#IFNDEF G_PLATFORM_WIN32
#DEFINE G_WIN32_DLLMAIN_FOR_DLL_NAME(static, dll_name)
#ELSE ' G_PLATFORM_WIN32
#MACRO G_WIN32_DLLMAIN_FOR_DLL_NAME(static, dll_name)
 STATIC SHARED AS ZSTRING PTR dll_name
 FUNCTION DllMain STDCALL ALIAS "DllMain" (BYVAL hinstDLL AS HINSTANCE, BYVAL fdwReason AS DWORD, BYVAL lpvReserved AS LPVOID) AS BOOL ' WINAPI
   DIM AS wchar_t wcbfr(999)
   SELECT CASE fdwReason
   CASE DLL_PROCESS_ATTACH
     GetModuleFileNameW (CAST(HMODULE, hinstDLL), wcbfr, G_N_ELEMENTS (wcbfr))
     VAR tem = g_utf16_to_utf8 (wcbfr, -1, NULL, NULL, NULL)
     dll_name = g_path_get_basename (tem)
     g_free (tem)
   END SELECT : RETURN TRUE
 END FUNCTION
#ENDMACRO
#ENDIF ' G_PLATFORM_WIN32
#ENDIF ' G_DISABLE_DEPRECATED

'#IFDEF G_CAN_INLINE
'#DEFINE g_string_append_c(gstr,c) g_string_append_c_inline (gstr, c)
'#ENDIF ' G_CAN_INLINE

#IFNDEF G_DISABLE_DEPRECATED
#DEFINE g_string_sprintf g_string_printf
#DEFINE g_string_sprintfa g_string_append_printf
#ENDIF ' G_DISABLE_DEPRECATED

#DEFINE G_IO_CHANNEL_ERROR g_io_channel_error_quark()

'#DEFINE G_IO_FLAG_IS_WRITEABLE (G_IO_FLAG_IS_WRITABLE)

#IFDEF G_OS_WIN32
#DEFINE g_io_channel_new_file g_io_channel_new_file_utf8
#ENDIF ' G_OS_WIN32

#DEFINE G_KEY_FILE_ERROR g_key_file_error_quark()

'#DEFINE G_KEY_FILE_DESKTOP_GROUP @!"Desktop Entry"
'#DEFINE G_KEY_FILE_DESKTOP_KEY_TYPE @!"Type"
'#DEFINE G_KEY_FILE_DESKTOP_KEY_VERSION @!"Version"
'#DEFINE G_KEY_FILE_DESKTOP_KEY_NAME @!"Name"
'#DEFINE G_KEY_FILE_DESKTOP_KEY_GENERIC_NAME @!"GenericName"
'#DEFINE G_KEY_FILE_DESKTOP_KEY_NO_DISPLAY @!"NoDisplay"
'#DEFINE G_KEY_FILE_DESKTOP_KEY_COMMENT @!"Comment"
'#DEFINE G_KEY_FILE_DESKTOP_KEY_ICON @!"Icon"
'#DEFINE G_KEY_FILE_DESKTOP_KEY_HIDDEN @!"Hidden"
'#DEFINE G_KEY_FILE_DESKTOP_KEY_ONLY_SHOW_IN @!"OnlyShowIn"
'#DEFINE G_KEY_FILE_DESKTOP_KEY_NOT_SHOW_IN @!"NotShowIn"
'#DEFINE G_KEY_FILE_DESKTOP_KEY_TRY_EXEC @!"TryExec"
'#DEFINE G_KEY_FILE_DESKTOP_KEY_EXEC @!"Exec"
'#DEFINE G_KEY_FILE_DESKTOP_KEY_PATH @!"Path"
'#DEFINE G_KEY_FILE_DESKTOP_KEY_TERMINAL @!"Terminal"
'#DEFINE G_KEY_FILE_DESKTOP_KEY_MIME_TYPE @!"MimeType"
'#DEFINE G_KEY_FILE_DESKTOP_KEY_CATEGORIES @!"Categories"
'#DEFINE G_KEY_FILE_DESKTOP_KEY_STARTUP_NOTIFY @!"StartupNotify"
'#DEFINE G_KEY_FILE_DESKTOP_KEY_STARTUP_WM_CLASS @!"StartupWMClass"
'#DEFINE G_KEY_FILE_DESKTOP_KEY_URL @!"URL"
'#DEFINE G_KEY_FILE_DESKTOP_TYPE_APPLICATION @!"Application"
'#DEFINE G_KEY_FILE_DESKTOP_TYPE_LINK @!"Link"
'#DEFINE G_KEY_FILE_DESKTOP_TYPE_DIRECTORY @!"Directory"

'#DEFINE G_LOG_LEVEL_USER_SHIFT (8)

'#DEFINE G_LOG_FATAL_MASK (G_LOG_FLAG_RECURSION  OR G_LOG_LEVEL_ERROR)

#IFNDEF G_LOG_DOMAIN
#DEFINE G_LOG_DOMAIN (CAST(gchar PTR, 0))
#ENDIF ' G_LOG_DOMAIN

#IFNDEF G_HAVE_GNUC_VARARGS
#DEFINE g_error(format) #ERROR g_error NOT defined (update fbc)
#DEFINE g_message(format)  #ERROR g_message NOT defined (update fbc)
#DEFINE g_critical(format)  #ERROR g_critical NOT defined (update fbc)
#DEFINE g_warning(format)  #ERROR g_warning NOT defined (update fbc)
#DEFINE g_debug(format)  #ERROR g_debug NOT defined (update fbc)
#ELSE ' G_HAVE_GNUC_VARARGS
#DEFINE g_error(__VA_ARGS__...) g_log (G_LOG_DOMAIN, G_LOG_LEVEL_ERROR, __VA_ARGS__)
#DEFINE g_message(__VA_ARGS__...) g_log (G_LOG_DOMAIN, G_LOG_LEVEL_MESSAGE, __VA_ARGS__)
#DEFINE g_critical(__VA_ARGS__...) g_log(G_LOG_DOMAIN, G_LOG_LEVEL_CRITICAL, __VA_ARGS__)
#DEFINE g_warning(__VA_ARGS__...) g_log(G_LOG_DOMAIN, G_LOG_LEVEL_WARNING, __VA_ARGS__)
#DEFINE g_debug(__VA_ARGS__...) g_log(G_LOG_DOMAIN, G_LOG_LEVEL_DEBUG, __VA_ARGS__)
#ENDIF ' G_HAVE_GNUC_VARARGS

#DEFINE g_warn_if_reached() g_warn_message (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, NULL)
#DEFINE g_warn_if_fail(expr) IF NOT (expr) THEN g_warn_message (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, #expr)

#IFDEF G_DISABLE_CHECKS
#DEFINE g_return_if_fail(expr)
#DEFINE g_return_val_if_fail(expr,val)
#DEFINE g_return_if_reached()
#DEFINE g_return_val_if_reached(val)
#ELSE ' G_DISABLE_CHECKS
#DEFINE g_return_if_fail(expr) IF 0 = (expr) THEN g_log(G_LOG_DOMAIN, G_LOG_LEVEL_CRITICAL, _
          "file %s: line %d (%s): assertion `%s' failed", __FILE__, __LINE__, __FUNCTION__, #expr) : EXIT SUB
#DEFINE g_return_val_if_fail(expr,val) IF 0 = (expr) THEN g_log(G_LOG_DOMAIN, G_LOG_LEVEL_CRITICAL, _
          "file %s: line %d (%s): assertion `%s' failed", __FILE__, __LINE__, __FUNCTION__, #expr) : RETURN val
#DEFINE g_return_if_reached() g_log(G_LOG_DOMAIN, G_LOG_LEVEL_CRITICAL, _
          "file %s: line %d (%s): should not be reached", __FILE__, __LINE__, __FUNCTION__) : EXIT SUB
#DEFINE g_return_val_if_reached(val) g_log(G_LOG_DOMAIN, G_LOG_LEVEL_CRITICAL, _
          "file %s: line %d (%s): should not be reached", __FILE__, __LINE__, __FUNCTION__) : RETURN val
#ENDIF ' G_DISABLE_CHECKS

#DEFINE G_NODE_IS_ROOT(node) ((CAST(GNode PTR, (node)))->parent = NULL  ANDALSO _
     (CAST(GNode PTR, (node)))->prev = NULL  ANDALSO _
     (CAST(GNode PTR, (node)))->next = NULL)
#DEFINE G_NODE_IS_LEAF(node) ((CAST(GNode PTR, (node)))->children = NULL)

#DEFINE g_node_append(parent, node) _
     g_node_insert_before ((parent), NULL, (node))
#DEFINE g_node_insert_data(parent, position, data) _
     g_node_insert ((parent), (position), g_node_new (data))
#DEFINE g_node_insert_data_after(parent, sibling, data) _
     g_node_insert_after ((parent), (sibling), g_node_new (data))
#DEFINE g_node_insert_data_before(parent, sibling, data) _
     g_node_insert_before ((parent), (sibling), g_node_new (data))
#DEFINE g_node_prepend_data(parent, data) _
     g_node_prepend ((parent), g_node_new (data))
#DEFINE g_node_append_data(parent, data) _
     g_node_insert_before ((parent), NULL, g_node_new (data))

#DEFINE g_node_prev_sibling(node) IIF((node) , _
      (CAST(GNode PTR, (node)))->prev , NULL)
#DEFINE g_node_next_sibling(node) IIF((node) , _
      (CAST(GNode PTR, (node)))->next , NULL)
#DEFINE g_node_first_child(node) IIF((node) , _
      (CAST(GNode PTR, (node)))->children , NULL)

#DEFINE G_OPTION_ERROR (g_option_error_quark ())

'#DEFINE G_OPTION_REMAINING @!""

#DEFINE G_QUEUE_INIT_ TYPE<GQueue>( NULL, NULL, 0 )

#DEFINE g_rand_boolean(rand_) ((g_rand_int (rand_)  AND (1  SHL 15))  <> 0)

#DEFINE g_random_boolean() ((g_random_int ()  AND (1  SHL 15))  <> 0)

#DEFINE G_REGEX_ERROR g_regex_error_quark ()

'#DEFINE G_CSET_A_2_Z_ @!"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
'#DEFINE G_CSET_a_2_z @!"abcdefghijklmnopqrstuvwxyz"
'#DEFINE G_CSET_DIGITS @!"0123456789"
#DEFINE G_CSET_LATINC @!"\300\301\302\303\304\305\306"_
   @!"\307\310\311\312\313\314\315\316\317\320"_
   @!"\321\322\323\324\325\326"_
   @!"\330\331\332\333\334\335\336"
#DEFINE G_CSET_LATINS @!"\337\340\341\342\343\344\345\346"_
   @!"\347\350\351\352\353\354\355\356\357\360"_
   @!"\361\362\363\364\365\366"_
   @!"\370\371\372\373\374\375\376\377"

#IFNDEF G_DISABLE_DEPRECATED
#DEFINE g_scanner_add_symbol( scanner, symbol, value ) g_scanner_scope_add_symbol ((scanner), 0, (symbol), (value))
#DEFINE g_scanner_remove_symbol( scanner, symbol ) g_scanner_scope_remove_symbol ((scanner), 0, (symbol))
#DEFINE g_scanner_foreach_symbol( scanner, func, data ) g_scanner_scope_foreach_symbol ((scanner), 0, (func), (data))
#DEFINE g_scanner_freeze_symbol_table(scanner)
#DEFINE g_scanner_thaw_symbol_table(scanner)
#ENDIF ' G_DISABLE_DEPRECATED

#DEFINE G_SHELL_ERROR g_shell_error_quark ()

#DEFINE g_slice_new(type) (CAST(type PTR, g_slice_alloc (SIZEOF (type))))
#DEFINE g_slice_new0(type) (CAST(type PTR, g_slice_alloc0 (SIZEOF (type))))
#DEFINE g_slice_dup(type, mem) _
  (IIF(1 , CAST(type PTR, g_slice_copy (SIZEOF (type), (mem))) _
     , (CAST(ANY), (CAST(type PTR, 0) = (mem))), CAST(type PTR, 0)))

#DEFINE g_slice_free(type, mem) g_slice_free1 (SIZEOF (type), (mem))
#DEFINE g_slice_free_chain(type, mem_chain, next) g_slice_free_chain_with_offset (SIZEOF (type), (mem_chain), G_STRUCT_OFFSET (type, next))

#DEFINE G_SPAWN_ERROR g_spawn_error_quark ()

#IFNDEF __GTK_DOC_IGNORE__
#IFDEF G_OS_WIN32
#DEFINE g_spawn_async g_spawn_async_utf8
#DEFINE g_spawn_async_with_pipes g_spawn_async_with_pipes_utf8
#DEFINE g_spawn_sync g_spawn_sync_utf8
#DEFINE g_spawn_command_line_sync g_spawn_command_line_sync_utf8
#DEFINE g_spawn_command_line_async g_spawn_command_line_async_utf8
#ENDIF ' G_OS_WIN32
#ENDIF ' __GTK_DOC_IGNORE__

#DEFINE g_ascii_isalnum(c) _
  ((g_ascii_table[CAST(guchar, (c))]  AND G_ASCII_ALNUM)  <> 0)
#DEFINE g_ascii_isalpha(c) _
  ((g_ascii_table[CAST(guchar, (c))]  AND G_ASCII_ALPHA)  <> 0)
#DEFINE g_ascii_iscntrl(c) _
  ((g_ascii_table[CAST(guchar, (c))]  AND G_ASCII_CNTRL)  <> 0)
#DEFINE g_ascii_isdigit(c) _
  ((g_ascii_table[CAST(guchar, (c))]  AND G_ASCII_DIGIT)  <> 0)
#DEFINE g_ascii_isgraph(c) _
  ((g_ascii_table[CAST(guchar, (c))]  AND G_ASCII_GRAPH)  <> 0)
#DEFINE g_ascii_islower(c) _
  ((g_ascii_table[CAST(guchar, (c))]  AND G_ASCII_LOWER)  <> 0)
#DEFINE g_ascii_isprint(c) _
  ((g_ascii_table[CAST(guchar, (c))]  AND G_ASCII_PRINT)  <> 0)
#DEFINE g_ascii_ispunct(c) _
  ((g_ascii_table[CAST(guchar, (c))]  AND G_ASCII_PUNCT)  <> 0)
#DEFINE g_ascii_isspace(c) _
  ((g_ascii_table[CAST(guchar, (c))]  AND G_ASCII_SPACE)  <> 0)
#DEFINE g_ascii_isupper(c) _
  ((g_ascii_table[CAST(guchar, (c))]  AND G_ASCII_UPPER)  <> 0)
#DEFINE g_ascii_isxdigit(c) _
  ((g_ascii_table[CAST(guchar, (c))]  AND G_ASCII_XDIGIT)  <> 0)

'#DEFINE G_STR_DELIMITERS @!"_-|> <."

'#DEFINE G_ASCII_DTOSTR_BUF_SIZE (29 + 10)

#DEFINE g_strstrip( string ) g_strchomp (g_strchug (string))

#DEFINE g_assert_cmpstr(s1, cmp, s2) _
           IF 0 = (s1 cmp s2) THEN _
                  g_assertion_message_cmpstr(G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, _
                                             #s1 " " #cmp " " #s2, s1, #cmp, s2)
#DEFINE g_assert_cmpint(n1, cmp, n2) _
           IF 0 = (CLNGINT(n1) cmp CLNGINT(n2)) THEN _
                  g_assertion_message (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, _
                    g_strdup_printf ("assertion failed (%s): (%" G_GINT64_FORMAT " %s %" G_GINT64_FORMAT ")", _
                                     #n1 " " #cmp " " #n2, CLNGINT(n1), #cmp, CLNGINT(n2)))
#DEFINE g_assert_cmpuint(n1, cmp, n2) _
           IF 0 = (CULNGINT(n1) cmp CULNGINT(n2)) THEN _
                  g_assertion_message (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, _
                    g_strdup_printf ("assertion failed (%s): (%" G_GUINT64_FORMAT " %s %" G_GUINT64_FORMAT ")", _
                                     #n1 " " #cmp " " #n2, CULNGINT(n1), #cmp, CULNGINT(n2)))
#DEFINE g_assert_cmphex(n1, cmp, n2) _
          IF 0 = (n1 cmp n2) THEN _
                  g_assertion_message (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, _
                    g_strdup_printf ("assertion failed (%s): (0x%08" G_GINT64_MODIFIER "x %s 0x%08" G_GINT64_MODIFIER "x)", _
                                     #n1 " " #cmp " " #n2, CAST(guint64, n1), #cmp, CAST(guint64, n2)))
#DEFINE g_assert_cmpfloat(n1,cmp,n2) _
          IF 0 = (n1 cmp n2) THEN _
                  g_assertion_message (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, _
                    g_strdup_printf ("assertion failed (%s): (%.9g %s %.9g)", _
                                     #n1 " " #cmp " " #n2, CDBL(n1), #cmp, CDBL(n2)))
#DEFINE g_assert_no_error(err) IF (err) THEN _
          g_assertion_message_error (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, #err, err, 0, 0)
#DEFINE g_assert_error(err, dom, c) IF (0 = err ORELSE (err)->domain <> dom ORELSE (err)->code <> c) THEN _
          g_assertion_message_error (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, #err, err, dom, c)

#IFDEF G_DISABLE_ASSERT
#DEFINE g_assert_not_reached()
#DEFINE g_assert(expr)
#ELSE ' G_DISABLE_ASSERT
#DEFINE g_assert_not_reached() g_assertion_message (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, NULL)
#DEFINE g_assert(expr) IF NOT (expr) THEN g_assertion_message_expr (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, #expr)
#ENDIF ' G_DISABLE_ASSERT

#DEFINE g_test_quick() (g_test_config_vars->test_quick)
#DEFINE g_test_slow() ( 0 = g_test_config_vars->test_quick)
#DEFINE g_test_thorough() ( 0 = g_test_config_vars->test_quick)
#DEFINE g_test_perf() (g_test_config_vars->test_perf)
#DEFINE g_test_verbose() (g_test_config_vars->test_verbose)
#DEFINE g_test_quiet() (g_test_config_vars->test_quiet)
#DEFINE g_test_undefined() (g_test_config_vars->test_unDEFINED)

#MACRO g_test_add(testpath, Fixture, tdata, fsetup, ftest, fteardown)
 DIM add_vtable AS SUB CDECL(BYVAL AS CONST ZSTRING PTR, _
                             BYVAL AS gsize, _
                             BYVAL AS gconstpointer, _
                             BYVAL AS SUB CDECL(BYVAL AS Fixture PTR, BYVAL AS gconstpointer), _
                             BYVAL AS SUB CDECL(BYVAL AS Fixture PTR, BYVAL AS gconstpointer), _
                             BYVAL AS SUB CDECL(BYVAL AS Fixture PTR, BYVAL AS gconstpointer)) _
     = CAST(SUB CDECL(BYVAL AS CONST ZSTRING PTR, _
                      BYVAL AS gsize, _
                      BYVAL AS gconstpointer, _
                      BYVAL AS SUB CDECL(BYVAL AS Fixture PTR, BYVAL AS gconstpointer), _
                      BYVAL AS SUB CDECL(BYVAL AS Fixture PTR, BYVAL AS gconstpointer), _
                      BYVAL AS SUB CDECL(BYVAL AS Fixture PTR, BYVAL AS gconstpointer)), _
            g_test_add_vtable) ' Thanks, dkl!
 add_vtable (testpath, SIZEOF (Fixture), tdata, fsetup, ftest, fteardown)
#ENDMACRO

#DEFINE g_test_queue_unref(gobject) g_test_queue_destroy (g_object_unref, gobject)

#DEFINE g_test_trap_assert_passed() g_test_trap_assertions (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, 0, 0)
#DEFINE g_test_trap_assert_failed() g_test_trap_assertions (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, 1, 0)
#DEFINE g_test_trap_assert_stdout(soutpattern) g_test_trap_assertions (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, 2, soutpattern)
#DEFINE g_test_trap_assert_stdout_unmatched(soutpattern) g_test_trap_assertions (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, 3, soutpattern)
#DEFINE g_test_trap_assert_stderr(serrpattern) g_test_trap_assertions (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, 4, serrpattern)
#DEFINE g_test_trap_assert_stderr_unmatched(serrpattern) g_test_trap_assertions (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, 5, serrpattern)
#DEFINE g_test_rand_bit() (0  <> (g_test_rand_int()  AND (1  SHL 15)))

#DEFINE G_USEC_PER_SEC 1000000

'#DEFINE G_URI_RESERVED_CHARS_GENERIC_DELIMITERS @!":/?#[]@"
'#DEFINE G_URI_RESERVED_CHARS_SUBCOMPONENT_DELIMITERS @!"!$&'()*+,;="
'#DEFINE G_URI_RESERVED_CHARS_ALLOWED_IN_PATH_ELEMENT G_URI_RESERVED_CHARS_SUBCOMPONENT_DELIMITERS @!":@"
'#DEFINE G_URI_RESERVED_CHARS_ALLOWED_IN_PATH G_URI_RESERVED_CHARS_ALLOWED_IN_PATH_ELEMENT @!"/"
'#DEFINE G_URI_RESERVED_CHARS_ALLOWED_IN_USERINFO G_URI_RESERVED_CHARS_SUBCOMPONENT_DELIMITERS @!":"

#DEFINE G_VARIANT_TYPE_BOOLEAN (CAST(CONST GVariantType PTR, @!"b"))
#DEFINE G_VARIANT_TYPE_BYTE (CAST(CONST GVariantType PTR, @!"y"))
#DEFINE G_VARIANT_TYPE_INT16 (CAST(CONST GVariantType PTR, @!"n"))
#DEFINE G_VARIANT_TYPE_UINT16 (CAST(CONST GVariantType PTR, @!"q"))
#DEFINE G_VARIANT_TYPE_INT32 (CAST(CONST GVariantType PTR, @!"i"))
#DEFINE G_VARIANT_TYPE_UINT32 (CAST(CONST GVariantType PTR, @!"u"))
#DEFINE G_VARIANT_TYPE_INT64 (CAST(CONST GVariantType PTR, @!"x"))
#DEFINE G_VARIANT_TYPE_UINT64 (CAST(CONST GVariantType PTR, @!"t"))
#DEFINE G_VARIANT_TYPE_DOUBLE (CAST(CONST GVariantType PTR, @!"d"))
#DEFINE G_VARIANT_TYPE_STRING (CAST(CONST GVariantType PTR, @!"s"))
#DEFINE G_VARIANT_TYPE_OBJECT_PATH (CAST(CONST GVariantType PTR, @!"o"))
#DEFINE G_VARIANT_TYPE_SIGNATURE (CAST(CONST GVariantType PTR, @!"g"))
#DEFINE G_VARIANT_TYPE_VARIANT (CAST(CONST GVariantType PTR, @!"v"))
#DEFINE G_VARIANT_TYPE_HANDLE (CAST(CONST GVariantType PTR, @!"h"))
#DEFINE G_VARIANT_TYPE_UNIT (CAST(CONST GVariantType PTR, @!"()"))
#DEFINE G_VARIANT_TYPE_ANY (CAST(CONST GVariantType PTR, @!"*"))
#DEFINE G_VARIANT_TYPE_BASIC (CAST(CONST GVariantType PTR, @!"?"))
#DEFINE G_VARIANT_TYPE_MAYBE (CAST(CONST GVariantType PTR, @!"m*"))
#DEFINE G_VARIANT_TYPE_ARRAY (CAST(CONST GVariantType PTR, @!"a*"))
#DEFINE G_VARIANT_TYPE_TUPLE (CAST(CONST GVariantType PTR, @!"r"))
#DEFINE G_VARIANT_TYPE_DICT_ENTRY (CAST(CONST GVariantType PTR, @!"{?*}"))
#DEFINE G_VARIANT_TYPE_DICTIONARY (CAST(CONST GVariantType PTR, @!"a{?*}"))
#DEFINE G_VARIANT_TYPE_STRING_ARRAY (CAST(CONST GVariantType PTR, @!"as"))
#DEFINE G_VARIANT_TYPE_OBJECT_PATH_ARRAY (CAST(CONST GVariantType PTR, @!"ao"))
#DEFINE G_VARIANT_TYPE_BYTESTRING (CAST(CONST GVariantType PTR, @!"ay"))
#DEFINE G_VARIANT_TYPE_BYTESTRING_ARRAY (CAST(CONST GVariantType PTR, @!"aay"))
#DEFINE G_VARIANT_TYPE_VARDICT (CAST(CONST GVariantType PTR, @!"a{sv}"))

#IFNDEF G_DISABLE_CHECKS
#DEFINE G_VARIANT_TYPE(type_string) (g_variant_type_checked_ ((type_string)))
#ELSE ' G_DISABLE_CHECKS
#DEFINE G_VARIANT_TYPE(type_string) (CAST(CONST GVariantType PTR, (type_string)))
#ENDIF ' G_DISABLE_CHECKS

#DEFINE G_VARIANT_PARSE_ERROR (g_variant_parser_get_error_quark ())

'#DEFINE GLIB_CHECK_VERSION(major,minor,micro) _
    '(GLIB_MAJOR_VERSION  > (major)  ORELSE _
     '(GLIB_MAJOR_VERSION = (major)  ANDALSO GLIB_MINOR_VERSION  > (minor))  ORELSE _
     '(GLIB_MAJOR_VERSION = (major)  ANDALSO GLIB_MINOR_VERSION = (minor)  ANDALSO _
      'GLIB_MICRO_VERSION >= (micro)))

#IFNDEF G_DISABLE_DEPRECATED
#IFNDEF __GTK_DOC_IGNORE__
#IFDEF _WIN64
#DEFINE g_win32_get_package_installation_directory g_win32_get_package_installation_directory_utf8
#DEFINE g_win32_get_package_installation_subdirectory g_win32_get_package_installation_subdirectory_utf8
#ENDIF ' _WIN64
#ENDIF ' __GTK_DOC_IGNORE__
#ENDIF ' G_DISABLE_DEPRECATED

#DEFINE G_ALLOC_ONLY 1
#DEFINE G_ALLOC_AND_FREE 2
#DEFINE G_ALLOCATOR_LIST 1
#DEFINE G_ALLOCATOR_SLIST 2
#DEFINE G_ALLOCATOR_NODE 3
#DEFINE g_chunk_new(type, chunk) (CAST(type PTR, g_mem_chunk_alloc (chunk)))
#DEFINE g_chunk_new0(type, chunk) (CAST(type PTR, g_mem_chunk_alloc0 (chunk)))
#DEFINE g_chunk_free(mem, mem_chunk) (g_mem_chunk_free (mem_chunk, mem))
#DEFINE g_mem_chunk_create(type, x, y) (g_mem_chunk_new (NULL, SIZEOF (type), 0, 0))

#DEFINE g_main_new(is_running) g_main_loop_new (NULL, is_running)
#DEFINE g_main_run(loop) g_main_loop_run(loop)
#DEFINE g_main_quit(loop) g_main_loop_quit(loop)
#DEFINE g_main_destroy(loop) g_main_loop_unref(loop)
#DEFINE g_main_is_running(loop) g_main_loop_is_running(loop)
#DEFINE g_main_iteration(may_block) g_main_context_iteration (NULL, may_block)
#DEFINE g_main_pending() g_main_context_pending (NULL)
#DEFINE g_main_set_poll_func(func) g_main_context_set_poll_func (NULL, func)

#DEFINE g_static_mutex_get_mutex g_static_mutex_get_mutex_impl
#DEFINE G_STATIC_MUTEX_INIT_ TYPE<GStaticMutex>( NULL )

#DEFINE g_static_mutex_lock(mutex) _
    g_mutex_lock (g_static_mutex_get_mutex (mutex))
#DEFINE g_static_mutex_trylock(mutex) _
    g_mutex_trylock (g_static_mutex_get_mutex (mutex))
#DEFINE g_static_mutex_unlock(mutex) _
    g_mutex_unlock (g_static_mutex_get_mutex (mutex))

#DEFINE G_STATIC_REC_MUTEX_INIT_ TYPE<GStaticRecMutex>(G_STATIC_MUTEX_INIT_)

#DEFINE G_STATIC_RW_LOCK_INIT_ TYPE<GStaticRWLock>( G_STATIC_MUTEX_INIT_, NULL, NULL, 0, FALSE, 0, 0 )

#DEFINE G_STATIC_PRIVATE_INIT_ TYPE<GStaticPrivate>(0)
