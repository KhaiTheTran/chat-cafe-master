package;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;

/**
    An OrderCard represents a card that represents an accepted Order.
 **/
class OrderCard extends FlxSpriteGroup {

    // The distance from the bottom
    static inline final TIMER_VERT_OFFSET:Int = 10;
    // The font size of the timer
    static inline final TIMER_SIZE:Int = 30;

    // Color of text on the card
    static inline final TEXT_COLOR:FlxColor = FlxColor.BLACK;
    // Size of the text on the card
    static inline final FONT_SIZE:Int = 20;
    // Y offset of card sprite
    static inline final CARD_Y_OFFSET:Int = -10;
    // X offset for the card text
    static inline final CARD_TEXT_X:Int = 10;
    // Y offset for the card text
    static inline final CARD_TEXT_Y:Int = 15;

    // Color of money indicator
    static inline final MONEY_COLOR:FlxColor = FlxColor.BLACK;
    // Y offset of money text from the bottom
    static inline final MONEY_Y:Int = 30;
    // Money indicator font size
    static inline final MONEY_SIZE:Int = 20;

    // The recipe for the card
    public var recipe:Recipe;

    // The text on the card
    public var cardText:FlxText;

    public function new(x:Int, y:Int, width:Int, height:Int, text:String, recipe:Recipe,
        cardColor:FlxColor):Void {
        super(x, y, 0);

        this.recipe = recipe;

        var cardGraphic:FlxSprite = new FlxSprite(0, CARD_Y_OFFSET, AssetPaths.ordercard__png);
        cardGraphic.color = cardColor;
        add(cardGraphic);

        cardText = new FlxText(CARD_TEXT_X, CARD_TEXT_Y, width - CARD_TEXT_X, text, FONT_SIZE);
        cardText.color = TEXT_COLOR;
        cardText.font = AssetPaths.IndieFlower__ttf;
        cardText.bold = true;
        add(cardText);

        var moneyText:FlxText = new FlxText(0, height - MONEY_Y, width,
                                            "$" + Std.string(recipe.reward), MONEY_SIZE);
        moneyText.alignment = FlxTextAlign.CENTER;
        moneyText.color = MONEY_COLOR;
        add(moneyText);
    }

    /**
        Returns true if the degredation timer can be resumed. Should be true by default.
    **/
    public function canResume():Bool {
        return true;
    }
}