'################################################################################
'#  Duckdb.bi                                                                   #
'#  Authors: fan2006                                                            #
'#  Based on: the code posted on the freeBasic forum(www.freebasic.net/forum/   #
'#  See also：                                                                  #
'#   https://www.freebasic.net/forum/viewtopic.php?t=32986                      #
'#   https://github.com/duckdb/duckdb                                           #
'################################################################################
'Download the library duckdb.a and duckdb.dll files from the following address
'https://github.com/LukyGuyLucky/duckdb-Win-x64-mingw-lib

#pragma once
#ifndef DUCKDB_API
#define DUCKDB_API
#include once "crt/stdint.bi"
#include once "crt/stddef.bi"
#inclib "duckdb"
Extern "C"

Enum Duckdb_Type
   DUCKDB_TYPE_INVALID = 0
   DUCKDB_TYPE_BOOLEAN = 1
   DUCKDB_TYPE_TINYINT = 2
   DUCKDB_TYPE_SMALLINT = 3
   DUCKDB_TYPE_INTEGER = 4
   DUCKDB_TYPE_BIGINT = 5
   DUCKDB_TYPE_UTINYINT = 6
   DUCKDB_TYPE_USMALLINT = 7
   DUCKDB_TYPE_UINTEGER = 8
   DUCKDB_TYPE_UBIGINT = 9
   DUCKDB_TYPE_FLOAT = 10
   DUCKDB_TYPE_DOUBLE = 11
   DUCKDB_TYPE_TIMESTAMP = 12
   DUCKDB_TYPE_DATE = 13
   DUCKDB_TYPE_TIME = 14
   DUCKDB_TYPE_INTERVAL = 15
   DUCKDB_TYPE_HUGEINT = 16
   DUCKDB_TYPE_UHUGEINT = 32
   DUCKDB_TYPE_VARCHAR = 17
   DUCKDB_TYPE_BLOB = 18
   DUCKDB_TYPE_DECIMAL = 19
   DUCKDB_TYPE_TIMESTAMP_S = 20
   DUCKDB_TYPE_TIMESTAMP_MS = 21
   DUCKDB_TYPE_TIMESTAMP_NS = 22
   DUCKDB_TYPE_ENUM = 23
   DUCKDB_TYPE_LIST = 24
   DUCKDB_TYPE_STRUCT = 25
   DUCKDB_TYPE_MAP = 26
   DUCKDB_TYPE_ARRAY = 33
   DUCKDB_TYPE_UUID = 27
   DUCKDB_TYPE_UNION = 28
   DUCKDB_TYPE_BIT = 29
   DUCKDB_TYPE_TIME_TZ = 30
   DUCKDB_TYPE_TIMESTAMP_TZ = 31
   DUCKDB_TYPE_ANY = 34
   DUCKDB_TYPE_VARINT = 35
   DUCKDB_TYPE_SQLNULL = 36
End Enum

Enum Duckdb_State
   DuckDBSuccess = 0
   DuckDBError = 1
End Enum

Enum Duckdb_Pending_State
   DUCKDB_PENDING_RESULT_READY = 0
   DUCKDB_PENDING_RESULT_NOT_READY = 1
   DUCKDB_PENDING_ERROR = 2
   DUCKDB_PENDING_NO_TASKS_AVAILABLE = 3
End Enum

Enum Duckdb_Result_Type
   DUCKDB_RESULT_TYPE_INVALID = 0
   DUCKDB_RESULT_TYPE_CHANGED_ROWS = 1
   DUCKDB_RESULT_TYPE_NOTHING = 2
   DUCKDB_RESULT_TYPE_QUERY_RESULT = 3
End Enum

Enum Duckdb_Statement_Type
   DUCKDB_STATEMENT_TYPE_INVALID = 0
   DUCKDB_STATEMENT_TYPE_SELECT = 1
   DUCKDB_STATEMENT_TYPE_INSERT = 2
   DUCKDB_STATEMENT_TYPE_UPDATE = 3
   DUCKDB_STATEMENT_TYPE_EXPLAIN = 4
   DUCKDB_STATEMENT_TYPE_DELETE = 5
   DUCKDB_STATEMENT_TYPE_PREPARE = 6
   DUCKDB_STATEMENT_TYPE_CREATE = 7
   DUCKDB_STATEMENT_TYPE_EXECUTE = 8
   DUCKDB_STATEMENT_TYPE_ALTER = 9
   DUCKDB_STATEMENT_TYPE_TRANSACTION = 10
   DUCKDB_STATEMENT_TYPE_COPY = 11
   DUCKDB_STATEMENT_TYPE_ANALYZE = 12
   DUCKDB_STATEMENT_TYPE_VARIABLE_SET = 13
   DUCKDB_STATEMENT_TYPE_CREATE_FUNC = 14
   DUCKDB_STATEMENT_TYPE_DROP = 15
   DUCKDB_STATEMENT_TYPE_EXPORT = 16
   DUCKDB_STATEMENT_TYPE_PRAGMA = 17
   DUCKDB_STATEMENT_TYPE_VACUUM = 18
   DUCKDB_STATEMENT_TYPE_CALL = 19
   DUCKDB_STATEMENT_TYPE_SET = 20
   DUCKDB_STATEMENT_TYPE_LOAD = 21
   DUCKDB_STATEMENT_TYPE_RELATION = 22
   DUCKDB_STATEMENT_TYPE_EXTENSION = 23
   DUCKDB_STATEMENT_TYPE_LOGICAL_PLAN = 24
   DUCKDB_STATEMENT_TYPE_ATTACH = 25
   DUCKDB_STATEMENT_TYPE_DETACH = 26
   DUCKDB_STATEMENT_TYPE_MULTI = 27
End Enum

Enum Duckdb_Error_Type
   DUCKDB_ERROR_INVALID = 0
   DUCKDB_ERROR_OUT_OF_RANGE = 1
   DUCKDB_ERROR_CONVERSION = 2
   DUCKDB_ERROR_UNKNOWN_TYPE = 3
   DUCKDB_ERROR_DECIMAL = 4
   DUCKDB_ERROR_MISMATCH_TYPE = 5
   DUCKDB_ERROR_DIVIDE_BY_ZERO = 6
   DUCKDB_ERROR_OBJECT_SIZE = 7
   DUCKDB_ERROR_INVALID_TYPE = 8
   DUCKDB_ERROR_SERIALIZATION = 9
   DUCKDB_ERROR_TRANSACTION = 10
   DUCKDB_ERROR_NOT_IMPLEMENTED = 11
   DUCKDB_ERROR_EXPRESSION = 12
   DUCKDB_ERROR_CATALOG = 13
   DUCKDB_ERROR_PARSER = 14
   DUCKDB_ERROR_PLANNER = 15
   DUCKDB_ERROR_SCHEDULER = 16
   DUCKDB_ERROR_EXECUTOR = 17
   DUCKDB_ERROR_CONSTRAINT = 18
   DUCKDB_ERROR_INDEX = 19
   DUCKDB_ERROR_STAT = 20
   DUCKDB_ERROR_CONNECTION = 21
   DUCKDB_ERROR_SYNTAX = 22
   DUCKDB_ERROR_SETTINGS = 23
   DUCKDB_ERROR_BINDER = 24
   DUCKDB_ERROR_NETWORK = 25
   DUCKDB_ERROR_OPTIMIZER = 26
   DUCKDB_ERROR_NULL_POINTER = 27
   DUCKDB_ERROR_IO = 28
   DUCKDB_ERROR_INTERRUPT = 29
   DUCKDB_ERROR_FATAL = 30
   DUCKDB_ERROR_INTERNAL = 31
   DUCKDB_ERROR_INVALID_INPUT = 32
   DUCKDB_ERROR_OUT_OF_MEMORY = 33
   DUCKDB_ERROR_PERMISSION = 34
   DUCKDB_ERROR_PARAMETER_NOT_RESOLVED = 35
   DUCKDB_ERROR_PARAMETER_NOT_ALLOWED = 36
   DUCKDB_ERROR_DEPENDENCY = 37
   DUCKDB_ERROR_HTTP = 38
   DUCKDB_ERROR_MISSING_EXTENSION = 39
   DUCKDB_ERROR_AUTOLOAD = 40
   DUCKDB_ERROR_SEQUENCE = 41
   DUCKDB_INVALID_CONFIGURATION = 42
