// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//These replace onload and onunload functions in body tag.
window.onload = function() {
   init();
}
window.onunload = function(){
	GUnload();
}