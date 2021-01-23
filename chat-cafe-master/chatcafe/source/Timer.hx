package;

import flixel.FlxSprite;
import flixel.math.FlxMath;

/**
    Represents a timer which counts down from some value.
    Callbacks can be triggered upon completion.
**/
class Timer extends FlxSprite {

    // Callbacks for when a recipe is completed
    var onCompletionFns:Array<Void -> Void>;

    // The number of miliseconds remaining
    var timeLeft:Int;

    // Whether the timer is running
    var isRunning:Bool;

    // Initial time set
    var initialTime:Int;

    override public function new(miliseconds:Int, ?callback:Void -> Void) {
        super(0, 0);

        // Remove default sprite
        makeGraphic(1, 1);
        alpha = 0;

        timeLeft = FlxMath.maxInt(0, miliseconds);
        initialTime = timeLeft;

        isRunning = false;

        onCompletionFns = [];
        if (callback != null) {
            onCompletionFns.push(callback);
        }
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if (isRunning) {
            if (timeLeft <= 0) {
                timeLeft = 0;
                isRunning = false;
                complete();
            } else {
                timeLeft -= Math.round(elapsed * 1000);
            }
        }
    }

    /**
        Returns whether the timer is finished:
    **/
    public function isFinished():Bool {
        return timeLeft <= 0;
    }

    /**
        Returns the number of miliseconds left on the timer.
    **/
    public function getTimeLeft():Int {
        return timeLeft;
    }

    /**
        Removes all completion listeners from the timer
    **/
    public function clearCompletionListeners():Void {
        onCompletionFns = [];
    }

    /**
        Adds a listener function to be notified when the timer is finished.
    **/
    public function addCompletionListener(fn:Void -> Void):Void {
        onCompletionFns.push(fn);
    }

    /**
        Notifies all of the completion listening functions
    **/
    public function complete():Void {
        for (fn in onCompletionFns) {
            fn();
        }
    }

    /**
        Returns true iff the timer is running
    **/
    public function getIsRunning():Bool {
        return isRunning;
    }

    /**
        Start the timer
        Returns true if the timer was started.
        Returns false if it was not (it is already complete)
    **/
    public function start():Bool {
        if (timeLeft > 0) {
            isRunning = true;
            return true;
        }
        return false;
    }

    /**
        Stop the timer, assuming it was running.
    **/
    public function stop():Void {
        isRunning = false;
    }
    /**.
        Reset the timer to new timer if one is passed
        Stops the timer.
    **/
    public function resetTime(?newTime:Int = 0):Void {
        if (newTime > 0) {
            initialTime = newTime;
        }
        timeLeft = initialTime;
        isRunning = false;
    }
}