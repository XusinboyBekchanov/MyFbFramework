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
	
	#define QMenuItem(__Ptr__)  (*Cast(PMenuItem, __Ptr__))
	#define QMenu(__Ptr__)      (*Cast(PMenu, __Ptr__))
	#define QPopupMenu(__Ptr__) (*Cast(PPopupMenu, __Ptr__))
	#define QMainMenu(__Ptr__)     (*Cast(PMainMenu, __Ptr__))
	
	Const MIM_BACKGROUND      = &H2
	Const MIM_APPLYTOSUBMENUS = &H80000000
	Const MIM_MENUDATA        = &H00000008
	
	'`MenuItem` - Represents an individual element in menu structures with hierarchical submenu support and action binding.
	Private Type MenuItem Extends My.Sys.Object
	Private:
		Declare Static Sub BitmapChanged(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.BitmapType)
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
			'FMenu  	    As HMENU
		#endif
		FName			    As WString Ptr
		FOwner			    As PMenu
		FMenuItemChecked    As Boolean
		Declare Sub ChangeIndex(value As PMenuItem, Index As Integer)
	Public:
		#ifndef ReadProperty_Off
			'Loads configuration from stream
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves configuration to stream
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean   
		#endif
		'User-defined data container
		Tag As Any Ptr
		'Reference to nested menu structure
		SubMenu As PPopupMenu
		#ifdef __USE_WINAPI__
			'declare property Menu as HMENU
			'declare property Menu(value as HMENU)
			Declare Property Handle As HMENU
			Declare Property Handle(value As HMENU)
			'Updates Windows MENUITEMINFO
			Declare Sub SetInfo(ByRef value As MENUITEMINFO)
			'Configures GTK+ menu attributes
			Declare Sub SetItemInfo(ByRef value As MENUITEMINFO)
		#elseif defined(__USE_GTK__)
			'Keyboard key for shortcut (e.g., 'F5')
			accelerator_key As guint
			'Modifier keys (Ctrl/Alt/Shift) for shortcut
			accelerator_mods As GdkModifierType
			Box				As GtkWidget Ptr
			Icon			As GtkWidget Ptr
			Label			As GtkWidget Ptr
			'GTK+ menu item widget reference
			Widget 			As GtkWidget Ptr
			'GTK+ activate signal handler
			Declare Static Sub MenuItemActivate(MenuItem As GtkMenuItem Ptr, user_data As Any Ptr)
			'GTK+ button press handler
			Declare Static Function MenuItemButtonPressEvent(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
		#endif
		Declare Property Owner As PMenu
		'Parent form/control reference
		Declare Property Owner(value As PMenu)
		Declare Property Name ByRef As WString
		'Unique identifier string
		Declare Property Name(ByRef value As WString)
		Declare Property Parent As My.Sys.Object Ptr
		'Immediate container reference
		Declare Property Parent(value As My.Sys.Object Ptr)
		Declare Property ParentMenu As PMenu
		'MainMenu/PopupMenu parent
		Declare Property ParentMenu(value As PMenu)
		Declare Property ParentMenuItem As PMenuItem
		'Hierarchical parent menu item
		Declare Property ParentMenuItem(value As PMenuItem)
		Declare Property Command As Integer
		'Associated command ID/object
		Declare Property Command(value As Integer)
		Declare Property MenuIndex As Integer
		'Position in parent menu
		Declare Property MenuIndex(value As Integer)
		Declare Property Image As My.Sys.Drawing.BitmapType
		'Windows HBITMAP icon handle
		Declare Property Image(value As My.Sys.Drawing.BitmapType)
		'Windows HBITMAP icon handle
		Declare Property Image(ByRef value As WString)
		Declare Property ImageIndex As Integer
		'Index in parent's ImageList
		Declare Property ImageIndex(value As Integer)
		Declare Property ImageKey ByRef As WString
		'Icon resource key name
		Declare Property ImageKey(ByRef value As WString)
		Declare Property Caption ByRef As WString
		'Display text with underscore accelerators
		Declare Property Caption(ByRef value As WString)
		Declare Property Checked As Boolean
		'Checkmark display state
		Declare Property Checked(value As Boolean)
		Declare Property RadioItem As Boolean
		'Indicates radio-button group membership
		Declare Property RadioItem(value As Boolean)
		Declare Property Enabled As Boolean
		'Controls interactive availability
		Declare Property Enabled(value As Boolean)
		Declare Property Visible As Boolean
		'Visibility toggle
		Declare Property Visible(value As Boolean)
		Declare Property Count As Integer
		'Number of submenu items
		Declare Property Count(value As Integer)
		'Indexer for submenu items
		Declare Property Item(index As Integer) As PMenuItem
		'Indexer for submenu items
		Declare Property Item(index As Integer, value As PMenuItem)
		'Indexer for submenu items
		Declare Property Item(ByRef Key As WString) As PMenuItem
		'Indexer for submenu items
		Declare Property Item(ByRef Key As WString, value As PMenuItem)
		Declare Property ShortCut ByRef As WString
		'Combined shortcut key configuration
		Declare Property ShortCut(ByRef value As WString)
		'Programmatically triggers click action
		Declare Sub Click
		Declare Virtual Function ToString ByRef As WString
		'Appends new submenu item
		Declare Function Add(ByRef sCaption As WString) As MenuItem Ptr
		'Appends new submenu item
		Declare Function Add(ByRef sCaption As WString, ByRef iImage As My.Sys.Drawing.BitmapType, sKey As String = "", eClick As NotifyEvent = 0, Checkable As Boolean = False, Index As Integer = -1, bEnabled As Boolean = True) As MenuItem Ptr
		'Appends new submenu item
		Declare Function Add(ByRef sCaption As WString, iImageIndex As Integer, sKey As String = "", eClick As NotifyEvent = 0, Checkable As Boolean = False, Index As Integer = -1, bEnabled As Boolean = True) As MenuItem Ptr
		'Appends new submenu item
		Declare Function Add(ByRef sCaption As WString, ByRef sImageKey As WString, sKey As String = "", eClick As NotifyEvent = 0, Checkable As Boolean = False, Index As Integer = -1, bEnabled As Boolean = True) As MenuItem Ptr
		'Appends new submenu item
		Declare Sub Add(ByRef value As PMenuItem, Index As Integer = -1)
		'Appends new submenu item
		Declare Sub Add(value() As PMenuItem)
		'Adds multiple submenu items
		Declare Sub AddRange cdecl(CountArgs As Integer, ...)
		'Deletes specified submenu item
		Declare Sub Remove(value As PMenuItem)
		'Inserts submenu at specified position
		Declare Sub Insert(index As Integer, value As PMenuItem)
		'Removes all submenu items
		Declare Sub Clear
		'Returns submenu item position
		Declare Function IndexOf(value As PMenuItem) As Integer
		'Returns submenu item position
		Declare Function IndexOf(ByRef Key As WString) As Integer
		'Searches items by name/command
		Declare Function Find(value As Integer) As PMenuItem
		'Searches items by name/command
		Declare Function Find(ByRef value As WString) As PMenuItem
		Declare Function VisibleMenuIndex() As Integer
		Declare Operator Cast As Any Ptr
		Declare Constructor(ByRef Label As WString = "", ByRef wImageKey As WString = "", eClick As NotifyEvent = 0, Checkable As Boolean = False)
		Declare Destructor
		'Triggered when selected via click/shortcut
		OnClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As MenuItem)
	End Type
	
	'`Menu` - Base class for menu containers supporting hierarchical item management and visual customization.
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
		Declare Sub TraverseItems(Item As MenuItem)
		Declare Sub GetMenuItems
		Declare Virtual Sub ProcessMessage(ByRef mess As Message)
	Public:
		#ifdef __USE_GTK__
			Widget As GtkWidget Ptr
		#endif
		#ifndef ReadProperty_Off
			'Loads menu structure from stream
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves menu structure to stream
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Associated ImageList for menu icons
		ImagesList       As ImageList Ptr
		Declare Property DisplayIcons As Boolean
		'Toggles visibility of menu item icons
		Declare Property DisplayIcons(value As Boolean)
		Declare Property ParentWindow As Component Ptr
		'Owning form/window reference
		Declare Property ParentWindow(value As Component Ptr)
		#ifdef __USE_WINAPI__
			Declare Property Handle As HMENU
			'Native OS menu handle (HMENU)
			Declare Property Handle(value As HMENU)
		#else
			Declare Property Handle As GtkWidget Ptr
			'Native OS menu handle (HMENU)
			Declare Property Handle(value As GtkWidget Ptr)
		#endif
		Declare Property Style As Integer
		'Visual theme (Classic/Flat/Modern)
		Declare Property Style(value As Integer)
		Declare Property ColorizeEntire As Integer
		'Applies color theme to entire menu bar
		Declare Property ColorizeEntire(value As Integer)
		Declare Property Color As Integer
		'Background color of menu items
		Declare Property Color(value As Integer)
		Declare Property Count As Integer
		'Number of top-level menu items
		Declare Property Count(value As Integer)
		'Indexer accessing menu items by position
		Declare Property Item(index As Integer) As PMenuItem
		'Indexer accessing menu items by position
		Declare Property Item(index As Integer, value As PMenuItem)
		'Indexer accessing menu items by position
		Declare Property Item(ByRef Key As WString) As PMenuItem
		'Indexer accessing menu items by position
		Declare Property Item(ByRef Key As WString, value As PMenuItem)
		'Appends new top-level menu item
		Declare Function Add(ByRef sCaption As WString) As MenuItem Ptr
		'Appends new top-level menu item
		Declare Function Add(ByRef sCaption As WString, iImage As My.Sys.Drawing.BitmapType, sKey As String = "", eClick As NotifyEvent = 0, Checkable As Boolean = False, Index As Integer = -1, bEnabled As Boolean = True) As MenuItem Ptr
		'Appends new top-level menu item
		Declare Function Add(ByRef sCaption As WString, iImageIndex As Integer, sKey As String = "", eClick As NotifyEvent = 0, Checkable As Boolean = False, Index As Integer = -1, bEnabled As Boolean = True) As MenuItem Ptr
		'Appends new top-level menu item
		Declare Function Add(ByRef sCaption As WString, ByRef sImageKey As WString, sKey As String = "", eClick As NotifyEvent = 0, Checkable As Boolean = False, Index As Integer = -1, bEnabled As Boolean = True) As MenuItem Ptr
		'Appends new top-level menu item
		Declare Sub Add(value As PMenuItem, Index As Integer = -1)
		'Appends new top-level menu item
		Declare Sub Add(value() As PMenuItem)
		'Adds multiple menu items at once
		Declare Sub AddRange cdecl(CountArgs As Integer, ...)
		'Deletes specified menu item
		Declare Sub Remove(value As PMenuItem)
		'Inserts item at specific index
		Declare Sub Insert(index As Integer, value As PMenuItem)
		'Removes all menu items
		Declare Sub Clear
		'Returns position of specified item
		Declare Function IndexOf(value As PMenuItem) As Integer
		'Returns position of specified item
		Declare Function IndexOf(ByRef Key As WString) As Integer
		'Modifies menu item display order
		Declare Sub ChangeIndex(value As PMenuItem, Index As Integer)
		'Locates item by text/command ID
		Declare Function Find(value  As Integer) As PMenuItem
		'Locates item by text/command ID
		Declare Function Find(ByRef value As WString) As PMenuItem
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		'Triggered when menu gains focus
		OnActivate As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Menu)
	End Type
	
	'Represents the menu structure of a form.
	Private Type MainMenu Extends Menu
	Private:
	Protected:
		Declare Function EnumMenuItems(ByRef Item As MenuItem) As Boolean
	Public:
		#ifndef ReadProperty_Off
			'Loads menu structure from stream
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves menu configuration to stream
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Handles Windows message loop
		Declare Virtual Sub ProcessMessages(ByRef Message As Message)
		'Reference to owner form
		Declare Property ParentWindow(value As Component Ptr)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	'Represents a context menu.
	Private Type PopupMenu Extends Menu
	Private:
	Protected:
	Public:
		#ifndef ReadProperty_Off
			'Loads menu structure from stream
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves menu configuration to stream
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property ParentMenuItem As MenuItem Ptr
		'Hierarchical parent menu item
		Declare Property ParentMenuItem(value As MenuItem Ptr)
		Declare Property ParentWindow As Component Ptr
		'Reference to owner form
		Declare Property ParentWindow(value As Component Ptr)
		Declare Sub Popup(x As Integer, y As Integer, MSG As Message Ptr = 0)
		'Handles Windows message loop
		Declare Virtual Sub ProcessMessages(ByRef Message As Message)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnPopup As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As PopupMenu)
		OnDropDown As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As PopupMenu)
	End Type
	
	Declare Function GetAscKeyCode(HotKey As String) As Integer
	
	Declare Function GetChrKeyCode(KeyCode As Integer) As String
