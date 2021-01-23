package;

/**
    Upgrade system for getting new recipes
**/
class UpgradeRecipes extends Upgrade {

    // The actual reward values that are applied on purchase
    var upgradeRewards:Array<Int>;

    override public function new(xPos:Int, yPos:Int):Void {
        super(xPos, yPos, 3);

        title = "Learn a new recipe";
        description = "Learn a new, more profitable recipe.";
        upgradeTexts = ["Oven Recipe", "Cookie", "Coffee", "Scramble"];
        costs = [0, 3000, 8000, 12000];
        upgradeRewards = [QueueSystem.TIMED, QueueSystem.COOKIE, QueueSystem.COFFEE, QueueSystem.RANDOMSEQ];
        index = upgradeRewards.indexOf(Main.globalState.unlockedRecipes[Main.globalState.unlockedRecipes.length - 1]);
        drawElements();
    }

    override function onBuy():Void {
        var oldIndex:Int = index;
        super.onBuy();
        if (oldIndex != index) {  // There was an update
            Main.globalState.unlockedRecipes.push(upgradeRewards[index]);
            Main.globalState.tutorialRecipes.push(upgradeRewards[index]);
        }
    }
}