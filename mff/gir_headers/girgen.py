# Generates FreeBASIC headers (gir_headers style) from GObject-Introspection .gir files.
# Usage: python gen.py <girdir> <headerdir> Graphene-1.0 Gdk-4.0 Gsk-4.0 Gtk-4.0
import os, re, sys
import xml.etree.ElementTree as ET

CORE = '{http://www.gtk.org/introspection/core/1.0}'
C = '{http://www.gtk.org/introspection/c/1.0}'
GLIB = '{http://www.gtk.org/introspection/glib/1.0}'

GIRDIR, HDIR = sys.argv[1], sys.argv[2]
TARGETS = sys.argv[3:]

BADKW = set(x.lower() for x in open(os.path.join(os.path.dirname(__file__), 'badkw.txt')).read().split())

def tag(e):
    return e.tag.split('}')[1]

# ---------------------------------------------------------------- dependency headers
re_ident_decl = re.compile(r'(?im)^\s*declare\s+(?:function|sub)\s+(\w+)')
re_define = re.compile(r'(?im)^\s*#define\s+(\w+)')
re_type_alias = re.compile(r'(?im)^\s*type\s+as\s+(.+?)\s*$')
re_type_named_as = re.compile(r'(?im)^\s*type\s+(\w+)\s+as\s+(.+?)\s*$')
re_type_body = re.compile(r'(?im)^\s*(type|union)\s+(\w+)\s*(?:field\s*=\s*\d+)?\s*$')
re_enum_member = re.compile(r'(?im)^\s+([A-Za-z_]\w*)\s*=')
re_include = re.compile(r'(?im)^\s*#include\s+once\s+"([^"]+)"')

dep_types = set()       # lower-case type names known
dep_complete = set()    # lower-case type names that are complete (usable by value)
dep_idents = set()      # lower-case identifiers (all kinds)
dep_macros = set()
parsed_headers = set()

def parse_header(fn):
    fn = os.path.normpath(fn)
    if fn in parsed_headers or not os.path.exists(fn):
        return
    parsed_headers.add(fn)
    txt = open(fn, encoding='latin-1').read()
    # strip comment lines
    lines = [l for l in txt.split('\n') if not l.lstrip().startswith("'")]
    txt = '\n'.join(lines)
    for inc in re_include.findall(txt):
        parse_header(os.path.join(os.path.dirname(fn), inc))
    aliases = []
    for m in re_type_alias.finditer(txt):
        rest = m.group(1)
        # Type As <target> name1, name2
        mm = re.match(r'(?i)(const\s+)?(\w+)((?:\s+ptr)*)\s+(.+)$', rest)
        if not mm:
            continue
        target = mm.group(2).lower()
        isptr = bool(mm.group(3).strip())
        for n in mm.group(4).split(','):
            n = n.strip().split()[0] if n.strip() else ''
            if not n:
                continue
            dep_types.add(n.lower()); dep_idents.add(n.lower())
            aliases.append((n.lower(), target, isptr))
    for m in re_type_named_as.finditer(txt):
        n = m.group(1).lower()
        dep_types.add(n); dep_idents.add(n)
        dep_complete.add(n)  # callbacks / Type X As Y
    for m in re_type_body.finditer(txt):
        n = m.group(2).lower()
        if n in ('as',):
            continue
        dep_types.add(n); dep_idents.add(n); dep_complete.add(n)
    for m in re_ident_decl.finditer(txt):
        dep_idents.add(m.group(1).lower())
    for m in re_define.finditer(txt):
        dep_idents.add(m.group(1).lower()); dep_macros.add(m.group(1).lower())
    for m in re_enum_member.finditer(txt):
        dep_idents.add(m.group(1).lower())
    basic = {'byte', 'ubyte', 'short', 'ushort', 'long', 'ulong', 'longint', 'ulongint', 'integer', 'uinteger',
             'single', 'double', 'zstring', 'wstring', 'any', 'boolean', 'cva_list', 'string'}
    changed = True
    while changed:
        changed = False
        for n, target, isptr in aliases:
            if n in dep_complete:
                continue
            if isptr or target in basic or target in dep_complete:
                dep_complete.add(n); changed = True

