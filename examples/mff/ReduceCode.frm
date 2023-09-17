'################################################################################
'#  ReduceCode.frm                                                                   #
'#  This file is an examples of MyFBFramework.                                  #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'################################################################################
'See Also
'https://www.freebasic.net/forum/viewtopic.php?t=28397&start=45

'#Region "Form"
	'#Region Off_Defines
		#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
			#define __MAIN_FILE__
			#ifdef __FB_WIN32__
				#cmdline "ReduceCode.rc"
			#endif
			Const _MAIN_FILE_ = __FILE__
		#endif
		
		#define ReadProperty_Off
		#define WriteProperty_Off
		#define Application_Controls_Get_Off
		#define Application_ControlCount_Get_Off
		#define Application_DoEvents_Off
		'#define Application_GetVerInfo_Off
		#define Application_GetControls_Off
		'#define Application_Forms_Get_Off
		'#define Application_Title_Get_Off
		'#define BitmapType_Height_Get_Off
		#define BitmapType_Let_HBITMAP_Off
		#define BitmapType_Let_HICON_Off
		#define BitmapType_Let_WString_Off
		'#define BitmapType_LoadFromHICON_Off
		#define BitmapType_SaveToFile_Off
		'#define BitmapType_Width_Get_Off
		#define Brush_Color_Get_Off
		#define Canvas_DrawTransparent_Off
		#define Canvas_Rectangle_Double_Double_Double_Double_Off
		#define Canvas_TransferDoubleBuffer_Off
		#define Chart_AddAxisItems_Off
		#define Chart_AddItem_Off
		#define Chart_AddSerie_Off
		#define Chart_LabelsVisible_Get_Off
		#define Chart_LabelsVisible_Set_Off
		#define Chart_Wait_Off
		#define CommandButton_EnumMenuItems_Off
		#define CommandButton_Style_Get_Off
		'#define Component_GetTopLevel_Off
		'#define Component_Left_Set_Off
		'#define Component_Top_Set_Off
		#define Control_IndexOf_String_Off
		'#define Control_RecreateWnd_Off
		#define Control_ChangeControlIndex_Off
		#define Control_ChangeStyle_Off
		#define Control_ChangeTabStop_Off
		#define Control_GetTextLength_Off
		#define Control_StyleExists_Off
		#define Control_TopLevelControl_Off
		'#define Control_Parent_Set_Off
		#define Cursor_LoadFromFile_Off
		#define Cursor_LoadFromResourceID_Off
		#define Cursor_LoadFromResourceName_Off
		#define Cursor_SaveToFile_Off
		#define Debug_Print_Off
		#define Dictionary_Add_Off
		#define Dictionary_Count_Get_Off
		#define Dictionary_IndexOf_Off
		'#define Dictionary_IndexOfKey_Off
		#define Dictionary_IndexOfObject_Off
		#define Dictionary_Item_Get_Integer_Off
		#define Dictionary_Sort_Off
		#define Dictionary_SortKeys_Off
		#define Dictionary_Text_Get_Off
		#define Dictionary_Text_Set_Off
		'#define DictionaryItem_Key_Get_Off
		#define DictionaryItem_Text_Get_Off
		#define DoubleList_Add_Off
		#define DoubleList_Exchange_Off
		#define DoubleList_IndexOf_Off
		'#define Font_Color_Set_Off
		#define Form_ShowModal_Off
		#define GraphicType_LoadFromFile_Off
		#define GraphicType_LoadFromResourceID_Off
		#define GraphicType_LoadFromResourceName_Off
		#define Grid_ChangeLVExStyle_Off
		#define Grid_SelectedColumn_Off
		#define Grid_SelectedRow_Off
		'#define GridColumn_Format_Set_Off
		'#define GridColumn_ImageIndex_Set_Off
		'#define GridColumn_Width_Set_Off
		#define GridRow_ImageKey_Set_Off
		#define GridRow_ImageIndex_Set_Off
		#define GridRow_Indent_Set_Off
		'#define GridRow_Item_Off
		'#define GridRow_State_Set_Off
		#define GridRows_Add_Integer_Off
		#define GridRows_CompareFunc_Off
		#define Icon_Height_Get_Off
		#define Icon_LoadFromResourceID_Off
		#define Icon_LoadFromResourceName_Off
		#define Icon_ResName_Set_Off
		#define Icon_SaveToFile_Off
		#define Icon_Width_Get_Off
		#define ImageList_Add_WString_Off
		#define ImageList_AddFromFile_Off
		#define ImageList_Clear_Off
		#define ImageList_GetBitmap_Integer_Off
		#define ImageList_GetCursor_Integer_Off
		'#define ImageList_GetIcon_Integer_Off
		#define ImageList_GetMask_Integer_Off
		'#define ImageList_IndexOf_Off
		#define ImageList_Remove_Integer_Off
		'#define IntegerList_IndexOf_Off
		'#define List_Item_Set_Off
		#define LoadFromFile_Off
		#define MainHandle_Off
		#define Match_Off
		#define Menu_Color_Set_Off
		#define Menu_IndexOf_WString_Off
		#define Menu_Item_Set_MenuItem_Off
		#define MenuItem_IndexOf_WString_Off
		#define MenuItem_Insert_Off
		#define MenuItem_Find_WString_Off
		#define MenuItem_Image_Set_BitmapType_Off
		#define MenuItem_ImageIndex_Set_Off
		#define MenuItem_Name_Set_Off
		'#define Pen_Color_Get_Off
		#define Pen_Color_Set_Off
		'#define Pen_Create_Off
		#define Pen_Size_Set_Off
		'#define Replace_Off
		#define SaveToFile_Off
		#define StringParseCount_Off
		#define TextBox_InsertLine_Off
		#define TextBox_LinesCount_Off
		#define WAdd_Off
		'#define WStringList_Add_Off
		#define WStringList_IndexOf_Off
		#define WStringList_IndexOfObject_Off
		#define WStringList_MatchCase_Get_Off
		#define WStringList_Sort_Off
		#define WStringList_Text_Set_Off
	'#End Region
	#include once "mff/Form.bi"
	#include once "mff/TextBox.bi"
	#include once "mff/Chart.bi"
	#include once "mff/Grid.bi"
	#include once "mff/CommandButton.bi"
	
	Using My.Sys.Forms
	
	Type ReduceCodeType Extends Form
		Declare Constructor
		
		Dim As TextBox TextBox1
		Dim As CommandButton CommandButton1
	End Type
	
	Constructor ReduceCodeType
		' ReduceCode
		With This
			.Name = "ReduceCode"
			.Text = "ReduceCode"
			.Designer = @This
			.SetBounds 0, 0, 350, 300
		End With
		' TextBox1
		With TextBox1
			.Name = "TextBox1"
			.Text = "TextBox1"
			.TabIndex = 0
			.SetBounds 120, 60, 110, 60
			.Designer = @This
			.Parent = @This
		End With
		' CommandButton1
		With CommandButton1
			.Name = "CommandButton1"
			.Text = "CommandButton1"
			.TabIndex = 2
			.SetBounds 70, 180, 120, 60
			.Designer = @This
			.Parent = @This
		End With
	End Constructor
	
	Dim Shared ReduceCode As ReduceCodeType
	
	#if _MAIN_FILE_ = __FILE__
		ReduceCode.MainForm = True
		'ReduceCode.darkmode= True
		ReduceCode.Show
		App.Run
	#endif
'#End Region
