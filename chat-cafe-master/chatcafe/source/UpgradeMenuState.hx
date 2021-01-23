package;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;

/**
    Game state that displays a score and allows one to restart the game.
**/
class UpgradeMenuState extends FlxState {

    // Y coordinate for title text
    static inline final TITLE_TEXT_Y:Int = 10;
    // Size of title text
    static inline final TITLE_TEXT_SIZE:Int = 80;
    // X coordinate for start text
    static inline final START_TEXT_X:Int = 120;
    // Y coordinate for start text
    static inline final START_TEXT_Y:Int = 830;
    // Width for start text
    static inline final START_TEXT_WIDTH:Int = 400;
    // Size of start text
    static inline final START_TEXT_SIZE:Int = 45;

    // Y coordinate of the upgrade header
    static inline final UPGRADE_HEADER_Y:Int = 120;
    // Font size of the upgrade header
    static inline final UPGRADE_HEADER_SIZE:Int = 40;
    // Y coordinate of the money display
    static inline final MONEY_Y:Int = 170;
    // Font size of the money display
    static inline final MONEY_SIZE:Int = 25;
    // X coordinate of the upgrades
    static inline final UPGRADE_X:Int = 40;
    // Y coordinate of the first upgrade
    static inline final UPGRADE_Y:Int = 230;
    // Space from the top of one upgrade to the top of the next one
    static inline final UPGRADE_SPACE:Int = 125;

    // X coordinate for win game button
    static inline final WIN_TEXT_X:Int = 620;
    // Y coordinate for win game button is same as start text
    // Width for win game button
    static inline final WIN_TEXT_WIDTH:Int = 560;
    // Font size for win game button
    static inline final WIN_TEXT_SIZE:Int = 35;

    // Action ID for beating the game
    static inline final GAME_COMPLETE_ACTION:Int = 6969;

    // The money display text
    var moneyDisplay:FlxText;
    // Save text, if needed
    var saveText:FlxText;
    // Save timer, if needed
    var saveTimer:Timer;

    override public function new() {
        super();
    }

    override public function create():Void {
        FlxG.cameras.bgColor = 0xFF131C1B;

        super.create();

        Util.scaleGameCamera();

        var title:FlxText = new FlxText(0, TITLE_TEXT_Y, Util.relWidth(1), "Day Complete!", TITLE_TEXT_SIZE);
        title.alignment = CENTER;
        title.font = AssetPaths.RobotoBlack__ttf;
        if (Main.globalState.numDays > 2) {
            title.text = "Welcome back!";
        }
        add(title);

        // Half is 640
        var startText:FlxText = new FlxText(START_TEXT_X, START_TEXT_Y, START_TEXT_WIDTH,
                                            "Click here to start the next day!", START_TEXT_SIZE);
        startText.alignment = CENTER;
        startText.font = AssetPaths.RobotoBlack__ttf;
        add(startText);

        var resumeButton:FlxSprite = new FlxSprite(startText.x, startText.y);
        resumeButton.makeGraphic(START_TEXT_WIDTH, Math.round(startText.height), 0x01000000);
        add(resumeButton);
        FlxMouseEventManager.add(resumeButton, startLevelOne);

        var endText:FlxText = new FlxText(WIN_TEXT_X, START_TEXT_Y, WIN_TEXT_WIDTH,
                                        null, WIN_TEXT_SIZE);
        endText.font = AssetPaths.RobotoBlack__ttf;
        endText.alignment = CENTER;
        if (Main.globalState.won) {
            endText.text = "You've paid your loans, the rest is just for fun :)";
            add(endText);
        } else if (Main.globalState.money < Main.GOAL_MONEY) {
            endText.color = FlxColor.GRAY.getLightened();
            endText.text = "You need $" + Main.GOAL_MONEY + " to pay off your loans";
            add(endText);
        } else {
            endText.text = "Click here to pay off your $" + Main.GOAL_MONEY + " loan!";
            add(endText);

            var endButton:FlxSprite = new FlxSprite(endText.x, endText.y);
            endButton.makeGraphic(START_TEXT_WIDTH, Math.round(endText.height), 0x01000000);
            add(endButton);
            FlxMouseEventManager.add(endButton, endGame);
        }

        // Upgrades
        var upgradeHeader:FlxText = new FlxText(0, UPGRADE_HEADER_Y, Util.relWidth(1),
                                                "Buy Some Upgrades?", UPGRADE_HEADER_SIZE);
        upgradeHeader.alignment = CENTER;
        upgradeHeader.font = AssetPaths.RobotoBlack__ttf;
        add(upgradeHeader);

        moneyDisplay = new FlxText(0, MONEY_Y, Util.relWidth(1),
                                   "Account balance: $" + Std.string(Main.globalState.money), MONEY_SIZE);
        moneyDisplay.alignment = CENTER;
        moneyDisplay.font = AssetPaths.RobotoBlack__ttf;
        add(moneyDisplay);

        Main.save.data.globalState = Main.globalState;
        Main.save.flush();

        var upg1:UpgradeOvenTimer = new UpgradeOvenTimer(UPGRADE_X, UPGRADE_Y);
        add(upg1);
        var upg2:UpgradeQueueLimit = new UpgradeQueueLimit(UPGRADE_X, UPGRADE_Y + UPGRADE_SPACE * 1);
        add(upg2);
        var upg3:UpgradeQueueTime = new UpgradeQueueTime(UPGRADE_X, UPGRADE_Y + UPGRADE_SPACE * 2);
        add(upg3);
        var upg4:UpgradeRecipes = new UpgradeRecipes(UPGRADE_X, UPGRADE_Y + UPGRADE_SPACE * 3);
        add(upg4);
        var upg5:UpgradeRewards = new UpgradeRewards(UPGRADE_X, UPGRADE_Y + UPGRADE_SPACE * 4);
        add(upg5);
    }

    override function update(elapsed:Float):Void {
        super.update(elapsed);
        moneyDisplay.text = "Account balance: $" + Std.string(Main.globalState.money);
    }

    /**
        Callback to start the game over and collect analytics
    **/
    function startLevelOne(_:FlxSprite):Void {
        Main.LOGGER.logLevelStart(1, {
            replay: true,
            day: Main.globalState.numDays
        });

        Util.fadeToPlayOrTutorial();
    }

    /**
        Ends game
    **/
    function endGame(_:FlxSprite):Void {
        Main.LOGGER.logActionWithNoLevel(GAME_COMPLETE_ACTION, {
            day: Main.globalState.numDays
        });
        Main.globalState.money -= 200000;
        Main.globalState.won = true;
        Util.fadeTo(new GameEndState());
    }
}