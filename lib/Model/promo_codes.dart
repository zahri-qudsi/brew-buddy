class Promo {
  final String image;
  final String promoCode;
  final String subTitle;

  Promo({
    required this.image,
    required this.promoCode,
    required this.subTitle,
  });
}

List<Promo> activities = [
  Promo(
    image: "assets/images/cappuccino.png",
    promoCode: 'Promo Code',
    subTitle: 'Selected Coffee \nCafe Latte',
  ),
];

// class PromoCodes {
//   String image, promoCode, subTitle;
//   // final Icon icon;

//   PromoCodes(
//     this.image,
//     this.promoCode,
//     this.subTitle,
//     // this.icon,
//   );
// }

// PromoCodes(
//       "assets/images/cappuccino.png",
//       "Promo Code",
//       "Selected Coffee \nCafe Latte",
//     ),
//     PromoCodes(
//       "assets/images/cappuccino.png",
//       "Promo Code",
//       "Selected Coffee \nCafe Latte",
//     ),
//     PromoCodes(
//       "assets/images/cappuccino.png",
//       "Promo Code",
//       "Selected Coffee \nCafe Latte",
//     ),