package haxe.ui.builder;

import haxe.ui.toolkit.containers.Accordion;
import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.style.DefaultStyles;
import haxe.ui.toolkit.style.StyleManager;
import haxe.ui.toolkit.themes.DefaultTheme;
import haxe.ui.toolkit.themes.GradientTheme;

class Main {
	public static function main() {
		var s:Smiley;
		
		Toolkit.defaultTransition = "none";
		Toolkit.setTransitionForClass(Accordion, "slide");
		Toolkit.setTransitionForClass(Popup, "slide");
		Toolkit.theme = Prefs.theme;
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
			var layoutId:String = null;
			#if flash
			layoutId = Reflect.field(flash.Lib.current.root.loaderInfo.parameters, "layoutId");
			#end
			
			if (layoutId != null && layoutId.length == 0) {
				layoutId = null;
			}
			var controller:MainController = new MainController(layoutId);
			root.addChild(controller.view);
			if (layoutId != null) {
				controller.retrieveLayout(layoutId);
			}
		});
	}
}
