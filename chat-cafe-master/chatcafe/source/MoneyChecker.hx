package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
    Make an account money for player 
**/
class MoneyChecker extends FlxSpriteGroup {

    // size of text
    static inline final FONT_SIZE:Int = 40;
    // size of text when you just have too much money
    static inline final SMALL_FONT:Int = 30;
    // Initial amount of money
    static inline final INITIAL_MONEY:Int = 0;
    // Width of box containing money amount
    static inline final BOX_WIDTH:Int = 200;
    // Text color of the money
    static inline final TEXT_COLOR:FlxColor = FlxColor.BLACK;
    // display text
    var txtMoney:FlxText;
    // display image
    var sprMoney:FlxSprite;

    public function new():Void {
        super();
        var moneybg:FlxSprite = new FlxSprite(Util.relWidth(1) - BOX_WIDTH, 0, AssetPaths.moneybg__png);
        add(moneybg);
        txtMoney = new FlxText(Util.relWidth(1) - BOX_WIDTH, 0, BOX_WIDTH,
                               "$" + Std.string(Main.globalState.money), FONT_SIZE);
        txtMoney.alignment = RIGHT;
        txtMoney.font = AssetPaths.RobotoBlack__ttf;
        txtMoney.color = TEXT_COLOR;
        if (Main.globalState.money > 9999999) {
            txtMoney.size = SMALL_FONT;
        } else {
            txtMoney.size = FONT_SIZE;
        }
        add(txtMoney);
    }

    /**
        add more or subtract the money account
    **/
    public function updateMoney(money:Int):Void {
        Main.globalState.money += money;
        txtMoney.text = "$" + Std.string(Main.globalState.money);
        if (Main.globalState.money > 9999999) {
            txtMoney.size = SMALL_FONT;
        } else {
            txtMoney.size = FONT_SIZE;
        }
    }

    /**
        return the current account
    **/
    public function getMoney():Int {
        return Main.globalState.money;
    }
}