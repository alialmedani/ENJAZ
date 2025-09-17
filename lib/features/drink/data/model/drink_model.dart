class DrinkModel {
  String? name;
  String? nameAr;
  String? nameBe;
  String? description;
  String? id;

  DrinkModel({this.name, this.nameAr, this.nameBe, this.description, this.id});

  DrinkModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameAr = json['nameAr'];
    nameBe = json['nameBe'];
    description = json['description'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['nameAr'] = nameAr;
    data['nameBe'] = nameBe;
    data['description'] = description;
    data['id'] = id;
    return data;
  }
}
