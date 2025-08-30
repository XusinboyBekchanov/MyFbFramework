#ifndef __FBS_3D_BI__
#define __FBS_3D_BI__

'  ############
' # fbs3d.bi #
'############
' Copyright 2005-2020 by D.J.Peters (Joshy)
' d.j.peters@web.de

#include once "fbstypes.bi"

#ifndef NO_3D

Type FBS_V3D
  As Single   x,y,z
End Type

Type FBS_SOUNDOBJECT
  As FBS_V3D  pos,rot,dir
  As Boolean  uptodate
  As Integer  rp,wp
  As Single   lastvolumes(9)
  As Single   lastpans(9)
  As Single   penumbra
  As Single   umbra
  As Single   cos_pen,cos_dif
  As Single   maxrange
End Type

Sub fbs_Set_V3D(ByVal d As FBS_V3D Ptr, _
                ByVal x As Single, _
                ByVal y As Single, _
                ByVal z As Single)
  d->x=x:
  d->y=y:
  d->z=z
End Sub

Sub fbs_Add_V3D(ByVal d As FBS_V3D Ptr,_
                ByRef a As FBS_V3D    ,_
                ByRef b As FBS_V3D    )
  d->x=a.x+b.x:
  d->y=a.y+b.y:
  d->z=a.z+b.z
End Sub

Sub fbs_Sub_V3D(ByVal d As FBS_V3D Ptr,_
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
End Sub


Sub fbs_Set_MaxRange(ByRef o As FBS_SOUNDOBJECT, _
                     ByVal r As Single)
  o.maxrange=Abs(r)
End Sub

Sub fbs_Set_Cone(ByRef o As FBS_SOUNDOBJECT, _
                 ByVal p As Single, _
                 ByVal u As Single)
  p=Abs(p*0.5)
  If (p>1.57) Then p=1.57
  u=Abs(u*0.5)
  If u>p Then u=p
  o.penumbra=p
  o.umbra=u
  o.cos_pen=Cos(p)
  o.cos_dif=Cos(u)-o.cos_pen
  If o.cos_dif<0.0001 Then o.cos_dif=0.0001
End Sub

Sub fbs_Get_VolumePan(ByVal v As Single Ptr    , _
                      ByVal p As Single Ptr     , _
                      ByRef l As FBS_SOUNDOBJECT, _
                      ByRef s As FBS_SOUNDOBJECT)
?138:  Dim As FBS_V3D d,n
?139:  Dim As Single  m,r,c,rl,rs
?140:  Dim As Long i
?141:  If l.uptodate=False Then fbs_Update(l)
?142:  If s.uptodate=False Then fbs_Update(s)
?143:  fbs_Sub_V3D(@d,s.pos,l.pos)
?144:  m=fbs_Dot_V3D(d,d)
  ' listner and source on same place
?146:  If m = 0.0 Then *v = 1.0: *p = 0.0: Return
  ' get distance between listner and source
?148:  m=Sqr(m)
?149:  rl=l.maxrange:rs=s.maxrange
  ' missing maxrange
?151:  If (rl<=0.0) Then rl=300.0
?152:  If (rs<=0.0) Then rs=300.0
  ' calc volume
?154:  r=IIf(rl<rs,rl,rs)
?155:  *v=1-(m/r)
?156:  If (*v<=0.0) Then 
?157:    *v=0.0
?158:  ElseIf (*v>1.0) Then 
?159:    *v=1.0
?160:  Else
?161:    *v=*v^2
?162:  End If
    
?164:  If *v=0.0 Then
?165:    s.lastvolumes(s.wp)=*v
?166:    s.lastpans(s.wp)   =*p
?167:    s.wp+=1:If s.wp=4 Then s.wp=0
?168:    Exit Sub
?169:  End If

  ' source has no or wrong cone
?172:  If (s.penumbra<=0.0) Or (s.penumbra>90*Deg2Rad) Then
?173:    c=s.pos.z/m
?174:    If c<0 Then 
?175:      c=-s.pos.z/m:*v=(*v * 0.75)
?176:    End If
?177:    *p=(c-1) * Sgn(-s.pos.x)
?178:    If *p<-1.0 Then 
?179:      *p=-1
?180:    ElseIf *p>1.0 Then
?181:      *p=1
?182:    End If
?183:  Else
?184:    fbs_Sub_V3D(@d,l.pos,s.pos)
?185:    m=Sqr(fbs_Dot_V3D(d,d))
?186:    fbs_Scale_V3D(@n,d,1.0/m)
?187:    r=fbs_Dot_V3D(n,s.dir)
    ' inside the cone
?189:    If (r>0.0) And (Acos(r)<=s.penumbra) Then
?190:      fbs_Sub_V3D(@d,s.pos,l.pos)
?191:      m=Sqr(fbs_Dot_V3D(d,d))
?192:      c=d.z/m
?193:      If c<0 Then 
?194:        c=-d.z/m
?195:        *v=(*v * 0.75)
?196:      End If
?197:      r=(r-s.cos_pen) / s.cos_dif
?198:      If (r<=0.0) Then
?199:        *v=0
?200:      ElseIf (r<=1.0) Then
?201:        *v=*v * r
?202:      End If
?203:      *p=(c-1) * Sgn(-s.pos.x)
?204:      If *p<-1.0 Then *p=-1.0
?205:      If *p> 1.0 Then *p= 1.0
?206:    Else ' out side of the cone
?207:      *v=0
?208:    EndIf
?209:  End If
#if 0
?211:  s.lastvolumes(s.wp)=*v
?212:  s.lastpans   (s.wp) = *p
?213:  s.wp+=1:If s.wp=4 Then s.wp=0
?214:  *v=0:*p=0
?215:  For i=0 To 3
?216:    *v+=s.lastvolumes(i)
?217:    *v+=s.lastpans   (i)
?218:  Next
?219:  *v=*v * 0.25
?220:  *p=*p * 0.25
#endif
End Sub

#endif ' NO_3D

#endif ' __FBS_3D_BI__
