class PosterDefaults {
  final double size;
  final double ratio;

  double get gridRatio => size * ratio;

  const PosterDefaults({required this.size, required this.ratio});
}
