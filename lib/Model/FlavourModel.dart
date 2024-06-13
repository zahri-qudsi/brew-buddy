class FlavourModel {
  int? id;
  String? name;
  String? image_url;

  FlavourModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image_url = json['image_url'];
  }
}
