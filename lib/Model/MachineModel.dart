class MachineModel {
  int? id;
  String? title;
  String? description;
  String? link;
  String? image;

  MachineModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    link = json['link'];
    image = json['image_url'];
  }
}
