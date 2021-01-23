package;

import flixel.FlxG;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;

/**
    Recipe that requires the player to start a timer and auto completes when
    timer is done
**/
class TimedRecipe extends Recipe {

    // Distance from top of the screen for text
    static inline final DISTANCE_FROM_TOP:Int = 50;
    // Size of the recipe information
    static inline final FONT_SIZE:Int = 40;
    // Width of the text objects
    static inline final TEXT_WIDTH:Int = 600;
    // Size of button to activate oven
    static inline final BUTTON_SIZE:Int = 100;
    // Distance from top of the screen for the button object
    static inline final DISTANCE_FROM_TOP_BUTTON:Int = 300;
    // Distance from side of the screen for the button object
    static inline final DISTANCE_FROM_SIDE_BUTTON:Int = 50;
    // Color of button to start recipe
    static final START_COLOR:FlxColor = FlxColor.RED;
    // Color of button to finish recipe
    static final END_COLOR:FlxColor = FlxColor.BLUE;
    // Border color
    static final TEXT_BORDER_COLOR:FlxColor = FlxColor.BLACK;
    // Border size
    static inline final TEXT_BORDER_SIZE:Int = 2;

    // Timer for oven
    var ovenTimer:Timer;
    // Text display for the recipe
    var displayText:FlxText;
    // Flag for when the oven was just started, to trigger a dialogue close
    var justStarted:Bool;

    // The start button. Null if it does not exist
    var startBtn:FlxSprite;
    // The finish button. Null if it does not exist
    var endBtn:FlxSprite;

    override public function new(displayName:String, timeToComplete:Int,
            reward:Int, ?onCompletion:Recipe -> Void):Void {
        super(displayName, reward, onCompletion);
        displayText = new FlxText(Math.round(Util.relWidth(Dialogue.REL_DIALOGUE_WIDTH * 0.5) -
            (TEXT_WIDTH / 2)), DISTANCE_FROM_TOP, TEXT_WIDTH,
            "Press the button or hit space to start the oven!", FONT_SIZE);
        displayText.alignment = CENTER;
        displayText.setBorderStyle(OUTLINE, TEXT_BORDER_COLOR, TEXT_BORDER_SIZE);
        displayText.font = AssetPaths.RobotoBlack__ttf;
        this.ovenTimer = new Timer(Math.round(timeToComplete * Main.globalState.ovenTimeMultiplier));

        startBtn = new FlxSprite(Util.relWidth(Dialogue.REL_DIALOGUE_WIDTH / 2) - Math.floor(BUTTON_SIZE / 2),
                                 DISTANCE_FROM_TOP_BUTTON, AssetPaths.ovenstart__png);

        add(displayText);
        add(startBtn);

        justStarted = false;
        queueID = QueueSystem.TIMED;
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if (active) {
            if (FlxG.keys.justPressed.SPACE && startBtn != null) {
                startOven(startBtn);
            } else if (FlxG.keys.justPressed.SPACE && endBtn != null) {
                complete();
            }

            if (ovenTimer.isFinished() && this.length < 2) {
                displayText.text = "Press the button or hit space to serve!";
                endBtn = new FlxSprite(Util.relWidth(Dialogue.REL_DIALOGUE_WIDTH / 2) - Math.floor(BUTTON_SIZE / 2),
                                       DISTANCE_FROM_TOP_BUTTON, AssetPaths.ovenend__png);
                if (isOpen) {
                    FlxMouseEventManager.add(endBtn, _ -> complete());
                }
                add(endBtn);
            } else if (ovenTimer.getIsRunning()) {
                displayText.text = "" + (Math.round(ovenTimer.getTimeLeft() / 100) / 10.0) + " time remaining...";
            }
        }
    }

    /**
        Returns OvenTimer
    **/
    public function getOvenTimer():Timer {
        return this.ovenTimer;
    }

    /**
        Start oven callback when button is pressed and destroys button
    **/
    function startOven(spt:FlxSprite):Void {
        startBtn = null;
        ovenTimer.start();
        // Remove button from dialogue then destroy it
        this.remove(spt, true).destroy();
        justStarted = true;
    }

    override public function shouldCloseDialogue():Bool {
        if (justStarted) {
            justStarted = false;
            return true;
        } else {
            return false;
        }
    }

    override public function onDialogueOpen():Void {
        super.onDialogueOpen();
        if (startBtn != null) {
            FlxMouseEventManager.remove(startBtn);
            FlxMouseEventManager.add(startBtn, startOven);
        }
        if (endBtn != null) {
            FlxMouseEventManager.remove(endBtn);
            FlxMouseEventManager.add(endBtn, _ -> complete());
        }
    }

    override public function onDialogueClose():Void {
        super.onDialogueClose();
        if (startBtn != null) {
            FlxMouseEventManager.remove(startBtn);
        }
        if (endBtn != null) {
            FlxMouseEventManager.remove(endBtn);
        }
    }
}