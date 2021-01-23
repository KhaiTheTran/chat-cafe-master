package;

import flixel.input.mouse.FlxMouseEventManager;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxState;

/**
    Game end screen, should be able to loop back to the real game.
**/
class GameEndState extends FlxState {

    // Congratulations text height
    static inline final CONGRATS_TEXT_Y:Int = 200;
    // Congratulations text size
    static inline final CONGRATS_TEXT_SIZE:Int = 70;

    // Return text height
    static inline final RETURN_TEXT_Y:Int = 700;
    // Return text font size
    static inline final RETURN_TEXT_SIZE:Int = 50;
    // Return text font width
    static inline final RETURN_TEXT_WIDTH:Int = 800;

    override public function create():Void {
        super.create();

        Util.scaleGameCamera();

        var congratsText:FlxText = new FlxText(0, CONGRATS_TEXT_Y, Util.relWidth(1),
            "Congratulations! You've won! Thank you for playing, it means a lot to us!", CONGRATS_TEXT_SIZE);
        congratsText.font = AssetPaths.RobotoBlack__ttf;
        congratsText.alignment = CENTER;
        add(congratsText);

        var returnText:FlxText = new FlxText(Math.round(Util.relWidth(0.5) - (RETURN_TEXT_WIDTH / 2)), RETURN_TEXT_Y,
            RETURN_TEXT_WIDTH, "Click here to return to the game.", RETURN_TEXT_SIZE);
        returnText.font = AssetPaths.RobotoBlack__ttf;
        returnText.alignment = CENTER;

        var returnButton:FlxSprite = new FlxSprite(returnText.x, returnText.y);
        returnButton.makeGraphic(RETURN_TEXT_WIDTH, Math.round(returnText.height), 0x01000000);
        add(returnText);
        add(returnButton);
        FlxMouseEventManager.add(returnButton, _ -> Util.fadeTo(new UpgradeMenuState()));

    }
}