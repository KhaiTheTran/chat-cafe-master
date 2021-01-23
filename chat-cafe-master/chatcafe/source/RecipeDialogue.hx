package;

import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.text.FlxText;

/**
    A recipe dialogue. Renders a recipe which can be completed.
 **/
class RecipeDialogue extends Dialogue {

    // The recipe of the dialogue.
    public var recipe:Recipe;
    // Tooltip text width
    static inline final TOOLTIP_WIDTH:Int = 100;
    // Play text and tooltip font size
    static inline final TOOLTIP_FONT:Int = 25;
    // Tooltip font height
    static inline final TOOLTIP_HEIGHT:Int = 40;
    // Question box size
    static inline final QUESTION_SIZE:Int = 75;
    // Question mark color
    static final QUESTION_COLOR:FlxColor = 0xFFE6E6E6;

    public function new(recipe:Recipe, hudref:HUD, ?onClose:Dialogue -> Void):Void {
        super(onClose);
        add(recipe);
        this.recipe = recipe;
        recipe.onDialogueOpen();

        var help:FlxSprite = new FlxSprite(Util.relWidth(Dialogue.REL_DIALOGUE_WIDTH) - QUESTION_SIZE,
            Util.relHeight(Dialogue.REL_DIALOGUE_HEIGHT) - QUESTION_SIZE, AssetPaths.help__png);
        FlxMouseEventManager.add(help, _ -> hudref.callBasicDialogue(Main.TUTORIAL_TXT_FILES[recipe.queueID]));
        add(help);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // I think this must happen LAST. Put code above this or in an else branch to this if.
        if (recipe.shouldCloseDialogue()) {
            closeDialogue();
        }
    }

    override public function closeDialogue():Void {
        recipe.onDialogueClose();
        super.closeDialogue();
    }

}