package;

import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;

/**
    Recipe that requires player to type a set of keys from another set
**/
class RandomSequenceRecipe extends Recipe {

    // Array of the possible keys that the recipe can consist of.
    static final POSSIBLE_KEYS:Array<FlxKey> = [T, E, S, G, A, P];
    // Random object
    static final RANDOM:FlxRandom = new FlxRandom();
    // Distance from top of the screen
    static inline final KEYS_DISTANCE_FROM_TOP:Int = 200;
    // Instructions distance from top of the screen
    static inline final INSTRUCT_DISTANCE_FROM_TOP:Int = 500;
    // Instructions width
    static inline final INSTRUCT_WIDTH:Int = 700;
    // Instruction font size
    static inline final INSTRUCT_SIZE:Int = 40;
    // Size of the recipe information
    static inline final FONT_SIZE:Int = 70;
    // Size of spaces between recipe information
    static inline final SPACE_SIZE:Int = 10;
    // Failed key vanish delay
    static inline final VANISH_DELAY:Int = 1000;
    // Failed key vanish speed
    static inline final VANISH_SPEED:Int = 100;
    // Failed key vanish width
    static inline final VANISH_WIDTH:Int = 350;
    // Color for unpressed letter
    static final UNPRESSED_COLOR:FlxColor = FlxColor.WHITE;
    // Color for correctly pressed letter
    static final CORRECT_COLOR:FlxColor = FlxColor.GREEN.getLightened(0.4);
    // Color for incorrectly pressed letter
    static final INCORRECT_COLOR:FlxColor = FlxColor.RED.getLightened(0.4);
    // Border color
    static final TEXT_BORDER_COLOR:FlxColor = FlxColor.BLACK;
    // Emphasis color
    static final EMPHASIS_COLOR:FlxColor = FlxColor.YELLOW;
    // Border size
    static inline final TEXT_BORDER_SIZE:Int = 2;

    // Visuals for keys
    var displayKeys:Array<FlxText>;
    // Number of successes
    var success:Int;
    // Number of failures
    var failure:Int;
    // Target number of keys
    var target:Int;

    override public function new(displayName: String, numKeys: Int,
        reward:Int, ?onCompletion:Recipe -> Void):Void {
        super(displayName, reward, onCompletion);

        // First, we have to select keys to make the players hit
        this.target = numKeys;
        var totalKeys:Array<FlxKey> = POSSIBLE_KEYS.copy();
        var correctKeys:Array<FlxKey> = [];
        for (i in 0...numKeys) {
            var key:FlxKey = RANDOM.getObject(totalKeys);
            correctKeys.push(key);
        }

        // Next, we need to make the key texts
        this.displayKeys = Util.generateTextKeys(correctKeys, FONT_SIZE, SPACE_SIZE,
            KEYS_DISTANCE_FROM_TOP, UNPRESSED_COLOR, TEXT_BORDER_COLOR, TEXT_BORDER_SIZE);
        for (dispKey in displayKeys) {
            add(dispKey);
        }

        var instruct:FlxText = new FlxText(Math.round((Util.relWidth(Dialogue.REL_DIALOGUE_WIDTH) / 2) -
            (INSTRUCT_WIDTH / 2)), INSTRUCT_DISTANCE_FROM_TOP, INSTRUCT_WIDTH,
            "", INSTRUCT_SIZE);
        instruct.alignment = CENTER;
        instruct.applyMarkup("Press the keys associated with the ingredients $in any order$!",
            [new FlxTextFormatMarkerPair(new FlxTextFormat(EMPHASIS_COLOR), "$")]);
        instruct.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
        instruct.font = AssetPaths.RobotoBlack__ttf;
        add(instruct);

        this.active = true;
        this.success = 0;
        this.failure = 0;
        queueID = QueueSystem.RANDOMSEQ;
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if (active) {
            for (key in POSSIBLE_KEYS) {
                if (FlxG.keys.anyJustPressed([key])) {
                    var foundAssociatedText:Bool = false;
                    for (keyText in displayKeys) {
                        if (keyText.text == key.toString()) {
                            keyText.color = CORRECT_COLOR;
                            displayKeys.remove(keyText);
                            this.success += 1;
                            foundAssociatedText = true;
                            break;
                        }
                    }
                    if (!foundAssociatedText) {
                        this.failure += 1;
                        add(new VanishingText(Math.round((Util.relWidth(Dialogue.REL_DIALOGUE_WIDTH) / 2) -
                            (VANISH_WIDTH / 2)), Math.round(Util.relHeight(Dialogue.REL_DIALOGUE_HEIGHT) / 2),
                            "Wrong key!", FONT_SIZE, VANISH_DELAY, VANISH_SPEED, INCORRECT_COLOR, VANISH_WIDTH));
                    } else if (success == target) {
                        this.active = false;
                        this.failMultiplier = (this.success / (this.success + this.failure));
                        complete();
                    }
                }
            }
        }
    }
}