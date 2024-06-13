class Slide {
  // final String image;
  final String title;
  final String subTitle;
  final String description;

  Slide({
    // required this.image,
    required this.title,
    required this.subTitle,
    required this.description,
  });
}

final slideList = [
  Slide(
    // image: "assets/images/coffee1.jpg",
    title: 'Delonghi Logo',
    subTitle: "Change the text to\nit's all about your\ncoffee.",
    description:
        "Delight yourself in the exellence of the \ncoffee experience with a masterprice of \nquality and innovation.",
  ),
  Slide(
    // image: "assets/images/coffee2.jpg",
    title: 'Delonghi Logo',
    subTitle: "Simple and intelligent.",
    description:
        "Delight yourself in the exellence of the \ncoffee experience with a masterprice of \nquality and innovation.",
  ),
  Slide(
    // image: "assets/images/coffee3.jpg",
    title: 'Delonghi Logo',
    subTitle: "Two Bean Containers",
    description:
        "Delight yourself in the exellence of the \ncoffee experience with a masterprice of \nquality and innovation.",
  ),
];