End Enum

Enum Duckdb_Cast_Mode
   DUCKDB_CAST_NORMAL = 0
   DUCKDB_CAST_TRY = 1
End Enum

'Type idx_t As ULongInt
Type DuckDB_Delete_Callback_t As Sub(ByVal data_ As Any Ptr)
Type DuckDB_Task_State As Any Ptr

Type DuckDB_Date
   Days As Long
End Type

Type DuckDB_Date_Struct
   Year As Long
   Month As Byte
   Day As Byte
End Type

Type DuckDB_Time
   micros As LongInt
End Type

Type DuckDB_Time_Struct
   Hour As Byte
   Min As Byte
   Sec As Byte
   Micros As Long
End Type

Type DuckDB_Time_TZ
   Bits As ULongInt
End Type

Type DuckDB_Time_TZ_Struct
   Time As DuckDB_Time_Struct
   Offset As Long
End Type

Type DuckDB_Timestamp
   Micros As LongInt
End Type

Type DuckDB_Timestamp_Struct
   Date As DuckDB_Date_Struct
   Time As DuckDB_Time_Struct
End Type

Type DuckDB_Interval
   Months As Long
   Days As Long
   Micros As LongInt
End Type

Type DuckDB_HugeInt
   Lower As ULongInt
   Upper As LongInt
End Type

Type DuckDB_UHugeInt
   Lower As ULongInt
   Upper As ULongInt
End Type

Type DuckDB_Decimal
   Width As UByte
   Scale As UByte
   Value As DuckDB_HugeInt
End Type

Type DuckDB_Query_Progress_Type
   Percentage As Double
   Rows_processed As ULongInt
   Total_Rows_To_Process As ULongInt
End Type

Type DuckDB_String_T_Value_Pointer
   Length As ULong
   Prefix As ZString * 4
   Ptr_ As ZString Ptr
End Type

Type DuckDB_String_T_Value_Inlined
   Length As ULong
   Inlined As ZString * 12
End Type

Union Duckdb_String_T_Value
   Pointer As DuckDB_String_T_Value_Pointer
   Inlined As DuckDB_String_T_Value_Inlined
End Union

Type DuckDB_String_T
   Value As Duckdb_String_T_Value
End Type

Type DuckDB_List_Entry
   Offset As ULongInt
   Length As ULongInt
End Type

Type DuckDB_Column
   Deprecated_Data As Any Ptr
   Deprecated_Nullmask As Long Ptr
   Deprecated_type As Duckdb_Type
   Deprecated_name As ZString Ptr
   Internal_Data As Any Ptr
End Type

Type _DuckDB_Vector
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Vector As _DuckDB_Vector Ptr

Type DuckDB_String
   Data_ As ZString Ptr
   Size As ULongInt
End Type

Type DuckDB_Blob
   Data_ As Any Ptr
   Size As ULongInt
End Type

Type DuckDB_result
   Deprecated_column_count As ULongInt
   Deprecated_row_count As ULongInt
   Deprecated_rows_changed As ULongInt
   Deprecated_columns As DuckDB_Column Ptr
   Deprecated_error_message As ZString Ptr
   Internal_data As Any Ptr
End Type

Type _DuckDB_Database
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Database As _DuckDB_Database Ptr

Type _DuckDB_Connection
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_connection As _DuckDB_Connection Ptr

Type _DuckDB_Prepared_Statement
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Prepared_Statement As _DuckDB_Prepared_Statement Ptr

Type _DuckDB_Extracted_Statements
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Extracted_Statements As _DuckDB_Extracted_Statements Ptr

Type _DuckDB_Pending_Result
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Pending_Result As _DuckDB_Pending_Result Ptr

Type _DuckDB_Appender
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Appender As _DuckDB_Appender Ptr

Type _DuckDB_Table_Description
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Table_Description As _DuckDB_Table_Description Ptr

Type _DuckDB_Config
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_config As _DuckDB_Config Ptr

Type _DuckDB_Logical_Type
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Logical_Type As _DuckDB_Logical_Type Ptr

Type _DuckDB_Create_Type_Info
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Create_Type_Info As _DuckDB_Create_Type_Info Ptr

Type _DuckDB_Data_Chunk
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Data_Chunk As _DuckDB_Data_Chunk Ptr

Type _DuckDB_Value
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Value As _DuckDB_Value Ptr

Type _DuckDB_Profiling_Info
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Profiling_Info As _DuckDB_Profiling_Info Ptr

Type _DuckDB_Extension_Info
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Extension_Info As _DuckDB_Extension_Info Ptr

Type _DuckDB_Function_Info
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Function_info As _DuckDB_Function_Info Ptr

Type _DuckDB_Scalar_function
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Scalar_Function As _DuckDB_Scalar_function Ptr

Type _DuckDB_Scalar_Function_set
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Scalar_Function_Set As _DuckDB_Scalar_Function_set Ptr
Type DuckDB_Scalar_Function_t As Sub(ByVal info As DuckDB_Function_info, ByVal Input As DuckDB_Data_Chunk, ByVal Output As DuckDB_Vector)

Type _DuckDB_Aggregate_Function
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Aggregate_Function As _DuckDB_Aggregate_Function Ptr

Type _DuckDB_aggregate_Function_Set
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Aggregate_Function_Set As _DuckDB_aggregate_Function_Set Ptr

Type _DuckDB_Aggregate_State
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Aggregate_State As _DuckDB_Aggregate_State Ptr
Type DuckDB_Aggregate_State_size As Function(ByVal info As DuckDB_Function_info) As ULongInt
Type DuckDB_Aggregate_Init_t As Sub(ByVal info As DuckDB_Function_info, ByVal state As DuckDB_Aggregate_State)
Type DuckDB_Aggregate_Destroy_t As Sub(ByVal states As DuckDB_Aggregate_State Ptr, ByVal count As ULongInt)
Type DuckDB_Aggregate_Update_t As Sub(ByVal info As DuckDB_Function_info, ByVal Input As DuckDB_Data_Chunk, ByVal states As DuckDB_Aggregate_State Ptr)
Type DuckDB_Aggregate_Combine_t As Sub(ByVal info As DuckDB_Function_info, ByVal source As DuckDB_Aggregate_State Ptr, ByVal target As DuckDB_Aggregate_State Ptr, ByVal count As ULongInt)
Type DuckDB_Aggregate_Finalize_t As Sub(ByVal info As DuckDB_Function_info, ByVal source As DuckDB_Aggregate_State Ptr, ByVal result As DuckDB_Vector, ByVal count As ULongInt, ByVal offset As ULongInt)

Type _DuckDB_Table_Function
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Table_Function As _DuckDB_Table_Function Ptr

Type _DuckDB_Bind_Info
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Bind_Info As _DuckDB_Bind_Info Ptr

Type _DuckDB_Init_Info
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Init_Info As _DuckDB_Init_Info Ptr
Type DuckDB_Table_Function_Bind_t As Sub(ByVal info As DuckDB_Bind_Info)
Type DuckDB_Table_Function_Init_t As Sub(ByVal info As DuckDB_Init_Info)
Type DuckDB_Table_Function_t As Sub(ByVal info As DuckDB_Function_info, ByVal Output As DuckDB_Data_Chunk)

Type _DuckDB_Cast_Function
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Cast_Function As _DuckDB_Cast_Function Ptr
Type DuckDB_Cast_Function_t As Function(ByVal info As DuckDB_Function_info, ByVal count As ULongInt, ByVal Input As DuckDB_Vector, ByVal Output As DuckDB_Vector) As Boolean