End Namespace

#ifdef __EXPORT_PROCS__
	Declare Function MenuItemItemsCount Alias "MenuItemItemsCount"(PMenuItem As My.Sys.Forms.MenuItem Ptr) As Integer
	
	Declare Function MenuItemsCount Alias "MenuItemsCount"(PMenu As My.Sys.Forms.Menu Ptr) As Integer
	
	Declare Function MenuItemFindByName Alias "MenuItemFindByName"(PMenuItem As My.Sys.Forms.MenuItem Ptr, ByRef FName As WString) As My.Sys.Forms.MenuItem Ptr
	
	Declare Function MenuFindByName Alias "MenuFindByName"(PMenu As My.Sys.Forms.Menu Ptr, ByRef FName As WString) As My.Sys.Forms.MenuItem Ptr
	
	Declare Function MenuItemAdd Alias "MenuItemAdd"(PMenuItem As My.Sys.Forms.MenuItem Ptr, ByRef sCaption As WString, ByRef sImageKey As WString, sKey As String = "", eClick As Any Ptr = NULL, Index As Integer = -1) As My.Sys.Forms.MenuItem Ptr
	
	Declare Function MenuItemAddWithBitmapType Alias "MenuItemAddWithBitmapType"(PMenuItem As My.Sys.Forms.MenuItem Ptr, ByRef sCaption As WString, iImage As My.Sys.Drawing.BitmapType Ptr, sKey As String = "", eClick As Any Ptr = NULL, Index As Integer = -1) As My.Sys.Forms.MenuItem Ptr
	
	Declare Sub MenuItemRemove Alias "MenuItemRemove"(ParentMenuItem As My.Sys.Forms.MenuItem Ptr, PMenuItem As My.Sys.Forms.MenuItem Ptr)
	
	Declare Sub MenuRemove Alias "MenuRemove"(ParentMenu As My.Sys.Forms.Menu Ptr, PMenuItem As My.Sys.Forms.MenuItem Ptr)
#endif

#ifndef __USE_MAKE__
	#include once "Menus.bas"
#endif
