class InformToScreens {
  final String thisRoute;
  final Function goToRoute;
  String? gameMode;

  InformToScreens({
    this.gameMode,
    required this.thisRoute,
    required this.goToRoute
  });
}