// mff_lib.js - MyFbFramework Web (WASM) bridge.
// Linked with: emcc ... --js-library mff_lib.js
// Every function here is imported by the FreeBASIC side (see Declare list in SysUtils.bi under __USE_WASM__).
// FreeBASIC "String" parameters arrive as a pointer to the string descriptor (first field = data pointer),
// numeric parameters arrive as numbers, "Any Ptr" ids are control pointers used as DOM element ids.

var MffLibrary = {
	$mff__deps: ['$UTF8ToString', '$stringToNewUTF8'],
	$mff: {
		// FreeBASIC String (descriptor pointer) -> JS string
		str: function(p) {
			if (!p) return "";
			var data = HEAPU32[p >> 2];
			return data ? UTF8ToString(data) : "";
		},
		el: function(id) {
			return document.getElementById(String(id));
		},
		// FreeBASIC colors are BGR integers (&hBBGGRR), -1 means default
		color: function(v) {
			if (v < 0) return "";
			return "rgb(" + (v & 255) + ", " + ((v >> 8) & 255) + ", " + ((v >> 16) & 255) + ")";
		},
		call: function(name, args) {
			var f = Module["_" + name];
			if (f) return f.apply(null, args);
		},
		shift: function(e) {
			return (e.shiftKey ? 1 : 0) | (e.ctrlKey ? 2 : 0) | (e.altKey ? 4 : 0);
		},
		key: function(e) {
			if (e.keyCode) return e.keyCode;
			return e.key && e.key.length === 1 ? e.key.charCodeAt(0) : 0;
		},
		// the items of a list: the options of a <select> or the .mffitem labels
		items: function(e) {
			return e.tagName == "SELECT" ? e.options : e.querySelectorAll(":scope > .mffitem");
		},
		item: function(e, text) {
			if (e.tagName == "SELECT") {
				var o = document.createElement("option");
				o.textContent = text;
				return o;
			}
			var l = document.createElement("label");
			l.className = "mffitem";
			l.style.cssText = "display: block; white-space: nowrap;";
			var c = document.createElement("input");
			c.type = e.getAttribute("data-check") || "checkbox";
			if (c.type == "radio") c.name = String(e.id);
			l.appendChild(c);
			l.appendChild(document.createTextNode(text));
			return l;
		},
		tableFill: function(tr, cells) {
			tr.innerHTML = "";
			cells.split("\t").forEach(function(text) {
				var td = document.createElement("td");
				td.textContent = text;
				td.style.cssText = "border: 1px solid #ddd; padding: 2px 4px; white-space: nowrap;";
				tr.appendChild(td);
			});
		},
		tableSelect: function(e, index) {
			var rows = e.tBodies[0].rows;
			for (var i = 0; i < rows.length; i++) {
				rows[i].style.backgroundColor = i == index ? "Highlight" : "";
				rows[i].style.color = i == index ? "HighlightText" : "";
			}
			e.setAttribute("data-position", index);
		},
		// Canvas of a control: a <canvas> over the element, made at the first drawing.
		// It follows the size of the element; a change of the size repaints the control (ONPAINT).
		ctx: function(id, create) {
			var e = mff.el(id);
			if (!e) return null;
			var c = e.querySelector(":scope > canvas.mffcanvas");
			if (!c) {
				if (!create) return null;
				c = document.createElement("canvas");
				c.className = "mffcanvas";
				c.style.cssText = "position: absolute; left: 0; top: 0; width: 100%; height: 100%; pointer-events: none;";
				e.insertAdjacentElement("afterbegin", c);
				if (typeof ResizeObserver !== "undefined") {
					var w0 = e.clientWidth, h0 = e.clientHeight;
					new ResizeObserver(function() {
						if (e.clientWidth == w0 && e.clientHeight == h0) return;
						w0 = e.clientWidth; h0 = e.clientHeight;
						mff.call("ONPAINT", [id]);
					}).observe(e);
				}
			}
			var dpr = window.devicePixelRatio || 1;
			var w = Math.max(1, Math.round(e.clientWidth * dpr)), h = Math.max(1, Math.round(e.clientHeight * dpr));
			var g = c.getContext("2d");
			if (c.width != w || c.height != h) {
				c.width = w;
				c.height = h;
				g.setTransform(dpr, 0, 0, dpr, 0, 0);
			}
			return g;
		},
		rgba: function(color, alpha) {
			return "rgba(" + (color & 255) + ", " + ((color >> 8) & 255) + ", " + ((color >> 16) & 255) + ", " + (alpha / 255) + ")";
		},
		font: function(name, size, bold, italic) {
			return (italic ? "italic " : "") + (bold ? "bold " : "") + size + "px " + (name ? "'" + name + "', " : "") + "sans-serif";
		},
		images: {},
		image: function(path, id) {
			var img = mff.images[path];
			if (!img) {
				img = new Image();
				img.waiting = [];
				img.onload = function() {
					img.waiting.forEach(function(w) { mff.call("ONPAINT", [w]); });
					img.waiting = [];
				};
				img.src = path;
				mff.images[path] = img;
			}
			if (!img.complete && img.waiting.indexOf(id) < 0) img.waiting.push(id);
			return img;
		},
		// The main form is in the flow of the page (position: relative): left/top would only shift it
		// and the elements after it (the console) would be under it, so the margins are used
		place: function(e, left, top) {
			if (e.style.position == "relative") {
				e.style.left = ""; e.style.top = "";
				e.style.marginLeft = left; e.style.marginTop = top;
			} else {
				e.style.left = left; e.style.top = top;
			}
		},
		// The main form fills the browser window (with its margins on all sides) and follows its size:
		// ONRESIZE gives the size to the form, RequestAlign moves the anchored controls
		fitMainForm: function(e, Id) {
			var pending = false;
			function fit() {
				pending = false;
				var r = e.getBoundingClientRect();
				var x = r.left + window.scrollX, y = r.top + window.scrollY;
				var w = Math.max(100, Math.floor(document.documentElement.clientWidth - 2 * x));
				var h = Math.max(100, Math.floor(window.innerHeight - 2 * y));
				if (w == e.offsetWidth && h == e.offsetHeight) return;
				e.style.width = w + "px";
				e.style.height = h + "px";
				mff.call("ONRESIZE", [Id, w, h]);
			}
			window.addEventListener("resize", function() {
				if (!pending) { pending = true; requestAnimationFrame(fit); }
			});
			// after the child controls are created
			setTimeout(fit, 0);
		},
		on: function(id, event, handler) {
			var e = mff.el(id);
			if (e) e.addEventListener(event, handler, false);
		}
	},

	GETDOCUMENTWIDTH__deps: ['$mff'],
	GETDOCUMENTWIDTH: function() {
		return window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	},

	GETDOCUMENTHEIGHT__deps: ['$mff'],
	GETDOCUMENTHEIGHT: function() {
		return window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
	},

	INSERTHTML__deps: ['$mff'],
	INSERTHTML: function(value) {
		document.body.insertAdjacentHTML("afterbegin", mff.str(value));
	},

	SETTITLE__deps: ['$mff'],
	SETTITLE: function(value) {
		document.title = mff.str(value);
	},

	FREEPTR: function(ptr) {
		_free(ptr);
	},

	CREATEELEMENT__deps: ['$mff'],
	CREATEELEMENT: function(AddPosition, ClassName, Class, Type, Id, Name, Text, Style, PositionType, Left, Top, Width, Height, Right, Bottom, Parent) {
		var strType = mff.str(Type);
		var strText = mff.str(Text);
		var strClass = mff.str(Class);
		var e = document.createElement(mff.str(ClassName) || "div");
		if (strType != "") e.type = strType;
		if (strType == "text" || strType == "password" || e.tagName == "TEXTAREA") {
			e.value = strText;
			if (typeof Terminal !== "undefined" && Terminal.prototype.globals && Terminal.prototype.globals.activeTerm) Terminal.prototype.globals.activeTerm.lock = true;
		} else {
			e.innerHTML = strText;
		}
		e.id = String(Id);
		e.name = mff.str(Name);
		e.className = strClass;
		e.style.cssText = mff.str(Style);
		e.style.position = mff.str(PositionType);
		mff.place(e, mff.str(Left), mff.str(Top));
		e.style.width = mff.str(Width);
		e.style.height = mff.str(Height);
		e.style.right = mff.str(Right);
		e.style.bottom = mff.str(Bottom);
		e.style.boxSizing = "border-box";
		var parent = Parent ? (mff.el(String(Parent) + "Client") || mff.el(Parent)) : null;
		(parent || document.body).insertAdjacentElement(mff.str(AddPosition) || "beforeend", e);
		if (e.style.position == "relative") mff.fitMainForm(e, Id);
		if (strClass.indexOf("vetdialog box") >= 0) {
			var header = mff.el(String(Id) + "Header");
			if (header && typeof dragElement === "function") dragElement(header, e);
			var close = mff.el(String(Id) + "CloseButton");
			if (close) close.onclick = function() { mff.call("ONCLOSE", [Id]); };
		}
	},

	DELETEELEMENT__deps: ['$mff'],
	DELETEELEMENT: function(Id) {
		var e = mff.el(Id);
		if (e && e.parentNode) e.parentNode.removeChild(e);
	},

	ELEMENTSETBOUNDS__deps: ['$mff'],
	ELEMENTSETBOUNDS: function(Id, Left, Top, Width, Height) {
		var e = mff.el(Id);
		if (!e) return;
		mff.place(e, Left + "px", Top + "px");
		e.style.width = Width + "px";
		e.style.height = Height + "px";
	},

	SETVISIBLE__deps: ['$mff'],
	SETVISIBLE: function(Id, value) {
		var e = mff.el(Id);
		if (e) e.style.display = value ? "" : "none";
	},

	SETVISIBLEBYSTRINGID__deps: ['$mff'],
	SETVISIBLEBYSTRINGID: function(Id, value) {
		var e = mff.el(mff.str(Id));
		if (e) e.style.display = value ? "" : "none";
	},

	ELEMENTSETENABLED__deps: ['$mff'],
	ELEMENTSETENABLED: function(Id, value) {
		var e = mff.el(Id);
		if (e) e.disabled = !value;
	},

	ELEMENTSETFOCUS__deps: ['$mff'],
	ELEMENTSETFOCUS: function(Id) {
		var e = mff.el(Id);
		if (e && e.focus) e.focus();
	},

	GETSTRINGVALUE__deps: ['$mff'],
	GETSTRINGVALUE: function(Id) {
		var e = mff.el(Id);
		return stringToNewUTF8(e ? (e.value !== undefined ? e.value : e.textContent) : "");
	},

	SETSTRINGVALUE__deps: ['$mff'],
	SETSTRINGVALUE: function(Id, Value) {
		var e = mff.el(Id);
		if (e) e.value = mff.str(Value);
	},

	SETINNERTEXT__deps: ['$mff'],
	SETINNERTEXT: function(Id, Value) {
		var e = mff.el(Id);
		if (e) e.textContent = mff.str(Value);
	},

	SETINNERTEXTBYSTRINGID__deps: ['$mff'],
	SETINNERTEXTBYSTRINGID: function(Id, Value) {
		var e = mff.el(mff.str(Id));
		if (e) e.textContent = mff.str(Value);
	},

	SETBACKCOLOR__deps: ['$mff'],
	SETBACKCOLOR: function(Id, Value) {
		var e = mff.el(Id);
		if (e) e.style.backgroundColor = mff.color(Value);
	},

	SETFORECOLOR__deps: ['$mff'],
	SETFORECOLOR: function(Id, Value) {
		var e = mff.el(Id);
		if (e) e.style.color = mff.color(Value);
	},

	SETFONT__deps: ['$mff'],
	SETFONT: function(Id, Value) {
		var e = mff.el(Id);
		if (e) e.style.font = mff.str(Value);
	},

	SETMULTIPLE__deps: ['$mff'],
	SETMULTIPLE: function(Id, Value) {
		var e = mff.el(Id);
		if (e) e.multiple = !!Value;
	},

	SETSIZE__deps: ['$mff'],
	SETSIZE: function(Id, Value) {
		var e = mff.el(Id);
		if (e) e.size = Value;
	},

	// The list functions work with a <select> (ComboBoxEdit, ListControl) and with an element whose items are
	// <label class="mffitem"><input type="checkbox">Text</label> (CheckedListBox, data-check="radio" for radio buttons)
	GETSELECTEDINDEX__deps: ['$mff'],
	GETSELECTEDINDEX: function(Id) {
		var e = mff.el(Id);
		if (!e) return -1;
		if (e.tagName != "SELECT") return e.hasAttribute("data-position") ? Number(e.getAttribute("data-position")) | 0 : -1;
		return e.selectedIndex;
	},

	SETSELECTEDINDEX__deps: ['$mff'],
	SETSELECTEDINDEX: function(Id, Value) {
		var e = mff.el(Id);
		if (!e) return;
		if (e.tagName != "SELECT") e.setAttribute("data-position", Value);
		else e.selectedIndex = Value;
	},

	ADDSELECTITEM__deps: ['$mff'],
	ADDSELECTITEM: function(Id, Text) {
		var e = mff.el(Id);
		if (e) e.insertBefore(mff.item(e, mff.str(Text)), null);
	},

	INSERTSELECTITEM__deps: ['$mff'],
	INSERTSELECTITEM: function(Id, Index, Text) {
		var e = mff.el(Id);
		if (e) e.insertBefore(mff.item(e, mff.str(Text)), mff.items(e)[Index] || null);
	},

	REMOVESELECTITEM__deps: ['$mff'],
	REMOVESELECTITEM: function(Id, Index) {
		var e = mff.el(Id);
		if (!e) return;
		var items = mff.items(e);
		if (Index >= 0 && Index < items.length) e.removeChild(items[Index]);
	},

	CLEARSELECTITEMS__deps: ['$mff'],
	CLEARSELECTITEMS: function(Id) {
		var e = mff.el(Id);
		if (!e) return;
		var items = mff.items(e);
		for (var i = items.length - 1; i >= 0; i--) e.removeChild(items[i]);
	},

	ADDCOLUMN__deps: ['$mff'],
	ADDCOLUMN: function(Id, Caption) {
		var e = document.querySelector("table[id='" + Id + "'] thead tr");
		if (!e) return;
		var th = document.createElement("th");
		th.style.cssText = "background: #ccc; padding: 5px; border: 1px solid black;";
		th.innerHTML = mff.str(Caption);
		e.insertAdjacentElement("beforeend", th);
	},

	ADDROW__deps: ['$mff'],
	ADDROW: function(Id, Text) {
		var e = document.querySelector("table[id='" + Id + "'] tbody");
		if (!e) return;
		var tr = document.createElement("tr");
		tr.innerHTML = mff.str(Text);
		e.insertAdjacentElement("beforeend", tr);
	},

	// ---- Table view (ListView, TreeListView, GridData): a <table> with a header row and a row per item.
	// The cells are separated by "\t", the column captions by "\n". A click on a row selects it
	// (data-position) and raises the change event; data-event is "click" or "dblclick".
	TABLEINIT__deps: ['$mff'],
	TABLEINIT: function(Id) {
		var e = mff.el(Id);
		if (!e || e.getAttribute("data-table")) return;
		e.setAttribute("data-table", "1");
		e.setAttribute("data-position", "-1");
		e.style.borderCollapse = "collapse";
		e.style.display = "block";
		e.style.overflow = "auto";
		e.innerHTML = "<thead><tr></tr></thead><tbody></tbody>";
		function row(ev) {
			var tr = ev.target && ev.target.closest ? ev.target.closest("tbody > tr") : null;
			return tr && e.contains(tr) ? Array.prototype.indexOf.call(tr.parentNode.children, tr) : -1;
		}
		e.addEventListener("click", function(ev) {
			var i = row(ev);
			if (i < 0) return;
			mff.tableSelect(e, i);
			e.setAttribute("data-event", "click");
			mff.call("ONCHANGE", [Id]);
		});
		e.addEventListener("dblclick", function(ev) {
			var i = row(ev);
			if (i < 0) return;
			e.setAttribute("data-event", "dblclick");
			mff.call("ONCHANGE", [Id]);
		});
	},

	TABLESETCOLUMNS__deps: ['$mff'],
	TABLESETCOLUMNS: function(Id, Captions, Widths) {
		var e = mff.el(Id);
		if (!e || !e.tHead) return;
		var tr = e.tHead.rows[0];
		tr.innerHTML = "";
		var c = mff.str(Captions), w = mff.str(Widths).split("\n");
		if (c == "") return;
		c.split("\n").forEach(function(text, i) {
			var th = document.createElement("th");
			th.textContent = text;
			th.style.cssText = "position: sticky; top: 0; background: #e8e8e8; border: 1px solid #bbb; padding: 2px 4px; text-align: left; white-space: nowrap; font-weight: normal;";
			if (w[i] && Number(w[i]) > 0) th.style.minWidth = w[i] + "px";
			tr.appendChild(th);
		});
	},

	TABLEINSERTROW__deps: ['$mff'],
	TABLEINSERTROW: function(Id, Index, Cells) {
		var e = mff.el(Id);
		if (!e || !e.tBodies.length) return;
		var b = e.tBodies[0];
		var tr = document.createElement("tr");
		mff.tableFill(tr, mff.str(Cells));
		b.insertBefore(tr, Index >= 0 ? b.rows[Index] || null : null);
		var p = Number(e.getAttribute("data-position"));
		if (Index >= 0 && p >= Index) e.setAttribute("data-position", p + 1);
	},

	TABLESETROW__deps: ['$mff'],
	TABLESETROW: function(Id, Index, Cells) {
		var e = mff.el(Id);
		if (e && e.tBodies.length && e.tBodies[0].rows[Index]) mff.tableFill(e.tBodies[0].rows[Index], mff.str(Cells));
	},

	TABLEREMOVEROW__deps: ['$mff'],
	TABLEREMOVEROW: function(Id, Index) {
		var e = mff.el(Id);
		if (!e || !e.tBodies.length || !e.tBodies[0].rows[Index]) return;
		e.tBodies[0].deleteRow(Index);
		var p = Number(e.getAttribute("data-position"));
		if (p == Index) e.setAttribute("data-position", "-1");
		else if (p > Index) e.setAttribute("data-position", p - 1);
	},

	TABLECLEAR__deps: ['$mff'],
	TABLECLEAR: function(Id) {
		var e = mff.el(Id);
		if (e && e.tBodies.length) e.tBodies[0].innerHTML = "";
		if (e) e.setAttribute("data-position", "-1");
	},

	TABLESETINDEX__deps: ['$mff'],
	TABLESETINDEX: function(Id, Index) {
		var e = mff.el(Id);
		if (e && e.tBodies.length) mff.tableSelect(e, Index);
	},

	GETCHECKED__deps: ['$mff'],
	GETCHECKED: function(Id) {
		var e = mff.el(mff.str(Id));
		return e && e.checked ? 1 : 0;
	},

	SETCHECKED__deps: ['$mff'],
	SETCHECKED: function(Id, Value) {
		var e = mff.el(mff.str(Id));
		if (e) e.checked = !!Value;
	},

	SETATTRIBUTE__deps: ['$mff'],
	SETATTRIBUTE: function(Id, Name, Value) {
		var e = mff.el(Id);
		if (!e) return;
		var name = mff.str(Name), value = mff.str(Value);
		if (name == "src" || name == "srcdoc" || name == "href" || name == "placeholder" || name == "title") {
			if (name == "src" && e.hasAttribute("srcdoc")) e.removeAttribute("srcdoc");
			e.setAttribute(name, value);
		} else if (value == "") {
			e.removeAttribute(name);
		} else {
			e.setAttribute(name, value);
		}
	},

	SETSTYLE__deps: ['$mff'],
	SETSTYLE: function(Id, Name, Value) {
		var e = mff.el(Id);
		if (e) e.style.setProperty(mff.str(Name), mff.str(Value));
	},

	SETINNERHTML__deps: ['$mff'],
	SETINNERHTML: function(Id, Value) {
		var e = mff.el(Id);
		if (e) e.innerHTML = mff.str(Value);
	},

	GETATTRIBUTE__deps: ['$mff'],
	GETATTRIBUTE: function(Id, Name) {
		var e = mff.el(Id);
		var v = e ? e.getAttribute(mff.str(Name)) : null;
		return stringToNewUTF8(v == null ? "" : String(v));
	},

	// LinkLabel: a click on an <a> stores its index and href and raises the change event
	SETLINKEVENT__deps: ['$mff'],
	SETLINKEVENT: function(Id) {
		mff.on(Id, "click", function(ev) {
			var e = mff.el(Id);
			var a = ev.target && ev.target.closest ? ev.target.closest("a") : null;
			if (!a || !e || !e.contains(a)) return;
			ev.preventDefault();
			var links = e.querySelectorAll("a");
			e.setAttribute("data-position", Array.prototype.indexOf.call(links, a));
			e.setAttribute("data-link", a.getAttribute("href") || a.getAttribute("id") || "");
			mff.call("ONCHANGE", [Id]);
		});
	},

	// HotKey: the pressed key with its modifiers replaces the value ("Ctrl+Shift+Alt+F5")
	SETHOTKEYEVENT__deps: ['$mff'],
	SETHOTKEYEVENT: function(Id) {
		mff.on(Id, "keydown", function(ev) {
			if (ev.key == "Tab") return;
			ev.preventDefault();
			var e = mff.el(Id);
			var k = ev.key;
			if (k == "Control" || k == "Shift" || k == "Alt" || k == "Meta") k = "";
			else if (k == " ") k = "Space";
			else if (k.length == 1) k = k.toUpperCase();
			if (k == "Backspace" && !ev.ctrlKey && !ev.shiftKey && !ev.altKey) e.value = "";
			else e.value = (ev.ctrlKey ? "Ctrl+" : "") + (ev.shiftKey ? "Shift+" : "") + (ev.altKey ? "Alt+" : "") + k;
			mff.call("ONCHANGE", [Id]);
		});
	},

	// Splitter: the drag with the mouse or a finger; data-dx/data-dy are the distance from the press
	SETDRAGEVENT__deps: ['$mff'],
	SETDRAGEVENT: function(Id) {
		var e = mff.el(Id);
		if (!e) return;
		var x0 = 0, y0 = 0, down = false;
		function report(state, ev) {
			e.setAttribute("data-drag", state);
			e.setAttribute("data-dx", Math.round(ev.clientX - x0));
			e.setAttribute("data-dy", Math.round(ev.clientY - y0));
			mff.call("ONCHANGE", [Id]);
		}
		e.addEventListener("pointerdown", function(ev) {
			down = true; x0 = ev.clientX; y0 = ev.clientY;
			if (e.setPointerCapture) e.setPointerCapture(ev.pointerId);
			ev.preventDefault();
			report(1, ev);
		});
		e.addEventListener("pointermove", function(ev) { if (down) report(2, ev); });
		function up(ev) {
			if (!down) return;
			down = false;
			report(3, ev);
		}
		e.addEventListener("pointerup", up);
		e.addEventListener("pointercancel", up);
	},

	OPENURL__deps: ['$mff'],
	OPENURL: function(URL) {
		window.open(mff.str(URL), "_blank");
	},

	// Range controls: <progress>, <input type="range">, <input type="number">, tabs (div[data-tabs])
	// <progress> has no min attribute, so the minimum is kept in data-min and subtracted
	SETRANGE__deps: ['$mff'],
	SETRANGE: function(Id, MinValue, MaxValue) {
		var e = mff.el(Id);
		if (!e) return;
		if (e.tagName == "PROGRESS") {
			var pos = Number(e.value) + Number(e.getAttribute("data-min") || 0);
			e.setAttribute("data-min", MinValue);
			e.max = Math.max(1, MaxValue - MinValue);
			e.value = Math.max(0, pos - MinValue);
		} else {
			e.min = MinValue;
			e.max = MaxValue;
		}
	},

	SETPOSITION__deps: ['$mff'],
	SETPOSITION: function(Id, Value) {
		var e = mff.el(Id);
		if (!e) return;
		if (e.tagName == "PROGRESS") {
			e.value = Math.max(0, Value - Number(e.getAttribute("data-min") || 0));
		} else if (e.hasAttribute("data-tabs")) {
			e.setAttribute("data-position", Value);
			var tabs = e.querySelectorAll(":scope > .mfftabs > button");
			for (var i = 0; i < tabs.length; i++) tabs[i].className = (i == Value ? "mfftab selected" : "mfftab");
		} else if (e.hasAttribute("data-position")) {
			e.setAttribute("data-position", Value);
		} else {
			e.value = Value;
		}
	},

	GETPOSITION__deps: ['$mff'],
	GETPOSITION: function(Id) {
		var e = mff.el(Id);
		if (!e) return 0;
		if (e.tagName == "PROGRESS") return Math.round(Number(e.value) + Number(e.getAttribute("data-min") || 0));
		if (e.hasAttribute("data-position")) return Number(e.getAttribute("data-position")) | 0;
		return Math.round(Number(e.value) || 0);
	},

	// Check boxes of a list made of .mffitem labels (CheckedListBox)
	SETITEMCHECKED__deps: ['$mff'],
	SETITEMCHECKED: function(Id, Index, Value) {
		var e = mff.el(Id);
		if (!e) return;
		var items = mff.items(e);
		var box = Index >= 0 && Index < items.length ? items[Index].querySelector("input") : null;
		if (box) box.checked = !!Value;
	},

	GETITEMCHECKED__deps: ['$mff'],
	GETITEMCHECKED: function(Id, Index) {
		var e = mff.el(Id);
		if (!e) return 0;
		var items = mff.items(e);
		var box = Index >= 0 && Index < items.length ? items[Index].querySelector("input") : null;
		return box && box.checked ? 1 : 0;
	},

	// Tab strip of a TabControl: a row of buttons at the top of the element;
	// a click selects the tab and raises the change event of the element
	SETTABS__deps: ['$mff'],
	SETTABS: function(Id, Titles) {
		var e = mff.el(Id);
		if (!e) return;
		e.setAttribute("data-tabs", "1");
		if (!e.hasAttribute("data-position")) e.setAttribute("data-position", "0");
		var strip = e.querySelector(":scope > .mfftabs");
		if (!strip) {
			strip = document.createElement("div");
			strip.className = "mfftabs";
			strip.style.cssText = "position: absolute; left: 0; top: 0; right: 0; height: 26px; display: flex; overflow: hidden; border-bottom: 1px solid #aaa;";
			e.insertAdjacentElement("afterbegin", strip);
		}
		// the pages are in a client element under the strip (CREATEELEMENT puts the children into "<Id>Client"),
		// otherwise a page (alClient) covers the strip and its buttons can not be clicked
		var client = mff.el(String(Id) + "Client");
		if (!client) {
			client = document.createElement("div");
			client.id = String(Id) + "Client";
			client.style.cssText = "position: absolute; left: 0; top: 27px; right: 0; bottom: 0;";
			Array.prototype.slice.call(e.children).forEach(function(c) { if (c !== strip) client.appendChild(c); });
			e.appendChild(client);
		}
		strip.innerHTML = "";
		var titles = mff.str(Titles);
		var list = titles == "" ? [] : titles.split("\n");
		var selected = Number(e.getAttribute("data-position")) | 0;
		list.forEach(function(title, i) {
			var b = document.createElement("button");
			b.type = "button";
			b.className = (i == selected ? "mfftab selected" : "mfftab");
			b.textContent = title;
			b.style.cssText = "margin-right: 2px; border: 1px solid #aaa; border-bottom: none; border-radius: 4px 4px 0 0;";
			b.addEventListener("click", function(ev) {
				ev.stopPropagation();
				e.setAttribute("data-position", i);
				var tabs = strip.querySelectorAll("button");
				for (var j = 0; j < tabs.length; j++) tabs[j].className = (j == i ? "mfftab selected" : "mfftab");
				mff.call("ONCHANGE", [Id]);
			}, false);
			strip.appendChild(b);
		});
	},

	// ToolBar: a row of buttons; the items are separated by "\n", the first char of an item is a flag:
	// "0" - button, "1" - disabled, "2" - checked, "3" - separator, "4" - hidden.
	// A click stores the index of the button in data-position and raises the change event.
	SETBUTTONS__deps: ['$mff'],
	SETBUTTONS: function(Id, Items) {
		var e = mff.el(Id);
		if (!e) return;
		var row = e.querySelector(":scope > .mffbuttons");
		if (!row) {
			row = document.createElement("div");
			row.className = "mffbuttons";
			row.style.cssText = "display: flex; align-items: center; height: 100%; overflow: hidden; gap: 2px; padding: 0 2px;";
			e.insertAdjacentElement("afterbegin", row);
		}
		// a tall element (ToolPalette) shows the buttons in a column
		var column = e.clientHeight > e.clientWidth * 1.5;
		row.style.flexDirection = column ? "column" : "row";
		row.style.alignItems = column ? "stretch" : "center";
		row.style.overflow = "auto";
		row.innerHTML = "";
		var s = mff.str(Items);
		var list = s == "" ? [] : s.split("\n");
		list.forEach(function(item, i) {
			var flag = item.charAt(0), text = item.substring(1);
			var b;
			if (flag == "3") {
				b = document.createElement("span");
				b.style.cssText = column ? "height: 1px; margin: 2px 3px; background: #aaa;" : "width: 1px; align-self: stretch; margin: 3px 2px; background: #aaa;";
			} else {
				b = document.createElement("button");
				b.type = "button";
				b.textContent = text;
				b.disabled = flag == "1";
				b.style.cssText = "white-space: nowrap;" + (flag == "2" ? " border-style: inset;" : "");
				b.addEventListener("click", function(ev) {
					ev.stopPropagation();
					e.setAttribute("data-position", i);
					mff.call("ONCHANGE", [Id]);
				}, false);
			}
			if (flag == "4") b.style.display = "none";
			row.appendChild(b);
		});
	},

	// WebBrowser (iframe): 0 - back, 1 - forward, 2 - reload, 3 - stop; the history of a page
	// from another origin is not accessible, then nothing happens
	WEBACTION__deps: ['$mff'],
	WEBACTION: function(Id, Action) {
		var e = mff.el(Id);
		if (!e || !e.contentWindow) return;
		try {
			var w = e.contentWindow;
			if (Action == 0) w.history.back();
			else if (Action == 1) w.history.forward();
			else if (Action == 2) w.location.reload();
			else if (Action == 3) w.stop();
		} catch (err) {
			if (Action == 2) e.src = e.src;
		}
	},

	// TimerComponent: Id is the address of the TimerComponent, ONTIMER(Id) is exported by Form.bas
	// ---- Canvas (My.Sys.Drawing.Canvas): Id is the element of the control. The path works like the one of cairo:
	// CANVASFILL and CANVASSTROKE keep it, CANVASNEWPATH starts a new one. Colors are BGR (&hBBGGRR).
	CANVASBEGIN__deps: ['$mff'],
	CANVASBEGIN: function(Id) {
		var g = mff.ctx(Id, false);
		if (!g) return;
		g.save();
		g.setTransform(1, 0, 0, 1, 0, 0);
		g.clearRect(0, 0, g.canvas.width, g.canvas.height);
		g.restore();
		g.beginPath();
	},

	CANVASEND: function(Id) {
	},

	CANVASNEWPATH__deps: ['$mff'],
	CANVASNEWPATH: function(Id) {
		var g = mff.ctx(Id, false);
		if (g) g.beginPath();
	},

	CANVASMOVETO__deps: ['$mff'],
	CANVASMOVETO: function(Id, x, y) {
		var g = mff.ctx(Id, true);
		if (g) g.moveTo(x, y);
	},

	CANVASLINETO__deps: ['$mff'],
	CANVASLINETO: function(Id, x, y) {
		var g = mff.ctx(Id, true);
		if (g) g.lineTo(x, y);
	},

	CANVASCURVETO__deps: ['$mff'],
	CANVASCURVETO: function(Id, x1, y1, x2, y2, x3, y3) {
		var g = mff.ctx(Id, true);
		if (g) g.bezierCurveTo(x1, y1, x2, y2, x3, y3);
	},

	CANVASARC__deps: ['$mff'],
	CANVASARC: function(Id, cx, cy, r, a1, a2, Negative) {
		var g = mff.ctx(Id, true);
		if (g) g.arc(cx, cy, Math.max(0, r), a1, a2, !!Negative);
	},

	CANVASRECTPATH__deps: ['$mff'],
	CANVASRECTPATH: function(Id, x, y, w, h) {
		var g = mff.ctx(Id, true);
		if (g) g.rect(x, y, w, h);
	},

	CANVASCLOSEPATH__deps: ['$mff'],
	CANVASCLOSEPATH: function(Id) {
		var g = mff.ctx(Id, false);
		if (g) g.closePath();
	},

	CANVASFILL__deps: ['$mff'],
	CANVASFILL: function(Id, Color, Alpha) {
		var g = mff.ctx(Id, true);
		if (!g) return;
		g.fillStyle = mff.rgba(Color, Alpha);
		g.fill();
	},

	CANVASSTROKE__deps: ['$mff'],
	CANVASSTROKE: function(Id, Color, Alpha, LineWidth, Dash) {
		var g = mff.ctx(Id, true);
		if (!g) return;
		var d = mff.str(Dash);
		g.setLineDash(d == "" ? [] : d.split(",").map(Number));
		g.strokeStyle = mff.rgba(Color, Alpha);
		g.lineWidth = LineWidth > 0 ? LineWidth : 1;
		g.stroke();
	},

	CANVASFILLRECT__deps: ['$mff'],
	CANVASFILLRECT: function(Id, x, y, w, h, Color, Alpha) {
		var g = mff.ctx(Id, true);
		if (!g) return;
		g.fillStyle = mff.rgba(Color, Alpha);
		g.fillRect(x, y, w, h);
	},

	CANVASSAVE__deps: ['$mff'],
	CANVASSAVE: function(Id) {
		var g = mff.ctx(Id, true);
		if (g) g.save();
	},

	CANVASRESTORE__deps: ['$mff'],
	CANVASRESTORE: function(Id) {
		var g = mff.ctx(Id, false);
		if (g) g.restore();
	},

	// The text begins at y (its top) like TextOut of Windows; BkColor -1 is transparent
	CANVASTEXT__deps: ['$mff'],
	CANVASTEXT: function(Id, x, y, Text, Color, BkColor, FontName, FontSize, Bold, Italic) {
		var g = mff.ctx(Id, true);
		if (!g) return;
		var s = mff.str(Text);
		g.font = mff.font(mff.str(FontName), FontSize, Bold, Italic);
		g.textBaseline = "top";
		if (BkColor >= 0) {
			g.fillStyle = mff.rgba(BkColor, 255);
			g.fillRect(x, y, g.measureText(s).width, FontSize * 1.2);
		}
		g.fillStyle = mff.rgba(Color, 255);
		g.fillText(s, x, y);
	},

	CANVASTEXTWIDTH__deps: ['$mff'],
	CANVASTEXTWIDTH: function(Id, Text, FontName, FontSize, Bold, Italic) {
		var g = mff.ctx(Id, false) || (mff.measure = mff.measure || document.createElement("canvas").getContext("2d"));
		g.font = mff.font(mff.str(FontName), FontSize, Bold, Italic);
		return Math.ceil(g.measureText(mff.str(Text)).width);
	},

	CANVASTEXTHEIGHT__deps: ['$mff'],
	CANVASTEXTHEIGHT: function(Id, FontName, FontSize, Bold, Italic) {
		return Math.ceil(FontSize * 1.2);
	},

	// The color (BGR) of a pixel, -1 outside
	CANVASGETPIXEL__deps: ['$mff'],
	CANVASGETPIXEL: function(Id, x, y) {
		var g = mff.ctx(Id, false);
		if (!g) return -1;
		var dpr = window.devicePixelRatio || 1;
		var px = Math.round(x * dpr), py = Math.round(y * dpr);
		if (px < 0 || py < 0 || px >= g.canvas.width || py >= g.canvas.height) return -1;
		var d = g.getImageData(px, py, 1, 1).data;
		return d[0] | (d[1] << 8) | (d[2] << 16);
	},

	// A picture file (URL); Width/Height -1 is the size of the picture. A picture which is not loaded yet
	// repaints the control when it is loaded.
	CANVASIMAGE__deps: ['$mff'],
	CANVASIMAGE: function(Id, Path, x, y, w, h, Alpha) {
		var g = mff.ctx(Id, true);
		if (!g) return;
		var img = mff.image(mff.str(Path), Id);
		if (!img.complete || !img.naturalWidth) return;
		g.save();
		g.globalAlpha = Alpha / 255;
		g.drawImage(img, x, y, w < 0 ? img.naturalWidth : w, h < 0 ? img.naturalHeight : h);
		g.restore();
	},

	STARTTIMER__deps: ['$mff'],
	STARTTIMER: function(Id, Interval) {
		mff.timers = mff.timers || {};
		if (mff.timers[Id]) clearInterval(mff.timers[Id]);
		mff.timers[Id] = setInterval(function() { mff.call("ONTIMER", [Id]); }, Math.max(1, Interval));
	},

	STOPTIMER__deps: ['$mff'],
	STOPTIMER: function(Id) {
		if (mff.timers && mff.timers[Id]) {
			clearInterval(mff.timers[Id]);
			delete mff.timers[Id];
		}
	},

	MESSAGEBOX__deps: ['$mff'],
	MESSAGEBOX: function(Message, Caption, MessageType, ButtonsType) {
		var msg = mff.str(Message), ttl = mff.str(Caption);
		if (typeof mymod !== "undefined" && mymod.dialog) {
			// MessageType: MB_ICONERROR = 16, MB_ICONQUESTION = 32, MB_ICONWARNING = 48, MB_ICONINFORMATION = 64
			var style = { 16: "error", 32: "question", 48: "warning", 64: "info" }[MessageType & 0xF0] || "none";
			// ButtonsType: MB_OK = 0, MB_OKCANCEL = 1
			var buttons = (ButtonsType & 0x0F) == 1 ? "okcancel" : "ok";
			mymod.dialog.msgBoxShow(mymod.dialog.msgBoxGet(ttl, msg, { dlgStyle: style, dlgButtons: buttons }));
		} else {
			alert((ttl ? ttl + "\n\n" : "") + msg);
		}
		return 1;
	},

	SENDHTTPREQUEST__deps: ['$mff'],
	SENDHTTPREQUEST: function(url, method, data) {
		var xhr = new XMLHttpRequest();
		var result;
		try {
			xhr.open(mff.str(method), mff.str(url), false);
			xhr.setRequestHeader("Content-Type", "application/text");
			xhr.send(mff.str(data));
			result = xhr.status + ":" + ((xhr.status >= 200 && xhr.status < 300) ? xhr.responseText : xhr.statusText);
		} catch (err) {
			result = "0:" + err;
		}
		return stringToNewUTF8(result);
	},

	// ---- events -------------------------------------------------------------

	SETLOADEVENT__deps: ['$mff'],
	SETLOADEVENT: function(Id) {
		// a div has no load event: fire once the element is in the DOM
		setTimeout(function() { mff.call("ONLOAD", [Id]); }, 0);
	},

	SETCHANGEEVENT__deps: ['$mff'],
	SETCHANGEEVENT: function(Id) {
		var e = mff.el(Id);
		if (!e) return;
		var tag = e.tagName;
		var ev = (tag == "INPUT" && (e.type == "text" || e.type == "password" || e.type == "search" || e.type == "range" || e.type == "number")) || tag == "TEXTAREA" || e.isContentEditable ? "input" : "change";
		// change/input events bubble: a control handles the events of its own inner elements
		// (the check box of a CheckBox), but not those of its child controls
		e.setAttribute("data-mffchange", "1");
		mff.on(Id, ev, function(evt) {
			var owner = evt.target && evt.target.closest ? evt.target.closest("[data-mffchange]") : e;
			if (owner && owner !== e) return;
			// the check box of a list item: remember which item was changed (GetSelectedIndex)
			var item = evt.target && evt.target.closest ? evt.target.closest(".mffitem") : null;
			if (item && item.parentNode === e) e.setAttribute("data-position", Array.prototype.indexOf.call(mff.items(e), item));
			mff.call("ONCHANGE", [Id]);
		});
	},

	SETCLICKEVENT__deps: ['$mff'],
	SETCLICKEVENT: function(Id) {
		mff.on(Id, "click", function(e) { e.stopPropagation(); mff.call("ONCLICK", [Id]); });
	},

	SETDBLCLICKEVENT__deps: ['$mff'],
	SETDBLCLICKEVENT: function(Id) {
		mff.on(Id, "dblclick", function(e) { e.stopPropagation(); mff.call("ONDBLCLICK", [Id]); });
	},

	SETGOTFOCUSEVENT__deps: ['$mff'],
	SETGOTFOCUSEVENT: function(Id) {
		mff.on(Id, "focus", function() { mff.call("ONGOTFOCUS", [Id]); });
	},

	SETLOSTFOCUSEVENT__deps: ['$mff'],
	SETLOSTFOCUSEVENT: function(Id) {
		mff.on(Id, "blur", function() { mff.call("ONLOSTFOCUS", [Id]); });
	},

	SETKEYDOWNEVENT__deps: ['$mff'],
	SETKEYDOWNEVENT: function(Id) {
		mff.on(Id, "keydown", function(e) { mff.call("ONKEYDOWN", [Id, mff.key(e), mff.shift(e)]); });
	},

	SETKEYPRESSEVENT__deps: ['$mff'],
	SETKEYPRESSEVENT: function(Id) {
		mff.on(Id, "keypress", function(e) { mff.call("ONKEYPRESS", [Id, mff.key(e), mff.shift(e)]); });
	},

	SETKEYUPEVENT__deps: ['$mff'],
	SETKEYUPEVENT: function(Id) {
		mff.on(Id, "keyup", function(e) { mff.call("ONKEYUP", [Id, mff.key(e), mff.shift(e)]); });
	},

	SETMOUSEENTEREVENT__deps: ['$mff'],
	SETMOUSEENTEREVENT: function(Id) {
		mff.on(Id, "mouseenter", function() { mff.call("ONMOUSEENTER", [Id]); });
	},

	SETMOUSEDOWNEVENT__deps: ['$mff'],
	SETMOUSEDOWNEVENT: function(Id) {
		mff.on(Id, "mousedown", function(e) { mff.call("ONMOUSEDOWN", [Id, e.button, e.offsetX, e.offsetY, mff.shift(e)]); });
	},

	SETMOUSEMOVEEVENT__deps: ['$mff'],
	SETMOUSEMOVEEVENT: function(Id) {
		mff.on(Id, "mousemove", function(e) { mff.call("ONMOUSEMOVE", [Id, e.buttons, e.offsetX, e.offsetY, mff.shift(e)]); });
	},

	SETMOUSEUPEVENT__deps: ['$mff'],
	SETMOUSEUPEVENT: function(Id) {
		mff.on(Id, "mouseup", function(e) { mff.call("ONMOUSEUP", [Id, e.button, e.offsetX, e.offsetY, mff.shift(e)]); });
	},

	SETMOUSELEAVEEVENT__deps: ['$mff'],
	SETMOUSELEAVEEVENT: function(Id) {
		mff.on(Id, "mouseleave", function() { mff.call("ONMOUSELEAVE", [Id]); });
	},

	SETMOUSEWHEELEVENT__deps: ['$mff'],
	SETMOUSEWHEELEVENT: function(Id) {
		mff.on(Id, "wheel", function(e) { mff.call("ONMOUSEWHEEL", [Id, e.deltaY < 0 ? 1 : -1, e.offsetX, e.offsetY, mff.shift(e)]); });
	},

	SETUNLOADEVENT__deps: ['$mff'],
	SETUNLOADEVENT: function(Id) {
		window.addEventListener("unload", function() { mff.call("ONUNLOAD", [Id]); });
	}
};

mergeInto(LibraryManager.library, MffLibrary);
