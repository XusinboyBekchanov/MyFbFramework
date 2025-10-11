'https://github.com/cesanta/mongoose
'See https://mongoose.ws/ for complete documentation, videos, case studies, etc. 
#pragma once
#ifndef MONGOOSE_H
	#define MONGOOSE_H
	#include once "crt/long.bi"
	#include once "crt/ctype.bi"
	#include once "crt/errno.bi"
	#include once "crt/limits.bi"
	#include once "crt/stdarg.bi"
	#include once "crt/stddef.bi"
	#include once "crt/stdio.bi"
	#include once "crt/stdlib.bi"
	#include once "crt/string.bi"
	#include once "crt/sys/types.bi"
	#include once "crt/time.bi"
	#include once "crt/stdint.bi"
	#inclib "mongoose"
	#inclib "ws2_32"
	#inclib "Bcrypt"
	#inclib "mbedtls"
	#inclib "mbedcrypto"
	#inclib "mbedx509"
	
	Extern "C"
		
		#define MG_VERSION "7.18"
		Type bool As Byte
		Const MG_ARCH_CUSTOM = 0
		Const MG_ARCH_UNIX = 1
		Const MG_ARCH_WIN32 = 2
		Const MG_ARCH_ESP32 = 3
		Const MG_ARCH_ESP8266 = 4
		Const MG_ARCH_FREERTOS = 5
		Const MG_ARCH_AZURERTOS = 6
		Const MG_ARCH_ZEPHYR = 7
		Const MG_ARCH_NEWLIB = 8
		Const MG_ARCH_CMSIS_RTOS1 = 9
		Const MG_ARCH_TIRTOS = 10
		Const MG_ARCH_PICOSDK = 11
		Const MG_ARCH_ARMCC = 12
		Const MG_ARCH_CMSIS_RTOS2 = 13
		Const MG_ARCH_RTTHREAD = 14
		Const MG_ARCH_ARMCGT = 15
		#define MG_BIG_ENDIAN ((*CPtr(UShort Ptr, @!"\0\255")) < &h100)
		Const MG_ENABLE_WINSOCK = 1
		#define _CRT_RAND_S
		#define WIN32_LEAN_AND_MEAN
		#define _CRT_SECURE_NO_WARNINGS
		#define _WINSOCK_DEPRECATED_NO_WARNINGS
		#define strdup(x) _strdup(x)
		Type nfds_t As culong
		#define MG_DIRSEP Asc(!"\\")
		#define MG_PATH_MAX FILENAME_MAX
		#define MG_INVALID_SOCKET INVALID_SOCKET
		#define MG_SOCKET_TYPE SOCKET
		#define poll(a, b, c) WSAPoll((a), (b), (c))
		#define closesocket(x) closesocket(x)
		Type socklen_t As Long
		#define SO_EXCLUSIVEADDRUSE CLng(Not SO_REUSEADDR)
		#define MG_SOCK_ERR(errcode) IIf((errcode) < 0, WSAGetLastError(), 0)
		#define MG_SOCK_PENDING(errcode) (((errcode) < 0) AndAlso (((WSAGetLastError() = WSAEINTR) OrElse (WSAGetLastError() = WSAEINPROGRESS)) OrElse (WSAGetLastError() = WSAEWOULDBLOCK)))
		#define MG_SOCK_RESET(errcode) (((errcode) < 0) AndAlso (WSAGetLastError() = WSAECONNRESET))
		#define realpath(a, b) _fullpath((b), (a), MG_PATH_MAX)
		#define timegm(x) _mkgmtime(x)
		#define S_ISDIR(x) (((x) And _S_IFMT) = _S_IFDIR)
		Const MG_ENABLE_DIRLIST = 1
		Const SIGPIPE = 0
		Const MG_ENABLE_POSIX_FS = 1
		Const MG_IO_SIZE = 16384
		Const MG_ENABLE_LOG = 1
		Const MG_ENABLE_CUSTOM_LOG = 0
		Const MG_ENABLE_TCPIP = 0
		Const MG_ENABLE_LWIP = 0
		Const MG_ENABLE_FREERTOS_TCP = 0
		Const MG_ENABLE_RL = 0
		Const MG_ENABLE_SOCKET = MG_ENABLE_TCPIP = 0
		Const MG_ENABLE_POLL = 0
		Const MG_ENABLE_EPOLL = 0
		Const MG_ENABLE_FATFS = 0
		Const MG_ENABLE_SSI = 0
		Const MG_ENABLE_IPV6 = 0
		Const MG_IPV6_V6ONLY = 0
		Const MG_ENABLE_MD5 = 1
		Const MG_ENABLE_CUSTOM_RANDOM = 0
		Const MG_ENABLE_CUSTOM_MILLIS = 0
		Const MG_ENABLE_PACKED_FS = 0
		Const MG_ENABLE_ASSERT = 0
		Const MG_MAX_RECV_SIZE = (Cast(culong, 3) * Cast(culong, 1024)) * Cast(culong, 1024)
		Const MG_DATA_SIZE = 32
		Const MG_MAX_HTTP_HEADERS = 30
		#define MG_HTTP_INDEX "index.html"
		Const MG_SOCK_LISTEN_BACKLOG_SIZE = 128
		#define MG_SOCKET_ERRNO errno
		#define MG_EPOLL_ADD(c)
		#define MG_EPOLL_MOD(c, wr)
		Const MG_ENABLE_PROFILE = 0
		Const MG_ENABLE_TCPIP_DRIVER_INIT = 1
		#define MG_TCPIP_IP MG_IPV4(0, 0, 0, 0)
		#define MG_TCPIP_MASK MG_IPV4(0, 0, 0, 0)
		#define MG_TCPIP_GW MG_IPV4(0, 0, 0, 0)
		#define MG_SET_MAC_ADDRESS(mac)
		#define MG_SET_WIFI_CONFIG(data_)
		Const MG_ENABLE_TCPIP_PRINT_DEBUG_STATS = 0
		
		Type mg_str
			buf As ZString Ptr
			len_ As UInteger
		End Type
		
		Declare Function mg_str_s(ByVal s As Const ZString Ptr) As mg_str
		Declare Function mg_str_n(ByVal s As Const ZString Ptr, ByVal n As UInteger) As mg_str
		Declare Function mg_casecmp(ByVal s1 As Const ZString Ptr, ByVal s2 As Const ZString Ptr) As Long
		Declare Function mg_strcmp(ByVal str1 As Const mg_str, ByVal str2 As Const mg_str) As Long
		Declare Function mg_strcasecmp(ByVal str1 As Const mg_str, ByVal str2 As Const mg_str) As Long
		Declare Function mg_strdup(ByVal s As Const mg_str) As mg_str
		Declare Function mg_match(ByVal str_ As mg_str, ByVal PATTERN As mg_str, ByVal caps As mg_str Ptr) As bool
		Declare Function mg_span(ByVal s As mg_str, ByVal a As mg_str Ptr, ByVal b As mg_str Ptr, ByVal delim As Byte) As bool
		Declare Function mg_str_to_num(ByVal As mg_str, ByVal base As Long, ByVal val_ As Any Ptr, ByVal val_len As UInteger) As bool
		
		Type mg_queue
			buf As ZString Ptr
			size As UInteger
			tail As UInteger
			head As UInteger
		End Type
		
		Declare Sub mg_queue_init(ByVal As mg_queue Ptr, ByVal As ZString Ptr, ByVal As UInteger)
		Declare Function mg_queue_book(ByVal As mg_queue Ptr, ByVal buf As ZString Ptr Ptr, ByVal As UInteger) As UInteger
		Declare Sub mg_queue_add(ByVal As mg_queue Ptr, ByVal As UInteger)
		Declare Function mg_queue_next(ByVal As mg_queue Ptr, ByVal As ZString Ptr Ptr) As UInteger
		Declare Sub mg_queue_del(ByVal As mg_queue Ptr, ByVal As UInteger)
		Type mg_pfn_t As Sub(ByVal As Byte, ByVal As Any Ptr)
		Type mg_pm_t As Function(ByVal As mg_pfn_t, ByVal As Any Ptr, ByVal As va_list Ptr) As UInteger
		Declare Function mg_vxprintf(ByVal As Sub(ByVal As Byte, ByVal As Any Ptr), ByVal As Any Ptr, ByVal fmt As Const ZString Ptr, ByVal As va_list Ptr) As UInteger
		Declare Function mg_xprintf(ByVal fn As Sub(ByVal As Byte, ByVal As Any Ptr), ByVal As Any Ptr, ByVal fmt As Const ZString Ptr, ...) As UInteger
		Declare Function mg_vsnprintf(ByVal buf As ZString Ptr, ByVal len_ As UInteger, ByVal fmt As Const ZString Ptr, ByVal ap As va_list Ptr) As UInteger
		Declare Function mg_snprintf(ByVal As ZString Ptr, ByVal As UInteger, ByVal fmt As Const ZString Ptr, ...) As UInteger
		Declare Function mg_vmprintf(ByVal fmt As Const ZString Ptr, ByVal ap As va_list Ptr) As ZString Ptr
		Declare Function mg_mprintf(ByVal fmt As Const ZString Ptr, ...) As ZString Ptr
		Declare Function mg_queue_vprintf(ByVal As mg_queue Ptr, ByVal fmt As Const ZString Ptr, ByVal As va_list Ptr) As UInteger
		Declare Function mg_queue_printf(ByVal As mg_queue Ptr, ByVal fmt As Const ZString Ptr, ...) As UInteger
		Declare Function mg_print_base64(ByVal out_ As Sub(ByVal As Byte, ByVal As Any Ptr), ByVal arg As Any Ptr, ByVal ap As va_list Ptr) As UInteger
		Declare Function mg_print_esc(ByVal out_ As Sub(ByVal As Byte, ByVal As Any Ptr), ByVal arg As Any Ptr, ByVal ap As va_list Ptr) As UInteger
		Declare Function mg_print_hex(ByVal out_ As Sub(ByVal As Byte, ByVal As Any Ptr), ByVal arg As Any Ptr, ByVal ap As va_list Ptr) As UInteger
		Declare Function mg_print_ip(ByVal out_ As Sub(ByVal As Byte, ByVal As Any Ptr), ByVal arg As Any Ptr, ByVal ap As va_list Ptr) As UInteger
		Declare Function mg_print_ip_port(ByVal out_ As Sub(ByVal As Byte, ByVal As Any Ptr), ByVal arg As Any Ptr, ByVal ap As va_list Ptr) As UInteger
		Declare Function mg_print_ip4(ByVal out_ As Sub(ByVal As Byte, ByVal As Any Ptr), ByVal arg As Any Ptr, ByVal ap As va_list Ptr) As UInteger
		Declare Function mg_print_ip6(ByVal out_ As Sub(ByVal As Byte, ByVal As Any Ptr), ByVal arg As Any Ptr, ByVal ap As va_list Ptr) As UInteger
		Declare Function mg_print_mac(ByVal out_ As Sub(ByVal As Byte, ByVal As Any Ptr), ByVal arg As Any Ptr, ByVal ap As va_list Ptr) As UInteger
		Declare Sub mg_pfn_iobuf(ByVal ch As Byte, ByVal param As Any Ptr)
		Declare Sub mg_pfn_stdout(ByVal c As Byte, ByVal param As Any Ptr)
		#define MG_ESC(str1) Cast(Any Ptr,@mg_print_esc),0, (str1)
		
		Enum
			MG_LL_NONE
			MG_LL_ERROR
			MG_LL_INFO
			MG_LL_DEBUG
			MG_LL_VERBOSE
		End Enum
		
		Extern mg_log_level As Long
		Declare Sub mg_log(ByVal fmt As Const ZString Ptr, ...)
		Declare Sub mg_log_prefix(ByVal ll As Long, ByVal file As Const ZString Ptr, ByVal Line As Long, ByVal fname As Const ZString Ptr)
		Declare Sub mg_hexdump(ByVal buf As Const Any Ptr, ByVal len_ As UInteger)
		Declare Sub mg_log_set_fn(ByVal fn As mg_pfn_t, ByVal param As Any Ptr)
		
		#define mg_log_set(level_) Scope : mg_log_level = (level_) : End Scope
	#macro MG_LOG_(level, args...)
		Scope
			If (level) <= mg_log_level Then
				mg_log_prefix((level), __FILE__, __LINE__, __FUNCTION__)
				mg_log (args)
			End If
		End Scope
	#endmacro
	#define MG_INFO(args...) MG_LOG_(MG_LL_INFO, args)
	#define MG_ERROR_(args...) MG_LOG_(MG_LL_ERROR, args)
	#define MG_DEBUG(args...) MG_LOG_(MG_LL_DEBUG, args)
	#define MG_VERBOSE(args...) MG_LOG_(MG_LL_VERBOSE, args)
	
	Type mg_timer
		period_ms As ULongInt
		expire As ULongInt
		flags As ULong
		fn As Sub(ByVal As Any Ptr)
		arg As Any Ptr
		next_ As mg_timer Ptr
	End Type
	
	Const MG_TIMER_ONCE = 0
	Const MG_TIMER_REPEAT = 1
	Const MG_TIMER_RUN_NOW = 2
	Const MG_TIMER_CALLED = 4
	Const MG_TIMER_AUTODELETE = 8
	
	Declare Sub mg_timer_init(ByVal head As mg_timer Ptr Ptr, ByVal timer As mg_timer Ptr, ByVal milliseconds As ULongInt, ByVal flags As ULong, ByVal fn As Sub(ByVal As Any Ptr), ByVal arg As Any Ptr)
	Declare Sub mg_timer_free(ByVal head As mg_timer Ptr Ptr, ByVal As mg_timer Ptr)
	Declare Sub mg_timer_poll(ByVal head As mg_timer Ptr Ptr, ByVal new_ms As ULongInt)
	Declare Function mg_timer_expired(ByVal expiration As ULongInt Ptr, ByVal period As ULongInt, ByVal now As ULongInt) As bool
	
	Enum
		MG_FS_READ = 1
		MG_FS_WRITE = 2
		MG_FS_DIR = 4
	End Enum
	
	Type mg_fs
		st As Function(ByVal path As Const ZString Ptr, ByVal size As UInteger Ptr, ByVal mtime As time_t Ptr) As Long
		ls As Sub(ByVal path As Const ZString Ptr, ByVal fn As Sub(ByVal As Const ZString Ptr, ByVal As Any Ptr), ByVal As Any Ptr)
		op As Function(ByVal path As Const ZString Ptr, ByVal flags As Long) As Any Ptr
		cl As Sub(ByVal fd As Any Ptr)
		rd As Function(ByVal fd As Any Ptr, ByVal buf As Any Ptr, ByVal len_ As UInteger) As UInteger
		wr As Function(ByVal fd As Any Ptr, ByVal buf As Const Any Ptr, ByVal len_ As UInteger) As UInteger
		sk As Function(ByVal fd As Any Ptr, ByVal offset As UInteger) As UInteger
		mv As Function(ByVal from As Const ZString Ptr, ByVal to As Const ZString Ptr) As bool
		rm As Function(ByVal path As Const ZString Ptr) As bool
		mkd As Function(ByVal path As Const ZString Ptr) As bool
	End Type
	
	Extern mg_fs_posix As mg_fs
	Extern mg_fs_packed As mg_fs
	Extern mg_fs_fat As mg_fs
	
	Type mg_fd
		fd As Any Ptr
		fs As mg_fs Ptr
	End Type
	
	Declare Function mg_fs_open(ByVal fs As mg_fs Ptr, ByVal path As Const ZString Ptr, ByVal flags As Long) As mg_fd Ptr
	Declare Sub mg_fs_close(ByVal fd As mg_fd Ptr)
	Declare Function mg_fs_ls(ByVal fs As mg_fs Ptr, ByVal path As Const ZString Ptr, ByVal buf As ZString Ptr, ByVal len_ As UInteger) As bool
	Declare Function mg_file_read(ByVal fs As mg_fs Ptr, ByVal path As Const ZString Ptr) As mg_str
	Declare Function mg_file_write(ByVal fs As mg_fs Ptr, ByVal path As Const ZString Ptr, ByVal As Const Any Ptr, ByVal As UInteger) As bool
	Declare Function mg_file_printf(ByVal fs As mg_fs Ptr, ByVal path As Const ZString Ptr, ByVal fmt As Const ZString Ptr, ...) As bool
	Declare Function mg_unpack(ByVal path As Const ZString Ptr, ByVal size As UInteger Ptr, ByVal mtime As time_t Ptr) As Const ZString Ptr
	Declare Function mg_unlist(ByVal no As UInteger) As Const ZString Ptr
	Declare Function mg_unpacked(ByVal path As Const ZString Ptr) As mg_str
	
	Declare Sub mg_bzero(ByVal buf As UByte Ptr, ByVal len_ As UInteger)
	Declare Function mg_random(ByVal buf As Any Ptr, ByVal len_ As UInteger) As bool
	Declare Function mg_random_str(ByVal buf As ZString Ptr, ByVal len_ As UInteger) As ZString Ptr
	Declare Function mg_crc32(ByVal crc As ULong, ByVal buf As Const ZString Ptr, ByVal len_ As UInteger) As ULong
	Declare Function mg_millis() As ULongInt
	Declare Function mg_path_is_sane(ByVal path As Const mg_str) As bool
	Declare Sub mg_delayms(ByVal ms As ULong)
	
	#define MG_U32(a, b, c, d) CULng(CULng(CULng(CULng(CULng((a) And 255) Shl 24) Or CULng(CULng((b) And 255) Shl 16)) Or CULng(CULng((c) And 255) Shl 8)) Or CULng((d) And 255))
	#define MG_IPV4(a, b, c, d) mg_htonl(MG_U32(a, b, c, d))
	#define MG_U8P(ADDR) CPtr(UByte Ptr, (ADDR))
	'' TODO: #define MG_IPADDR_PARTS(ADDR) MG_U8P(ADDR)[0], MG_U8P(ADDR)[1], MG_U8P(ADDR)[2], MG_U8P(ADDR)[3]
	#define MG_LOAD_BE16(p) CUShort((CUShort(MG_U8P(p)[0]) Shl 8u) Or MG_U8P(p)[1])
	#define MG_LOAD_BE24(p) CULng(CULng(CULng(CULng(MG_U8P(p)[0]) Shl 16u) Or CULng(CULng(MG_U8P(p)[1]) Shl 8u)) Or MG_U8P(p)[2])
	#define MG_LOAD_BE32(p) CULng(CULng(CULng(CULng(CULng(MG_U8P(p)[0]) Shl 24u) Or CULng(CULng(MG_U8P(p)[1]) Shl 16u)) Or CULng(CULng(MG_U8P(p)[2]) Shl 8u)) Or MG_U8P(p)[3])
	#macro MG_STORE_BE16(p, n)
		Scope
			MG_U8P(p)[0] = ((n) Shr 8u) And 255
			MG_U8P(p)[1] = (n) And 255
		End Scope
	#endmacro
	#macro MG_STORE_BE24(p, n)
		Scope
			MG_U8P(p)[0] = ((n) Shr 16u) And 255
			MG_U8P(p)[1] = ((n) Shr 8u) And 255
			MG_U8P(p)[2] = (n) And 255
		End Scope
	#endmacro
	#macro MG_STORE_BE32(p, n)
		Scope
			MG_U8P(p)[0] = ((n) Shr 24u) And 255
			MG_U8P(p)[1] = ((n) Shr 16u) And 255
			MG_U8P(p)[2] = ((n) Shr 8u) And 255
			MG_U8P(p)[3] = (n) And 255
		End Scope
	#endmacro
	Declare Function mg_ntohs(ByVal net As UShort) As UShort
	Declare Function mg_ntohl(ByVal net As ULong) As ULong
	#define mg_htons(x) mg_ntohs(x)
	#define mg_htonl(x) mg_ntohl(x)
	#define MG_REG(x) CPtr(ULong Ptr, (x))[0]
	#define MG_BIT(x) CULng(CULng(1u) Shl (x))
	#define MG_SET_BITS(R, CLRMASK, SETMASK) Scope : (R) = ((R) And (Not (CLRMASK))) Or (SETMASK) : End Scope
