'' FreeBASIC binding for libdumb-0.9.3
''
'' based on the C header files:
''   /*  _______         ____    __         ___    ___
''    * \    _  \       \    /  \  /       \   \  /   /       '   '  '
''    *  |  | \  \       |  |    ||         |   \/   |         .      .
''    *  |  |  |  |      |  |    ||         ||\  /|  |
''    *  |  |  |  |      |  |    ||         || \/ |  |         '  '  '
''    *  |  |  |  |      |  |    ||         ||    |  |         .      .
''    *  |  |_/  /        \  \__//          ||    |  |
''    * /_______/ynamic    \____/niversal  /__\  /____\usic   /|  .  . ibliotheque
''    *                                                      /  \
''    *                                                     / .  \
''    * dumb.h - The user header file for DUMB.            / / \  \
''    *                                                   | <  /   \_
''    * Include this file in any of your files in         |  \/ /\   /
''    * which you wish to use the DUMB functions           \_  /  > /
''    * and variables.                                       | \ / /
''    *                                                      |  ' /
''    * Allegro users, you will probably want aldumb.h.       \__/
''    */
''
''
'' translated to FreeBASIC by:
''   fbfrog for JayRM's FreeBASIC Load Out

#pragma once
#ifndef __DUMB_BI__
#define __DUMB_BI__
#ifndef NO_MOD
#inclib "dumb"

#include once "crt/long.bi"
#include once "crt/stdlib.bi"
#include once "crt/stdio.bi"
#include once "fbstypes.bi"
extern "C"

const DUMB_MAJOR_VERSION = 0
const DUMB_MINOR_VERSION = 9
const DUMB_REVISION_VERSION = 3
const DUMB_VERSION = ((DUMB_MAJOR_VERSION * 10000) + (DUMB_MINOR_VERSION * 100)) + DUMB_REVISION_VERSION
#define DUMB_VERSION_STR "0.9.3"
#define DUMB_NAME "DUMB v" DUMB_VERSION_STR
const DUMB_YEAR = 2005
const DUMB_MONTH = 8
const DUMB_DAY = 7
#define DUMB_YEAR_STR2 "05"
#define DUMB_YEAR_STR4 "2005"
#define DUMB_MONTH_STR1 "8"
#define DUMB_DAY_STR1 "7"
#define DUMB_MONTH_STR2 "0" DUMB_MONTH_STR1
#define DUMB_DAY_STR2 "0" DUMB_DAY_STR1
const DUMB_DATE = ((DUMB_YEAR * 10000) + (DUMB_MONTH * 100)) + DUMB_DAY
#define DUMB_DATE_STR DUMB_DAY_STR1 "." DUMB_MONTH_STR1 "." DUMB_YEAR_STR4
#undef MID_Dumb
#define MID_Dumb(x, y, z) MAX((x), MIN((y), (z)))
#undef ABS_Dumb
#define ABS_Dumb(x) iif((x) >= 0, (x), -(x))
#define TRACE iif(1, cast(any, 0), cast(any, printf))
#define DUMB_ID(a, b, c, d) culng(culng(culng(culng(culng(a) shl 24) or culng(culng(b) shl 16)) or culng(culng(c) shl 8)) or culng(d))
type LONG_LONG as longint
#define DUMB_DECLARE_DEPRECATED
type sample_t as long
declare function dumb_atexit(byval proc as sub()) as long
declare sub dumb_exit()

type DUMBFILE_SYSTEM
	open as function(byval filename as const zstring ptr) as any ptr
	skip as function(byval f as any ptr, byval n as clong) as long
	getc as function(byval f as any ptr) as long
	getnc as function(byval ptr as zstring ptr, byval n as clong, byval f as any ptr) as clong
	close as sub(byval f as any ptr)
end type

