// mff_lib.js - MyFbFramework Web (WASM) bridge.
// Linked with: emcc ... --js-library mff_lib.js
// Every function here is imported by the FreeBASIC side (see Declare list in SysUtils.bi under __USE_WASM__).
// FreeBASIC "String" parameters arrive as a pointer to the string descriptor (first field = data pointer),
// numeric parameters arrive as numbers, "Any Ptr" ids are control pointers used as DOM element ids.

var MffLibrary = {
	$mff__deps: ['$UTF8ToString', '$stringToNewUTF8', '$Asyncify'],
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
		// ASYNCIFY can wait (unwind the stack of the program) only when no other wait runs and the program was called
		// by the page once: an event raised by the program itself (focus() of SetFocus gives ONGOTFOCUS at once) has
		// the frames of the browser between the two calls, they can not be unwound (the data of the program would be
		// broken). In the Normal state only: in a rewind the waiting function must go to handleSleep
		cannotWait: function() {
			return !!Asyncify.currData || Asyncify.exportCallStack.length > 1;
		},
		call: function(name, args) {
			var f = Module["_" + name];
			if (f) return f.apply(null, args);
		},
		// An event of the control itself: like Windows, a click or the mouse in a child control (an element with the id
		// of a control, the address) is not the one of its parent also when the child has no such event (a double click
		// in a tree view is not the one of the TabControl of its page, which collapses the panel of the IDE; a press in
		// the list of IntelliSense does not move the caret of the editor)
		ownEvent: function(e) {
			// the path of the event at its dispatch: a handler of the child can have removed the target (a tree view
			// draws its rows again), then parentElement does not go up to the child control any more
			var path = e.composedPath ? e.composedPath() : [];
			if (path.length) {
				for (var i = 0; i < path.length && path[i] !== e.currentTarget; i++) {
					if (/^\d+$/.test(path[i].id || "")) return false;
				}
				return true;
			}
			for (var x = e.target; x && x !== e.currentTarget; x = x.parentElement) {
				if (/^\d+$/.test(x.id)) return false;
			}
			return true;
		},
		// preventDefault of a key event: the one of the event (a text box of the page disables it for the keyboard of the
		// console of FreeBASIC, mff.js)
		prevent: function(e) {
			(e.mffPreventDefault || e.preventDefault).call(e);
		},
		shift: function(e) {
			return (e.shiftKey ? 1 : 0) | (e.ctrlKey ? 2 : 0) | (e.altKey ? 4 : 0);
		},
		key: function(e) {
			if (e.keyCode) return e.keyCode;
			return e.key && e.key.length === 1 ? e.key.charCodeAt(0) : 0;
		},
		// The keys of the page for the forms (mff.keys, once): the hot keys of the menus (ONSHORTCUT of Form.bas) before
		// the focused control like the accelerators of Windows, not while a modal form or a popup menu waits (one wait at
		// a time), in a text box only the keys with Ctrl or Alt and the function keys (the others are typed); Enter and
		// Escape in a text box or a list after the control (ONDIALOGKEY): the DefaultButton, CancelButton of its form.
		// The item or the button is clicked after the event: its click can wait (ShowModal)
		keys: function() {
			if (mff.keysOn) return;
			mff.keysOn = true;
			var control = function(x) {
				while (x && !/^\d+$/.test(x.id || "")) x = x.parentElement;
				return x ? Number(x.id) : 0;
			};
			window.addEventListener("keydown", function(e) {
				if (mff.modalWait || Asyncify.currData) return;
				var key = mff.key(e), shift = mff.shift(e);
				if (!key || key == 16 || key == 17 || key == 18) return;
				var a = document.activeElement, typing = a && (a.isContentEditable || /^(INPUT|TEXTAREA|SELECT)$/.test(a.tagName));
				if (typing && !(shift & 6) && !(key >= 112 && key <= 135)) return;
				// the keys of the editing of a text box (Ctrl+C, Ctrl+V, Ctrl+A, Ctrl+Z, Ctrl+arrows...) are its own
				if (typing && (shift & 2) && !(shift & 4) && [8, 35, 36, 37, 38, 39, 40, 45, 46, 65, 67, 86, 88, 89, 90].indexOf(key) >= 0) return;
				var item = mff.call("ONSHORTCUT", [control(a), key, shift]);
				if (!item) return;
				e.preventDefault();
				e.stopPropagation();
				setTimeout(function() { mff.call("ONSHORTCUTCLICK", [item]); }, 0);
			}, true);
			window.addEventListener("keydown", function(e) {
				if (e.defaultPrevented || (e.key != "Enter" && e.key != "Escape") || e.shiftKey || e.ctrlKey || e.altKey) return;
				var a = e.target;
				if (!a || !(a.tagName == "SELECT" || (a.tagName == "INPUT" && !/^(button|submit|reset|checkbox|radio|file)$/.test(a.type)))) return;
				var btn = mff.call("ONDIALOGKEY", [control(a), e.key == "Enter" ? 13 : 27]);
				if (!btn) return;
				e.preventDefault();
				setTimeout(function() { mff.call("ONCLICK", [btn]); }, 0);
			});
			// The right button: the ContextMenu of the control or of its parent (ONCONTEXTMENU) instead of the menu of the
			// browser, shown after the event at the place of the mouse (it waits for the item)
			window.addEventListener("contextmenu", function(e) {
				if (mff.modalWait || Asyncify.currData) return;
				var c = mff.call("ONCONTEXTMENU", [control(e.target)]);
				if (!c) return;
				e.preventDefault();
				var x = Math.round(e.clientX), y = Math.round(e.clientY);
				setTimeout(function() { mff.call("ONCONTEXTMENUPOPUP", [c, x, y]); }, 0);
			});
		},
		// The element of the items: a ComboBoxEdit with an edit box is an <input> with a <datalist> of its items (made
		// for the first item), the other lists have their items in the element
		list: function(e) {
			if (!e || e.tagName != "INPUT") return e;
			var l = e.list;
			if (!l) {
				l = document.createElement("datalist");
				l.id = e.id + "List";
				document.body.appendChild(l);
				e.setAttribute("list", l.id);
				// the arrow (.mffcombo of mff.html) shows the list like the one of Windows
				e.addEventListener("mousedown", function(ev) {
					if (ev.button != 0 || ev.offsetX < e.clientWidth - 18 || e.disabled || e.readOnly) return;
					ev.preventDefault();
					e.focus();
					try { e.showPicker(); } catch (err) {}
				});
			}
			return l;
		},
		// the items of a list: the options of a <select> or the .mffitem labels
		items: function(e) {
			return e.tagName == "SELECT" || e.tagName == "DATALIST" ? e.options : e.querySelectorAll(":scope > .mffitem");
		},
		item: function(e, text) {
			if (e.tagName == "SELECT") {
				var o = document.createElement("option");
				o.textContent = text;
				return o;
			}
			if (e.tagName == "DATALIST") {
				var d = document.createElement("option");
				d.value = text;
				return d;
			}
			// like on Windows a click on the text selects the item (its text is highlighted, .mffselected of mff.html),
			// a click on the check box changes it too
			var l = document.createElement("div");
			l.className = "mffitem";
			l.style.cssText = "display: block; white-space: nowrap;";
			var c = document.createElement("input");
			c.type = e.getAttribute("data-check") || "checkbox";
			if (c.type == "radio") c.name = String(e.id);
			l.appendChild(c);
			var t = document.createElement("span");
			t.className = "mffnodetext";
			t.textContent = text;
			l.appendChild(t);
			mff.listInit(e);
			return l;
		},
		// the items of the list (also the ones of the HTML of CheckedListBox.GetContent) are selected by the mouse
		listInit: function(e) {
			if (e.mffListInit) return;
			e.mffListInit = true;
			e.addEventListener("mousedown", function(ev) {
				var l = ev.target && ev.target.closest ? ev.target.closest(".mffitem") : null;
				if (!l || l.parentNode !== e) return;
				var index = Array.prototype.indexOf.call(mff.items(e), l);
				var old = e.hasAttribute("data-position") ? Number(e.getAttribute("data-position")) : -1;
				mff.listSelect(e, index);
				if (index != old && e.hasAttribute("data-mffchange")) mff.call("ONCHANGE", [e.id]);
			});
		},
		// The first of the URLs which the browser loads (the folders of FindResourceFile): the URL, "" when none loads, the
		// callbacks while the URLs are tried. One probe for all the items with the same picture (a list of keywords asked for
		// one file dozens of times at once, a failed request of them took the picture of all). Not mff.images: the pictures
		// of the canvas (mff.image) are there under their path, which is the key of one URL
		imageURLs: {},
		findImage: function(sources, done) {
			var key = sources.join("|"), url = mff.imageURLs[key];
			if (typeof url == "string") { if (url) done(url); return; }
			if (url) { url.push(done); return; }
			var waiting = mff.imageURLs[key] = [done], i = 0, img = new Image();
			img.onload = function() {
				mff.imageURLs[key] = sources[i];
				waiting.forEach(function(f) { f(sources[i]); });
			};
			img.onerror = function() { i++; if (i < sources.length) img.src = sources[i]; else mff.imageURLs[key] = ""; };
			img.src = sources[0];
		},
		// A <select> with pictures (SETSELECTITEMIMAGE): the picture of the selected item is its background
		comboFace: function(e) {
			var o = e.options[e.selectedIndex], url = o ? o.getAttribute("data-img") : null;
			// a list box (size) shows the pictures of its options, not the one of the selected item
			if (e.size > 1) url = null;
			if (url) {
				e.style.backgroundImage = "url(\"" + url + "\")";
				e.style.backgroundRepeat = "no-repeat";
				e.style.backgroundPosition = "3px center";
				e.style.backgroundSize = "16px 16px";
				e.style.paddingLeft = "21px";
			} else {
				e.style.backgroundImage = "";
				e.style.paddingLeft = "";
			}
		},
		comboInit: function(e) {
			if (e.mffImages) return;
			e.mffImages = true;
			e.addEventListener("change", function() { mff.comboFace(e); });
			// ComboBoxEdit.ShowDropDown opens and closes the list by the size attribute
			new MutationObserver(function() { mff.comboFace(e); }).observe(e, {attributes: true, attributeFilter: ["size"]});
			// the closed list opens its own list of the items with their pictures
			e.addEventListener("mousedown", function(ev) {
				if (e.size > 1 || e.disabled || ev.button != 0) return;
				ev.preventDefault();
				e.focus({preventScroll: true});
				mff.comboPopup(e);
			});
		},
		comboPopup: function(e) {
			if (mff.comboList) { var old = mff.comboList; mff.comboList = null; old.remove(); if (old.mffOwner === e) return; }
			var r = e.getBoundingClientRect(), list = document.createElement("div");
			list.className = "mffcombolist";
			list.mffOwner = e;
			list.style.left = r.left + "px";
			list.style.minWidth = r.width + "px";
			var close = function() {
				if (mff.comboList !== list) return;
				mff.comboList = null;
				list.remove();
				document.removeEventListener("mousedown", outside, true);
			};
			var outside = function(ev) { if (!list.contains(ev.target) && ev.target !== e) close(); };
			Array.prototype.forEach.call(e.options, function(o) {
				var item = document.createElement("div");
				item.className = "mffcomboitem" + (o.index == e.selectedIndex ? " mffselected" : "");
				item.style.paddingLeft = ((o.mffIndent || 0) * 10 + 2) + "px";
				var url = o.getAttribute("data-img");
				var img = document.createElement("span");
				img.className = "mffcomboimage";
				if (url) img.style.backgroundImage = "url(\"" + url + "\")";
				item.appendChild(img);
				item.appendChild(document.createTextNode(o.text));
				item.addEventListener("mouseenter", function() {
					var s = list.querySelector(".mffselected");
					if (s) s.classList.remove("mffselected");
					item.classList.add("mffselected");
				});
				item.addEventListener("mousedown", function(ev) { ev.preventDefault(); });
				item.addEventListener("click", function() {
					close();
					if (e.selectedIndex != o.index) {
						e.selectedIndex = o.index;
						e.dispatchEvent(new Event("change", {bubbles: true}));
					}
				});
				list.appendChild(item);
			});
			document.body.appendChild(list);
			// under the list, above it when there is no place under it
			var h = list.offsetHeight;
			list.style.top = (r.bottom + h <= window.innerHeight || r.top < h ? r.bottom : r.top - h) + "px";
			var sel = list.querySelector(".mffselected");
			if (sel) sel.scrollIntoView({block: "nearest"});
			mff.comboList = list;
			document.addEventListener("mousedown", outside, true);
			e.addEventListener("blur", close, {once: true});
		},
		listSelect: function(e, index) {
			var items = mff.items(e);
			for (var i = 0; i < items.length; i++) items[i].classList.toggle("mffselected", i == index);
			e.setAttribute("data-position", index);
		},
		tableFill: function(tr, cells, table) {
			tr.innerHTML = "";
			cells.split("\t").forEach(function(text, i) {
				var td = document.createElement("td"), img = null, lines = null;
				// the first cell of a TreeView: "\x02Lines\x02..." - the dotted lines of the tree (TreeView.AddRows): a
				// character a level, "1" the line of the level goes on, "0" not; the last one is the line of the node:
				// "T" a node with nodes after it, "L" the last node, "F" the first root, "N" the only root
				if (i == 0 && text.charAt(0) == "\x02") {
					var endLines = text.indexOf("\x02", 1);
					if (endLines > 0) {
						lines = text.substring(1, endLines);
						text = text.substring(endLines + 1);
					}
				}
				// the first cell: "\x01Path\x01Text" - the picture of the item (ListView.RowCells, TreeView.AddRows), the
				// size is the one of the view (TABLESETVIEW, .mfftable of mff.html); the URLs separated by "|" are tried
				// one after another (FindResourceFile)
				if (i == 0 && text.charAt(0) == "\x01") {
					var end = text.indexOf("\x01", 1);
					if (end > 0) {
						var sources = text.substring(1, end).split("|");
						img = document.createElement("img");
						img.className = "mffitemimage";
						img.src = sources.shift();
						img.alt = "";
						img.addEventListener("error", function() { if (sources.length) img.src = sources.shift(); else img.style.visibility = "hidden"; });
						text = text.substring(end + 1);
					}
				}
				td.style.cssText = "border-right: 1px solid var(--mff-line, #ddd); border-bottom: 1px solid var(--mff-line, #ddd); padding: 1px 4px; white-space: nowrap;";
				// the first cell of a tree (TreeView.AddRows, TreeListView.RowCells): "Spaces[Sign ]Text", 4 spaces a
				// level, the sign of a node with children (\u25BC open, \u25BA closed), 2 spaces without children. The
				// level is the indent (the browser does not show the spaces), the sign opens and closes the node with
				// one click (data-event "toggle", TABLEINIT)
				var m = i == 0 ? /^( *)([\u25BC\u25BA] )?/.exec(text) : null;
				if (m && (m[1].length >= 2 || m[2])) {
					var level = Math.floor(m[1].length / 4);
					td.style.paddingLeft = (4 + level * 16) + "px";
					var sign = document.createElement("span");
					// the chevron of Windows (.mfftoggle of mff.html): data-state "open" or "closed", none without children
					sign.className = "mfftoggle";
					if (m[2]) sign.setAttribute("data-state", m[2].charAt(0) == "\u25BC" ? "open" : "closed");
					td.appendChild(sign);
					text = text.substring(m[0].length).replace(/^ +/, "");
					if (lines) mff.treeLines(td, lines, m[2] ? m[2].charAt(0) : "");
				}
				// the picture is after the sign of the node; the text of a node is in its own element: like on Windows
				// only the text of the selected node of a tree is highlighted, not its sign (.mffnode of mff.html); in a
				// TreeView (table.mfftree) the picture is in this element and is highlighted with the text in one box like
				// the Explorer theme of Windows, the row of a list is highlighted with its picture
				var node = i == 0 && m && (m[1].length >= 2 || m[2]), tree = table && table.classList.contains("mfftree");
				if (img && !(node && tree)) td.appendChild(img);
				if (node) {
					td.classList.add("mffnode");
					var span = document.createElement("span");
					span.className = "mffnodetext";
					if (img && tree) span.appendChild(img);
					span.appendChild(document.createTextNode(text));
					td.appendChild(span);
				} else td.appendChild(document.createTextNode(text));
				tr.appendChild(td);
			});
			// data-colorcolumn of the table (the Properties of the IDE): the value of a row whose name ends with "Color"
			// is shown with a square of this color before it (BGR of Windows, -1 the default color)
			var c = table ? table.getAttribute("data-colorcolumn") : null;
			if (c != null && tr.cells[c] && /color$/i.test(tr.cells[0].textContent.trim())) {
				var v = parseInt(tr.cells[c].textContent, 10);
				if (!isNaN(v)) {
					var sq = document.createElement("span");
					sq.style.cssText = "display: inline-block; width: 10px; height: 10px; border: 1px solid #000; margin: 0 3px 0 -1px; vertical-align: -1px; background: " +
						(v < 0 ? "#fff" : "rgb(" + (v & 255) + "," + ((v >> 8) & 255) + "," + ((v >> 16) & 255) + ")") + ";";
					tr.cells[c].insertBefore(sq, tr.cells[c].firstChild);
				}
			}
		},
		// The dotted lines of a node of a tree (.mfftreeline of mff.html): the levels are 16 pixels after the 4 of the
		// padding, a line is in the middle of the sign of its level; the line of the nodes of an open node begins under
		// its picture (16 pixels in the middle of the row). Like TVS_HASLINES with TVS_HASBUTTONS of Windows the lines
		// stop at the sign of a node with nodes (sign "▼" open, "►" closed, "" none): 12 pixels around the chevron in the
		// middle of the row are free, a short line goes on from the chevron to the picture
		treeLines: function(td, lines, sign) {
			td.style.position = "relative";
			var n = lines.length - 1, gap = "calc(50% + 6px)";
			// a vertical line from top to bottom, a horizontal one (width) in the middle of the row
			function line(x, top, bottom, width) {
				var l = document.createElement("span");
				l.className = width ? "mfftreeline mfftreelineh" : "mfftreeline";
				l.style.left = x + "px";
				if (width) { l.style.top = "50%"; l.style.width = width + "px"; }
				else { l.style.top = top; l.style.bottom = bottom; }
				td.insertBefore(l, td.firstChild);
			}
			for (var k = 0; k < n; k++) if (lines.charAt(k) == "1") line(4 + k * 16 + 8, "0", "0");
			var x = 4 + n * 16 + 8, c = lines.charAt(n);
			if (sign) {
				if (c == "T" || c == "L") line(x, "0", gap);
				if (c == "T" || c == "F") line(x, gap, "0");
				line(x + 6, 0, 0, 3);
			} else {
				if (c == "T") line(x, "0", "0");
				else if (c == "L") line(x, "0", "50%");
				else if (c == "F") line(x, "50%", "0");
				line(x, 0, 0, 9);
			}
			if (sign == "▼") line(x + 16, "calc(50% + 8px)", "0");
		},
		tableSelect: function(e, index) {
			var rows = e.tBodies[0].rows;
			// .mffselected of mff.html
			for (var i = 0; i < rows.length; i++) rows[i].classList.toggle("mffselected", i == index);
			e.setAttribute("data-position", index);
		},
		// Canvas of a control: a <canvas> over the element, made at the first drawing.
		// It follows the size of the element; a change of the size repaints the control (ONPAINT).
		ctx: function(id, create) {
			// a page of PrintDocument (PAGECREATE) is drawn like a control
			var page = mff.pages[id];
			if (page) return page.getContext("2d");
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
		// The pages of PrintDocument (PAGECREATE): offscreen canvases by the address of the page
		pages: {},
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
				// the main form fills the browser window (fitMainForm): its Left and Top would only be empty places
				e.style.left = ""; e.style.top = "";
				e.style.marginLeft = "0px"; e.style.marginTop = "0px";
			} else {
				e.style.left = left; e.style.top = top;
			}
		},
		// The main form fills the browser window (with its margins on all sides) and follows its size:
		// ONRESIZE gives the size to the form, RequestAlign moves the anchored controls
		fitMainForm: function(e, Id) {
			var pending = false;
			// the console of FreeBASIC (termContainer of mff.html) is under the form: both are in the browser window
			var term = document.getElementById("termContainer");
			function fit() {
				pending = false;
				var r = e.getBoundingClientRect();
				var x = r.left + window.scrollX, y = r.top + window.scrollY;
				var below = term && term.offsetHeight ? term.offsetHeight + x : 0;
				// the margin at the bottom is the one at the left: y is bigger with the main menu bar above the form
				var w = Math.max(100, Math.floor(document.documentElement.clientWidth - 2 * x));
				var h = Math.max(100, Math.floor(window.innerHeight - y - x - below));
				// the bar of the main menu (SETMAINMENU) has the width of the form
				var bar = mff.el(String(Id) + "MainMenu");
				if (bar) bar.style.width = w + "px";
				if (w == e.offsetWidth && h == e.offsetHeight) return;
				e.style.width = w + "px";
				e.style.height = h + "px";
				mff.call("ONRESIZE", [Id, w, h]);
			}
			function request() {
				if (!pending) { pending = true; requestAnimationFrame(fit); }
			}
			window.addEventListener("resize", request);
			// the page gets narrower or wider without a resize of the window too (its scroll bar comes or goes)
			if (typeof ResizeObserver !== "undefined") {
				new ResizeObserver(request).observe(document.documentElement);
				// the console is opened, closed ([x]) or gets another size
				if (term) new ResizeObserver(request).observe(term);
			}
			// after the child controls are created
			setTimeout(fit, 0);
		},
		on: function(id, event, handler) {
			var e = mff.el(id);
			if (e) e.addEventListener(event, handler, false);
		},
		// ScrollBarControl (data-scrollbar "v" or "h"): the scroll bar of the browser over a long content, the position
		// in data-min .. data-max (data-page: the size of the thumb); the scrolling of the user raises ONCHANGE
		scrollBar: function(e) {
			var dir = e.getAttribute("data-scrollbar");
			if (!dir) return false;
			if (!e.mffSpacer) {
				var v = dir == "v";
				e.style.overflowX = v ? "hidden" : "scroll";
				e.style.overflowY = v ? "scroll" : "hidden";
				if (!e.hasAttribute("data-position")) e.setAttribute("data-position", "0");
				var sp = document.createElement("div");
				sp.style.cssText = v ? "width: 1px;" : "height: 1px;";
				e.appendChild(sp);
				e.mffSpacer = sp;
				e.addEventListener("scroll", function() {
					var scroll = v ? e.scrollTop : e.scrollLeft;
					// the scrolling of the program (scrollBarLayout)
					if (e.mffScrollSet !== undefined && Math.abs(scroll - e.mffScrollSet) < 1) return;
					e.mffScrollSet = undefined;
					var min = Number(e.getAttribute("data-min") || 0), max = Number(e.getAttribute("data-max") || 0);
					var room = (v ? e.scrollHeight - e.clientHeight : e.scrollWidth - e.clientWidth);
					var pos = room > 0 ? Math.round(min + scroll / room * (max - min)) : min;
					if (pos == Number(e.getAttribute("data-position"))) return;
					e.setAttribute("data-position", pos);
					mff.call("ONCHANGE", [Number(e.id)]);
				});
				if (typeof ResizeObserver !== "undefined") new ResizeObserver(function() { mff.scrollBarLayout(e); }).observe(e);
			}
			return true;
		},
		scrollBarLayout: function(e) {
			if (!e.mffSpacer) return;
			var v = e.getAttribute("data-scrollbar") == "v";
			var min = Number(e.getAttribute("data-min") || 0), max = Number(e.getAttribute("data-max") || 0);
			var pos = Number(e.getAttribute("data-position") || 0), range = Math.max(0, max - min);
			var size = v ? e.clientHeight : e.clientWidth;
			if (size <= 0) return;
			// the page is the visible part: without data-page a tenth of the range
			var page = Number(e.getAttribute("data-page") || 0) || Math.max(1, range / 10);
			var total = range > 0 ? Math.round(size * (range + page) / page) : size;
			if (v) e.mffSpacer.style.height = total + "px"; else e.mffSpacer.style.width = total + "px";
			var scroll = range > 0 ? Math.round((Math.min(max, Math.max(min, pos)) - min) / range * (total - size)) : 0;
			if ((v ? e.scrollTop : e.scrollLeft) != scroll) {
				e.mffScrollSet = scroll;
				if (v) e.scrollTop = scroll; else e.scrollLeft = scroll;
			}
		},
		// The point of a mouse event in the element el: e.offsetX is the one in the target (a child element when the
		// event comes up to el)
		mousePos: function(el, e) {
			var r = el.getBoundingClientRect();
			// a pressed element hidden after the press (the sizing dots of the designer of the IDE) has no place on the
			// page: the moves are in the place which it had at the press (its control keeps it)
			if (el.mffDownRect && r.width == 0 && r.height == 0 && !el.offsetParent) r = el.mffDownRect;
			// the border of a group box (fieldset) is drawn in its client area like on Windows (GroupBox.GetContent)
			if (el.tagName == "FIELDSET") return [Math.round(e.clientX - r.left), Math.round(e.clientY - r.top)];
			return [Math.round(e.clientX - r.left - el.clientLeft), Math.round(e.clientY - r.top - el.clientTop)];
		},
		// The mouse events like the messages of Windows: a press goes to the innermost control with the event (not to
		// its parents too), the moves and the release after the press go to the pressed control (the capture of
		// Windows: the designer of the IDE places a control by the press and the release)
		mouseIds: {move: {}, up: {}},
		mouseCapture: function() {
			if (mff.captureOn) return;
			mff.captureOn = true;
			function captured(e) {
				var id = mff.captureId;
				if (!id) return;
				var el = mff.el(id);
				if (!el) { mff.captureId = 0; return; }
				e.mffDone = true;
				var p = mff.mousePos(el, e);
				if (e.type == "mousemove") {
					if (mff.mouseIds.move[id]) mff.call("ONMOUSEMOVE", [id, e.buttons, p[0], p[1], mff.shift(e)]);
				} else {
					mff.captureId = 0;
					if (mff.mouseIds.up[id]) mff.call("ONMOUSEUP", [id, e.button, p[0], p[1], mff.shift(e)]);
				}
			}
			document.addEventListener("mousemove", captured, true);
			document.addEventListener("mouseup", captured, true);
		}
	},

	// The dark mode of the page (SetDarkMode of DarkMode.bas, App.DarkMode): html.mffdark has the dark colors of mff.html
	SETPAGEDARKMODE: function(Value) {
		document.documentElement.classList.toggle("mffdark", !!Value);
	},

	GETDOCUMENTWIDTH__deps: ['$mff'],
	GETDOCUMENTWIDTH: function() {
		return window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	},

	GETDOCUMENTHEIGHT__deps: ['$mff'],
	GETDOCUMENTHEIGHT: function() {
		return window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
	},

	GETCLIENTSIZE__deps: ['$mff'],
	GETCLIENTSIZE: function(Id, Vertical) {
		var e = mff.el(String(Id) + "Client");
		if (!e) {
			// a form with a title bar: its element without the borders (Height is the one of the window with the title
			// bar, CREATEELEMENT), by its style also while it is hidden (the controls are docked before Show)
			var f = mff.el(Id), header = mff.el(String(Id) + "Header");
			if (!f || !header || header.parentElement !== f) return -1;
			var cs = getComputedStyle(f);
			var s = Vertical ? parseFloat(f.style.height) - parseFloat(cs.borderTopWidth) - parseFloat(cs.borderBottomWidth) :
				parseFloat(f.style.width) - parseFloat(cs.borderLeftWidth) - parseFloat(cs.borderRightWidth);
			return s > 0 ? Math.round(s) : -1;
		}
		var v = Vertical ? e.clientHeight : e.clientWidth;
		// a hidden one has no size
		return v > 0 ? v : -1;
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

	CREATEELEMENT__deps: ['$mff', '$Asyncify'],
	CREATEELEMENT: function(AddPosition, ClassName, Class, Type, Id, Name, Text, Style, PositionType, Left, Top, Width, Height, Right, Bottom, Parent) {
		mff.keys();
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
		// a RichTextBox can be edited until it is ReadOnly (SETREADONLY)
		if (/(^| )mffrichtext( |$)/.test(strClass)) e.contentEditable = "true";
		e.style.cssText = mff.str(Style);
		// the display of the style (the flex of CheckBox, RadioButton) comes back when the element is shown (SETVISIBLE)
		if (e.style.display && e.style.display != "none") e.setAttribute("data-display", e.style.display);
		e.style.position = mff.str(PositionType);
		mff.place(e, mff.str(Left), mff.str(Top));
		e.style.width = mff.str(Width);
		e.style.height = mff.str(Height);
		e.style.right = mff.str(Right);
		e.style.bottom = mff.str(Bottom);
		e.style.boxSizing = "border-box";
		var parent = Parent ? (mff.el(String(Parent) + "Client") || mff.el(Parent)) : null;
		(parent || document.body).insertAdjacentElement(mff.str(AddPosition) || "beforeend", e);
		// a ComboBoxEdit with an edit box has its list also without items (its arrow)
		if (e.tagName == "INPUT" && e.classList.contains("mffcombo")) mff.list(e);
		if (e.style.position == "relative") mff.fitMainForm(e, Id);
		if (strClass.indexOf("vetdialog box") >= 0 || /(^| )mffdialog( |$)/.test(strClass)) {
			var header = mff.el(String(Id) + "Header");
			var design = /(^| )mffdesign( |$)/.test(strClass);
			// the title bar is above the form (.mffcaption): like on Windows Height and Top are the ones of the window
			// with the title bar, the element is the client area under it (a designed form is under it by .mffdesign of
			// mff.html, ELEMENTSETBOUNDS)
			if (header) {
				var ch = header.offsetHeight;
				if (/px$/.test(e.style.height)) e.style.height = Math.max(0, parseFloat(e.style.height) - ch) + "px";
				if (!design) e.style.top = ((parseFloat(e.style.top) || 0) + ch) + "px";
			}
			if (header && typeof dragElement === "function" && !design) dragElement(header, e);
			// the panel of the designer shows the part of the designed form in it (scroll bars like on Windows)
			if (design && e.parentElement && e.parentElement !== document.body) e.parentElement.style.overflow = "auto";
			var close = mff.el(String(Id) + "CloseButton");
			if (close && !design) close.onclick = function() { mff.call("ONCLOSE", [Id]); };
			// minimize and maximize (ONCAPTIONBUTTON of Form.bas), the double click on the title bar maximizes or restores
			var min = mff.el(String(Id) + "MinButton"), max = mff.el(String(Id) + "MaxButton");
			if (min && !design) min.onclick = function() { mff.call("ONCAPTIONBUTTON", [Id, 1]); };
			if (max && !design) max.onclick = function() { mff.call("ONCAPTIONBUTTON", [Id, 2]); };
			if (header && max && !design) header.addEventListener("dblclick", function(ev) {
				if (ev.target.closest(".mffclose, .mffcaptionbutton") || max.style.display == "none") return;
				mff.call("ONCAPTIONBUTTON", [Id, 2]);
			});
		}
	},

	GETPARENTPAGEOFFSET__deps: ['$mff'],
	GETPARENTPAGEOFFSET: function(Id, Vertical) {
		var e = mff.el(Id), p = e ? e.offsetParent : null;
		if (!p) return 0;
		var r = p.getBoundingClientRect();
		return Math.round(Vertical ? r.top + p.clientTop : r.left + p.clientLeft);
	},

	SETCAPTIONSTATE__deps: ['$mff'],
	SETCAPTIONSTATE: function(Id, State) {
		var min = mff.el(String(Id) + "MinButton"), max = mff.el(String(Id) + "MaxButton");
		// the characters of .mffcaptionbutton (mff.html)
		if (min) { min.setAttribute("data-glyph", State == 1 ? "restore" : "min"); min.title = State == 1 ? "Restore Up" : "Minimize"; }
		if (max) { max.setAttribute("data-glyph", State == 2 ? "restore" : "max"); max.title = State == 2 ? "Restore Down" : "Maximize"; }
	},

	DELETEELEMENT__deps: ['$mff'],
	DELETEELEMENT: function(Id) {
		var e = mff.el(Id);
		if (e && e.tagName == "INPUT" && e.list) e.list.remove();
		if (e && e.parentNode) e.parentNode.removeChild(e);
	},

	// Control.Add of a control which has its element already (SetParent): the element is moved into the client
	// element of the new parent (CREATEELEMENT puts the children there)
	// Control.BringToFront / SendToBack: the element is the last / the first child of its parent (after the canvas of
	// the parent, which is under the children)
	ELEMENTZORDER__deps: ['$mff'],
	ELEMENTZORDER: function(Id, ToFront) {
		var e = mff.el(Id), p = e ? e.parentNode : null;
		if (!p) return;
		// the main form is in the flow of the page at its beginning (CreateElement "afterbegin"): moved to the end it
		// would be under the console of FreeBASIC (termContainer of mff.html)
		if (p === document.body && e.style.position == "relative") return;
		if (ToFront) { if (p.lastElementChild !== e) p.appendChild(e); }
		else {
			var first = p.firstElementChild;
			while (first && (first === e || first.classList.contains("mffcanvas") || first.classList.contains("mfftabs"))) first = first.nextElementSibling;
			if (first) p.insertBefore(e, first);
		}
	},

	SETPARENTELEMENT__deps: ['$mff'],
	SETPARENTELEMENT: function(Id, Parent) {
		var e = mff.el(Id), p = mff.el(String(Parent) + "Client") || mff.el(Parent);
		if (e && p && e.parentNode !== p && !e.contains(p)) p.appendChild(e);
		// the panel of the designer shows the part of the designed form in it (CREATEELEMENT)
		if (e && p && e.classList.contains("mffdesign")) p.style.overflow = "auto";
	},

	// The size of the content of the element without wrapping (Horizontal = 1: the width, 0: the height in that width),
	// a tooltip of EditControl gets the size of its text
	ELEMENTNATURALSIZE__deps: ['$mff'],
	ELEMENTNATURALSIZE: function(Id, Horizontal) {
		var e = mff.el(Id);
		if (!e) return 0;
		var w = e.style.width, h = e.style.height;
		// the height in the width of the element (its lines wrap), the width without wrapping
		if (Horizontal) e.style.width = "max-content";
		e.style.height = "auto";
		var r = Horizontal ? e.offsetWidth : e.offsetHeight;
		e.style.width = w;
		e.style.height = h;
		return r;
	},

	// Control.OnMouseHover like TrackMouseEvent of Windows: ONMOUSEHOVER when the mouse stays 400 ms on the control after
	// a move (ONMOUSEMOVE), leaving the control stops it; not while a modal form or a popup menu waits
	MOUSEHOVERTIMER__deps: ['$mff', '$Asyncify'],
	MOUSEHOVERTIMER: function(Id, x, y, Shift) {
		clearTimeout(mff.hoverTimer);
		var e = mff.el(Id);
		if (!e) return;
		if (!e.mffHover) {
			e.mffHover = true;
			e.addEventListener("mouseleave", function() { clearTimeout(mff.hoverTimer); });
		}
		mff.hoverTimer = setTimeout(function() {
			if (mff.modalWait || Asyncify.currData || !e.isConnected) return;
			mff.call("ONMOUSEHOVER", [Id, x, y, Shift]);
		}, 400);
	},

	ELEMENTSETBOUNDS__deps: ['$mff'],
	ELEMENTSETBOUNDS: function(Id, Left, Top, Width, Height) {
		var e = mff.el(Id);
		if (!e) return;
		// a form with a title bar: Top and Height are the ones of the window (CREATEELEMENT)
		var header = mff.el(String(Id) + "Header"), ch = header && header.parentElement === e ? header.offsetHeight : 0;
		mff.place(e, Left + "px", (Top + (e.classList.contains("mffdesign") ? 0 : ch)) + "px");
		e.style.width = Width + "px";
		e.style.height = Math.max(0, Height - ch) + "px";
	},

	// The left and the width of the item Index of the buttons of a ToolBar (SETBUTTONS), -1 if there is none
	BUTTONSITEMLEFT__deps: ['$mff'],
	BUTTONSITEMLEFT: function(Id, Index) {
		var e = mff.el(Id), row = e ? e.querySelector(":scope > .mffbuttons") : null;
		var item = row ? row.children[Index] : null;
		return item ? item.offsetLeft + row.offsetLeft : -1;
	},

	BUTTONSITEMWIDTH__deps: ['$mff'],
	BUTTONSITEMWIDTH: function(Id, Index) {
		var e = mff.el(Id), row = e ? e.querySelector(":scope > .mffbuttons") : null;
		var item = row ? row.children[Index] : null;
		return item ? item.offsetWidth : -1;
	},

	// The width which the content of the element needs (the buttons of a ToolBar for its band of a ReBar), 0 if unknown
	ELEMENTCONTENTWIDTH__deps: ['$mff'],
	ELEMENTCONTENTWIDTH: function(Id) {
		var e = mff.el(Id);
		if (!e || e.style.display == "none") return 0;
		var row = e.querySelector(":scope > .mffbuttons");
		if (!row) return e.scrollWidth;
		// the items one after another (an expanding gap counts with its least width)
		var w = 0, items = row.children, cs = getComputedStyle(row);
		for (var i = 0; i < items.length; i++) {
			var it = items[i], s = getComputedStyle(it);
			if (s.display == "none") continue;
			var basis = it.className == "mffgap" ? parseFloat(s.flexBasis) || 0 : it.offsetWidth;
			w += basis + (parseFloat(s.marginLeft) || 0) + (parseFloat(s.marginRight) || 0);
		}
		var gap = parseFloat(cs.columnGap) || 0;
		return Math.ceil(w + gap * Math.max(0, items.length - 1) + (parseFloat(cs.paddingLeft) || 0) + (parseFloat(cs.paddingRight) || 0)) + 2;
	},

	SETVISIBLE__deps: ['$mff'],
	SETVISIBLE: function(Id, value) {
		var e = mff.el(Id);
		// a shown element gets its own display back (data-display: the block of a table view, TABLEINIT)
		if (e) e.style.display = value ? (e.getAttribute("data-display") || "") : "none";
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
		if (!e || !e.focus) return;
		// an element which can not have the focus (a div, a table: a TreeListView) gets it like a window of Windows
		if (e.tabIndex < 0 && !e.hasAttribute("tabindex")) e.tabIndex = -1;
		e.focus({preventScroll: true});
	},

	GETSTRINGVALUE__deps: ['$mff'],
	GETSTRINGVALUE: function(Id) {
		var e = mff.el(Id);
		// the text of a RichTextBox (.mffrichtext, a <div contenteditable>) with its new lines
		return stringToNewUTF8(e ? (e.value !== undefined ? e.value : e.classList.contains("mffrichtext") ? e.innerText : e.textContent) : "");
	},

	SETSTRINGVALUE__deps: ['$mff'],
	SETSTRINGVALUE: function(Id, Value) {
		var e = mff.el(Id);
		if (!e) return;
		if (e.classList.contains("mffrichtext")) e.textContent = mff.str(Value);
		else e.value = mff.str(Value);
	},

	// The RichTextBox of the Web (RichTextBox.bas): a <div contenteditable class="mffrichtext">. Its text is the one of
	// innerText: a <br> and the start of a block (<div>, <p>, <li>) after other text are new lines ("\n"); the positions
	// of SelStart, Find, GetTextRange are in this text. The last selection in the element is kept (a button of a toolbar
	// takes the focus), the commands use it
	$mffRich__deps: ['$mff'],
	$mffRich: {
		init: function() {
			if (mffRich.inited) return;
			mffRich.inited = true;
			document.addEventListener("selectionchange", function() {
				var s = document.getSelection();
				if (!s || !s.rangeCount) return;
				var n = s.anchorNode, e = n && (n.nodeType == 1 ? n : n.parentNode);
				e = e && e.closest ? e.closest(".mffrichtext") : null;
				// only a selection of the user (the element has the focus): the event of a command comes later, after the
				// command has given the focus back and maybe has set mffRange itself (Find)
				if (e && document.activeElement === e) e.mffRange = s.getRangeAt(0).cloneRange();
			});
		},
		isBlock: function(n) {
			return n.nodeType == 1 && /^(DIV|P|LI|UL|OL|H[1-6]|BLOCKQUOTE)$/.test(n.tagName);
		},
		// calls f(node, text) for the pieces of the text of e in their order: a text node, a <br> ("\n") or the start of
		// a block after other text ("\n", node null)
		walk: function(e, f) {
			var started = false;
			(function go(p) {
				for (var n = p.firstChild; n; n = n.nextSibling) {
					if (n.nodeType == 3) { if (n.nodeValue.length) { f(n, n.nodeValue); started = true; } }
					else if (n.nodeType == 1) {
						if (n.tagName == "BR") { f(n, "\n"); started = true; continue; }
						if (mffRich.isBlock(n) && started) f(null, "\n");
						go(n);
					}
				}
			})(e);
		},
		text: function(e) {
			var t = "";
			mffRich.walk(e, function(n, s) { t += s; });
			return t;
		},
		// the position in the text of the place (node, offset) of a range
		offsetOf: function(e, node, offset) {
			var pos = 0, done = false;
			if (node === e || (node.nodeType == 1 && node.childNodes.length)) {
				// a place between the children of an element: before its child offset
				var child = node.childNodes[offset];
				if (!child) { var r = document.createRange(); r.selectNodeContents(node); r.collapse(false); node = r.endContainer; }
				mffRich.walk(e, function(n, s) {
					if (done) return;
					if (child && n && (n === child || child.contains(n))) { done = true; return; }
					if (!child && n && !node.contains(n) && (node.compareDocumentPosition(n) & Node.DOCUMENT_POSITION_FOLLOWING)) { done = true; return; }
					pos += s.length;
				});
				return pos;
			}
			mffRich.walk(e, function(n, s) {
				if (done) return;
				if (n === node) { pos += n.nodeType == 3 ? offset : (offset > 0 ? 1 : 0); done = true; return; }
				pos += s.length;
			});
			return pos;
		},
		// the place (node, offset) of the position pos of the text
		pointAt: function(e, pos) {
			var res = null, last = null;
			mffRich.walk(e, function(n, s) {
				if (res) return;
				if (n && n.nodeType == 3) last = { node: n, offset: n.nodeValue.length };
				if (pos <= s.length && n) {
					if (n.nodeType == 3) res = { node: n, offset: pos };
					else res = { node: n.parentNode, offset: Array.prototype.indexOf.call(n.parentNode.childNodes, n) + (pos > 0 ? 1 : 0) };
				}
				pos -= s.length;
			});
			return res || last || { node: e, offset: e.childNodes.length };
		},
		range: function(e) {
			var r = e.mffRange;
			if (!r || !e.contains(r.startContainer)) { r = document.createRange(); r.selectNodeContents(e); r.collapse(false); }
			return r;
		},
		// the selection of the element is the one of the document while a command works (the element can be edited for it)
		apply: function(e, f) {
			var editable = e.contentEditable, s = document.getSelection(), active = document.activeElement;
			if (editable != "true") e.contentEditable = "true";
			e.focus({ preventScroll: true });
			s.removeAllRanges();
			s.addRange(mffRich.range(e));
			document.execCommand("styleWithCSS", false, true);
			var result = f(s);
			if (s.rangeCount) e.mffRange = s.getRangeAt(0).cloneRange();
			if (editable != "true") e.contentEditable = editable;
			// the focus goes back: the element does not keep it (the later selectionchange of the command is not a selection
			// of the user)
			if (active !== e) {
				if (active && active !== document.body && active.focus) active.focus({ preventScroll: true });
				if (document.activeElement === e) e.blur();
			}
			return result;
		},
		select: function(e, start, end) {
			var a = mffRich.pointAt(e, start), b = mffRich.pointAt(e, end), r = document.createRange();
			r.setStart(a.node, a.offset);
			r.setEnd(b.node, b.offset);
			e.mffRange = r;
			if (document.activeElement === e) { var s = document.getSelection(); s.removeAllRanges(); s.addRange(r); }
		},
		// the element of the start of the selection (its computed style is the one of the selected text)
		anchor: function(e) {
			var r = mffRich.range(e), n = r.startContainer;
			// the first text in the selection (its start can be at the end of the text before it)
			if (!r.collapsed) {
				var root = r.commonAncestorContainer.nodeType == 1 ? r.commonAncestorContainer : r.commonAncestorContainer.parentNode;
				var w = document.createTreeWalker(root, NodeFilter.SHOW_TEXT);
				for (var t = w.nextNode(); t; t = w.nextNode()) {
					if (!r.intersectsNode(t) || !t.nodeValue.length) continue;
					if (t === r.startContainer && r.startOffset >= t.nodeValue.length) continue;
					if (t === r.endContainer && r.endOffset == 0) continue;
					return t.parentNode;
				}
			}
			if (n.nodeType == 1 && n.childNodes[r.startOffset] && n.childNodes[r.startOffset].nodeType == 1) n = n.childNodes[r.startOffset];
			return n.nodeType == 1 ? n : n.parentNode;
		},
		block: function(e) {
			var n = mffRich.anchor(e);
			while (n && n !== e && !mffRich.isBlock(n)) n = n.parentNode;
			return n || e;
		},
		// a CSS color as a color of Windows (BGR)
		bgr: function(c) {
			var m = /rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*([\d.]+))?/.exec(c || "");
			if (!m || m[4] === "0") return -1;
			return (+m[1]) | (+m[2] << 8) | (+m[3] << 16);
		},
		// the font size of the selection in points: execCommand has 7 sizes, a <font size="7"> becomes a <span> with the size
		fontSize: function(e, pt) {
			document.execCommand("styleWithCSS", false, false);
			document.execCommand("fontSize", false, "7");
			var first = null, last = null;
			Array.prototype.forEach.call(e.querySelectorAll("font[size='7']"), function(f) {
				var sp = document.createElement("span");
				sp.style.fontSize = pt + "pt";
				while (f.firstChild) sp.appendChild(f.firstChild);
				f.parentNode.replaceChild(sp, f);
				if (!first) first = sp;
				last = sp;
			});
			// the new spans are the selection (the one of the replaced <font> elements is lost)
			if (first) {
				var r = document.createRange(), s = document.getSelection();
				r.setStart(first, 0);
				r.setEnd(last, last.childNodes.length);
				s.removeAllRanges();
				s.addRange(r);
			}
		},
		// The RTF of the element (TextRTF): the formatting of the text (bold, italic, underline, strikeout, the color, the
		// font and its size, the alignment of the paragraphs) like the RTF of a rich edit of Windows
		rtf: function(e) {
			var fonts = [], colors = [], body = "";
			function fontIndex(f) { f = (f || "").split(",")[0].replace(/["']/g, "").trim(); var i = fonts.indexOf(f); if (i < 0) { fonts.push(f); i = fonts.length - 1; } return i; }
			function colorIndex(c) { var i = colors.indexOf(c); if (i < 0) { colors.push(c); i = colors.length - 1; } return i + 1; }
			function esc(s) {
				var r = "";
				for (var i = 0; i < s.length; i++) {
					var ch = s.charAt(i), code = s.charCodeAt(i);
					if (ch == "\\" || ch == "{" || ch == "}") r += "\\" + ch;
					else if (ch == "\n") r += "\\par\n";
					else if (ch == "\t") r += "\\tab ";
					else if (code > 127) r += "\\u" + (code > 32767 ? code - 65536 : code) + "?";
					else r += ch;
				}
				return r;
			}
			var base = getComputedStyle(e), last = "", align = "";
			fontIndex(base.fontFamily);
			mffRich.walk(e, function(n, s) {
				var el = n ? (n.nodeType == 3 ? n.parentNode : n.parentNode) : null, fmt = "";
				if (el) {
					var cs = getComputedStyle(el), deco = cs.textDecorationLine || cs.textDecoration || "";
					var blk = el; while (blk && blk !== e && !mffRich.isBlock(blk)) blk = blk.parentNode;
					var a = getComputedStyle(blk || e).textAlign, q = a == "center" ? "\\qc" : a == "right" || a == "end" ? "\\qr" : a == "justify" ? "\\qj" : "\\ql";
					if (q != align) { body += "\\pard" + q + " "; align = q; last = ""; }
					fmt = (parseInt(cs.fontWeight, 10) >= 600 ? "\\b" : "\\b0") + (cs.fontStyle == "italic" ? "\\i" : "\\i0") +
						(deco.indexOf("underline") >= 0 ? "\\ul" : "\\ulnone") + (deco.indexOf("line-through") >= 0 ? "\\strike" : "\\strike0") +
						"\\f" + fontIndex(cs.fontFamily) + "\\fs" + Math.round(parseFloat(cs.fontSize) * 0.75 * 2) +
						"\\cf" + colorIndex(mffRich.bgr(cs.color));
					var bg = mffRich.bgr(cs.backgroundColor);
					fmt += bg >= 0 ? "\\highlight" + colorIndex(bg) : "\\highlight0";
				}
				if (fmt && fmt != last) { body += fmt + " "; last = fmt; }
				body += esc(s);
			});
			var ft = "{\\fonttbl" + fonts.map(function(f, i) { return "{\\f" + i + " " + f + ";}"; }).join("") + "}";
			var ct = "{\\colortbl ;" + colors.map(function(c) { return "\\red" + (c & 255) + "\\green" + ((c >> 8) & 255) + "\\blue" + ((c >> 16) & 255) + ";"; }).join("") + "}";
			return "{\\rtf1\\ansi\\deff0" + ft + ct + "\n" + body + "\\par\n}";
		}
	},

	// The commands of a RichTextBox (RichTextBox.bas): Cmd "get..." returns the value, the other ones set Value (UTF-8);
	// the result is a new UTF-8 string (Deallocate)
	RICHTEXTCMD__deps: ['$mff', '$mffRich', '$FS', '$stringToNewUTF8'],
	RICHTEXTCMD: function(Id, Cmd, Value) {
		var e = mff.el(Id), cmd = mff.str(Cmd), v = mff.str(Value), res = "";
		if (!e) return stringToNewUTF8("");
		mffRich.init();
		var R = mffRich;
		switch (cmd) {
		case "getbold": res = parseInt(getComputedStyle(R.anchor(e)).fontWeight, 10) >= 600 ? "1" : "0"; break;
		case "getitalic": res = getComputedStyle(R.anchor(e)).fontStyle == "italic" ? "1" : "0"; break;
		case "getunderline": case "getstrikeout":
			var n = R.anchor(e), want = cmd == "getunderline" ? "underline" : "line-through";
			res = "0";
			for (; n && n !== e.parentNode; n = n.parentNode) {
				var cs = getComputedStyle(n);
				if ((cs.textDecorationLine || cs.textDecoration || "").indexOf(want) >= 0) { res = "1"; break; }
			}
			break;
		case "bold": case "italic": case "underline": case "strikeThrough":
			R.apply(e, function() { if (document.queryCommandState(cmd) != (v == "1")) document.execCommand(cmd); });
			break;
		case "getcolor": res = String(R.bgr(getComputedStyle(R.anchor(e)).color)); break;
		case "getbackcolor": res = String(R.bgr(getComputedStyle(R.anchor(e)).backgroundColor)); break;
		case "color": case "backcolor":
			var c = parseInt(v, 10), css = c < 0 ? (cmd == "color" ? "inherit" : "transparent") : mff.color(c);
			R.apply(e, function() { document.execCommand(cmd == "color" ? "foreColor" : "hiliteColor", false, css); });
			break;
		case "getfontname": res = getComputedStyle(R.anchor(e)).fontFamily.split(",")[0].replace(/["']/g, "").trim(); break;
		case "fontname": R.apply(e, function() { document.execCommand("fontName", false, v); }); break;
		case "getfontsize": res = String(Math.round(parseFloat(getComputedStyle(R.anchor(e)).fontSize) * 0.75)); break;
		case "fontsize": R.apply(e, function() { R.fontSize(e, parseFloat(v)); }); break;
		case "getalignment":
			var ta = getComputedStyle(R.block(e)).textAlign;
			// AlignmentConstants: taLeft, taCenter, taRight
			res = ta == "center" ? "1" : ta == "right" || ta == "end" ? "2" : "0";
			break;
		case "alignment":
			R.apply(e, function() { document.execCommand(v == "1" ? "justifyCenter" : v == "2" ? "justifyRight" : "justifyLeft"); });
			break;
		case "getbullet": var b = R.anchor(e); res = b.closest && b.closest("ul") && e.contains(b.closest("ul")) ? "1" : "0"; break;
		case "bullet":
			R.apply(e, function() { if (document.queryCommandState("insertUnorderedList") != (v == "1")) document.execCommand("insertUnorderedList"); });
			break;
		// the indents are in twips like on Windows (1440 a inch, 15 a pixel)
		case "getindent": res = String(Math.round(parseFloat(getComputedStyle(R.block(e)).marginLeft) * 15)); break;
		case "getrightindent": res = String(Math.round(parseFloat(getComputedStyle(R.block(e)).marginRight) * 15)); break;
		case "gethangingindent": res = String(Math.round(-parseFloat(getComputedStyle(R.block(e)).textIndent) * 15)); break;
		case "indent": case "rightindent": case "hangingindent":
			R.apply(e, function() {
				var blk = R.block(e);
				if (blk === e) { document.execCommand("formatBlock", false, "div"); blk = R.block(e); }
				if (blk === e) return;
				var px = parseInt(v, 10) / 15 + "px";
				if (cmd == "indent") blk.style.marginLeft = px;
				else if (cmd == "rightindent") blk.style.marginRight = px;
				else { blk.style.textIndent = "-" + px; blk.style.paddingLeft = px; }
			});
			break;
		case "getcharoffset":
			var va = getComputedStyle(R.anchor(e)).verticalAlign;
			res = va == "super" ? "40" : va == "sub" ? "-40" : "0";
			break;
		case "charoffset":
			R.apply(e, function() {
				var o = parseInt(v, 10);
				if (document.queryCommandState("superscript")) document.execCommand("superscript");
				if (document.queryCommandState("subscript")) document.execCommand("subscript");
				if (o > 0) document.execCommand("superscript"); else if (o < 0) document.execCommand("subscript");
			});
			break;
		case "getseltext": var r = R.range(e); res = R.text(e).substring(R.offsetOf(e, r.startContainer, r.startOffset), R.offsetOf(e, r.endContainer, r.endOffset)); break;
		case "seltext": R.apply(e, function() { document.execCommand("insertText", false, v); }); break;
		case "getsel": var r2 = R.range(e); res = R.offsetOf(e, r2.startContainer, r2.startOffset) + "," + R.offsetOf(e, r2.endContainer, r2.endOffset); break;
		case "setsel": var p = v.split(","); R.select(e, Math.max(0, parseInt(p[0], 10) || 0), Math.max(0, parseInt(p[1], 10) || 0)); break;
		case "gettext": res = R.text(e); break;
		case "gettextrange": var q = v.split(","), t = R.text(e), hi = parseInt(q[1], 10); res = t.substring(parseInt(q[0], 10) || 0, hi < 0 ? t.length : hi); break;
		case "getrtf": res = R.rtf(e); break;
		// Find: Value is "start,flags,text" (flags: 1 - backward, 2 - match case); the found text is selected, the result is
		// its position or -1
		case "find":
			var i1 = v.indexOf(","), i2 = v.indexOf(",", i1 + 1), from = parseInt(v.substring(0, i1), 10), flags = parseInt(v.substring(i1 + 1, i2), 10), what = v.substring(i2 + 1);
			var hay = R.text(e);
			if (!(flags & 2)) { hay = hay.toLowerCase(); what = what.toLowerCase(); }
			var at = flags & 1 ? hay.lastIndexOf(what, Math.max(0, from - 1)) : hay.indexOf(what, from);
			if (at >= 0 && what.length) { R.select(e, at, at + what.length); res = String(at); } else res = "-1";
			break;
		case "getcharindexfrompos":
			var xy = v.split(","), b2 = e.getBoundingClientRect(), x = b2.left + parseInt(xy[0], 10), y = b2.top + parseInt(xy[1], 10), node = null, off = 0;
			if (document.caretPositionFromPoint) { var cp = document.caretPositionFromPoint(x, y); if (cp) { node = cp.offsetNode; off = cp.offset; } }
			else if (document.caretRangeFromPoint) { var cr = document.caretRangeFromPoint(x, y); if (cr) { node = cr.startContainer; off = cr.startOffset; } }
			res = node && e.contains(node) ? String(R.offsetOf(e, node, off)) : "-1";
			break;
		case "undo": R.apply(e, function() { document.execCommand("undo"); }); break;
		case "redo": R.apply(e, function() { document.execCommand("redo"); }); break;
		case "getcanredo": res = R.apply(e, function() { return document.queryCommandEnabled("redo"); }) ? "1" : "0"; break;
		case "getcanundo": res = R.apply(e, function() { return document.queryCommandEnabled("undo"); }) ? "1" : "0"; break;
		case "zoom": e.style.zoom = (parseInt(v, 10) || 100) / 100; break;
		// the last line which is seen (BottomLine): the line of the place at the bottom of the element
		case "getbottomline":
			var bb = e.getBoundingClientRect(), lh = parseFloat(getComputedStyle(e).lineHeight) || parseFloat(getComputedStyle(e).fontSize) * 1.2;
			res = String(Math.max(0, Math.floor((e.scrollTop + bb.height) / lh) - 1));
			break;
		// a picture (a data URL or the path of a file of FS) at the place of the selection
		case "image":
			var src = v;
			if (!/^(data|blob|https?):/.test(src)) { try { src = URL.createObjectURL(new Blob([FS.readFile(src)])); } catch (err) { src = v; } }
			R.apply(e, function() { document.execCommand("insertImage", false, src); });
			break;
		case "html": e.innerHTML = v; e.mffRange = null; break;
		}
		return stringToNewUTF8(res);
	},

	// TextBox.SelStart, SelLength, SetSel: the selection of an <input>, a <textarea> or a RichTextBox as "start,end"
	TEXTGETSEL__deps: ['$mff', '$mffRich', '$stringToNewUTF8'],
	TEXTGETSEL: function(Id) {
		var e = mff.el(Id);
		if (!e) return stringToNewUTF8("0,0");
		if (e.classList.contains("mffrichtext")) { mffRich.init(); var r = mffRich.range(e); return stringToNewUTF8(mffRich.offsetOf(e, r.startContainer, r.startOffset) + "," + mffRich.offsetOf(e, r.endContainer, r.endOffset)); }
		return stringToNewUTF8((e.selectionStart || 0) + "," + (e.selectionEnd || 0));
	},
	TEXTSETSEL__deps: ['$mff', '$mffRich'],
	TEXTSETSEL: function(Id, Start, End) {
		var e = mff.el(Id);
		if (!e) return;
		if (e.classList.contains("mffrichtext")) { mffRich.init(); mffRich.select(e, Start, End); return; }
		if (e.setSelectionRange) e.setSelectionRange(Start, End);
	},

	// TextBox.ReadOnly: an <input>, a <textarea> or a RichTextBox (.mffrichtext, a <div contenteditable>)
	SETREADONLY__deps: ['$mff'],
	SETREADONLY: function(Id, Value) {
		var e = mff.el(Id);
		if (!e) return;
		if (e.classList.contains("mffrichtext")) e.contentEditable = Value ? "false" : "true";
		else e.readOnly = !!Value;
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
		// the edit box of a ComboBoxEdit: the item with its text
		if (e.tagName == "INPUT") return Array.prototype.findIndex.call(mff.list(e).options, function(o) { return o.value == e.value; });
		if (e.tagName != "SELECT") return e.hasAttribute("data-position") ? Number(e.getAttribute("data-position")) | 0 : -1;
		return e.selectedIndex;
	},

	SETSELECTEDINDEX__deps: ['$mff'],
	SETSELECTEDINDEX: function(Id, Value) {
		var e = mff.el(Id);
		if (!e) return;
		if (e.tagName == "INPUT") { var o = mff.list(e).options[Value]; e.value = o ? o.value : ""; }
		else if (e.tagName != "SELECT") { mff.listInit(e); mff.listSelect(e, Value); }
		else { e.selectedIndex = Value; if (e.mffImages) mff.comboFace(e); }
	},

	// The picture of an item of a <select> (ComboBoxEx.bas): the browser shows the background of the options of a list
	// (size), the closed one shows the picture of the selected item as its background and its own list of the items
	// with their pictures (comboPopup) like the ComboBoxEx of Windows
	// The icon of a form (Form.Icon): URLs separated by "|" (FindIconFile), the browser shows the first one which is
	// there; in the title bar of a form which has one, the main form gives it to the page (favicon)
	SETFORMICON__deps: ['$mff'],
	SETFORMICON: function(Id, URLs, Main) {
		var sources = mff.str(URLs), old = mff.el(String(Id) + "Icon");
		if (!sources) { if (old) old.remove(); return; }
		mff.findImage(sources.split("|"), function(url) {
			var header = mff.el(String(Id) + "Header"), img = mff.el(String(Id) + "Icon");
			if (header && !img) {
				img = document.createElement("img");
				img.id = String(Id) + "Icon";
				img.className = "mffcaptionicon";
				header.insertBefore(img, header.firstChild);
			}
			if (img) img.src = url;
			if (Main) {
				var link = document.querySelector("link[rel~='icon']");
				if (!link) { link = document.createElement("link"); link.rel = "icon"; document.head.appendChild(link); }
				link.href = url;
			}
		});
	},

	SETSELECTITEMIMAGE__deps: ['$mff'],
	SETSELECTITEMIMAGE: function(Id, Index, URLs, Indent) {
		var e = mff.el(Id);
		if (!e || e.tagName != "SELECT" || !e.options[Index]) return;
		var o = e.options[Index], sources = mff.str(URLs);
		o.style.paddingLeft = (Indent * 10 + (sources ? 20 : 2)) + "px";
		o.mffIndent = Indent;
		if (!sources) { o.removeAttribute("data-img"); o.style.backgroundImage = ""; return; }
		mff.comboInit(e);
		mff.findImage(sources.split("|"), function(url) {
			o.setAttribute("data-img", url);
			// not the background shorthand: it resets the background color of the selected option (Edge gives it
			// white text on gray, the text was white on white)
			o.style.backgroundImage = "url(\"" + url + "\")";
			o.style.backgroundRepeat = "no-repeat";
			o.style.backgroundPosition = (Indent * 10 + 2) + "px center";
			o.style.backgroundSize = "16px 16px";
			if (o.index == e.selectedIndex) mff.comboFace(e);
		});
	},

	ADDSELECTITEM__deps: ['$mff'],
	ADDSELECTITEM: function(Id, Text) {
		var e = mff.list(mff.el(Id));
		if (e) e.insertBefore(mff.item(e, mff.str(Text)), null);
	},

	INSERTSELECTITEM__deps: ['$mff'],
	INSERTSELECTITEM: function(Id, Index, Text) {
		var e = mff.list(mff.el(Id));
		if (e) e.insertBefore(mff.item(e, mff.str(Text)), mff.items(e)[Index] || null);
	},

	REMOVESELECTITEM__deps: ['$mff'],
	REMOVESELECTITEM: function(Id, Index) {
		var e = mff.list(mff.el(Id));
		if (!e) return;
		var items = mff.items(e);
		if (Index >= 0 && Index < items.length) e.removeChild(items[Index]);
	},

	CLEARSELECTITEMS__deps: ['$mff'],
	CLEARSELECTITEMS: function(Id) {
		var e = mff.list(mff.el(Id));
		if (!e) return;
		var items = mff.items(e);
		for (var i = items.length - 1; i >= 0; i--) e.removeChild(items[i]);
	},

	ADDCOLUMN__deps: ['$mff'],
	ADDCOLUMN: function(Id, Caption) {
		var e = document.querySelector("table[id='" + Id + "'] thead tr");
		if (!e) return;
		var th = document.createElement("th");
		th.style.cssText = "background: var(--mff-header, #ccc); padding: 5px; border: 1px solid var(--mff-border, black);";
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
		// a list takes the focus by a click like on Windows (Form.ActiveControl, the keys)
		if (!e.hasAttribute("tabindex")) e.tabIndex = 0;
		// separate: the header row (sticky) has its own borders, the collapsed ones stay at their places when it is scrolled
		e.style.borderCollapse = "separate";
		e.style.borderSpacing = "0";
		// block: the rows keep their height in a high element (a table would stretch them); SETVISIBLE keeps it
		e.setAttribute("data-display", "block");
		if (e.style.display != "none") e.style.display = "block";
		e.style.overflow = "auto";
		// the elements of the child controls made before (the editor of the Properties of the IDE) stay
		var kids = Array.prototype.slice.call(e.children);
		e.innerHTML = "<thead><tr></tr></thead><tbody></tbody>";
		kids.forEach(function(k) { e.appendChild(k); });
		function row(ev) {
			var tr = ev.target && ev.target.closest ? ev.target.closest("tbody > tr") : null;
			return tr && e.contains(tr) ? Array.prototype.indexOf.call(tr.parentNode.children, tr) : -1;
		}
		e.addEventListener("click", function(ev) {
			var i = row(ev);
			if (i < 0) return;
			mff.tableSelect(e, i);
			// the sign of a node of a tree opens or closes it (tableFill)
			var toggle = ev.target.classList && ev.target.classList.contains("mfftoggle") && ev.target.hasAttribute("data-state");
			e.setAttribute("data-event", toggle ? "toggle" : "click");
			mff.call("ONCHANGE", [Id]);
		});
		e.addEventListener("dblclick", function(ev) {
			var i = row(ev);
			if (i < 0) return;
			e.setAttribute("data-event", "dblclick");
			mff.call("ONCHANGE", [Id]);
		});
	},

	// The rectangle of the cell Row, Col of a table in the coordinates of its content (Left, Top, Right, Bottom: Long at
	// pRect, like ListView_GetSubItemRect): a child control of the table (the editor of the Properties of the IDE) is put
	// over the cell; the content scrolls with the table, 0 if there is no such cell
	TABLECELLRECT__deps: ['$mff'],
	TABLECELLRECT: function(Id, Row, Col, pRect) {
		var e = mff.el(Id), r = [0, 0, 0, 0];
		var row = e && e.tBodies && e.tBodies[0] ? e.tBodies[0].rows[Row] : null;
		var c = row ? row.cells[Col] : null;
		if (c) {
			var b = c.getBoundingClientRect(), eb = e.getBoundingClientRect();
			var l = b.left - eb.left - e.clientLeft + e.scrollLeft, t = b.top - eb.top - e.clientTop + e.scrollTop;
			// without the right line of the cell (the bottom one is left out by the editors like the grid line of Windows)
			r = [l, t, l + c.clientLeft + c.clientWidth, t + b.height];
		}
		for (var i = 0; i < 4; i++) HEAP32[(pRect >> 2) + i] = Math.round(r[i]);
	},

	// The view of a ListView: "icon", "smallicon", "list", "tile" or "report" (.mfftable[data-view] of mff.html)
	TABLESETVIEW__deps: ['$mff'],
	TABLESETVIEW: function(Id, View) {
		var e = mff.el(Id);
		if (!e) return;
		e.classList.add("mfftable");
		e.setAttribute("data-view", mff.str(View) || "report");
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
			th.style.cssText = "position: sticky; top: 0; z-index: 1; background: var(--mff-header, #e8e8e8); border-right: 1px solid var(--mff-grid, #bbb); border-bottom: 1px solid var(--mff-grid, #bbb); padding: 2px 4px; text-align: left; white-space: nowrap; font-weight: normal; box-sizing: border-box;";
			// the width of the column (a column of -2, the rest of the width, has none)
			if (w[i] && Number(w[i]) > 0) th.style.minWidth = th.style.width = w[i] + "px";
			tr.appendChild(th);
		});
	},

	TABLEINSERTROW__deps: ['$mff'],
	TABLEINSERTROW: function(Id, Index, Cells) {
		var e = mff.el(Id);
		if (!e || !e.tBodies.length) return;
		var b = e.tBodies[0];
		var tr = document.createElement("tr");
		mff.tableFill(tr, mff.str(Cells), e);
		b.insertBefore(tr, Index >= 0 ? b.rows[Index] || null : null);
		var p = Number(e.getAttribute("data-position"));
		if (Index >= 0 && p >= Index) e.setAttribute("data-position", p + 1);
	},

	TABLESETROW__deps: ['$mff'],
	TABLESETROW: function(Id, Index, Cells) {
		var e = mff.el(Id);
		if (e && e.tBodies.length && e.tBodies[0].rows[Index]) mff.tableFill(e.tBodies[0].rows[Index], mff.str(Cells), e);
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
			mff.prevent(ev);
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
		if (mff.scrollBar(e)) {
			e.setAttribute("data-min", MinValue);
			e.setAttribute("data-max", MaxValue);
			mff.scrollBarLayout(e);
		} else if (e.tagName == "PROGRESS") {
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
		if (mff.scrollBar(e)) {
			e.setAttribute("data-position", Value);
			mff.scrollBarLayout(e);
			return;
		}
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
			e.insertAdjacentElement("afterbegin", strip);
		}
		// the text of the element (Text of the TabControl, "TabControl1") is not shown
		Array.prototype.slice.call(e.childNodes).forEach(function(n) { if (n.nodeType == 3) e.removeChild(n); });
		// TabPosition (data-tabpos of TabControl.UpdateTabs): 0 - left, 1 - right (vertical tabs, a collapsed panel of the
		// IDE shows only them), 2 - top, 3 - bottom
		var pos = Number(e.getAttribute("data-tabpos") || 2);
		var vertical = pos == 0 || pos == 1;
		strip.style.cssText = "position: absolute; display: flex; overflow: hidden; " + [
			"left: 0; top: 0; bottom: 0; width: 26px; flex-direction: column; border-right: 1px solid #aaa;",
			"right: 0; top: 0; bottom: 0; width: 26px; flex-direction: column; border-left: 1px solid #aaa;",
			"left: 0; top: 0; right: 0; height: 26px; border-bottom: 1px solid var(--mff-border, #aaa);",
			"left: 0; bottom: 0; right: 0; height: 26px; border-top: 1px solid #aaa;"][pos] || "";
		// the pages are in a client element under the strip (CREATEELEMENT puts the children into "<Id>Client"),
		// otherwise a page (alClient) covers the strip and its buttons can not be clicked
		var client = mff.el(String(Id) + "Client");
		if (!client) {
			client = document.createElement("div");
			client.id = String(Id) + "Client";
			Array.prototype.slice.call(e.children).forEach(function(c) { if (c !== strip) client.appendChild(c); });
			e.appendChild(client);
		}
		client.style.cssText = "position: absolute; " + ["left: 27px; top: 0; right: 0; bottom: 0;", "left: 0; top: 0; right: 27px; bottom: 0;",
			"left: 0; top: 27px; right: 0; bottom: 0;", "left: 0; top: 0; right: 0; bottom: 27px;"][pos];
		strip.innerHTML = "";
		var titles = mff.str(Titles);
		var list = titles == "" ? [] : titles.split("\n");
		var selected = Number(e.getAttribute("data-position")) | 0;
		list.forEach(function(title, i) {
			var b = document.createElement("button");
			b.type = "button";
			b.className = (i == selected ? "mfftab selected" : "mfftab");
			// "Title\tx": the tab has a close button (TabControl.ShowCloseButtons), its click raises the change event
			// with data-close (OnTabClose)
			var parts = title.split("\t");
			b.textContent = parts[0];
			// the picture of the tab before its caption (the URLs separated by "|" are tried one after another)
			if (parts[2]) {
				var sources = parts[2].split("|");
				var img = document.createElement("img");
				img.src = sources.shift();
				img.alt = "";
				img.style.cssText = "width: 16px; height: 16px; vertical-align: middle; margin-right: 4px;" + (vertical ? " transform: rotate(90deg);" : "");
				img.addEventListener("error", function() { if (sources.length) img.src = sources.shift(); else img.remove(); });
				b.insertBefore(img, b.firstChild);
			}
			if (parts[1] == "x") {
				var x = document.createElement("span");
				x.textContent = "\u00D7";
				x.title = "Close";
				x.style.cssText = "margin-left: 6px; padding: 0 3px; border-radius: 3px; color: var(--mff-gray, #666); font-weight: normal;";
				x.onmouseenter = function() { x.style.background = "#e81123"; x.style.color = "#fff"; };
				x.onmouseleave = function() { x.style.background = ""; x.style.color = "var(--mff-gray, #666)"; };
				x.addEventListener("click", function(ev) {
					ev.stopPropagation();
					e.setAttribute("data-close", i);
					mff.call("ONCHANGE", [Id]);
				});
				b.appendChild(x);
			}
			b.style.cssText = vertical ? "margin-bottom: 2px; border: 1px solid var(--mff-border, #aaa); writing-mode: vertical-rl; padding: 8px 2px; white-space: nowrap;" +
				(pos == 0 ? " border-right: none; border-radius: 4px 0 0 4px; transform: rotate(180deg);" : " border-left: none; border-radius: 0 4px 4px 0;") :
				"margin-right: 2px; border: 1px solid #aaa; display: inline-flex; align-items: center; " +
				(pos == 3 ? "border-top: none; border-radius: 0 0 4px 4px;" : "border-bottom: none; border-radius: 4px 4px 0 0;");
			// vertical tabs and the ones at the bottom are not moved down (.mfftab: 2px lower for the tabs at the top)
			if (vertical || pos == 3) b.style.top = "0";
			b.addEventListener("click", function(ev) {
				// the click goes on to the TabControl (its OnClick: the IDE opens a collapsed panel by its tab)
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
		// the buttons show the mouse over them and the press (their inline styles have a transparent border and
		// background), a checked one is pressed in (flag 2)
		if (!document.getElementById("mffbuttonsstyle")) {
			var st = document.createElement("style");
			st.id = "mffbuttonsstyle";
			// mffflat - a button with a picture (a transparent border), mffgroup - the header of a group of a palette;
			// a button with only a text keeps the look of the browser (a border color alone would make it an old 3D one)
			st.textContent = ".mffbuttons > button.mffflat:not(:disabled):hover { border: 1px solid #8a8a8a !important; background: rgba(0, 120, 215, 0.08) !important; }" +
				" .mffbuttons > button.mffflat:not(:disabled):active { border: 1px solid #6a6a6a !important; background: rgba(0, 0, 0, 0.12) !important; }" +
				" .mffbuttons > button.mffchecked { border: 1px solid #6a8fb8 !important; background: rgba(0, 120, 215, 0.16) !important; }" +
				" .mffbuttons > button.mffgroup:hover { background: var(--mff-hover, #f4f4f4) !important; border-color: #8a8a8a !important; }" +
				" .mffbuttons > button.mffgroup:active { background: var(--mff-pressed, #dcdcdc) !important; }";
			document.head.appendChild(st);
		}
		var row = e.querySelector(":scope > .mffbuttons");
		if (!row) {
			row = document.createElement("div");
			row.className = "mffbuttons";
			row.style.cssText = "display: flex; align-items: center; height: 100%; overflow: hidden; gap: 2px; padding: 0 2px;";
			e.insertAdjacentElement("afterbegin", row);
			// the controls of the custom buttons are put over their gaps by the program (ToolBar, CM_SIZE): in a hidden
			// page of a TabControl the gaps have no place, when the row is shown or gets another size they are put again
			// (ONPAINT: CM_PAINT of ToolBar)
			if (typeof ResizeObserver !== "undefined") {
				var w0 = -1, h0 = -1;
				new ResizeObserver(function() {
					if (row.clientWidth == w0 && row.clientHeight == h0) return;
					w0 = row.clientWidth; h0 = row.clientHeight;
					// a row which became tall shows the buttons in a column and back (the not pinned panel of the
					// Pin toolbar of the IDE is low when it is closed and tall when it is shown)
					if (row.mffSet && !row.mffPalette && e.clientWidth > 0 && (e.clientHeight > e.clientWidth * 1.5) != row.mffColumn) {
						row.mffSet(row.mffItems);
					}
					if (w0 > 0 && row.querySelector(":scope > .mffgap")) mff.call("ONPAINT", [Id]);
				}).observe(row);
			}
		}
		row.mffSet = function(s) {
			row.mffItems = s;
			var list = s == "" ? [] : s.split("\n");
			// a ToolPalette (the headers of its groups have G in Options): a header and a separator are a whole row, the
			// buttons of a group are laid out in rows of the same width under it (like the List style of Windows). The size
			// of the element is not used: in a page of a TabControl which is not selected it is 0
			var palette = list.some(function(item) { return (item.split("\t")[2] || "").indexOf("G") >= 0; });
			// a tall element shows the buttons in a column
			var column = !palette && e.clientHeight > e.clientWidth * 1.5;
			row.mffPalette = palette;
			row.mffColumn = column;
			row.style.flexDirection = column ? "column" : "row";
			row.style.flexWrap = palette ? "wrap" : "nowrap";
			row.style.alignItems = column ? "stretch" : (palette ? "flex-start" : "center");
			row.style.alignContent = palette ? "flex-start" : "normal";
			// a band of a ReBar gets the width of its buttons (ELEMENTCONTENTWIDTH): a row of a ToolBar has no scroll bars;
			// a column and a palette can be longer than the element
			row.style.overflow = column || palette ? "auto" : "hidden";
			row.style.boxSizing = "border-box";
			// Only the states of the buttons changed (a button was pressed, checked, enabled): the buttons are updated in
			// place, they are not made again (their pictures are not loaded and drawn again)
			var sig = (column ? "C" : "R") + list.map(function(item) {
				var f = item.charAt(0);
				return (f == "3" || f == "6" || f == "7" ? f : "b") + item.substring(1);
			}).join("\n");
			if (row.mffSig === sig && row.children.length == list.length) {
				list.forEach(function(item, i) {
					var b = row.children[i], flag = item.charAt(0);
					if (b.tagName != "BUTTON") return;
					b.disabled = flag == "1";
					b.classList.toggle("mffchecked", flag == "2");
					b.style.display = flag == "4" ? "none" : "inline-flex";
					var img = b.querySelector(":scope > img");
					if (img) img.style.opacity = b.disabled ? "0.4" : "";
					if (b.mffTriangle) b.mffTriangle.style.borderTopColor = b.disabled ? "#aaa" : "#444";
				});
				return;
			}
			row.mffSig = sig;
			row.innerHTML = "";
			// the width of the buttons of a palette: the widest picture with its caption
			var paletteWidth = 0;
			if (palette) {
				var measure = document.createElement("canvas").getContext("2d");
				measure.font = getComputedStyle(e).font || "8pt Tahoma, sans-serif";
				list.forEach(function(item) {
					var parts = item.substring(1).split("\t");
					if ((parts[2] || "").indexOf("G") < 0 && item.charAt(0) != "3") {
						paletteWidth = Math.max(paletteWidth, Math.ceil(measure.measureText(parts[0]).width) + (parts[1] ? 16 + 3 : 0) + 8 + 2);
					}
				});
			}
			list.forEach(function(item, i) {
				// "Flag Text" or "Flag Text\tImage\tOptions\tHint": a button with a picture shows the text as its tooltip,
				// with S in Options the text is by the picture too; D - an arrow of a drop-down menu, W - the whole button
				// opens the menu (ToolBar.UpdateButtons)
				var flag = item.charAt(0), parts = item.substring(1).split("\t");
				var text = parts[0], image = parts[1] || "", options = parts[2] || "", hint = parts[3] || "";
				var showText = options.indexOf("S") >= 0, whole = options.indexOf("W") >= 0, arrow = whole || options.indexOf("D") >= 0;
				var b;
				if (flag == "3") {
					b = document.createElement("span");
					b.style.cssText = palette ? "flex: 0 0 100%; height: 1px; margin: 3px 0; background: var(--mff-border, #aaa);" : column ? "height: 1px; margin: 2px 3px; background: var(--mff-border, #aaa);" : "width: 1px; align-self: stretch; margin: 3px 2px; background: var(--mff-border, #aaa);";
				} else if (flag == "6" || flag == "7") {
					// the place of the control of a custom button (ToolBar.UpdateButtons puts the control over it):
					// "6Width" - a fixed width, "7Width" - it takes the free width of the bar, at least Width
					b = document.createElement("span");
					b.className = "mffgap";
					b.style.cssText = "align-self: stretch; flex: " + (flag == "7" ? "1 1 " : "0 0 ") + (Number(text) || 0) + "px;";
				} else {
					b = document.createElement("button");
					b.type = "button";
					b.disabled = flag == "1";
					// the state "checked" is the class (the same inline styles: SETBUTTONS updates the states in place)
					if (flag == "2") b.classList.add("mffchecked");
					b.style.cssText = "white-space: nowrap; display: inline-flex; align-items: center; gap: 3px;";
					if (image) {
						// the URLs of the picture separated by "|" (FindResourceFile): the next one is tried when one is not there
						var sources = image.split("|");
						var img = document.createElement("img");
						img.src = sources.shift();
						img.alt = text;
						img.style.cssText = "width: 16px; height: 16px; display: block; flex: 0 0 16px;" + (b.disabled ? " opacity: 0.4;" : "");
						b.appendChild(img);
						if (showText) {
							var label = document.createElement("span");
							label.textContent = text;
							label.style.cssText = "overflow: hidden; text-overflow: ellipsis;";
							b.appendChild(label);
						}
						img.addEventListener("error", function() {
							if (sources.length) {
								img.src = sources.shift();
							} else if (showText) {
								// the caption is by it: the place of the picture stays empty
								img.style.visibility = "hidden";
							} else {
								// without the picture file the text is shown
								img.replaceWith(document.createTextNode(text));
							}
						});
						b.title = hint || text;
						// a button with only a picture is not wider than the one of Windows (23 pixels)
						b.style.cssText += " padding: " + (showText || arrow ? "2px 3px" : "2px") + "; background: transparent; border: 1px solid transparent;";
						b.classList.add("mffflat");
					} else {
						b.appendChild(document.createTextNode(text));
						if (hint && hint != text) b.title = hint;
					}
					if (palette) {
						if (options.indexOf("G") >= 0) {
							// the header of a group: a whole row
							b.style.cssText += " font: inherit; flex: 0 0 100%; box-sizing: border-box; justify-content: flex-start; padding: 2px 4px; margin-top: 1px; border: 1px solid var(--mff-border, #c4c4c4); border-radius: 2px; background: var(--mff-face, #ececec);";
							b.classList.add("mffgroup");
						} else {
							// the buttons of a group have the same width, the next one is in the next row when there is no place (the
							// font of the element like on Windows: paletteWidth is measured with it)
							b.style.cssText += " font: inherit; box-sizing: border-box; justify-content: flex-start; width: " + paletteWidth + "px; max-width: 100%;";
						}
					}
					var dropArrow = null;
					if (arrow) {
						// the arrow is a triangle like the one of Windows (7 x 4 pixels), a character of the font is too small
						dropArrow = document.createElement("span");
						dropArrow.style.cssText = "display: inline-flex; align-items: center; align-self: stretch;" + (whole ? "" : " padding-left: 3px; border-left: 1px solid var(--mff-border, #ccc);");
						var triangle = document.createElement("span");
						triangle.style.cssText = "width: 0; height: 0; border-left: 4px solid transparent; border-right: 4px solid transparent; border-top: 4px solid " + (b.disabled ? "var(--mff-disabled, #aaa)" : "var(--mff-glyph, #444)") + ";";
						dropArrow.appendChild(triangle);
						b.mffTriangle = triangle;
						b.appendChild(dropArrow);
					}
					b.addEventListener("click", function(ev) {
						ev.stopPropagation();
						e.setAttribute("data-position", i);
						// the menu of a drop-down button is shown under it (ToolBar.ProcessMessage)
						var r = b.getBoundingClientRect();
						e.setAttribute("data-dropdown", whole || (dropArrow && dropArrow.contains(ev.target)) ? "1" : "0");
						e.setAttribute("data-x", Math.round(r.left));
						e.setAttribute("data-y", Math.round(r.bottom));
						mff.call("ONCHANGE", [Id]);
					}, false);
				}
				if (flag == "4") b.style.display = "none";
				row.appendChild(b);
			});
		};
		row.mffSet(mff.str(Items));
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

	// ---- Printing (PrintDocument, PrintPreviewControl): a page is an offscreen <canvas> of Width x Height pixels
	// (96 DPI, Printer.PrintableWidth) whose Id is the address of the page; the Canvas draws into it like into a control
	// (mff.ctx). It has twice the pixels for the zoom of the preview and the printer
	PAGECREATE__deps: ['$mff'],
	PAGECREATE: function(Id, Width, Height) {
		var c = document.createElement("canvas"), k = 2;
		c.width = Math.max(1, Math.round(Width * k));
		c.height = Math.max(1, Math.round(Height * k));
		c.mffWidth = Width;
		c.mffHeight = Height;
		var g = c.getContext("2d");
		g.setTransform(k, 0, 0, k, 0, 0);
		g.fillStyle = "#fff";
		g.fillRect(0, 0, Width, Height);
		g.beginPath();
		mff.pages[Id] = c;
	},

	PAGEDELETE__deps: ['$mff'],
	PAGEDELETE: function(Id) {
		delete mff.pages[Id];
	},

	// The page PageId in the canvas of the control Id at x, y in w x h (PrintPreviewControl): white paper with a border
	PAGEDRAW__deps: ['$mff'],
	PAGEDRAW: function(Id, PageId, x, y, w, h) {
		var g = mff.ctx(Id, true), page = mff.pages[PageId];
		if (!g) return;
		g.save();
		g.fillStyle = "#fff";
		g.fillRect(x, y, w, h);
		if (page) {
			g.imageSmoothingQuality = "high";
			g.drawImage(page, x, y, w, h);
		}
		g.strokeStyle = "#000";
		g.lineWidth = 1;
		g.strokeRect(x - 0.5, y - 0.5, w + 1, h + 1);
		g.restore();
	},

	// PrintDocument.Print: the pages (their ids separated by spaces) are pictures of a hidden frame which the print
	// dialog of the browser prints (it chooses the printer); @page has the size of the paper of the pages
	PRINTPAGES__deps: ['$mff'],
	PRINTPAGES: function(Ids, Title) {
		var pages = mff.str(Ids).split(" ").filter(function(i) { return i && mff.pages[i]; }).map(function(i) { return mff.pages[i]; });
		if (!pages.length) return;
		var old = document.getElementById("mffprintframe");
		if (old) old.remove();
		var f = document.createElement("iframe");
		f.id = "mffprintframe";
		f.style.cssText = "position: fixed; right: 0; bottom: 0; width: 0; height: 0; border: 0; visibility: hidden;";
		document.body.appendChild(f);
		var mm = function(px) { return (px * 25.4 / 96).toFixed(2) + "mm"; };
		var w = pages[0].mffWidth, h = pages[0].mffHeight, d = f.contentWindow.document;
		d.open();
		d.write("<!doctype html><html><head><meta charset='utf-8'><title></title><style>@page {size: " + mm(w) + " " + mm(h) +
			"; margin: 0;} html, body {margin: 0; padding: 0;} img {display: block; width: " + mm(w) + "; height: calc(" + mm(h) +
			" - 0.5mm); break-after: page;} img:last-child {break-after: auto;}</style></head><body></body></html>");
		d.close();
		d.title = mff.str(Title) || document.title;
		var loads = pages.map(function(p) {
			var img = d.createElement("img");
			img.src = p.toDataURL("image/png");
			d.body.appendChild(img);
			return img.decode ? img.decode().catch(function() {}) : Promise.resolve();
		});
		Promise.all(loads).then(function() {
			f.contentWindow.focus();
			f.contentWindow.print();
		});
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

	CANVASCLIP__deps: ['$mff'],
	CANVASCLIP: function(Id) {
		var g = mff.ctx(Id, false);
		if (g) {
			g.clip();
			g.beginPath();
		}
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

	// The caret of Windows: the pixels of the rectangle are inverted (it is seen on any background)
	CANVASINVERTRECT__deps: ['$mff'],
	CANVASINVERTRECT: function(Id, x, y, w, h) {
		var g = mff.ctx(Id, true);
		if (!g) return;
		g.save();
		g.globalCompositeOperation = "difference";
		g.fillStyle = "#fff";
		g.fillRect(x, y, w, h);
		g.restore();
	},

	CANVASSAVE__deps: ['$mff'],
	CANVASSAVE: function(Id) {
		var g = mff.ctx(Id, true);
		if (g) g.save();
	},

	CANVASROTATE__deps: ['$mff'],
	CANVASROTATE: function(Id, x, y, Angle) {
		var g = mff.ctx(Id, true);
		if (!g) return;
		g.translate(x, y);
		g.rotate(-Angle * Math.PI / 180);
		g.translate(-x, -y);
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

	// MsgBox of Application.bas: a modal dialog like the other windows of the program (the title bar of .mffcaption),
	// the FreeBASIC code waits (ASYNCIFY) for the button. MessageType: 0 - none, 1 - information, 2 - warning,
	// 3 - question, 4 - error. Buttons (ButtonsTypes): 0 - none, 1 - OK, 2 - Yes No, 3 - Yes No Cancel, 4 - OK Cancel.
	// Returns the MessageResult: 1 - Cancel, 3 - No, 4 - OK, 6 - Yes
	MESSAGEBOX__deps: ['$mff', '$Asyncify'],
	MESSAGEBOX__async: true,
	MESSAGEBOX: function(Message, Caption, MessageType, Buttons) {
		var msg = mff.str(Message), ttl = mff.str(Caption);
		var mrCancel = 1, mrNo = 3, mrOK = 4, mrYes = 6;
		var list = [[["OK", mrOK]], [["OK", mrOK]], [["Yes", mrYes], ["No", mrNo]], [["Yes", mrYes], ["No", mrNo], ["Cancel", mrCancel]],
			[["OK", mrOK], ["Cancel", mrCancel]]][Buttons] || [["OK", mrOK]];
		// the button of Esc: Cancel, without it No; a box with only OK closes with OK
		var escResult = list.length == 1 ? list[0][1] : (list.some(function(b) { return b[1] == mrCancel; }) ? mrCancel : mrNo);
		// ASYNCIFY has one wait at a time: in a wait which runs the box of the browser is shown (it waits by itself)
		if (Asyncify.state === Asyncify.State.Normal && mff.cannotWait()) {
			var text = (ttl ? ttl + "\n\n" : "") + msg;
			if (list.length == 1) { alert(text); return list[0][1]; }
			return confirm(text) ? list[0][1] : list[1][1];
		}
		return Asyncify.handleSleep(function(wakeUp) {
			var back = document.createElement("div");
			back.style.cssText = "position: fixed; left: 0; top: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.15); z-index: 10000; display: flex; align-items: center; justify-content: center;";
			var box = document.createElement("div");
			box.style.cssText = "background: var(--mff-window, #fff); color: var(--mff-text, #000); font: 8pt Tahoma, sans-serif; border: 1px solid var(--mff-frame, #5b7fae); border-radius: 6px; " +
				"filter: drop-shadow(0 4px 12px rgba(0, 0, 0, .35)); min-width: 280px; max-width: min(560px, calc(100vw - 32px)); max-height: calc(100vh - 32px); " +
				"display: flex; flex-direction: column; overflow: hidden;";
			var title = document.createElement("div");
			title.style.cssText = "height: 28px; box-sizing: border-box; display: flex; align-items: center; padding: 0 4px 0 10px; " +
				"background: var(--mff-caption, linear-gradient(#f4f8fc, #dce7f3)); border-bottom: 1px solid var(--mff-caption-line, #b9cbe0); color: var(--mff-caption-text, #1e3a5f); font-weight: bold; cursor: move; user-select: none; flex: 0 0 auto;";
			var titleText = document.createElement("span");
			titleText.textContent = ttl || document.title;
			titleText.style.cssText = "flex: 1 1 auto; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;";
			var x = document.createElement("div");
			x.textContent = "✕";
			x.title = "Close";
			x.style.cssText = "flex: 0 0 auto; width: 30px; height: 20px; line-height: 20px; text-align: center; border-radius: 4px; color: var(--mff-caption-button, #44546a); font-size: 12px; font-weight: normal;";
			x.onmouseenter = function() { x.style.background = "#e81123"; x.style.color = "#fff"; };
			x.onmouseleave = function() { x.style.background = ""; x.style.color = "var(--mff-caption-button, #44546a)"; };
			title.appendChild(titleText);
			title.appendChild(x);
			var body = document.createElement("div");
			body.style.cssText = "display: flex; align-items: flex-start; gap: 12px; padding: 18px 20px 16px 16px; overflow: auto;";
			// the icon of the message type: a circle with a sign like the icons of Windows
			var icons = [null, ["i", "#1e6fd9"], ["!", "#e8a200"], ["?", "#1e6fd9"], ["✕", "#d93025"]];
			var icon = icons[MessageType];
			if (icon) {
				var ic = document.createElement("div");
				ic.textContent = icon[0];
				ic.style.cssText = "flex: 0 0 32px; width: 32px; height: 32px; border-radius: 50%; background: " + icon[1] +
					"; color: #fff; font: bold 18px Georgia, serif; display: flex; align-items: center; justify-content: center;" +
					(MessageType == 2 ? " border-radius: 4px; clip-path: polygon(50% 0, 100% 100%, 0 100%); padding-top: 6px; box-sizing: border-box; font-size: 15px;" : "");
				body.appendChild(ic);
			}
			var text = document.createElement("div");
			text.textContent = msg;
			text.style.cssText = "white-space: pre-wrap; word-break: break-word; line-height: 1.4; padding-top: " + (icon ? "7px" : "0") + ";";
			body.appendChild(text);
			var bar = document.createElement("div");
			bar.style.cssText = "display: flex; justify-content: flex-end; gap: 8px; padding: 10px 12px; background: var(--mff-face, #f0f0f0); border-top: 1px solid var(--mff-line, #dfdfdf); flex: 0 0 auto;";
			var done = false, buttons = [];
			function close(result) {
				if (done) return;
				done = true;
				document.removeEventListener("keydown", onKey, true);
				if (back.parentNode) back.parentNode.removeChild(back);
				wakeUp(result);
			}
			list.forEach(function(item) {
				var b = document.createElement("button");
				b.type = "button";
				b.textContent = item[0];
				b.style.cssText = "min-width: 75px; height: 23px; font: inherit; padding: 0 10px;";
				b.addEventListener("click", function() { close(item[1]); });
				bar.appendChild(b);
				buttons.push(b);
			});
			x.addEventListener("click", function() { close(escResult); });
			// the box is moved by its title bar like the other windows
			title.addEventListener("mousedown", function(ev) {
				if (ev.button != 0 || ev.target === x) return;
				ev.preventDefault();
				var r = box.getBoundingClientRect(), dx = ev.clientX - r.left, dy = ev.clientY - r.top;
				box.style.position = "absolute";
				box.style.left = r.left + "px";
				box.style.top = r.top + "px";
				function move(e) {
					box.style.left = Math.max(0, Math.min(window.innerWidth - 40, e.clientX - dx)) + "px";
					box.style.top = Math.max(0, Math.min(window.innerHeight - 28, e.clientY - dy)) + "px";
				}
				function up() {
					document.removeEventListener("mousemove", move, true);
					document.removeEventListener("mouseup", up, true);
				}
				document.addEventListener("mousemove", move, true);
				document.addEventListener("mouseup", up, true);
			});
			function onKey(e) {
				if (e.key == "Escape") { e.preventDefault(); e.stopPropagation(); close(escResult); }
				else if (e.key == "Enter") {
					e.preventDefault(); e.stopPropagation();
					var i = buttons.indexOf(document.activeElement);
					close(list[i >= 0 ? i : 0][1]);
				} else if (e.key == "Tab" || e.key == "ArrowLeft" || e.key == "ArrowRight") {
					// the focus stays on the buttons of the box
					e.preventDefault(); e.stopPropagation();
					var j = buttons.indexOf(document.activeElement), d = (e.key == "ArrowLeft" || (e.key == "Tab" && e.shiftKey)) ? -1 : 1;
					buttons[((j < 0 ? 0 : j) + d + buttons.length) % buttons.length].focus();
				} else {
					e.stopPropagation();
				}
			}
			document.addEventListener("keydown", onKey, true);
			box.appendChild(title);
			box.appendChild(body);
			box.appendChild(bar);
			back.appendChild(box);
			document.body.appendChild(back);
			buttons[0].focus();
		});
	},

	// Regular expressions of Regex.bas. Flags: 1 - ignore case, 2 - multiline, 4 - dot matches all,
	// 8 - extended (the spaces and # comments are removed from the pattern, RegExp has no such flag)
	REGEXCOMPILE__deps: ['$mff'],
	REGEXCOMPILE: function(Pattern, Flags) {
		// d - the start and end of each group (match.indices)
		var pattern = mff.str(Pattern), flags = "dgu";
		if (Flags & 1) flags += "i";
		if (Flags & 2) flags += "m";
		if (Flags & 4) flags += "s";
		if (Flags & 8) pattern = pattern.replace(/\\.|\[(?:\\.|[^\]])*\]|#[^\n]*|\s+/g, function(t) { return t[0] == "\\" || t[0] == "[" ? t : ""; });
		if (!mff.regex) mff.regex = { next: 1, items: {}, error: "" };
		try {
			var id = mff.regex.next++;
			mff.regex.items[id] = new RegExp(pattern, flags);
			mff.regex.error = "";
			return id;
		} catch (err) {
			mff.regex.error = err.message;
			return 0;
		}
	},

	REGEXERROR__deps: ['$mff'],
	REGEXERROR: function() {
		return stringToNewUTF8(mff.regex ? mff.regex.error : "");
	},

	REGEXFREE__deps: ['$mff'],
	REGEXFREE: function(Id) {
		if (mff.regex) delete mff.regex.items[Id];
	},

	// Subject is UTF-8, StartByte and Offsets are UTF-8 byte offsets (-1 - the group did not match)
	REGEXEXEC__deps: ['$mff', '$lengthBytesUTF8'],
	REGEXEXEC: function(Id, Subject, StartByte, Offsets, MaxGroups) {
		var re = mff.regex && mff.regex.items[Id];
		if (!re) return 0;
		var data = HEAPU32[Subject >> 2], len = HEAP32[(Subject >> 2) + 1];
		var s = data ? UTF8ToString(data, len) : "";
		var start = data && StartByte > 0 ? UTF8ToString(data, StartByte).length : 0;
		re.lastIndex = start;
		var m = re.exec(s);
		if (!m) return 0;
		var count = Math.min(m.length, MaxGroups);
		for (var i = 0; i < count; i++) {
			var b = -1, e = -1, r = m.indices[i];
			if (r) {
				b = lengthBytesUTF8(s.substring(0, r[0]));
				e = b + lengthBytesUTF8(s.substring(r[0], r[1]));
			}
			HEAP32[(Offsets >> 2) + 2 * i] = b;
			HEAP32[(Offsets >> 2) + 2 * i + 1] = e;
		}
		return count;
	},

	// Modal dialogs of Dialogs.bas: the FreeBASIC code waits (ASYNCIFY) until the dialog is closed
	$mffDialog__deps: ['$mff', '$Asyncify'],
	$mffDialog: {
		// A dialog box over the page: build(box, close) fills it, close(result) removes it and returns result
		show: function(caption, build) {
			// ASYNCIFY has one wait at a time: in the events of a modal form (MODALWAIT) the dialog is "cancelled"
			// (a rewind - the wait of this dialog ends - goes to handleSleep)
			if (Asyncify.state === Asyncify.State.Normal && mff.cannotWait()) return 0;
			return Asyncify.handleSleep(function(wakeUp) {
				// a window like the other ones of the program (MsgBox): the title bar (moves it, its close button
				// presses Cancel), the content box of build
				var back = document.createElement("div");
				back.style.cssText = "position: fixed; left: 0; top: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.15); z-index: 10000; display: flex; align-items: center; justify-content: center;";
				var win = document.createElement("div");
				win.style.cssText = "background: var(--mff-window, #fff); color: var(--mff-text, #000); font: 8pt Tahoma, sans-serif; border: 1px solid var(--mff-frame, #5b7fae); border-radius: 6px; " +
					"filter: drop-shadow(0 4px 12px rgba(0, 0, 0, .35)); width: 440px; max-width: calc(100vw - 32px); max-height: calc(100vh - 32px); " +
					"display: flex; flex-direction: column; overflow: hidden;";
				var title = document.createElement("div");
				title.style.cssText = "height: 28px; box-sizing: border-box; display: flex; align-items: center; padding: 0 4px 0 10px; " +
					"background: var(--mff-caption, linear-gradient(#f4f8fc, #dce7f3)); border-bottom: 1px solid var(--mff-caption-line, #b9cbe0); color: var(--mff-caption-text, #1e3a5f); font-weight: bold; cursor: move; user-select: none; flex: 0 0 auto;";
				var titleText = document.createElement("span");
				titleText.textContent = caption;
				titleText.style.cssText = "flex: 1 1 auto; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;";
				var x = document.createElement("div");
				x.textContent = "✕";
				x.title = "Close";
				x.style.cssText = "flex: 0 0 auto; width: 30px; height: 20px; line-height: 20px; text-align: center; border-radius: 4px; color: var(--mff-caption-button, #44546a); font-size: 12px; font-weight: normal; cursor: default;";
				x.onmouseenter = function() { x.style.background = "#e81123"; x.style.color = "#fff"; };
				x.onmouseleave = function() { x.style.background = ""; x.style.color = "var(--mff-caption-button, #44546a)"; };
				title.appendChild(titleText);
				title.appendChild(x);
				var box = document.createElement("div");
				box.className = "mffdialogbox";
				box.style.cssText = "padding: 12px; box-sizing: border-box; display: flex; flex-direction: column; gap: 8px; overflow: auto;";
				win.appendChild(title);
				win.appendChild(box);
				back.appendChild(win);
				document.body.appendChild(back);
				title.addEventListener("mousedown", function(ev) {
					if (ev.button != 0 || ev.target === x) return;
					ev.preventDefault();
					var r = win.getBoundingClientRect(), dx = ev.clientX - r.left, dy = ev.clientY - r.top;
					win.style.position = "absolute";
					win.style.left = r.left + "px";
					win.style.top = r.top + "px";
					function move(e) {
						win.style.left = Math.max(0, Math.min(window.innerWidth - 40, e.clientX - dx)) + "px";
						win.style.top = Math.max(0, Math.min(window.innerHeight - 28, e.clientY - dy)) + "px";
					}
					function up() {
						document.removeEventListener("mousemove", move, true);
						document.removeEventListener("mouseup", up, true);
					}
					document.addEventListener("mousemove", move, true);
					document.addEventListener("mouseup", up, true);
				});
				var done = false;
				function close(result) {
					if (done) return;
					done = true;
					document.body.removeChild(back);
					wakeUp(result);
				}
				x.addEventListener("click", function() {
					var cancel = [...box.querySelectorAll("button")].filter(function(b) { return b.textContent == "Cancel"; })[0];
					if (cancel) cancel.click(); else close(0);
				});
				build(box, close);
				// the row of the buttons is at the right side (the last row of build)
				var rows = box.querySelectorAll(":scope > div");
				if (rows.length && rows[rows.length - 1].querySelector("button")) rows[rows.length - 1].style.justifyContent = "flex-end";
			});
		},
		row: function(parent) {
			var r = document.createElement("div");
			r.style.cssText = "display: flex; gap: 6px; align-items: center; flex-wrap: wrap;";
			parent.appendChild(r);
			return r;
		},
		button: function(parent, text, onclick) {
			var b = document.createElement("button");
			b.textContent = text;
			b.type = "button";
			b.style.cssText = "min-width: 75px; height: 23px; font: inherit; padding: 0 10px;";
			b.onclick = onclick;
			parent.appendChild(b);
			return b;
		},
		input: function(parent, type, value) {
			var i = document.createElement("input");
			i.type = type;
			i.value = value;
			i.style.font = "inherit";
			parent.appendChild(i);
			return i;
		},
		// "Text files|*.txt;*.log|All files|*.*" -> [{ text: "Text files", re: /^(.*\.txt|.*\.log)$/i }, ...]
		filters: function(filter) {
			var parts = filter.split("|"), result = [];
			for (var i = 0; i + 1 < parts.length; i += 2) {
				var globs = parts[i + 1].split(";").map(function(g) {
					return g.trim().replace(/[.+^${}()|[\]\\]/g, "\\$&").replace(/\*/g, ".*").replace(/\?/g, ".");
				});
				// ext - the extension of the first pattern ("*.bas" - ".bas") which Save adds to a name without it
				var first = parts[i + 1].split(";")[0].trim();
				result.push({ text: parts[i], re: new RegExp("^(" + globs.join("|") + ")$", "i"), ext: /^\*\.[^*?]+$/.test(first) ? first.substring(1) : "" });
			}
			return result;
		},
		join: function(dir, name) {
			return (dir == "/" ? "" : dir.replace(/\/+$/, "")) + "/" + name;
		},
		isDir: function(path) {
			try { return FS.isDir(FS.stat(path).mode); } catch (err) { return false; }
		},
		parent: function(dir) {
			return dir.substring(0, dir.replace(/\/+$/, "").lastIndexOf("/")) || "/";
		},
		// The pictures of the file list (fileView) and of its view buttons (viewButtons)
		icon: function(name) {
			var svg = {
				folder: "<path d='M2 6.5h10l3 3h15v18H2z' fill='#e8b73d' stroke='#b88a1b'/><path d='M2 12.5h28v15H2z' fill='#ffd766' stroke='#c99a2e'/>",
				up: "<path d='M2 6.5h10l3 3h15v18H2z' fill='#e8b73d' stroke='#b88a1b'/><path d='M2 12.5h28v15H2z' fill='#ffd766' stroke='#c99a2e'/><path d='M16 15l-5 5h3v4h4v-4h3z' fill='#2e6fbd'/>",
				file: "<path d='M7 2.5h13l6 6v21H7z' fill='#fff' stroke='#7a7a7a'/><path d='M20 2.5v6h6' fill='#e6e6e6' stroke='#7a7a7a'/><path d='M10 14h13M10 18h13M10 22h9' stroke='#a8a8a8'/>",
				icon: "<path d='M3 3h11v11H3zM18 3h11v11H18zM3 18h11v11H3zM18 18h11v11H18z' fill='#5b7fae'/>",
				list: "<path d='M3 5h5v5H3zM3 14h5v5H3zM3 23h5v5H3z' fill='#5b7fae'/><path d='M11 7.5h18M11 16.5h18M11 25.5h18' stroke='#5b7fae' stroke-width='3'/>"
			}[name];
			return "data:image/svg+xml," + encodeURIComponent("<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'>" + svg + "</svg>");
		},
		// The folders and the files of a folder of FS like the file list of the dialogs of Windows (SHOWFILEDIALOG,
		// FILEVIEWFILL): the view "icon" (large icons in rows) or "list" (small icons in columns, .mfffileview of
		// mff.html), ".." first, then the folders and the files. A click selects (Ctrl and Shift with v.multiple), a
		// double click and Enter call o.onOpen(item), a change of the selection o.onSelect(item); item.mffName is the
		// name, item.mffDir is true for a folder
		fileView: function(parent, o) {
			var d = this, el = document.createElement("div"), v = {el: el, items: [], multiple: false, anchor: -1};
			el.className = "mfffileview";
			el.tabIndex = 0;
			parent.appendChild(el);
			v.view = function(name) {
				if (name) {
					el.setAttribute("data-view", name);
					try { localStorage.setItem("mffFileView", name); } catch (err) { }
					if (v.onView) v.onView(name);
				}
				return el.getAttribute("data-view");
			};
			var saved = null;
			try { saved = localStorage.getItem("mffFileView"); } catch (err) { }
			el.setAttribute("data-view", saved == "icon" ? "icon" : "list");
			// accept(name): the files which are shown, null - only the folders
			v.fill = function(dir, accept) {
				el.innerHTML = "";
				v.items = [];
				v.anchor = -1;
				var dirs = [], files = [];
				try {
					FS.readdir(dir).forEach(function(n) {
						if (n == "." || n == "..") return;
						if (d.isDir(d.join(dir, n))) dirs.push(n);
						else if (accept && accept(n)) files.push(n);
					});
				} catch (err) { }
				var names = (dir != "/" ? [".."] : []).concat(dirs.sort(), files.sort()), nDirs = names.length - files.length;
				names.forEach(function(n, i) {
					var it = document.createElement("div"), img = document.createElement("img"), t = document.createElement("span");
					it.className = "mfffileitem";
					it.title = n;
					it.mffName = n;
					it.mffDir = i < nDirs;
					img.alt = "";
					img.src = d.icon(n == ".." ? "up" : it.mffDir ? "folder" : "file");
					t.textContent = n;
					it.appendChild(img);
					it.appendChild(t);
					el.appendChild(it);
					v.items.push(it);
				});
				el.scrollTop = el.scrollLeft = 0;
			};
			v.selected = function() {
				return v.items.filter(function(it) { return it.classList.contains("mffselected"); });
			};
			function select(i, ctrl, shift) {
				if (i < 0 || i >= v.items.length) return;
				if (v.multiple && shift && v.anchor >= 0) {
					var a = Math.min(v.anchor, i), b = Math.max(v.anchor, i);
					v.items.forEach(function(it, k) { it.classList.toggle("mffselected", k >= a && k <= b); });
				} else if (v.multiple && ctrl) {
					v.items[i].classList.toggle("mffselected");
					v.anchor = i;
				} else {
					v.items.forEach(function(it, k) { it.classList.toggle("mffselected", k == i); });
					v.anchor = i;
				}
				v.items[i].scrollIntoView({block: "nearest", inline: "nearest"});
				if (o.onSelect) o.onSelect(v.items[i]);
			}
			function index(ev) {
				var it = ev.target.closest ? ev.target.closest(".mfffileitem") : null;
				return it ? v.items.indexOf(it) : -1;
			}
			// the items in a line of the view: the step of the arrows across the lines
			function perLine() {
				var prop = v.view() == "icon" ? "offsetTop" : "offsetLeft", n = 0;
				while (n < v.items.length && v.items[n][prop] == v.items[0][prop]) n++;
				return Math.max(1, n);
			}
			el.addEventListener("mousedown", function(ev) {
				if (ev.button != 0) return;
				var i = index(ev);
				if (i >= 0) select(i, ev.ctrlKey || ev.metaKey, ev.shiftKey);
			});
			el.addEventListener("dblclick", function(ev) {
				var i = index(ev);
				if (i >= 0 && o.onOpen) o.onOpen(v.items[i]);
			});
			el.addEventListener("keydown", function(ev) {
				var i = v.anchor, n = v.items.length, line = perLine(), icon = v.view() == "icon";
				var step = {ArrowRight: icon ? 1 : line, ArrowLeft: icon ? -1 : -line, ArrowDown: icon ? line : 1, ArrowUp: icon ? -line : -1}[ev.key];
				if (step) {
					select(i < 0 ? 0 : Math.max(0, Math.min(n - 1, i + step)), false, ev.shiftKey);
				} else if (ev.key == "Home") {
					select(0, false, ev.shiftKey);
				} else if (ev.key == "End") {
					select(n - 1, false, ev.shiftKey);
				} else if (ev.key == "Enter") {
					if (i >= 0 && o.onOpen) o.onOpen(v.items[i]);
				} else if (ev.key == "Backspace") {
					if (n && v.items[0].mffName == ".." && o.onOpen) o.onOpen(v.items[0]);
				} else if (ev.key == "a" && (ev.ctrlKey || ev.metaKey) && v.multiple) {
					v.items.forEach(function(it) { it.classList.toggle("mffselected", !it.mffDir); });
				} else return;
				ev.preventDefault();
			});
			return v;
		},
		// The buttons of the views of a fileView ("Large icons", "List"): the one of the current view is pressed
		viewButtons: function(parent, v) {
			var d = this, buttons = [];
			[["icon", "Large icons"], ["list", "List"]].forEach(function(b) {
				var btn = document.createElement("button"), img = document.createElement("img");
				btn.type = "button";
				btn.className = "mffviewbutton";
				btn.title = b[1];
				btn.mffView = b[0];
				img.alt = b[1];
				img.src = d.icon(b[0]);
				btn.appendChild(img);
				btn.onclick = function() { v.view(b[0]); v.el.focus(); };
				parent.appendChild(btn);
				buttons.push(btn);
			});
			v.onView = function(name) {
				buttons.forEach(function(btn) { btn.toggleAttribute("data-on", btn.mffView == name); });
			};
			v.onView(v.view());
		}
	},

	// Mode: 0 - open, 1 - open several files, 2 - save, 3 - folder. The files are the ones of the virtual file system (FS),
	// a file of the device can be uploaded into it. Returns the paths separated with "\n" or 0 if the dialog was cancelled
	SHOWFILEDIALOG__deps: ['$mff', '$mffDialog', '$FS', '$stringToNewUTF8'],
	SHOWFILEDIALOG__async: true,
	SHOWFILEDIALOG: function(Mode, Caption, InitialDir, FileName, Filter, FilterIndex) {
		var d = mffDialog, fileName = mff.str(FileName), dir = mff.str(InitialDir).replace(/\\/g, "/");
		var filters = d.filters(mff.str(Filter));
		if (fileName.indexOf("/") >= 0) {
			if (!dir) dir = fileName.substring(0, fileName.lastIndexOf("/")) || "/";
			fileName = fileName.substring(fileName.lastIndexOf("/") + 1);
		}
		if (!dir || !d.isDir(dir)) dir = FS.cwd();
		var result = d.show(mff.str(Caption) || ["Open", "Open", "Save As", "Select Folder"][Mode], function(box, close) {
			// the folder with the buttons of the views, the file list of Windows (fileView) under it
			box.parentNode.style.width = "600px";
			var top = d.row(box);
			top.style.flexWrap = "nowrap";
			var path = d.input(top, "text", dir);
			path.style.flex = "1";
			path.style.minWidth = "0";
			var list = d.fileView(box, {
				onSelect: function(it) {
					if (name && !it.mffDir) name.value = it.mffName;
				},
				onOpen: function(it) {
					if (it.mffDir) open(it.mffName);
					else if (Mode != 3) { name.value = it.mffName; ok(); }
				}
			});
			list.multiple = Mode == 1;
			list.el.style.height = "260px";
			d.viewButtons(top, list);
			var name = null, type = null;
			if (Mode != 3) {
				name = d.input(d.row(box), "text", fileName);
				name.style.flex = "1";
				name.placeholder = "File name";
				if (filters.length) {
					type = document.createElement("select");
					filters.forEach(function(f, i) { type.add(new Option(f.text, i)); });
					type.selectedIndex = Math.max(0, Math.min(FilterIndex - 1, filters.length - 1));
					type.onchange = fill;
					name.parentNode.appendChild(type);
				}
			}
			function fill() {
				path.value = dir;
				var re = type ? filters[type.selectedIndex].re : null;
				list.fill(dir, Mode == 3 ? null : function(n) { return !re || re.test(n); });
			}
			function open(n) {
				dir = n == ".." ? d.parent(dir) : d.join(dir, n);
				fill();
			}
			function ok() {
				if (Mode == 3) {
					var sel = list.selected()[0];
					close(sel && sel.mffName != ".." ? d.join(dir, sel.mffName) : dir);
					return;
				}
				var names = Mode == 1 ? list.selected().filter(function(it) { return !it.mffDir; }).map(function(it) { return it.mffName; }) : [];
				if (!names.length && name.value) names = [name.value];
				if (!names.length) return;
				if (Mode == 2 && type && !d.isDir(names[0].charAt(0) == "/" ? names[0] : d.join(dir, names[0]))) {
					var f = filters[type.selectedIndex], title = names[0].substring(names[0].lastIndexOf("/") + 1);
					if (f.ext && !f.re.test(title)) names[0] += f.ext;
				}
				var paths = names.map(function(n) { return n.charAt(0) == "/" ? n : d.join(dir, n); });
				if (paths.length == 1 && d.isDir(paths[0])) { dir = paths[0]; name.value = ""; fill(); return; }
				if (Mode == 2) {
					if (FS.analyzePath(paths[0]).exists && !confirm(paths[0] + "\n\nThe file already exists. Replace it?")) return;
				} else if (!paths.every(function(p) { return FS.analyzePath(p).exists; })) {
					alert("The file was not found.");
					return;
				}
				close(paths.join("\n"));
			}
			path.onkeydown = function(e) {
				if (e.key == "Enter" && d.isDir(path.value)) { dir = path.value; fill(); }
			};
			if (name) name.onkeydown = function(e) { if (e.key == "Enter") ok(); };
			var buttons = d.row(box);
			buttons.style.justifyContent = "flex-end";
			if (Mode <= 1) {
				// A file of the device is copied into the current folder of the virtual file system
				d.button(buttons, "Upload...", function() {
					var f = document.createElement("input");
					f.type = "file";
					f.multiple = true;
					f.onchange = function() {
						var pending = f.files.length;
						Array.prototype.forEach.call(f.files, function(file) {
							file.arrayBuffer().then(function(buf) {
								FS.writeFile(d.join(dir, file.name), new Uint8Array(buf));
								if (--pending == 0) { fill(); name.value = file.name; }
							});
						});
					};
					f.click();
				});
			} else {
				d.button(buttons, "New folder", function() {
					var n = prompt("Folder name:");
					if (!n) return;
					try { FS.mkdir(d.join(dir, n)); } catch (err) { alert(err.message || err); }
					fill();
				});
			}
			d.button(buttons, Mode == 2 ? "Save" : "OK", ok);
			d.button(buttons, "Cancel", function() { close(""); });
			fill();
			(name || list.el).focus();
		});
		return result ? stringToNewUTF8(result) : 0;
	},

	// The file list of an OpenFileControl (OpenFileControl.bas): the fileView of the file dialogs with the buttons of its
	// views over it, the files of the patterns ("*.bas;*.bi") in the folder Dir. A double click on a folder opens it here.
	// A change calls ONCHANGE with data-event "select" (the selection), "activate" (a double click on a file) or "folder"
	// (another folder), data-dir - the folder, data-files - the chosen files separated with "\n"
	FILEVIEWFILL__deps: ['$mff', '$mffDialog', '$FS'],
	FILEVIEWFILL: function(Id, Dir, Patterns, Multiple) {
		var e = mff.el(Id), d = mffDialog;
		if (!e) return;
		var v = e.mffFileView;
		if (!v) {
			var wrap = document.createElement("div"), bar = document.createElement("div");
			wrap.className = "mfffileviewhost";
			bar.className = "mfffileviewbar";
			wrap.appendChild(bar);
			e.appendChild(wrap);
			function report(ev) {
				e.setAttribute("data-dir", v.dir);
				e.setAttribute("data-files", v.selected().filter(function(it) { return !it.mffDir; }).map(function(it) { return d.join(v.dir, it.mffName); }).join("\n"));
				e.setAttribute("data-event", ev);
				mff.call("ONCHANGE", [Id]);
			}
			v = e.mffFileView = d.fileView(wrap, {
				onSelect: function() { report("select"); },
				onOpen: function(it) {
					if (!it.mffDir) { report("activate"); return; }
					v.dir = it.mffName == ".." ? d.parent(v.dir) : d.join(v.dir, it.mffName);
					v.fill(v.dir, v.accept);
					report("folder");
				}
			});
			d.viewButtons(bar, v);
		}
		var dir = mff.str(Dir).replace(/\\/g, "/") || "/";
		if (!d.isDir(dir)) dir = FS.cwd();
		var re = d.filters("|" + (mff.str(Patterns) || "*"))[0].re;
		v.multiple = Multiple != 0;
		v.dir = dir;
		v.accept = function(n) { return re.test(n); };
		v.fill(dir, v.accept);
		e.setAttribute("data-dir", dir);
		e.setAttribute("data-files", "");
	},

	// Style: 1 - bold, 2 - italic, 4 - underline, 8 - strikeout. Returns "Name\nSize\nStyle\nColor" or 0 if the dialog was cancelled
	SHOWFONTDIALOG__deps: ['$mff', '$mffDialog', '$stringToNewUTF8'],
	SHOWFONTDIALOG__async: true,
	SHOWFONTDIALOG: function(FontName, Size, Style, Color) {
		var d = mffDialog;
		var result = d.show("Font", function(box, close) {
			var r1 = d.row(box);
			var name = d.input(r1, "text", mff.str(FontName));
			name.style.flex = "1";
			name.setAttribute("list", "mff-fonts");
			var fonts = document.createElement("datalist");
			fonts.id = "mff-fonts";
			["Arial", "Consolas", "Courier New", "Georgia", "Segoe UI", "Tahoma", "Times New Roman", "Verdana", "monospace", "sans-serif", "serif"].forEach(function(f) { fonts.appendChild(new Option(f)); });
			r1.appendChild(fonts);
			var size = d.input(r1, "number", Size || 10);
			size.min = 1;
			size.style.width = "60px";
			var color = d.input(r1, "color", "#" + [Color & 255, (Color >> 8) & 255, (Color >> 16) & 255].map(function(c) { return ("0" + c.toString(16)).slice(-2); }).join(""));
			var r2 = d.row(box), checks = [];
			["Bold", "Italic", "Underline", "Strikeout"].forEach(function(text, i) {
				var l = document.createElement("label");
				var c = document.createElement("input");
				c.type = "checkbox";
				c.checked = (Style & (1 << i)) != 0;
				c.onchange = preview;
				l.appendChild(c);
				l.appendChild(document.createTextNode(" " + text));
				r2.appendChild(l);
				checks.push(c);
			});
			var sample = document.createElement("div");
			sample.textContent = "AaBbYyZz 0123";
			sample.style.cssText = "border: 1px solid var(--mff-border, #ccc); padding: 8px; min-height: 40px; overflow: hidden;";
			box.appendChild(sample);
			function style() {
				return checks.reduce(function(s, c, i) { return s | (c.checked ? 1 << i : 0); }, 0);
			}
			function preview() {
				var s = style();
				sample.style.fontFamily = "'" + name.value + "'";
				sample.style.fontSize = size.value + "pt";
				sample.style.fontWeight = s & 1 ? "bold" : "normal";
				sample.style.fontStyle = s & 2 ? "italic" : "normal";
				sample.style.textDecoration = [s & 4 ? "underline" : "", s & 8 ? "line-through" : ""].join(" ").trim() || "none";
				sample.style.color = color.value;
			}
			name.oninput = size.oninput = color.oninput = preview;
			preview();
			var buttons = d.row(box);
			buttons.style.justifyContent = "flex-end";
			d.button(buttons, "OK", function() {
				var c = parseInt(color.value.slice(1), 16);
				close([name.value, size.value, style(), ((c & 255) << 16) | (c & 0xFF00) | ((c >> 16) & 255)].join("\n"));
			});
			d.button(buttons, "Cancel", function() { close(""); });
		});
		return result ? stringToNewUTF8(result) : 0;
	},

	// Color is BGR (&hBBGGRR). Returns the chosen color or -1 if the dialog was cancelled
	SHOWCOLORDIALOG__deps: ['$mff', '$mffDialog'],
	SHOWCOLORDIALOG__async: true,
	SHOWCOLORDIALOG: function(Caption, Color) {
		var d = mffDialog;
		return d.show(mff.str(Caption) || "Color", function(box, close) {
			var color = d.input(box, "color", "#" + [Color & 255, (Color >> 8) & 255, (Color >> 16) & 255].map(function(c) { return ("0" + c.toString(16)).slice(-2); }).join(""));
			color.style.cssText = "width: 100%; height: 48px;";
			var buttons = d.row(box);
			buttons.style.justifyContent = "flex-end";
			d.button(buttons, "OK", function() {
				var c = parseInt(color.value.slice(1), 16);
				close(((c & 255) << 16) | (c & 0xFF00) | ((c >> 16) & 255));
			});
			d.button(buttons, "Cancel", function() { close(-1); });
		});
	},

	// The bar of the main menu of the main form: it is before the form (in the margin of the form at the top), so
	// fitMainForm gives the form the height under it. Captions: separated by "\n", "" - a hidden item. A press on an
	// item calls ONMAINMENU with the index of the item and the place under it for the popup menu of its items
	SETMAINMENU__deps: ['$mff'],
	SETMAINMENU: function(Id, Captions) {
		var form = mff.el(Id);
		if (!form) return;
		var bar = mff.el(String(Id) + "MainMenu");
		if (!bar) {
			bar = document.createElement("div");
			bar.id = String(Id) + "MainMenu";
			bar.className = "unselectable";
			bar.style.cssText = "display: flex; flex-wrap: wrap; box-sizing: border-box; background: var(--mff-face, #f0f0f0); color: var(--mff-text, #000); border: 1px solid var(--mff-border, #ccc); border-bottom: none; font: 8pt Tahoma, sans-serif; user-select: none;";
			bar.style.marginLeft = form.style.marginLeft;
			bar.style.marginTop = form.style.marginTop;
			bar.style.width = form.offsetWidth + "px";
			form.style.marginTop = "0px";
			form.insertAdjacentElement("beforebegin", bar);
		}
		bar.innerHTML = "";
		mff.str(Captions).split("\n").forEach(function(Caption, Index) {
			if (Caption == "") return;
			var item = document.createElement("div");
			item.textContent = Caption;
			item.style.cssText = "padding: 3px 8px; cursor: default; white-space: nowrap;";
			item.className = "mffmenubaritem";
			item.addEventListener("mouseenter", function() { if (mff.menuBarItem != item) item.style.background = "var(--mff-menu-hover, #dde8f5)"; });
			item.addEventListener("mouseleave", function() { if (mff.menuBarItem != item) item.style.background = ""; });
			item.addEventListener("mousedown", function(e) {
				e.preventDefault();
				// a popup waits already (ASYNCIFY has one wait at a time): its back element gets the presses
				if (mff.popupOpen) return;
				// the item of the open menu stays marked until its popup closes (SHOWPOPUPMENU)
				mff.menuBarItem = item;
				item.style.background = "var(--mff-hot, #cce4ff)";
				var r = item.getBoundingClientRect();
				mff.call("ONMAINMENU", [Id, Index, Math.round(r.left), Math.round(r.bottom)]);
			});
			bar.appendChild(item);
		});
		// the form gets the height under the bar
		window.dispatchEvent(new Event("resize"));
	},

	// Application.DoEvents: the browser draws the page (ASYNCIFY). Not in a wait which runs (a modal form, MODALWAIT):
	// a second wait would overwrite the data of that one
	PAGESLEEP__deps: ['$mff', '$Asyncify'],
	PAGESLEEP__async: true,
	PAGESLEEP: function(ms) {
		if (Asyncify.state === Asyncify.State.Normal && mff.cannotWait()) return;
		return Asyncify.handleSleep(function(wakeUp) {
			mff.pageSleep = true;
			setTimeout(function() { mff.pageSleep = false; wakeUp(); }, ms);
		});
	},

	// Form.ShowModal: the FreeBASIC code waits (ASYNCIFY) until the form Id is closed (removed, CloseForm) or hidden
	// (Hide); the events of the page run meanwhile. A back element under the form takes the presses of the rest of
	// the page. ASYNCIFY has one wait at a time: a modal form shown in the events of another one does not wait (0)
	MODALWAIT__deps: ['$mff', '$Asyncify'],
	MODALWAIT__async: true,
	MODALWAIT: function(Id) {
		var e = mff.el(Id);
		// the check is not done in a rewind (the wait ends): then the form is closed already and handleSleep returns
		if (Asyncify.state === Asyncify.State.Normal && (!e || mff.cannotWait())) return 0;
		return Asyncify.handleSleep(function(wakeUp) {
			mff.modalWait = true;
			var back = document.createElement("div");
			back.style.cssText = "position: fixed; left: 0; top: 0; right: 0; bottom: 0; z-index: 999;";
			e.parentNode.insertBefore(back, e);
			var timer = setInterval(function() {
				if (e.isConnected && e.style.display != "none") return;
				clearInterval(timer);
				if (back.parentNode) back.parentNode.removeChild(back);
				mff.modalWait = false;
				wakeUp(1);
			}, 50);
		});
	},

	// A popup menu at x, y (the pixels of the page). Items: the lines "Level\tEnabled\tChecked\tImage\tCaption"; a submenu opens
	// over its item. The FreeBASIC code waits (ASYNCIFY) for the index of the chosen line, -1 if the menu was closed
	SHOWPOPUPMENU__deps: ['$mff', '$Asyncify'],
	SHOWPOPUPMENU__async: true,
	SHOWPOPUPMENU: function(Items, x, y) {
		var lines = mff.str(Items).split("\n").filter(function(l) { return l.length; }).map(function(l, i) {
			var p = l.split("\t");
			return { index: i, level: +p[0], enabled: p[1] == "1", checked: p[2] == "1", image: p[3], caption: p.slice(4).join("\t"), items: [] };
		});
		// The tree of the items
		var root = { items: [] }, stack = [root];
		lines.forEach(function(it) {
			stack.length = Math.min(stack.length, it.level + 1);
			(stack[stack.length - 1] || root).items.push(it);
			stack.push(it);
		});
		// ASYNCIFY has one wait at a time: a second popup (a timer, a key while a popup waits) is "nothing chosen"
		if (mff.popupOpen || (Asyncify.state === Asyncify.State.Normal && mff.cannotWait())) return -1;
		return Asyncify.handleSleep(function(wakeUp) {
			mff.popupOpen = true;
			var menus = [], done = false;
			var back = document.createElement("div");
			back.style.cssText = "position: fixed; left: 0; top: 0; right: 0; bottom: 0; z-index: 10001;";
			document.body.appendChild(back);
			// the popup of an item of the bar of the main menu (SETMAINMENU)
			var barItem = mff.menuBarItem || null;
			function close(result) {
				if (done) return;
				done = true;
				document.body.removeChild(back);
				document.removeEventListener("keydown", onKey, true);
				if (barItem) {
					barItem.style.background = "";
					if (mff.menuBarItem == barItem) mff.menuBarItem = null;
				}
				mff.popupOpen = false;
				wakeUp(result);
			}
			// The bar item under the pointer (the back element covers the page)
			function barItemAt(x, y) {
				if (!barItem || !barItem.parentElement) return null;
				var items = barItem.parentElement.children;
				for (var j = 0; j < items.length; j++) {
					var r = items[j].getBoundingClientRect();
					if (x >= r.left && x < r.right && y >= r.top && y < r.bottom) return items[j];
				}
				return null;
			}
			// Moving over another item of the bar opens its menu (like a menu bar of Windows); a press on the
			// item of this menu closes it
			back.addEventListener("mousemove", function(e) {
				var other = barItemAt(e.clientX, e.clientY);
				if (!other || other == barItem) return;
				close(-1);
				setTimeout(function() { other.dispatchEvent(new MouseEvent("mousedown", { bubbles: true, cancelable: true })); }, 0);
			});
			back.addEventListener("mousedown", function(e) {
				if (barItemAt(e.clientX, e.clientY) == barItem && barItem) { e.preventDefault(); close(-1); }
			});
			function onKey(e) {
				if (e.key == "Escape") { e.preventDefault(); close(-1); }
			}
			document.addEventListener("keydown", onKey, true);
			back.addEventListener("mousedown", function(e) { if (e.target == back) close(-1); });
			back.addEventListener("contextmenu", function(e) { e.preventDefault(); });
			function show(items, left, top, depth) {
				while (menus.length > depth) back.removeChild(menus.pop());
				var m = document.createElement("div");
				m.style.cssText = "position: absolute; background: var(--mff-window, #fff); color: var(--mff-text, #000); font: 8pt Tahoma, sans-serif; border: 1px solid var(--mff-border, #aaa); box-shadow: 2px 2px 8px rgba(0, 0, 0, 0.25); padding: 2px 0; min-width: 160px;";
				items.forEach(function(it) {
					var row = document.createElement("div");
					if (it.caption == "-") {
						row.style.cssText = "border-top: 1px solid var(--mff-line, #ddd); margin: 3px 0;";
						m.appendChild(row);
						return;
					}
					row.style.cssText = "padding: 4px 24px 4px 28px; white-space: nowrap; position: relative; cursor: default; display: flex;" + (it.enabled ? "" : " color: var(--mff-disabled, #999);");
					// "Caption\tShortcut": the shortcut is at the right
					var parts = it.caption.replace(/&(.)/g, "$1").split("\t");
					var text = document.createElement("span");
					text.textContent = parts[0];
					text.style.cssText = "flex: 1;";
					row.appendChild(text);
					if (parts[1]) {
						var k = document.createElement("span");
						k.textContent = parts[1];
						k.style.cssText = "margin-left: 24px; color: " + (it.enabled ? "var(--mff-gray, #555)" : "var(--mff-disabled, #aaa)") + ";";
						row.appendChild(k);
					}
					if (it.checked) {
						var c = document.createElement("span");
						c.textContent = "\u2713";
						c.style.cssText = "position: absolute; left: 8px;";
						row.appendChild(c);
					} else if (it.image) {
						var img = document.createElement("img");
						img.src = it.image;
						img.style.cssText = "position: absolute; left: 5px; top: 50%; margin-top: -8px; width: 16px; height: 16px;" + (it.enabled ? "" : " opacity: 0.4;");
						img.addEventListener("error", function() { img.remove(); });
						row.appendChild(img);
					}
					if (it.items.length) {
						var a = document.createElement("span");
						a.textContent = "\u25B8";
						a.style.cssText = "position: absolute; right: 8px;";
						row.appendChild(a);
					}
					row.onmouseenter = function() {
						row.style.background = it.enabled ? "var(--mff-hot, #cce4ff)" : "";
						if (it.items.length && it.enabled) {
							var r = row.getBoundingClientRect();
							show(it.items, r.right - 2, r.top - 3, depth + 1);
						} else {
							while (menus.length > depth + 1) back.removeChild(menus.pop());
						}
					};
					row.onmouseleave = function() { row.style.background = ""; };
					row.onclick = function() {
						if (!it.enabled || it.items.length) return;
						close(it.index);
					};
					m.appendChild(row);
				});
				back.appendChild(m);
				menus.push(m);
				// The menu stays in the window
				var w = m.offsetWidth, h = m.offsetHeight;
				m.style.left = Math.max(0, Math.min(left, window.innerWidth - w)) + "px";
				m.style.top = Math.max(0, Math.min(top, window.innerHeight - h)) + "px";
			}
			show(root.items, x, y, 0);
		});
	},

	// The system clipboard. Reading waits (ASYNCIFY) for navigator.clipboard; the text written here is the answer
	// when the browser does not allow reading (no permission, no secure context)
	CLIPBOARDSETTEXT__deps: ['$mff'],
	CLIPBOARDSETTEXT: function(Text) {
		mff.clipboard = mff.str(Text);
		if (navigator.clipboard && navigator.clipboard.writeText) navigator.clipboard.writeText(mff.clipboard).catch(function() { });
	},

	CLIPBOARDGETTEXT__deps: ['$mff', '$Asyncify', '$stringToNewUTF8'],
	CLIPBOARDGETTEXT__async: true,
	CLIPBOARDGETTEXT: function() {
		return Asyncify.handleSleep(function(wakeUp) {
			var done = function(s) { wakeUp(s == null ? 0 : stringToNewUTF8(s)); };
			if (!navigator.clipboard || !navigator.clipboard.readText) return done(mff.clipboard);
			navigator.clipboard.readText().then(done, function() { done(mff.clipboard); });
		});
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
		// a div has no load event: fire once the element is in the DOM. Not while the start of the program waits in
		// Application.DoEvents (PAGESLEEP): OnShow of the form can show a modal form, which can wait only when no
		// other wait runs (the events of a modal form, MODALWAIT, run in its wait)
		function fire() {
			if (mff.pageSleep) { setTimeout(fire, 10); return; }
			mff.call("ONLOAD", [Id]);
		}
		setTimeout(fire, 0);
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
		if (e.tagName != "SELECT" && e.querySelector(".mffitem")) mff.listInit(e);
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
		mff.on(Id, "click", function(e) { e.stopPropagation(); if (mff.ownEvent(e)) mff.call("ONCLICK", [Id]); });
	},

	SETDBLCLICKEVENT__deps: ['$mff'],
	SETDBLCLICKEVENT: function(Id) {
		mff.on(Id, "dblclick", function(e) { e.stopPropagation(); if (mff.ownEvent(e)) mff.call("ONDBLCLICK", [Id]); });
	},

	SETGOTFOCUSEVENT__deps: ['$mff'],
	SETGOTFOCUSEVENT: function(Id) {
		var e = mff.el(Id);
		if (e) e.mffGotFocusEvent = true;
		mff.on(Id, "focus", function() { mff.call("ONGOTFOCUS", [Id]); });
	},

	SETLOSTFOCUSEVENT__deps: ['$mff'],
	SETLOSTFOCUSEVENT: function(Id) {
		mff.on(Id, "blur", function() { mff.call("ONLOSTFOCUS", [Id]); });
	},

	SETKEYDOWNEVENT__deps: ['$mff'],
	SETKEYDOWNEVENT: function(Id) {
		// The element takes the focus (a canvas has no tabindex); a handled key does not do the action of the browser
		var el = mff.el(Id);
		if (el && !el.hasAttribute("tabindex")) el.tabIndex = 0;
		mff.on(Id, "keydown", function(e) { if (mff.call("ONKEYDOWN", [Id, mff.key(e), mff.shift(e)])) mff.prevent(e); });
	},

	SETKEYPRESSEVENT__deps: ['$mff'],
	SETKEYPRESSEVENT: function(Id) {
		mff.on(Id, "keypress", function(e) { if (mff.call("ONKEYPRESS", [Id, mff.key(e), mff.shift(e)])) mff.prevent(e); });
	},

	SETKEYUPEVENT__deps: ['$mff'],
	SETKEYUPEVENT: function(Id) {
		mff.on(Id, "keyup", function(e) { if (mff.call("ONKEYUP", [Id, mff.key(e), mff.shift(e)])) mff.prevent(e); });
	},

	SETMOUSEENTEREVENT__deps: ['$mff'],
	SETMOUSEENTEREVENT: function(Id) {
		mff.on(Id, "mouseenter", function() { mff.call("ONMOUSEENTER", [Id]); });
	},

	SETMOUSEDOWNEVENT__deps: ['$mff'],
	SETMOUSEDOWNEVENT: function(Id) {
		mff.mouseCapture();
		mff.on(Id, "mousedown", function(e) {
			if (e.mffDone || !mff.ownEvent(e)) return;
			e.mffDone = true;
			mff.captureId = Id;
			e.currentTarget.mffDownRect = e.currentTarget.getBoundingClientRect();
			var p = mff.mousePos(e.currentTarget, e);
			mff.call("ONMOUSEDOWN", [Id, e.button, p[0], p[1], mff.shift(e)]);
		});
	},

	SETMOUSEMOVEEVENT__deps: ['$mff'],
	SETMOUSEMOVEEVENT: function(Id) {
		mff.mouseIds.move[Id] = true;
		mff.on(Id, "mousemove", function(e) {
			if (e.mffDone || !mff.ownEvent(e)) return;
			e.mffDone = true;
			var p = mff.mousePos(e.currentTarget, e);
			mff.call("ONMOUSEMOVE", [Id, e.buttons, p[0], p[1], mff.shift(e)]);
		});
	},

	SETMOUSEUPEVENT__deps: ['$mff'],
	SETMOUSEUPEVENT: function(Id) {
		mff.mouseCapture();
		mff.mouseIds.up[Id] = true;
		mff.on(Id, "mouseup", function(e) {
			if (e.mffDone || !mff.ownEvent(e)) return;
			e.mffDone = true;
			var p = mff.mousePos(e.currentTarget, e);
			mff.call("ONMOUSEUP", [Id, e.button, p[0], p[1], mff.shift(e)]);
		});
	},

	SETMOUSELEAVEEVENT__deps: ['$mff'],
	SETMOUSELEAVEEVENT: function(Id) {
		mff.on(Id, "mouseleave", function() { mff.call("ONMOUSELEAVE", [Id]); });
	},

	SETMOUSEWHEELEVENT__deps: ['$mff'],
	SETMOUSEWHEELEVENT: function(Id) {
		mff.on(Id, "wheel", function(e) {
			// a control inside handled it already (it scrolled) or scrolls itself (a list in an editor): its parents do
			// not scroll
			if (e.defaultPrevented || !mff.ownEvent(e)) return;
			var p = mff.mousePos(e.currentTarget, e);
			if (mff.call("ONMOUSEWHEEL", [Id, e.deltaY < 0 ? 1 : -1, p[0], p[1], mff.shift(e)])) e.preventDefault();
		});
	},

	SETUNLOADEVENT__deps: ['$mff'],
	SETUNLOADEVENT: function(Id) {
		window.addEventListener("unload", function() { mff.call("ONUNLOAD", [Id]); });
	}
};

mergeInto(LibraryManager.library, MffLibrary);