parse_header(os.path.join(HDIR, '_GirToBac-0.0.bi'))
dep_complete.update(['gchar', 'char', 'gint', 'guint', 'gboolean', 'gpointer', 'gconstpointer', 'va_list', 'file',
                     'gint8', 'guint8', 'guchar', 'gint16', 'guint16', 'gshort', 'gushort', 'gunichar2', 'gint32', 'guint32',
                     'gunichar', 'gint64', 'guint64', 'glong', 'gulong', 'gfloat', 'gdouble', 'gssize', 'gsize',
                     'ssize_t', 'size_t', 'goffset', 'utf8', 'filename'])

# ---------------------------------------------------------------- gir index (all namespaces)
class Repo:
    pass

repos = {}
gir_name_to_ctype = {}  # 'Gtk.Widget' -> 'GtkWidget'
kind_of_ctype = {}      # 'GtkWidget' -> 'class'/'record'/...

def load_repo(name):
    if name in repos:
        return repos[name]
    path = os.path.join(GIRDIR, name + '.gir')
    if not os.path.exists(path):
        repos[name] = None
        return None
    root = ET.parse(path).getroot()
    r = Repo()
    r.name = name
    r.root = root
    r.includes = [(i.get('name'), i.get('version')) for i in root.findall(CORE + 'include')]
    r.ns = root.find(CORE + 'namespace')
    r.nsname = r.ns.get('name')
    r.prefixes = (r.ns.get(C + 'symbol-prefixes') or r.nsname.lower()).split(',')
    r.idprefixes = (r.ns.get(C + 'identifier-prefixes') or r.nsname).split(',')
    r.shlib = r.ns.get('shared-library') or ''
    repos[name] = r
    for e in r.ns:
        t = tag(e)
        n = e.get('name')
        ct = e.get(C + 'type') or e.get(GLIB + 'type-name')
        if n and ct:
            gir_name_to_ctype[r.nsname + '.' + n] = ct
            kind_of_ctype[ct] = t
    for inc, ver in r.includes:
        load_repo(inc + '-' + ver)
    return r

for t in TARGETS:
    load_repo(t)

BASICMAP = {
    'gchar': 'gchar', 'char': 'gchar', 'int': 'gint', 'unsigned int': 'guint', 'unsigned': 'guint',
    'signed': 'gint', 'long': 'glong', 'unsigned long': 'gulong', 'long int': 'glong',
    'short': 'gshort', 'unsigned short': 'gushort', 'unsigned char': 'guchar', 'signed char': 'gint8',
    'float': 'gfloat', 'double': 'gdouble', 'long double': 'gdouble', 'void': 'Any',
    'long long': 'gint64', 'unsigned long long': 'guint64',
    'int8_t': 'gint8', 'uint8_t': 'guint8', 'int16_t': 'gint16', 'uint16_t': 'guint16',
    'int32_t': 'gint32', 'uint32_t': 'guint32', 'int64_t': 'gint64', 'uint64_t': 'guint64',
    'pid_t': 'gint', 'uid_t': 'guint', 'gid_t': 'guint', 'bool': 'Boolean', '_Bool': 'Boolean',
    'utf8': 'gchar Ptr', 'filename': 'gchar Ptr', 'none': 'Any', 'gtype': 'GType', 'off_t': 'goffset',
    'time_t': 'glong', 'socklen_t': 'guint', 'dev_t': 'guint64', 'ino_t': 'guint64', 'mode_t': 'guint',
    'GType': 'GType',
}

unknown_types = set()

def norm_ctype(ct):
    ct = re.sub(r'\b(volatile|restrict)\b', ' ', ct)
    isconst = bool(re.match(r'\s*const\b', ct))
    ptr = ct.count('*')
    base = re.sub(r'\bconst\b', ' ', ct.replace('*', ' '))
    base = re.sub(r'\bstruct\b|\bunion\b|\benum\b', ' ', base)
    base = ' '.join(base.split())
    return isconst, base, ptr

def map_base(base):
    if base in BASICMAP:
        b = BASICMAP[base]
        return b
    return base

def fb_from_ctype(ct, gir_name=None):
    isconst, base, ptr = norm_ctype(ct)
    b = map_base(base)
    if b.endswith(' Ptr'):  # utf8 etc.
        b = b[:-4]; ptr += 1
    s = ('Const ' if isconst and ptr > 0 else '') + b + ' Ptr' * ptr
    return s, b, ptr