declare sub register_dumbfile_system(byval dfs as DUMBFILE_SYSTEM ptr)
type DUMBFILE as DUMBFILE_
declare function dumbfile_open(byval filename as const zstring ptr) as DUMBFILE ptr
declare function dumbfile_open_ex(byval file as any ptr, byval dfs as DUMBFILE_SYSTEM ptr) as DUMBFILE ptr
declare function dumbfile_pos(byval f as DUMBFILE ptr) as clong
declare function dumbfile_skip(byval f as DUMBFILE ptr, byval n as clong) as long
declare function dumbfile_getc(byval f as DUMBFILE ptr) as long
declare function dumbfile_igetw(byval f as DUMBFILE ptr) as long
declare function dumbfile_mgetw(byval f as DUMBFILE ptr) as long
declare function dumbfile_igetl(byval f as DUMBFILE ptr) as clong
declare function dumbfile_mgetl(byval f as DUMBFILE ptr) as clong
declare function dumbfile_cgetul(byval f as DUMBFILE ptr) as culong
declare function dumbfile_cgetsl(byval f as DUMBFILE ptr) as clong
declare function dumbfile_getnc(byval ptr as zstring ptr, byval n as clong, byval f as DUMBFILE ptr) as clong
declare function dumbfile_error(byval f as DUMBFILE ptr) as long
declare function dumbfile_close(byval f as DUMBFILE ptr) as long
declare sub dumb_register_stdfiles()
declare function dumbfile_open_stdfile(byval p as FILE ptr) as DUMBFILE ptr
declare function dumbfile_open_memory(byval data as const zstring ptr, byval size as clong) as DUMBFILE ptr
#define DUH_SIGNATURE DUMB_ID(asc("D"), asc("U"), asc("H"), asc("!"))
type DUH as DUH_
declare sub unload_duh(byval duh as DUH ptr)
declare function load_duh(byval filename as const zstring ptr) as DUH ptr
declare function read_duh(byval f as DUMBFILE ptr) as DUH ptr
declare function duh_get_length(byval duh as DUH ptr) as clong
declare function duh_get_tag(byval duh as DUH ptr, byval key as const zstring ptr) as const zstring ptr
type DUH_SIGRENDERER as DUH_SIGRENDERER_
declare function duh_start_sigrenderer(byval duh as DUH ptr, byval sig as long, byval n_channels as long, byval pos as clong) as DUH_SIGRENDERER ptr
type DUH_SIGRENDERER_CALLBACK as sub(byval data as any ptr, byval samples as sample_t ptr ptr, byval n_channels as long, byval length as clong)
declare sub duh_sigrenderer_set_callback(byval sigrenderer as DUH_SIGRENDERER ptr, byval callback as DUH_SIGRENDERER_CALLBACK, byval data as any ptr)
type DUH_SIGRENDERER_ANALYSER_CALLBACK as sub(byval data as any ptr, byval samples as const sample_t const ptr ptr, byval n_channels as long, byval length as clong)
declare sub duh_sigrenderer_set_analyser_callback(byval sigrenderer as DUH_SIGRENDERER ptr, byval callback as DUH_SIGRENDERER_ANALYSER_CALLBACK, byval data as any ptr)
type DUH_SIGRENDERER_SAMPLE_ANALYSER_CALLBACK as sub(byval data as any ptr, byval samples as const sample_t const ptr ptr, byval n_channels as long, byval length as clong)
declare sub duh_sigrenderer_set_sample_analyser_callback(byval sigrenderer as DUH_SIGRENDERER ptr, byval callback as DUH_SIGRENDERER_SAMPLE_ANALYSER_CALLBACK, byval data as any ptr)
declare function duh_sigrenderer_get_n_channels(byval sigrenderer as DUH_SIGRENDERER ptr) as long
declare function duh_sigrenderer_get_position(byval sigrenderer as DUH_SIGRENDERER ptr) as clong
declare sub duh_sigrenderer_set_sigparam(byval sigrenderer as DUH_SIGRENDERER ptr, byval id as ubyte, byval value as clong)
declare function duh_sigrenderer_get_samples(byval sigrenderer as DUH_SIGRENDERER ptr, byval volume as single, byval delta as single, byval size as clong, byval samples as sample_t ptr ptr) as clong
declare function duh_sigrenderer_generate_samples(byval sigrenderer as DUH_SIGRENDERER ptr, byval volume as single, byval delta as single, byval size as clong, byval samples as sample_t ptr ptr) as clong
declare sub duh_sigrenderer_get_current_sample(byval sigrenderer as DUH_SIGRENDERER ptr, byval volume as single, byval samples as sample_t ptr)
declare sub duh_end_sigrenderer(byval sigrenderer as DUH_SIGRENDERER ptr)
declare function duh_render(byval sigrenderer as DUH_SIGRENDERER ptr, byval bits as long, byval unsign as long, byval volume as single, byval delta as single, byval size as clong, byval sptr as any ptr) as clong
declare function duh_render_signal(byval sigrenderer as DUH_SIGRENDERER ptr, byval volume as single, byval delta as single, byval size as clong, byval samples as sample_t ptr ptr) as clong
type DUH_RENDERER as DUH_SIGRENDERER
declare function duh_start_renderer(byval duh as DUH ptr, byval n_channels as long, byval pos as clong) as DUH_SIGRENDERER ptr
declare function duh_renderer_get_n_channels(byval dr as DUH_SIGRENDERER ptr) as long
declare function duh_renderer_get_position(byval dr as DUH_SIGRENDERER ptr) as clong
declare sub duh_end_renderer(byval dr as DUH_SIGRENDERER ptr)
declare function duh_renderer_encapsulate_sigrenderer(byval sigrenderer as DUH_SIGRENDERER ptr) as DUH_SIGRENDERER ptr
declare function duh_renderer_get_sigrenderer(byval dr as DUH_SIGRENDERER ptr) as DUH_SIGRENDERER ptr
declare function duh_renderer_decompose_to_sigrenderer(byval dr as DUH_SIGRENDERER ptr) as DUH_SIGRENDERER ptr
extern dumb_it_max_to_mix as long
type DUMB_IT_SIGDATA as DUMB_IT_SIGDATA_
declare function duh_get_it_sigdata(byval duh as DUH ptr) as DUMB_IT_SIGDATA ptr
type DUMB_IT_SIGRENDERER as DUMB_IT_SIGRENDERER_
declare function duh_encapsulate_it_sigrenderer(byval it_sigrenderer as DUMB_IT_SIGRENDERER ptr, byval n_channels as long, byval pos as clong) as DUH_SIGRENDERER ptr
declare function duh_get_it_sigrenderer(byval sigrenderer as DUH_SIGRENDERER ptr) as DUMB_IT_SIGRENDERER ptr
declare function dumb_it_start_at_order(byval duh as DUH ptr, byval n_channels as long, byval startorder as long) as DUH_SIGRENDERER ptr
declare sub dumb_it_set_loop_callback(byval sigrenderer as DUMB_IT_SIGRENDERER ptr, byval callback as function(byval data as any ptr) as long, byval data as any ptr)
declare sub dumb_it_set_xm_speed_zero_callback(byval sigrenderer as DUMB_IT_SIGRENDERER ptr, byval callback as function(byval data as any ptr) as long, byval data as any ptr)
declare sub dumb_it_set_midi_callback(byval sigrenderer as DUMB_IT_SIGRENDERER ptr, byval callback as function(byval data as any ptr, byval channel as long, byval midi_byte as ubyte) as long, byval data as any ptr)
declare function dumb_it_callback_terminate(byval data as any ptr) as long
declare function dumb_it_callback_midi_block(byval data as any ptr, byval channel as long, byval midi_byte as ubyte) as long
declare function dumb_load_it(byval filename as const zstring ptr) as DUH ptr
declare function dumb_load_xm(byval filename as const zstring ptr) as DUH ptr
declare function dumb_load_s3m(byval filename as const zstring ptr) as DUH ptr
declare function dumb_load_mod(byval filename as const zstring ptr) as DUH ptr
declare function dumb_read_it(byval f as DUMBFILE ptr) as DUH ptr
declare function dumb_read_xm(byval f as DUMBFILE ptr) as DUH ptr
declare function dumb_read_s3m(byval f as DUMBFILE ptr) as DUH ptr
declare function dumb_read_mod(byval f as DUMBFILE ptr) as DUH ptr
declare function dumb_load_it_quick(byval filename as const zstring ptr) as DUH ptr
declare function dumb_load_xm_quick(byval filename as const zstring ptr) as DUH ptr
declare function dumb_load_s3m_quick(byval filename as const zstring ptr) as DUH ptr
declare function dumb_load_mod_quick(byval filename as const zstring ptr) as DUH ptr
declare function dumb_read_it_quick(byval f as DUMBFILE ptr) as DUH ptr
declare function dumb_read_xm_quick(byval f as DUMBFILE ptr) as DUH ptr
declare function dumb_read_s3m_quick(byval f as DUMBFILE ptr) as DUH ptr
declare function dumb_read_mod_quick(byval f as DUMBFILE ptr) as DUH ptr
declare function dumb_it_build_checkpoints(byval sigdata as DUMB_IT_SIGDATA ptr) as clong
declare sub dumb_it_do_initial_runthrough(byval duh as DUH ptr)
declare function dumb_it_sd_get_song_message(byval sd as DUMB_IT_SIGDATA ptr) as const ubyte ptr
declare function dumb_it_sd_get_n_orders(byval sd as DUMB_IT_SIGDATA ptr) as long
declare function dumb_it_sd_get_n_samples(byval sd as DUMB_IT_SIGDATA ptr) as long
declare function dumb_it_sd_get_n_instruments(byval sd as DUMB_IT_SIGDATA ptr) as long
declare function dumb_it_sd_get_sample_name(byval sd as DUMB_IT_SIGDATA ptr, byval i as long) as const ubyte ptr
declare function dumb_it_sd_get_sample_filename(byval sd as DUMB_IT_SIGDATA ptr, byval i as long) as const ubyte ptr
declare function dumb_it_sd_get_instrument_name(byval sd as DUMB_IT_SIGDATA ptr, byval i as long) as const ubyte ptr
declare function dumb_it_sd_get_instrument_filename(byval sd as DUMB_IT_SIGDATA ptr, byval i as long) as const ubyte ptr
declare function dumb_it_sd_get_initial_global_volume(byval sd as DUMB_IT_SIGDATA ptr) as long
declare sub dumb_it_sd_set_initial_global_volume(byval sd as DUMB_IT_SIGDATA ptr, byval gv as long)
declare function dumb_it_sd_get_mixing_volume(byval sd as DUMB_IT_SIGDATA ptr) as long
declare sub dumb_it_sd_set_mixing_volume(byval sd as DUMB_IT_SIGDATA ptr, byval mv as long)
declare function dumb_it_sd_get_initial_speed(byval sd as DUMB_IT_SIGDATA ptr) as long
declare sub dumb_it_sd_set_initial_speed(byval sd as DUMB_IT_SIGDATA ptr, byval speed as long)
declare function dumb_it_sd_get_initial_tempo(byval sd as DUMB_IT_SIGDATA ptr) as long
declare sub dumb_it_sd_set_initial_tempo(byval sd as DUMB_IT_SIGDATA ptr, byval tempo as long)
declare function dumb_it_sd_get_initial_channel_volume(byval sd as DUMB_IT_SIGDATA ptr, byval channel as long) as long
declare sub dumb_it_sd_set_initial_channel_volume(byval sd as DUMB_IT_SIGDATA ptr, byval channel as long, byval volume as long)
declare function dumb_it_sr_get_current_order(byval sr as DUMB_IT_SIGRENDERER ptr) as long
declare function dumb_it_sr_get_current_row(byval sr as DUMB_IT_SIGRENDERER ptr) as long
declare function dumb_it_sr_get_global_volume(byval sr as DUMB_IT_SIGRENDERER ptr) as long
declare sub dumb_it_sr_set_global_volume(byval sr as DUMB_IT_SIGRENDERER ptr, byval gv as long)
declare function dumb_it_sr_get_tempo(byval sr as DUMB_IT_SIGRENDERER ptr) as long
declare sub dumb_it_sr_set_tempo(byval sr as DUMB_IT_SIGRENDERER ptr, byval tempo as long)
declare function dumb_it_sr_get_speed(byval sr as DUMB_IT_SIGRENDERER ptr) as long
declare sub dumb_it_sr_set_speed(byval sr as DUMB_IT_SIGRENDERER ptr, byval speed as long)

