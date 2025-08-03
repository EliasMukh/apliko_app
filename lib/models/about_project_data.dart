// ignore_for_file: camel_case_types

class aboutProject {
  final String? name, source, text;

  aboutProject({this.name, this.source, this.text});
}

final List<aboutProject> demoRecommendations = [
  aboutProject(
    name: "</>",
    // image: "assets/images/client-01.jpg",
    source: "We help lern new skills",
    text:
        "The Apliko project aims to develop programming skills and engineering thinking in students.",
  ),
  aboutProject(
    name: "</>",
    // image: "assets/images/client-02.jpg",
    source: "Through real-world practice",
    text:
        "We provide a physical kit that, combined with our software, allows students to build and customize smart devices.",
  ),
  aboutProject(
    name: "</>",
    // image: "assets/images/client-03.jpg",
    source: "our goal is.",
    text:
        "To help students gain a deeper understanding of how smart devices work, their application.",
  ),
];
