class Picture {
  int? code;
  String? msg;
  Res? res;

  Picture({this.code, this.msg, this.res});

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
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
  List<Vertical>? vertical;

  Res({this.vertical});

  factory Res.fromJson(Map<String, dynamic> json) {
    return Res(
      vertical: json['vertical'] != null
          ? (json['vertical'] as List).map((i) => Vertical.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (vertical != null) {
      data['vertical'] = vertical!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vertical {
  double? atime;
  List<String>? cid;
  bool? cr;
  String? desc;
  int? favs;
  String? id;
  String? img;
  int? ncos;
  String? preview;
  int? rank;
  String? rule;
  String? source_type;
  String? store;
  List<Object>? tag;
  String? thumb;
  List<Object>? url;
  int? views;
  String? wp;
  bool? xr;

  Vertical(
      {this.atime,
      this.cid,
      this.cr,
      this.desc,
      this.favs,
      this.id,
      this.img,
      this.ncos,
      this.preview,
      this.rank,
      this.rule,
      this.source_type,
      this.store,
      this.tag,
      this.thumb,
      this.url,
      this.views,
      this.wp,
      this.xr});

  factory Vertical.fromJson(Map<String, dynamic> json) {
    return Vertical(
      atime: json['atime'],
      cid: json['cid'] != null ? List<String>.from(json['cid']) : null,
      cr: json['cr'],
      desc: json['desc'],
      favs: json['favs'],
      id: json['id'],
      img: json['img'],
      ncos: json['ncos'],
      preview: json['preview'],
      rank: json['rank'],
      rule: json['rule'],
      source_type: json['source_type'],
      store: json['store'],
      // tag: json['tag'],
      thumb: json['thumb'],
      // url: json['url'],
      views: json['views'],
      wp: json['wp'],
      xr: json['xr'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['atime'] = atime;
    data['cr'] = cr;
    data['desc'] = desc;
    data['favs'] = favs;
    data['id'] = id;
    data['img'] = img;
    data['ncos'] = ncos;
    data['preview'] = preview;
    data['rank'] = rank;
    data['rule'] = rule;
    data['source_type'] = source_type;
    data['store'] = store;
    data['thumb'] = thumb;
    data['views'] = views;
    data['wp'] = wp;
    data['xr'] = xr;
    if (cid != null) {
      data['cid'] = cid;
    }
    if (tag != null) {
      data['tag'] = tag!.map((v) => v.toString()).toList();
    }
    if (url != null) {
      data['url'] = url!.map((v) => v.toString()).toList();
    }
    return data;
  }
}