#define MG_ROUND_UP(x, a) IIf((a) = 0, (x), ((((x) + (a)) - 1) / (a)) * (a))
#define MG_ROUND_DOWN(x, a) IIf((a) = 0, (x), ((x) / (a)) * (a))
'' TODO: #define MG_ARM_DISABLE_IRQ() asm volatile("cpsid i" : : : "memory")
'' TODO: #define MG_ARM_ENABLE_IRQ() asm volatile("cpsie i" : : : "memory")
#define MG_DSB()
Type mg_addr As mg_addr_
Declare Function mg_check_ip_acl(ByVal acl As mg_str, ByVal remote_ip As mg_addr Ptr) As Long
#macro LIST_ADD_HEAD(type_, head_, elem_)
	Scope
		(elem_)->next_ = *head_
		(*(head_)) = (elem_)
	End Scope
#endmacro
#macro LIST_ADD_TAIL(type_, head_, elem_)
	Scope
		(type_ * (*h)) = head_
		While (*h) <> NULL
			h = @(*h)->next_
		Wend
		(*h) = (elem_)
	End Scope
#endmacro
#macro LIST_DELETE(type_, head_, elem_)
	Scope
		Dim As type_ Ptr Ptr  h = head_
		While *h <> (elem_)
			h = @(*h)->next_
		Wend
		(*h) = (elem_)->next_
	End Scope
