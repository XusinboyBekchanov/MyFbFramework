#pragma once

#ifndef RAYLIB_H
	#include once "raylib.bi"
#endif

#inclib "raygui" 

extern "C"

#define RAYGUI_H
#define RAYGUI_VERSION "3.2"
#define RAYGUI_MALLOC(sz) malloc(sz)
#define RAYGUI_CALLOC(n, sz) calloc(n, sz)
#define RAYGUI_FREE(p) free(p)
#define RAYGUI_SUPPORT_LOG_INFO
#define RAYGUI_LOG(__VA_ARGS__...) printf(__VA_ARGS__)

type GuiStyleProp
	controlId as ushort
	propertyId as ushort
	propertyValue as ulong
end type

type GuiState as long
enum
	STATE_NORMAL = 0
	STATE_FOCUSED
	STATE_PRESSED
	STATE_DISABLED
end enum

type GuiTextAlignment as long
enum
	TEXT_ALIGN_LEFT = 0
	TEXT_ALIGN_CENTER
	TEXT_ALIGN_RIGHT
end enum

type GuiControl as long
enum
	DEFAULT = 0
	LABEL
	BUTTON
	TOGGLE
	SLIDER
	PROGRESSBAR
	CHECKBOX
	COMBOBOX
	DROPDOWNBOX
	TEXTBOX
	VALUEBOX
	SPINNER
	LISTVIEW
	COLORPICKER
	SCROLLBAR
	STATUSBAR
end enum

type GuiControlProperty as long
enum
	BORDER_COLOR_NORMAL = 0
	BASE_COLOR_NORMAL
	TEXT_COLOR_NORMAL
	BORDER_COLOR_FOCUSED
	BASE_COLOR_FOCUSED
	TEXT_COLOR_FOCUSED
	BORDER_COLOR_PRESSED
	BASE_COLOR_PRESSED
	TEXT_COLOR_PRESSED
	BORDER_COLOR_DISABLED
	BASE_COLOR_DISABLED
	TEXT_COLOR_DISABLED
	BORDER_WIDTH
	TEXT_PADDING
	TEXT_ALIGNMENT
	RESERVED
end enum

type GuiDefaultProperty as long
enum
	TEXT_SIZE = 16
	TEXT_SPACING
	LINE_COLOR
	BACKGROUND_COLOR
end enum

type GuiToggleProperty as long
enum
	GROUP_PADDING = 16
end enum

type GuiSliderProperty as long
enum
	SLIDER_WIDTH = 16
	SLIDER_PADDING
end enum

type GuiProgressBarProperty as long
enum
	PROGRESS_PADDING = 16
end enum

type GuiScrollBarProperty as long
enum
	ARROWS_SIZE = 16
	ARROWS_VISIBLE
	SCROLL_SLIDER_PADDING
	SCROLL_SLIDER_SIZE
	SCROLL_PADDING
	SCROLL_SPEED
end enum

type GuiCheckBoxProperty as long
enum
	CHECK_PADDING = 16
end enum

type GuiComboBoxProperty as long
enum
	COMBO_BUTTON_WIDTH = 16
	COMBO_BUTTON_SPACING
end enum

type GuiDropdownBoxProperty as long
enum
	ARROW_PADDING = 16
	DROPDOWN_ITEMS_SPACING
end enum

type GuiTextBoxProperty as long
enum
	TEXT_INNER_PADDING = 16
	TEXT_LINES_SPACING
end enum

type GuiSpinnerProperty as long
enum
	SPIN_BUTTON_WIDTH = 16
	SPIN_BUTTON_SPACING
end enum

type GuiListViewProperty as long
enum
	LIST_ITEMS_HEIGHT = 16
	LIST_ITEMS_SPACING
	SCROLLBAR_WIDTH
	SCROLLBAR_SIDE
end enum

type GuiColorPickerProperty as long
enum
	COLOR_SELECTOR_SIZE = 16
	HUEBAR_WIDTH
	HUEBAR_PADDING
	HUEBAR_SELECTOR_HEIGHT
	HUEBAR_SELECTOR_OVERFLOW
end enum

