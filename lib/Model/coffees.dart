class Coffees {
  final String image;
  final String title;

  Coffees(
    this.image,
    this.title,
  );
}

List<Coffees> coffeeList = [
  Coffees("assets/images/cappuccino.png", "CAPPUCCINO +"),
  Coffees("assets/images/cappuccino.png", "LATTE MACCHIATO"),
  Coffees("assets/images/cappuccino.png", "FLAT WHITE"),
];