#endmacro

Declare Function mg_url_port(ByVal url As Const ZString Ptr) As UShort
Declare Function mg_url_is_ssl(ByVal url As Const ZString Ptr) As Long
Declare Function mg_url_host(ByVal url As Const ZString Ptr) As mg_str
Declare Function mg_url_user(ByVal url As Const ZString Ptr) As mg_str
Declare Function mg_url_pass(ByVal url As Const ZString Ptr) As mg_str
Declare Function mg_url_uri(ByVal url As Const ZString Ptr) As Const ZString Ptr

Type mg_iobuf
	buf As UByte Ptr
	size As UInteger
	len_ As UInteger
	align As UInteger
End Type

Declare Function mg_iobuf_init(ByVal As mg_iobuf Ptr, ByVal As UInteger, ByVal As UInteger) As Long
Declare Function mg_iobuf_resize(ByVal As mg_iobuf Ptr, ByVal As UInteger) As Long
Declare Sub mg_iobuf_free(ByVal As mg_iobuf Ptr)
Declare Function mg_iobuf_add(ByVal As mg_iobuf Ptr, ByVal As UInteger, ByVal As Const Any Ptr, ByVal As UInteger) As UInteger
Declare Function mg_iobuf_del(ByVal As mg_iobuf Ptr, ByVal ofs As UInteger, ByVal len_ As UInteger) As UInteger
Declare Function mg_base64_update(ByVal input_byte As UByte, ByVal buf As ZString Ptr, ByVal len_ As UInteger) As UInteger
Declare Function mg_base64_final(ByVal buf As ZString Ptr, ByVal len_ As UInteger) As UInteger
Declare Function mg_base64_encode(ByVal p As Const UByte Ptr, ByVal n As UInteger, ByVal buf As ZString Ptr, ByVal As UInteger) As UInteger
Declare Function mg_base64_decode(ByVal src As Const ZString Ptr, ByVal n As UInteger, ByVal dst As ZString Ptr, ByVal As UInteger) As UInteger

Type mg_md5_ctx
	buf(0 To 3) As ULong
	bits(0 To 1) As ULong
	in(0 To 63) As UByte
End Type

Declare Sub mg_md5_init(ByVal c As mg_md5_ctx Ptr)
Declare Sub mg_md5_update(ByVal c As mg_md5_ctx Ptr, ByVal data_ As Const UByte Ptr, ByVal len_ As UInteger)
Declare Sub mg_md5_final(ByVal c As mg_md5_ctx Ptr, ByVal As UByte Ptr)

