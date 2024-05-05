'  #################################
' # fbs_get_playingsounds_ogg.bas #
'#################################

#include "tests-common.bi"

#ifdef NO_OGG
print "sorry no ogg loader available ! ..."
sleep : end
#else

' same as "test6.bas" but with OGG loader

' example of:
' fbs_Load_OGGFile()
' fbs_Get_PlayingSounds()

const data_path = TESTS_DATA_PATH

chdir(exepath())

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

const scr_width  as integer = 640 '320 640 800 ...
const scr_height as integer = 480 '200 480 600 ...

dim as integer  anim,cfade,frames,fake,hWave
dim as double   r,rstep,i,istep,ioffset,roffset
dim as double   stime,etime,fps
dim as double   r_max,r_min,i_max,i_min,rdiff,idiff,zoom
dim as double   roffsetsoll,ioffsetsoll,zoomsoll
dim as double   roffsetdiff,ioffsetdiff,zoomdiff
dim as double   roffsetstep,ioffsetstep,zoomstep
dim as integer  x2y2,col1,col2,flag
dim as integer  l,a ' xm,ym,l a
dim as byte ptr video_mem
dim as string   k
dim as single   rc,gc,bc,w

const xmax   as integer = (scr_width/2)
const ymax   as integer = (scr_height/2)
const cfstep as single  = 6.28/256

rdiff=3.14:idiff=2.0:zoom=1:anim=1:cfade=1
roffset=-1.12528145737525
ioffset=-0.2838605380885302
zoom   = 0.05332073216078524

screenres scr_width,scr_height

' in this example i use same samplerate as the ogg file!
if fbs_Init(22050)=true then
  setmouse ,,0
  print "wait while decode 'legends.ogg' in memory ..."
  if fbs_Load_OGGFile(data_path & "legends.ogg",@hWave)=true then
    fbs_Play_Wave(hWave)
    while fbs_Get_PlayingSounds()=0:sleep 10:wend
  else
    ? "error: fbs_Load_OGGFile() !"
    beep:sleep:end 1
  end if
end if

'color table
for l=1 to 254
  rc=sin(w)*0.5+0.5
  gc=cos(w*1.125)*0.5+0.5
  bc=sin(w*1.333)*0.5+0.5
  palette l,rc*255,gc*255,bc*255
  w=w+cfstep
next

restore waypoints
palette 255,255,255,255

stime=timer():fps=24
'[esq]=end 
while (a<>27) and (fbs_Get_PlayingSounds()>0) 
  rstep=rdiff*zoom/xmax
  istep=idiff*zoom/ymax
  r_min=roffset-(rdiff*zoom*0.5)
  i_min=ioffset-(idiff*zoom*0.5)

  ScreenLock
  video_mem=screenptr
  select case fake
    case 0

    case 1
      video_mem+=scr_width+1:r_min+=rstep*0.5:i_min+=istep*0.5
    case 2
      video_mem+=1:r_min+=rstep*0.5
    case 3
      video_mem+=scr_width:i_min+=istep*0.5
  end select
  fake+=1:if fake=4 then fake=0
  
  asm
#ifndef __FB_64BIT__
  #define REG EDI
#else
  #define REG RDI
