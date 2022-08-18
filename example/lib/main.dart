import 'package:flutter/material.dart';
import 'package:image_gallery_view/image_gallery_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // Ideally, your thumbnail images are smaller than the original images.
  // In this example, however, I don't have smaller versions of the images,
  // so I just use the same image.
  final _images = <ImageGalleryItem>[
    ImageGalleryItem(
        imageUrl:
            'https://images.pexels.com/photos/5720809/pexels-photo-5720809.jpeg',
        thumbnailUrl:
            'https://images.pexels.com/photos/5720809/pexels-photo-5720809.jpeg',
        text: 'A nice egg for breakfast'),
    ImageGalleryItem(
      imageUrl:
          'https://images.pexels.com/photos/9428260/pexels-photo-9428260.jpeg',
      thumbnailUrl:
          'https://images.pexels.com/photos/9428260/pexels-photo-9428260.jpeg',
    ),
    ImageGalleryItem(
        imageUrl:
            'https://images.pexels.com/photos/929778/pexels-photo-929778.jpeg',
        thumbnailUrl:
            'https://images.pexels.com/photos/929778/pexels-photo-929778.jpeg',
        text: 'Red Rose'),
    ImageGalleryItem(
      imageUrl:
          'https://images.pexels.com/photos/4790406/pexels-photo-4790406.jpeg',
      thumbnailUrl:
          'https://images.pexels.com/photos/4790406/pexels-photo-4790406.jpeg',
    ),
    ImageGalleryItem(
        imageUrl:
            'https://images.pexels.com/photos/10165785/pexels-photo-10165785.jpeg',
        thumbnailUrl:
            'https://images.pexels.com/photos/10165785/pexels-photo-10165785.jpeg',
        text:
            'This is an egg which has been perfectly cooked and presented very nicely on a plate, with some garnish'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: ImageGalleryView(
        images: _images,
      ),
    );
  }
}
