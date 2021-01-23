package;

import flixel.FlxG;
import flixel.FlxState;

/**
    Game state representing the starting menu
**/
class StartMenuState extends FlxState {

    // Height for title text. It should always be centered, so no length value necessary
    static inline final TITLE_TEXT_HEIGHT:Int = 20;
    // Size of title text
    static inline final TITLE_TEXT_SIZE:Int = 70;
    // Width of title text
    static inline final TITLE_TEXT_WIDTH:Int = 500;
    // height for start text
    static inline final START_TEXT_HEIGHT:Int = 800;
    // size for start txt
    static inline final START_TEXT_SIZE:Int = 40;
    // width of start text
    static inline final START_TEXT_WIDTH:Int = 500;
    // Height of transparent box for start button
    static inline final START_BOX_HEIGHT:Int = 100;
    // Vertical Offset for tutorial graphic
    static inline final TUTORIAL_OFFSET:Int = 175;
    // Height for tutorial graphic
    static inline final TUTORIAL_HEIGHT:Int = 600;
    // Width for tutorial graphic
    static inline final TUTORIAL_WIDTH:Int = 1000;

    // Relative X position of explanatory text
    static inline final EXPLAIN_X:Float = 0.15;
    // Relative Y position of explanatory text
    static inline final EXPLAIN_Y:Float = 0.4;
    // Relative Width of explanatory text
    static inline final EXPLAIN_WIDTH:Float = 0.7;
    // Explanatory text font size
    static inline final EXPLAIN_SIZE:Int = 40;
    // Action ID for a returning user
    static inline final RETURN_ID:Int = 420420;

    override public function create():Void {
        super.create();

        Util.scaleGameCamera();

        if (Main.save.data.globalState != null) {
            Main.LOGGER.logActionWithNoLevel(RETURN_ID, {
                returnPoint: Main.save.data.globalState.numDays
            });
            Util.fadeTo(new UpgradeMenuState());
        } else {
            Util.fadeToPlayOrTutorial();
        }

        /*

        var title:FlxText = new FlxText(Util.relWidth(0.5) - (TITLE_TEXT_WIDTH / 2),
            TITLE_TEXT_HEIGHT, TITLE_TEXT_WIDTH, "Chat Cafe", TITLE_TEXT_SIZE);
        title.alignment = CENTER;
        title.font = AssetPaths.IndieFlower__ttf;
        add(title);

        var explainText:FlxText = new FlxText(Util.relWidth(EXPLAIN_X), Util.relHeight(EXPLAIN_Y),
                                              Util.relWidth(EXPLAIN_WIDTH),
                                              "Earn money by completing orders, and use it to upgrade your cafe.\n\n" +
                                              "That's all there is to it. Earn as much as you can!",
                                              EXPLAIN_SIZE);
        explainText.alignment = CENTER;
        explainText.font = AssetPaths.RobotoBlack__ttf;
        add(explainText);

        var startText:FlxText = new FlxText(Util.relWidth(0.5) - (START_TEXT_WIDTH / 2),
            START_TEXT_HEIGHT, START_TEXT_WIDTH, "Click here to start the game!", START_TEXT_SIZE);
        startText.alignment = CENTER;
        startText.font = AssetPaths.RobotoBlack__ttf;
        add(startText);

        var startTextBox:FlxSprite = new FlxSprite(startText.x, startText.y);
        startTextBox.makeGraphic(START_TEXT_WIDTH, START_BOX_HEIGHT, 0x01000000);
        add(startTextBox);

        FlxMouseEventManager.add(startTextBox, startNextLevel);
        */
    }
}