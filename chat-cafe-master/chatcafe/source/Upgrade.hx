package;

import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;

/**
    An interface for using a recipe for the cafe.
    Initialize subclasses, never a plain Upgrade.
**/
class Upgrade extends FlxSpriteGroup {

    // Width of the upgrade element
    static inline final WIDTH:Int = 1100;
    // Height of the upgrade element
    static inline final HEIGHT:Int = 100;
    // Color of the upgrade element background
    static inline final COLOR:FlxColor = FlxColor.ORANGE;
    // Width of title section of the card
    static inline final TITLE_WIDTH:Int = 400;
    // Width of the "current" and "next" areas
    static inline final PREVIEW_WIDTH:Int = 300;
    // Width of the "buy" button area
    static inline final BUY_WIDTH:Int = 100;
    // Size of top text
    static inline final TOP_SIZE:Int = 30;
    // Size of bottom text
    static inline final BOTTOM_SIZE:Int = 20;
    // Y Offset of bottom text
    static inline final BOTTOM_OFFSET:Int = 50;
    // Text color
    static inline final TEXT_COLOR:FlxColor = FlxColor.BLACK;
    // Vanishing text font color
    static inline final VANISH_COLOR:FlxColor = FlxColor.RED;
    // Vanishing text duration
    static inline final VANISH_DURATION:Int = 2000;
    // Vanishing text speed
    static inline final VANISH_SPEED:Int = 25;
    // Vanishing text size
    static inline final VANISH_SIZE:Int = 40;

    // The buy button
    var buyButton:FlxSprite;
    // The current upgrade
    var currUpgrade:FlxText;
    // The next upgrade
    var nextUpgrade:FlxText;
    // The cost display
    var costDisplay:FlxText;

    // Variables that should be initialized by subclasses
    // Title of the upgrade
    var title:String;
    // Description of the upgrade
    var description:String;
    // Index of the current upgrade in the arrays.
    var index:Int;
    // Upgrade display texts
    var upgradeTexts:Array<String>;
    // Costs
    var costs:Array<Int>;
    // Logger id
    var logID:Int;

    override public function new(xPos:Int, yPos:Int, id:Int):Void {
        super(xPos, yPos);
        var background:FlxSprite = new FlxSprite(0, 0);
        background.makeGraphic(WIDTH, HEIGHT, COLOR);
        add(background);
        logID = id;

        // Overwrite these in subclasses :)
        title = "Placeholder";
        description = "Placeholder";
        index = 0;
        upgradeTexts = ["Placeholder", "Placeholder"];
        costs = [0, 0];
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }

    /**
        Draws the elements onto the upgrade card.
        Call from subclass after fields are initialized.
    **/
    function drawElements():Void {
        this.costs = this.costs.map(i -> Math.round(i * Main.globalState.pityFactor));
        var titleText:FlxText = new FlxText(0, 0, TITLE_WIDTH, title, TOP_SIZE);
        titleText.color = TEXT_COLOR;
        titleText.font = AssetPaths.RobotoBlack__ttf;
        add(titleText);
        var descriptionText:FlxText = new FlxText(0, BOTTOM_OFFSET, TITLE_WIDTH, description, BOTTOM_SIZE);
        descriptionText.color = TEXT_COLOR;
        descriptionText.font = AssetPaths.RobotoBlack__ttf;
        add(descriptionText);
        var currentHeader:FlxText = new FlxText(TITLE_WIDTH, 0, PREVIEW_WIDTH, "Current:", TOP_SIZE);
        currentHeader.alignment = CENTER;
        currentHeader.color = TEXT_COLOR;
        currentHeader.font = AssetPaths.RobotoBlack__ttf;
        add(currentHeader);
        var nextHeader:FlxText = new FlxText(TITLE_WIDTH + PREVIEW_WIDTH, 0, PREVIEW_WIDTH, "Next:", TOP_SIZE);
        nextHeader.alignment = CENTER;
        nextHeader.color = TEXT_COLOR;
        nextHeader.font = AssetPaths.RobotoBlack__ttf;
        add(nextHeader);
        if (index != upgradeTexts.length - 1) {
            buyButton = new FlxSprite(TITLE_WIDTH + PREVIEW_WIDTH * 2, 0, AssetPaths.buy__png);
            add(buyButton);
            FlxMouseEventManager.add(buyButton, _ -> onBuy());
        } else {
            buyButton = null;
        }
        currUpgrade = new FlxText(TITLE_WIDTH, BOTTOM_OFFSET, PREVIEW_WIDTH, upgradeTexts[index], BOTTOM_SIZE);
        currUpgrade.alignment = CENTER;
        currUpgrade.color = TEXT_COLOR;
        currUpgrade.font = AssetPaths.RobotoBlack__ttf;
        add(currUpgrade);
        nextUpgrade = new FlxText(TITLE_WIDTH + PREVIEW_WIDTH, BOTTOM_OFFSET, PREVIEW_WIDTH,
                                  index == upgradeTexts.length - 1 ? "/" : upgradeTexts[index + 1], BOTTOM_SIZE);
        nextUpgrade.alignment = CENTER;
        nextUpgrade.color = TEXT_COLOR;
        nextUpgrade.font = AssetPaths.RobotoBlack__ttf;
        add(nextUpgrade);
        costDisplay = new FlxText(TITLE_WIDTH + PREVIEW_WIDTH * 2, BOTTOM_OFFSET, BUY_WIDTH,
                                  (index == upgradeTexts.length - 1 ? "/" : "$" + Std.string(costs[index + 1])),
                                  BOTTOM_SIZE);
        costDisplay.alignment = CENTER;
        costDisplay.color = TEXT_COLOR;
        costDisplay.font = AssetPaths.RobotoBlack__ttf;
        add(costDisplay);
    }

    /**
        Override in children. Is called when the buy button is pressed
        Be sure the children call super.onBuy to run this code too.
    **/
    function onBuy():Void {
        if (index != upgradeTexts.length - 1) {
            if (Main.globalState.money < costs[index + 1]) {
                var response:VanishingText = new VanishingText(TITLE_WIDTH + PREVIEW_WIDTH, 0,
                                                               "Not enough money!", VANISH_SIZE,
                                                               VANISH_DURATION, VANISH_SPEED, VANISH_COLOR);
                add(response);
            } else {
                index++;
                Main.LOGGER.logActionWithNoLevel(Main.UPGRADE_BUY_ACTION + logID, {
                    tier: index
                });
                var response:VanishingText = new VanishingText(TITLE_WIDTH + PREVIEW_WIDTH * 2, 0,
                                                               "-$" + Std.string(costs[index]), VANISH_SIZE,
                                                               VANISH_DURATION, VANISH_SPEED, VANISH_COLOR);
                add(response);
                Main.globalState.money -= costs[index];
                currUpgrade.text = upgradeTexts[index];
                if (index == upgradeTexts.length - 1) {
                    nextUpgrade.text = "/";
                    costDisplay.text = "/";
                    remove(buyButton, true).destroy();
                } else {
                    nextUpgrade.text = upgradeTexts[index + 1];
                    costDisplay.text = "$" + Std.string(costs[index + 1]);
                }
            }
        }
    }
}