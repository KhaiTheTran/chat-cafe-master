package;

import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.FlxCamera;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;

/**
    A utility class with useful functions
 **/
class Util {

    // Fade time for fadeTo functions
    public static inline final FADE_TIME:Float = 0.5;

    /**
        Returns the number of pixels comprising percent of the screen height
     **/
    public static function relHeight(percent:Float):Int {
        return Math.round(FlxG.height * percent);
    }

    /**
        Returns the number of pixels comprising percent of the screen width
     **/
    public static function relWidth(percent:Float):Int {
        return Math.round(FlxG.width * percent);
    }

    /**
        Generates text for given keys, with them centered in the screen
    **/
    public static function generateTextKeys(inputKeys:Array<FlxKey>, fontSize:Int, spaceSize:Int,
        topDist:Int, unpressedColor:FlxColor, borderColor:FlxColor, borderSize:Int):Array<FlxText> {
        // We first need to find the midpoint of the dialogue to make calculations easier
        var midpt:Int = Math.round(Util.relWidth(Dialogue.REL_DIALOGUE_WIDTH) / 2);
        // Next, let's calculate the top left corner of the leftmost letter.
        var leftX:Int;
        if (inputKeys.length % 2 == 0) {
            leftX = Math.round(midpt - ((inputKeys.length / 2) * fontSize) -
                (((inputKeys.length / 2) - 0.5) * spaceSize));
        } else {
            leftX = Math.round(midpt - ((Math.round(inputKeys.length / 2) - 0.5) * fontSize) -
                ((Math.round(inputKeys.length / 2) * spaceSize)));
        }
        var returnKeys:Array<FlxText> = [];
        for (key in inputKeys) {
            var keyText:FlxText = new FlxText(leftX, topDist, 0, key.toString(), fontSize);
            keyText.color = unpressedColor;
            keyText.setBorderStyle(OUTLINE, borderColor, borderSize);
            returnKeys.push(keyText);
            leftX += fontSize + spaceSize;
        }
        return returnKeys;
    }

    /**
        Scales the game camera to match deployments
    **/
    public static function scaleGameCamera():Void {
        var camera:FlxCamera = new FlxCamera(0, 0, Math.round(FlxG.width * Main.SCALE_RATIO),
                                             Math.round(FlxG.height * Main.SCALE_RATIO));
        camera.focusOn(new FlxPoint(FlxG.width * 0.5, FlxG.height * 0.5));
        camera.zoom = Main.SCALE_RATIO;
        FlxG.cameras.reset(camera);
    }

    /**
        No op for mouse manager
    **/
    public static function noop():Void {
        return;
    }

    /**
        Fades to the playstate AFTER checking tutorial
    **/
    public static function fadeToPlayOrTutorial():Void {
        if (Main.globalState.tutorialRecipes.length > 0) {
            var tutorialType:Int = Main.globalState.tutorialRecipes.shift();
            Main.LOGGER.logLevelStart(2 + tutorialType);
            fadeTo(new TutorialState(tutorialType));
        } else {
            Main.LOGGER.logLevelStart(1, {
                day: Main.globalState.numDays
            });
            fadeTo(new PlayState());
        }
    }

    /**
        Fades to the specified state WITHOUT checking tutorial
    **/
    public static function fadeTo(state:FlxState):Void {
        FlxG.camera.fade(FlxColor.BLACK, FADE_TIME, false, () -> FlxG.switchState(state));
    }
}