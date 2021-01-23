package;

import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;

/**
    This recipe help player cook a new Coffee
**/
class CoffeeRecipe extends Recipe {

    // array of step cooking image
    static final COOKING_PICS:Array<String> = [AssetPaths.IceCoffee__PNG, AssetPaths.SugarCoffee__PNG,
    AssetPaths.CaramelCoffee__PNG, AssetPaths.MilkCoffee__PNG];
    // Array of number label images
    static final NUM_LABEL_PICS:Array<String> = [AssetPaths.number1__png, AssetPaths.number2__png,
    AssetPaths.number3__png, AssetPaths.number4__png];
    // distance from top for instruction text
    static inline final INSTRUCT_DISTANCE_FROM_TOP:Int = 250;
    // instruction text width
    static inline final INSTRUCT_DISTANCE_WIDTH:Int = 600;
    // Font size for instructions
    static inline final INSTRUCT_FONT_SIZE:Int = 30;
    // ingredients
    static final INGREDIENTS:Array<String> = ["Ice", "Sugar", "Caramel", "Milk"];
    // Ingredients buttons
    static final INGREDIENT_KEYBINDS:Array<FlxKey> = [NUMPADONE, ONE, NUMPADTWO, TWO, NUMPADTHREE,
    THREE, NUMPADFOUR, FOUR];
    // Ingredient font size
    static inline final INGRED_FONT_SIZE:Int = 30;
    // Check locations
    static final CHECK_WIDTHS:Array<Int> = [150, 350, 550, 750];
    // Number label offset
    static final NUMBER_LABEL_OFFSET:Int = 50;
    // Button text width
    static inline final BUTTON_WIDTH:Int = 600;
    // Button text font size
    static inline final BUTTON_FONT_SIZE:Int = 30;
    // Button box color
    static final BUTTON_COLOR:FlxColor = FlxColor.BROWN;

    //The text of the coffee recipe.
    var txtDia:FlxText;
    //coffee text
    var txtCoffee:FlxText;
    // list of button
    var buttons:Array<FlxSprite>;
    // Indices of correct buttons
    var correctIndices:Array<Int>;

    // distance from top of button step
    static inline final DISTANCE_FROM_TOP_STEP:Int = 450;
    // distance from top of text ingredient
    static inline final TXT_DISTANCE_FROM_TOP_STEP:Int = 370;
    // space left of cooking image finishing
    static inline final SPACE_LEFT_OF_IMAGE:Int = 450;
    //distance from top of cooking image finishing
    static inline final DISTANCE_FROM_TOP_PNG:Int = 90;
    // postition left for show time and finish
    static inline final ALI_LEFT:Int = 200;
    // position top
    static inline final ALI_TOP:Int = 600;
    // Size of checking image
    static inline final CHECK_SIZE:Int = 26;
    // Size of ingredient buttons
    static inline final IM_BUTTON_SIZE:Int = 100;
    // Size of cup image
    static inline final CUP_WIDTH:Int = 200;

    // display image top
    var diaImage:FlxSprite;
    // Timer for oven prepare
    var ovenTimer:Timer;
    // Text for both "done" and "start coffee"
    var buttonText:FlxText;
    // Button box for hitbox
    var buttonBox:FlxSprite;
    // Ingredients
    var ingreds:String;
    // Incorrect ingredients
    var incorrectIngreds:Int;
    // Flag for when the oven was just started, to trigger dialogue close
    var justStarted:Bool;

    // Size of the incorrect notification text
    static inline final INCORRECT_TEXT_SIZE:Int = 20;
    // Size of spaces between recipe information
    static inline final SPACE_SIZE:Int = 10;
    // Failed key vanish delay
    static inline final VANISH_DELAY:Int = 1500;
    // Failed key vanish speed
    static inline final VANISH_SPEED:Int = 100;
    // Failed key vanish width
    static inline final VANISH_WIDTH:Int = 350;
    // Color for incorrect ingredient popup
    static final INCORRECT_COLOR:FlxColor = FlxColor.RED.getLightened(0.4);
    // Incorrect ingredient multiplier
    static inline final INCORRECT_MULTIPLIER:Float = 0.2;

