#ifndef __FBS_PLUGOUT_DSP__
#define __FBS_PLUGOUT_DSP__

'  ###############
' # plug-dsp.bi #
'###############
' Copyright 2005-2020 by D.J.Peters (Joshy)
' d.j.peters@web.de

#include once "fbstypes.bi"

#ifndef NO_PLUG_DSP

#if __FB_OUT_DLL__ = 0
namespace fbsound.plug_dsp
#endif

const _FBS_READ              = 3
const _FBS_WRITE             = 4
const _FBS_OPEN              = 5
const _FBS_CLOSE             = 6
const _FBS_ACCESS            = 33
const _FBS_IOCTL             = 54

const _FBS_O_RDONLY          = &H0000
const _FBS_O_WRONLY          = &H0001
const _FBS_O_RDWR            = &H0002
const _FBS_O_NONBLOCK        = &H0800

const _FBS_EAGAIN            = -11
const _FBS_EBUSY             = -16
const _FBS_ENDEV             = -19

const SNDCTL_DSP_RESET       = &H00005000
const SNDCTL_DSP_SYNC        = &H00005001
const SNDCTL_DSP_POST        = &H00005008
const SNDCTL_DSP_NONBLOCK    = &H0000500e

const SNDCTL_DSP_SPEED       = &Hc0045002
const SNDCTL_DSP_STEREO      = &Hc0045003 '0=mono 1=stereo
const SNDCTL_DSP_GETBLKSIZE  = &Hc0045004
const SNDCTL_DSP_SETFMT      = &Hc0045005

const SNDCTL_DSP_SAMPLESIZE  = &Hc0045005 'same as _SETFMT
const SNDCTL_DSP_CHANNELS    = &Hc0045006 '1=mono 2=stereo
const SOUND_PCM_WRITE_FILTER = &Hc0045007

const SNDCTL_DSP_SUBDIVIDE   = &Hc0045009
const SNDCTL_DSP_SETFRAGMENT = &Hc004500A

'arg for SNDCTL_DSP_SETFMT cmd
const AFMT_MU_LAW            = &H00000001
const AFMT_A_LAW             = &H00000002
const AFMT_IMA_ADPCM         = &H00000004
const AFMT_U8                = &H00000008
const AFMT_S16_LE            = &H00000010  ' Little endian signed 
const AFMT_S16_BE            = &H00000020  ' Big endian signed 16 
const AFMT_S8                = &H00000040
const AFMT_U16_LE            = &H00000080  ' Little endian U16 
const AFMT_U16_BE            = &H00000100  ' Big endian U16 
const AFMT_MPEG              = &H00000200  ' MPEG (2) audio 
const AFMT_AC3               = &H00000400  ' Dolby Digital AC3 

type FILEHANDLE as integer

function SYS_ACCESS( _
byval DeviceName as const zstring ptr, _
byval mode       as long) as long
asm
  mov eax, _FBS_ACCESS
  mov ebx, [DeviceName]
  mov ecx, [mode]
  int &H80
  mov [function],eax
end asm
end function

function SYS_OPEN( _
byval DeviceName as const zstring ptr, _
byval flag       as long, _
byval mode       as long=0) as long
asm
  mov eax, _FBS_OPEN
  mov ebx, [DeviceName]
  mov ecx, [flag]
  mov edx, [mode]
  int &H80
  mov [function],eax
end asm
end function

function SYS_IOCTL ( _
byval hDevice as FILEHANDLE, _
byval io_cmd  as long, _
byval lpArg   as long ptr) as long
asm
  mov eax, _FBS_IOCTL
  mov ebx, [hDevice]
  mov ecx, [io_cmd]
  mov edx, [lpArg]
  int &H80
  mov [function],eax
end asm
end function

function SYS_WRITE( _
byval hDevice    as FILEHANDLE, _
byval lpBuffer   as any ptr, _
byval Buffersize as long) as long
asm
  mov eax, _FBS_WRITE
  mov ebx, [hDevice]
  mov ecx, [lpBuffer]
  mov edx, [BufferSize]
  int &H80
  mov [function],eax
end asm
end function

function SYS_READ( _
byval hDevice    as FILEHANDLE, _
byval lpBuffer   as any ptr, _
byval Buffersize as long) as long
asm
  mov eax, _FBS_READ
  mov ebx, [hDevice]
  mov ecx, [lpBuffer]
  mov edx, [Buffersize]
  int &H80
  mov [function],eax
end asm
end function

function SYS_CLOSE( _
byval hDevice as FILEHANDLE) as long
asm
  mov eax, _FBS_CLOSE
  mov ebx, [hDevice]
  int &H80
  mov [function],eax
end asm
end function

#if __FB_OUT_DLL__ = 0
end namespace ' fbsound.plug_dsp
#endif

#endif ' NO_PLUG_DSP

#endif '__FBS_PLUGOUT_DSP__
