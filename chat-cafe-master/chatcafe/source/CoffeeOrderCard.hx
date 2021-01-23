package;

import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
    Order card for a coffee recipe
**/
class CoffeeOrderCard extends OrderCard {

    // Color for card
    static final CARD_COLOR:FlxColor = FlxColor.BLUE.getLightened(0.6);
    // The initial text on the OrderCard
    var iniText:String;
    // The timer for the recipe
    var recipeTimer:Timer;

    // Height of timer text above the card
    static final TEXT_HEIGHT_ABOVE_CARD:Int = 50;
    // Color of timer text when finished
    static final FINISHED_COLOR:FlxColor = FlxColor.GREEN.getLightened(0.3);
    // Text for timer
    var timerText:FlxText;

    public function new(x:Int, y:Int, width:Int, height:Int, text:String,
        recipe:Recipe):Void {
        super(x, y, width, height, text, recipe, CARD_COLOR);
        var castedRecipe:CoffeeRecipe = cast(recipe, CoffeeRecipe);
        recipeTimer = castedRecipe.getOvenTimer();
        insert(0, recipeTimer);
        iniText = text;
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if (recipeTimer.getIsRunning()) {
            if (timerText == null) {
                timerText = new FlxText(0, 0 - TEXT_HEIGHT_ABOVE_CARD, cardText.width,
                    "", cardText.size);
                timerText.color = FlxColor.WHITE;
                timerText.alignment = CENTER;
                add(timerText);
            }
            var secondsLeft:Int = Math.round(recipeTimer.getTimeLeft() / 1000.0);
            timerText.text = "Time Left: " + Std.string(secondsLeft);
        } else if (recipeTimer.isFinished()) {
            timerText.text = "Done pouring!";
            timerText.color = FINISHED_COLOR;
        }
    }
}