const DUMB_IT_N_CHANNELS = 64
const DUMB_IT_N_NNA_CHANNELS = 192
const DUMB_IT_TOTAL_CHANNELS = DUMB_IT_N_CHANNELS + DUMB_IT_N_NNA_CHANNELS

declare function dumb_it_sr_get_channel_volume(byval sr as DUMB_IT_SIGRENDERER ptr, byval channel as long) as long
declare sub dumb_it_sr_set_channel_volume(byval sr as DUMB_IT_SIGRENDERER ptr, byval channel as long, byval volume as long)
declare function dumb_it_sr_get_channel_muted(byval sr as DUMB_IT_SIGRENDERER ptr, byval channel as long) as long
declare sub dumb_it_sr_set_channel_muted(byval sr as DUMB_IT_SIGRENDERER ptr, byval channel as long, byval muted as long)

type DUMB_IT_CHANNEL_STATE
	channel as long
	sample as long
	freq as long
	volume as single
	pan as ubyte
	subpan as byte
	filter_cutoff as ubyte
	filter_subcutoff as ubyte
	filter_resonance as ubyte
end type

declare sub dumb_it_sr_get_channel_state(byval sr as DUMB_IT_SIGRENDERER ptr, byval channel as long, byval state as DUMB_IT_CHANNEL_STATE ptr)
const DUMB_SEMITONE_BASE = 1.059463094359295309843105314939748495817
const DUMB_QUARTERTONE_BASE = 1.029302236643492074463779317738953977823
const DUMB_PITCH_BASE = 1.000225659305069791926712241547647863626

