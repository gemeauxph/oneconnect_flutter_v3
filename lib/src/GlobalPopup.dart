import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalPopup {
  static OverlayEntry? _entry;

  static void show(BuildContext context,
      {required String message,
        required String title,
        required String link,
        required String image,
        required String logo,
        required String ctaText,
        required int showStar}) {
    if (_entry != null) return; // Prevent multiple popups

    _entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 80,
        left: 20,
        right: 20,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: GestureDetector(
              onTap: () {
                _launchURL(link);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ad',
                        style: TextStyle(
                          color: Color(0xFF808080),
                          fontSize: 16,
                        ),
                      ),
                      InkWell(
                        onTap: () => hide(),
                        child: const Text(
                          'X',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (image.isNotEmpty)
                    Image.network(
                      "https://developer.oneconnect.top/uploads/$image",
                      fit: BoxFit.cover,
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (logo.isNotEmpty)
                        Image.network(
                          "https://developer.oneconnect.top/uploads/$logo",
                          width: 57,
                          height: 57,
                          fit: BoxFit.cover,
                        ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (title.isNotEmpty)
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            if (message.isNotEmpty)
                              Text(
                                _stripHtmlTags(message),
                                style: const TextStyle(
                                  color: Color(0xFF808080),
                                  fontSize: 14,
                                ),
                              ),
                            if (showStar != 0)
                              Row(
                                children: List.generate(
                                  5,
                                      (index) => const Icon(
                                    Icons.star,
                                    color: Color(0xFFFDCA0E),
                                    size: 20,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (ctaText.isNotEmpty && link.isNotEmpty)
                    ElevatedButton(
                      onPressed: () => _launchURL(link),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(ctaText),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}

Future<void> _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

String _stripHtmlTags(String html) {
  return html.replaceAll(RegExp(r'<[^>]*>'), '');
}