def type_elem_to_fb(te):
    """te: <type> or <array> or <varargs>. returns (fbtype, basename, ptrcount) ; None for varargs"""
    t = tag(te)
    if t == 'varargs':
        return None
    ct = te.get(C + 'type')
    if t == 'array':
        if ct:
            return fb_from_ctype(ct)
        inner = None
        for ch in te:
            if tag(ch) in ('type', 'array'):
                inner = ch
                break
        if inner is None:
            return ('gpointer', 'gpointer', 0)
        s, b, p = type_elem_to_fb(inner)
        return (s + ' Ptr', b, p + 1)
    # <type>
    if ct:
        return fb_from_ctype(ct)
    n = te.get('name') or 'none'
    if n in BASICMAP:
        return fb_from_ctype(n)
    if n.startswith('g') and n[1:] and n in ('gboolean', 'gint', 'guint', 'gint8', 'guint8', 'gint16', 'guint16',
                                             'gint32', 'guint32', 'gint64', 'guint64', 'gfloat', 'gdouble',
                                             'gchar', 'guchar', 'gsize', 'gssize', 'gpointer', 'gconstpointer',
                                             'glong', 'gulong', 'gshort', 'gushort', 'gunichar', 'goffset', 'gintptr', 'guintptr'):
        return fb_from_ctype(n)
    if '.' not in n:
        n2 = CUR.nsname + '.' + n
    else:
        n2 = n
    if n2 in gir_name_to_ctype:
        cty = gir_name_to_ctype[n2]
        k = kind_of_ctype.get(cty)
        if k in ('class', 'interface', 'record', 'union', 'boxed'):
            return (cty + ' Ptr', cty, 1)
        return (cty, cty, 0)
    return ('gpointer', 'gpointer', 0)

def find_type_child(e):
    for ch in e:
        if tag(ch) in ('type', 'array', 'varargs'):
            return ch
    return None

# ---------------------------------------------------------------- generation per namespace
def sanitize_field(n):
    if n.lower() in BADKW or n.lower() in all_macros_lower:
        return n + '_'
    return n

def gen_params(e, for_callback=False):
    """returns (list of fb param strings, set of byvalue base types, ok)"""
    out = []
    byval = set()
    allnames = set()
    ps = e.find(CORE + 'parameters')
    if ps is None:
        if e.get('throws') == '1':
            out.append('ByVal As GError Ptr Ptr')
        return out, byval, allnames
    for p in ps:
        t = tag(p)
        if t not in ('parameter', 'instance-parameter'):
            continue
        te = find_type_child(p)
        if te is None:
            continue
        r = type_elem_to_fb(te)
        if r is None:
            out.append('...')
            continue
        s, b, ptr = r
        if ptr == 0 and b != 'Any':
            byval.add(b)
        allnames.add(b)
        if b == 'Any' and ptr == 0:
            s = 'Any Ptr'
        out.append('ByVal As ' + s)
    if e.get('throws') == '1':
        if out and out[-1] == '...':
            out.insert(len(out) - 1, 'ByVal As GError Ptr Ptr')
        else:
            out.append('ByVal As GError Ptr Ptr')
    return out, byval, allnames

def gen_ret(e):
    rv = e.find(CORE + 'return-value')
    if rv is None:
        return None, set(), set()
    te = find_type_child(rv)
    if te is None:
        return None, set(), set()
    s, b, ptr = type_elem_to_fb(te)
    if b == 'Any' and ptr == 0:
        return None, set(), set()
    return s, ({b} if ptr == 0 else set()), {b}

def proc_sig(e, cconv=True):
    params, byval, names = gen_params(e, True)
    ret, rbv, rnames = gen_ret(e)
    byval |= rbv; names |= rnames
    p = '(' + ', '.join(params) + ')'
    if ret is None:
        return 'Sub CDecl' + p if cconv else 'Sub' + p, byval, names
    return ('Function CDecl' + p + ' As ' + ret) if cconv else ('Function' + p + ' As ' + ret), byval, names

