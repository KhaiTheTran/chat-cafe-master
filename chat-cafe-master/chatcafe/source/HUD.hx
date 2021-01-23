package;

import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.input.mouse.FlxMouseEventManager;

/**
    The HUD manages the collection of UI elements and interaction between them.
 **/
class HUD extends FlxSpriteGroup {

    // The brown counter at the bottom of the screen
    var counterTop:FlxSpriteGroup;
    // The relative height of the countertop
    static inline final REL_COUNTER_HEIGHT:Float = 0.4;
    // Color for money popup
    static final MONEY_COLOR:FlxColor = FlxColor.GREEN.getLightened(0.4);
    // Keys for hotkeys
    static final CARD_KEYS:Array<Array<FlxKey>> = [[NUMPADONE, ONE], [NUMPADTWO, TWO],
    [NUMPADTHREE, THREE], [NUMPADFOUR, FOUR]];

    // Stores the cards on the counter
    public var orderCards:FlxSpriteGroup;
    // The relative height of a card
    static inline final REL_CARD_HEIGHT:Float = 0.25;
    // The relative width of a card
    static inline final REL_CARD_WIDTH:Float = 0.15;
    // The relative amount of space between cards
    static inline final REL_CARD_SPACING:Float = 0.05;

    // Size of the reward text
    static inline final REWARD_FONT_SIZE:Int = 40;
    // Time before the reward text goes away
    static inline final REWARD_VANISH_DELAY:Int = 1000;
    // Speed of the reward text
    static inline final REWARD_FLOAT_SPEED:Int = 100;
    // Color of failed recipe text
    static inline final FAILED_TEXT_COLOR:FlxColor = FlxColor.WHITE;
    // Color of partial failure percent text
    static final PERCENT_TEXT_COLOR:FlxColor = FlxColor.RED.getLightened(0.6);

    // An array of functions to be executed on the next update cycle, only once.
    var hudUpdateFns:Array<Void -> Void>;

    // Keeps track of the money
    public var moneyCounter:MoneyChecker;

    // Holds the dialogue when added
    var dialogueContainer:FlxSpriteGroup;
    // Holds if this iteration is a tutorial or not.
    var tutorial:Bool;
    // Basic dialogue opens
    public var isbasicDialogueOpen:Bool;

    ////ANALYTICS////
    // Classes to log
    static final ORDER_CARD_CLASSES:Array<String> =
        ["SequenceOrderCard", "TimedOrderCard", "RandomSequenceOrderCard", "CoffeeOrderCard", "CookieOrderCard"];
    // Completed recipes
    public var completed:Array<Int>;
    // Failed recipes
    public var failed:Array<Int>;

    public function new(?tutorial = false):Void {
        // Max size 0 means unlimited sprite capacity
        super(0, 0, 0);

        //// ANALYTICS ////
        completed = [];
        for (i in 0...ORDER_CARD_CLASSES.length) {
            completed[i] = 0;
        }
        failed = [];
        for (i in 0...ORDER_CARD_CLASSES.length) {
            failed[i] = 0;
        }
        //// ANALYTICS ////

        orderCards = new FlxSpriteGroup(0, 0, 0);
        hudUpdateFns = [];

        counterTop = new FlxSpriteGroup(Util.relWidth(0),
                                        Util.relHeight(1 - REL_COUNTER_HEIGHT),
                                        0);
        var counterTopSprite:FlxSprite = new FlxSprite(0, 0);
        counterTopSprite.loadGraphic(AssetPaths.Countertop__png);
        counterTop.add(counterTopSprite);
        counterTop.add(orderCards);
        add(counterTop);

        if (!tutorial) {
            moneyCounter = new MoneyChecker();
            add(moneyCounter);
        }

        dialogueContainer = new FlxSpriteGroup(0, 0, 0);
        add(dialogueContainer);

        this.tutorial = tutorial;
        this.isbasicDialogueOpen = false;
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        while (hudUpdateFns.length > 0) {
            // Remove and call a function
            hudUpdateFns.shift()();
        }

        // Card logic
        orderCards.forEach(orderCardUpdate);

        // Escape logic
        if (FlxG.keys.justPressed.ESCAPE && this.dialogueContainer.length >= 1) {
            var lastDialogue:Dialogue = cast this.dialogueContainer.members[this.dialogueContainer.length - 1];
            lastDialogue.closeDialogue();
        }

        for (i in 0...orderCards.members.length) {
            if (orderCards.members[i] != null && FlxG.keys.anyJustPressed(CARD_KEYS[i])) {
                cardClicked(cast orderCards.members[i]);
            }
        }
    }

