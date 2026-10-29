/**
  * The addEventListener() method attaches an event handler to the specified element.
  * @param {*} event Type of the event (like 'load', 'click' or 'onchange' ...)
  * @param {*} obj When the event occurs, an event object is passed to the function as the first parameter. The type of the event object depends on the specified event
  * @param {*} fn Specifies the function to run when the event occurs. 
  */
 function addListener(event, obj, fn) {
    if (obj.addEventListener) {
       obj.addEventListener(event, fn, false);   // modern browsers
    } else {
       obj.attachEvent("on"+event, fn);          // older versions of IE
    }
}

// The console of FreeBASIC (termlib.js) shows "\r" as "^": the new line of Print ("\r\n" of the runtime) is "\n"
if (typeof __fb_rtlib !== "undefined" && __fb_rtlib.console && __fb_rtlib.console.write) {
	var mffConsoleWrite = __fb_rtlib.console.write;
	__fb_rtlib.console.write = function(text) {
		return mffConsoleWrite.call(this, String(text).replace(/\r\n/g, "\n"));
	};
}

// The event emitter will be emitted when page is loaded
addOnPostRun(function() {
	if (Module["_ONSTART"]) Module["_ONSTART"]();
});

function toggleNode(event) {
  var parent = event.target.parentElement;
    var childNodes = parent.querySelector('ul');
    if (childNodes.style.display === 'none') {
      childNodes.style.display = 'block';
      event.target.textContent = '▼';
    } else {
      childNodes.style.display = 'none';
      event.target.textContent = '►';
    }
}

// The functions imported by the FreeBASIC side (CREATEELEMENT, SETVISIBLE, SETCLICKEVENT, ...)
// live in mff_lib.js, which is linked with --js-library. This file holds only page helpers.

var mymod = mymod || {};

