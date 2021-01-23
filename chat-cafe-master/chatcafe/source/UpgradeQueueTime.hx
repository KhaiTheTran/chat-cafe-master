package;

/**
    Upgrade system for increasing rewards.
**/
class UpgradeQueueTime extends Upgrade {

    // The actual reward values that are applied on purchase - lower bounds
    var upgradeLowers:Array<Int>;
    // The actual reward values that are applied on purchase - upper bounds
    var upgradeUppers:Array<Int>;

    override public function new(xPos:Int, yPos:Int):Void {
        super(xPos, yPos, 2);

        title = "Marketing Campaign";
        description = "Decrease the range of seconds between customer arrivals.";
        upgradeTexts = [Std.string(Main.INIT_QUEUE_LOWER / 1000.0) + " - " + Std.string(Main.INIT_QUEUE_UPPER / 1000.0),
          "2 - 4", "1.5 - 3.5", "1 - 3", "1 - 2.5", "0.5 - 2", "0.5 - 1.5", "0.5 - 1"];
        costs = [0, 3500, 6000, 8000, 10000, 12500, 15000, 17500];
        upgradeLowers = [Main.INIT_QUEUE_LOWER, 2000, 1500, 1000, 1000, 500, 500, 500];
        upgradeUppers = [Main.INIT_QUEUE_UPPER, 4000, 3500, 3000, 2500, 2000, 1500, 1000];
        index = upgradeUppers.indexOf(Main.globalState.queueUpperBound);
        drawElements();
    }

    override function onBuy():Void {
        super.onBuy();
        Main.globalState.queueLowerBound = upgradeLowers[index];
        Main.globalState.queueUpperBound = upgradeUppers[index];
    }
}