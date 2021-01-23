package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

/**
    Represents a person who may visit the cafe.
    They have attributes representing who they are, what they plan to order,
    and how long it will take for them to get frustrated.
**/
class Person extends FlxSpriteGroup {

    // The person's recipe
    var order:Recipe;

    // The person's sprite.
    var sprite:FlxSprite;

    // The name of the person
    var name:String;

    // Initial y coordinate
    var initialY:Int;

    // Time passed since creation
    var timePassed:Int;

    public function new(order:Recipe, sprite:FlxSprite, name:String, x:Int, y:Int):Void {
        super(x, y);
        this.order = order;
        this.sprite = sprite;
        this.name = name;
        initialY = y;
        add(sprite);
    }

    override public function update(elapsed:Float):Void {
        timePassed = (timePassed + Math.round(elapsed * 1000)) % 2000;
        if (timePassed < 1000) {
            sprite.y = initialY + 10;
        } else {
            sprite.y = initialY;
        }
    }

    /**
        get's the cusomter's order
    **/
    public function getOrder():Recipe {
        return this.order;
    }

    /**
        gets the person's sprite
    **/
    public function getSprite():FlxSprite {
        return this.sprite;
    }

    /**
        get's the person's name
    **/
    public function getName():String {
        return this.name;
    }
}