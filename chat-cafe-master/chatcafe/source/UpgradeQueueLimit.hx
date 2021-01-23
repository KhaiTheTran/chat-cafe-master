package;

/**
    Upgrade system for increasing rewards.
**/
class UpgradeQueueLimit extends Upgrade {

    // The actual reward values that are applied on purchase
    var upgradeRewards:Array<Int>;

    override public function new(xPos:Int, yPos:Int):Void {
        super(xPos, yPos, 1);

        title = "More Queue Space";
        description = "Increase the number of people who can wait in the queue.";
        upgradeTexts = [Std.string(Main.INIT_QUEUE_LIMIT), "6", "8", "10", "12"];
        costs = [0, 2000, 4000, 6000, 8000, 10000];
        upgradeRewards = [Main.INIT_QUEUE_LIMIT, 6, 8, 10, 12];
        index = upgradeRewards.indexOf(Main.globalState.queueLimit);
        drawElements();
    }

    override function onBuy():Void {
        super.onBuy();
        Main.globalState.queueLimit = upgradeRewards[index];
    }
}