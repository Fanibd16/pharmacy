class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Find the nearest pharmacy.",
    image: "assets/icon/searching.png",
    // image: "assets/icon/smartphone.png",
    desc: "Instantly find the nearest pharmacies at your fingertips.",
  ),
  OnboardingContents(
    title: "Easy to use",
    image: "assets/icon/smartphone.png",
    desc: "Effortlessly locate nearby pharmacies—just scan the QR code and go!",
  ),
  OnboardingContents(
    title: "Fast",
    image: "assets/icon/fast.png",
    desc: "Lightning-fast app.",
  ),
];
