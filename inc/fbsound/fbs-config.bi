#ifndef __FBS_CONFIG_BI__
#define __FBS_CONFIG_BI__

'' NOTE: If these options are changed, then
'' the libraries must be built again from sources.
'' These options disable features of both the
'' static libraries and shared libraries.
'' 
'' Otherwise, any options defined here can be used
'' in the user program to detect if certain features
'' will be unavilable at either compile time or
'' run time depending on the method of library use
'' (either static or shared respectively). 

' disable some features and rebuild the lib
'#define NO_ASM
'#define NO_MP3        ' no MP3 sound and stream 
'#define NO_OGG        ' no Vorbis sound
'#define NO_MOD        ' no tracker modules
'#define NO_SID        ' no SID stream
'#define NO_CALLBACK   ' no load or buffer callbacks
'#define NO_DSP        ' no EQS Filter
'#define NO_PITCHSHIFT ' no realtime pitch shifter
'#define NO_3D

'#define DEBUG

#ifdef __FB_WIN32__
' windows
'#define NO_PLUG_MM
'#define NO_PLUG_DS 
#endif
' linux
#ifdef __FB_LINUX__
 #ifndef __FB_64BIT__
  #define NO_PLUG_DSP
  #define NO_PLUG_ARTS
 #endif  
'#define NO_PLUG_ALSA 
#endif

#ifndef DEBUG 
 #if __FB_DEBUG__ ' -g has priority
  #define DEBUG
 #endif 
#endif
 
#ifdef DEBUG
  #define dprint(msg) open err for output as #99 : print #99,"debug: " & msg : close #99
#else
  #define dprint(msg) :
#endif

#endif ' __FBS_CONFIG_BI__
