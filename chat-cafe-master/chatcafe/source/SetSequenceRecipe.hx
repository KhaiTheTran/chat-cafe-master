package;

import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.FlxG;

/**
    Recipe that requires player to type a set of keys in a specific order
**/
class SetSequenceRecipe extends Recipe {

    // Instructions distance from top of the screen
    static inline final INSTRUCT_DISTANCE_FROM_TOP:Int = 500;
    // Instructions width
    static inline final INSTRUCT_WIDTH:Int = 700;
    // Instruction font size
    static inline final INSTRUCT_SIZE:Int = 40;
    // Distance from top of the screen
    static inline final DISTANCE_FROM_TOP:Int = 200;
    // Size of the recipe information
    static inline final FONT_SIZE:Int = 70;
    // Size of spaces between recipe information
    static inline final SPACE_SIZE:Int = 10;
    // Color for unpressed letter
    static final UNPRESSED_COLOR:FlxColor = FlxColor.RED.getLightened(0.4);
    // Color for pressed letter
    static final PRESSED_COLOR:FlxColor = FlxColor.GREEN.getLightened(0.4);
    // Border color
    static final TEXT_BORDER_COLOR:FlxColor = FlxColor.BLACK;
    // Emphasis color
    static final EMPHASIS_COLOR:FlxColor = FlxColor.YELLOW;
    // Border size
    static inline final TEXT_BORDER_SIZE:Int = 2;

    // Keys for the recipe
    var keys:Array<FlxKey>;
    // Visuals for keys
    var displayKeys:Array<FlxText>;
    // Index of the key that the recipe is waiting for
    var index:Int;

    override public function new(displayName: String, keys: Array<FlxKey>,
        reward:Int, ?onCompletion:Recipe -> Void):Void {
        super(displayName, reward, onCompletion);
        this.keys = keys;

        // Next, we need to make the key texts
        this.displayKeys = Util.generateTextKeys(keys, FONT_SIZE, SPACE_SIZE, DISTANCE_FROM_TOP,
            UNPRESSED_COLOR, TEXT_BORDER_COLOR, TEXT_BORDER_SIZE);
        for (dispKey in displayKeys) {
            add(dispKey);
        }

        var instruct:FlxText = new FlxText(Math.round((Util.relWidth(Dialogue.REL_DIALOGUE_WIDTH) / 2) -
            (INSTRUCT_WIDTH / 2)), INSTRUCT_DISTANCE_FROM_TOP, INSTRUCT_WIDTH,
            "", INSTRUCT_SIZE);
        instruct.alignment = CENTER;
        instruct.applyMarkup("Press the keys associated with the ingredients $from left to right$!",
            [new FlxTextFormatMarkerPair(new FlxTextFormat(EMPHASIS_COLOR), "$")]);
        instruct.font = AssetPaths.RobotoBlack__ttf;
        instruct.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
        add(instruct);

        this.active = true;
        this.index = 0;
        queueID = QueueSystem.SEQUENCE;
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if (active) {
            if (FlxG.keys.anyJustPressed([keys[index]])) {
                displayKeys[index].color = PRESSED_COLOR;
                this.index = this.index + 1;
                if (this.index == keys.length) {
                    this.active = false;
                    complete();
                }
            }
        }
    }

    /**
        Returns either the key that the recipe is currently
        waiting for or null if the recipe is finished/inactive
    **/
    public function getCurrentKey():FlxKey {
        if (!active) {
            return null;
        }
        return keys[index];
    }
}