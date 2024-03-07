class Tag {
  int id; // 标签的唯一标识符
  String name; // 标签名称

  Tag({
    required this.id,
    required this.name,
  });

  // 将标签对象转换为Map以便存储到数据库
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // 从Map中构建标签对象
  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      id: map['id'],
      name: map['name'],
    );
  }
}