//mymod msg dialogs
mymod.dialog = (function() {

	var _exposed = {
		//global methods
		msgBoxGet:		msgbxGet,
		msgBoxShow: 	msgbxShow,
	}
	
	//module globals
	
	function msgbxGet(title,msg,options) {
		//parse options
		//console.log(options)
		if (!options) options = {}
		var dlgstyle = (options.dlgStyle) ? options.dlgStyle : "none"
		var dlgbuttons = (options.dlgButtons) ? options.dlgButtons : "ok"
		var dlgcallbackOk = (options.dlgCallbackOk) ? options.dlgCallbackOk : null
		var dlgcallbackApply = (options.dlgCallbackApply) ? options.dlgCallbackApply : null
		var dlgcallbackCancel = (options.dlgCallbackCancel) ? options.dlgCallbackCancel : null
		var dlgOkLabel = (options.dlgOkLabel && options.dlgOkLabel!="") ? options.dlgOkLabel : "Ok"
		var dlgApplyLabel = (options.dlgApplyLabel && options.dlgApplyLabel!="") ? options.dlgApplyLabel : "Apply"
		var dlgCancelLabel = (options.dlgCancelLabel && options.dlgCancelLabel!="") ? options.dlgCancelLabel : "Cancel"
		var dlginputBox = (options.dlgInputBox) ? options.dlgInputBox : false
		var dlginputCb = (options.dlgInputBoxCallback) ? options.dlgInputBoxCallback : null
		var dlguserElm = (options.dlgCustElement) ? options.dlgCustElement : null
		
		var mask = document.createElement("div");
		mask.id = "vetdialogmodal"
		mask.className += " vetdialog mask "
		mask.onkeydown = function(){ondlgKeydown(event,dlgcallbackOk,mask)}
		
		var box = document.createElement("div");
		box.className += " vetdialog box dropshadow"
		mask.appendChild(box);
		
		var titdv = document.createElement("div");
		titdv.className += " flexpanel backgroundmenu unselectable basecolorblue"
		setElmStyle(titdv,{padding:"8px"})
		dragElement(titdv, box);
		var tittxt = document.createElement("div");
		tittxt.innerHTML = (title == "" || !title) ? "Title" : title;
		tittxt.className += " "
		titdv.appendChild(tittxt);
		var titbut = document.createElement("div");
		titbut.className += " vetdialogbutton fa fa-remove "
		titbut.innerHTML = "X";
		setElmStyle(titbut,{width:"20px",position:"absolute",right:"8px",opacity:"0.7"})
		titbut.onclick = function(){if (mask) document.body.removeChild(mask);}
		titdv.appendChild(titbut);
		box.appendChild(titdv);
		
		var msgdiv = document.createElement("div");
		msgdiv.className += " flexpanel unselectable  "
		
		var icdiv = document.createElement("div");
		icdiv.className += " flexpanel vertical basecolorblue fontbigger"
		setElmStyle(icdiv,{width:"15%",alignItems:"center",paddingTop:"15px" })
		var icimg = getIcon(dlgstyle)
		if (icimg) {icdiv.className += " "+icimg}
		msgdiv.appendChild(icdiv);
		
		var bddiv = document.createElement("div");
		//give the body an id to be able by the client script to add controls to the body
		bddiv.id = "vetdialogbody"
		bddiv.className += " flexpanel vertical dockfill "
		setElmStyle(bddiv,{padding:"4px"})
		var lins = splitMsg(msg), pr
		for (var i=0;i<lins.length;i++) {
			//console.log("line"+i+"="+lins[i])
			pr = document.createElement("p");
			pr.innerHTML = lins[i]
			bddiv.appendChild(pr);
		}
		
		//inputbox?
		if (dlginputBox) {
			var ipdiv = document.createElement("input");
			//give an id to focus later on
			ipdiv.id = "vetdialogdefaultinputbox"
			ipdiv.className += " fonttitle fontsizesmall "
			setElmStyle(ipdiv,{marginLeft:"0%",width:"82%"})
			//console.log(dlginputCb)
			if (dlginputCb) {
				//override the ok and apply callbacks with default inputBoxCallback
				ipdiv.onkeydown = function(){oninputKeydown(event,dlginputCb,mask)}
				dlgcallbackOk = function(){dlginputCb(ipdiv.value)}
				dlgcallbackApply = function(){dlginputCb(ipdiv.value)}
			}
			bddiv.appendChild(ipdiv);
		}
		
		//user element?
		if (dlguserElm)	{
			//just straightforwardly append, the cust element should have its own style and callbacks and stuff
			bddiv.appendChild(dlguserElm);
		}	
		
		msgdiv.appendChild(bddiv);
		box.appendChild(msgdiv);
		
		//buttons ok apply cancel
		var defaultclose = function(){if (mask) document.body.removeChild(mask);}
		var butdiv = document.createElement("div");
		butdiv.className += " flexpanel backgroundmenu unselectable basecolorred"
		setElmStyle(butdiv,{padding:"8px",justifyContent:"flex-end"})
		dlgbuttons = String(dlgbuttons).toLowerCase()
		
		var butok = getDialogButton("ok",1,dlgOkLabel)
		butok.onclick = (dlgcallbackOk) ? function(){dlgcallbackOk();defaultclose()} : defaultclose;
		var butapply = getDialogButton("apply",2,dlgApplyLabel)
		butapply.onclick = (dlgcallbackApply) ? function(){dlgcallbackApply()} : null;
		var butcancel = getDialogButton("cancel",3,dlgCancelLabel)
		butcancel.onclick = (dlgcallbackCancel) ? function(){dlgcallbackCancel();defaultclose()} : defaultclose;
		
		if (dlgbuttons=="okcancel") {
			butdiv.appendChild(butok)
			butdiv.appendChild(butcancel)
		} else if (dlgbuttons=="okapplycancel") {
			butdiv.appendChild(butok)
			butdiv.appendChild(butapply)
			butdiv.appendChild(butcancel)
		} else if (dlgbuttons=="applycancel") {
			butdiv.appendChild(butapply)
			butdiv.appendChild(butcancel)
		} else {
			butdiv.appendChild(butok)
		}
		box.appendChild(butdiv);
		
		
		return mask
	}
	
	function msgbxShow(msgbox) {
		//msgbox.style.pointerEvents = "auto";
		document.body.appendChild(msgbox);
		//set focus, input overrules the cancel button, note the cascading
		var focel = msgbox.querySelector("#vetdialogdefaultinputbox"); if (focel) {focel.focus();return true}
		focel = msgbox.querySelector("#vetdialogcancel"); if (focel) {focel.focus();return true}
		focel = msgbox.querySelector("#vetdialogok"); if (focel) {focel.focus();return true}
		return true
	}
	
	function getIcon(dlgstl){
		dlgstl = dlgstl.substr(0,4).toLowerCase();
		var icimgtg = null
		if (dlgstl == "info") {
			icimgtg = "fa fa-info-circle"
		} else if (dlgstl == "excl" || dlgstl == "warn") {
			icimgtg = "fa fa-exclamation-triangle"
		} else if (dlgstl == "ques") {
			icimgtg = "fa fa-question-circle"
		} else if (dlgstl == "erro") {
			icimgtg = "fa fa-minus-circle"
		}
		return icimgtg
	}
	
	function getDialogButton(txt,tbindx,lab){
		var bx = txt.substr(0,2).toLowerCase();
		var bt = document.createElement("div");
		bt.className += " vetdialogbutton"
		bt.tabIndex = tbindx
		bt.innerHTML = lab
		bt.onfocus = function(){this.style.outlineWidth="3px";this.setAttribute("hasfocus",true);}
		bt.onblur = function(){this.style.outlineWidth="1px";this.setAttribute("hasfocus",false);}
		if (bx=="ap") {
			bt.id = "vetdialogapply"
		} else if (bx=="ca") {
			bt.id = "vetdialogcancel"
		} else {
			bt.id = "vetdialogok"
		}
		//bt.onclick = function(){console.log(this)}
		return bt;
	}
	
	function splitMsg(msg){
		var ps=[], nolines=false;
		if (!msg || msg == "") {
			nolines=true
		} else {
			//first check if the breaks are given in <br>
			var lines = String(msg).split("<br>")
			//console.log(lines)
			if (!lines || lines.length == 1) {
				//try regex
				lines = msg.match(/[^\r\n]+/g);
				if (!lines || lines.length == 0) nolines=true
				//console.log(lines)
			}
			
			if (nolines){
				ps.push("No message")
			} else {
				//console.log(lines)
				for (var i=0; i<lines.length; i++) {ps.push(lines[i])}
			}
		}
		if (ps.length==0) ps.push("No message")
		return ps
	}
	
	function oninputKeydown(e,clb,dlg){
		//console.log(e.keyCode,e)
		var clskeys = [13]; //close dialog on return only and pass value
		if (clskeys.indexOf(e.keyCode) > -1) {
			//console.log("got enter with value="+e.target.value)
			//console.log(clb)
			if (clb) clb(e.target.value)
			//killme
			if (dlg) document.body.removeChild(dlg)
		}
		//catch the char 32 (spacebar) because it triggers the foccused button action, i.e. default cancel
		if (e.keyCode==32) {
			(e.mffPreventDefault || e.preventDefault).call(e)
			e.stopPropagation()
			e.target.value += " "
		}
	}
	
	function ondlgKeydown(e,okclb,dlg){
		//console.log("mask",e.keyCode,e)
		var clskeys = [13,32]; //close dialog on return and spacebar
		if (clskeys.indexOf(e.keyCode) > -1) {
			//exec the okcallback only when the button has focus
			var okb = dlg.querySelector("#vetdialogok")
			if (okb && okb.getAttribute("hasfocus")=="true") {
				//console.log(okb)
				if (okclb) okclb(e.target.value)
			}
			//killme, use try catch block because the dlg might have been removed by the oninputKeydown
			if (dlg) {try{document.body.removeChild(dlg)} catch(err){}}
		}
	}
	
	//helper functions not really belonging to the core of the module
	function setElmStyle(elm,props) {
		if (!elm) return null;
		for (var property in props) elm.style[property] = props[property];
	}
	
	return _exposed;
	
})(mymod.dialog || {});

