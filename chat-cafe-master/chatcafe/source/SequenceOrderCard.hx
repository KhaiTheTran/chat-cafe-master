package;

import flixel.util.FlxColor;

/**
    Order Card for a Sequence recipe. Currently doesn't have anything significant
**/
class SequenceOrderCard extends OrderCard {

    // Color for card
    static final CARD_COLOR:FlxColor = FlxColor.YELLOW;

    public function new(x:Int, y:Int, width:Int, height:Int, text:String,
        recipe:Recipe):Void {
        super(x, y, width, height, text, recipe, CARD_COLOR);
    }
}