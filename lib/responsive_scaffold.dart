import 'package:flutter/material.dart';
import 'package:responsive_scaffold/src/responsive.dart';

class ResponsiveScaffoldController {
  _ResponsiveScaffoldState? _state;

  void _attach(_ResponsiveScaffoldState state) => _state = state;
  void _detach() => _state = null;

  void toggleEndDrawer() {
    final scaffold = _state?._scaffoldKey.currentState;
    if (scaffold == null) return;
    if (scaffold.isEndDrawerOpen) {
      scaffold.closeEndDrawer();
    } else {
      scaffold.openEndDrawer();
    }
  }

  void toggleDrawer() {
    final scaffold = _state?._scaffoldKey.currentState;
    if (scaffold == null) return;
    if (scaffold.isDrawerOpen) {
      scaffold.closeDrawer();
    } else {
      scaffold.openDrawer();
    }
  }

  void closeEndDrawer() {
    _state?._scaffoldKey.currentState?.closeEndDrawer();
  }

  void openEndDrawer() {
    _state?._scaffoldKey.currentState?.openEndDrawer();
  }

  void openDrawer() {
    _state?._scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    _state?._scaffoldKey.currentState?.closeDrawer();
  }
}

class ResponsiveScaffold extends StatefulWidget {
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
    this.controller,
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
  final ResponsiveScaffoldController? controller;

  @override
  State<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);
  }

  @override
  void dispose() {
    widget.controller?._detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    final bool isMobile = Responsive.isMobile(context);
    final bool isTablet = Responsive.isTablet(context);
    final Size size = MediaQuery.sizeOf(context);

    final bool hasUser = widget.isUserAuthenticated?.call() ?? true;
    if (!hasUser) {
      return widget.unauthenticatedView ??
          const Scaffold(
            body: Center(child: Text("Please sign in to continue")),
          );
    }

    if (isMobile) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: widget.appBar,
        drawer: widget.leftPanel == null
            ? null
            : Drawer(
                shape: const BeveledRectangleBorder(),
                child: widget.leftPanel,
              ),
        endDrawer: widget.rightPanel == null
            ? null
            : Drawer(
                shape: const BeveledRectangleBorder(),
                child: widget.rightPanel,
              ),
        body: Stack(
          children: [
            Positioned.fill(child: widget.body),
            if (widget.rightPanel != null &&
                !_scaffoldKey.currentState!.isEndDrawerOpen) ...{
              Positioned(
                right: 0,
                top: kToolbarHeight + 50,
                child: SizedBox(
                  width: 20,
                  height: 200,
                  child: MaterialButton(
                    onPressed: () {
                      if (_scaffoldKey.currentState!.isEndDrawerOpen) {
                        _scaffoldKey.currentState!.closeEndDrawer();
                      } else {
                        _scaffoldKey.currentState!.openEndDrawer();
                      }
                    },
                    child: Center(
                      child: Icon(Icons.chevron_left_outlined, size: 15),
                    ),
                  ),
                ),
              ),
            },
          ],
        ),
        floatingActionButton: widget.floatingActionButton,
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: isTablet
          ? widget.rightPanel == null
                ? null
                : Drawer(
                    shape: const BeveledRectangleBorder(),
                    child: widget.rightPanel,
                  )
          : null,
      appBar: widget.alwaysShowAppbar ? widget.appBar : null,
      floatingActionButton: isTablet ? widget.floatingActionButton : null,
      body: Row(
        children: [
          AnimatedContainer(
            height: size.height,
            width: isDesktop
                ? (size.width * 0.2).clamp(200, 300)
                : kToolbarHeight + 15,
            color: widget.panelColor,
            duration: widget.panelAnimationDuration,
            curve: Curves.easeInOutCubic,
            child: widget.leftPanel,
          ),
          Expanded(child: widget.body),
          if (widget.rightPanel != null)
            AnimatedContainer(
              height: size.height,
              width: isDesktop ? (size.width * 0.2).clamp(200, 300) : 0,
              color: widget.panelColor,
              duration: widget.panelAnimationDuration,
              curve: Curves.easeInOutCubic,
              child: widget.rightPanel,
            ),
        ],
      ),
    );
  }
}