def macro_base_from_gettype(gt, r):
    if not gt or not gt.endswith('_get_type'):
        return None, None
    base = gt[:-len('_get_type')].upper()
    for pf in sorted(r.prefixes, key=len, reverse=True):
        P = pf.upper() + '_'
        if base.startswith(P):
            return base, P + 'TYPE_' + base[len(P):]
    return base, None

all_macros_lower = set()

def generate(name):
    global CUR
    r = repos[name]
    CUR = r
    ns = r.ns
    out_fwd = []      # forward declarations / aliases / enums
    items = {}        # name -> (deps set, lines list)  for records/unions/callbacks/aliases
    order_hint = []
    funcs = []        # declare lines
    macros = []
    consts = []
    local_types = set()
    local_complete = set()
    used_types = set()

    def ct_of(e):
        return e.get(C + 'type') or e.get(GLIB + 'type-name')

    # ---- pass 1: collect type names
    for e in ns:
        t = tag(e)
        ct = ct_of(e)
        if t in ('class', 'interface', 'record', 'union', 'boxed') and ct:
            local_types.add(ct)
        elif t in ('enumeration', 'bitfield', 'callback', 'alias') and ct:
            local_types.add(ct)

    # ---- identifiers for dedupe (enum members, constants, macros)
    pending_idents = []  # (identifier, kind)

    # ---- forward declarations
    for e in ns:
        t = tag(e)
        ct = ct_of(e)
        if not ct:
            continue
        if t in ('class', 'interface', 'record', 'union', 'boxed'):
            if ct.lower() in dep_types:
                continue
            if t == 'boxed' and e.get(C + 'type') is None:
                continue
            out_fwd.append('Type As _%s %s' % (ct, ct))

    # ---- enums / bitfields
    enum_lines = []
    for e in ns:
        t = tag(e)
        if t not in ('enumeration', 'bitfield'):
            continue
        ct = ct_of(e)
        if not ct or ct.lower() in dep_types:
            continue
        enum_lines.append(('type', 'Type As Long %s' % ct))
        mem = []
        for m in e.findall(CORE + 'member'):
            ident = m.get(C + 'identifier')
            v = m.get('value')
            if not ident or v is None:
                continue
            iv = int(v)
            if iv > 2147483647:
                iv -= 4294967296
            mem.append((ident, iv))
            pending_idents.append(ident)
        enum_lines.append(('enum', mem))
        local_complete.add(ct)

    # ---- constants
    const_items = []
    for e in ns.findall(CORE + 'constant'):
        ident = e.get(C + 'type') or e.get(C + 'identifier')
        v = e.get('value')
        if not ident or v is None:
            continue
        te = find_type_child(e)
        tn = te.get('name') if te is not None else ''
        if tn in ('utf8', 'filename'):
            val = '"' + v.replace('"', '""') + '"'
        else:
            if re.match(r'^-?\d+(\.\d+)?(e[-+]?\d+)?$', v, re.I):
                val = v
            elif v in ('true', 'false'):
                val = '1' if v == 'true' else '0'
            else:
                continue
        const_items.append((ident, val))
        pending_idents.append(ident)

    # ---- GType macros
    gtype_macros = []
    gettype_funcs = []
    for e in ns:
        t = tag(e)
        if t not in ('class', 'interface', 'record', 'union', 'boxed', 'enumeration', 'bitfield'):
            continue
        gt = e.get(GLIB + 'get-type')
        ct = ct_of(e)
        if not gt or gt == 'intern' or not ct:
            continue
        base, tmac = macro_base_from_gettype(gt, r)
        if not tmac:
            continue
        gettype_funcs.append(gt)
        lines = ['#define %s (%s())' % (tmac, gt)]
        idents = [tmac]
        if t in ('class', 'interface'):
            lines.append('#define %s(obj) (G_TYPE_CHECK_INSTANCE_CAST((obj), %s, %s))' % (base, tmac, ct))
            P, rest = tmac.split('_TYPE_', 1)
            ismac = P + '_IS_' + rest
            lines.append('#define %s(obj) (G_TYPE_CHECK_INSTANCE_TYPE((obj), %s))' % (ismac, tmac))
            idents += [base, ismac]
            ts = e.get(GLIB + 'type-struct')
            if ts:
                tsct = gir_name_to_ctype.get(r.nsname + '.' + ts)
                if tsct:
                    if t == 'class':
                        lines.append('#define %s_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST((klass), %s, %s))' % (base, tmac, tsct))
                        lines.append('#define %s_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE((klass), %s))' % (ismac, tmac))
                        lines.append('#define %s_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS((obj), %s, %s))' % (base, tmac, tsct))
                        idents += [base + '_CLASS', ismac + '_CLASS', base + '_GET_CLASS']
                    else:
                        lines.append('#define %s_GET_IFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE((obj), %s, %s))' % (base, tmac, tsct))
                        idents += [base + '_GET_IFACE']
        gtype_macros.append((lines, idents))

    # ---- dedupe identifiers (case-insensitive) ----
    rename = {}
    groups = {}
    for i in pending_idents:
        groups.setdefault(i.lower(), []).append(i)
    used = set(dep_idents)
    for lname, lst in groups.items():
        uniq = []
        for x in lst:
            if x not in uniq:
                uniq.append(x)
        # keeper: fewest uppercase letters
        uniq.sort(key=lambda s: sum(1 for c in s if c.isupper()))
        for k, x in enumerate(uniq):
            nn = x
            if k > 0 or nn.lower() in used:
                while nn.lower() in used or (k > 0 and nn == x):
                    nn += '_'
            used.add(nn.lower())
            rename[x] = nn
    filtered = []
    for lines, idents in gtype_macros:
        nl = []; ni = []
        for ln, i in zip(lines, idents):
            if i.lower() in used:
                continue
            used.add(i.lower()); nl.append(ln); ni.append(i)
        filtered.append((nl, ni))
    gtype_macros[:] = filtered
    for lines, idents in gtype_macros:
        for i in idents:
            all_macros_lower.add(i.lower())
    for i, _ in const_items:
        all_macros_lower.add(rename.get(i, i).lower())

    # ---- aliases
    for e in ns.findall(CORE + 'alias'):
        ct = ct_of(e)
        if not ct or ct.lower() in dep_types:
            continue
        te = find_type_child(e)
        if te is None:
            continue
        s, b, ptr = type_elem_to_fb(te)
        if b == 'Any' and ptr == 0:
            s = 'Any'
        deps = {b} if ptr == 0 else set()
        items[ct] = (deps, set([b]), ['Type As %s %s' % (s, ct)])
        order_hint.append(ct)

    # ---- callbacks
    for e in ns.findall(CORE + 'callback'):
        ct = ct_of(e)
        if not ct or ct.lower() in dep_types:
            continue
        sig, byval, names = proc_sig(e)
        items[ct] = (set(byval), names, ['Type %s As %s' % (ct, sig)])
        order_hint.append(ct)

    # ---- records / classes / unions bodies
    def field_lines(container, indent):
        lines = []
        deps = set()
        names = set()
        ok = True
        for f in container:
            t = tag(f)
            if t == 'field':
                fname = sanitize_field(f.get('name'))
                bits = f.get('bits')
                cb = f.find(CORE + 'callback')
                if cb is not None:
                    sig, bv, nm = proc_sig(cb)
                    deps |= bv; names |= nm
                    lines.append(indent + 'As %s %s' % (sig, fname))
                    continue
                te = find_type_child(f)
                if te is None:
                    ok = False; continue
                if tag(te) == 'array' and te.get('fixed-size'):
                    inner = find_type_child(te)
                    if inner is None:
                        ok = False; continue
                    s, b, ptr = type_elem_to_fb(inner)
                    if b == 'Any' and ptr == 0:
                        s = 'Any Ptr'
                    if ptr == 0:
                        deps.add(b)
                    names.add(b)
                    n = int(te.get('fixed-size'))
                    lines.append(indent + 'As %s %s(0 To %d)' % (s, fname, n - 1))
                    continue
                s, b, ptr = type_elem_to_fb(te)
                if b == 'Any' and ptr == 0:
                    s = 'Any Ptr'
                if ptr == 0:
                    deps.add(b)
                names.add(b)
                if bits:
                    lines.append(indent + 'As %s %s : %s' % (s, fname, bits))
                else:
                    lines.append(indent + 'As %s %s' % (s, fname))
            elif t == 'union':
                sub, d, nm, o = field_lines(f, indent + '  ')
                deps |= d; names |= nm; ok = ok and o
                if f.get('name'):
                    # named union member: emit anonymous (FB lacks inline named unions)
                    pass
                lines.append(indent + 'Union')
                lines += sub
                lines.append(indent + 'End Union')
            elif t == 'record':
                sub, d, nm, o = field_lines(f, indent + '  ')
                deps |= d; names |= nm; ok = ok and o
                lines.append(indent + 'Type')
                lines += sub
                lines.append(indent + 'End Type')
        return lines, deps, names, ok

    for e in ns:
        t = tag(e)
        if t not in ('class', 'record', 'union'):
            continue
        ct = ct_of(e)
        if not ct or ct.lower() in dep_complete:
            continue
        has_fields = any(tag(f) in ('field', 'union', 'record') for f in e)
        if not has_fields:
            continue
        if e.get('disguised') == '1' and not any(tag(f) == 'field' for f in e):
            continue
        fl, deps, names, ok = field_lines(e, '  ')
        if not ok or not fl:
            continue
        kw = 'Union' if t == 'union' else 'Type'
        lines = ['%s _%s' % (kw, ct)] + fl + ['End %s' % kw]
        items['_' + ct] = (deps, names, lines)
        order_hint.append('_' + ct)

    # ---- resolve dependencies; types considered complete
    item_names_by_ct = {}
    for k in items:
        item_names_by_ct[k.lstrip('_') if k.startswith('_') else k] = k

    def dep_key(b):
        # map a by-value base type name to an item key
        if b in items and not b.startswith('_'):
            return b
        if '_' + b in items:
            return '_' + b
        return None

    def is_complete_external(b):
        bl = b.lower()
        if bl in dep_complete:
            return True
        if b in local_complete:  # enums
            return True
        return False

    emitted = []
    state = {}
    failed = set()

    def visit(k, stack):
        if state.get(k) == 2:
            return k not in failed
        if state.get(k) == 1:
            return True  # cycle: hope for the best
        state[k] = 1
        deps, names, lines = items[k]
        good = True
        for b in deps:
            if b == k or ('_' + b) == k:
                continue
            dk = dep_key(b)
            if dk:
                if not visit(dk, stack + [k]):
                    good = False
            elif not is_complete_external(b):
                good = False
        # callbacks referenced by name in fields need to be emitted before (they're names, not byval)
        for b in names:
            dk = dep_key(b)
            if dk and dk != k and not dk.startswith('_'):
                kind = kind_of_ctype.get(b)
                if kind in ('callback', 'alias'):
                    visit(dk, stack + [k])
        state[k] = 2
        if good:
            emitted.append(k)
        else:
            failed.add(k)
        return good

    for k in order_hint:
        visit(k, [])

    # failed callbacks/aliases fall back to opaque pointer type so that names exist
    complete_now = set(x.lower().lstrip('_') for x in emitted)

    # ---- functions
    func_lines = []
    seen_funcs = set()

    def add_func(e):
        cid = e.get(C + 'identifier')
        if not cid or cid in seen_funcs:
            return
        if e.get('moved-to'):
            pass
        seen_funcs.add(cid)
        params, byval, names = gen_params(e)
        ret, rbv, rnames = gen_ret(e)
        byval |= rbv
        for b in byval:
            bl = b.lower()
            if bl in dep_complete or b in local_complete or bl in complete_now:
                continue
            func_lines.append("' skipped %s: by-value use of incomplete type %s" % (cid, b))
            return
        nm = cid
        alias = ''
        if cid.lower() in dep_idents or cid.lower() in used_func_names:
            nm = cid + '_'
            alias = ' Alias "%s"' % cid
        # gboolean parameters: FreeBASIC's True is -1, GTK4 rejects it for boolean properties.
        # The function gets another name, a macro with the real name passes 0/1
        bidx = [i for i, x in enumerate(params) if x == 'ByVal As gboolean']
        if bidx and '...' not in params and not alias:
            nm = cid + '__'
            alias = ' Alias "%s"' % cid
            args = ['__a%d__' % i for i in range(len(params))]
            call = ['IIf((%s), 1, 0)' % a if i in bidx else a for i, a in enumerate(args)]
            bool_macros.append('#define %s(%s) %s(%s)' % (cid, ', '.join(args), nm, ', '.join(call)))
        used_func_names.add(nm.lower())
        p = '(' + ', '.join(params) + ')'
        if ret is None:
            func_lines.append('Declare Sub %s%s%s' % (nm, alias, p))
        else:
            func_lines.append('Declare Function %s%s%s As %s' % (nm, alias, p, ret))
        for b in names:
            used_types.add(b)

    used_func_names = set()
    bool_macros = []
    for e in ns.iter():
        t = tag(e)
        if t in ('function', 'method', 'constructor'):
            add_func(e)

    for gt in gettype_funcs:
        if gt in seen_funcs or gt.lower() in dep_idents:
            continue
        seen_funcs.add(gt); used_func_names.add(gt.lower())
        func_lines.append('Declare Function %s() As GType' % gt)

    # collect referenced types from items too
    for k in emitted:
        for b in items[k][1]:
            used_types.add(b)

    # unknown types => opaque forward declarations
    extra_fwd = []
    known_lower = set(dep_types) | set(x.lower() for x in local_types)
    builtin = {'any', 'boolean', 'gtype'}
    for b in sorted(used_types):
        bl = b.lower()
        if bl in known_lower or bl in builtin or bl in dep_complete:
            continue
        if not re.match(r'^[A-Za-z_]\w*$', b):
            continue
        extra_fwd.append('Type As _%s %s' % (b, b))
        known_lower.add(bl)
    # failed items: give them an opaque name
    for k in sorted(failed):
        if not k.startswith('_'):
            extra_fwd.append("Type As Any Ptr %s ' simplified (incomplete dependency)" % k)

    # ---- write
    L = []
    L.append("'            FreeBasic header file, auto-generated by")
    L.append("'                 gen.py (MyFbFramework, girtobac style)")
    L.append("' Auto-translated from file /usr/share/gir-1.0/%s.gir" % name)
    L.append('#include once "_GirToBac-0.0.bi"')
    L.append("' Repository version 1.2")
    for inc, ver in r.includes:
        fn = '%s-%s.bi' % (inc, ver)
        if inc == 'cairo':
            L.append("'#include once \"%s\"" % fn)
        else:
            L.append('#include once "%s"' % fn)
    L += out_fwd
    L += extra_fwd
    for kind, v in enum_lines:
        if kind == 'type':
            L.append(v)
        else:
            if not v:
                continue
            L.append('Enum')
            for ident, iv in v:
                L.append('  %s = %d' % (rename.get(ident, ident), iv))
            L.append('End Enum')
    for ident, val in const_items:
        L.append('#define %s %s' % (rename.get(ident, ident), val))
    for k in emitted:
        L += items[k][2]
    lib = ''
    m = re.match(r'lib(.+?)\.so', (r.shlib.split(',')[0] if r.shlib else ''))
    if m:
        lib = m.group(1)
    if not lib and r.shlib:
        lib = r.shlib.split(',')[0]
    L.append('Extern "C" Lib "%s"' % lib if lib else 'Extern "C"')
    L += func_lines
    for lines, idents in gtype_macros:
        L += lines
    L.append('End Extern')
    L += bool_macros
    open(os.path.join(HDIR, name + '.bi'), 'w', encoding='latin-1', newline='\n').write('\n'.join(L) + '\n')
    # register for following namespaces
    for x in local_types:
        dep_types.add(x.lower()); dep_idents.add(x.lower())
    for x in emitted:
        dep_complete.add(x.lower().lstrip('_'))
        dep_complete.add(x.lower())
    for x in local_complete:
        dep_complete.add(x.lower())
    for x in rename.values():
        dep_idents.add(x.lower())
    for x in used_func_names:
        dep_idents.add(x)
    for lines, idents in gtype_macros:
        for i in idents:
            dep_idents.add(i.lower())
    print(name, 'types', len(local_types), 'items', len(emitted), 'failed', len(failed), 'funcs', len(func_lines), 'extra_fwd', len(extra_fwd))

# parse dependency headers that are not targets
for t in TARGETS:
    r = repos[t]
    for inc, ver in r.includes:
        n = '%s-%s' % (inc, ver)
        if n not in TARGETS:
            parse_header(os.path.join(HDIR, n + '.bi'))

for t in TARGETS:
    generate(t)
