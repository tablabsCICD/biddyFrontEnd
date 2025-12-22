class CabCategory {
  int? id;
  String? name;
  double? basePriceAtDayTime;
  double? basePriceInNightTime;
  double? ratePerKmAtDayTime;
  double? ratePerKmInNightTime;
  bool? active;
  String? noOfPerson;
  String? image;

  CabCategory(
      {this.id,
        this.name,
        this.basePriceAtDayTime,
        this.basePriceInNightTime,
        this.ratePerKmAtDayTime,
        this.ratePerKmInNightTime,
        this.active,
        this.noOfPerson,
        this.image});

  CabCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    basePriceAtDayTime = json['basePriceAtDayTime'];
    basePriceInNightTime = json['basePriceInNightTime'];
    ratePerKmAtDayTime = json['ratePerKmAtDayTime'];
    ratePerKmInNightTime = json['ratePerKmInNightTime'];
    active = json['active'];
    noOfPerson = json['noOfPerson'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['basePriceAtDayTime'] = this.basePriceAtDayTime;
    data['basePriceInNightTime'] = this.basePriceInNightTime;
    data['ratePerKmAtDayTime'] = this.ratePerKmAtDayTime;
    data['ratePerKmInNightTime'] = this.ratePerKmInNightTime;
    data['active'] = this.active;
    data['image'] = this.image;
    data['noOfPerson'] = this.noOfPerson;
    return data;
  }
}