type sigdata_t as any
type sigrenderer_t as any
type DUH_LOAD_SIGDATA as function(byval duh as DUH ptr, byval file as DUMBFILE ptr) as sigdata_t ptr
type DUH_START_SIGRENDERER as function(byval duh as DUH ptr, byval sigdata as sigdata_t ptr, byval n_channels as long, byval pos as clong) as sigrenderer_t ptr
type DUH_SIGRENDERER_SET_SIGPARAM as sub(byval sigrenderer as sigrenderer_t ptr, byval id as ubyte, byval value as clong)
type DUH_SIGRENDERER_GENERATE_SAMPLES as function(byval sigrenderer as sigrenderer_t ptr, byval volume as single, byval delta as single, byval size as clong, byval samples as sample_t ptr ptr) as clong
type DUH_SIGRENDERER_GET_CURRENT_SAMPLE as sub(byval sigrenderer as sigrenderer_t ptr, byval volume as single, byval samples as sample_t ptr)
type DUH_END_SIGRENDERER as sub(byval sigrenderer as sigrenderer_t ptr)
type DUH_UNLOAD_SIGDATA as sub(byval sigdata as sigdata_t ptr)

type DUH_SIGTYPE_DESC
	as clong type
	load_sigdata as DUH_LOAD_SIGDATA
	start_sigrenderer as DUH_START_SIGRENDERER
	sigrenderer_set_sigparam as DUH_SIGRENDERER_SET_SIGPARAM
	sigrenderer_generate_samples as DUH_SIGRENDERER_GENERATE_SAMPLES
	sigrenderer_get_current_sample as DUH_SIGRENDERER_GET_CURRENT_SAMPLE
	end_sigrenderer as DUH_END_SIGRENDERER
	unload_sigdata as DUH_UNLOAD_SIGDATA
