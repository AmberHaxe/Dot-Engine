package ui;

import Type.ValueType;
import flixel.FlxSprite;
import haxe.ds.StringMap;
import flixel.FlxObject;
import flixel.FlxCamera;

class PreferencesMenu extends ui.OptionsState.Page
{
    public static var preferences:StringMap<Bool> = new StringMap<Bool>();
    public static var checkboxes:Array<CheckboxThingie> = [];

    var camFollow:FlxObject;
    var menuCamera:FlxCamera;
    static var items:TextMenuList;

    public function new()
    {
        super();

        menuCamera = new FlxCamera();
        FlxG.cameras.add(menuCamera, false);
        menuCamera.bgColor = 0;
        camera = menuCamera;

        items = new TextMenuList();
        add(items);

        createPrefItem("naughtyness", "censor-naughty", true);
        createPrefItem("downscroll", "downscroll", false);
        createPrefItem("flashing menu", "flashing-menu", false);
        createPrefItem("Camera Zooming on Beat", "camera-zoom", false);
        createPrefItem("FPS Counter", "fps-counter", true);
        createPrefItem("Auto Pause", "auto-pause", false);

        camFollow = new FlxObject(FlxG.width / 2, 0, 140, 70);

        if (items != null)
            camFollow.y = items.members[items.selectedIndex].y;

        menuCamera.follow(camFollow, null, 0.06);

        menuCamera.deadzone.setPosition(0, 160);
        menuCamera.deadzone.setSize(menuCamera.width, 40);

        menuCamera.minScrollY = 0;

        items.onChange.add(function(listener)
        {
            camFollow.y = listener.y;
        });
    }

    public static function getPref(name:String):Bool
    {
        return preferences.get(name);
    }

    public static function initPrefs()
    {
        preferenceCheck("censor-naughty", true);
        preferenceCheck("downscroll", false);
        preferenceCheck("flashing-menu", true);
        preferenceCheck("camera-zoom", true);
        preferenceCheck("fps-counter", true);
        preferenceCheck("auto-pause", true);
        preferenceCheck("master-volume", 1);

        if (getPref("fps-counter"))
            FlxG.stage.removeChild(Main.fpsCounter);

        FlxG.autoPause = getPref("auto-pause");
    }

    public static function preferenceCheck(name:String, defaultValue:Dynamic)
    {
        if (preferences.get(name) == null)
        {
            preferences.set(name, defaultValue);
            trace("set preference!");
        }
        else
        {
            trace("found preference: " + Std.string(preferences.get(name)));
        }
    }

    public function createPrefItem(name:String, pref:Dynamic, defaultVal:Dynamic)
    {
        var thing = Type.typeof(defaultVal);

        items.createItem(120, 120 * items.length + 30, name,Bold, function() {
            preferenceCheck(pref, defaultVal);

            if (thing == ValueType.TBool)
                prefToggle(pref);
            else
                trace('swag');
        });

        if (thing == ValueType.TBool)
            createCheckbox(pref);
        else
            trace('swag');

        trace(thing);
    }

    public function createCheckbox(name:String)
    {
        var checkbox:CheckboxThingie = new CheckboxThingie(0, 120 * (items.length - 1), PreferencesMenu.preferences.get(name));
        checkboxes.push(checkbox);
        add(checkbox);
    }

    public static function prefToggle(pref:String):Void
    {
        var getPref = preferences.get(pref);
        getPref = !getPref;
        preferences.set(pref, getPref);
        checkboxes[items.selectedIndex].daValue = getPref;
        trace("toggled? " + Std.string(preferences.get(pref)));

        switch (pref)
        {
            case 'auto-pause':
                FlxG.autoPause = PreferencesMenu.getPref("auto-pause");
            case 'fps-counter':
                if (PreferencesMenu.getPref("fps-counter"))
                    FlxG.stage.addChild(Main.fpsCounter);
                else
                    FlxG.stage.removeChild(Main.fpsCounter);
        }
    }

    public override function update(elapsed:Float)
    {
        super.update(elapsed);

        menuCamera.followLerp = CoolUtil.camLerpShit(0.05);
        items.forEach(function(item:FlxSprite)
        {
            item == items.members[items.selectedIndex] ? item.x = 150 : item.x = 120;
        });
    }
}
