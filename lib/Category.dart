class Category {
  int? code;
  String? msg;
  Res? res;

  Category({this.code, this.msg, this.res});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      code: json['code'],
      msg: json['msg'],
      res: json['res'] != null ? Res.fromJson(json['res']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['msg'] = msg;
    if (res != null) {
      data['res'] = res!.toJson();
    }
    return data;
  }
}

class Res {
  List<CategoryX>? category;

  Res({this.category});

  factory Res.fromJson(Map<String, dynamic> json) {
    return Res(
      category: json['category'] != null
          ? (json['category'] as List)
              .map((i) => CategoryX.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (category != null) {
      data['category'] = category?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryX {
  double? atime;
  int? count;
  String? cover;
  String? cover_temp;
  String? ename;
  List<Object?>? filter;
  String? icover;
  String? id;
  String? name;
  String? picasso_cover;
  int? rank;
  String? rname;
  int? sn;
  int? type;

  CategoryX(
      {this.atime,
      this.count,
      this.cover,
      this.cover_temp,
      this.ename,
      this.filter,
      this.icover,
      this.id,
      this.name,
      this.picasso_cover,
      this.rank,
      this.rname,
      this.sn,
      this.type});

  factory CategoryX.fromJson(Map<String, dynamic> json) {
    return CategoryX(
      atime: json['atime'],
      count: json['count'],
      cover: json['cover'],
      cover_temp: json['cover_temp'],
      ename: json['ename'],
      filter: json['filter'] != null ? null : null,
      icover: json['icover'],
      id: json['id'],
      name: json['name'],
      picasso_cover: json['picasso_cover'],
      rank: json['rank'],
      rname: json['rname'],
      sn: json['sn'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['atime'] = atime;
    data['count'] = count;
    data['cover'] = cover;
    data['cover_temp'] = cover_temp;
    data['ename'] = ename;
    data['icover'] = icover;
    data['id'] = id;
    data['name'] = name;
    data['picasso_cover'] = picasso_cover;
    data['rank'] = rank;
    data['rname'] = rname;
    data['sn'] = sn;
    data['type'] = type;
    if (filter != null) {
      data['filter'] = filter?.map((v) => v.toString()).toList();
    }
    return data;
  }
}
