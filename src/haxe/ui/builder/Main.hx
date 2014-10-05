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
		Toolkit.defaultTransition = "none";
		Toolkit.setTransitionForClass(Accordion, "slide");
		Toolkit.setTransitionForClass(Popup, "slide");
		if (Prefs.theme == "default") {
			Toolkit.theme = new DefaultTheme();
		} else if (Prefs.theme == "gradient") {
			Toolkit.theme = new GradientTheme();
		}
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
			root.addChild(new MainController().view);
		});
	}
}
