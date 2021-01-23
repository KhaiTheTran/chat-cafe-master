package;

import flixel.FlxG;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.text.FlxText;
import flixel.math.FlxRandom;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;

/**
    Put people on the screen in a queue, and when the people are 
    clicked, they can create a new order card on the screen.
**/
class QueueSystem extends FlxSpriteGroup {

    // Constant for SequenceRecipes
    public static inline final SEQUENCE:Int = 0;
    // Constant for timedRecipes
    public static inline final TIMED:Int = 1;
    // Constant for RandomSeqRecipes
    public static inline final RANDOMSEQ:Int = 2;
    // Constant for coffee
    public static inline final COFFEE:Int = 3;
    // Constant for GridCoffee
    public static inline final COOKIE:Int = 4;
    // Constant for recipe names, associated with the same indices
    public static final RECIPE_NAMES:Array<String> = ["Sequence", "Oven Recipe", "Scramble", "Coffee", "Cookie"];

    // Random object
    static final RANDOM:FlxRandom = new FlxRandom();
    // X coordinate of the person sprites.
    static inline final TEST_PERSON_SPRITE_X:Int = 200;
    // Y coordinate of the person sprites
    static inline final TEST_PERSON_SPRITE_Y:Int = 180;
    // The relative x coordinate to render the queue count at
    static inline final QUEUE_COUNT_X:Int = 110;
    // The relative y cordinate to render the queue count at
    static inline final QUEUE_COUNT_Y:Int = 110;
    // Color of queue count
    static inline final TEXT_COLOR:FlxColor = FlxColor.WHITE;
    // Color of queue count at capacity
    static inline final TEXT_CAPACITY_COLOR:FlxColor = FlxColor.RED;
    // font size
    static inline final QUEUE_COUNT_SIZE:Int = 30;
    // Queue text width
    static inline final QUEUE_WIDTH:Int = 500;
    // Shadow size for the queue text
    static inline final SHADOW_SIZE:Float = 3;

    // All possible people sprites that can occur
    // Indentation sucks, blame the linter
    static final ALL_PEOPLE:Array<String> = [AssetPaths.person1__png, AssetPaths.person2__png,
    AssetPaths.person3__png, AssetPaths.person4__png];
    // The last person to have been spawned
    var lastPerson:Int;

    // Other people in the queue
    var queue:Array<Person>;
    // Available recipes for this day
    var availableRecipes:Array<Int>;
    // The HUD, where OrderCards are added.
    var hud:HUD;
    // Timer for gradually adding people to queue
    var queueTimer:Timer;
    // Text to display number of people in queue
    var queueText:FlxText;
    // Max time between two people showing up in the queue
    var maxQueueTime:Int;
    // Min time between two epople showing up in the queue
    var minQueueTime:Int;

    /**
        Boolean flag for if the queue is being used for a tutorial
        If it is, then the queue will be capped at 5 people and the text is hidden
    **/
    var tutorial:Bool;

    public function new(hud:HUD, initialPeople:Int, availableRecipes:Array<Int>,
        minQueueTime:Int, maxQueueTime:Int, ?tutorial = false):Void {
        super();

        this.tutorial = tutorial;
        this.hud = hud;
        this.availableRecipes = availableRecipes;
        this.minQueueTime = minQueueTime;
        this.maxQueueTime = maxQueueTime;
        queue = [];

        queueTimer = new Timer(RANDOM.int(minQueueTime, maxQueueTime), addPerson);
        queueTimer.start();
        add(queueTimer);

        // Display the text above the first line in the queue.
        var personText:String;
        if (tutorial) {
            personText = "Click on a person or press space to take their order!";
        } else {
            personText = "Queue: " + initialPeople;
        }
        queueText = new FlxText(QUEUE_COUNT_X, QUEUE_COUNT_Y, QUEUE_WIDTH, personText, QUEUE_COUNT_SIZE);
        queueText.color = TEXT_COLOR;
        queueText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, SHADOW_SIZE);
        queueText.font = AssetPaths.RobotoBlack__ttf;
        queueText.alignment = CENTER;
        add(queueText);

        lastPerson = 0;
        for (_ in 0...initialPeople) {
            addPerson();
        }
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if (FlxG.keys.justPressed.SPACE) {
            onMouseClick(null);
        }
    }

    /**
        Fires when Timer runs out, setting a new timer and adding a person to the queue
    **/
    function addPerson():Void {
        if (queue.length < Main.globalState.queueLimit) {
            // First, determine what kind of recipe we're dealing with
            var recipe:Recipe;
            var recipeType:Int = RANDOM.getObject(availableRecipes);
            switch (recipeType) {
                case TIMED:
                    recipe = cast (RecipeFactory.getRandomTimedRecipe(), Recipe);
                case SEQUENCE:
                    recipe = cast (RecipeFactory.getRandomSetSequenceRecipe(), Recipe);
                case RANDOMSEQ:
                    recipe = cast (RecipeFactory.getRandomRandSequenceRecipe(), Recipe);
                case COFFEE:
                    recipe = cast (RecipeFactory.getRandomCoffee(), Recipe);
                case COOKIE:
                    recipe = cast (RecipeFactory.getCookieRecipe(), Recipe);
                case _:
                    throw new js.lib.Error("Unexpected recipe type");
            }

            // Next, let's pick the sprite to use.
            // for now, we decide from an array of sprites at random, and never repeat twice in a row
            var sprite:FlxSprite = new FlxSprite(0, 0);
            lastPerson = RANDOM.int(0, ALL_PEOPLE.length - 1, [lastPerson]);
            sprite.loadGraphic(ALL_PEOPLE[lastPerson]);

            // We can skip person name
            // We will need MaxWaitTime and locations, which should be ok.
            var person:Person = new Person(recipe, sprite, "Bleh", TEST_PERSON_SPRITE_X, TEST_PERSON_SPRITE_Y);
            queue.push(person);
            if (!tutorial) {
                queueText.text = "Queue: " + queue.length;
            }

            if (queue.length == 1) {
                add(person);
                FlxMouseEventManager.add(person, onMouseClick);
            }

            if (queue.length == Main.globalState.queueLimit && !tutorial) {
                queueText.color = TEXT_CAPACITY_COLOR;
            }
        }

        // Lastly, let's reset the timer.
        queueTimer.resetTime(RANDOM.int(minQueueTime, maxQueueTime));
        queueTimer.start();
    }

    /**
        Fires when the person is clicked, taking their order
    **/
    function onMouseClick(object:FlxSprite):Void {
        if (!hud.dialogueOpen() && hud.canAddCard() && queue.length > 0) {
            queueText.color = TEXT_COLOR;
            var personInFront:Person = queue.shift();
            remove(personInFront);
            if (queue.length >= 1) {
                add(queue[0]);
                FlxMouseEventManager.add(queue[0], onMouseClick);
            }
            if (!tutorial) {
                queueText.text = "Queue: " + queue.length;
            }
            hud.addCard(personInFront.getOrder());
        }
    }

    // Returns number of people currently in the queue
    function queueSize():Int {
        return queue.length;
    }
}