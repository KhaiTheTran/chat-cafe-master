package;

import flixel.input.keyboard.FlxKey;

/**
    Defines type for random sequence recipe properties
**/
typedef RandSeqProps = {
    name: String,
    numKeys: Int,
    reward: Int
}

/**
    Defines type for sequence recipe properties
**/
typedef SetSeqProps = {
    name: String,
    keys: Array<FlxKey>,
    reward: Int
}

/**
    Defines type for timed recipe properties
**/
typedef TimedProps = {
    name: String,
    delay: Int,
    reward: Int
}

/**
    Defines type for Coffee recipe properties
**/
typedef CoffeeProps = {
    name: String,
    delay: Int,
    reward: Int,
    addins:Int
}

/**
    Defines type for Cookie recipe properties
**/
typedef CookieProps = {
    name: String,
    reward: Int
}

/**
    Holder class for recipe parameters
**/
class RecipeFactory {

    // Random sequence recipe data
    public static final RAND_SEQ_DATA:Array<RandSeqProps> = [
        {
            name: "Small Letter Salad", numKeys: 5, reward: 600
        },
        {
            name: "Medium Letter Salad", numKeys: 6, reward: 800
        },
        {
            name: "Large Letter Salad", numKeys: 7, reward: 1000
        },
        {
            name: "Extra Large Letter Salad", numKeys: 8, reward: 1200
        }
    ];

    // Sequence recipe data
    public static final SEQ_REC_DATA:Array<SetSeqProps> = [
        {
            name: "BLT", keys: [B, L, T, M], reward: 200
        },
        {
            name: "Sausage and Egg", keys: [S, B, E, K, S], reward: 300
        },
        {
            name: "Owlatte", keys: [O, W, L, A, T, T, E], reward: 500
        },
        {
            name: "Gwyneth Paltrow's Special Supplement", keys: [G, O, O, P, Y], reward: 250
        },
        {
            name: "Chat Cafe Special", keys: [C, H, A, T, C, A, F, E], reward: 550
        },
        {
            name: "Alphabet Soup", keys: [D, E, B, A, C], reward: 150
        },
        {
            name: "Waffles And Oatmeal", keys: [W, A, F, F, L, E, O], reward: 300
        },
        {
            name: "Tea", keys: [B, L, A, C, K], reward: 200
        },
        {
            name: "Tea", keys: [G, R, E, E, N], reward: 200
        },
        {
            name: "Tea", keys: [W, H, I, T, E], reward: 200
        },
        {
            name: "Tea", keys: [O, O, L, O, N, G], reward: 200
        }
    ];

    // Timed recipe data
    public static final TIMED_REC_DATA:Array<TimedProps> = [
        {
            name: "Toasted Toast", delay: 12000, reward: 400
        },
        {
            name: "Biscuit and Biscuit", delay: 5000, reward: 300
        },
        {
            name: "Cat Cookies", delay: 15000, reward: 500
        }
    ];

    /**
        Coffee Recipe
    **/
    public static final COFFEE_REC_DATA:Array<CoffeeProps> = [
        {
            name: "Coffee Tall", delay: 5000, reward: 800, addins: 2
        },
        {
            name: "Coffee Grande", delay: 6000, reward: 1000, addins:3
        },
        {
            name: "Coffee Venti", delay: 7000, reward: 1200, addins:3
        }
    ];

    // Cookie recipe data
    public static final COOKIE_REC_DATA:Array<CookieProps> = [
        {
            name: "Box of Cookies", reward: 1000
        }
    ];

    /**
        Returns a random pre-built Random Sequence Recipe
    **/
    public static function getRandomRandSequenceRecipe():RandomSequenceRecipe {
        var choice:Int = Math.floor(Math.random() * RAND_SEQ_DATA.length);
        return new RandomSequenceRecipe(RAND_SEQ_DATA[choice].name,
                                  RAND_SEQ_DATA[choice].numKeys,
                                  RAND_SEQ_DATA[choice].reward);
    }

    /**
        Returns a random pre-built SequenceRecipe.
    **/
    public static function getRandomSetSequenceRecipe():SetSequenceRecipe {
        var choice:Int = Math.floor(Math.random() * SEQ_REC_DATA.length);
        return new SetSequenceRecipe(SEQ_REC_DATA[choice].name,
                                  SEQ_REC_DATA[choice].keys,
                                  SEQ_REC_DATA[choice].reward);
    }

    /**
        Returns a random pre-built TimedRecipe.
    **/
    public static function getRandomTimedRecipe():TimedRecipe {
        var choice:Int = Math.floor(Math.random() * TIMED_REC_DATA.length);
        return new TimedRecipe(TIMED_REC_DATA[choice].name,
                               TIMED_REC_DATA[choice].delay,
                               TIMED_REC_DATA[choice].reward);
    }

    /**
        Returns a random pre-built Coffee.
    **/
    public static function getRandomCoffee():CoffeeRecipe {
        var choice:Int = Math.floor(Math.random() * COFFEE_REC_DATA.length);
        return new CoffeeRecipe(COFFEE_REC_DATA[choice].name,
                                    COFFEE_REC_DATA[choice].delay,
                                    COFFEE_REC_DATA[choice].reward,
                                    COFFEE_REC_DATA[choice].addins);
    }

    /**
        Returns a random pre-built cookie recipe
    **/
    public static function getCookieRecipe():CookieRecipe {
        var choice:Int = Math.floor(Math.random() * COOKIE_REC_DATA.length);
        return new CookieRecipe(COOKIE_REC_DATA[choice].name,
                               COOKIE_REC_DATA[choice].reward);
    }
}