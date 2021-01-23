package;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;
/**
    The Dialogue Basic is implemented as a subclass of the Dialogue object. 
    it displays a character image, some dialogue, and one or more dialogue 
    choices for the player to make, with different effects depending on which one is chosen. 
 **/
class BasicDialogue extends Dialogue {

    // Markup map
    static final MARKUP_ARRAY:Array<FlxTextFormatMarkerPair> =
        [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.GREEN.getLightened(0.4)), "<g>"),
        new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED.getLightened(0.4)), "<r>"),
        new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.CYAN), "<b>")];
    // distance from top of text
    static inline final DISTANCE_FROM_TOP:Int = 30;
    // distance from top of text
    static inline final DISTANCE_FROM_LEFT:Int = 170;
    // front size of text
    static inline final FONT_SIZE:Int = 40;
    // Text width
    static inline final TEXT_WIDTH:Int = 800;
    // Dialogue text list
    var dialogue:String;
    // display text
    var txtDia:FlxText;
    // space left of speak image
    static inline final SPACE_LEFT_OF_IMAGE:Int = 1;
    //distance from top of speak image
    static inline final DISTANCE_FROM_TOP_PNG:Int = 10;
    // display image
    var diaImage:FlxSprite;

    public function new(textFile:String, ?talkingSprite:String, ?onClose:Dialogue -> Void):Void {
        super(onClose);
        dialogue = openfl.Assets.getText(textFile);
        if (talkingSprite != null) {
            diaImage = new FlxSprite(SPACE_LEFT_OF_IMAGE, DISTANCE_FROM_TOP_PNG, talkingSprite);
            this.add(diaImage);
        }
        txtDia = new FlxText(DISTANCE_FROM_LEFT, DISTANCE_FROM_TOP, TEXT_WIDTH, "", FONT_SIZE);
        txtDia.setFormat(AssetPaths.RobotoBlack__ttf, FONT_SIZE, FlxColor.WHITE);

        // For future reference, if we want to use `applyMarkup`, you *must* precede it with a 
        // call to `setBorderStyle`, or else the markup will apply incorrectly.
        txtDia.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
        txtDia.applyMarkup(dialogue, MARKUP_ARRAY);
        this.add(txtDia);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }
}