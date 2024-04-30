#ifndef __FBS_DSP_BI__
#define __FBS_DSP_BI__

'  #############
' # fbsdsp.bi #
'#############
' Copyright 2005 - 2018 by D.J.Peters (Joshy)
' d.j.peters@web.de

#include once "fbstypes.bi"



const PI         as double = atn(1)*4
const PI2        as double = atn(1)*8
const rad2deg    as double = 180.0/PI
const deg2rad    as double = PI/180.0

declare function fbs_Rad2Deg     (byval as double) as double
declare function fbs_Deg2Rad     (byval as double) as double
declare function fbs_Volume_2_DB (byval as single) as single
declare function fbs_DB_2_Volume (byval as single) as single 
declare function fbs_Pow         (byval as double, byval as double) as double

#inclib "fbsdsp"

#ifndef NO_DSP

#define MAX_FILTERS 10
type FBS_FILTER
  as integer enabled,inuse ' 32/64 bit
  as single  Center,Rate,Octave,dB,Scale
  as single  a1,a2,b0,b1,b2
  as single  x1_l,x2_l,y1_l,y2_l
  as single  x1_r,x2_r,y1_r,y2_r
end type

const _Center = offsetof(FBS_FILTER,Center)
const _Octave = offsetof(FBS_FILTER,Octave)
const _dB     = offsetof(FBS_FILTER,dB)
'const _Scale = offsetof(FBS_FILTER,Scale)
const _a1     = offsetof(FBS_FILTER,a1)
const _a2     = offsetof(FBS_FILTER,a2)
const _b0     = offsetof(FBS_FILTER,b0)
const _b1     = offsetof(FBS_FILTER,b1)
const _b2     = offsetof(FBS_FILTER,b2)

const _x1_l   = offsetof(FBS_FILTER,x1_l)
const _x2_l   = offsetof(FBS_FILTER,x2_l)
const _y1_l   = offsetof(FBS_FILTER,y1_l)
const _y2_l   = offsetof(FBS_FILTER,y2_l)

const _x1_r   = offsetof(FBS_FILTER,x1_r)
const _x2_r   = offsetof(FBS_FILTER,x2_r)
const _y1_r   = offsetof(FBS_FILTER,y1_r)
const _y2_r   = offsetof(FBS_FILTER,y2_r)


 #ifndef NO_PITCHSHIFT
type PitchShift_t as sub(byval des as short ptr, _
                         byval src as short ptr, _
                         byval v as single, _
                         byval r as single, _
                         byval n as integer)

declare sub _PitchShiftMono_asm( _
  byval d as short ptr, _
  byval s as short ptr, _
  byval v as single  , _
  byval r as single  , _
  byval n as integer)

declare sub _PitchShiftStereo_asm(byval d as short ptr, _
                                  byval s as short ptr, _
                                  byval v as single  , _
                                  byval r as single  , _
                                  byval n as integer)
 #endif

declare sub _Set_EQFilter(byval lpFilter as fbs_filter ptr, _
                          byval Center   as single       , _
                          byval dB       as single = 0.0 , _
                          byval Octave   as single = 1.0 , _
                          byval Rate     as single = 44100.0)


type Filter_t as sub(byval des as any ptr, _
                     byval src as any ptr, _
                     byval f   as fbs_filter ptr, _
                     byval n   as integer)
declare sub _Filter_Mono_asm16  (byval des as any ptr, _
                                 byval src as any ptr, _
                                 byval f   as fbs_filter ptr, _
                                 byval n   as integer)
declare sub _Filter_Stereo_asm16(byval des as any ptr, _
                                 byval src as any ptr, _
                                 byval f   as fbs_filter ptr, _
                                 byval n   as integer)




#endif ' NO_DSP

#endif ' __FBS_DSP_BI__
