import 'package:flutter/material.dart';
import 'package:union_shop/widgets/header.dart';
import 'package:union_shop/widgets/footer.dart';
import 'package:union_shop/models/cart_scope.dart';
import 'package:go_router/go_router.dart';

class PrintPersonalisationPage extends StatefulWidget {
  const PrintPersonalisationPage({super.key});

  @override
  State<PrintPersonalisationPage> createState() =>
      _PrintPersonalisationPageState();
}

class _PrintPersonalisationPageState extends State<PrintPersonalisationPage> {
  String text = 'Your text here';
  String fontFamily = 'Roboto';
  double fontSize = 28;
  Color color = Colors.black;
  bool includeBorder = false;
  String alignment = 'Center';

  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.text = text;
    _textController.addListener(() {
      setState(() {
        text = _textController.text;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppHeader(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Print Shack — Text Personalisation',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Create personalised prints by entering text and choosing style options. Preview updates live as you change fields.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    // Form and preview side-by-side on wide screens
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 700;
                        return isWide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: _buildForm()),
                                  const SizedBox(width: 24),
                                  Expanded(child: _buildPreview()),
                                ],
                              )
                            : Column(
                                children: [
                                  _buildForm(),
                                  const SizedBox(height: 20),
                                  _buildPreview(),
                                ],
                              );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Add to cart or further actions (placeholder)
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Generate a stable-ish id for personalised prints
                            final generatedId =
                                'print-${DateTime.now().millisecondsSinceEpoch}';

                            final cartNotifier = CartScope.of(context);
                            cartNotifier.value =
                                cartNotifier.value.addItem(generatedId, 1);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added to cart')),
                            );
                          },
                          child: const Text('Add to cart'),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () {
                            context.go('/print/about');
                          },
                          child: const Text('About Print Shack'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Text', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            const Text('Font family',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: fontFamily,
              items: const [
                DropdownMenuItem(value: 'Roboto', child: Text('Roboto')),
                DropdownMenuItem(value: 'Lobster', child: Text('Lobster')),
                DropdownMenuItem(value: 'Courier', child: Text('Courier')),
              ],
              onChanged: (v) => setState(() => fontFamily = v ?? 'Roboto'),
            ),
            const SizedBox(height: 16),
            const Text('Font size',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: fontSize,
              min: 12,
              max: 72,
              divisions: 12,
              label: fontSize.round().toString(),
              onChanged: (v) => setState(() => fontSize = v),
            ),
            const SizedBox(height: 16),
            const Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _colorChip(Colors.black),
                _colorChip(Colors.white),
                _colorChip(Colors.red),
                _colorChip(Colors.blue),
                _colorChip(Colors.green),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: includeBorder,
                  onChanged: (v) => setState(() => includeBorder = v ?? false),
                ),
                const SizedBox(width: 8),
                const Flexible(
                  child: Text('Include border around text'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Alignment',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: alignment,
              items: const [
                DropdownMenuItem(value: 'Left', child: Text('Left')),
                DropdownMenuItem(value: 'Center', child: Text('Center')),
                DropdownMenuItem(value: 'Right', child: Text('Right')),
              ],
              onChanged: (v) => setState(() => alignment = v ?? 'Center'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    final textWidget = Text(
      text.isEmpty ? ' ' : text,
      textAlign: alignment == 'Left'
          ? TextAlign.left
          : alignment == 'Right'
              ? TextAlign.right
              : TextAlign.center,
      style: TextStyle(
        fontFamily: fontFamily == 'Lobster' ? 'Lobster' : null,
        fontSize: fontSize,
        color: color,
      ),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 300,
        color: color == Colors.white ? Colors.grey[200] : Colors.white,
        child: Center(
          child: Container(
            padding: includeBorder ? const EdgeInsets.all(12) : EdgeInsets.zero,
            decoration: includeBorder
                ? BoxDecoration(border: Border.all(color: Colors.grey))
                : null,
            child: textWidget,
          ),
        ),
      ),
    );
  }

  Widget _colorChip(Color c) {
    return GestureDetector(
      onTap: () => setState(() => color = c),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: c,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: color == c ? const Icon(Icons.check, color: Colors.white) : null,
      ),
    );
  }
}
