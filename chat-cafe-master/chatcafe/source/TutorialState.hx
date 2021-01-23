package;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;

/**
    Game state that displays a recipe and instructions to help a user play it
**/
class TutorialState extends FlxState {

    // Distance from the right side of the screen for the play button
    static inline final DIST_FROM_RIGHT:Int = 10;
    // Playbutton size
    static inline final PLAY_SIZE:Int = 128;
    // Play text width
    static inline final PLAY_WIDTH:Int = 350;
    // Play text font size
    static inline final TOOLTIP_FONT:Int = 30;
    // Play text font color
    static final PLAY_COLOR:FlxColor = FlxColor.WHITE;
    // Title text width
    static inline final TITLE_WIDTH:Int = 600;
    // Title text font size
    static inline final TITLE_FONT_SIZE:Int = 50;
    // Title shadow size
    static inline final SHADOW_SIZE:Float = 3;
    // Title text font distance from top
    static inline final TITLE_DIST_FROM_TOP:Int = 10;
    // Fade time to gameplay
    static inline final FADE_TIME:Float = 0.5;

    // "TUTORIAL" color
    static inline final START_TEXT_COLOR:FlxColor = FlxColor.WHITE;
    // "TUTORIAL" size
    static inline final START_TEXT_SIZE:Int = 50;
    // "TUTORIAL" Y coordinate
    static inline final START_TEXT_Y:Int = 400;
    // "TUTORIAL" Duration
    static inline final START_TEXT_DURATION:Int = 3500;
    // "TUTORIAL" Speed
    static inline final START_TEXT_SPEED:Int = 0;
    // Tutorial text for order cards Y offset
    static inline  final TUTORIAL_Y_OFFSET:Int = 600;

    // Int of the recipe that the tutorial should be associated with
    var recipe:Int;
    // Hud
    var hud:HUD;

    override public function new(recipe:Int) {
        super();
        this.recipe = recipe;
    }

    override public function create():Void {
        FlxG.cameras.bgColor = 0x3051AB76;

        super.create();

        Util.scaleGameCamera();

        // Create the hud again
        this.hud = new HUD(true);

        var cafebg:FlxSprite = new FlxSprite(0, 0, AssetPaths.cafebg__png);
        add(cafebg);

        var qs:QueueSystem = new QueueSystem(hud, 4, [recipe], 1000, 2000, true);
        add(qs);

        // Pause button
        var pauseBtn:FlxSprite = new FlxSprite(0, 0);
        pauseBtn.loadGraphic(AssetPaths.PauseBtn__png);
        pauseBtn.scale.x = pauseBtn.scale.y = 0.5;
        pauseBtn.updateHitbox();
        FlxMouseEventManager.add(pauseBtn, _ -> openSubState(new PauseMenu()));

        // Play button
        var playBtn:FlxSprite = new FlxSprite(FlxG.width - PLAY_SIZE, 0);
        playBtn.loadGraphic(AssetPaths.PlayBtn__png);
        playBtn.scale.x = playBtn.scale.y = 0.5;
        playBtn.updateHitbox();
        FlxMouseEventManager.add(playBtn, _ -> changeState());

        var nextLevelText:String = null;
        if (Main.globalState.tutorialRecipes.length == 0) {
            nextLevelText = "Click here to end the tutorial and start the day!";
        } else {
            nextLevelText = "Click here to continue!";
        }

        var playText:FlxText = new FlxText(FlxG.width - PLAY_WIDTH,
            PLAY_SIZE, PLAY_WIDTH, nextLevelText,
            TOOLTIP_FONT);
        playText.color = PLAY_COLOR;
        playText.alignment = RIGHT;
        playText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, SHADOW_SIZE);
        playText.font = AssetPaths.RobotoBlack__ttf;
        add(playText);

        // Title text for the tutorial
        var titleText:FlxText = new FlxText(0, TITLE_DIST_FROM_TOP, Util.relWidth(1),
                                            "Tutorial: " + QueueSystem.RECIPE_NAMES[this.recipe],
                                            TITLE_FONT_SIZE);
        titleText.font = AssetPaths.RobotoBlack__ttf;
        titleText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, SHADOW_SIZE);
        titleText.alignment = CENTER;
        add(titleText);

        var startText:VanishingText = new VanishingText(0, START_TEXT_Y,
                                                        "TUTORIAL: " + QueueSystem.RECIPE_NAMES[this.recipe],
                                                        START_TEXT_SIZE,
                                                        START_TEXT_DURATION, START_TEXT_SPEED, START_TEXT_COLOR,
                                                        Util.relWidth(1));
        startText.displayText.alignment = CENTER;
        add(startText);

        var orderTutorial:FlxText = new FlxText(0, TUTORIAL_Y_OFFSET, Util.relWidth(1),
                                                "Click an order card or use the number keys to cook a recipe",
                                                TOOLTIP_FONT);
        orderTutorial.color = PLAY_COLOR;
        orderTutorial.alignment = CENTER;
        orderTutorial.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, SHADOW_SIZE);
        orderTutorial.font = AssetPaths.RobotoBlack__ttf;
        hud.insertAboveCountertop(orderTutorial);

        add(playBtn);
        add(hud);
        add(pauseBtn);
    }

    /**
        Changes state if no dialogue is open in the hud
    **/
    function changeState():Void {
        if (!hud.dialogueOpen()) {
            Main.LOGGER.logLevelEnd();
            Util.fadeToPlayOrTutorial();
        }
    }
}