Type mg_sha1_ctx
	state(0 To 4) As ULong
	count(0 To 1) As ULong
	buffer(0 To 63) As UByte
End Type

Declare Sub mg_sha1_init(ByVal As mg_sha1_ctx Ptr)
Declare Sub mg_sha1_update(ByVal As mg_sha1_ctx Ptr, ByVal data_ As Const UByte Ptr, ByVal len_ As UInteger)
Declare Sub mg_sha1_final(ByVal digest As UByte Ptr, ByVal As mg_sha1_ctx Ptr)

Type mg_sha256_ctx
	state(0 To 7) As ULong
	bits As ULongInt
	len_ As ULong
	buffer(0 To 63) As UByte
End Type

Declare Sub mg_sha256_init(ByVal As mg_sha256_ctx Ptr)
Declare Sub mg_sha256_update(ByVal As mg_sha256_ctx Ptr, ByVal data_ As Const UByte Ptr, ByVal len_ As UInteger)
Declare Sub mg_sha256_final(ByVal digest As UByte Ptr, ByVal As mg_sha256_ctx Ptr)
Declare Sub mg_sha256(ByVal dst As UByte Ptr, ByVal data_ As UByte Ptr, ByVal datasz As UInteger)
Declare Sub mg_hmac_sha256(ByVal dst As UByte Ptr, ByVal key As UByte Ptr, ByVal keysz As UInteger, ByVal data_ As UByte Ptr, ByVal datasz As UInteger)

Type mg_sha384_ctx
	state(0 To 7) As ULongInt
	buffer(0 To 127) As UByte
	bitlen(0 To 1) As ULongInt
	datalen As ULong
End Type

Declare Sub mg_sha384_init(ByVal ctx As mg_sha384_ctx Ptr)
Declare Sub mg_sha384_update(ByVal ctx As mg_sha384_ctx Ptr, ByVal data_ As Const UByte Ptr, ByVal len_ As UInteger)
Declare Sub mg_sha384_final(ByVal digest As UByte Ptr, ByVal ctx As mg_sha384_ctx Ptr)
Declare Sub mg_sha384(ByVal dst As UByte Ptr, ByVal data_ As UByte Ptr, ByVal datasz As UInteger)
#define TLS_X15519_H
Const X25519_BYTES = 32
Extern X25519_BASE_POINT(0 To 31) As Const UByte
Declare Function mg_tls_x25519(ByVal out_ As UByte Ptr, ByVal scalar As Const UByte Ptr, ByVal x1 As Const UByte Ptr, ByVal clamp As Long) As Long
#define TLS_AES128_H

Type aes_context
	mode As Long
	rounds As Long
	rk As ULong Ptr
	buf(0 To 67) As ULong
End Type

Const GCM_AUTH_FAILURE = &h55555555
Declare Function mg_gcm_initialize() As Long
Declare Function mg_aes_gcm_encrypt(ByVal output As UByte Ptr, ByVal input As Const UByte Ptr, ByVal input_length As UInteger, ByVal key As Const UByte Ptr, ByVal key_len As Const UInteger, ByVal iv As Const UByte Ptr, ByVal iv_len As Const UInteger, ByVal aead As UByte Ptr, ByVal aead_len As UInteger, ByVal tag As UByte Ptr, ByVal tag_len As Const UInteger) As Long
Declare Function mg_aes_gcm_decrypt(ByVal output As UByte Ptr, ByVal input As Const UByte Ptr, ByVal input_length As UInteger, ByVal key As Const UByte Ptr, ByVal key_len As Const UInteger, ByVal iv As Const UByte Ptr, ByVal iv_len As Const UInteger) As Long

Const MG_UECC_SUPPORTS_secp256r1 = 1
#define _UECC_H_
Const mg_uecc_arch_other = 0
Const mg_uecc_x86 = 1
Const mg_uecc_x86_64 = 2
Const mg_uecc_arm = 3
Const mg_uecc_arm_thumb = 4
Const mg_uecc_arm_thumb2 = 5
Const mg_uecc_arm64 = 6
Const mg_uecc_avr = 7
Const MG_UECC_OPTIMIZATION_LEVEL = 2
Const MG_UECC_SQUARE_FUNC = 0
Const MG_UECC_VLI_NATIVE_LITTLE_ENDIAN = 0
Const MG_UECC_SUPPORTS_secp160r1 = 0
Const MG_UECC_SUPPORTS_secp192r1 = 0
Const MG_UECC_SUPPORTS_secp224r1 = 0
Const MG_UECC_SUPPORTS_secp256k1 = 0
Const MG_UECC_SUPPORT_COMPRESSED_POINT = 1
Type MG_UECC_Curve As Const MG_UECC_Curve_t Ptr
Declare Function mg_uecc_secp256r1() As MG_UECC_Curve
Type MG_UECC_RNG_Function As Function(ByVal dest As UByte Ptr, ByVal size As ULong) As Long

Declare Sub mg_uecc_set_rng(ByVal rng_function As MG_UECC_RNG_Function)
Declare Function mg_uecc_get_rng() As MG_UECC_RNG_Function
Declare Function mg_uecc_curve_private_key_size(ByVal curve As MG_UECC_Curve) As Long
Declare Function mg_uecc_curve_public_key_size(ByVal curve As MG_UECC_Curve) As Long
Declare Function mg_uecc_make_key(ByVal public_key As UByte Ptr, ByVal private_key As UByte Ptr, ByVal curve As MG_UECC_Curve) As Long
Declare Function mg_uecc_shared_secret(ByVal public_key As Const UByte Ptr, ByVal private_key As Const UByte Ptr, ByVal secret As UByte Ptr, ByVal curve As MG_UECC_Curve) As Long
Declare Sub mg_uecc_compress(ByVal public_key As Const UByte Ptr, ByVal compressed As UByte Ptr, ByVal curve As MG_UECC_Curve)
Declare Sub mg_uecc_decompress(ByVal compressed As Const UByte Ptr, ByVal public_key As UByte Ptr, ByVal curve As MG_UECC_Curve)
Declare Function mg_uecc_valid_public_key(ByVal public_key As Const UByte Ptr, ByVal curve As MG_UECC_Curve) As Long
Declare Function mg_uecc_compute_public_key(ByVal private_key As Const UByte Ptr, ByVal public_key As UByte Ptr, ByVal curve As MG_UECC_Curve) As Long
Declare Function mg_uecc_sign(ByVal private_key As Const UByte Ptr, ByVal message_hash As Const UByte Ptr, ByVal hash_size As ULong, ByVal signature As UByte Ptr, ByVal curve As MG_UECC_Curve) As Long

Type MG_UECC_HashContext
	init_hash As Sub(ByVal context As Const MG_UECC_HashContext Ptr)
	update_hash As Sub(ByVal context As Const MG_UECC_HashContext Ptr, ByVal message As Const UByte Ptr, ByVal message_size As ULong)
	finish_hash As Sub(ByVal context As Const MG_UECC_HashContext Ptr, ByVal hash_result As UByte Ptr)
	block_size As ULong
	result_size As ULong
	tmp As UByte Ptr
End Type

Declare Function mg_uecc_sign_deterministic(ByVal private_key As Const UByte Ptr, ByVal message_hash As Const UByte Ptr, ByVal hash_size As ULong, ByVal hash_context As Const MG_UECC_HashContext Ptr, ByVal signature As UByte Ptr, ByVal curve As MG_UECC_Curve) As Long
Declare Function mg_uecc_verify(ByVal public_key As Const UByte Ptr, ByVal message_hash As Const UByte Ptr, ByVal hash_size As ULong, ByVal signature As Const UByte Ptr, ByVal curve As MG_UECC_Curve) As Long
#define _UECC_TYPES_H_

#if defined(__FB_DOS__) Or ((Not defined(__FB_64BIT__)) And (defined(__FB_DARWIN__) Or defined(__FB_WIN32__) Or defined(__FB_CYGWIN__) Or ((Not defined(__FB_ARM__)) And (defined(__FB_LINUX__) Or defined(__FB_FREEBSD__) Or defined(__FB_OPENBSD__) Or defined(__FB_NETBSD__)))))
	Const MG_UECC_PLATFORM = mg_uecc_x86