    override public function new(displayName:String, timeToComplete:Int, reward:Int, numIngred:Int,
        ?onCompletion:Recipe -> Void):Void {
        super(displayName, reward, onCompletion);
        ovenTimer = new Timer(timeToComplete);
        ingreds = "";
        correctIndices = [0, 1, 2, 3];
        buttons = null;
        incorrectIngreds = 0;

        // Select the ingredients required
        for (i in 0...(4 - numIngred)){
            var rnum:Int = Math.floor((Math.random() * (4 - i)));
            correctIndices.remove(correctIndices[rnum]);
        }
        for (i in correctIndices) {
            ingreds += "* " + INGREDIENTS[i] + "\n";
        }
        createHUD();
        queueID = QueueSystem.COFFEE;
    }

    /**
        Creates the hud for the game
    **/
    function createHUD():Void {
        diaImage = new FlxSprite(Util.relWidth(0.5 * Dialogue.REL_DIALOGUE_WIDTH) - (CUP_WIDTH / 2),
                                 DISTANCE_FROM_TOP_PNG, AssetPaths.BlackCoffee__PNG);
        add(diaImage);

        buttonText = new FlxText(Math.round(Util.relWidth(Dialogue.REL_DIALOGUE_WIDTH) / 2) - (BUTTON_WIDTH / 2),
            ALI_TOP, BUTTON_WIDTH, "Click here or press space to pour some coffee!", BUTTON_FONT_SIZE);
        buttonText.alignment = CENTER;
        buttonText.font = AssetPaths.RobotoBlack__ttf;
        buttonText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
        buttonBox = new FlxSprite(Math.round(Util.relWidth(Dialogue.REL_DIALOGUE_WIDTH) / 2) - (BUTTON_WIDTH / 2),
            ALI_TOP);
        buttonBox.makeGraphic(BUTTON_WIDTH, BUTTON_FONT_SIZE * 3, BUTTON_COLOR);
        buttonBox.alpha = 0.1;
        add(buttonBox);
        add(buttonText);
    }

    /**
        Adds buttons and their corresponding text
    **/
    function addButtons():Void {
        diaImage.loadGraphic(AssetPaths.coffeepoured__png);
        txtCoffee = new FlxText(CHECK_WIDTHS[0], DISTANCE_FROM_TOP_PNG, 0,
            ingreds, INGRED_FONT_SIZE);
        txtCoffee.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
        txtCoffee.font = AssetPaths.RobotoBlack__ttf;
        add(txtCoffee);

        buttons = [null, null, null, null];
        var txtStep:Array<FlxText> = [null, null, null, null];
        for (i in 0...4){
            buttons[i] = new FlxSprite(CHECK_WIDTHS[i], DISTANCE_FROM_TOP_STEP, COOKING_PICS[i]);
            txtStep[i] = new FlxText(CHECK_WIDTHS[i], TXT_DISTANCE_FROM_TOP_STEP,
                0, INGREDIENTS[i], BUTTON_FONT_SIZE);
            var numLabel:FlxSprite = new FlxSprite(CHECK_WIDTHS[i] - NUMBER_LABEL_OFFSET, DISTANCE_FROM_TOP_STEP,
                NUM_LABEL_PICS[i]);
            txtStep[i].font = AssetPaths.RobotoBlack__ttf;
            txtStep[i].setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
            if (isOpen) {
                FlxMouseEventManager.add(buttons[i], _ -> onMouseClick(i));
            }
            add(txtStep[i]);
            add(buttons[i]);
            add(numLabel);
        }

        txtDia = new FlxText(Math.round(Util.relWidth(Dialogue.REL_DIALOGUE_WIDTH) / 2) - (INSTRUCT_DISTANCE_WIDTH / 2),
            INSTRUCT_DISTANCE_FROM_TOP, INSTRUCT_DISTANCE_WIDTH, "Add the ingredients on the left " +
            "to the coffee in any order:", INSTRUCT_FONT_SIZE);
        txtDia.font = AssetPaths.RobotoBlack__ttf;
        txtDia.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
        add(txtDia);

        buttonText.text = "Click here or press space when done!";
        buttonBox = new FlxSprite(Math.round(Util.relWidth(Dialogue.REL_DIALOGUE_WIDTH) / 2) - (BUTTON_WIDTH / 2),
            ALI_TOP);
        buttonBox.makeGraphic(BUTTON_WIDTH, BUTTON_FONT_SIZE * 3, BUTTON_COLOR);
        buttonBox.alpha = 0.1;
        insert(0, buttonBox);
        if (isOpen) {
            FlxMouseEventManager.add(buttonBox, _ -> centerButtonCallback());
        }
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (FlxG.keys.justPressed.SPACE) {
            centerButtonCallback();
        }

        if (this.ovenTimer.isFinished() && FlxG.keys.anyJustPressed(INGREDIENT_KEYBINDS)) {
            var index:Int = 0;
            for (key in INGREDIENT_KEYBINDS) {
                if (FlxG.keys.anyJustPressed([key])) {
                    onMouseClick(Math.floor(index / 2));
                }
                index++;
            }
        }

        if (active){
            if (ovenTimer.getIsRunning()) {
                buttonText.text = "Pouring coffee... Time remaining: " +
                    (Math.round(ovenTimer.getTimeLeft() / 100) / 10.0);
            }
        }
        if (this.ovenTimer.isFinished() && buttons == null){
            diaImage.loadGraphic(AssetPaths.BlackCoffee__PNG);
            addButtons();
        }
    }

