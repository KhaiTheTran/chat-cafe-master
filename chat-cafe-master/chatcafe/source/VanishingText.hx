package;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;

/**
    Represents a text object which floats up and vanishes, then kills itself after the specified delay.
    The provided floatSpeed corresponds to how many pixels per second the text will rise at.
**/
class VanishingText extends FlxSpriteGroup {

    // Border color
    static inline final TEXT_BORDER_COLOR:FlxColor = FlxColor.BLACK;
    // Border size
    static inline final TEXT_BORDER_SIZE:Int = 1;

    // A timer that determines when to destroy the text
    var vanishTimer:Timer;
    // The initial amont of time until the text should vanish, in MS
    var initialVanishDelay:Int;
    // The number of pixels to rise the text per second
    var floatSpeed:Int;
    // The FlxText object for the displayText
    public var displayText:FlxText;

    override public function new(x:Int, y:Int, text:String, fontSize:Int, durationMS:Int, floatSpeed:Int,
        color:FlxColor, ?width:Int) {
        super(x, y, 0);
        if (width == null) {
            width = 0;
        }
        displayText = new FlxText(0, 0, width, text, fontSize);
        displayText.color = color;
        displayText.setBorderStyle(OUTLINE, TEXT_BORDER_COLOR, TEXT_BORDER_SIZE);
        displayText.font = AssetPaths.RobotoBlack__ttf;
        add(displayText);
        initialVanishDelay = durationMS;
        vanishTimer = new Timer(durationMS);
        add(vanishTimer);
        vanishTimer.start();
        this.floatSpeed = floatSpeed;
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        var timeLeft:Int = vanishTimer.getTimeLeft();
        if (timeLeft == 0) {
            kill();
        } else {
            var timeRatio:Float = timeLeft * 1.0 / initialVanishDelay;
            var timeDifference:Int = initialVanishDelay - timeLeft;
            // Disappear linearly over time
            displayText.alpha = timeRatio;
            displayText.y = this.y - Math.round(floatSpeed * (timeDifference / 1000.0));
        }
    }

}