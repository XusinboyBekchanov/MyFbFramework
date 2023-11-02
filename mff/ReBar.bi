'################################################################################
'#  ReBar.bi                                                                    #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#include once "ToolBar.bi"
#include once "Graphic.bi"
#include once "ContainerControl.bi"

Namespace My.Sys.Forms
	#define QReBar(__Ptr__) (*Cast(ReBar Ptr, __Ptr__))
	'#define REBAR_HEIGHT 35
	
	Private Enum GripperStyles
		Auto
		GripperAlways
		NoGripper
	End Enum
	
	Private Type PReBar As ReBar Ptr
	
	Private Type ReBarBand Extends My.Sys.Object
	Private:
		FBreak As Boolean
		FCaption As WString Ptr
		FChild As Control Ptr
		FChildEdge As Boolean
		FFixedBitmap As Boolean
		FFixedSize As Boolean
		FGripperStyle As GripperStyles
		FImageIndex As Integer
		FImageKey As WString Ptr
		FMinWidth As Integer
		FMinHeight As Integer
		FLeft As Integer
		FTop As Integer
		FWidth As Integer
		FHeight As Integer
		FIdealWidth As Integer
		FRequestedWidth As Integer
		FTopAlign As Boolean
		FTitleVisible As Boolean
		FVisible As Boolean
		FStyle As Integer
		Declare Sub ChangeStyle(iStyle As Integer, Value As Boolean)
	Public:
		Image As My.Sys.Drawing.BitmapType
		Parent   As PReBar
		Declare Property Break As Boolean
		Declare Property Break(Value As Boolean)
		Declare Property Caption ByRef As WString
		Declare Property Caption(ByRef Value As WString)
		Declare Property ChildEdge As Boolean
		Declare Property ChildEdge(Value As Boolean)
		Declare Property Child As Control Ptr
		Declare Property Child(Value As Control Ptr)
		Declare Property FixedBitmap As Boolean
		Declare Property FixedBitmap(Value As Boolean)
		Declare Property FixedSize As Boolean
		Declare Property FixedSize(Value As Boolean)
		Declare Property GripperStyle As GripperStyles
		Declare Property GripperStyle(Value As GripperStyles)
		Declare Property ImageIndex(Value As Integer)
		Declare Property ImageIndex As Integer
		Declare Property ImageKey ByRef As WString
		Declare Property ImageKey(ByRef Value As WString)
		Declare Property MinWidth As Integer
		Declare Property MinWidth(Value As Integer)
		Declare Property MinHeight As Integer
		Declare Property MinHeight(Value As Integer)
		Declare Property Left As Integer
		Declare Property Left(Value As Integer)
		Declare Property Top As Integer
		Declare Property Top(Value As Integer)
		Declare Property Width As Integer
		Declare Property Width(Value As Integer)
		Declare Property Height As Integer
		Declare Property Height(Value As Integer)
		Declare Property IdealWidth As Integer
		Declare Property IdealWidth(Value As Integer)
		Declare Property RequestedWidth As Integer
		Declare Property RequestedWidth(Value As Integer)
		Declare Property TopAlign As Boolean
		Declare Property TopAlign(Value As Boolean)
		Declare Property TitleVisible As Boolean
		Declare Property TitleVisible(Value As Boolean)
		Declare Property Visible As Boolean
		Declare Property Visible(Value As Boolean)
		Declare Property UseChevron As Boolean
		Declare Property UseChevron(Value As Boolean)
		Declare Property Index As Integer
		Declare Property Index(Value As Integer)
		Declare Function GetRect As My.Sys.Drawing.Rect
		
		Declare Sub Maximize
		Declare Sub Minimize
		Declare Sub Update(Create As Boolean = False)
		Declare Constructor
		Declare Destructor
	End Type
	
	Private Type ReBarBandCollection
	Private:
		FItems As List
	Public:
		Parent   As PReBar
		Declare Function Count As Integer
		Declare Property Item(Index As Integer) As ReBarBand Ptr
		Declare Property Item(Index As Integer, Value As ReBarBand Ptr)
		Declare Function Add(Value As Control Ptr, ByRef Caption As WString = "", ImageIndex As Integer = 0, Index As Integer = -1) As ReBarBand Ptr
		Declare Function Add(Value As Control Ptr, ByRef Caption As WString = "", ByRef ImageKey As WString, Index As Integer = -1) As ReBarBand Ptr
		Declare Sub Remove(Index As Integer)
		Declare Sub Move(OldIndex As Integer, NewIndex As Integer)
		Declare Sub Clear
		Declare Function IndexOf(Value As ReBarBand Ptr) As Integer
		Declare Function IndexOf(Value As Control Ptr) As Integer
		Declare Function Contains(Value As ReBarBand Ptr) As Boolean
		Declare Function Contains(Value As Control Ptr) As Boolean
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	'A Rebar control acts as a container for child windows. It can contain one or more bands, and each band can have any combination of a gripper bar, a bitmap, a text label, and one child window.
	Private Type ReBar Extends ContainerControl
	Private:
		FAutoSize As Boolean
		FRowCount As Integer
		Declare Static Sub GraphicChange(ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)    ' Handle to the popup menu
		#ifdef __USE_GTK__
			Declare Static Sub Layout_SizeAllocate(widget As GtkWidget Ptr, allocation As GdkRectangle Ptr, user_data As Any Ptr)
			Declare Static Function Layout_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Declare Static Function Layout_ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
		#else
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#endif
		FReBarDarkMode As Boolean
	Protected:
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		#ifdef __USE_GTK__
			Dim As Boolean InRect
			Dim As Boolean bPressed, bWithoutUpdate
			Dim As Integer DraggedItem, OldX
			Dim As cairo_t Ptr cr
			Dim As GdkWindow Ptr win
			Dim As GdkDisplay Ptr pdisplay
			Dim As GdkCursor Ptr gdkCursorDefault
			Dim As GdkCursor Ptr gdkCursorWEResize
			Dim As GdkCursor Ptr gdkCursorColResize
		#endif
	Public:
		#ifndef ReadProperty_Off
			Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Bands           As ReBarBandCollection
		ImageList       As ImageList Ptr                                                                                        ' One image per band
		ImageBacking    As My.Sys.Drawing.BitmapType                                                                            ' Bitmap used for backing image
		Declare Property AutoSize As Boolean
		Declare Property AutoSize(Value As Boolean)
		Declare Sub Add(Ctrl As Control Ptr, Index As Integer = -1)
		Declare Sub UpdateReBar()
		Declare Function RowCount As Integer
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		OnHeightChange  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ReBar)
		OnPopup         As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ReBar, Index As Integer)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "ReBar.bas"
#endif