const SCROLLBAR_LEFT_SIDE = 0
const SCROLLBAR_RIGHT_SIDE = 1
declare sub GuiEnable()
declare sub GuiDisable()
declare sub GuiLock()
declare sub GuiUnlock()
declare function GuiIsLocked() as boolean
declare sub GuiFade(byval alpha as single)
declare sub GuiSetState(byval state as long)
declare function GuiGetState() as long
declare sub GuiSetFont(byval font as Font)
declare function GuiGetFont() as Font
declare sub GuiSetStyle(byval control as long, byval property as long, byval value as long)
declare function GuiGetStyle(byval control as long, byval property as long) as long
declare function GuiWindowBox(byval bounds as Rectangle, byval title as const zstring ptr) as boolean
declare sub GuiGroupBox(byval bounds as Rectangle, byval text as const zstring ptr)
declare sub GuiLine(byval bounds as Rectangle, byval text as const zstring ptr)
declare sub GuiPanel(byval bounds as Rectangle, byval text as const zstring ptr)
declare function GuiScrollPanel(byval bounds as Rectangle, byval text as const zstring ptr, byval content as Rectangle, byval scroll as Vector2 ptr) as Rectangle
declare sub GuiLabel(byval bounds as Rectangle, byval text as const zstring ptr)
declare function GuiButton(byval bounds as Rectangle, byval text as const zstring ptr) as boolean
declare function GuiLabelButton(byval bounds as Rectangle, byval text as const zstring ptr) as boolean
declare function GuiToggle(byval bounds as Rectangle, byval text as const zstring ptr, byval active as boolean) as boolean
declare function GuiToggleGroup(byval bounds as Rectangle, byval text as const zstring ptr, byval active as long) as long
declare function GuiCheckBox(byval bounds as Rectangle, byval text as const zstring ptr, byval checked as boolean) as boolean
declare function GuiComboBox(byval bounds as Rectangle, byval text as const zstring ptr, byval active as long) as long
declare function GuiDropdownBox(byval bounds as Rectangle, byval text as const zstring ptr, byval active as long ptr, byval editMode as boolean) as boolean
declare function GuiSpinner(byval bounds as Rectangle, byval text as const zstring ptr, byval value as long ptr, byval minValue as long, byval maxValue as long, byval editMode as boolean) as boolean
declare function GuiValueBox(byval bounds as Rectangle, byval text as const zstring ptr, byval value as long ptr, byval minValue as long, byval maxValue as long, byval editMode as boolean) as boolean
declare function GuiTextBox(byval bounds as Rectangle, byval text as zstring ptr, byval textSize as long, byval editMode as boolean) as boolean
declare function GuiTextBoxMulti(byval bounds as Rectangle, byval text as zstring ptr, byval textSize as long, byval editMode as boolean) as boolean
declare function GuiSlider(byval bounds as Rectangle, byval textLeft as const zstring ptr, byval textRight as const zstring ptr, byval value as single, byval minValue as single, byval maxValue as single) as single
declare function GuiSliderBar(byval bounds as Rectangle, byval textLeft as const zstring ptr, byval textRight as const zstring ptr, byval value as single, byval minValue as single, byval maxValue as single) as single
declare function GuiProgressBar(byval bounds as Rectangle, byval textLeft as const zstring ptr, byval textRight as const zstring ptr, byval value as single, byval minValue as single, byval maxValue as single) as single
declare sub GuiStatusBar(byval bounds as Rectangle, byval text as const zstring ptr)
declare sub GuiDummyRec(byval bounds as Rectangle, byval text as const zstring ptr)
declare function GuiGrid(byval bounds as Rectangle, byval text as const zstring ptr, byval spacing as single, byval subdivs as long) as Vector2
declare function GuiListView(byval bounds as Rectangle, byval text as const zstring ptr, byval scrollIndex as long ptr, byval active as long) as long
declare function GuiListViewEx(byval bounds as Rectangle, byval text as const zstring ptr ptr, byval count as long, byval focus as long ptr, byval scrollIndex as long ptr, byval active as long) as long
declare function GuiMessageBox(byval bounds as Rectangle, byval title as const zstring ptr, byval message as const zstring ptr, byval buttons as const zstring ptr) as long
declare function GuiTextInputBox(byval bounds as Rectangle, byval title as const zstring ptr, byval message as const zstring ptr, byval buttons as const zstring ptr, byval text as zstring ptr, byval textMaxSize as long, byval secretViewActive as long ptr) as long
declare function GuiColorPicker(byval bounds as Rectangle, byval text as const zstring ptr, byval color as RLColor) as RLColor
declare function GuiColorPanel(byval bounds as Rectangle, byval text as const zstring ptr, byval color as RLColor) as RLColor
declare function GuiColorBarAlpha(byval bounds as Rectangle, byval text as const zstring ptr, byval alpha as single) as single
declare function GuiColorBarHue(byval bounds as Rectangle, byval text as const zstring ptr, byval value as single) as single
declare sub GuiLoadStyle(byval fileName as const zstring ptr)
declare sub GuiLoadStyleDefault()
declare function GuiIconText(byval iconId as long, byval text as const zstring ptr) as const zstring ptr
declare sub GuiDrawIcon(byval iconId as long, byval posX as long, byval posY as long, byval pixelSize as long, byval color as RLColor)
declare function GuiGetIcons() as ulong ptr
declare function GuiGetIconData(byval iconId as long) as ulong ptr
declare sub GuiSetIconData(byval iconId as long, byval data_ as ulong ptr)
declare sub GuiSetIconScale(byval scale as ulong)
declare sub GuiSetIconPixel(byval iconId as long, byval x as long, byval y as long)
declare sub GuiClearIconPixel(byval iconId as long, byval x as long, byval y as long)
declare function GuiCheckIconPixel(byval iconId as long, byval x as long, byval y as long) as boolean

