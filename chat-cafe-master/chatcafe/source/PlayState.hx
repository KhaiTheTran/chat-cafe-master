package;

import flixel.input.keyboard.FlxKey;
import flixel.input.FlxInput;
import flixel.text.FlxText;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

/**
    The PlayState manages the state of game objects.
**/
class PlayState extends FlxState {

    // X coordinate of the person sprites.
    static inline final TEST_PERSON_SPRITE_X:Int = 200;
    // Y coordinate of the person sprites
    static inline final TEST_PERSON_SPRITE_Y:Int = 300;
    // Pause button size
    static inline final PAUSE_BTN_SIZE:Int = 30;

    // Ok player score
    static inline final OK_PLAYER_SCORE:Int = 7000;
    // Ok player upgrade multiplier
    static inline final OK_PLAYER_MULTIPLIER:Float = 0.75;
    // Bad player score
    static inline final BAD_PLAYER_SCORE:Int = 5000;
    // Bad player upgrade multiplier
    static inline final BAD_PLAYER_MULTIPLIER:Float = 0.5;
    // Terrible player score
    static inline final TERRIBLE_PLAYER_SCORE:Int = 2500;
    // Terrible player upgrade multiplier
    static inline final TERRIBLE_PLAYER_MULTIPLIER:Float = 0.25;

    // Game ending timer
    var gameEndTimer:Timer;
    // Visual for game ending timer
    var timerVisual:FlxText;
    // hud reference
    var hud:HUD;
    // The background for the cafe
    var cafebg:FlxSprite;
    // Whether it has been set to night time yet
    var nightTime:Bool;
    // Amount of money at the start of the level. For logging.
    var initialMoney:Int;
    // Background for the timer width
    static inline final TIMER_BG_WIDTH:Int = 150;
    // Timer color
    static inline final TIMER_COLOR:FlxColor = FlxColor.BLACK;
    // Time limit for the game in ms
    static inline final TIME_LIMIT:Int = 90000;
    // Size of the game ending timer
    static inline final GAME_TIMER_SIZE:Int = 50;
    // Time for when the timer changes color
    static inline final LOW_GAME_TIME:Int = 10000;
    // Color to change to when the game time is low
    static inline final LOW_GAME_TIME_COLOR:FlxColor = FlxColor.RED;

    // "DAY START" color
    static inline final START_TEXT_COLOR:FlxColor = FlxColor.GREEN;
    // "DAY START" size
    static inline final START_TEXT_SIZE:Int = 60;
    // "DAY START" Y coordinate
    static inline final START_TEXT_Y:Int = 400;
    // "DAY START" Duration
    static inline final START_TEXT_DURATION:Int = 2500;
    // "DAY START" Speed
    static inline final START_TEXT_SPEED:Int = 0;

    // Action ID for developer action
    static inline final DEV_ACTION:Int = 420;

    // Stores whether the developer logigng action has occurred
    var notYetLoggedDeveloper:Bool;

    override public function create():Void {
        super.create();

        Util.scaleGameCamera();

        // HUD test cards
        hud = new HUD();

        cafebg = new FlxSprite(0, 0, AssetPaths.cafebg__png);
        add(cafebg);

        initialMoney = Main.globalState.money;

        var qs:QueueSystem = new QueueSystem(hud, 1, Main.globalState.unlockedRecipes,
            Main.globalState.queueLowerBound, Main.globalState.queueUpperBound);
        add(qs);

        // DAY START text
        var startText:VanishingText = new VanishingText(0, START_TEXT_Y, "DAY " + Std.string(Main.globalState.numDays) +
                                                        " START!", START_TEXT_SIZE,
                                                        START_TEXT_DURATION, START_TEXT_SPEED, START_TEXT_COLOR,
                                                        Util.relWidth(1));
        startText.displayText.alignment = CENTER;
        add(startText);

        // Pause button
        var pauseBtn:FlxSprite = new FlxSprite(0, 0);
        pauseBtn.loadGraphic(AssetPaths.PauseBtn__png);
        pauseBtn.scale.x = pauseBtn.scale.y = 0.5;
        pauseBtn.updateHitbox();
        FlxMouseEventManager.add(pauseBtn, _ -> openSubState(new PauseMenu()));

        // game ending code.
        var timerbg:FlxSprite = new FlxSprite(Util.relWidth(0.5) - (TIMER_BG_WIDTH / 2), 0,
                                              AssetPaths.gametimerbg__png);
        add(timerbg);

        var timeLimit:Int = TIME_LIMIT;
        gameEndTimer = new Timer(timeLimit);
        add(gameEndTimer);
        gameEndTimer.start();
        timerVisual = new FlxText(0, 0, Util.relWidth(1), Std.string(Math.round(timeLimit / 1000)), GAME_TIMER_SIZE);
        timerVisual.alignment = FlxTextAlign.CENTER;
        timerVisual.font = AssetPaths.RobotoBlack__ttf;
        timerVisual.color = TIMER_COLOR;
        add(timerVisual);

        // The HUD must go on top of everything else.
        add(hud);
        // Except the pause button
        add(pauseBtn);
        notYetLoggedDeveloper = true;
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // Daytime shift
        if (gameEndTimer.getTimeLeft() < TIME_LIMIT / 3 && !nightTime) {
            nightTime = true;
            cafebg.loadGraphic(AssetPaths.cafebgnight__png);
        }

        // Game timer update
        if (gameEndTimer.isFinished()) {
            Main.LOGGER.logLevelEnd({
                level: 1, total_money: Main.globalState.money,
                level_money: Main.globalState.money - initialMoney, completed: hud.completed, failed: hud.failed,
                day: Main.globalState.numDays
            });
            // If first day, set the pity factor
            if (Main.globalState.numDays == 1 && Main.abkey == 1) {
                if (Main.globalState.money < TERRIBLE_PLAYER_SCORE) {
                    Main.globalState.pityFactor = TERRIBLE_PLAYER_MULTIPLIER;
                } else if (Main.globalState.money < BAD_PLAYER_SCORE) {
                    Main.globalState.pityFactor = BAD_PLAYER_MULTIPLIER;
                } else if (Main.globalState.money < OK_PLAYER_SCORE) {
                    Main.globalState.pityFactor = OK_PLAYER_MULTIPLIER;
                }
            }
            Main.globalState.numDays++;

            FlxG.switchState(new UpgradeMenuState());
        } else if (gameEndTimer.getTimeLeft() < LOW_GAME_TIME) {
            timerVisual.color = LOW_GAME_TIME_COLOR;
        }
        timerVisual.text = Std.string(Math.round(gameEndTimer.getTimeLeft() / 1000));

        // If this specific key is pressed, log developer user ID.
        if (notYetLoggedDeveloper) {
            var downKeys:Array<FlxInput<FlxKey>> = FlxG.keys.getIsDown();
            if (downKeys.length == 2 && (downKeys[0].ID == PAGEDOWN || downKeys[0].ID == PAGEUP) &&
                (downKeys[1].ID == PAGEDOWN || downKeys[1].ID == PAGEUP)) {
                Main.LOGGER.logActionWithNoLevel(DEV_ACTION);
                notYetLoggedDeveloper = false;
            }
        }
    }
}