#elseif defined(__FB_64BIT__) And (defined(__FB_DARWIN__) Or defined(__FB_WIN32__) Or defined(__FB_CYGWIN__) Or ((Not defined(__FB_ARM__)) And (defined(__FB_LINUX__) Or defined(__FB_FREEBSD__) Or defined(__FB_OPENBSD__) Or defined(__FB_NETBSD__))))
	Const MG_UECC_PLATFORM = mg_uecc_x86_64
#elseif defined(__FB_64BIT__) And defined(__FB_ARM__) And (defined(__FB_LINUX__) Or defined(__FB_FREEBSD__) Or defined(__FB_OPENBSD__) Or defined(__FB_NETBSD__))
	Const MG_UECC_PLATFORM = mg_uecc_arm64
#endif

#if (Not defined(__FB_64BIT__)) And defined(__FB_ARM__) And (defined(__FB_LINUX__) Or defined(__FB_FREEBSD__) Or defined(__FB_OPENBSD__) Or defined(__FB_NETBSD__))
	Const MG_UECC_PLATFORM = mg_uecc_arm
	Const MG_UECC_ARM_USE_UMAAL = 1
#else
	Const MG_UECC_ARM_USE_UMAAL = 0
#endif

#if defined(__FB_64BIT__) And (defined(__FB_WIN32__) Or defined(__FB_UNIX__))
	Const MG_UECC_WORD_SIZE = 8
#else
	Const MG_UECC_WORD_SIZE = 4
#endif

Type wordcount_t As Byte
Type bitcount_t As Short
Type cmpresult_t As Byte

#if defined(__FB_64BIT__) And (defined(__FB_WIN32__) Or defined(__FB_UNIX__))
	Type mg_uecc_word_t As ULongInt
	Const HIGH_BIT_SET = &h8000000000000000u
	Const MG_UECC_WORD_BITS = 64
	Const MG_UECC_WORD_BITS_SHIFT = 6
	Const MG_UECC_WORD_BITS_MASK = &h03F
#else
	Type mg_uecc_word_t As ULong
	Type mg_uecc_dword_t As ULongInt
	Const HIGH_BIT_SET = &h80000000
	Const MG_UECC_WORD_BITS = 32
	Const MG_UECC_WORD_BITS_SHIFT = 5
	Const MG_UECC_WORD_BITS_MASK = &h01F
#endif

#define _UECC_VLI_H_
Const MG_UECC_ENABLE_VLI_API = 0
#define __PORTABLE_8439_H
#define PORTABLE_8439_DECL
Const RFC_8439_TAG_SIZE = 16
Const RFC_8439_KEY_SIZE = 32
Const RFC_8439_NONCE_SIZE = 12
Declare Function mg_chacha20_poly1305_encrypt(ByVal cipher_text As UByte Ptr, ByVal key As Const UByte Ptr, ByVal nonce As Const UByte Ptr, ByVal ad As Const UByte Ptr, ByVal ad_size As UInteger, ByVal plain_text As Const UByte Ptr, ByVal plain_text_size As UInteger) As UInteger
Declare Function mg_chacha20_poly1305_decrypt(ByVal plain_text As UByte Ptr, ByVal key As Const UByte Ptr, ByVal nonce As Const UByte Ptr, ByVal cipher_text As Const UByte Ptr, ByVal cipher_text_size As UInteger) As UInteger
#define TLS_RSA_H
Declare Function mg_rsa_mod_pow(ByVal _mod As Const UByte Ptr, ByVal modsz As UInteger, ByVal Exp As Const UByte Ptr, ByVal expsz As UInteger, ByVal MSG As Const UByte Ptr, ByVal msgsz As UInteger, ByVal out_ As UByte Ptr, ByVal outsz As UInteger) As Long
Type mg_connection As mg_connection_
Type mg_event_handler_t As Sub(ByVal As mg_connection Ptr, ByVal ev As Long, ByVal ev_data As Any Ptr)
Declare Sub mg_call(ByVal c As mg_connection Ptr, ByVal ev As Long, ByVal ev_data As Any Ptr)
Declare Sub mg_error(ByVal c As mg_connection Ptr, ByVal fmt As Const ZString Ptr, ...)

Enum
	MG_EV_ERROR
	MG_EV_OPEN
	MG_EV_POLL
	MG_EV_RESOLVE
	MG_EV_CONNECT
	MG_EV_ACCEPT
	MG_EV_TLS_HS
	MG_EV_READ
	MG_EV_WRITE
	MG_EV_CLOSE
	MG_EV_HTTP_HDRS
	MG_EV_HTTP_MSG
	MG_EV_WS_OPEN
	MG_EV_WS_MSG
	MG_EV_WS_CTL
	MG_EV_MQTT_CMD
	MG_EV_MQTT_MSG
	MG_EV_MQTT_OPEN
	MG_EV_SNTP_TIME
	MG_EV_WAKEUP
	MG_EV_USER
End Enum

Type mg_dns
	url As Const ZString Ptr
	c As mg_connection Ptr
End Type

Type mg_addr_
	ip(0 To 15) As UByte
	port As UShort
	scope_id As UByte
	is_ip6 As bool
End Type
Type mg_tcpip_if As Any Ptr
Type SOCKET As ULongInt
Type mg_mgr
	conns As mg_connection Ptr
	dns4 As mg_dns
	dns6 As mg_dns
	dnstimeout As Long
	use_dns6 As bool
	nextid As culong
	userdata As Any Ptr
	tls_ctx As Any Ptr
	mqtt_id As UShort
	active_dns_requests As Any Ptr
	timers As mg_timer Ptr
	epoll_fd As Long
	ifp As mg_tcpip_if Ptr
	extraconnsize As UInteger
	pipe As SOCKET
End Type

Type mg_connection_
	next_ As mg_connection Ptr
	mgr As mg_mgr Ptr
	loc As mg_addr
	As mg_addr rem_
	fd As Any Ptr
	id As culong
	recv As mg_iobuf
	send As mg_iobuf
	prof As mg_iobuf
	rtls As mg_iobuf
	fn As mg_event_handler_t
	fn_data As Any Ptr
	pfn As mg_event_handler_t
	pfn_data As Any Ptr
	data_ As ZString * 32
	tls As Any Ptr
	is_listening : 1 As ULong
	is_client : 1 As ULong
	is_accepted : 1 As ULong
	is_resolving : 1 As ULong
	is_arplooking : 1 As ULong
	is_connecting : 1 As ULong
	is_tls : 1 As ULong
	is_tls_hs : 1 As ULong
	is_udp : 1 As ULong
	is_websocket : 1 As ULong
	is_mqtt5 : 1 As ULong
	is_hexdumping : 1 As ULong
	is_draining : 1 As ULong
	is_closing : 1 As ULong
	is_full : 1 As ULong
	is_tls_throttled : 1 As ULong
	is_resp : 1 As ULong
	is_readable : 1 As ULong
	is_writable : 1 As ULong
End Type

