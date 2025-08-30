#ifndef __FBS_PLUG_CDTOR_BI__
#define __FBS_PLUG_CDTOR_BI__

'' Copyright 2023 by Jeff Marshall
''   coder[at]execulink.com

#if __FB_OUT_DLL__ = 0
'' building static library

#define FBS_MODULE_CDTOR_SCOPE private
#define FBS_MODULE_REGISTER_CDTOR constructor
#define FBS_MODULE_CTOR
#define FBS_MODULE_DTOR

#else ' not( __FB_OUT_DLL__ = 0 )
'' building shared library

#define FBS_MODULE_CDTOR_SCOPE private 
#define FBS_MODULE_REGISTER_CDTOR
#define FBS_MODULE_CTOR constructor
#define FBS_MODULE_DTOR destructor

#endif ' __FB_OUT_DLL__ = 0

#define FBS_GLOBAL_CTOR constructor
#define FBS_GLOBAL_DTOR destructor

#endif ' __FBS_PLUG_CDTOR_BI__