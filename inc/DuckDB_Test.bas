'################################################################################
'#  Duckdb_Test.bas                                                             #
'#  Authors: fan2006                                                            #
'#  Based on: the code posted on the freeBasic forum(www.freebasic.net/forum/   #
'#  See also：                                                                  #
'#   https://www.freebasic.net/forum/viewtopic.php?t=32986                      #
'#   https://github.com/duckdb/duckdb                                           #
'################################################################################
'Download the library duckdb.a and duckdb.dll files from the following address
'https://github.com/LukyGuyLucky/duckdb-Win-x64-mingw-lib
'#cmdline "-w none"
#include once "duckdb.bi"
#include once "mff/NoInterface.bi"
'#include once "crt/stdio.bi"

'only for amd64 test with no x86 lib provided in the github release,and the source code is  in a large size.
Dim db As duckdb_database = NULL
Dim con As duckdb_connection = NULL
Dim result As duckdb_result
If duckdb_open(NULL, @db) = DuckDBError Then
	Debug.Print "Failed to open database!"
	Goto cleanup
End If
If duckdb_connect(db, @con) = DuckDBError Then
	Debug.Print "Failed to open connection!"
	Goto cleanup
End If
If duckdb_query(con, "CREATE TABLE integers(i INTEGER, j INTEGER);", NULL) = DuckDBError Then
	Debug.Print "Failed to query database!"
	Goto cleanup
End If
If duckdb_query(con, "INSERT INTO integers VALUES (3, 4), (5, 6), (7, NULL);", NULL) = DuckDBError Then
	Debug.Print "Failed to query database!"
	Goto cleanup
End If
If duckdb_query(con, "SELECT * FROM integers", @result) = DuckDBError Then
	Debug.Print "Failed to query database!"
	Goto cleanup
End If
Scope ' If True Then
	Dim row_count As Long = duckdb_row_count(@result)
	Dim column_count As Long = duckdb_column_count(@result)
	Print "column_count " & column_count
	For i As UInteger = 0 To column_count -1
		Print WStr(*duckdb_column_name(@result, i)),
	Next
	Print
	For row_idx As UInteger = 0 To row_count - 1
		For col_idx As UInteger = 0 To column_count -1
			Dim As ZString Ptr ValuePtr = duckdb_value_varchar(@result, col_idx, row_idx)
			Print *ValuePtr,
			duckdb_free(ValuePtr)
		Next
		Print
	Next
End Scope '  End  If
cleanup:
duckdb_destroy_result(@result)
duckdb_disconnect(@con)
duckdb_close(@db)
Sleep(8000)
End
