function _INSERTHTML(value) {
	var ptr = HEAPU32[((value)>>2)];
        var len = HEAPU32[(((value)+(4))>>2)];
	//text = ``;
       	//for (var j = 0; j < len; j++) {
	//	text += String.fromCharCode(HEAPU8[ptr+j]);
       	//}
	//document.body.insertAdjacentHTML("afterbegin", text);
	document.body.insertAdjacentHTML("afterbegin", UTF8ToString(ptr));
}