Declare Sub mg_mgr_poll(ByVal As mg_mgr Ptr, ByVal ms As Long)
Declare Sub mg_mgr_init(ByVal As mg_mgr Ptr)
Declare Sub mg_mgr_free(ByVal As mg_mgr Ptr)
Declare Function mg_listen(ByVal As mg_mgr Ptr, ByVal url As Const ZString Ptr, ByVal fn As mg_event_handler_t, ByVal fn_data As Any Ptr) As mg_connection Ptr
Declare Function mg_connect(ByVal As mg_mgr Ptr, ByVal url As Const ZString Ptr, ByVal fn As mg_event_handler_t, ByVal fn_data As Any Ptr) As mg_connection Ptr
Declare Function mg_wrapfd(ByVal mgr As mg_mgr Ptr, ByVal fd As Long, ByVal fn As mg_event_handler_t, ByVal fn_data As Any Ptr) As mg_connection Ptr
Declare Sub mg_connect_resolved(ByVal As mg_connection Ptr)
Declare Function mg_send(ByVal As mg_connection Ptr, ByVal As Const Any Ptr, ByVal As UInteger) As bool
Declare Function mg_printf(ByVal As mg_connection Ptr, ByVal fmt As Const ZString Ptr, ...) As UInteger
Declare Function mg_vprintf(ByVal As mg_connection Ptr, ByVal fmt As Const ZString Ptr, ByVal ap As va_list Ptr) As UInteger
Declare Function mg_aton(ByVal str_ As mg_str, ByVal addr As mg_addr Ptr) As bool
Declare Function mg_alloc_conn(ByVal As mg_mgr Ptr) As mg_connection Ptr
Declare Sub mg_close_conn(ByVal c As mg_connection Ptr)
Declare Function mg_open_listener(ByVal c As mg_connection Ptr, ByVal url As Const ZString Ptr) As bool
Declare Function mg_wakeup(ByVal As mg_mgr Ptr, ByVal id As culong, ByVal buf As Const Any Ptr, ByVal len_ As UInteger) As bool
Declare Function mg_wakeup_init(ByVal As mg_mgr Ptr) As bool
Declare Function mg_timer_add(ByVal mgr As mg_mgr Ptr, ByVal milliseconds As ULongInt, ByVal flags As ULong, ByVal fn As Sub(ByVal As Any Ptr), ByVal arg As Any Ptr) As mg_timer Ptr

Type mg_http_header
	name_ As mg_str
	value As mg_str
End Type

Type mg_http_message
	method As mg_str
	uri As mg_str
	query As mg_str
	proto As mg_str
	headers(0 To 29) As mg_http_header
	body As mg_str
	head As mg_str
	message As mg_str
End Type

Type mg_http_serve_opts
	root_dir As Const ZString Ptr
	ssi_pattern As Const ZString Ptr
	extra_headers As Const ZString Ptr
	mime_types As Const ZString Ptr
	page404 As Const ZString Ptr
	fs As mg_fs Ptr
End Type

Type mg_http_part
	name_ As mg_str
	filename As mg_str
	body As mg_str
End Type

Declare Function mg_http_parse(ByVal s As Const ZString Ptr, ByVal len_ As UInteger, ByVal As mg_http_message Ptr) As Long
Declare Function mg_http_get_request_len(ByVal buf As Const UByte Ptr, ByVal buf_len As UInteger) As Long
Declare Sub mg_http_printf_chunk(ByVal cnn As mg_connection Ptr, ByVal fmt As Const ZString Ptr, ...)
Declare Sub mg_http_write_chunk(ByVal c As mg_connection Ptr, ByVal buf As Const ZString Ptr, ByVal len_ As UInteger)
Declare Sub mg_http_delete_chunk(ByVal c As mg_connection Ptr, ByVal hm As mg_http_message Ptr)
Declare Function mg_http_listen(ByVal As mg_mgr Ptr, ByVal url As Const ZString Ptr, ByVal fn As mg_event_handler_t, ByVal fn_data As Any Ptr) As mg_connection Ptr
Declare Function mg_http_connect(ByVal As mg_mgr Ptr, ByVal url As Const ZString Ptr, ByVal fn As mg_event_handler_t, ByVal fn_data As Any Ptr) As mg_connection Ptr
Declare Sub mg_http_serve_dir(ByVal As mg_connection Ptr, ByVal hm As mg_http_message Ptr, ByVal As Const mg_http_serve_opts Ptr)
Declare Sub mg_http_serve_file(ByVal As mg_connection Ptr, ByVal hm As mg_http_message Ptr, ByVal path As Const ZString Ptr, ByVal As Const mg_http_serve_opts Ptr)
Declare Sub mg_http_reply(ByVal As mg_connection Ptr, ByVal status_code As Long, ByVal headers As Const ZString Ptr, ByVal body_fmt As Const ZString Ptr, ...)
Declare Function mg_http_get_header(ByVal As mg_http_message Ptr, ByVal name_ As Const ZString Ptr) As mg_str Ptr
Declare Function mg_http_var(ByVal buf As mg_str, ByVal name_ As mg_str) As mg_str
Declare Function mg_http_get_var(ByVal As Const mg_str Ptr, ByVal name_ As Const ZString Ptr, ByVal As ZString Ptr, ByVal As UInteger) As Long
Declare Function mg_url_decode(ByVal s As Const ZString Ptr, ByVal n As UInteger, ByVal to As ZString Ptr, ByVal to_len As UInteger, ByVal form As Long) As Long
Declare Function mg_url_encode(ByVal s As Const ZString Ptr, ByVal n As UInteger, ByVal buf As ZString Ptr, ByVal len_ As UInteger) As UInteger
Declare Sub mg_http_creds(ByVal As mg_http_message Ptr, ByVal As ZString Ptr, ByVal As UInteger, ByVal As ZString Ptr, ByVal As UInteger)
Declare Function mg_http_upload(ByVal c As mg_connection Ptr, ByVal hm As mg_http_message Ptr, ByVal fs As mg_fs Ptr, ByVal dir As Const ZString Ptr, ByVal max_size As UInteger) As clong
Declare Sub mg_http_bauth(ByVal As mg_connection Ptr, ByVal user As Const ZString Ptr, ByVal pass As Const ZString Ptr)
Declare Function mg_http_get_header_var(ByVal s As mg_str, ByVal v As mg_str) As mg_str
Declare Function mg_http_next_multipart(ByVal As mg_str, ByVal As UInteger, ByVal As mg_http_part Ptr) As UInteger
Declare Function mg_http_status(ByVal hm As Const mg_http_message Ptr) As Long
Declare Sub mg_hello(ByVal url As Const ZString Ptr)
Declare Sub mg_http_serve_ssi(ByVal c As mg_connection Ptr, ByVal root As Const ZString Ptr, ByVal fullpath As Const ZString Ptr)

Const MG_TLS_NONE = 0
Const MG_TLS_MBED = 1
Const MG_TLS_OPENSSL = 2
Const MG_TLS_WOLFSSL = 5
Const MG_TLS_BUILTIN = 3
Const MG_TLS_CUSTOM = 4

Type mg_tls_opts
	ca As mg_str
	cert As mg_str
	key As mg_str
	name_ As mg_str
	skip_verification As Long
End Type

Declare Sub mg_tls_init(ByVal As mg_connection Ptr, ByVal opts As Const mg_tls_opts Ptr)
Declare Sub mg_tls_free(ByVal As mg_connection Ptr)
Declare Function mg_tls_send(ByVal As mg_connection Ptr, ByVal buf As Const Any Ptr, ByVal len_ As UInteger) As clong
Declare Function mg_tls_recv(ByVal As mg_connection Ptr, ByVal buf As Any Ptr, ByVal len_ As UInteger) As clong
Declare Function mg_tls_pending(ByVal As mg_connection Ptr) As UInteger
Declare Sub mg_tls_handshake(ByVal As mg_connection Ptr)
Declare Sub mg_tls_ctx_init(ByVal As mg_mgr Ptr)
Declare Sub mg_tls_ctx_free(ByVal As mg_mgr Ptr)

Enum
	MG_IO_ERR = -1
	MG_IO_WAIT = -2
	MG_IO_RESET = -3
End Enum

Declare Function mg_io_send(ByVal c As mg_connection Ptr, ByVal buf As Const Any Ptr, ByVal len_ As UInteger) As clong
Declare Function mg_io_recv(ByVal c As mg_connection Ptr, ByVal buf As Any Ptr, ByVal len_ As UInteger) As clong

Type mg_tls_ctx
	dummy As Long
End Type

Type mbedtls_x509_crt As Any Ptr
Type mbedtls_pk_context As Any Ptr
Type mbedtls_ssl_context As Any Ptr
Type mbedtls_ssl_config As Any Ptr
Type mg_tls
	ca As mbedtls_x509_crt
	cert As mbedtls_x509_crt
	pk As mbedtls_pk_context
	ssl As mbedtls_ssl_context
	conf As mbedtls_ssl_config
	throttled_buf As UByte Ptr
	throttled_len As UInteger
End Type

