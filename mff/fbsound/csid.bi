#ifndef __CSID_BI__
#define __CSID_BI__

#ifndef NO_SID
 
#inclib "csid"

#define SIDMODEL_8580 8580
#define SIDMODEL_6581 6581

#define DEFAULT_SIDMODEL SIDMODEL_6581

extern "C"

declare sub      libcsid_init(byval samplerate as long, byval sidmodel as long=DEFAULT_SIDMODEL)
declare function libcsid_load(byval buffer as any ptr, byval nBufferSize as long, byval subtune as long=0) as long
declare function libcsid_getauthor() as const zstring ptr
declare function libcsid_getinfo() as const zstring ptr
declare function libcsid_gettitle() as const zstring ptr
declare sub      libcsid_render(byval buffer as any ptr, byval nChannels as long, byval nBytes as long)

end extern

#endif ' NO_SID

#endif ' __CSID_BI__