function dragElement(elmnt, frm) {
  var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
  elmnt.onmousedown = dragMouseDown;

  function dragMouseDown(e) {
    e = e || window.event;
    e.preventDefault();
    pos3 = e.clientX;
    pos4 = e.clientY;
    document.onmouseup = closeDragElement;
    document.onmousemove = elementDrag;
  }

  function elementDrag(e) {
    e = e || window.event;
    e.preventDefault();
    pos1 = pos3 - e.clientX;
    pos2 = pos4 - e.clientY;
    pos3 = e.clientX;
    pos4 = e.clientY;
    frm.style.top = (frm.offsetTop - pos2) + "px";
    frm.style.left = (frm.offsetLeft - pos1) + "px";
  }

  function closeDragElement() {
    document.onmouseup = null;
    document.onmousemove = null;
  }
}

// The keyboard of the console of FreeBASIC (fb_rtlib: the key callbacks of emscripten on the page) stops the action of
// keys like Backspace and Delete: in a text box of the page they keep their action. The listener on the window in the
// capture phase runs first (this file is loaded before the program starts): preventDefault of the event does nothing
// then, the handlers of the controls use the original one (mff.prevent of mff_lib.js)
// The keys of the characters of the punctuation (the OEM keys: - = ; , . / ` [ \ ] ') are not stopped by it anywhere: its
// table has the key codes of Firefox for some of them (173 "-", 61 "=", 59 ";"), with the ones of Chrome and Edge (189,
// 187, 186) it stopped the keydown, so the browser gave no keypress (the letters "ғ" and "ҳ" of the Uzbek keyboard
// on "-" and "=" could not be typed). INKEY gets the character from the keypress
var mffCharKeys = [186, 187, 188, 189, 190, 191, 192, 219, 220, 221, 222, 226];
["keydown", "keypress", "keyup"].forEach(function(type) {
	window.addEventListener(type, function(e) {
		var el = e.target;
		if ((el && (el.tagName == "INPUT" || el.tagName == "TEXTAREA" || el.tagName == "SELECT" || el.isContentEditable)) ||
			(type == "keydown" && !e.ctrlKey && !e.altKey && !e.metaKey && mffCharKeys.indexOf(e.keyCode) >= 0)) {
			e.mffPreventDefault = e.preventDefault;
			e.preventDefault = function() {};
		}
	}, true);
});

// The active control of the form (Form.ActiveControl, OnActiveControlChanged: the IDE closes a collapsed panel when
// another control gets the focus) follows the focus of the page like on Windows: the control of the focused element
// (the element whose id is the address of the control) is told unless it tells it itself (SETGOTFOCUSEVENT)
document.addEventListener("focusin", function(e) {
	for (var el = e.target; el && el !== document.body; el = el.parentElement) {
		if (/^\d+$/.test(el.id)) {
			if (!el.mffGotFocusEvent) mff.call("ONGOTFOCUS", [Number(el.id)]);
			return;
		}
	}
}, true);
