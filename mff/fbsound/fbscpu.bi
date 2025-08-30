#ifndef __MMNCPU_BI__
#define __MMNCPU_BI__

'  #############
' # fbscpu.bi #
'#############
' Copyright 2005-2020 by D.J.Peters (Joshy)
' d.j.peters@web.de

#include once "fbstypes.bi"

#inclib "fbscpu"

declare function IsX86_64() as boolean
declare function IsFPU() as boolean
declare function IsTSC() as boolean
declare function IsCMOV() as boolean

declare function IsMMX() as boolean
declare function IsMMX2() as boolean

declare function IsSSE() as boolean
declare function IsSSE2() as boolean
declare function IsSSE3() as boolean
declare function IsSSE41() as boolean
declare function IsSSE42() as boolean

declare function IsNOW3D() as boolean
declare function IsNOW3D2() as boolean

declare function MHz() as integer
declare function CPUCores() as integer

type counter_t as function () as longint
declare function _SoftCounter() as longint
declare function CPUCounter() as longint

type zero_t as sub (byval d as any ptr, byval n as integer)
declare sub Zero   (byval d as any ptr, byval n as integer)

type zerobuffer_t as sub (byval s as any ptr,byval p as any ptr ptr, byval e as any ptr, byval n as integer)
declare sub ZeroBuffer   (byval s as any ptr,byval p as any ptr ptr, byval e as any ptr, byval n as integer)

type copy_t as sub (byval d as any ptr, byval s as any ptr, byval n as integer)
declare sub Copy   (byval d as any ptr, byval s as any ptr, byval n as integer)


type mix16_t as sub (byval d as any ptr, byval a as any ptr, byval b as any ptr, byval n as integer)
declare sub Mix16   (byval d as any ptr, byval a as any ptr, byval b as any ptr, byval n as integer)


type scale16_t as sub (byval d as any ptr, byval s as any ptr, byval v as single, byval n as integer)
declare sub Scale16   (byval d as any ptr, byval s as any ptr, byval v as single, byval n as integer)


type panleft16_t  as sub (byval d as any ptr, byval s as any ptr, byval v as single, byval n as integer)
type panright16_t as sub (byval d as any ptr, byval s as any ptr, byval v as single, byval n as integer)

type pan16_t as sub (byval d as any ptr, byval s as any ptr, _
                    byval l as single , byval r as single , _
                    byval n as integer)
declare sub Pan16  (byval d as any ptr, byval s as any ptr, _
                    byval l as single, byval r as single, _
                    byval n as integer)

' right (forward)
type copyright16_t as sub (byval d as any ptr    , byval s as any ptr,  _
                           byval p as any ptr ptr, byval e as any ptr, _
                           byval l as integer ptr, byval n as integer)
declare sub CopyRight16   (byval d as any ptr    , byval s as any ptr, _
                           byval p as any ptr ptr, byval e as any ptr , _
                           byval l as integer ptr, byval n as integer)

type copyright32_t as sub (byval d as any ptr    , byval s as any ptr, _
                           byval p as any ptr ptr, byval e as any ptr, _
                           byval l as integer ptr, byval n as integer)
declare sub CopyRight32   (byval d as any ptr    , byval s as any ptr, _
                           byval p as any ptr ptr, byval e as any ptr, _
                           byval l as integer ptr, byval n as integer)

type moveright16_t as sub (byval s as any ptr, _
                           byval p as any ptr ptr, byval e as any ptr, _
                           byval l as integer ptr, byval n as integer)
declare sub MoveRight16   (byval s as any ptr, _
                           byval p as any ptr ptr, byval e as any ptr, _
                           byval l as integer ptr, byval n as integer)

type moveright32_t as sub (byval s as any ptr, _
                           byval p as any ptr ptr, byval e as any ptr, _
                           byval l as integer ptr, byval n as integer)
declare sub MoveRight32   (byval s as any ptr, _
                           byval p as any ptr ptr, byval e as any ptr, _
                           byval l as integer ptr, byval n as integer)


type copysliceright16_t as sub (byval d as any ptr    , byval s as any ptr, _
                                byval p as any ptr ptr, byval e as any ptr, _
                                byval l as integer ptr, byval v as single, byval n as integer)
declare sub CopySliceRight16   (byval d as any ptr    , byval s as any ptr, _
                                byval p as any ptr ptr, byval e as any ptr, _
                                byval l as integer ptr, byval v as single, byval n as integer)

type copysliceright32_t as sub (byval d as any ptr    , byval s as any ptr, _
                                byval p as any ptr ptr, byval e as any ptr, _
                                byval l as integer ptr, byval v as single, byval n as integer)
declare sub CopySliceRight32   (byval d as any ptr    , byval s as any ptr, _
                                byval p as any ptr ptr, byval e as any ptr, _
                                byval l as integer ptr, byval v as single, byval n as integer)

type movesliceright16_t as sub (byval s as any ptr, _
                                byval p as any ptr ptr, byval e as any ptr, _
                                byval l as integer ptr, byval v as single, byval n as integer)
declare sub MoveSliceRight16   (byval s as any ptr, _
                                byval p as any ptr ptr, byval e as any ptr, _
                                byval l as integer ptr, byval v as single, byval n as integer)
                                
type movesliceright32_t as sub (byval s as any ptr, _
                                byval p as any ptr ptr, byval e as any ptr, _
                                byval l as integer ptr, byval v as single, byval n as integer)
declare sub MoveSliceRight32   (byval s as any ptr, _
                                byval p as any ptr ptr, byval e as any ptr, _
                                byval l as integer ptr, byval v as single, byval n as integer)

