import 'package:flutter/material.dart';
import 'package:electricity/shared/widgets/responsive_layout.dart';
import 'package:electricity/shared/widgets/slide_in_panel.dart';
import 'package:electricity/features/houses/presentation/screens/house_form_screen.dart';
import 'package:electricity/features/houses/presentation/form/house_form_model.dart';
import 'package:provider/provider.dart';

/// Navigation helper for responsive form handling
class ResponsiveFormNavigator {
  /// Show responsive form that adapts to screen size changes in real-time
  static void _showResponsiveForm({
    required BuildContext context,
    required Widget formWidget,
    required String title,
    double panelWidth = 600,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (context, animation, secondaryAnimation) {
          return _ResponsiveFormWrapper(
            formWidget: formWidget,
            title: title,
            panelWidth: panelWidth,
            animation: animation,
            onClose: () => Navigator.of(context).pop(),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  /// Navigate to add house form
  static void navigateToAddHouse(BuildContext context) {
    // Create the provider once and reuse it
    final formProvider = ChangeNotifierProvider(
      create: (context) => HouseFormModel(),
      child: const AddHouseScreen(),
    );

    _showResponsiveForm(
      context: context,
      title: 'Add New House',
      formWidget: formProvider,
    );
  }

  /// Navigate to edit house form
  static void navigateToEditHouse(BuildContext context, String houseId) {
    // Create the provider once and reuse it
    final formProvider = ChangeNotifierProvider(
      create: (context) => HouseFormModel(),
      child: EditHouseScreen(houseId: houseId),
    );

    _showResponsiveForm(
      context: context,
      title: 'Edit House',
      formWidget: formProvider,
    );
  }
}

/// Wrapper to ensure form content has proper padding when shown in slide-in panel
class _FormContentWrapper extends StatelessWidget {
  final Widget child;

  const _FormContentWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Add padding only when in slide-in panel (desktop mode)
        if (constraints.maxWidth >= ResponsiveBreakpoints.desktop) {
          return Padding(padding: const EdgeInsets.all(16.0), child: child);
        } else {
          // No additional padding for mobile/tablet
          return child;
        }
      },
    );
  }
}

/// Responsive wrapper that maintains form state while changing presentation
class _ResponsiveFormWrapper extends StatefulWidget {
  final Widget formWidget;
  final String title;
  final double panelWidth;
  final Animation<double> animation;
  final VoidCallback onClose;

  const _ResponsiveFormWrapper({
    required this.formWidget,
    required this.title,
    required this.panelWidth,
    required this.animation,
    required this.onClose,
  });

  @override
  State<_ResponsiveFormWrapper> createState() => _ResponsiveFormWrapperState();
}

class _ResponsiveFormWrapperState extends State<_ResponsiveFormWrapper> {
  late Widget _stableFormWidget;

  @override
  void initState() {
    super.initState();
    // Create the form widget once and keep it stable
    _stableFormWidget = widget.formWidget;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Check screen size in real-time and adapt presentation
        if (constraints.maxWidth >= ResponsiveBreakpoints.desktop) {
          // Desktop: Show slide-in panel
          return SlideInPanel(
            title: widget.title,
            width: widget.panelWidth,
            showCloseButton: true,
            showHeader: true,
            onClose: widget.onClose,
            child: _FormContentWrapper(child: _stableFormWidget),
          );
        } else {
          // Mobile/Tablet: Show full screen with fade transition
          return FadeTransition(
            opacity: widget.animation,
            child: _stableFormWidget,
          );
        }
      },
    );
  }
}