end type

declare sub dumb_register_sigtype(byval desc as DUH_SIGTYPE_DESC ptr)
declare function duh_get_raw_sigdata(byval duh as DUH ptr, byval sig as long, byval type as clong) as sigdata_t ptr
declare function duh_encapsulate_raw_sigrenderer(byval vsigrenderer as sigrenderer_t ptr, byval desc as DUH_SIGTYPE_DESC ptr, byval n_channels as long, byval pos as clong) as DUH_SIGRENDERER ptr
declare function duh_get_raw_sigrenderer(byval sigrenderer as DUH_SIGRENDERER ptr, byval type as clong) as sigrenderer_t ptr
declare function create_sample_buffer(byval n_channels as long, byval length as clong) as sample_t ptr ptr
declare function allocate_sample_buffer(byval n_channels as long, byval length as clong) as sample_t ptr ptr
declare sub destroy_sample_buffer(byval samples as sample_t ptr ptr)
declare sub dumb_silence(byval samples as sample_t ptr, byval length as clong)
type DUMB_CLICK_REMOVER as DUMB_CLICK_REMOVER_
declare function dumb_create_click_remover() as DUMB_CLICK_REMOVER ptr
declare sub dumb_record_click(byval cr as DUMB_CLICK_REMOVER ptr, byval pos as clong, byval step as sample_t)
declare sub dumb_remove_clicks(byval cr as DUMB_CLICK_REMOVER ptr, byval samples as sample_t ptr, byval length as clong, byval step as long, byval halflife as single)
declare function dumb_click_remover_get_offset(byval cr as DUMB_CLICK_REMOVER ptr) as sample_t
declare sub dumb_destroy_click_remover(byval cr as DUMB_CLICK_REMOVER ptr)
declare function dumb_create_click_remover_array(byval n as long) as DUMB_CLICK_REMOVER ptr ptr
declare sub dumb_record_click_array(byval n as long, byval cr as DUMB_CLICK_REMOVER ptr ptr, byval pos as clong, byval step as sample_t ptr)
declare sub dumb_record_click_negative_array(byval n as long, byval cr as DUMB_CLICK_REMOVER ptr ptr, byval pos as clong, byval step as sample_t ptr)
declare sub dumb_remove_clicks_array(byval n as long, byval cr as DUMB_CLICK_REMOVER ptr ptr, byval samples as sample_t ptr ptr, byval length as clong, byval halflife as single)
declare sub dumb_click_remover_get_offset_array(byval n as long, byval cr as DUMB_CLICK_REMOVER ptr ptr, byval offset as sample_t ptr)
declare sub dumb_destroy_click_remover_array(byval n as long, byval cr as DUMB_CLICK_REMOVER ptr ptr)

