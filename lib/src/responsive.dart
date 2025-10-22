import 'package:flutter/widgets.dart';

class Responsive extends StatelessWidget {
  final Widget mobile, tablet, desktop;
  const Responsive({
    super.key,
    required this.desktop,
    required this.mobile,
    required this.tablet,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 650;
  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 1100 &&
      MediaQuery.sizeOf(context).width >= 650;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1100;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        if (constraint.maxWidth >= 1100) {
          return desktop;
        } else if (constraint.maxWidth >= 650) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
