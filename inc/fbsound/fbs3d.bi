#ifndef __FBS_3D_BI__
#define __FBS_3D_BI__

'  ############
' # fbs3d.bi #
'############
' Copyright 2005-2020 by D.J.Peters (Joshy)
' d.j.peters@web.de

#include once "fbstypes.bi"

#ifndef NO_3D

type FBS_V3D
  as single   x,y,z
end type

type FBS_SOUNDOBJECT
  as FBS_V3D  pos,rot,dir
  as boolean  uptodate
  as integer  rp,wp
  as single   lastvolumes(9)
  as single   lastpans(9)
  as single   penumbra
  as single   umbra
  as single   cos_pen,cos_dif
  as single   maxrange
end type

sub fbs_Set_V3D(byval d as FBS_V3D ptr, _
                byval x as single, _
                byval y as single, _
                byval z as single)
  d->x=x:
  d->y=y:
  d->z=z
end sub

sub fbs_Add_V3D(byval d as FBS_V3D ptr,_
                byref a as FBS_V3D    ,_
                byref b as FBS_V3D    )
  d->x=a.x+b.x:
  d->y=a.y+b.y:
  d->z=a.z+b.z
end sub

sub fbs_Sub_V3D(byval d as FBS_V3D ptr,_
                byref a as FBS_V3D    ,_
                byref b as FBS_V3D    )
  d->x=a.x-b.x:
  d->y=a.y-b.y:
  d->z=a.z-b.z
end sub

function fbs_Dot_V3D(byref a as FBS_V3D,_
                     byref b as FBS_V3D) as single
  return a.x*b.x + a.y*b.y + a.z*b.z
end function

sub fbs_Scale_V3D(byval d as FBS_V3D ptr,_
                  byref a as FBS_V3D    ,_
                  byref s as single )
  d->x=a.x*s:
  d->y=a.y*s:
  d->z=a.z*s
end sub

sub fbs_Rotate_V3D(byval d as FBS_V3D ptr, _
                   byref s as FBS_V3D    , _
                   byref r as FBS_V3D    )
  dim as single cx,cy,cz,sx,sy,sz,x,y,z
  sx=sin(r.x):sy=sin(r.y):sz=sin(r.z)
  cx=cos(r.x):cy=cos(r.y):cz=cos(r.z)
  ' alpha
  y   = s.y*cx-s.z*sx
  z   = s.y*sx+s.z*cx
  ' beta
  x   = s.x*cy+z  *sy
  d->z=-s.x*sy+z  *cy
  ' gamma
  d->x= x  *cz-y  *sz
  d->y= x  *sz+y  *cz
end sub

sub fbs_Update(byref o as FBS_SOUNDOBJECT)
  dim as FBs_V3D i
  i.z=1
  fbs_Rotate_V3D(@o.dir,i,o.rot)
end sub


sub fbs_Set_Position(byref o as FBS_SOUNDOBJECT, _
                     byval x as single, _
                     byval y as single, _
                     byval z as single)
  dim as boolean flag=true
  if (x<>o.pos.x) then o.pos.x=x:flag=false
  if (y<>o.pos.y) then o.pos.y=y:flag=false
  if (z<>o.pos.z) then o.pos.z=z:flag=false
  o.uptodate=flag
end sub

sub fbs_Set_Rotation(byref o as FBS_SOUNDOBJECT, _
                     byval x as single, _
                     byval y as single, _
                     byval z as single)
  dim as boolean flag=true
  if (x<>o.rot.x) then o.rot.x=x:flag=false
  if (y<>o.rot.y) then o.rot.y=y:flag=false
  if (z<>o.rot.z) then o.rot.z=z:flag=false
  o.uptodate=flag
end sub


sub fbs_Set_MaxRange(byref o as FBS_SOUNDOBJECT, _
                     byval r as single)
  o.maxrange=abs(r)
end sub

sub fbs_Set_Cone(byref o as FBS_SOUNDOBJECT, _
                 byval p as single, _
                 byval u as single)
  p=abs(p*0.5)
  if (p>1.57) then p=1.57
  u=abs(u*0.5)
  if u>p then u=p
  o.penumbra=p
  o.umbra=u
  o.cos_pen=cos(p)
  o.cos_dif=cos(u)-o.cos_pen
  if o.cos_dif<0.0001 then o.cos_dif=0.0001
end sub

sub fbs_Get_VolumePan(byval v as single ptr     , _
                      byval p as single ptr     , _
                      byref l as FBS_SOUNDOBJECT, _
                      byref s as FBS_SOUNDOBJECT)
  dim as FBS_V3D d,n
  dim as single  m,r,c,rl,rs
  dim as integer i
  if l.uptodate=false then fbs_Update(l)
  if s.uptodate=false then fbs_Update(s)
  fbs_Sub_V3D(@d,s.pos,l.pos)
  m=fbs_Dot_V3D(d,d)
  ' listner and source on same place
  if m=0.0 then *v=1.0:*p=0.0:return
  ' get distance between listner and source
  m=sqr(m)
  rl=l.maxrange:rs=s.maxrange
  ' missing maxrange
  if (rl<=0.0) then rl=300.0
  if (rs<=0.0) then rs=300.0
  ' calc volume
  r=iif(rl<rs,rl,rs)
  *v=1-(m/r)
  if (*v<=0.0) then 
    *v=0.0
  elseif (*v>1.0) then 
    *v=1.0
  else
    *v=*v^2
  end if
    
  if *v=0.0 then
    s.lastvolumes(s.wp)=*v
    s.lastpans(s.wp)   =*p
    s.wp+=1:if s.wp=4 then s.wp=0
    exit sub
  end if

  ' source has no or wrong cone
  if (s.penumbra<=0.0) or (s.penumbra>90*Deg2Rad) then
    c=s.pos.z/m
    if c<0 then 
      c=-s.pos.z/m:*v=(*v * 0.75)
    end if
    *p=(c-1) * sgn(-s.pos.x)
    if *p<-1.0 then 
      *p=-1
    elseif *p>1.0 then
      *p=1
    end if
  else
    fbs_Sub_V3D(@d,l.pos,s.pos)
    m=sqr(fbs_Dot_V3D(d,d))
    fbs_Scale_V3D(@n,d,1.0/m)
    r=fbs_Dot_V3D(n,s.dir)
    ' inside the cone
    if (r>0.0) and (acos(r)<=s.penumbra) then
      fbs_Sub_V3D(@d,s.pos,l.pos)
      m=sqr(fbs_Dot_V3D(d,d))
      c=d.z/m
      if c<0 then 
        c=-d.z/m
        *v=(*v * 0.75)
      end if
      r=(r-s.cos_pen) / s.cos_dif
      if (r<=0.0) then
        *v=0
      elseif (r<=1.0) then
        *v=*v * r
      end if
      *p=(c-1) * sgn(-s.pos.x)
      if *p<-1.0 then *p=-1.0
      if *p> 1.0 then *p= 1.0
    else ' out side of the cone
      *v=0
    endif
  end if
#if 0
  s.lastvolumes(s.wp)=*v
  s.lastpans   (s.wp)=*p
  s.wp+=1:if s.wp=4 then s.wp=0
  *v=0:*p=0
  for i=0 to 3
    *v+=s.lastvolumes(i)
    *v+=s.lastpans   (i)
  next
  *v=*v * 0.25
  *p=*p * 0.25
#endif
end sub

#endif ' NO_3D

#endif ' __FBS_3D_BI__