    /**
        Done/start oven timer button callback
    **/
    function centerButtonCallback():Void {
        if (!this.ovenTimer.isFinished() && !this.ovenTimer.getIsRunning()) {
            this.startOven(this);
            FlxMouseEventManager.remove(this.buttonBox);
            this.buttonBox.kill();
            justStarted = true;
        } else if (!this.ovenTimer.getIsRunning()) {
            this.complete();
        }
    }

    override public function shouldCloseDialogue():Bool {
        if (justStarted) {
            justStarted = false;
            return true;
        } else {
            return false;
        }
    }

    /**
        Handle ingredient clicks
    **/
    function onMouseClick(index:Int):Void {
        if (!correctIndices.remove(index)) {
            incorrectIngreds++;
            replaceIngredient(index, AssetPaths.wrong__png);
        } else {
            replaceIngredient(index, AssetPaths.check__PNG);
        }
    }

    /**
        Removes picture when player clicks a correct ingredient
    **/
    function replaceIngredient(index:Int, icon:String):Void {
        buttons[index].kill();
        buttons[index] = new FlxSprite(CHECK_WIDTHS[index], DISTANCE_FROM_TOP_STEP, icon);
        add(buttons[index]);
    }

    override public function onDialogueOpen():Void {
        super.onDialogueOpen();
        if (buttons != null) {
            for (i in correctIndices) {
                FlxMouseEventManager.remove(buttons[i]);
                FlxMouseEventManager.add(buttons[i], _ -> onMouseClick(i));
            }
        }

        if (!this.ovenTimer.getIsRunning()) {
            FlxMouseEventManager.remove(buttonBox);
            FlxMouseEventManager.add(buttonBox, _ -> centerButtonCallback());
        }
    }

    /**
        Returns OvenTimer
    **/
    public function getOvenTimer():Timer {
        return this.ovenTimer;
    }

    /**
        Start oven timer
    **/
    function startOven(spt:FlxSprite):Void {
        ovenTimer.start();
        diaImage.loadGraphic(AssetPaths.coffeepour__png);
    }

    /**
        Calculate reward
    **/
    override public function complete():Void {
        incorrectIngreds += correctIndices.length;
        this.failMultiplier = 1.0 - (INCORRECT_MULTIPLIER * incorrectIngreds);
        super.complete();
    }

    override public function onDialogueClose():Void {
        super.onDialogueClose();
        if (buttons != null) {
            for (i in correctIndices) {
                FlxMouseEventManager.remove(buttons[i]);
            }
        }

        if (!this.ovenTimer.getIsRunning()) {
            FlxMouseEventManager.remove(buttonBox);
        }
    }
}