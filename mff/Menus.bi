'###############################################################################
'#  Menus.bi                                                                   #
'#  TMenuItem, TMainMenu, TPopupMenu                                           #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   Menus.bi                                                                  #
'#   TMenuItem, TMainMenu, TPopupMenu                                          #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "Component.bi"
#include once "ImageList.bi"
#ifdef __USE_WINAPI__
	#include once "win/uxtheme.bi"
#endif

#ifdef __USE_GTK__
	Dim Shared As GdkPixbuf Ptr EmptyPixbuf
	EmptyPixbuf = gdk_pixbuf_new (GDK_COLORSPACE_RGB, True, 8, 16, 16)
	gdk_pixbuf_fill(EmptyPixbuf, 0)
#else
	'	Type BP_PAINTPARAMS
	'        cbSize As DWORD
	'        dwFlags As DWORD
	'        prcExclude As Const RECT Ptr
	'        pBlendFunction As Const BLENDFUNCTION Ptr
	'    End Type
#endif

Using My.Sys.ComponentModel

Namespace My.Sys.Forms
	Private Type PMenu      As Menu Ptr
	Private Type PMainMenu  As MainMenu Ptr
	Private Type PPopupMenu As PopupMenu Ptr
	Private Type PMenuItem  As MenuItem Ptr
	
	#define QMenuItem(__Ptr__)  *Cast(PMenuItem,__Ptr__)
	#define QMenu(__Ptr__)      *Cast(PMenu,__Ptr__)
	#define QPopupMenu(__Ptr__) *Cast(PPopupMenu,__Ptr__)
	#define QMainMenu(__Ptr__)     *Cast(PMainMenu,__Ptr__)
	
	Const MIM_BACKGROUND      = &H2
	Const MIM_APPLYTOSUBMENUS = &H80000000
	Const MIM_MENUDATA        = &H00000008
	
	Private Type MenuItem Extends My.Sys.Object
	Private:
		Declare Static Sub BitmapChanged(ByRef Sender As My.Sys.Drawing.BitmapType)
		#ifdef __USE_WINAPI__
			FInfo	    	As MENUITEMINFO
		#endif
		FCount		    	As Integer
		FItems          	As PMenuItem Ptr
		FCaption		    As WString Ptr
		pCaption            As WString Ptr
		FText			    As WString Ptr
		FAccelerator	    As WString Ptr
		FChecked		    As Boolean
		FRadioItem		    As Boolean
		FParentMenuItem     As PMenuItem
		FEnabled		    As Boolean
		FVisible		    As Boolean
		FCommand		    As Integer
		FMenuIndex		    As Integer
		FImage			    As My.Sys.Drawing.BitmapType
		FImageIndex		    As Integer
		FImageKey		    As WString Ptr
		FOwnerDraw		    As Integer
	Protected:
		#ifdef __USE_WINAPI__
			FHandle		    As HMENU
			'FMenu  		As HMENU
		#endif
		FName			    As WString Ptr
		FOwner			    As PMenu
		FMenuItemChecked    As Boolean
		Declare Sub ChangeIndex(value As PMenuItem, Index As Integer)
	Public:
		Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Tag As Any Ptr
		SubMenu As PPopupMenu
		#ifdef __USE_WINAPI__
			'declare property Menu as HMENU
			'declare property Menu(value as HMENU)
			Declare Property Handle As HMENU
			Declare Property Handle(value As HMENU)
			Declare Sub SetInfo(ByRef value As MENUITEMINFO)
			Declare Sub SetItemInfo(ByRef value As MENUITEMINFO)
		#elseif defined(__USE_GTK__)
			accelerator_key As guint
			accelerator_mods As GdkModifierType
			Box				As GtkWidget Ptr
			Icon			As GtkWidget Ptr
			Label			As GtkWidget Ptr
			Widget 			As GtkWidget Ptr
			Declare Static Sub MenuItemActivate(MenuItem As GtkMenuItem Ptr, user_data As Any Ptr)
			Declare Static Function MenuItemButtonPressEvent(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
		#endif
		Declare Property Owner As PMenu
		Declare Property Owner(value As PMenu)
		Declare Property Name ByRef As WString
		Declare Property Name(ByRef value As WString)
		Declare Property Parent As My.Sys.Object Ptr
		Declare Property Parent(value As My.Sys.Object Ptr)
		Declare Property ParentMenu As PMenu
		Declare Property ParentMenu(value As PMenu)
		Declare Property ParentMenuItem As PMenuItem
		Declare Property ParentMenuItem(value As PMenuItem)
		Declare Property Command As Integer
		Declare Property Command(value As Integer)
		Declare Property MenuIndex As Integer
		Declare Property MenuIndex(value As Integer)
		Declare Property Image As My.Sys.Drawing.BitmapType
		Declare Property Image(value As My.Sys.Drawing.BitmapType)
		Declare Property Image(ByRef value As WString)
		Declare Property ImageIndex As Integer
		Declare Property ImageIndex(value As Integer)
		Declare Property ImageKey ByRef As WString
		Declare Property ImageKey(ByRef value As WString)
		Declare Property Caption ByRef As WString
		Declare Property Caption(ByRef value As WString)
		Declare Property Checked As Boolean
		Declare Property Checked(value As Boolean)
		Declare Property RadioItem As Boolean
		Declare Property RadioItem(value As Boolean)
		Declare Property Enabled As Boolean
		Declare Property Enabled(value As Boolean)
		Declare Property Visible As Boolean
		Declare Property Visible(value As Boolean)
		Declare Property Count As Integer
		Declare Property Count(value As Integer)
		Declare Property Item(index As Integer) As PMenuItem
		Declare Property Item(index As Integer, value As PMenuItem)
		Declare Property Item(ByRef Key As WString) As PMenuItem
		Declare Property Item(ByRef Key As WString, value As PMenuItem)
		Declare Sub Click
		Declare Virtual Function ToString ByRef As WString
		Declare Function Add(ByRef sCaption As WString) As MenuItem Ptr
		Declare Function Add(ByRef sCaption As WString, ByRef iImage As My.Sys.Drawing.BitmapType, sKey As String = "", eClick As NotifyEvent = NULL, Checkable As Boolean = False, Index As Integer = -1) As MenuItem Ptr
		Declare Function Add(ByRef sCaption As WString, iImageIndex As Integer, sKey As String = "", eClick As NotifyEvent = NULL, Checkable As Boolean = False, Index As Integer = -1) As MenuItem Ptr
		Declare Function Add(ByRef sCaption As WString, ByRef sImageKey As WString, sKey As String = "", eClick As NotifyEvent = NULL, Checkable As Boolean = False, Index As Integer = -1) As MenuItem Ptr
		Declare Sub Add(ByRef value As PMenuItem, Index As Integer = -1)
		Declare Sub Add(value() As PMenuItem)
		Declare Sub AddRange cdecl(CountArgs As Integer, ...)
		Declare Sub Remove(value As PMenuItem)
		Declare Sub Insert(index As Integer, value As PMenuItem)
		Declare Sub Clear
		Declare Function IndexOf(value As PMenuItem) As Integer
		Declare Function IndexOf(ByRef Key As WString) As Integer
		Declare Function Find(value As Integer) As PMenuItem
		Declare Function Find(ByRef value As WString) As PMenuItem
		Declare Operator Cast As Any Ptr
		Declare Constructor(ByRef Label As WString = "", ByRef wImageKey As WString = "", eClick As NotifyEvent = NULL, Checkable As Boolean = False)
		Declare Destructor
		OnClick As Sub(ByRef Sender As MenuItem)
	End Type
	
	Private Type Menu Extends Component
	Private:
		FCount   As Integer
		FItems   As PMenuItem Ptr
	Protected:
		#ifdef __USE_WINAPI__
			FInfo    As MENUINFO
			FHandle  As HMENU
		#endif
		FStyle   As Integer
		FColor   As Integer
		FDisplayIcons As Boolean
		FMenuItems    As List
		FParentMenuItem As MenuItem Ptr
		FParentWindow As Component Ptr
		FIncSubItems  As Integer
		Declare Sub GetMenuItems
		Declare Virtual Sub ProcessMessage(ByRef mess As Message)
	Public:
		Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		ImagesList       As ImageList Ptr
		Declare Property DisplayIcons As Boolean
		Declare Property DisplayIcons(value As Boolean)
		Declare Property ParentWindow As Component Ptr
		Declare Property ParentWindow(value As Component Ptr)
		#ifdef __USE_WINAPI__
			Declare Property Handle As HMENU
			Declare Property Handle(value As HMENU)
		#endif
		Declare Property Style As Integer
		Declare Property Style(value As Integer)
		Declare Property ColorizeEntire As Integer
		Declare Property ColorizeEntire(value As Integer)
		Declare Property Color As Integer
		Declare Property Color(value As Integer)
		Declare Property Count As Integer
		Declare Property Count(value As Integer)
		Declare Property Item(index As Integer) As PMenuItem
		Declare Property Item(index As Integer, value As PMenuItem)
		Declare Property Item(ByRef Key As WString) As PMenuItem
		Declare Property Item(ByRef Key As WString, value As PMenuItem)
		Declare Function Add(ByRef sCaption As WString) As MenuItem Ptr
		Declare Function Add(ByRef sCaption As WString, iImage As My.Sys.Drawing.BitmapType, sKey As String = "", eClick As NotifyEvent = NULL, Checkable As Boolean = False, Index As Integer = -1) As MenuItem Ptr
		Declare Function Add(ByRef sCaption As WString, iImageIndex As Integer, sKey As String = "", eClick As NotifyEvent = NULL, Checkable As Boolean = False, Index As Integer = -1) As MenuItem Ptr
		Declare Function Add(ByRef sCaption As WString, ByRef sImageKey As WString, sKey As String = "", eClick As NotifyEvent = NULL, Checkable As Boolean = False, Index As Integer = -1) As MenuItem Ptr
		Declare Sub Add(value As PMenuItem, Index As Integer = -1)
		Declare Sub Add(value() As PMenuItem)
		Declare Sub AddRange cdecl(CountArgs As Integer, ...)
		Declare Sub Remove(value As PMenuItem)
		Declare Sub Insert(index As Integer, value As PMenuItem)
		Declare Sub Clear
		Declare Function IndexOf(value As PMenuItem) As Integer
		Declare Function IndexOf(ByRef Key As WString) As Integer
		Declare Sub ChangeIndex(value As PMenuItem, Index As Integer)
		Declare Function Find(value  As Integer) As PMenuItem
		Declare Function Find(ByRef value As WString) As PMenuItem
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnActivate As Sub(ByRef Sender As Menu)
	End Type
	
	Private Type MainMenu Extends Menu
	Private:
	Protected:
		Declare Function EnumMenuItems(ByRef Item As MenuItem) As Boolean
	Public:
		Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Virtual Sub ProcessMessages(ByRef Message As Message)
		Declare Property ParentWindow(value As Component Ptr)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	Private Type PopupMenu Extends Menu
	Private:
	Protected:
	Public:
		Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Property ParentMenuItem As MenuItem Ptr
		Declare Property ParentMenuItem(value As MenuItem Ptr)
		Declare Property ParentWindow As Component Ptr
		Declare Property ParentWindow(value As Component Ptr)
		Declare Sub Popup(x As Integer, y As Integer, MSG As Message Ptr = 0)
		Declare Virtual Sub ProcessMessages(ByRef Message As Message)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnPopup As Sub(ByRef Sender As PopupMenu)
		OnDropDown As Sub(ByRef Sender As PopupMenu)
	End Type
	
	Declare Function GetAscKeyCode(HotKey As String) As Integer
End Namespace

#ifdef __EXPORT_PROCS__
	Declare Function MenuItemItemsCount Alias "MenuItemItemsCount"(PMenuItem As My.Sys.Forms.MenuItem Ptr) As Integer
	
	Declare Function MenuItemsCount Alias "MenuItemsCount"(PMenu As My.Sys.Forms.Menu Ptr) As Integer
	
	Declare Function MenuItemFindByName Alias "MenuItemFindByName"(PMenuItem As My.Sys.Forms.MenuItem Ptr, ByRef FName As WString) As My.Sys.Forms.MenuItem Ptr
	
	Declare Function MenuFindByName Alias "MenuFindByName"(PMenu As My.Sys.Forms.Menu Ptr, ByRef FName As WString) As My.Sys.Forms.MenuItem Ptr
	
	Declare Function MenuItemAdd Alias "MenuItemAdd"(PMenuItem As My.Sys.Forms.MenuItem Ptr, ByRef sCaption As WString, ByRef sImageKey As WString, sKey As String = "", eClick As Any Ptr = NULL, Index As Integer = -1) As My.Sys.Forms.MenuItem Ptr
	
	Declare Function MenuItemAddWithBitmapType Alias "MenuItemAddWithBitmapType"(PMenuItem As My.Sys.Forms.MenuItem Ptr, ByRef sCaption As WString, iImage As My.Sys.Drawing.BitmapType Ptr, sKey As String = "", eClick As Any Ptr = Null, Index As Integer = -1) As My.Sys.Forms.MenuItem Ptr
	
	Declare Sub MenuItemRemove Alias "MenuItemRemove"(ParentMenuItem As My.Sys.Forms.MenuItem Ptr, PMenuItem As My.Sys.Forms.MenuItem Ptr)
	
	Declare Sub MenuRemove Alias "MenuRemove"(ParentMenu As My.Sys.Forms.Menu Ptr, PMenuItem As My.Sys.Forms.MenuItem Ptr)
#endif

#ifndef __USE_MAKE__
	#include once "Menus.bas"
#endif
