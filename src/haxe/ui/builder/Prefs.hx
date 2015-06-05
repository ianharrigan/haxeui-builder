package haxe.ui.builder;

import flash.net.SharedObject;

class Prefs {
	private static inline var DEFAULT_SECTION:String = "HaxeUIComponentShowcase";
	
	public function new() {
	}

	public static var theme(get, set):String;
	private static function get_theme():String {
		return getPref("theme", "gradient");
	}
	private static function set_theme(value:String):String {
		setPref("theme", value);
		return value;
	}

	public static function getPref(key:String, defaultValue:String = null, section:String = DEFAULT_SECTION):String {
		var value:String = defaultValue;
		
		var so = SharedObject.getLocal(section);
		if (so != null && so.data != null) {
			if (Reflect.hasField(so.data, key)) {
				value = Reflect.field(so.data, key);
			}
		}
		
		return value;
	}
	
	public static function setPref(key:String, value:String, section:String = DEFAULT_SECTION):Void {
		var so = SharedObject.getLocal(section);
		if (so != null && so.data != null) {
			if (value != null) {
				Reflect.setField(so.data, key, value);
			} else if (Reflect.hasField(so.data, key)) {
				Reflect.deleteField(so.data, key);
			}
			try {
				so.flush();
			} catch (e:Dynamic) {
				trace("Could not save pref: " + e);
			}
		}
	}

	public static function clearPref(key:String, section:String = DEFAULT_SECTION):Void {
		var so = SharedObject.getLocal(section);
		if (so != null && so.data != null) {
			if (Reflect.hasField(so.data, key)) {
				Reflect.deleteField(so.data, key);
				try {
					so.flush();
				} catch (e:Dynamic) {
					trace("Could not clear pref: " + e);
				}
			}
		}
	}
}