enum BaseTypesTags{
  nullable(0),
  integer(-1),
  double(-2),
  bool(-3),
  string(-4),
  map(-5),
  list(-6);

  final int tag;


  static BaseTypesTags fromInt(int value){
    return BaseTypesTags.values.singleWhere((element) => element.tag == value);
  }
  const BaseTypesTags(this.tag);
}