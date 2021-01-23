package;

import flixel.group.FlxSpriteGroup;

/**
    Recipe interface to be used for all recipes
**/
class Recipe extends FlxSpriteGroup {

    // Constant for completed recipe
    public static inline final COMPLETED:Int = 1;
    // Constant for failed recipe
    public static inline final FAILED:Int = -1;
    // Constant for running recipe
    public static inline final RUNNING:Int = 0;

    // Callbacks for when a recipe is completed
    var onCompletionFns:Array<Recipe -> Void>;
    // Multiplier for performing recipe incorrectly
    public var failMultiplier:Float;
    // Reward for completing the recipe
    public var reward:Int;
    // The state of the recipe
    public var state:Int;
    // The id in the queueSystem of the recipe
    public var queueID:Int;
    // Name of recipe to be displayed
    var displayName:String;

    // Whether or not the dialogue is open. Don't set up mouse events if it is false :\
    var isOpen:Bool;

    override public function new(displayName:String, reward:Int, ?onCompletion:Recipe -> Void) {
        super(0, 0, 0);
        this.reward = Math.round(reward * Main.globalState.rewardMultiplier);
        this.failMultiplier = 1.0;
        this.displayName = displayName;
        state = RUNNING;
        onCompletionFns = [];
        if (onCompletion != null) {
            onCompletionFns.push(onCompletion);
        }
        queueID = -1;  // OVERWRITE IN SUBCLASSES
        isOpen = false;
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }

    /**
        Removes all completion listeners from the recipe
    **/
    public function clearCompletionListeners():Void {
        onCompletionFns = [];
    }

    /**
        Adds a listener function to be notified when the recipe is complete.
    **/
    public function addCompletionListener(fn:Recipe -> Void):Void {
        onCompletionFns.push(fn);
    }

    /**
        Notifies all of the completion listening functions
    **/
    public function complete():Void {
        state = COMPLETED;
        this.reward = Math.round(this.reward * this.failMultiplier);
        for (fn in onCompletionFns) {
            fn(this);
        }
    }

    /**
        Resets the x and y coordinates of the recipe to the initial configuration.
    **/
    public function resetOffset():Void {
        x = 0;
        y = 0;
    }

    /**
        Returns name of order
    **/
    public function getOrderName():String {
        return displayName;
    }

    /**
        Returns whether the dialogue contianing the recipe should close itself.
        If it is called, the value should be reset to false so that it can be re-opened.
    **/
    public function shouldCloseDialogue():Bool {
        return false;
    }

    /**
        Called when the dialogue containing the recipe is opened. Can set up event listeners
        Safely here.
    **/
    public function onDialogueOpen():Void {
        isOpen = true;
    }

    /**
        Called when the dialogue containing the recipe is closes. Remove set up event listeners
        safely here.
    **/
    public function onDialogueClose():Void {
        isOpen = false;
    }
}