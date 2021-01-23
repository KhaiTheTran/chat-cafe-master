package;

import flixel.FlxG;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxSubState;

/**
    Substate to be used at the start of the game
**/
class PauseMenu extends FlxSubState {

    // The tint of the overlay
    static final OVERLAY_COLOR:FlxColor = FlxColor.BLACK;
    // The width of the dialogue box
    public static inline final REL_DIALOGUE_WIDTH:Float = 0.8;
    // The height of the dialogue box
    public static inline final REL_DIALOGUE_HEIGHT:Float = 0.8;
    // Height for title text. It should always be centered, so no length value necessary
    static inline final TITLE_TEXT_HEIGHT:Int = 90;
    // Size of title text
    static inline final TITLE_TEXT_SIZE:Int = 40;
    // width of the resume button
    static inline final BUTTON_WIDTH:Int = 400;
    // Button height
    static inline final BUTTON_Y:Int = 600;
    // delete save text size
    static inline final DELETE_SAVE_TEXT_SIZE:Int = 40;
    // Delete save text distance above bottom
    static inline final DELETE_SAVE_TEXT_Y:Int = 100;
    // Delete save text width
    static inline final DELETE_SAVE_TEXT_WIDTH:Int = 700;
    // Delete save button color
    static inline final DELETE_SAVE_COLOR:FlxColor = FlxColor.RED;
    // Delete save text border
    static inline final DELETE_SAVE_TEXT_BORDER_SIZE:Int = 2;
    // Action ID for save deletion
    static inline final SAVE_DELETE_ACTION:Int = 1337;

    // Delete save text
    var deleteText:FlxText;
    // Delete save button
    var deleteButton:FlxSprite;

    override public function create():Void {

        var overlay:FlxSprite = new FlxSprite(0, 0);
        overlay.makeGraphic(Util.relWidth(1), Util.relHeight(1), OVERLAY_COLOR);
        overlay.alpha = 0.5;
        add(overlay);
        FlxMouseEventManager.add(overlay, _ -> Util.noop());

        var title:FlxText = new FlxText(0, TITLE_TEXT_HEIGHT, Util.relWidth(1), "PAUSED", TITLE_TEXT_SIZE);
        title.alignment = CENTER;
        title.font = AssetPaths.RobotoBlack__ttf;
        add(title);

        var closeButton:FlxSprite = new FlxSprite(Util.relWidth(0.5) - (0.5 * BUTTON_WIDTH),
                                                  BUTTON_Y, AssetPaths.resume__png);
        FlxMouseEventManager.add(closeButton, _ -> close());
        add(closeButton);

        if (Main.save.data.globalState != null) {
            deleteText = new FlxText(0, Util.relHeight(1) - DELETE_SAVE_TEXT_SIZE - DELETE_SAVE_TEXT_Y,
                0, "Click here to delete save.", DELETE_SAVE_TEXT_SIZE);
            deleteText.font = AssetPaths.RobotoBlack__ttf;
            deleteText.setBorderStyle(OUTLINE, FlxColor.BLACK, DELETE_SAVE_TEXT_BORDER_SIZE);

            deleteButton = new FlxSprite(deleteText.x, deleteText.y);
            deleteButton.makeGraphic(Math.round(deleteText.width), Math.round(deleteText.height), DELETE_SAVE_COLOR);
            deleteButton.alpha = 0.2;
            add(deleteText);
            add(deleteButton);
            FlxMouseEventManager.add(deleteButton, deleteSave);
        }
    }

    /**
        Two step delete save.
    **/
    function deleteSave(txt:FlxSprite):Void {
        if (deleteText.text == "Click here to delete save.") {
            deleteText.text = "Are you sure? Click again to delete save.";
            deleteButton.makeGraphic(Math.round(deleteText.width), Math.round(deleteText.height), DELETE_SAVE_COLOR);
        } else {
            Main.LOGGER.logActionWithNoLevel(SAVE_DELETE_ACTION, {
                day: Main.globalState.numDays
            });
            Main.save.erase();
            Main.save.bind("SaveData");
            Main.resetToDefaultState();
            FlxG.switchState(new StartMenuState());
        }
    }
}