Const WEBSOCKET_OP_CONTINUE = 0
Const WEBSOCKET_OP_TEXT = 1
Const WEBSOCKET_OP_BINARY = 2
Const WEBSOCKET_OP_CLOSE = 8
Const WEBSOCKET_OP_PING = 9
Const WEBSOCKET_OP_PONG = 10

Type mg_ws_message
	data_ As mg_str
	flags As UByte
End Type

Declare Function mg_ws_connect(ByVal As mg_mgr Ptr, ByVal url As Const ZString Ptr, ByVal fn As mg_event_handler_t, ByVal fn_data As Any Ptr, ByVal fmt As Const ZString Ptr, ...) As mg_connection Ptr
Declare Sub mg_ws_upgrade(ByVal As mg_connection Ptr, ByVal As mg_http_message Ptr, ByVal fmt As Const ZString Ptr, ...)
Declare Function mg_ws_send(ByVal As mg_connection Ptr, ByVal buf As Const Any Ptr, ByVal len_ As UInteger, ByVal op As Long) As UInteger
Declare Function mg_ws_wrap(ByVal As mg_connection Ptr, ByVal len_ As UInteger, ByVal op As Long) As UInteger
Declare Function mg_ws_printf(ByVal c As mg_connection Ptr, ByVal op As Long, ByVal fmt As Const ZString Ptr, ...) As UInteger
Declare Function mg_ws_vprintf(ByVal c As mg_connection Ptr, ByVal op As Long, ByVal fmt As Const ZString Ptr, ByVal As va_list Ptr) As UInteger
Declare Function mg_sntp_connect(ByVal mgr As mg_mgr Ptr, ByVal url As Const ZString Ptr, ByVal fn As mg_event_handler_t, ByVal fn_data As Any Ptr) As mg_connection Ptr
Declare Sub mg_sntp_request(ByVal c As mg_connection Ptr)
Declare Function mg_sntp_parse(ByVal buf As Const UByte Ptr, ByVal len_ As UInteger) As LongInt
Declare Function mg_now() As ULongInt

Const MQTT_CMD_CONNECT = 1
Const MQTT_CMD_CONNACK = 2
Const MQTT_CMD_PUBLISH = 3
Const MQTT_CMD_PUBACK = 4
Const MQTT_CMD_PUBREC = 5
Const MQTT_CMD_PUBREL = 6
Const MQTT_CMD_PUBCOMP = 7
Const MQTT_CMD_SUBSCRIBE = 8
Const MQTT_CMD_SUBACK = 9
Const MQTT_CMD_UNSUBSCRIBE = 10
Const MQTT_CMD_UNSUBACK = 11
Const MQTT_CMD_PINGREQ = 12
Const MQTT_CMD_PINGRESP = 13
Const MQTT_CMD_DISCONNECT = 14
Const MQTT_CMD_AUTH = 15
Const MQTT_PROP_PAYLOAD_FORMAT_INDICATOR = &h01
Const MQTT_PROP_MESSAGE_EXPIRY_INTERVAL = &h02
Const MQTT_PROP_CONTENT_TYPE = &h03
Const MQTT_PROP_RESPONSE_TOPIC = &h08
Const MQTT_PROP_CORRELATION_DATA = &h09
Const MQTT_PROP_SUBSCRIPTION_IDENTIFIER = &h0B
Const MQTT_PROP_SESSION_EXPIRY_INTERVAL = &h11
Const MQTT_PROP_ASSIGNED_CLIENT_IDENTIFIER = &h12
Const MQTT_PROP_SERVER_KEEP_ALIVE = &h13
Const MQTT_PROP_AUTHENTICATION_METHOD = &h15
Const MQTT_PROP_AUTHENTICATION_DATA = &h16
Const MQTT_PROP_REQUEST_PROBLEM_INFORMATION = &h17
Const MQTT_PROP_WILL_DELAY_INTERVAL = &h18
Const MQTT_PROP_REQUEST_RESPONSE_INFORMATION = &h19
Const MQTT_PROP_RESPONSE_INFORMATION = &h1A
Const MQTT_PROP_SERVER_REFERENCE = &h1C
Const MQTT_PROP_REASON_STRING = &h1F
Const MQTT_PROP_RECEIVE_MAXIMUM = &h21
Const MQTT_PROP_TOPIC_ALIAS_MAXIMUM = &h22
Const MQTT_PROP_TOPIC_ALIAS = &h23
Const MQTT_PROP_MAXIMUM_QOS = &h24
Const MQTT_PROP_RETAIN_AVAILABLE = &h25
Const MQTT_PROP_USER_PROPERTY = &h26
Const MQTT_PROP_MAXIMUM_PACKET_SIZE = &h27
Const MQTT_PROP_WILDCARD_SUBSCRIPTION_AVAILABLE = &h28
Const MQTT_PROP_SUBSCRIPTION_IDENTIFIER_AVAILABLE = &h29
Const MQTT_PROP_SHARED_SUBSCRIPTION_AVAILABLE = &h2A

Enum
	MQTT_PROP_TYPE_BYTE
	MQTT_PROP_TYPE_STRING
	MQTT_PROP_TYPE_STRING_PAIR
	MQTT_PROP_TYPE_BINARY_DATA
	MQTT_PROP_TYPE_VARIABLE_INT
	MQTT_PROP_TYPE_INT
	MQTT_PROP_TYPE_SHORT
End Enum

Enum
	MQTT_OK
	MQTT_INCOMPLETE
	MQTT_MALFORMED
End Enum

Type mg_mqtt_prop
	id As UByte
	iv As ULong
	key As mg_str
	val_ As mg_str
End Type

Type mg_mqtt_opts
	user As mg_str
	pass As mg_str
	client_id As mg_str
	topic As mg_str
	message As mg_str
	qos As UByte
	version As UByte
	keepalive As UShort
	retransmit_id As UShort
	retain As bool
	clean As bool
	props As mg_mqtt_prop Ptr
	num_props As UInteger
	will_props As mg_mqtt_prop Ptr
	num_will_props As UInteger
End Type

Type mg_mqtt_message
	topic As mg_str
	data_ As mg_str
	dgram As mg_str
	id As UShort
	cmd As UByte
	qos As UByte
	ack As UByte
	props_start As UInteger
	props_size As UInteger
End Type

Declare Function mg_mqtt_connect(ByVal As mg_mgr Ptr, ByVal url As Const ZString Ptr, ByVal opts As Const mg_mqtt_opts Ptr, ByVal fn As mg_event_handler_t, ByVal fn_data As Any Ptr) As mg_connection Ptr
Declare Function mg_mqtt_listen(ByVal mgr As mg_mgr Ptr, ByVal url As Const ZString Ptr, ByVal fn As mg_event_handler_t, ByVal fn_data As Any Ptr) As mg_connection Ptr
Declare Sub mg_mqtt_login(ByVal c As mg_connection Ptr, ByVal opts As Const mg_mqtt_opts Ptr)
Declare Function mg_mqtt_pub(ByVal c As mg_connection Ptr, ByVal opts As Const mg_mqtt_opts Ptr) As UShort
Declare Sub mg_mqtt_sub(ByVal As mg_connection Ptr, ByVal opts As Const mg_mqtt_opts Ptr)
Declare Function mg_mqtt_parse(ByVal As Const UByte Ptr, ByVal As UInteger, ByVal As UByte, ByVal As mg_mqtt_message Ptr) As Long
Declare Sub mg_mqtt_send_header(ByVal As mg_connection Ptr, ByVal cmd As UByte, ByVal flags As UByte, ByVal len_ As ULong)
Declare Sub mg_mqtt_ping(ByVal As mg_connection Ptr)
Declare Sub mg_mqtt_pong(ByVal As mg_connection Ptr)
Declare Sub mg_mqtt_disconnect(ByVal As mg_connection Ptr, ByVal As Const mg_mqtt_opts Ptr)
Declare Function mg_mqtt_next_prop(ByVal As mg_mqtt_message Ptr, ByVal As mg_mqtt_prop Ptr, ByVal ofs As UInteger) As UInteger

Type mg_dns_message
	txnid As UShort
	resolved As bool
	addr As mg_addr
	name_ As ZString * 256
End Type

