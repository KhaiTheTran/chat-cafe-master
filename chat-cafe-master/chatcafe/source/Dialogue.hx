package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.input.mouse.FlxMouseEventManager;

/**
    A generic dialogue window for various events. Extend it for specific uses,
    such as a recipe minigame or conversation.
 **/
class Dialogue extends FlxSpriteGroup {

    // The tint of the overlay
    static final OVERLAY_COLOR:FlxColor = FlxColor.BLACK;
    // The relative width of the dialogue box
    public static inline final REL_DIALOGUE_WIDTH:Float = 0.8;
    // The relative height of the dialogue box
    public static inline final REL_DIALOGUE_HEIGHT:Float = 0.8;
    // The absolute width of the dialogue box
    public static final ABS_DIALOGUE_WIDTH:Int = Util.relWidth(REL_DIALOGUE_WIDTH);
    // Absolute height of the dialogue box
    public static final ABS_DIALOGUE_HEIGHT:Int = Util.relHeight(REL_DIALOGUE_HEIGHT);
    // The color of the dialogue box
    static final DIALOGUE_COLOR:FlxColor = FlxColor.GREEN;
    // The size of the exit button
    static inline final EXIT_BUTTON_SIZE:Int = 75;
    // An array of callbacks to trigger upon hitting the red X button.
    var onCloseFns:Array<Dialogue -> Void>;
    //exit button
    var exitButton:FlxSprite;

    public function new(?onClose:Dialogue -> Void):Void {
        super(Util.relWidth((1 - REL_DIALOGUE_WIDTH) / 2),
              Util.relHeight((1 - REL_DIALOGUE_HEIGHT) / 2), 0);
        var overlay:FlxSprite = new FlxSprite(-Util.relWidth((1 - REL_DIALOGUE_WIDTH) / 2),
                                              -Util.relHeight((1 - REL_DIALOGUE_HEIGHT) / 2));
        overlay.makeGraphic(Util.relWidth(1), Util.relHeight(1), OVERLAY_COLOR);
        overlay.alpha = 0.5;
        FlxMouseEventManager.add(overlay, _ -> Util.noop());
        add(overlay);

        var dialogueBlock:FlxSprite = new FlxSprite(0, 0, AssetPaths.dialogueblock__png);
        add(dialogueBlock);

        exitButton = new FlxSprite(Util.relWidth(REL_DIALOGUE_WIDTH) - (EXIT_BUTTON_SIZE / 2),
                                                 -EXIT_BUTTON_SIZE / 2,
                                                 AssetPaths.xicon__png);
        FlxMouseEventManager.reorder();
        FlxMouseEventManager.add(exitButton, _ -> closeDialogue());
        add(exitButton);

        onCloseFns = [];
        if (onClose != null) {
            onCloseFns.push(onClose);
        }
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }

    /**
        Adds the given function as a callback that will be called on close.
    **/
    public function addCloseListener(fn:Dialogue -> Void):Void {
        onCloseFns.push(fn);
    }

    /**
        Calls all of the onCloseFns
    **/
    public function closeDialogue():Void {
        for (fn in onCloseFns) {
            fn(this);
        }
    }
}