' left direction (backwards)
type copysliceleft16_t as sub (byval d as any ptr    , byval s as any ptr,  _
                               byval p as any ptr ptr, byval e as any ptr, _
                               byval l as integer ptr, byval v as single , byval n as integer)
declare sub CopySliceLeft16   (byval d as any ptr    , byval s as any ptr, _
                               byval p as any ptr ptr, byval e as any ptr, _
                               byval l as integer ptr, byval v as single , byval n as integer)

type copysliceleft32_t as sub (byval d as any ptr    , byval s as any ptr, _
                               byval p as any ptr ptr, byval e as any ptr, _
                               byval l as integer ptr, byval v as single , byval n as integer)
declare sub CopySliceLeft32   (byval d as any ptr    , byval s as any ptr, _
                               byval p as any ptr ptr, byval e as any ptr, _
                               byval l as integer ptr, byval v as single, byval n as integer)

type movesliceleft16_t as sub (byval s as any ptr    , _
                               byval p as any ptr ptr, byval e as any ptr,  _
                               byval l as integer ptr, byval v as single , byval n as integer)
declare sub MoveSliceLeft16   (byval s as any ptr    , _
                               byval p as any ptr ptr, byval e as any ptr, _
                               byval l as integer ptr, byval v as single , byval n as integer)

type movesliceleft32_t as sub (byval s as any ptr, _
                               byval p as any ptr ptr, byval e as any ptr, _
                               byval l as integer ptr, byval v as single , byval n as integer)
declare sub MoveSliceLeft32   (byval s as any ptr, _
                               byval p as any ptr ptr, byval e as any ptr, _
                               byval l as integer ptr, byval v as single , byval n as integer)


#ifndef NO_MP3
type CopyMP3Frame_t as sub        (byval s as any ptr, byval p as any ptr ptr, byval e as any ptr, byval a as any ptr, byval n as integer)
declare sub CopyMP3Frame          (byval s as any ptr, byval p as any ptr ptr, byval e as any ptr, byval f as any ptr, byval n as integer)

type CopySliceMP3Frame32_t as sub (byval s as any ptr, byval p as any ptr ptr, byval e as any ptr, byval a as any ptr, byval v as single, byval n as integer)
declare sub CopySliceMP3Frame32   (byval s as any ptr, byval p as any ptr ptr, byval e as any ptr, byval f as any ptr, byval v as single, byval n as integer)

type CopySliceMP3Frame16_t as sub (byval s as any ptr, byval p as any ptr ptr, byval e as any ptr, byval a as any ptr, byval v as single, byval n as integer)
declare sub CopySliceMP3Frame16   (byval s as any ptr, byval p as any ptr ptr, byval e as any ptr, byval f as any ptr, byval v as single, byval n as integer)

type ScaleMP3Frame_22_16_t as sub (byval d as any ptr, byval a as any ptr, byval b as any ptr, byval n as integer)
declare sub ScaleMP3Frame_22_16   (byval d as any ptr, byval a as any ptr, byval b as any ptr ,byval n as integer)

type ScaleMP3Frame_21_16_t as sub (byval d as any ptr, byval a as any ptr, byval b as any ptr, byval n as integer)
declare sub ScaleMP3Frame_21_16   (byval d as any ptr, byval a as any ptr, byval b as any ptr ,byval n as integer)

type ScaleMP3Frame_12_16_t as sub (byval d as any ptr, byval a as any ptr, byval n as integer)
declare sub ScaleMP3Frame_12_16   (byval d as any ptr, byval s as any ptr, byval n as integer)

type ScaleMP3Frame_11_16_t as sub (byval d as any ptr, byval b as any ptr, byval n as integer)
declare sub ScaleMP3Frame_11_16   (byval d as any ptr, byval s as any ptr, byval n as integer)
#endif

type FBS_CPU
  as boolean x86_64, fpu, cpuid, tsc, cmov
  as boolean mmx, mmx2, n3D,n3D2
  as boolean sse,sse2,sse3,sse41,sse42
  as integer MHz, nCores
  as double  Start
  as string*12 Vendor
 
  as counter_t             CpuCounter
  
  as zero_t                Zero
  as zerobuffer_t          ZeroBuffer 
  as copy_t                Copy

  as mix16_t               Mix16
  as scale16_t             Scale16
    
  as panleft16_t           PanLeft16
  as panright16_t          PanRight16

  as copyright16_t         CopyRight16
  as copyright32_t         CopyRight32
  
  as moveright16_t         MoveRight16
  as moveright32_t         MoveRight32

  as copysliceright16_t    CopySliceRight16
  as copysliceright32_t    CopySliceRight32
  
  as movesliceright16_t    MoveSliceRight16
  as movesliceright32_t    MoveSliceRight32

  as copysliceleft16_t     CopySliceLeft16
  as copysliceleft32_t     CopySliceLeft32
  
  as movesliceleft16_t     MoveSliceLeft16
  as movesliceleft32_t     MoveSliceLeft32
  
#ifndef NO_MP3
  as CopyMP3Frame_t        CopyMP3Frame
  as CopySliceMP3Frame32_t CopySliceMP3Frame32
  as CopySliceMP3Frame16_t CopySliceMP3Frame16
  as ScaleMP3Frame_22_16_t ScaleMP3Frame_22_16
  as ScaleMP3Frame_21_16_t ScaleMP3Frame_21_16
  as ScaleMP3Frame_12_16_t ScaleMP3Frame_12_16
  as ScaleMP3Frame_11_16_t ScaleMP3Frame_11_16
#endif
end type


#endif ' __MMNCPU_BI__
