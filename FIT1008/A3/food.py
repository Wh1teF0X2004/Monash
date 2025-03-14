""" Implement methods and attributes of Food for Trader.
    All functions, unless stated otherwise, have a constant best / worst case complexity of O(1).
"""

from __future__ import annotations

from material import Material
from random_gen import RandomGen

# List of food names from https://github.com/vectorwing/FarmersDelight/tree/1.18.2/src/main/resources/assets/farmersdelight/textures/item
FOOD_NAMES = [
    "Apple Cider",
    "Apple Pie",
    "Apple Pie Slice",
    "Bacon",
    "Bacon And Eggs",
    "Bacon Sandwich",
    "Baked Cod Stew",
    "Barbecue Stick",
    "Beef Patty",
    "Beef Stew",
    "Cabbage",
    "Cabbage Leaf",
    "Cabbage Rolls",
    "Cabbage Seeds",
    "Cake Slice",
    "Chicken Cuts",
    "Chicken Sandwich",
    "Chicken Soup",
    "Chocolate Pie",
    "Chocolate Pie Slice",
    "Cod Slice",
    "Cooked Bacon",
    "Cooked Chicken Cuts",
    "Cooked Cod Slice",
    "Cooked Mutton Chops",
    "Cooked Rice",
    "Cooked Salmon Slice",
    "Dog Food",
    "Dumplings",
    "Egg Sandwich",
    "Fish Stew",
    "Fried Egg",
    "Fried Rice",
    "Fruit Salad",
    "Grilled Salmon",
    "Ham",
    "Hamburger",
    "Honey Cookie",
    "Honey Glazed Ham",
    "Honey Glazed Ham Block",
    "Horse Feed",
    "Hot Cocoa",
    "Melon Juice",
    "Melon Popsicle",
    "Milk Bottle",
    "Minced Beef",
    "Mixed Salad",
    "Mutton Chops",
    "Mutton Wrap",
    "Nether Salad",
    "Noodle Soup",
    "Onion",
    "Pasta With Meatballs",
    "Pasta With Mutton Chop",
    "Pie Crust",
    "Pumpkin Pie Slice",
    "Pumpkin Slice",
    "Pumpkin Soup",
    "Ratatouille",
    "Raw Pasta",
    "Rice",
    "Rice Panicle",
    "Roast Chicken",
    "Roast Chicken Block",
    "Roasted Mutton Chops",
    "Rotten Tomato",
    "Salmon Slice",
    "Shepherds Pie",
    "Shepherds Pie Block",
    "Smoked Ham",
    "Squid Ink Pasta",
    "Steak And Potatoes",
    "Stuffed Potato",
    "Stuffed Pumpkin",
    "Stuffed Pumpkin Block",
    "Sweet Berry Cheesecake",
    "Sweet Berry Cheesecake Slice",
    "Sweet Berry Cookie",
    "Tomato",
    "Tomato Sauce",
    "Tomato Seeds",
    "Vegetable Noodles",
    "Vegetable Soup",
]


class Food:
    """
    Creates food of different price and hunger bars

    Attributes:
         name = Used to identify the food
         hunger_bars = Specify the number of bars of hunger this food will give when eaten
         price = fixed emerald cost of the food

    Getters:
         get_food_name = Return food name
         get_hunger_bars = Return number of hunger bars that this food will give
         get_price = Return buy price of the food

    Methods:
         random_food = Generates a food randomly
    """

    def __init__(self, name: str, hunger_bars: int, price: int) -> None:
        """ Initialisation, return None """
        self.name = name
        self.hunger_bars = hunger_bars
        self.price = price

    def get_food_name(self) -> str:
        """ Return food name """
        return self.name

    def get_hunger_bars(self) -> int:
        """ Return number of hunger bars that this food will give """
        return self.hunger_bars

    def get_price(self) -> int:
        """ Return buy price of the food """
        return self.price

    def __str__(self) -> str:
        """ String representation of food that consist of its name, price and hunger_bars, return String """
        return f'<Food: {self.get_food_name()} {self.get_price()}💰 for {self.get_hunger_bars()}🍗>'

    @classmethod
    def random_food(cls) -> Food:
        """ Generate and return a random food that consist of its name, price and hunger_bars """
        name = RandomGen.random_choice(FOOD_NAMES)
        hunger_bars = RandomGen.randint(1, 500)
        price = RandomGen.randint(1, 100)
        return Food(name, hunger_bars, price)


if __name__ == "__main__":
    print(Food.random_food())

