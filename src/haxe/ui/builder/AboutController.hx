package haxe.ui.builder;

import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.XMLController;

@:build(haxe.ui.toolkit.core.Macros.buildController("assets/ui/about.xml"))
class AboutController extends XMLController {
	public function new() {
		versionInfo.text = Toolkit.versionString;
	}
}