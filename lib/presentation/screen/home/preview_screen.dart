import 'package:flutter/material.dart';
import 'dart:html' as html;
// import 'dart:ui' as ui;
import 'dart:ui_web' as ui;

/// [Widget] displaying the home page consisting of an image the the buttons.
class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

/// State of a [PreviewScreen].
class _PreviewScreenState extends State<PreviewScreen> {
  // urlController will hold the image URL
  TextEditingController urlController = TextEditingController();

  String? imageUrl;

  /// [isMenuOpen] will define the menu status, opened or closed
  bool isMenuOpen = false;

  ///[toggleFullscreen] will toggle full-screen and default size
  void toggleFullscreen() {
    if (html.document.fullscreenElement == null) {
      html.document.documentElement?.requestFullscreen();
    } else {
      html.document.exitFullscreen();
    }
  }

  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  void closeMenu() {
    setState(() {
      isMenuOpen = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // Registering the custom HTML view for displaying the image
    ui.platformViewRegistry.registerViewFactory('imageElement', (int viewId) {
      final imgElement = html.ImageElement()
        ..src = imageUrl ?? ''
        ..style.maxWidth = '80%'
        ..style.maxHeight = '80%'
        ..style.objectFit = 'contain';
      return imgElement;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isMenuOpen ? Colors.black54 : Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: urlController,
                          decoration: InputDecoration(
                            labelText: 'Enter Image URL',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            imageUrl = urlController.text;
                          });
                        },
                        child: Text('Load Image'),
                      ),
                    ],
                  ),
                ),
                if (imageUrl != null && imageUrl!.isNotEmpty)
                  Container(
                    color: Color(0xffe4eaf5),
                    width: MediaQuery.sizeOf(context).height * 0.3,
                    height: MediaQuery.sizeOf(context).height * 0.3,
                    child: GestureDetector(
                      onDoubleTap: toggleFullscreen,
                      child: HtmlElementView(
                        viewType: 'imageElement',
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                if (isMenuOpen)
                  GestureDetector(
                    onTap: closeMenu,
                    child: Container(
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                if (isMenuOpen)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {
                          html.document.documentElement?.requestFullscreen();
                          closeMenu();
                        },
                        label: Text('Enter Fullscreen'),
                        icon: Icon(Icons.fullscreen),
                      ),
                      SizedBox(height: 10),
                      FloatingActionButton.extended(
                        onPressed: () {
                          html.document.exitFullscreen();
                          closeMenu();
                        },
                        label: Text('Exit Fullscreen'),
                        icon: Icon(Icons.fullscreen_exit),
                      ),
                    ],
                  ),
                FloatingActionButton(
                  onPressed: toggleMenu,
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
