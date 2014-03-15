package haxe.ui.builder;

import haxe.ui.toolkit.containers.Accordion;
import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.style.DefaultStyles;
import haxe.ui.toolkit.style.StyleManager;

class Main {
	public static function main() {
		Toolkit.defaultTransition = "none";
		Toolkit.setTransitionForClass(Accordion, "slide");
		Toolkit.setTransitionForClass(Popup, "slide");
		if (Prefs.theme == "default") {
			StyleManager.instance.addStyles(new DefaultStyles());
		} else if (Prefs.theme == "gradient") {
			Macros.addStyleSheet("styles/gradient/gradient.css");
		}
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
			root.addChild(new MainController().view);
		});
	}
}
