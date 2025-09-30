import 'package:flutter/material.dart';
import 'package:electricity/core/widgets/flutter_toast_x.dart';

/// Demo screen showing FlutterToastX capabilities
class ToastDemoScreen extends StatelessWidget {
  const ToastDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FlutterToastX Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'FlutterToastX Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Basic toast types
            const Text(
              'Basic Toast Types:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => FlutterToastX.success('Success message!'),
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Success'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => FlutterToastX.error('Error occurred!'),
                    icon: const Icon(Icons.error),
                    label: const Text('Error'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => FlutterToastX.warning('Warning message!'),
                    icon: const Icon(Icons.warning),
                    label: const Text('Warning'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => FlutterToastX.info('Info message!'),
                    icon: const Icon(Icons.info),
                    label: const Text('Info'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
            const Text(
              'Custom Configurations:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () => FlutterToastX.success(
                'Custom position toast!',
                config: const ToastConfig(
                  position: ToastPosition.bottomLeft,
                  autoClose: Duration(seconds: 6),
                ),
              ),
              child: const Text('Bottom Left Toast'),
            ),
            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () => FlutterToastX.info(
                'No progress bar!',
                config: const ToastConfig(
                  hideProgressBar: true,
                  position: ToastPosition.topCenter,
                ),
              ),
              child: const Text('No Progress Bar'),
            ),
            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () => FlutterToastX.warning(
                'Custom icon toast!',
                icon: const Icon(Icons.celebration, color: Colors.white),
                config: const ToastConfig(position: ToastPosition.bottomRight),
              ),
              child: const Text('Custom Icon'),
            ),

            const SizedBox(height: 32),
            const Text(
              'Advanced Features:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _showLoadingDemo,
              child: const Text('Loading Demo'),
            ),
            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () => FlutterToastX.dismissAll(),
              child: const Text('Dismiss All Toasts'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            ),

            const Spacer(),
            const Text(
              'Toast notifications appear at the top-right by default.\nTry different buttons to see various configurations!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoadingDemo() async {
    String loadingId = FlutterToastX.info('Loading data...');

    // Simulate loading
    await Future.delayed(const Duration(seconds: 3));

    FlutterToastX.dismiss(loadingId);
    FlutterToastX.success('Data loaded successfully!');
  }
}
