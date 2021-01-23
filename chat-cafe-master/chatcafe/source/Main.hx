package;

import flixel.util.FlxSave;
import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.FlxG;

/**
    Stores the persistent state across the game. May be modified by upgrades.
**/
typedef GlobState = {
    pityFactor: Float,
    money: Int,
    unlockedRecipes: Array<Int>,
    tutorialRecipes: Array<Int>,
    queueLowerBound: Int,
    queueUpperBound: Int,
    queueLimit: Int,
    rewardMultiplier: Float,
    ovenTimeMultiplier: Float,
    numDays: Int,
    won:Bool
}

/** 
    The main loop of the game
 **/
class Main extends Sprite {

    // A global variable for tracking the logger
    public static var LOGGER:CapstoneLogger;

    // A global variable for tracking player data
    public static var globalState:GlobState;

    // the abtesting state of the game. 1 if we do adaptation, 0 if not.
    public static var abkey:Int;

    // Save object
    public static var save:FlxSave;

    // A constant for debug mode when logging.
    public static inline final DEBUG:Int = 1;
    // A constant for testing locally with others when logging.
    public static inline final LOCAL_TEST:Int = 2;
    // A constant for testing on a public release when logging.
    public static inline final PUBLIC_TEST:Int = 3;
    // A constant for the second public test
    public static inline final PUBLIC_TEST_2:Int = 4;
    // A constant for the third public test
    public static inline final PUBLIC_TEST_3:Int = 10;
    // A constant for the fourth public test
    public static inline final PUBLIC_TEST_4:Int = 12;
    // Which mode we are currently using for logging. Change before building.
    public static inline final CURR_MODE:Int = DEBUG;

    // How much to scale the screen by. Change based on deployment
    public static inline final SCALE_RATIO:Float = 1;

    // Tutorial text files
    public static final TUTORIAL_TXT_FILES:Array<String> =
        [AssetPaths.set_seq_recipe_tutorial__txt,
        AssetPaths.timed_recipe_tutorial__txt,
        AssetPaths.rand_seq_recipe_tutorial__txt,
        AssetPaths.coffee_recipe_tutorial__txt,
        AssetPaths.cookie_recipe_tutorial__txt];

    // Global state initialization constants
    // Initial upgrade multipliier
    public static inline final INITIAL_PITY_FACTOR:Float = 1.0;
    // Initial money
    public static inline final INIT_MONEY:Int = 0;
    // Initial unlocked recipes
    public static final INIT_RECIPES:Array<Int> = [QueueSystem.SEQUENCE, QueueSystem.TIMED];
    // Initial tutorials required
    public static final INIT_TUTORIAL_RECIPES:Array<Int> = [QueueSystem.SEQUENCE, QueueSystem.TIMED];
    // Initial queue lower bound
    public static inline final INIT_QUEUE_LOWER:Int = 3000;
    // Initial queue upper bound
    public static inline final INIT_QUEUE_UPPER:Int = 5000;
    // Initial queue capacity
    public static inline final INIT_QUEUE_LIMIT:Int = 4;
    // Initial reward multiplier
    public static inline final INIT_REWARD_MULTIPLIER:Float = 1;
    // Initial timed recipe multiplier
    public static inline final INIT_OVEN_MULTIPLIER:Float = 1;
    // Amount of money required to win the game
    public static inline final GOAL_MONEY:Int = 200000;

    // Analytic constants
    // The id of the action for completing a card
    public static inline final CARD_COMPLETE_ACTION:Int = 1;
    // The id of the action for buying an upgrade. Takes up 4 additional ids above it for each upgrade.
    public static inline final UPGRADE_BUY_ACTION:Int = 2;

    public function new() {
        super();

        // AB TESTING
        abkey = Math.round(Math.random());

        var gameId:Int = 202005;
        var gameKey:String = "0f62265227df1b6d6deec36ab4bc5e76";
        var gameName:String = "chatcafe";
        var categoryId:Int = (CURR_MODE == PUBLIC_TEST_3) ? CURR_MODE + abkey : CURR_MODE;
        Main.LOGGER = new CapstoneLogger(gameId, gameName, gameKey, categoryId, false);

        // Initial configuration of the game.
        save = new FlxSave();
        save.bind("SaveData");
        if (save.data.globalState == null) {
            resetToDefaultState();
        } else {
            globalState = save.data.globalState;
        }

        // Retrieve the user (saved in local storage for later)
        var userId:String = Main.LOGGER.getSavedUserId();
        if (userId == null) {
            userId = Main.LOGGER.generateUuid();
            Main.LOGGER.setSavedUserId(userId);
        }
        Main.LOGGER.startNewSession(userId, this.onSessionReady);
    }

    /**
        Set global state to default values
    **/
    public static function resetToDefaultState():Void {
        globalState = {
            pityFactor: INITIAL_PITY_FACTOR, // Initial multiplier for upgrades to be scaled
            money: INIT_MONEY, // Amount of money in account
            unlockedRecipes: INIT_RECIPES, // Recipes that appear in game
            tutorialRecipes: INIT_TUTORIAL_RECIPES, // Initial set of tutorials to run through
            queueLowerBound: INIT_QUEUE_LOWER, // Lowerbound on spawn timer
            queueUpperBound: INIT_QUEUE_UPPER, // Upperbound on spawn timer
            queueLimit: INIT_QUEUE_LIMIT, // Maximum number of people waiting in the queue
            rewardMultiplier: INIT_REWARD_MULTIPLIER, // Multiplier on recipe rewards
            ovenTimeMultiplier: INIT_OVEN_MULTIPLIER, // Multiplier on how long the oven takes to run
            numDays: 1, // The number of days the player has played through.
            won: false
        };
    }

    /**
        A callback triggered when logging is ready, to start the game
    **/
    function onSessionReady(sessionRecieved:Bool):Void {
        addChild(new FlxGame(0, 0, StartMenuState));
    }
}