type GuiIconName as long
enum
	ICON_NONE = 0
	ICON_FOLDER_FILE_OPEN = 1
	ICON_FILE_SAVE_CLASSIC = 2
	ICON_FOLDER_OPEN = 3
	ICON_FOLDER_SAVE = 4
	ICON_FILE_OPEN = 5
	ICON_FILE_SAVE = 6
	ICON_FILE_EXPORT = 7
	ICON_FILE_ADD = 8
	ICON_FILE_DELETE = 9
	ICON_FILETYPE_TEXT = 10
	ICON_FILETYPE_AUDIO = 11
	ICON_FILETYPE_IMAGE = 12
	ICON_FILETYPE_PLAY = 13
	ICON_FILETYPE_VIDEO = 14
	ICON_FILETYPE_INFO = 15
	ICON_FILE_COPY = 16
	ICON_FILE_CUT = 17
	ICON_FILE_PASTE = 18
	ICON_CURSOR_HAND = 19
	ICON_CURSOR_POINTER = 20
	ICON_CURSOR_CLASSIC = 21
	ICON_PENCIL = 22
	ICON_PENCIL_BIG = 23
	ICON_BRUSH_CLASSIC = 24
	ICON_BRUSH_PAINTER = 25
	ICON_WATER_DROP = 26
	ICON_COLOR_PICKER = 27
	ICON_RUBBER = 28
	ICON_COLOR_BUCKET = 29
	ICON_TEXT_T = 30
	ICON_TEXT_A = 31
	ICON_SCALE = 32
	ICON_RESIZE = 33
	ICON_FILTER_POINT = 34
	ICON_FILTER_BILINEAR = 35
	ICON_CROP = 36
	ICON_CROP_ALPHA = 37
	ICON_SQUARE_TOGGLE = 38
	ICON_SYMMETRY = 39
	ICON_SYMMETRY_HORIZONTAL = 40
	ICON_SYMMETRY_VERTICAL = 41
	ICON_LENS = 42
	ICON_LENS_BIG = 43
	ICON_EYE_ON = 44
	ICON_EYE_OFF = 45
	ICON_FILTER_TOP = 46
	ICON_FILTER = 47
	ICON_TARGET_POINT = 48
	ICON_TARGET_SMALL = 49
	ICON_TARGET_BIG = 50
	ICON_TARGET_MOVE = 51
	ICON_CURSOR_MOVE = 52
	ICON_CURSOR_SCALE = 53
	ICON_CURSOR_SCALE_RIGHT = 54
	ICON_CURSOR_SCALE_LEFT = 55
	ICON_UNDO = 56
	ICON_REDO = 57
	ICON_REREDO = 58
	ICON_MUTATE = 59
	ICON_ROTATE = 60
	ICON_REPEAT = 61
	ICON_SHUFFLE = 62
	ICON_EMPTYBOX = 63
	ICON_TARGET = 64
	ICON_TARGET_SMALL_FILL = 65
	ICON_TARGET_BIG_FILL = 66
	ICON_TARGET_MOVE_FILL = 67
	ICON_CURSOR_MOVE_FILL = 68
	ICON_CURSOR_SCALE_FILL = 69
	ICON_CURSOR_SCALE_RIGHT_FILL = 70
	ICON_CURSOR_SCALE_LEFT_FILL = 71
	ICON_UNDO_FILL = 72
	ICON_REDO_FILL = 73
	ICON_REREDO_FILL = 74
	ICON_MUTATE_FILL = 75
	ICON_ROTATE_FILL = 76
	ICON_REPEAT_FILL = 77
	ICON_SHUFFLE_FILL = 78
	ICON_EMPTYBOX_SMALL = 79
	ICON_BOX = 80
	ICON_BOX_TOP = 81
	ICON_BOX_TOP_RIGHT = 82
	ICON_BOX_RIGHT = 83
	ICON_BOX_BOTTOM_RIGHT = 84
	ICON_BOX_BOTTOM = 85
	ICON_BOX_BOTTOM_LEFT = 86
	ICON_BOX_LEFT = 87
	ICON_BOX_TOP_LEFT = 88
	ICON_BOX_CENTER = 89
	ICON_BOX_CIRCLE_MASK = 90
	ICON_POT = 91
	ICON_ALPHA_MULTIPLY = 92
	ICON_ALPHA_CLEAR = 93
	ICON_DITHERING = 94
	ICON_MIPMAPS = 95
	ICON_BOX_GRID = 96
	ICON_GRID = 97
	ICON_BOX_CORNERS_SMALL = 98
	ICON_BOX_CORNERS_BIG = 99
	ICON_FOUR_BOXES = 100
	ICON_GRID_FILL = 101
	ICON_BOX_MULTISIZE = 102
	ICON_ZOOM_SMALL = 103
	ICON_ZOOM_MEDIUM = 104
	ICON_ZOOM_BIG = 105
	ICON_ZOOM_ALL = 106
	ICON_ZOOM_CENTER = 107
	ICON_BOX_DOTS_SMALL = 108
	ICON_BOX_DOTS_BIG = 109
	ICON_BOX_CONCENTRIC = 110
	ICON_BOX_GRID_BIG = 111
	ICON_OK_TICK = 112
	ICON_CROSS = 113
	ICON_ARROW_LEFT = 114
	ICON_ARROW_RIGHT = 115
	ICON_ARROW_DOWN = 116
	ICON_ARROW_UP = 117
	ICON_ARROW_LEFT_FILL = 118
	ICON_ARROW_RIGHT_FILL = 119
	ICON_ARROW_DOWN_FILL = 120
	ICON_ARROW_UP_FILL = 121
	ICON_AUDIO = 122
	ICON_FX = 123
	ICON_WAVE = 124
	ICON_WAVE_SINUS = 125
	ICON_WAVE_SQUARE = 126
	ICON_WAVE_TRIANGULAR = 127
	ICON_CROSS_SMALL = 128
	ICON_PLAYER_PREVIOUS = 129
	ICON_PLAYER_PLAY_BACK = 130
	ICON_PLAYER_PLAY = 131
	ICON_PLAYER_PAUSE = 132
	ICON_PLAYER_STOP = 133
	ICON_PLAYER_NEXT = 134
	ICON_PLAYER_RECORD = 135
	ICON_MAGNET = 136
	ICON_LOCK_CLOSE = 137
	ICON_LOCK_OPEN = 138
	ICON_CLOCK = 139
	ICON_TOOLS = 140
	ICON_GEAR = 141
	ICON_GEAR_BIG = 142
	ICON_BIN = 143
	ICON_HAND_POINTER = 144
	ICON_LASER = 145
	ICON_COIN = 146
	ICON_EXPLOSION = 147
	ICON_1UP = 148
	ICON_PLAYER = 149
	ICON_PLAYER_JUMP = 150
	ICON_KEY = 151
	ICON_DEMON = 152
	ICON_TEXT_POPUP = 153
	ICON_GEAR_EX = 154
	ICON_CRACK = 155
	ICON_CRACK_POINTS = 156
	ICON_STAR = 157
	ICON_DOOR = 158
	ICON_EXIT = 159
	ICON_MODE_2D = 160
	ICON_MODE_3D = 161
	ICON_CUBE = 162
	ICON_CUBE_FACE_TOP = 163
	ICON_CUBE_FACE_LEFT = 164
	ICON_CUBE_FACE_FRONT = 165
	ICON_CUBE_FACE_BOTTOM = 166
	ICON_CUBE_FACE_RIGHT = 167
	ICON_CUBE_FACE_BACK = 168
	ICON_CAMERA = 169
	ICON_SPECIAL = 170
	ICON_LINK_NET = 171
	ICON_LINK_BOXES = 172
	ICON_LINK_MULTI = 173
	ICON_LINK = 174
	ICON_LINK_BROKE = 175
	ICON_TEXT_NOTES = 176
	ICON_NOTEBOOK = 177
	ICON_SUITCASE = 178
	ICON_SUITCASE_ZIP = 179
	ICON_MAILBOX = 180
	ICON_MONITOR = 181
	ICON_PRINTER = 182
	ICON_PHOTO_CAMERA = 183
	ICON_PHOTO_CAMERA_FLASH = 184
	ICON_HOUSE = 185
	ICON_HEART = 186
	ICON_CORNER = 187
	ICON_VERTICAL_BARS = 188
	ICON_VERTICAL_BARS_FILL = 189
	ICON_LIFE_BARS = 190
	ICON_INFO = 191
	ICON_CROSSLINE = 192
	ICON_HELP = 193
	ICON_FILETYPE_ALPHA = 194
	ICON_FILETYPE_HOME = 195
	ICON_LAYERS_VISIBLE = 196
	ICON_LAYERS = 197
	ICON_WINDOW = 198
	ICON_HIDPI = 199
	ICON_FILETYPE_BINARY = 200
	ICON_HEX = 201
	ICON_SHIELD = 202
	ICON_FILE_NEW = 203
	ICON_FOLDER_ADD = 204
	ICON_ALARM = 205
	ICON_206 = 206
	ICON_207 = 207
	ICON_208 = 208
	ICON_209 = 209
	ICON_210 = 210
	ICON_211 = 211
	ICON_212 = 212
	ICON_213 = 213
	ICON_214 = 214
	ICON_215 = 215
	ICON_216 = 216
	ICON_217 = 217
	ICON_218 = 218
	ICON_219 = 219
	ICON_220 = 220
	ICON_221 = 221
	ICON_222 = 222
	ICON_223 = 223
	ICON_224 = 224
	ICON_225 = 225
	ICON_226 = 226
	ICON_227 = 227
	ICON_228 = 228
	ICON_229 = 229
	ICON_230 = 230
	ICON_231 = 231
	ICON_232 = 232
	ICON_233 = 233
	ICON_234 = 234
	ICON_235 = 235
	ICON_236 = 236
	ICON_237 = 237
	ICON_238 = 238
	ICON_239 = 239
	ICON_240 = 240
	ICON_241 = 241
	ICON_242 = 242
	ICON_243 = 243
	ICON_244 = 244
	ICON_245 = 245
	ICON_246 = 246
	ICON_247 = 247
	ICON_248 = 248
	ICON_249 = 249
	ICON_250 = 250
	ICON_251 = 251
	ICON_252 = 252
	ICON_253 = 253
	ICON_254 = 254
	ICON_255 = 255
end enum

end extern