Type mg_dns_header
	txnid As UShort
	flags As UShort
	num_questions As UShort
	num_answers As UShort
	num_authority_prs As UShort
	num_other_prs As UShort
End Type

Type mg_dns_rr
	nlen As UShort
	atype As UShort
	aclass As UShort
	alen As UShort
End Type

Declare Sub mg_resolve(ByVal As mg_connection Ptr, ByVal url As Const ZString Ptr)
Declare Sub mg_resolve_cancel(ByVal As mg_connection Ptr)
Declare Function mg_dns_parse(ByVal buf As Const UByte Ptr, ByVal len_ As UInteger, ByVal As mg_dns_message Ptr) As bool
Declare Function mg_dns_parse_rr(ByVal buf As Const UByte Ptr, ByVal len_ As UInteger, ByVal ofs As UInteger, ByVal is_question As bool, ByVal As mg_dns_rr Ptr) As UInteger
Declare Function mg_mdns_listen(ByVal mgr As mg_mgr Ptr, ByVal name_ As ZString Ptr) As mg_connection Ptr
Const MG_JSON_MAX_DEPTH = 30

Enum
	MG_JSON_TOO_DEEP = -1
	MG_JSON_INVALID = -2
	MG_JSON_NOT_FOUND = -3
End Enum

Declare Function mg_json_get(ByVal json As mg_str, ByVal path As Const ZString Ptr, ByVal toklen As Long Ptr) As Long
Declare Function mg_json_get_tok(ByVal json As mg_str, ByVal path As Const ZString Ptr) As mg_str
Declare Function mg_json_get_num(ByVal json As mg_str, ByVal path As Const ZString Ptr, ByVal v As Double Ptr) As bool
Declare Function mg_json_get_bool(ByVal json As mg_str, ByVal path As Const ZString Ptr, ByVal v As bool Ptr) As bool
Declare Function mg_json_get_long(ByVal json As mg_str, ByVal path As Const ZString Ptr, ByVal dflt As clong) As clong
Declare Function mg_json_get_str(ByVal json As mg_str, ByVal path As Const ZString Ptr) As ZString Ptr
Declare Function mg_json_get_hex(ByVal json As mg_str, ByVal path As Const ZString Ptr, ByVal len_ As Long Ptr) As ZString Ptr
Declare Function mg_json_get_b64(ByVal json As mg_str, ByVal path As Const ZString Ptr, ByVal len_ As Long Ptr) As ZString Ptr
Declare Function mg_json_unescape(ByVal str_ As mg_str, ByVal buf As ZString Ptr, ByVal len_ As UInteger) As bool
Declare Function mg_json_next(ByVal obj As mg_str, ByVal ofs As UInteger, ByVal key As mg_str Ptr, ByVal val_ As mg_str Ptr) As UInteger
Type mg_rpc As mg_rpc_

Type mg_rpc_req
	head As mg_rpc Ptr Ptr
	rpc As mg_rpc Ptr
	pfn As mg_pfn_t
	pfn_data As Any Ptr
	req_data As Any Ptr
	frame As mg_str
End Type

Type mg_rpc_
	next_ As mg_rpc Ptr
	method As mg_str
	fn As Sub(ByVal As mg_rpc_req Ptr)
	fn_data As Any Ptr
End Type

Declare Sub mg_rpc_add(ByVal head As mg_rpc Ptr Ptr, ByVal method_pattern As mg_str, ByVal handler As Sub(ByVal As mg_rpc_req Ptr), ByVal handler_data As Any Ptr)
Declare Sub mg_rpc_del(ByVal head As mg_rpc Ptr Ptr, ByVal handler As Sub(ByVal As mg_rpc_req Ptr))
Declare Sub mg_rpc_process(ByVal As mg_rpc_req Ptr)
Declare Sub mg_rpc_ok(ByVal As mg_rpc_req Ptr, ByVal fmt As Const ZString Ptr, ...)
Declare Sub mg_rpc_vok(ByVal As mg_rpc_req Ptr, ByVal fmt As Const ZString Ptr, ByVal ap As va_list Ptr)
Declare Sub mg_rpc_err(ByVal As mg_rpc_req Ptr, ByVal code As Long, ByVal fmt As Const ZString Ptr, ...)
Declare Sub mg_rpc_verr(ByVal As mg_rpc_req Ptr, ByVal code As Long, ByVal fmt As Const ZString Ptr, ByVal As va_list Ptr)
Declare Sub mg_rpc_list(ByVal r As mg_rpc_req Ptr)

Const MG_OTA_NONE = 0
Const MG_OTA_STM32H5 = 1
Const MG_OTA_STM32H7 = 2
Const MG_OTA_STM32H7_DUAL_CORE = 3
Const MG_OTA_STM32F = 4
Const MG_OTA_CH32V307 = 100
Const MG_OTA_U2A = 200
Const MG_OTA_RT1020 = 300
Const MG_OTA_RT1050 = 301
Const MG_OTA_RT1060 = 302
Const MG_OTA_RT1064 = 303
Const MG_OTA_RT1170 = 304
Const MG_OTA_MCXN = 310
Const MG_OTA_FRDM = 320
Const MG_OTA_FLASH = 900
Const MG_OTA_ESP32 = 910
Const MG_OTA_PICOSDK = 920
Const MG_OTA_CUSTOM = 1000
Const MG_OTA = MG_OTA_NONE

Declare Function mg_ota_begin(ByVal new_firmware_size As UInteger) As bool
Declare Function mg_ota_write(ByVal buf As Const Any Ptr, ByVal len_ As UInteger) As bool
Declare Function mg_ota_end() As bool

Type mg_wifi_scan_bss_data
	SSID As mg_str
	BSSID As ZString Ptr
	RSSI As Short
	security As UByte
	channel As UByte
	band : 2 As ULong
	has_n : 1 As ULong
End Type

Const MG_WIFI_SECURITY_OPEN = 0
#define MG_WIFI_SECURITY_WEP MG_BIT(0)
#define MG_WIFI_SECURITY_WPA MG_BIT(1)
#define MG_WIFI_SECURITY_WPA2 MG_BIT(2)
#define MG_WIFI_SECURITY_WPA3 MG_BIT(3)
Const MG_WIFI_BAND_2G = 0
Const MG_WIFI_BAND_5G = 1

Declare Function mg_wifi_scan() As bool
Declare Function mg_wifi_connect(ByVal ssid As ZString Ptr, ByVal pass As ZString Ptr) As bool
Declare Function mg_wifi_disconnect() As bool
Declare Function mg_wifi_ap_start(ByVal ssid As ZString Ptr, ByVal pass As ZString Ptr, ByVal channel As ULong) As bool
Declare Function mg_wifi_ap_stop() As bool

#define MG_PROF_INIT(c)
#define MG_PROF_FREE(c)
#define MG_PROF_ADD(c, name_)
#define MG_PROF_DUMP(c)

Type mg_phy
	read_reg As Function(ByVal addr As UByte, ByVal reg As UByte) As UShort
	write_reg As Sub(ByVal addr As UByte, ByVal reg As UByte, ByVal value As UShort)
End Type

Enum
	MG_PHY_LEDS_ACTIVE_HIGH = 1 Shl 0
	MG_PHY_CLOCKS_MAC = 1 Shl 1
End Enum

Enum
	MG_PHY_SPEED_10M
	MG_PHY_SPEED_100M
	MG_PHY_SPEED_1000M
End Enum

Declare Sub mg_phy_init(ByVal As mg_phy Ptr, ByVal addr As UByte, ByVal config As UByte)
Declare Function mg_phy_up(ByVal As mg_phy Ptr, ByVal addr As UByte, ByVal full_duplex As bool Ptr, ByVal speed As UByte Ptr) As bool

Type mg_tcpip_driver_ppp_data
	uart As Any Ptr
	reset As Sub(ByVal As Any Ptr)
	tx As Sub(ByVal As Any Ptr, ByVal As UByte)
	rx As Function(ByVal As Any Ptr) As Long
	script As Const ZString Ptr Ptr
	script_index As Long
	deadline As ULongInt
End Type

End Extern
#endif