const DUMB_RQ_ALIASING = 0
const DUMB_RQ_LINEAR = 1
const DUMB_RQ_CUBIC = 2
const DUMB_RQ_N_LEVELS = 3
extern dumb_resampling_quality as long
type DUMB_RESAMPLER as DUMB_RESAMPLER_
type DUMB_RESAMPLE_PICKUP as sub(byval resampler as DUMB_RESAMPLER ptr, byval data as any ptr)

union DUMB_RESAMPLER_x
	x24(0 to (3 * 2) - 1) as sample_t
	x16(0 to (3 * 2) - 1) as short
	x8(0 to (3 * 2) - 1) as byte
end union

type DUMB_RESAMPLER_
	src as any ptr
	pos as clong
	subpos as long
	start as clong
	as clong end
	dir as long
	pickup as DUMB_RESAMPLE_PICKUP
	pickup_data as any ptr
	min_quality as long
	max_quality as long
	x as DUMB_RESAMPLER_x
	overshot as long
end type

declare sub dumb_reset_resampler(byval resampler as DUMB_RESAMPLER ptr, byval src as sample_t ptr, byval src_channels as long, byval pos as clong, byval start as clong, byval end as clong)
declare function dumb_start_resampler(byval src as sample_t ptr, byval src_channels as long, byval pos as clong, byval start as clong, byval end as clong) as DUMB_RESAMPLER ptr
declare function dumb_resample_1_1(byval resampler as DUMB_RESAMPLER ptr, byval dst as sample_t ptr, byval dst_size as clong, byval volume as single, byval delta as single) as clong
declare function dumb_resample_1_2(byval resampler as DUMB_RESAMPLER ptr, byval dst as sample_t ptr, byval dst_size as clong, byval volume_left as single, byval volume_right as single, byval delta as single) as clong
declare function dumb_resample_2_1(byval resampler as DUMB_RESAMPLER ptr, byval dst as sample_t ptr, byval dst_size as clong, byval volume_left as single, byval volume_right as single, byval delta as single) as clong
declare function dumb_resample_2_2(byval resampler as DUMB_RESAMPLER ptr, byval dst as sample_t ptr, byval dst_size as clong, byval volume_left as single, byval volume_right as single, byval delta as single) as clong
declare sub dumb_resample_get_current_sample_1_1(byval resampler as DUMB_RESAMPLER ptr, byval volume as single, byval dst as sample_t ptr)
declare sub dumb_resample_get_current_sample_1_2(byval resampler as DUMB_RESAMPLER ptr, byval volume_left as single, byval volume_right as single, byval dst as sample_t ptr)
declare sub dumb_resample_get_current_sample_2_1(byval resampler as DUMB_RESAMPLER ptr, byval volume_left as single, byval volume_right as single, byval dst as sample_t ptr)
declare sub dumb_resample_get_current_sample_2_2(byval resampler as DUMB_RESAMPLER ptr, byval volume_left as single, byval volume_right as single, byval dst as sample_t ptr)
declare sub dumb_end_resampler(byval resampler as DUMB_RESAMPLER ptr)
declare sub dumb_reset_resampler_16(byval resampler as DUMB_RESAMPLER ptr, byval src as short ptr, byval src_channels as long, byval pos as clong, byval start as clong, byval end as clong)
declare function dumb_start_resampler_16(byval src as short ptr, byval src_channels as long, byval pos as clong, byval start as clong, byval end as clong) as DUMB_RESAMPLER ptr
declare function dumb_resample_16_1_1(byval resampler as DUMB_RESAMPLER ptr, byval dst as sample_t ptr, byval dst_size as clong, byval volume as single, byval delta as single) as clong
declare function dumb_resample_16_1_2(byval resampler as DUMB_RESAMPLER ptr, byval dst as sample_t ptr, byval dst_size as clong, byval volume_left as single, byval volume_right as single, byval delta as single) as clong
declare function dumb_resample_16_2_1(byval resampler as DUMB_RESAMPLER ptr, byval dst as sample_t ptr, byval dst_size as clong, byval volume_left as single, byval volume_right as single, byval delta as single) as clong
declare function dumb_resample_16_2_2(byval resampler as DUMB_RESAMPLER ptr, byval dst as sample_t ptr, byval dst_size as clong, byval volume_left as single, byval volume_right as single, byval delta as single) as clong
declare sub dumb_resample_get_current_sample_16_1_1(byval resampler as DUMB_RESAMPLER ptr, byval volume as single, byval dst as sample_t ptr)
declare sub dumb_resample_get_current_sample_16_1_2(byval resampler as DUMB_RESAMPLER ptr, byval volume_left as single, byval volume_right as single, byval dst as sample_t ptr)
declare sub dumb_resample_get_current_sample_16_2_1(byval resampler as DUMB_RESAMPLER ptr, byval volume_left as single, byval volume_right as single, byval dst as sample_t ptr)
declare sub dumb_resample_get_current_sample_16_2_2(byval resampler as DUMB_RESAMPLER ptr, byval volume_left as single, byval volume_right as single, byval dst as sample_t ptr)
declare sub dumb_end_resampler_16(byval resampler as DUMB_RESAMPLER ptr)
declare sub dumb_reset_resampler_8(byval resampler as DUMB_RESAMPLER ptr, byval src as byte ptr, byval src_channels as long, byval pos as clong, byval start as clong, byval end as clong)
declare function dumb_start_resampler_8(byval src as byte ptr, byval src_channels as long, byval pos as clong, byval start as clong, byval end as clong) as DUMB_RESAMPLER ptr
declare function dumb_resample_8_1_1(byval resampler as DUMB_RESAMPLER ptr, byval dst as sample_t ptr, byval dst_size as clong, byval volume as single, byval delta as single) as clong
declare function dumb_resample_8_1_2(byval resampler as DUMB_RESAMPLER ptr, byval dst as sample_t ptr, byval dst_size as clong, byval volume_left as single, byval volume_right as single, byval delta as single) as clong
declare function dumb_resample_8_2_1(byval resampler as DUMB_RESAMPLER ptr, byval dst as sample_t ptr, byval dst_size as clong, byval volume_left as single, byval volume_right as single, byval delta as single) as clong
declare function dumb_resample_8_2_2(byval resampler as DUMB_RESAMPLER ptr, byval dst as sample_t ptr, byval dst_size as clong, byval volume_left as single, byval volume_right as single, byval delta as single) as clong
declare sub dumb_resample_get_current_sample_8_1_1(byval resampler as DUMB_RESAMPLER ptr, byval volume as single, byval dst as sample_t ptr)
declare sub dumb_resample_get_current_sample_8_1_2(byval resampler as DUMB_RESAMPLER ptr, byval volume_left as single, byval volume_right as single, byval dst as sample_t ptr)
declare sub dumb_resample_get_current_sample_8_2_1(byval resampler as DUMB_RESAMPLER ptr, byval volume_left as single, byval volume_right as single, byval dst as sample_t ptr)
declare sub dumb_resample_get_current_sample_8_2_2(byval resampler as DUMB_RESAMPLER ptr, byval volume_left as single, byval volume_right as single, byval dst as sample_t ptr)
declare sub dumb_end_resampler_8(byval resampler as DUMB_RESAMPLER ptr)
declare sub dumb_reset_resampler_n(byval n as long, byval resampler as DUMB_RESAMPLER ptr, byval src as any ptr, byval src_channels as long, byval pos as clong, byval start as clong, byval end as clong)
declare function dumb_start_resampler_n(byval n as long, byval src as any ptr, byval src_channels as long, byval pos as clong, byval start as clong, byval end as clong) as DUMB_RESAMPLER ptr
declare function dumb_resample_n_1_1(byval n as long, byval resampler as DUMB_RESAMPLER ptr, byval dst as sample_t ptr, byval dst_size as clong, byval volume as single, byval delta as single) as clong
declare function dumb_resample_n_1_2(byval n as long, byval resampler as DUMB_RESAMPLER ptr, byval dst as sample_t ptr, byval dst_size as clong, byval volume_left as single, byval volume_right as single, byval delta as single) as clong
declare function dumb_resample_n_2_1(byval n as long, byval resampler as DUMB_RESAMPLER ptr, byval dst as sample_t ptr, byval dst_size as clong, byval volume_left as single, byval volume_right as single, byval delta as single) as clong
declare function dumb_resample_n_2_2(byval n as long, byval resampler as DUMB_RESAMPLER ptr, byval dst as sample_t ptr, byval dst_size as clong, byval volume_left as single, byval volume_right as single, byval delta as single) as clong
declare sub dumb_resample_get_current_sample_n_1_1(byval n as long, byval resampler as DUMB_RESAMPLER ptr, byval volume as single, byval dst as sample_t ptr)
declare sub dumb_resample_get_current_sample_n_1_2(byval n as long, byval resampler as DUMB_RESAMPLER ptr, byval volume_left as single, byval volume_right as single, byval dst as sample_t ptr)
declare sub dumb_resample_get_current_sample_n_2_1(byval n as long, byval resampler as DUMB_RESAMPLER ptr, byval volume_left as single, byval volume_right as single, byval dst as sample_t ptr)
declare sub dumb_resample_get_current_sample_n_2_2(byval n as long, byval resampler as DUMB_RESAMPLER ptr, byval volume_left as single, byval volume_right as single, byval dst as sample_t ptr)
declare sub dumb_end_resampler_n(byval n as long, byval resampler as DUMB_RESAMPLER ptr)
declare function make_duh(byval length as clong, byval n_tags as long, byval tag as const zstring const ptr ptr, byval n_signals as long, byval desc as DUH_SIGTYPE_DESC ptr ptr, byval sigdata as sigdata_t ptr ptr) as DUH ptr
declare sub duh_set_length(byval duh as DUH ptr, byval length as clong)

end extern

#endif ' NO_MOD

#endif ' __DUMB_BI__