    /**
        Function for managing order cards
    **/
    function orderCardUpdate(card:FlxSprite):Void {
        var castCard:OrderCard = cast card; // Unsafe casts, but it's all good yo
        if (castCard.recipe.state != Recipe.RUNNING) {
            // Destroy the dialogue
            var dialogue:Dialogue = cast dialogueContainer.group.getFirstExisting();
            if (dialogue != null && Std.is(dialogue, RecipeDialogue)) {
                var castDialogue:RecipeDialogue = cast dialogue;
                if (castDialogue.recipe  == castCard.recipe) {
                    destroyDialogue(dialogue);
                }
            }

            // Reward the player
            if (castCard.recipe.state == Recipe.COMPLETED) {
                logCardComplete(castCard, true);
                var recipeReward:Int = Math.round(castCard.recipe.reward);
                if (!tutorial) {
                    moneyCounter.updateMoney(Math.round(recipeReward * Main.globalState.rewardMultiplier));
                }
                if (castCard.recipe.failMultiplier < 1.0) {
                    add(new VanishingText(Math.round(castCard.x), Math.round(castCard.y - REWARD_FONT_SIZE),
                        "-" + Std.string(Math.round((1 - castCard.recipe.failMultiplier) * 100) + "%"),
                        REWARD_FONT_SIZE, REWARD_VANISH_DELAY, REWARD_FLOAT_SPEED, PERCENT_TEXT_COLOR));
                }
                add(new VanishingText(Math.round(castCard.x), Math.round(castCard.y),
                                      "+" + Std.string(recipeReward) + "$",
                                      REWARD_FONT_SIZE, REWARD_VANISH_DELAY,
                                      REWARD_FLOAT_SPEED, MONEY_COLOR));
            } else {
                add(new VanishingText(Math.round(castCard.x), Math.round(castCard.y),
                                      "+0$",
                                      REWARD_FONT_SIZE, REWARD_VANISH_DELAY,
                                      REWARD_FLOAT_SPEED, FAILED_TEXT_COLOR));
                logCardComplete(castCard, false);
            }

            // Destroy the card
            orderCards.remove(card).destroy();
        }
    }

    /**
        Adds an OrderCard to the HUD with the provided text
     **/
    public function addCard(recipe:Recipe):Void {
        var firstEmpty:Int = 0;
        if (orderCards.length == 4 || orderCards.members.indexOf(null) != -1) {
            firstEmpty = orderCards.members.indexOf(null);
        } else {
            firstEmpty = orderCards.length;
        }
        var constructor:(Int, Int, Int, Int, String, Recipe) -> OrderCard;
        if (Std.is(recipe, TimedRecipe)) {
            constructor = TimedOrderCard.new;
        } else if (Std.is(recipe, RandomSequenceRecipe)) {
            constructor = RandomSequenceOrderCard.new;
        } else if (Std.is(recipe, CoffeeRecipe)){
            constructor = CoffeeOrderCard.new;
        } else if (Std.is(recipe, CookieRecipe)) {
            constructor = CookieOrderCard.new;
        } else {
            constructor = SequenceOrderCard.new;
        }
        var card:OrderCard = constructor(Util.relWidth(REL_CARD_SPACING * (firstEmpty + 1) +
                                                         REL_CARD_WIDTH * firstEmpty),
                                           Util.relHeight(REL_COUNTER_HEIGHT - REL_CARD_HEIGHT),
                                           Util.relWidth(REL_CARD_WIDTH),
                                           Util.relHeight(REL_CARD_HEIGHT),
                                           recipe.getOrderName(),
                                           recipe);
        orderCards.insert(firstEmpty, card);
        FlxMouseEventManager.add(card, cardClicked);
    }

    /**
        Click event callback for cards which creates a new dialogue.
     **/
    public function cardClicked(target:OrderCard):Void {
        if (!dialogueOpen()) {
            var dialogue:Dialogue = new RecipeDialogue(target.recipe, this,
                    d -> destroyDialogue(d, target.recipe));
            this.dialogueContainer.add(dialogue);
        }
    }

    /**
        Destroys the given dialogue from reality
        If given a recipe, will remove it from the dialogue before destroying it to protect the recipe
    **/
    function destroyDialogue(dialogue:Dialogue, ?recipe:Recipe):Void {
        if (recipe != null) {
            dialogue.remove(recipe, true);
            // Reset the offset for the recipe so it can be re-added later
            recipe.resetOffset();
        }
        dialogueContainer.remove(dialogue, true).destroy();
    }

    /**
        Get the number of the card so that can add more on screen
    **/
    public function canAddCard():Bool {
        return (orderCards.length < 4 || (orderCards.length == 4 && orderCards.members.indexOf(null) != -1));
    }

    /**
        Log the completion of an order card, either successful or failed.
    **/
    function logCardComplete(card:OrderCard, didComplete:Bool):Void {
        var cardType:String = Type.getClassName(Type.getClass(card));
        for (i in 0...ORDER_CARD_CLASSES.length) {
            if (cardType == ORDER_CARD_CLASSES[i]) {
                completed[i] += didComplete ? 1 : 0;
                failed[i] += didComplete ? 0 : 1;
                break;
            }
        }
        Main.LOGGER.logLevelAction(Main.CARD_COMPLETE_ACTION, {
            type: cardType, didComplete: didComplete,
            recipeName: card.recipe.getOrderName()
        });
    }

    /**
        Returns true if there is a dialogue open
    **/
    public function dialogueOpen():Bool {
        return dialogueContainer.length >= 1;
    }

    /**
        call BasicDialogue
    **/
    public function callBasicDialogue(textFile:String):Void {
        if (!isbasicDialogueOpen) {
            var diames:Dialogue = new BasicDialogue(textFile, d -> closeBasicDialogue(d));
            dialogueContainer.add(diames);
            isbasicDialogueOpen = true;
        }
    }

    /**
        close BasicDialogue
    **/
    public function closeBasicDialogue(d:Dialogue):Void {
        isbasicDialogueOpen = false;
        dialogueContainer.remove(d, true).destroy();
    }

    /**
        Inserts something on top of the countertop
    **/
    public function insertAboveCountertop(sprite:FlxSprite):Void {
        insert(1, sprite);
    }
}
