package;

import flixel.input.mouse.FlxMouseEventManager;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
    A grid of colors appears and you need to select the 
    given colors from the grid that are all connected together.
**/
class CookieRecipe extends Recipe {

    // array of step cooking image
    static final COOKIE_IMGS:Array<String> = [AssetPaths.c1a__PNG, AssetPaths.c1__png,
        AssetPaths.c2__png, AssetPaths.c3__png, AssetPaths.c4__png, AssetPaths.c5__png,
    AssetPaths.c6__png];

    // Cookie distributions
    static final COOKIE_DISTRIBUTIONS:Array<Int> = [4, 3, 3, 2, 2, 1, 1];

    // Size of cookies
    static inline final COOKIE_SIZE:Int = 100;
    // distance from top for instructions
    static inline final INSTRUCT_DIST_FROM_TOP:Int = 50;
    // Instruction width
    static inline final INSTRUCT_WIDTH:Int = 500;
    // front size of text
    static inline final FONT_SIZE:Int = 40;
    // contain number for gird
    static inline final GRID_SPACE:Int = 105;
    // Button positions for y
    static final GRID_Y_COORDS:Array<Int> =
        [175, 175 + GRID_SPACE, 175 + (2 * GRID_SPACE), 175 + (3 * GRID_SPACE)];
    // Button positions for x
    static final GRID_X_COORDS:Array<Int> =
        [300, 300 + GRID_SPACE, 300 + (2 * GRID_SPACE), 300 + (3 * GRID_SPACE)];
    // Color of the cover for cookies (should have a low alpha)
    static final COVER_COLOR:FlxColor = FlxColor.BLACK.getLightened(0.2);
    // Cover alpha
    static inline final COVER_ALPHA:Float = 0.4;
    // list of buttons/cookies
    var buttons:Array<FlxSprite>;
    // list of button covers
    var buttonCovers:Map<Int, FlxSprite>;
    // Number of button covers, because god dammit there's no length for a map
    var buttonCoverCount:Int;
    // Text done button
    var doneButton:FlxSprite;
    // Indices of the 4 count cookie
    var correctCookies:Array<Int>;
    // Correct count, to keep us from having to iterate through correctCookies
    var correctCount:Int;

    // Size of the reward text
    static inline final REWARD_FONT_SIZE:Int = 50;
    // Failed key vanish delay
    static inline final VANISH_DELAY:Int = 1500;
    // Failed key vanish speed
    static inline final VANISH_SPEED:Int = 100;
    // Failed key vanish width
    static inline final VANISH_WIDTH:Int = 350;
    // Color for finish popup
    static final FINISH_COLOR:FlxColor = FlxColor.RED.getLightened(0.4);
    // postition left for show time and finish
    static inline final DONE_WIDTH:Int = 200;
    // DOne button distance from top
    static inline final DONE_BUTTON_TOP_DIST:Int = 640;

    override public function new(displayName:String,
        reward:Int, ?onCompletion:Recipe -> Void):Void {
        super(displayName, reward, onCompletion);
        var instructions:FlxText = new FlxText(Math.round(Util.relWidth(Dialogue.REL_DIALOGUE_WIDTH) / 2) -
            (INSTRUCT_WIDTH / 2), INSTRUCT_DIST_FROM_TOP, INSTRUCT_WIDTH, "Select 4 Identical Cookies", FONT_SIZE);
        instructions.alignment = CENTER;
        instructions.font = AssetPaths.RobotoBlack__ttf;
        instructions.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
        add(instructions);

        buttonCovers = [];
        buttonCoverCount = 0;
        buttons = [];

        doneButton = new FlxSprite(Util.relWidth(Dialogue.REL_DIALOGUE_WIDTH / 2) - Math.floor(DONE_WIDTH / 2),
                                   DONE_BUTTON_TOP_DIST, AssetPaths.cookiedone__png);
        add(doneButton);

        // load random image
        loadImages();
        queueID = QueueSystem.COOKIE;
    }

