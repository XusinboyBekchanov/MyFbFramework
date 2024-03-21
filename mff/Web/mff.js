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


// The event emitter will be emitted when page is loaded
addListener('load', window, function(event) {
	//_ONLOAD();
	addOnPostRun(_ONSTART);
});

function _MESSAGEBOX(Message, Caption, MessageType, ButtonsType) {
	var msg = UTF8ToString(HEAPU32[((Message)>>2)]);
	var ttl = UTF8ToString(HEAPU32[((Caption)>>2)]);
    //build the dialog
	var dlg = mymod.dialog.msgBoxGet(ttl,msg,{
		dlgStyle:MessageType,
		dlgButtons:ButtonsType,
		dlgOkLabel:"OK",
		dlgApplyLabel:"Apply",
		dlgCancelLabel:"Cancel",
		dlgInputBox: false,
		dlgInputBoxCallback: null,
	});
	//run the dialog
	mymod.dialog.msgBoxShow(dlg)
}

function _INSERTHTML(value) {
	var ptr = HEAPU32[((value)>>2)];
    //    var len = HEAPU32[(((value)+(4))>>2)];
	//text = ``;
       	//for (var j = 0; j < len; j++) {
	//	text += String.fromCharCode(HEAPU8[ptr+j]);
       	//}
	//document.body.insertAdjacentHTML("afterbegin", text);
	document.body.insertAdjacentHTML("afterbegin", UTF8ToString(ptr));
}

function _ADDCOLUMN(Id, Caption) {
	var strCaption = UTF8ToString(HEAPU32[((Caption)>>2)]);
	var el = document.querySelector("table[id='" + Id + "'] thead tr");
	var newElement = document.createElement("th");
	newElement.style = "background: #ccc; padding: 5px; border: 1px solid black;";
	newElement.innerHTML = strCaption;
	el.insertAdjacentElement("beforeend", newElement);
}

function _ADDROW(Id, Text) {
	var strText = UTF8ToString(HEAPU32[((Text)>>2)]);
	var el = document.querySelector("table[id='" + Id + "'] tbody");
	var newElement = document.createElement("tr");
	newElement.innerHTML = strText;
	el.insertAdjacentElement("beforeend", newElement);
}

function _SETTITLE(value) {
	var str = UTF8ToString(HEAPU32[((value)>>2)]);
	document.title = str;
}

function _SETVISIBLEBYSTRINGID(Id, value) {
	var strId = UTF8ToString(HEAPU32[((Id)>>2)]);
	document.getElementById(strId).style.display = (value)? 'inline':'none';
}

function _SETVISIBLE(Id, value) {
	document.getElementById(Id).style.display = (value)? 'inline':'none';
}

function _FREE(ptr) {
	_free(ptr);
}

function _GETSTRINGVALUE(Id) {
	var ptr = stringToNewUTF8(document.getElementById(Id).value);
	return ptr;
}

function _SETSTRINGVALUE(Id, Value) {
	var ptr = HEAPU32[((Value)>>2)];
	document.getElementById(Id).value = UTF8ToString(ptr);
}

function _SETBACKCOLOR(Id, Value) {
	document.getElementById(Id).style.backgroundColor = Value;
}

function _SETFORECOLOR(Id, Value) {
	document.getElementById(Id).style.color = Value;
}

function _SETFONT(Id, Value) {
	var str = UTF8ToString(HEAPU32[((Value)>>2)]);
	document.getElementById(Id).style.font = str;
}

function _GETCHECKED(Id) {
	var strId = UTF8ToString(HEAPU32[((Id)>>2)]);
	return document.getElementById(strId).checked;
}

function _SETCHECKED(Id, Value) {
	var strId = UTF8ToString(HEAPU32[((Id)>>2)]);
	document.getElementById(strId).checked = Value;
}

function _SETBODYID(Id) {
	document.body.id = Id;
}

function _SETLOADEVENT(Id) {
	document.getElementById(Id).onload = function(){_ONLOAD(this.id)};
}

function _SETCHANGEEVENT(Id) {
	document.getElementById(Id).onchange = function(){_ONCHANGE(this.id)};
}

function _SETCLICKEVENT(Id) {
	document.getElementById(Id).onclick = function(){_ONCLICK(this.id)};
}

function _SETDBLCLICKEVENT(Id) {
	document.getElementById(Id).ondblclick = function(){_ONDBLCLICK(this.id)};
}

function _SETGOTFOCUSEVENT(Id) {
	document.getElementById(Id).onfocus = function(){_ONGOTFOCUS(this.id)};
}

function _SETLOSTFOCUSEVENT(Id) {
	document.getElementById(Id).onblur = function(){_ONLOSTFOCUS(this.id)};
}