Type _DuckDB_Replacement_Scan_Info
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Replacement_Scan_info As _DuckDB_Replacement_Scan_Info Ptr
Type DuckDB_Replacement_Callback_t As Sub(ByVal info As DuckDB_Replacement_Scan_info, ByVal table_name As Const ZString Ptr, ByVal data_ As Any Ptr)

Type _DuckDB_Arrow
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Arrow As _DuckDB_Arrow Ptr

Type _DuckDB_Arrow_Stream
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Arrow_Stream As _DuckDB_Arrow_Stream Ptr

Type _DuckDB_Arrow_Schema
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Arrow_Schema As _DuckDB_Arrow_Schema Ptr

Type _DuckDB_Arrow_Array
   Internal_Ptr As Any Ptr
End Type

Type DuckDB_Arrow_Array As _DuckDB_Arrow_Array Ptr

Type DuckDB_Extension_Access
   Set_Error As Sub(ByVal info As DuckDB_Extension_Info, ByVal error_ As Const ZString Ptr)
   Get_Database As Function(ByVal info As DuckDB_Extension_Info) As DuckDB_Database Ptr
   Get_API As Function(ByVal info As DuckDB_Extension_Info, ByVal version As Const ZString Ptr) As Const Any Ptr
End Type

Declare Function duckdb_open(ByVal path As Const ZString Ptr, ByVal out_database As DuckDB_Database Ptr) As Duckdb_State
Declare Function duckdb_open_ext(ByVal path As Const ZString Ptr, ByVal out_database As DuckDB_Database Ptr, ByVal config As DuckDB_config, ByVal out_error As ZString Ptr Ptr) As Duckdb_State
Declare Sub duckdb_close(ByVal database As DuckDB_Database Ptr)
Declare Function duckdb_connect(ByVal database As DuckDB_Database, ByVal out_connection As DuckDB_connection Ptr) As Duckdb_State
Declare Sub duckdb_interrupt(ByVal connection As DuckDB_connection)
Declare Function duckdb_query_progress(ByVal connection As DuckDB_connection) As DuckDB_Query_Progress_Type
Declare Sub duckdb_disconnect(ByVal connection As DuckDB_connection Ptr)
Declare Function duckdb_library_version() As Const ZString Ptr
Declare Function duckdb_create_config(ByVal out_config As DuckDB_config Ptr) As Duckdb_State
Declare Function duckdb_config_count() As UInteger
Declare Function duckdb_get_config_flag(ByVal index As UInteger, ByVal out_name As Const ZString Ptr Ptr, ByVal out_description As Const ZString Ptr Ptr) As Duckdb_State
Declare Function duckdb_set_config(ByVal config As DuckDB_config, ByVal name_ As Const ZString Ptr, ByVal option As Const ZString Ptr) As Duckdb_State
Declare Sub duckdb_destroy_config(ByVal config As DuckDB_config Ptr)
Declare Function duckdb_query(ByVal connection As DuckDB_connection, ByVal query As Const ZString Ptr, ByVal out_result As DuckDB_result Ptr) As Duckdb_State
Declare Sub duckdb_destroy_result(ByVal result As DuckDB_result Ptr)
Declare Function duckdb_column_name(ByVal result As DuckDB_result Ptr, ByVal col As ULongInt) As Const ZString Ptr
Declare Function duckdb_column_type(ByVal result As DuckDB_result Ptr, ByVal col As ULongInt) As Duckdb_Type
Declare Function duckdb_result_statement_type(ByVal result As DuckDB_result) As Duckdb_Statement_Type
Declare Function duckdb_column_logical_type(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt) As Duckdb_Logical_Type
Declare Function duckdb_column_count(ByVal result As Duckdb_result Ptr) As ULongInt
Declare Function duckdb_row_count(ByVal result As Duckdb_result Ptr) As ULongInt
Declare Function duckdb_rows_changed(ByVal result As Duckdb_result Ptr) As ULongInt
Declare Function duckdb_column_data(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt) As Any Ptr
Declare Function duckdb_nullmask_data(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt) As Boolean
Declare Function duckdb_result_error(ByVal result As Duckdb_result Ptr) As Const ZString Ptr
Declare Function duckdb_result_error_type(ByVal result As Duckdb_result Ptr) As Duckdb_Error_Type
Declare Function duckdb_result_get_chunk(ByVal result As Duckdb_result, ByVal chunk_index As ULongInt) As Duckdb_Data_Chunk
Declare Function duckdb_result_is_streaming(ByVal result As Duckdb_result) As Boolean
Declare Function duckdb_result_chunk_count(ByVal result As Duckdb_result) As ULongInt
Declare Function duckdb_result_return_type(ByVal result As Duckdb_result) As Duckdb_Result_Type
Declare Function duckdb_value_boolean(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As Boolean
Declare Function duckdb_value_int8(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As Byte
Declare Function duckdb_value_int16(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As Short
Declare Function duckdb_value_int32(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As Long
Declare Function duckdb_value_int64(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As LongInt
Declare Function duckdb_value_hugeint(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As Duckdb_HugeInt
Declare Function duckdb_value_uhugeint(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As Duckdb_UHugeInt
Declare Function duckdb_value_decimal(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As Duckdb_Decimal
Declare Function duckdb_value_uint8(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As UByte
Declare Function duckdb_value_uint16(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As UShort
Declare Function duckdb_value_uint32(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As ULong
Declare Function duckdb_value_uint64(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As ULongInt
Declare Function duckdb_value_float(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As Single
Declare Function duckdb_value_double(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As Double
Declare Function duckdb_value_date(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As Duckdb_Date
Declare Function duckdb_value_time(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As Duckdb_Time
Declare Function duckdb_value_timestamp(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As Duckdb_Timestamp
Declare Function duckdb_value_interval(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As Duckdb_Interval
Declare Function duckdb_value_varchar(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As ZString Ptr
Declare Function duckdb_value_string(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As Duckdb_String
Declare Function duckdb_value_varchar_internal(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As ZString Ptr
Declare Function duckdb_value_string_internal(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As Duckdb_String
Declare Function duckdb_value_blob(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As Duckdb_Blob
Declare Function duckdb_value_is_null(ByVal result As Duckdb_result Ptr, ByVal col As ULongInt, ByVal row As ULongInt) As Boolean
Declare Function duckdb_malloc(ByVal size As UInteger) As Any Ptr
Declare Sub duckdb_free(ByVal ptr_ As Any Ptr)
Declare Function duckdb_vector_size() As ULongInt
Declare Function duckdb_string_is_inlined(ByVal string As Duckdb_String_T) As Boolean
Declare Function duckdb_string_t_length(ByVal string As Duckdb_String_T) As ULong
Declare Function duckdb_string_t_data(ByVal string As Duckdb_String_T Ptr) As Const ZString Ptr
Declare Function duckdb_from_date(ByVal date As Duckdb_Date) As Duckdb_Date_Struct
Declare Function duckdb_to_date(ByVal date As Duckdb_Date_Struct) As Duckdb_Date
Declare Function duckdb_is_finite_date(ByVal date As Duckdb_Date) As Boolean
Declare Function duckdb_from_time(ByVal time As Duckdb_Time) As Duckdb_Time_Struct
Declare Function duckdb_create_time_tz(ByVal micros As LongInt, ByVal offset As Long) As Duckdb_Time_TZ
Declare Function duckdb_from_time_tz(ByVal micros As Duckdb_Time_TZ) As Duckdb_Time_TZ_Struct
Declare Function duckdb_to_time(ByVal time As Duckdb_Time_Struct) As Duckdb_Time
Declare Function duckdb_from_timestamp(ByVal ts As Duckdb_Timestamp) As Duckdb_Timestamp_Struct
Declare Function duckdb_to_timestamp(ByVal ts As Duckdb_Timestamp_Struct) As Duckdb_Timestamp
Declare Function duckdb_is_finite_timestamp(ByVal ts As Duckdb_Timestamp) As Boolean
Declare Function duckdb_hugeint_to_double(ByVal val_ As Duckdb_HugeInt) As Double
Declare Function duckdb_double_to_hugeint(ByVal val_ As Double) As Duckdb_HugeInt
Declare Function duckdb_uhugeint_to_double(ByVal val_ As Duckdb_UHugeInt) As Double
Declare Function duckdb_double_to_uhugeint(ByVal val_ As Double) As Duckdb_UHugeInt
Declare Function duckdb_double_to_decimal(ByVal val_ As Double, ByVal width As UByte, ByVal scale As UByte) As Duckdb_Decimal
Declare Function duckdb_decimal_to_double(ByVal val_ As Duckdb_Decimal) As Double
Declare Function duckdb_prepare(ByVal connection As Duckdb_connection, ByVal query As Const ZString Ptr, ByVal out_prepared_statement As Duckdb_Prepared_Statement Ptr) As Duckdb_State
Declare Sub duckdb_destroy_prepare(ByVal prepared_statement As Duckdb_Prepared_Statement Ptr)
Declare Function duckdb_prepare_error(ByVal prepared_statement As Duckdb_Prepared_Statement) As Const ZString Ptr
Declare Function duckdb_nparams(ByVal prepared_statement As Duckdb_Prepared_Statement) As ULongInt
Declare Function duckdb_parameter_name(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal index As ULongInt) As Const ZString Ptr
Declare Function duckdb_param_type(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt) As Duckdb_Type
Declare Function duckdb_clear_bindings(ByVal prepared_statement As Duckdb_Prepared_Statement) As Duckdb_State
Declare Function duckdb_prepared_statement_type(ByVal statement As Duckdb_Prepared_Statement) As Duckdb_Statement_Type
Declare Function duckdb_bind_value(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As Duckdb_Value) As Duckdb_State
Declare Function duckdb_bind_parameter_index(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx_out As ULongInt Ptr, ByVal name_ As Const ZString Ptr) As Duckdb_State
Declare Function duckdb_bind_boolean(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As Boolean) As Duckdb_State
Declare Function duckdb_bind_int8(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As Byte) As Duckdb_State
Declare Function duckdb_bind_int16(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As Short) As Duckdb_State
Declare Function duckdb_bind_int32(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As Long) As Duckdb_State
Declare Function duckdb_bind_int64(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As LongInt) As Duckdb_State
Declare Function duckdb_bind_hugeint(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As Duckdb_HugeInt) As Duckdb_State
Declare Function duckdb_bind_uhugeint(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As Duckdb_UHugeInt) As Duckdb_State
Declare Function duckdb_bind_decimal(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As Duckdb_Decimal) As Duckdb_State
Declare Function duckdb_bind_uint8(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As UByte) As Duckdb_State
Declare Function duckdb_bind_uint16(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As UShort) As Duckdb_State
Declare Function duckdb_bind_uint32(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As ULong) As Duckdb_State
Declare Function duckdb_bind_uint64(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As ULongInt) As Duckdb_State
Declare Function duckdb_bind_float(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As Single) As Duckdb_State
Declare Function duckdb_bind_double(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As Double) As Duckdb_State
Declare Function duckdb_bind_date(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As Duckdb_Date) As Duckdb_State
Declare Function duckdb_bind_time(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As Duckdb_Time) As Duckdb_State
Declare Function duckdb_bind_timestamp(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As Duckdb_Timestamp) As Duckdb_State
Declare Function duckdb_bind_timestamp_tz(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As Duckdb_Timestamp) As Duckdb_State
Declare Function duckdb_bind_interval(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As Duckdb_Interval) As Duckdb_State
Declare Function duckdb_bind_varchar(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As Const ZString Ptr) As Duckdb_State
Declare Function duckdb_bind_varchar_length(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal val_ As Const ZString Ptr, ByVal length As ULongInt) As Duckdb_State
Declare Function duckdb_bind_blob(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt, ByVal data_ As Const Any Ptr, ByVal length As ULongInt) As Duckdb_State
Declare Function duckdb_bind_null(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal param_idx As ULongInt) As Duckdb_State
Declare Function duckdb_execute_prepared(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal out_result As Duckdb_result Ptr) As Duckdb_State
Declare Function duckdb_execute_prepared_streaming(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal out_result As Duckdb_result Ptr) As Duckdb_State
Declare Function duckdb_extract_statements(ByVal connection As Duckdb_connection, ByVal query As Const ZString Ptr, ByVal out_extracted_statements As Duckdb_Extracted_Statements Ptr) As ULongInt
Declare Function duckdb_prepare_extracted_statement(ByVal connection As Duckdb_connection, ByVal extracted_statements As Duckdb_Extracted_Statements, ByVal index As ULongInt, ByVal out_prepared_statement As Duckdb_Prepared_Statement Ptr) As Duckdb_State
Declare Function duckdb_extract_statements_error(ByVal extracted_statements As Duckdb_Extracted_Statements) As Const ZString Ptr
Declare Sub duckdb_destroy_extracted(ByVal extracted_statements As Duckdb_Extracted_Statements Ptr)
Declare Function duckdb_pending_prepared(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal out_result As Duckdb_Pending_Result Ptr) As Duckdb_State
Declare Function duckdb_pending_prepared_streaming(ByVal prepared_statement As Duckdb_Prepared_Statement, ByVal out_result As Duckdb_Pending_Result Ptr) As Duckdb_State
Declare Sub duckdb_destroy_pending(ByVal pending_result As Duckdb_Pending_Result Ptr)

Declare Function duckdb_pending_execute_task(ByVal pending_result As Duckdb_Pending_Result) As Duckdb_Pending_State
Declare Function duckdb_pending_execute_check_state(ByVal pending_result As Duckdb_Pending_Result) As Duckdb_Pending_State
Declare Function duckdb_execute_pending(ByVal pending_result As Duckdb_Pending_Result, ByVal out_result As Duckdb_result Ptr) As Duckdb_State
Declare Function duckdb_pending_execution_is_finished(ByVal pending_state As Duckdb_Pending_State) As Boolean
Declare Sub duckdb_destroy_value(ByVal value As Duckdb_Value Ptr)
Declare Function duckdb_create_varchar(ByVal text As Const ZString Ptr) As Duckdb_Value
Declare Function duckdb_create_varchar_length(ByVal text As Const ZString Ptr, ByVal length As ULongInt) As Duckdb_Value
Declare Function duckdb_create_bool(ByVal input As Boolean) As Duckdb_Value
Declare Function duckdb_create_int8(ByVal input As Byte) As Duckdb_Value
Declare Function duckdb_create_uint8(ByVal input As UByte) As Duckdb_Value
Declare Function duckdb_create_int16(ByVal input As Short) As Duckdb_Value
Declare Function duckdb_create_uint16(ByVal input As UShort) As Duckdb_Value
Declare Function duckdb_create_int32(ByVal input As Long) As Duckdb_Value
Declare Function duckdb_create_uint32(ByVal input As ULong) As Duckdb_Value
Declare Function duckdb_create_uint64(ByVal input As ULongInt) As Duckdb_Value
Declare Function duckdb_create_int64(ByVal val_ As LongInt) As Duckdb_Value
Declare Function duckdb_create_hugeint(ByVal input As Duckdb_HugeInt) As Duckdb_Value
Declare Function duckdb_create_uhugeint(ByVal input As Duckdb_UHugeInt) As Duckdb_Value
Declare Function duckdb_create_float(ByVal input As Single) As Duckdb_Value
Declare Function duckdb_create_double(ByVal input As Double) As Duckdb_Value
Declare Function duckdb_create_date(ByVal input As Duckdb_Date) As Duckdb_Value
Declare Function duckdb_create_time(ByVal input As Duckdb_Time) As Duckdb_Value
Declare Function duckdb_create_time_tz_value(ByVal value As Duckdb_Time_TZ) As Duckdb_Value
Declare Function duckdb_create_timestamp(ByVal input As Duckdb_Timestamp) As Duckdb_Value
Declare Function duckdb_create_interval(ByVal input As Duckdb_Interval) As Duckdb_Value
Declare Function duckdb_create_blob(ByVal data_ As Const UByte Ptr, ByVal length As ULongInt) As Duckdb_Value
Declare Function duckdb_get_bool(ByVal val_ As Duckdb_Value) As Boolean
Declare Function duckdb_get_int8(ByVal val_ As Duckdb_Value) As Byte
Declare Function duckdb_get_uint8(ByVal val_ As Duckdb_Value) As UByte
Declare Function duckdb_get_int16(ByVal val_ As Duckdb_Value) As Short
Declare Function duckdb_get_uint16(ByVal val_ As Duckdb_Value) As UShort
Declare Function duckdb_get_int32(ByVal val_ As Duckdb_Value) As Long
Declare Function duckdb_get_uint32(ByVal val_ As Duckdb_Value) As ULong
Declare Function duckdb_get_int64(ByVal val_ As Duckdb_Value) As LongInt
Declare Function duckdb_get_uint64(ByVal val_ As Duckdb_Value) As ULongInt
Declare Function duckdb_get_hugeint(ByVal val_ As Duckdb_Value) As Duckdb_HugeInt
Declare Function duckdb_get_uhugeint(ByVal val_ As Duckdb_Value) As Duckdb_UHugeInt
Declare Function duckdb_get_float(ByVal val_ As Duckdb_Value) As Single
Declare Function duckdb_get_double(ByVal val_ As Duckdb_Value) As Double
Declare Function duckdb_get_date(ByVal val_ As Duckdb_Value) As Duckdb_Date
Declare Function duckdb_get_time(ByVal val_ As Duckdb_Value) As Duckdb_Time
Declare Function duckdb_get_time_tz(ByVal val_ As Duckdb_Value) As Duckdb_Time_TZ
Declare Function duckdb_get_timestamp(ByVal val_ As Duckdb_Value) As Duckdb_Timestamp
Declare Function duckdb_get_interval(ByVal val_ As Duckdb_Value) As Duckdb_Interval
Declare Function duckdb_get_value_type(ByVal val_ As Duckdb_Value) As Duckdb_Logical_Type
Declare Function duckdb_get_blob(ByVal val_ As Duckdb_Value) As Duckdb_Blob
Declare Function duckdb_get_varchar(ByVal value As Duckdb_Value) As ZString Ptr
Declare Function duckdb_create_struct_value(ByVal type_ As Duckdb_Logical_Type, ByVal values As Duckdb_Value Ptr) As Duckdb_Value
Declare Function duckdb_create_list_value(ByVal type_ As Duckdb_Logical_Type, ByVal values As Duckdb_Value Ptr, ByVal value_count As ULongInt) As Duckdb_Value
Declare Function duckdb_create_array_value(ByVal type_ As Duckdb_Logical_Type, ByVal values As Duckdb_Value Ptr, ByVal value_count As ULongInt) As Duckdb_Value
Declare Function duckdb_get_map_size(ByVal value As Duckdb_Value) As ULongInt
Declare Function duckdb_get_map_key(ByVal value As Duckdb_Value, ByVal index As ULongInt) As Duckdb_Value
Declare Function duckdb_get_map_value(ByVal value As Duckdb_Value, ByVal index As ULongInt) As Duckdb_Value
Declare Function duckdb_create_logical_type(ByVal type_ As Duckdb_Type) As Duckdb_Logical_Type
Declare Function duckdb_logical_type_get_alias(ByVal type_ As Duckdb_Logical_Type) As ZString Ptr
Declare Sub duckdb_logical_type_set_alias(ByVal type_ As Duckdb_Logical_Type, ByVal alias As Const ZString Ptr)
Declare Function duckdb_create_list_type(ByVal type_ As Duckdb_Logical_Type) As Duckdb_Logical_Type
Declare Function duckdb_create_array_type(ByVal type_ As Duckdb_Logical_Type, ByVal array_size As ULongInt) As Duckdb_Logical_Type
Declare Function duckdb_create_map_type(ByVal key_type As Duckdb_Logical_Type, ByVal value_type As Duckdb_Logical_Type) As Duckdb_Logical_Type
Declare Function duckdb_create_union_type(ByVal member_types As Duckdb_Logical_Type Ptr, ByVal member_names As Const ZString Ptr Ptr, ByVal member_count As ULongInt) As Duckdb_Logical_Type
Declare Function duckdb_create_struct_type(ByVal member_types As Duckdb_Logical_Type Ptr, ByVal member_names As Const ZString Ptr Ptr, ByVal member_count As ULongInt) As Duckdb_Logical_Type
Declare Function duckdb_create_enum_type(ByVal member_names As Const ZString Ptr Ptr, ByVal member_count As ULongInt) As Duckdb_Logical_Type
Declare Function duckdb_create_decimal_type(ByVal width As UByte, ByVal scale As UByte) As Duckdb_Logical_Type
Declare Function duckdb_get_type_id(ByVal type_ As Duckdb_Logical_Type) As Duckdb_Type
Declare Function duckdb_decimal_width(ByVal type_ As Duckdb_Logical_Type) As UByte
Declare Function duckdb_decimal_scale(ByVal type_ As Duckdb_Logical_Type) As UByte
Declare Function duckdb_decimal_internal_type(ByVal type_ As Duckdb_Logical_Type) As Duckdb_Type
Declare Function duckdb_enum_internal_type(ByVal type_ As Duckdb_Logical_Type) As Duckdb_Type
Declare Function duckdb_enum_dictionary_size(ByVal type_ As Duckdb_Logical_Type) As ULong
Declare Function duckdb_enum_dictionary_value(ByVal type_ As Duckdb_Logical_Type, ByVal index As ULongInt) As ZString Ptr
Declare Function duckdb_list_type_child_type(ByVal type_ As Duckdb_Logical_Type) As Duckdb_Logical_Type
Declare Function duckdb_array_type_child_type(ByVal type_ As Duckdb_Logical_Type) As Duckdb_Logical_Type
Declare Function duckdb_array_type_array_size(ByVal type_ As Duckdb_Logical_Type) As ULongInt
Declare Function duckdb_map_type_key_type(ByVal type_ As Duckdb_Logical_Type) As Duckdb_Logical_Type
Declare Function duckdb_map_type_value_type(ByVal type_ As Duckdb_Logical_Type) As Duckdb_Logical_Type
Declare Function duckdb_struct_type_child_count(ByVal type_ As Duckdb_Logical_Type) As ULongInt
Declare Function duckdb_struct_type_child_name(ByVal type_ As Duckdb_Logical_Type, ByVal index As ULongInt) As ZString Ptr
Declare Function duckdb_struct_type_child_type(ByVal type_ As Duckdb_Logical_Type, ByVal index As ULongInt) As Duckdb_Logical_Type
Declare Function duckdb_union_type_member_count(ByVal type_ As Duckdb_Logical_Type) As ULongInt
Declare Function duckdb_union_type_member_name(ByVal type_ As Duckdb_Logical_Type, ByVal index As ULongInt) As ZString Ptr
Declare Function duckdb_union_type_member_type(ByVal type_ As Duckdb_Logical_Type, ByVal index As ULongInt) As Duckdb_Logical_Type
Declare Sub duckdb_destroy_logical_type(ByVal type_ As Duckdb_Logical_Type Ptr)
Declare Function duckdb_register_logical_type(ByVal con As Duckdb_connection, ByVal type_ As Duckdb_Logical_Type, ByVal info As Duckdb_Create_Type_Info) As Duckdb_State
Declare Function duckdb_create_data_chunk(ByVal types As Duckdb_Logical_Type Ptr, ByVal column_count As ULongInt) As Duckdb_Data_Chunk
Declare Sub duckdb_destroy_data_chunk(ByVal chunk As Duckdb_Data_Chunk Ptr)
Declare Sub duckdb_data_chunk_reset(ByVal chunk As Duckdb_Data_Chunk)
Declare Function duckdb_data_chunk_get_column_count(ByVal chunk As Duckdb_Data_Chunk) As ULongInt
Declare Function duckdb_data_chunk_get_vector(ByVal chunk As Duckdb_Data_Chunk, ByVal col_idx As ULongInt) As Duckdb_Vector
Declare Function duckdb_data_chunk_get_size(ByVal chunk As Duckdb_Data_Chunk) As ULongInt
Declare Sub duckdb_data_chunk_set_size(ByVal chunk As Duckdb_Data_Chunk, ByVal size As ULongInt)
Declare Function duckdb_vector_get_column_type(ByVal vector As Duckdb_Vector) As Duckdb_Logical_Type
Declare Function duckdb_vector_get_data(ByVal vector As Duckdb_Vector) As Any Ptr
Declare Function duckdb_vector_get_validity(ByVal vector As Duckdb_Vector) As ULongInt Ptr
Declare Sub duckdb_vector_ensure_validity_writable(ByVal vector As Duckdb_Vector)
Declare Sub duckdb_vector_assign_string_element(ByVal vector As Duckdb_Vector, ByVal index As ULongInt, ByVal str_ As Const ZString Ptr)
Declare Sub duckdb_vector_assign_string_element_len(ByVal vector As Duckdb_Vector, ByVal index As ULongInt, ByVal str_ As Const ZString Ptr, ByVal str_len As ULongInt)
Declare Function duckdb_list_vector_get_child(ByVal vector As Duckdb_Vector) As Duckdb_Vector
Declare Function duckdb_list_vector_get_size(ByVal vector As Duckdb_Vector) As ULongInt
Declare Function duckdb_list_vector_set_size(ByVal vector As Duckdb_Vector, ByVal size As ULongInt) As Duckdb_State
Declare Function duckdb_list_vector_reserve(ByVal vector As Duckdb_Vector, ByVal required_capacity As ULongInt) As Duckdb_State
Declare Function duckdb_struct_vector_get_child(ByVal vector As Duckdb_Vector, ByVal index As ULongInt) As Duckdb_Vector
Declare Function duckdb_array_vector_get_child(ByVal vector As Duckdb_Vector) As Duckdb_Vector
Declare Function duckdb_validity_row_is_valid(ByVal validity As ULongInt Ptr, ByVal row As ULongInt) As Boolean
Declare Sub duckdb_validity_set_row_validity(ByVal validity As ULongInt Ptr, ByVal row As ULongInt, ByVal valid As Boolean)
Declare Sub duckdb_validity_set_row_invalid(ByVal validity As ULongInt Ptr, ByVal row As ULongInt)
Declare Sub duckdb_validity_set_row_valid(ByVal validity As ULongInt Ptr, ByVal row As ULongInt)
Declare Function duckdb_create_scalar_function() As Duckdb_Scalar_Function
Declare Sub duckdb_destroy_scalar_function(ByVal scalar_function As Duckdb_Scalar_Function Ptr)
Declare Sub duckdb_scalar_function_set_name(ByVal scalar_function As Duckdb_Scalar_Function, ByVal name_ As Const ZString Ptr)
Declare Sub duckdb_scalar_function_set_varargs(ByVal scalar_function As Duckdb_Scalar_Function, ByVal type_ As Duckdb_Logical_Type)
Declare Sub duckdb_scalar_function_set_special_handling(ByVal scalar_function As Duckdb_Scalar_Function)
Declare Sub duckdb_scalar_function_set_volatile(ByVal scalar_function As Duckdb_Scalar_Function)
Declare Sub duckdb_scalar_function_add_parameter(ByVal scalar_function As Duckdb_Scalar_Function, ByVal type_ As Duckdb_Logical_Type)
Declare Sub duckdb_scalar_function_set_return_type(ByVal scalar_function As Duckdb_Scalar_Function, ByVal type_ As Duckdb_Logical_Type)
Declare Sub duckdb_scalar_function_set_extra_info(ByVal scalar_function As Duckdb_Scalar_Function, ByVal extra_info As Any Ptr, ByVal destroy As Duckdb_Delete_Callback_t)
Declare Sub duckdb_scalar_function_set_function(ByVal scalar_function As Duckdb_Scalar_Function, ByVal function As Duckdb_Scalar_Function_t)
Declare Function duckdb_register_scalar_function(ByVal con As Duckdb_connection, ByVal scalar_function As Duckdb_Scalar_Function) As Duckdb_State
Declare Function duckdb_scalar_function_get_extra_info(ByVal info As Duckdb_Function_info) As Any Ptr
Declare Sub duckdb_scalar_function_set_error(ByVal info As Duckdb_Function_info, ByVal error_ As Const ZString Ptr)
Declare Function duckdb_create_scalar_function_set(ByVal name_ As Const ZString Ptr) As Duckdb_Scalar_Function_Set
Declare Sub duckdb_destroy_scalar_function_set(ByVal scalar_function_set As Duckdb_Scalar_Function_Set Ptr)
Declare function duckdb_add_scalar_function_to_set(ByVal set As Duckdb_Scalar_Function_Set, ByVal function As Duckdb_Scalar_Function) As Duckdb_State
Declare Function duckdb_register_scalar_function_set(ByVal con As Duckdb_connection, ByVal set As Duckdb_Scalar_Function_Set) As Duckdb_State
Declare Function duckdb_create_aggregate_function() As Duckdb_Aggregate_Function
Declare Sub duckdb_destroy_aggregate_function(ByVal aggregate_function As Duckdb_Aggregate_Function Ptr)
Declare Sub duckdb_aggregate_function_set_name(ByVal aggregate_function As Duckdb_Aggregate_Function, ByVal name_ As Const ZString Ptr)
Declare Sub duckdb_aggregate_function_add_parameter(ByVal aggregate_function As Duckdb_Aggregate_Function, ByVal type_ As Duckdb_Logical_Type)
Declare Sub duckdb_aggregate_function_set_return_type(ByVal aggregate_function As Duckdb_Aggregate_Function, ByVal type_ As Duckdb_Logical_Type)
Declare Sub duckdb_aggregate_function_set_functions(ByVal aggregate_function As Duckdb_Aggregate_Function, ByVal state_size As Duckdb_Aggregate_State_size, ByVal state_init As Duckdb_Aggregate_Init_t, ByVal update As Duckdb_Aggregate_Update_t, ByVal combine As Duckdb_Aggregate_Combine_t, ByVal finalize As Duckdb_Aggregate_Finalize_t)
Declare Sub duckdb_aggregate_function_set_destructor(ByVal aggregate_function As Duckdb_Aggregate_Function, ByVal destroy As Duckdb_Aggregate_Destroy_t)
Declare Function duckdb_register_aggregate_function(ByVal con As Duckdb_connection, ByVal aggregate_function As Duckdb_Aggregate_Function) As Duckdb_State
Declare Sub duckdb_aggregate_function_set_special_handling(ByVal aggregate_function As Duckdb_Aggregate_Function)
Declare Sub duckdb_aggregate_function_set_extra_info(ByVal aggregate_function As Duckdb_Aggregate_Function, ByVal extra_info As Any Ptr, ByVal destroy As Duckdb_Delete_Callback_t)
Declare Function duckdb_aggregate_function_get_extra_info(ByVal info As Duckdb_Function_info) As Any Ptr
Declare Sub duckdb_aggregate_function_set_error(ByVal info As Duckdb_Function_info, ByVal error_ As Const ZString Ptr)
Declare Function duckdb_create_aggregate_function_set(ByVal name_ As Const ZString Ptr) As Duckdb_Aggregate_Function_Set
Declare Sub duckdb_destroy_aggregate_function_set(ByVal aggregate_function_set As Duckdb_Aggregate_Function_Set Ptr)
Declare function duckdb_add_aggregate_function_to_set(ByVal set As Duckdb_Aggregate_Function_Set, ByVal function As Duckdb_Aggregate_Function) As Duckdb_State
Declare Function duckdb_register_aggregate_function_set(ByVal con As Duckdb_connection, ByVal set As Duckdb_Aggregate_Function_Set) As Duckdb_State
Declare Function duckdb_create_table_function() As Duckdb_Table_Function
Declare Sub duckdb_destroy_table_function(ByVal table_function As Duckdb_Table_Function Ptr)
Declare Sub duckdb_table_function_set_name(ByVal table_function As Duckdb_Table_Function, ByVal name_ As Const ZString Ptr)
Declare Sub duckdb_table_function_add_parameter(ByVal table_function As Duckdb_Table_Function, ByVal type_ As Duckdb_Logical_Type)
Declare Sub duckdb_table_function_add_named_parameter(ByVal table_function As Duckdb_Table_Function, ByVal name_ As Const ZString Ptr, ByVal type_ As Duckdb_Logical_Type)
Declare Sub duckdb_table_function_set_extra_info(ByVal table_function As Duckdb_Table_Function, ByVal extra_info As Any Ptr, ByVal destroy As Duckdb_Delete_Callback_t)
Declare Sub duckdb_table_function_set_bind(ByVal table_function As Duckdb_Table_Function, ByVal bind As Duckdb_Table_Function_Bind_t)
Declare Sub duckdb_table_function_set_init(ByVal table_function As Duckdb_Table_Function, ByVal init As Duckdb_Table_Function_Init_t)
Declare Sub duckdb_table_function_set_local_init(ByVal table_function As Duckdb_Table_Function, ByVal init As Duckdb_Table_Function_Init_t)
Declare Sub duckdb_table_function_set_function(ByVal table_function As Duckdb_Table_Function, ByVal function As Duckdb_Table_Function_t)
Declare Sub duckdb_table_function_supports_projection_pushdown(ByVal table_function As Duckdb_Table_Function, ByVal pushdown As Boolean)
Declare function duckdb_register_table_function(ByVal con As Duckdb_connection, ByVal function As Duckdb_Table_Function) As Duckdb_State
Declare Function duckdb_bind_get_extra_info(ByVal info As Duckdb_Bind_Info) As Any Ptr
Declare Sub duckdb_bind_add_result_column(ByVal info As Duckdb_Bind_Info, ByVal name_ As Const ZString Ptr, ByVal type_ As Duckdb_Logical_Type)
Declare Function duckdb_bind_get_parameter_count(ByVal info As Duckdb_Bind_Info) As ULongInt
Declare Function duckdb_bind_get_parameter(ByVal info As Duckdb_Bind_Info, ByVal index As ULongInt) As Duckdb_Value
Declare Function duckdb_bind_get_named_parameter(ByVal info As Duckdb_Bind_Info, ByVal name_ As Const ZString Ptr) As Duckdb_Value
Declare Sub duckdb_bind_set_bind_data(ByVal info As Duckdb_Bind_Info, ByVal bind_data As Any Ptr, ByVal destroy As Duckdb_Delete_Callback_t)
Declare Sub duckdb_bind_set_cardinality(ByVal info As Duckdb_Bind_Info, ByVal cardinality As ULongInt, ByVal is_exact As Boolean)
Declare Sub duckdb_bind_set_error(ByVal info As Duckdb_Bind_Info, ByVal error_ As Const ZString Ptr)
Declare Function duckdb_init_get_extra_info(ByVal info As Duckdb_Init_Info) As Any Ptr
Declare Function duckdb_init_get_bind_data(ByVal info As Duckdb_Init_Info) As Any Ptr
Declare Sub duckdb_init_set_init_data(ByVal info As Duckdb_Init_Info, ByVal init_data As Any Ptr, ByVal destroy As Duckdb_Delete_Callback_t)
Declare Function duckdb_init_get_column_count(ByVal info As Duckdb_Init_Info) As ULongInt
Declare Function duckdb_init_get_column_index(ByVal info As Duckdb_Init_Info, ByVal column_index As ULongInt) As ULongInt
Declare Sub duckdb_init_set_max_threads(ByVal info As Duckdb_Init_Info, ByVal max_threads As ULongInt)
Declare Sub duckdb_init_set_error(ByVal info As Duckdb_Init_Info, ByVal error_ As Const ZString Ptr)
Declare Function duckdb_function_get_extra_info(ByVal info As Duckdb_Function_info) As Any Ptr
Declare Function duckdb_function_get_bind_data(ByVal info As Duckdb_Function_info) As Any Ptr
Declare Function duckdb_function_get_init_data(ByVal info As Duckdb_Function_info) As Any Ptr
Declare Function duckdb_function_get_local_init_data(ByVal info As Duckdb_Function_info) As Any Ptr
Declare Sub duckdb_function_set_error(ByVal info As Duckdb_Function_info, ByVal error_ As Const ZString Ptr)
Declare Sub duckdb_add_replacement_scan(ByVal db As Duckdb_Database, ByVal replacement As Duckdb_Replacement_Callback_t, ByVal extra_data As Any Ptr, ByVal delete_callback As Duckdb_Delete_Callback_t)
Declare Sub duckdb_replacement_scan_set_function_name(ByVal info As Duckdb_Replacement_Scan_info, ByVal function_name As Const ZString Ptr)
Declare Sub duckdb_replacement_scan_add_parameter(ByVal info As Duckdb_Replacement_Scan_info, ByVal parameter As Duckdb_Value)
Declare Sub duckdb_replacement_scan_set_error(ByVal info As Duckdb_Replacement_Scan_info, ByVal error_ As Const ZString Ptr)
Declare Function duckdb_get_profiling_info(ByVal connection As Duckdb_connection) As Duckdb_Profiling_Info
Declare Function duckdb_profiling_info_get_value(ByVal info As Duckdb_Profiling_Info, ByVal key As Const ZString Ptr) As Duckdb_Value
Declare Function duckdb_profiling_info_get_metrics(ByVal info As Duckdb_Profiling_Info) As Duckdb_Value
Declare Function duckdb_profiling_info_get_child_count(ByVal info As Duckdb_Profiling_Info) As ULongInt
Declare Function duckdb_profiling_info_get_child(ByVal info As Duckdb_Profiling_Info, ByVal index As ULongInt) As Duckdb_Profiling_Info
Declare Function duckdb_appender_create(ByVal connection As Duckdb_connection, ByVal schema As Const ZString Ptr, ByVal table As Const ZString Ptr, ByVal out_appender As Duckdb_Appender Ptr) As Duckdb_State
Declare Function duckdb_appender_column_count(ByVal appender As Duckdb_Appender) As ULongInt
Declare Function duckdb_appender_column_type(ByVal appender As Duckdb_Appender, ByVal col_idx As ULongInt) As Duckdb_Logical_Type
Declare Function duckdb_appender_error(ByVal appender As Duckdb_Appender) As Const ZString Ptr
Declare Function duckdb_appender_flush(ByVal appender As DuckDB_Appender) As Duckdb_State
Declare Function duckdb_appender_close(ByVal appender As DuckDB_Appender) As Duckdb_State
Declare Function duckdb_appender_destroy(ByVal appender As DuckDB_Appender Ptr) As Duckdb_State
Declare Function duckdb_appender_begin_row(ByVal appender As DuckDB_Appender) As Duckdb_State
Declare Function duckdb_appender_end_row(ByVal appender As DuckDB_Appender) As Duckdb_State
Declare Function duckdb_append_default(ByVal appender As DuckDB_Appender) As Duckdb_State
Declare Function duckdb_append_bool(ByVal appender As DuckDB_Appender, ByVal value As Boolean) As Duckdb_State
Declare Function duckdb_append_int8(ByVal appender As DuckDB_Appender, ByVal value As Byte) As Duckdb_State
Declare Function duckdb_append_int16(ByVal appender As DuckDB_Appender, ByVal value As Short) As Duckdb_State
Declare Function duckdb_append_int32(ByVal appender As DuckDB_Appender, ByVal value As Long) As Duckdb_State
Declare Function duckdb_append_int64(ByVal appender As DuckDB_Appender, ByVal value As LongInt) As Duckdb_State
Declare Function duckdb_append_hugeint(ByVal appender As DuckDB_Appender, ByVal value As DuckDB_HugeInt) As Duckdb_State
Declare Function duckdb_append_uint8(ByVal appender As DuckDB_Appender, ByVal value As UByte) As Duckdb_State
Declare Function duckdb_append_uint16(ByVal appender As DuckDB_Appender, ByVal value As UShort) As Duckdb_State
Declare Function duckdb_append_uint32(ByVal appender As DuckDB_Appender, ByVal value As ULong) As Duckdb_State
Declare Function duckdb_append_uint64(ByVal appender As DuckDB_Appender, ByVal value As ULongInt) As Duckdb_State
Declare Function duckdb_append_uhugeint(ByVal appender As DuckDB_Appender, ByVal value As DuckDB_UHugeInt) As Duckdb_State
Declare Function duckdb_append_float(ByVal appender As DuckDB_Appender, ByVal value As Single) As Duckdb_State
Declare Function duckdb_append_double(ByVal appender As DuckDB_Appender, ByVal value As Double) As Duckdb_State
Declare Function duckdb_append_date(ByVal appender As DuckDB_Appender, ByVal value As DuckDB_Date) As Duckdb_State
Declare Function duckdb_append_time(ByVal appender As DuckDB_Appender, ByVal value As DuckDB_Time) As Duckdb_State
Declare Function duckdb_append_timestamp(ByVal appender As DuckDB_Appender, ByVal value As DuckDB_Timestamp) As Duckdb_State
Declare Function duckdb_append_interval(ByVal appender As DuckDB_Appender, ByVal value As DuckDB_Interval) As Duckdb_State
Declare Function duckdb_append_varchar(ByVal appender As DuckDB_Appender, ByVal val_ As Const ZString Ptr) As Duckdb_State
Declare Function duckdb_append_varchar_length(ByVal appender As DuckDB_Appender, ByVal val_ As Const ZString Ptr, ByVal length As ULongInt) As Duckdb_State
Declare Function duckdb_append_blob(ByVal appender As DuckDB_Appender, ByVal data_ As Const Any Ptr, ByVal length As ULongInt) As Duckdb_State
Declare Function duckdb_append_null(ByVal appender As DuckDB_Appender) As Duckdb_State
Declare Function duckdb_append_data_chunk(ByVal appender As DuckDB_Appender, ByVal chunk As DuckDB_Data_Chunk) As Duckdb_State
Declare Function duckdb_table_description_create(ByVal connection As DuckDB_connection, ByVal schema As Const ZString Ptr, ByVal table As Const ZString Ptr, ByVal out_ As DuckDB_Table_Description Ptr) As Duckdb_State
Declare Sub duckdb_table_description_destroy(ByVal table_description As DuckDB_Table_Description Ptr)
Declare Function duckdb_table_description_error(ByVal table_description As DuckDB_Table_Description) As Const ZString Ptr
Declare Function duckdb_column_has_default(ByVal table_description As DuckDB_Table_Description, ByVal index As ULongInt, ByVal out_ As Boolean) As Duckdb_State
Declare Function duckdb_query_arrow(ByVal connection As DuckDB_connection, ByVal query As Const ZString Ptr, ByVal out_result As DuckDB_Arrow Ptr) As Duckdb_State
Declare Function duckdb_query_arrow_schema(ByVal result As DuckDB_Arrow, ByVal out_schema As DuckDB_Arrow_Schema Ptr) As Duckdb_State
Declare Function duckdb_prepared_arrow_schema(ByVal prepared As DuckDB_Prepared_Statement, ByVal out_schema As DuckDB_Arrow_Schema Ptr) As Duckdb_State
Declare Sub duckdb_result_arrow_array(ByVal result As DuckDB_result, ByVal chunk As DuckDB_Data_Chunk, ByVal out_array As DuckDB_Arrow_Array Ptr)
Declare Function duckdb_query_arrow_array(ByVal result As DuckDB_Arrow, ByVal out_array As DuckDB_Arrow_Array Ptr) As Duckdb_State
Declare Function duckdb_arrow_column_count(ByVal result As DuckDB_Arrow) As ULongInt
Declare Function duckdb_arrow_row_count(ByVal result As DuckDB_Arrow) As ULongInt
Declare Function duckdb_arrow_rows_changed(ByVal result As DuckDB_Arrow) As ULongInt
Declare Function duckdb_query_arrow_error(ByVal result As DuckDB_Arrow) As Const ZString Ptr
Declare Sub duckdb_destroy_arrow(ByVal result As DuckDB_Arrow Ptr)
Declare Sub duckdb_destroy_arrow_stream(ByVal stream_p As DuckDB_Arrow_Stream Ptr)
Declare Function duckdb_execute_prepared_arrow(ByVal prepared_statement As DuckDB_Prepared_Statement, ByVal out_result As DuckDB_Arrow Ptr) As Duckdb_State
Declare Function duckdb_arrow_scan(ByVal connection As DuckDB_connection, ByVal table_name As Const ZString Ptr, ByVal arrow As DuckDB_Arrow_Stream) As Duckdb_State
Declare Function duckdb_arrow_array_scan(ByVal connection As DuckDB_connection, ByVal table_name As Const ZString Ptr, ByVal arrow_schema As DuckDB_Arrow_Schema, ByVal arrow_array As DuckDB_Arrow_Array, ByVal out_stream As DuckDB_Arrow_Stream Ptr) As Duckdb_State
Declare Sub duckdb_execute_tasks(ByVal database As DuckDB_Database, ByVal max_tasks As ULongInt)
Declare Function duckdb_create_task_state(ByVal database As DuckDB_Database) As DuckDB_Task_State
Declare Sub duckdb_execute_tasks_state(ByVal state As DuckDB_Task_State)
Declare Function duckdb_execute_n_tasks_state(ByVal state As DuckDB_Task_State, ByVal max_tasks As ULongInt) As ULongInt
Declare Sub duckdb_finish_execution(ByVal state As DuckDB_Task_State)
Declare Function duckdb_task_state_is_finished(ByVal state As DuckDB_Task_State) As Boolean
Declare Sub duckdb_destroy_task_state(ByVal state As DuckDB_Task_State)
Declare Function duckdb_execution_is_finished(ByVal con As DuckDB_connection) As Boolean
Declare Function duckdb_stream_fetch_chunk(ByVal result As DuckDB_result) As DuckDB_Data_Chunk
Declare Function duckdb_fetch_chunk(ByVal result As DuckDB_result) As DuckDB_Data_Chunk
Declare Function duckdb_create_cast_function() As DuckDB_Cast_Function
Declare Sub duckdb_cast_function_set_source_type(ByVal cast_function As DuckDB_Cast_Function, ByVal source_type As DuckDB_Logical_Type)
Declare Sub duckdb_cast_function_set_target_type(ByVal cast_function As DuckDB_Cast_Function, ByVal target_type As DuckDB_Logical_Type)
Declare Sub duckdb_cast_function_set_implicit_cast_cost(ByVal cast_function As DuckDB_Cast_Function, ByVal cost As LongInt)
Declare Sub duckdb_cast_function_set_function(ByVal cast_function As DuckDB_Cast_Function, ByVal function As DuckDB_Cast_Function_t)
Declare Sub duckdb_cast_function_set_extra_info(ByVal cast_function As DuckDB_Cast_Function, ByVal extra_info As Any Ptr, ByVal destroy As DuckDB_Delete_Callback_t)
Declare Function duckdb_cast_function_get_extra_info(ByVal info As DuckDB_Function_info) As Any Ptr
Declare Function duckdb_cast_function_get_cast_mode(ByVal info As DuckDB_Function_info) As Duckdb_Cast_Mode
Declare Sub duckdb_cast_function_set_error(ByVal info As DuckDB_Function_info, ByVal error_ As Const ZString Ptr)
Declare Sub duckdb_cast_function_set_row_error(ByVal info As DuckDB_Function_info, ByVal error_ As Const ZString Ptr, ByVal row As ULongInt, ByVal output As DuckDB_Vector)
Declare Function duckdb_register_cast_function(ByVal con As DuckDB_connection, ByVal cast_function As DuckDB_Cast_Function) As Duckdb_State
Declare Sub duckdb_destroy_cast_function(ByVal cast_function As DuckDB_Cast_Function Ptr)

End Extern
#endif
