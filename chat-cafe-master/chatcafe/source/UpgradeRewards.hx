package;

/**
    Upgrade system for increasing rewards.
**/
class UpgradeRewards extends Upgrade {

    // The actual reward values that are applied on purchase
    var upgradeRewards:Array<Float>;

    override public function new(xPos:Int, yPos:Int):Void {
        super(xPos, yPos, 4);

        title = "Organic Ingredients";
        description = "Increase the multiplier on recipe prices for more profits.";
        upgradeTexts = [Std.string(Main.INIT_REWARD_MULTIPLIER), "1.1", "1.2", "1.3", "1.4", "1.5",
          "1.75", "2", "5", "10", "100!!!"];
        costs = [0, 4000, 6000, 8000, 11000, 14000, 18000, 25000, 50000, 100000, 1000000];
        upgradeRewards = [Main.INIT_REWARD_MULTIPLIER, 1.1, 1.2, 1.3, 1.4, 1.5, 1.75, 2, 5, 10, 100];
        index = upgradeRewards.indexOf(Main.globalState.rewardMultiplier);
        drawElements();
    }

    override function onBuy():Void {
        super.onBuy();
        Main.globalState.rewardMultiplier = upgradeRewards[index];
    }
}