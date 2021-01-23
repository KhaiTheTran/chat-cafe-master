package;

/**
    Upgrade system for increasing rewards.
**/
class UpgradeOvenTimer extends Upgrade {

    // The actual reward values that are applied on purchase
    var upgradeRewards:Array<Float>;

    override public function new(xPos:Int, yPos:Int):Void {
        super(xPos, yPos, 0);

        title = "Next Gen Oven";
        description = "Multiplier for how long it takes timed recipes to finish.";
        upgradeTexts = [Std.string(Main.INIT_OVEN_MULTIPLIER), "0.9", "0.8", "0.7", "0.6", "0.5"];
        costs = [0, 2500, 5000, 7500, 10000, 12500];
        upgradeRewards = [Main.INIT_OVEN_MULTIPLIER, 0.9, 0.8, 0.7, 0.6, 0.5];
        index = upgradeRewards.indexOf(Main.globalState.ovenTimeMultiplier);
        drawElements();
    }

    override function onBuy():Void {
        super.onBuy();
        Main.globalState.ovenTimeMultiplier = upgradeRewards[index];
    }
}