class SimplePathType {
  String? path;
  String? type;

  SimplePathType({this.path, this.type});

  factory SimplePathType.network({required String url}) {
    return SimplePathType(path: url, type: 'network');
  }

  factory SimplePathType.assets({required String url}) {
    return SimplePathType(path: url, type: 'assets');
  }
}
