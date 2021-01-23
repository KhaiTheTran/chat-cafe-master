package;

import flixel.util.FlxColor;

/**
    Order card for a coffee recipe
**/
class CookieOrderCard extends OrderCard {

    // Color for card
    static final CARD_COLOR:FlxColor = new FlxColor(0xFFF5C242);

    public function new(x:Int, y:Int, width:Int, height:Int, text:String,
        recipe:Recipe):Void {
        super(x, y, width, height, text, recipe, CARD_COLOR);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }
}