#endif  
  
    mov REG,[video_mem]
    fld qword ptr [rstep] 'rstep on fpu stack
    fld qword ptr [i_min] 'i,rstep
    mov dx,ymax
    asm_for_i:
      fld qword ptr [r_min] 'r,i,rstep
      shl edx,16
      mov dx,xmax
      asm_for_r:
        xor cl,cl           ' iterations counter = 0
        fldz                'y2=0,r,i,rstep
        fldz                'x2=0,y2=0,r,i,rstep
        fldz                'y=0,x2=0,y2=0,r,i,rstep
        fldz                'x=0,y=0,x2=0,y2=0,r,i,rstep
        asm_itera_loop:
          'y=2*x*y+i
          fld  st(0)          'x,x,y,x2,y2,r,i,rstep
          fadd st(0),st(1)    '2*x,x,y,x2,y2,r,i,rstep
          fmul st(0),st(2)    '2*x*y,x,y,x2,y2,r,i,rstep
          fadd st(0),st(6)    '2*y*x+i,x,y,x2,y2,r,i,rstep
          fxch st(2)          'y,x,y,2*x*y+i,x2,y2,r,i,rstep
          fstp st(0)          'x,y,x2,y2,r,i,2
          'x=x2-y2+r
          fld  st(2)          'x2,x,y,x2,y2,r,i,rstep
          fsub st(0),st(4)    'x2-y2,x,y,x2,y2,r,i,rstep
          fadd st(0),st(5)    'x2-y2+r,x,y,x2,y2,r,i,rstep
          fxch st(1)          'x,x2-y2+r,y,x2,y2,r,i,rstep
          fstp st(0)          'x,y,x2,y2,r,i,rstep
          'x2=x*x
          fld  st(0)          'x,x,y,x2,y2,r,i,rstep
          fmul st(0)          'x*x,x,y,x2,y2,r,i,rstep
          fxch st(3)          'x2,x,y,x*x,y2,r,i,rstep
          fstp st(0)          'x,y,x2,y2,r,i,rstep
          'y2=y*y
          fld  st(1)          'y,x,y,x2,y2,i,r,rstep
          fmul st(0)          'y*y,x,y,x2,y2,r,i,rstep
          fxch st(4)          'y2,x,y,x2,y*y,r,i,rstep
          fstp st(0)          'x,y,x2,y2,r,i,rstep

          inc cl              ' itera+=1
          cmp cl,255            ' if itera>max_iterations then exit do
          je asm_nothing
          'if (x2+y2)>4 same as sqr(x2*x2+y2*y2)>2     
          fld st(2)              'x2,x,y,x2,y2,r,i,rstep
          fadd st(0),st(4)       'x2+y2,x,y,x2,y2,r,i,rstep
          fistp dword ptr [x2y2] 'x,y,x2,y2,r,i,rstep
          cmp dword ptr [x2y2],4
          jg asm_found_it
        jmp asm_itera_loop
        asm_nothing:
        mov byte ptr [REG],0

        jmp asm_next
        asm_found_it:

        mov byte ptr [REG],cl '*video_ptr=itera (color)

        asm_next:

        add REG,2             ' video_ptr+=1

        fstp st(0)            'y,x2,y2,r,i,rstep
        fstp st(0)            'x2,y2,r,i,rstep
        fstp st(0)            'y2,r,i,rstep
        fstp st(0)            'r,i,rstep

        dec dx
        cmp dx,0
        je asm_exit_for_r
        'r+=rstep
        fadd st(0),st(2) 'r+rstep,i,rstep
      jmp asm_for_r

      asm_exit_for_r:
      add REG,scr_width
      fstp st(0) 'i,rstep
      shr edx,16
      dec dx
      cmp dx,0
      je asm_exit_for_i
      'i+=istep
      fadd qword ptr [istep] 'i+istep,rstep
    jmp asm_for_i
  asm_exit_for_i:
  fstp st(0) 'rstep
  fstp st(0) 'fpu stack empty
  end asm
  locate 1,1
  color 255
  draw string (0,0),"fps:" & int(fps) & "    "
  ScreenUnlock

  frames+=1
  if frames=50 then
    etime=timer()
    fps=50.0/(etime-stime)
    frames=0
    stime=etime
  end if

  k=inkey:a=len(k)
  if a then
    a=asc(right(k,1))
    select case a
      case 32
        anim=anim xor 1   ' [space] = togle animation on/off
      case 99             ' [c]     = togle colorfade on/off
        cfade=cfade xor 1
      case 72             '[left]   = move left
        ioffset-=istep*4
      case 80             '[right]  = move right
        ioffset+=istep*4
      case 75             '[up]     = move up
        roffset-=rstep*4
      case 77             '[down]   = move down
        roffset+=rstep*4
      case 45             '[+]      = zoom out
        zoom+=rstep*4
      case 43             '[-]      = zoom in
        zoom-=rstep*4
    end select
  else
    sleep 1
  end if
  if anim then
    if flag=0 then
      read roffsetsoll,ioffsetsoll,zoomsoll
      if roffsetsoll=-1.0 and ioffsetsoll=-1.0 and zoomsoll=-1.0 then
        restore waypoints
        read roffsetsoll,ioffsetsoll,zoomsoll
      end if
      roffsetdiff=(roffset-roffsetsoll)/(fps*5)
      ioffsetdiff=(ioffset-ioffsetsoll)/(fps*5)
      zoomdiff=(zoom-zoomsoll)/(fps*5)
      flag=(fps*5)
    end if
    roffset-=roffsetdiff
    ioffset-=ioffsetdiff
    zoom-=zoomdiff
    flag-=1
  end if
  if cfade then
    for l=1 to 253
      palette get l+1,col2
      palette l,col2
    next
    rc=sin(w)*0.5+0.5
    gc=cos(w*1.125)*0.5+0.5
    bc=sin(w*1.333)*0.5+0.5
    palette 254,rc*255,gc*255,bc*255
    w=w+cfstep
  end if
wend
end

waypoints:

data -1.075963307361561,-0.281196168240416 , 0.001278150678731087
data -1.075905981922811,-0.2811152382092401, 0.000337208463233124
data -1.075910747747044,-0.2811017817643467, 2.803426019437017e-05
data -1.07590848672774 ,-0.2810996537461788, 3.325028387365278e-06
data -1.07590848672774 ,-0.2810996537461788, 8.772265518984678e-07
data -1.075907070006857,-0.2810959343055991, 0.01129695497498939
data -1.075907070006857,-0.2810959343055991, 0.08003410897402498
data -1.143936062634779,-0.217068647126379 , 0.08003410897402498
data -1.143210591495763,-0.2105820816481155, 0.004267477288331084
data -1.143210591495763,-0.2103177956315089, 0.0002082036873464023
data -1.307569202089709,-0.4036808669185039, 0.4834076782174874
data -1.255246023079837,-0.3806104444336726, 0.009701562440018335
data -1.250718851773861,-0.3793857663888472, 0.0001630091602868114
data -1.250727676167075,-0.3793674947040732, 1.038163907600416e-05
data -1.250728211206519,-0.3793674947040732, 2.09819389711488e-06
data -1.250724822623374,-0.379366151859979 , 1.345708792003165e-06
data -1.250724482959964,-0.3793664232571313, 1.222702019775483e-07
data -1.250724482959964,-0.3793664163285442, 1.73214681291952e-08
data -1.250724482959964,-0.3793664163285442, 1.495705368346448
data -1.429768163191177, 0.0, 0.05827402421943742
data -1.429916265921348, 0.0, 2.547174155824884e-06
data -1.447242800619238,-0.02075477953116167, 0.01853105315282292
data -1.448491719244281,-0.01683185615982145, 0.000218250277751366
data -1.448494962416383,-0.01685102895821514, 1.271832197158205e-05
data -1.448540366825824,-0.01684899402669969, 1.271832197158205e-05
data -1.448540221908983,-0.01684881859373112, 6.686868933306398e-09
data -1.448540221650768,-0.01684881825349504, 6.075644447976854e-10
data -1.448540222056144,-0.01684881831740589, 8.876504632190959e-11
data -1.448540222056144,-0.01684881831740589, 0.0048015208111237
data -1.447315834249308,-0.006093411700488804, 0.0048015208111237
data -0.2067143705067878, 1.106365997884909, 1.329455317510298e-07
data -1.447575410718678,-0.006302817927879772, 0.0004362629737311815
data -1.447546060932151,-0.006275194599384553, 0.0001150972020634162
data -1.447549946836704,-0.006278851921316968, 1.142913103880331e-05
data -1.447549953773961,-0.006278904154782063, 2.720492973799422e-08
data -1.447549953773961,-0.006278904154782063, 0.0959551631790438
data -1.847203208414673,-0.006278904154782063, 0.0959551631790438
data -1.448540211341738,-0.01684882329907699, 1.049950669433006e-07
data -1.860985543961812, 5.730536102542537e-05, 0.02472605136870849
data -1.861382365188764, 0.0001280447521777783, 7.575700083603683e-07
data -1.861382300909908, 0.000128060841636056, 6.787177454139503e-10
data -1.861382300909908, 0.000128060841636056, 1.80301591945143
data  0.1309502900839218, 1.298299522846665, 1.80301591945143
data -0.1984145909714904, 1.100352449330687, 0.001352409399890011
data -0.1987733287401083, 1.100407573501614, 8.613151707517529e-05
data -0.1987927587686087, 1.100406817836918, 1.88916174031882e-06
data -0.1987926341447898, 1.100406706717228, 7.716645119686126e-08
data -1.448540221693981,-0.01684881825349504, 8.876504632190959e-11
data -0.1987926374785418, 1.100406704868181, 0.002943719650420304
data -0.2065493387573994, 1.106765139313087, 0.002943719650420304
data -0.206697724315536, 1.106402031123765, 0.0003491424897332628
data -0.2067125121193846, 1.106368035391356, 1.193999868780553e-05
data -0.2067148243436442, 1.106365903599446, 9.856968272467161e-08
data -0.2067148338391115, 1.106365912536355, 1.396392244558323e-08
data -0.2067148338391115, 1.106365912816002, 6.570202991474562e-10
data -0.2067148338855405, 1.106365912816002, 4.997933986013956e-11
data -0.2067148338502975, 1.106365912809265, 4.565903560075121e-12
data -0.1987926374785418, 1.100406704868181, 2.620466114794424e-10
data -0.2067148338219658, 1.106365912799768, 4.565903560075121e-12
data -0.2067148338219658, 1.106365912799768, 1.329455317510298e-07
data -0.2067143705067878, 1.106365997884909, 1.329455317510298e-07
data -0.2067143793444081, 1.10636599573528, 3.1423647016843e-11
data -0.2067143793495975, 1.106365995736637, 3.391748679138347e-12
data -0.2067143793494169, 1.106365995736712, 2.360785268886536e-13
data -0.2067143793494169, 1.106365995736712, 8.62035957278071e-08
data -0.2067139910022188, 1.106366050907014, 8.12035957278071e-08
data -0.2067139910022188, 1.106366050907014, 10.0
data -0.0, 0.0, 20.0
data  0.0, 0.0, 1.0
data -1.0,-1.0,-1.0

#endif