function _SETKEYDOWNEVENT(Id) {
	document.getElementById(Id).onkeydown = function(event){_ONKEYDOWN(this.id, event.key.charCodeAt(0), event.getModifierState)};
}

function _SETKEYPRESSEVENT(Id) {
	document.getElementById(Id).onkeypress = function(event){_ONKEYPRESS(this.id, event.key.charCodeAt(0), event.getModifierState)};
}

function _SETKEYUPEVENT(Id) {
	document.getElementById(Id).onkeyup = function(event){_ONKEYUP(this.id, event.key.charCodeAt(0), event.getModifierState)};
}

function _SETMOUSEENTEREVENT(Id) {
	document.getElementById(Id).onmouseenter = function(){_ONMOUSEENTER(this.id)};
}

function _SETMOUSEDOWNEVENT(Id) {
	document.getElementById(Id).onmousedown = function(event){_ONMOUSEDOWN(this.id, event.button, event.x, event.y, event.getModifierState)};
}

function _SETMOUSEMOVEEVENT(Id) {
	document.getElementById(Id).onmousemove = function(event){_ONMOUSEMOVE(this.id, event.button, event.x, event.y, event.getModifierState)};
}

function _SETMOUSEMOVEUP(Id) {
	document.getElementById(Id).onmouseup = function(event){_ONMOUSEUP(this.id, event.button, event.x, event.y, event.getModifierState)};
}

function _SETMOUSELEAVEEVENT(Id) {
	document.getElementById(Id).onmouseleave = function(){_ONMOUSELEAVE(this.id)};
}

function _SETMOUSEWHEELEVENT(Id) {
	document.getElementById(Id).onwheel = function(event){_ONMOUSEWHEEL(this.id, event.wheeldelta, event.x, event.y, event.getModifierState)};
}

function _SETUNLOADEVENT(Id) {
	document.getElementById(Id).onunload = function(){_ONUNLOAD(this.id)};
}

function _CREATEELEMENT(AddPosition, ClassName, Class, Type, Id, Name, Text, Style, PositionType, Left, Top, Width, Height, Right, Bottom, Parent) {
	var strAddPosition = UTF8ToString(HEAPU32[((AddPosition)>>2)]);
	var strPositionType = UTF8ToString(HEAPU32[((PositionType)>>2)]);
	var strStyle = UTF8ToString(HEAPU32[((Style)>>2)]);
	var strLeft = UTF8ToString(HEAPU32[((Left)>>2)]);
	var strTop = UTF8ToString(HEAPU32[((Top)>>2)]);
	var strWidth = UTF8ToString(HEAPU32[((Width)>>2)]);
	var strHeight = UTF8ToString(HEAPU32[((Height)>>2)]);
	var strRight = UTF8ToString(HEAPU32[((Right)>>2)]);
	var strBottom = UTF8ToString(HEAPU32[((Bottom)>>2)]);
	var strClassName = UTF8ToString(HEAPU32[((ClassName)>>2)]);
	var strClass = UTF8ToString(HEAPU32[((Class)>>2)]);
	var strType = UTF8ToString(HEAPU32[((Type)>>2)]);
	var strName = UTF8ToString(HEAPU32[((Name)>>2)]);
	var strText = UTF8ToString(HEAPU32[((Text)>>2)]);
	var newElement = document.createElement(strClassName);
	if(!(strType == "")) {
		newElement.type = strType;
	}
	if(strType == "text") {
		newElement.value = strText;
		Terminal.prototype.globals.activeTerm.lock = true;
	}
	else {
		newElement.innerHTML = strText;
	}
	newElement.id = Id;
	newElement.name = strName;
	newElement.className = strClass;
	newElement.style = strStyle;
	newElement.style.position = strPositionType;
	newElement.style.left = strLeft;
	newElement.style.top = strTop;
	newElement.style.width = strWidth;
	newElement.style.height = strHeight;
	newElement.style.right = strRight;
	newElement.style.bottom = strBottom;
	if(Parent == 0) {
		document.body.insertAdjacentElement(strAddPosition, newElement);
	}
	else
	{
		var ParentElement = document.getElementById(Parent);
		ParentElement.insertAdjacentElement(strAddPosition, newElement);
	}
	if(strClass == "vetdialog box dropshadow") {
		dragElement(document.getElementById(Id + "Header"), newElement);
		document.getElementById(Id + "CloseButton").onclick = function(){_ONCLOSE(Id)};
	}
}

function _DELETEELEMENT(Id) {
	if (Id) document.body.removeChild(document.getElementById(Id));
}

function _GETDOCUMENTWIDTH(Id) {
	const width  = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	return width;
}

function _GETDOCUMENTHEIGHT(Id) {
	const height = window.innerHeight|| document.documentElement.clientHeight|| document.body.clientHeight;
	return height;
}

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
			e.preventDefault()
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