    /**
        helper function
    **/
    function loadImages():Void {
        correctCookies = [];
        // First, let's assign the cookie to a distribution
        var distr:Array<Int> = COOKIE_DISTRIBUTIONS.copy();
        var cookieCounts:Map<String, Int> = [];
        for (i in 0...distr.length) {
            var index:Int = Math.floor(Math.random() * distr.length);
            cookieCounts[COOKIE_IMGS[i]] = distr[index];
            distr.remove(distr[index]);
        }

        var indices:Array<Int> = [for (i in 0...16) i];
        // Then, let's set the pictures
        for (i in cookieCounts.keys()) {
            for (_ in 0...cookieCounts[i]) {
                var index:Int = indices[Math.floor(Math.random() * indices.length)];

                buttons[index] = new FlxSprite(GRID_X_COORDS[Math.floor(index / 4)], GRID_Y_COORDS[index % 4], i);
                buttons[index].setGraphicSize(COOKIE_SIZE, COOKIE_SIZE);
                add(buttons[index]);

                indices.remove(index);
                if (cookieCounts[i] == 4) {
                    correctCookies.push(index);
                }
            }
        }
    }

    /**
        Mouse click event when clicking on the done button
    **/
    function onMouseClickDone():Void {
        if (correctCount == 4 && buttonCoverCount == 4) {
            this.complete();
        } else {
            add(new VanishingText(Math.round((Util.relWidth(Dialogue.REL_DIALOGUE_WIDTH) / 2) -
                (VANISH_WIDTH / 2)), Math.round(Util.relHeight(Dialogue.REL_DIALOGUE_HEIGHT) / 2),
                "Wrong cookies!", REWARD_FONT_SIZE, VANISH_DELAY,
                VANISH_SPEED, FINISH_COLOR, VANISH_WIDTH));
        }
    }

    /**
        Mouse click event when clicking on a cookie
    **/
    public function onMouseClickCookie(id:Int):Void {
        if (correctCookies.indexOf(id) != -1) {
            correctCount++;
        }
        buttonCoverCount++;

        FlxMouseEventManager.remove(buttons[id]);
        var cover:FlxSprite = new FlxSprite(GRID_X_COORDS[Math.floor(id / 4)], GRID_Y_COORDS[id % 4]);
        cover.makeGraphic(COOKIE_SIZE, COOKIE_SIZE, COVER_COLOR);
        cover.alpha = COVER_ALPHA;
        add(cover);

        buttonCovers.set(id, cover);
        FlxMouseEventManager.add(cover, _ -> onMouseClickCover(id));
    }

    /**
        Mouse click event when clicking on a cover
    **/
    public function onMouseClickCover(id:Int):Void {
        if (correctCookies.indexOf(id) != -1) {
            correctCount--;
        }
        buttonCoverCount--;

        var cover:FlxSprite = buttonCovers[id];
        FlxMouseEventManager.remove(cover);
        buttonCovers.remove(id);
        this.remove(cover).destroy();
        FlxMouseEventManager.add(buttons[id], _ -> onMouseClickCookie(id));
    }

    override public function onDialogueOpen():Void {
        super.onDialogueOpen();
        for (i in 0...16){
            if (buttonCovers[i] != null) {
                FlxMouseEventManager.remove(buttonCovers[i]);
                FlxMouseEventManager.add(buttonCovers[i], _ -> onMouseClickCover(i));
            } else {
                FlxMouseEventManager.remove(buttons[i]);
                FlxMouseEventManager.add(buttons[i], _ -> onMouseClickCookie(i));
            }
        }
        FlxMouseEventManager.remove(doneButton);
        FlxMouseEventManager.add(doneButton, _ -> onMouseClickDone());
    }

    override public function onDialogueClose():Void {
        super.onDialogueClose();
        for (i in 0...16){
            if (buttonCovers[i] != null) {
                FlxMouseEventManager.remove(buttonCovers[i]);
            } else {
                FlxMouseEventManager.remove(buttons[i]);
            }
        }
        FlxMouseEventManager.remove(doneButton);
    }
}