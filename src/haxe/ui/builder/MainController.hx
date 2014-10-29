package haxe.ui.builder;

import haxe.Http;
import haxe.ui.dialogs.files.FileDetails;
import haxe.ui.dialogs.files.FileDialogs;
import haxe.ui.toolkit.controls.Menu;
import haxe.ui.toolkit.controls.MenuButton;
import haxe.ui.toolkit.controls.MenuItem;
import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.events.MenuEvent;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.resources.ResourceManager;
import lime.net.URLRequest;
import openfl.Lib;

@:build(haxe.ui.toolkit.core.Macros.buildController("assets/ui/main.xml"))
class MainController extends XMLController {
	private static inline var DEFAULT:String = "Button";
	//private static inline var SERVER:String = "http://localhost:8080/haxeui/";
	private static inline var SERVER:String = "http://haxeui.org/";
	
	private static var EXAMPLES:Map<String, String>;
	
	public function new(layoutId:String = null) {
		EXAMPLES = new Map<String, String>();
		EXAMPLES.set("Button", "data/button.xml");
		EXAMPLES.set("Accordion", "data/accordion.xml");
		EXAMPLES.set("ListView", "data/listview.xml");
		EXAMPLES.set("Grid Layout", "data/grid_layout.xml");
		EXAMPLES.set("Layout Builder", "ui/main.xml");
		EXAMPLES.set("Scripted Calculator", "data/calc.xml");
		EXAMPLES.set("Dividers", "data/dividers.xml");
		
		var themeName:String = "Default";
		if (Prefs.theme == "default") {
			themeName = "Default Theme";
		} else if (Prefs.theme == "gradient") {
			themeName = "Gradient Theme";
		}
		theme.text = themeName;
		theme.onChange = function(e) {
			Prefs.theme = theme.selectedItems[0].data.id;
			showSimplePopup("The theme has been changed. You must restart (or refresh) the application to use the new theme.", "Theme Changed");
		};
		
		if (layoutId == null) {
			layoutCode.text = StringTools.replace(ResourceManager.instance.getText(EXAMPLES.get(DEFAULT)), "\r", "");
		}
		mainTabs.onChange = onTabsChange;
		
		attachEvent("menuFile", MenuEvent.SELECT, function(e:MenuEvent) {
			switch (e.menuItem.id) {
				case "menuOpen":
					openFile();
				default:
			}
		});
		attachEvent("menuExamples", MenuEvent.SELECT, function(e:MenuEvent) {
			layoutCode.text = StringTools.replace(ResourceManager.instance.getText(EXAMPLES.get(e.menuItem.text)), "\r", "");
			onTabsChange(null);
		});
		attachEvent("menuHelp", MenuEvent.SELECT, function(e:MenuEvent) {
			switch (e.menuItem.id) {
				case "menuAbout":
					showCustomPopup("ui/about.xml", "About", {width: 400, buttons: PopupButton.OK});
				default:
			}
		});
		
		store.onClick = function(e) {
			storeLayout();
		}
		
		buildMenu();
	}
	
	private function buildMenu():Void {
		var menuExamples:MenuButton = getComponentAs("menuExamples", MenuButton);
		var menu:Menu = new Menu();
		menuExamples.addChild(menu);
		for (key in EXAMPLES.keys()) {
			var item:MenuItem = new MenuItem();
			item.text = key;
			menu.addChild(item);
		}
	}
	
	private function onTabsChange(event:UIEvent):Void {
		if (mainTabs.selectedIndex == 0 && layoutCode.ready == true) {
			layoutCode.focus();
		} else if (mainTabs.selectedIndex == 1) {
			var layoutString:String = layoutCode.text;
			try {
				var xml:Xml = Xml.parse(layoutString);
				var r = Toolkit.processXml(xml);
				resultContainer.removeAllChildren();
				resultContainer.addChild(r);
			} catch (ex:Dynamic) {
				resultContainer.removeAllChildren();
				showSimplePopup(ex, "Error", PopupButton.OK, function(e) {
					mainTabs.selectedIndex = 0;
				});
			}
		}
	}
	
	private function openFile():Void {
		FileDialogs.openFile( { readContents: true }, function(details:FileDetails) {
			if (details != null) {
				layoutCode.text = StringTools.replace(details.contents, "\r", "");
				onTabsChange(null);
			}
		});
	}
	
	private function storeLayout():Void {
		var request:Http = new Http(SERVER + "actions/layout-builder?random=" + Math.random());
		request.addParameter("action", "store");
		request.addParameter("layoutCode", layoutCode.text);
		request.onError = function(msg) {
			showSimplePopup("Problem saving layout:\n\n" + msg);
		}
		request.onStatus = function(status:Int) {
		}
		request.onData = function(response) {
			Lib.getURL(new URLRequest(SERVER + "try.jsp?layoutId=" + response), "_self");
		}
		
		request.request(false);
	}
	
	public function retrieveLayout(layoutId):Void {
		var request:Http = new Http(SERVER + "actions/layout-builder?random=" + Math.random());
		request.addParameter("action", "retrieve");
		request.addParameter("layoutId", layoutId);
		request.onError = function(msg) {
			showSimplePopup("Problem loading layout:\n\n" + msg);
		}
		request.onStatus = function(status:Int) {
		}
		request.onData = function(response) {
			response = StringTools.replace(response, "\r\n", "\n");
			layoutCode.text = response;
		}
		
		request.request(false);
	}
}