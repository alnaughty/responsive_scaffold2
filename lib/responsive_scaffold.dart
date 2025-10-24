import 'package:flutter/material.dart';
import 'package:responsive_scaffold/src/responsive.dart';

class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    super.key,
    required this.body,
    this.rightPanel,
    this.floatingActionButton,
    this.appBar,
    this.unauthenticatedView,
    this.isUserAuthenticated,
    this.panelColor,
    this.leftPanel,
    this.alwaysShowAppbar = false,
  });
  final bool alwaysShowAppbar;
  final Widget body;
  final Widget? rightPanel, leftPanel;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;
  final Widget? unauthenticatedView;
  final bool Function()? isUserAuthenticated;
  final Color? panelColor;
  final Duration panelAnimationDuration = const Duration(milliseconds: 600);
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    final bool isMobile = Responsive.isMobile(context);
    final bool isTablet = Responsive.isTablet(context);
    final Size size = MediaQuery.sizeOf(context);

    final bool hasUser = isUserAuthenticated?.call() ?? true;
    if (!hasUser) {
      return unauthenticatedView ??
          const Scaffold(
            body: Center(child: Text("Please sign in to continue")),
          );
    }
    if (isMobile) {
      return Scaffold(
        appBar: appBar,
        drawer: leftPanel == null
            ? null
            : Drawer(shape: const BeveledRectangleBorder(), child: leftPanel),
        endDrawer: rightPanel == null
            ? null
            : Drawer(shape: const BeveledRectangleBorder(), child: rightPanel),
        body: body,
        floatingActionButton: floatingActionButton,
      );
    }
    return Scaffold(
      appBar: alwaysShowAppbar ? appBar : null,
      floatingActionButton: isTablet ? floatingActionButton : null,
      body: Row(
        children: [
          AnimatedContainer(
            height: size.height,
            width: isDesktop
                ? (size.width * 0.2).clamp(200, 300)
                : kToolbarHeight + 15,
            color: panelColor,
            duration: panelAnimationDuration,
            curve: Curves.easeInOutCubic,
            child: leftPanel,
          ),

          Expanded(child: body),

          if (rightPanel != null)
            AnimatedContainer(
              height: size.height,
              width: isDesktop ? (size.width * 0.2).clamp(200, 300) : 0,
              color: panelColor,
              duration: panelAnimationDuration,
              curve: Curves.easeInOutCubic,
              child: rightPanel,
            ),
        ],
      ),
    );
  }
}
