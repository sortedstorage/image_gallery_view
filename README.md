# Image Gallery View
Image gallery view makes it easy to view multiple images at once

## Content

- [Installation](#installation)
- [Usage](#usage)
- [Parameters](#parameters)
- [Community Support](#community-support)

## Installation
Add Image Gallery View to your pubspec.yaml
```yaml
dependencies:
  image_gallery_view: ^1.0.0+1
```

## Usage

### Import the Package
```dart
import 'package:image_gallery_view/image_gallery_view.dart';
```

### Example
```dart
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // Ideally, your thumbnail images are smaller than the original images.
  // In this example, however, I don't have smaller versions of the images,
  // so I just use the same image.
  final _images = <ImageGalleryItem>[
    ImageGalleryItem(
      imageUrl: 'https://images.pexels.com/photos/5720809/pexels-photo-5720809.jpeg',
      thumbnailUrl: 'https://images.pexels.com/photos/5720809/pexels-photo-5720809.jpeg',
      text: 'A nice egg for breakfast'
    ),
    ImageGalleryItem(
      imageUrl: 'https://images.pexels.com/photos/9428260/pexels-photo-9428260.jpeg',
      thumbnailUrl: 'https://images.pexels.com/photos/9428260/pexels-photo-9428260.jpeg',
    ),
    ImageGalleryItem(
      imageUrl: 'https://images.pexels.com/photos/929778/pexels-photo-929778.jpeg',
      thumbnailUrl: 'https://images.pexels.com/photos/929778/pexels-photo-929778.jpeg',
      text: 'Red Rose'
    ),
    ImageGalleryItem(
      imageUrl: 'https://images.pexels.com/photos/4790406/pexels-photo-4790406.jpeg',
      thumbnailUrl: 'https://images.pexels.com/photos/4790406/pexels-photo-4790406.jpeg',
    ),
    ImageGalleryItem(
      imageUrl: 'https://images.pexels.com/photos/10165785/pexels-photo-10165785.jpeg',
      thumbnailUrl: 'https://images.pexels.com/photos/10165785/pexels-photo-10165785.jpeg',
      text: 'This is an egg which has been perfectly cooked and presented very nicely on a plate, with some garnish'
    ),
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

```

## Parameters

### ImageGalleryView
#### Required:
- imageUrls -  List of image urls
- thumbnailUrls - List of image thumbnail urls

#### Optional:
- activeIndex - Index of the active image
- thumbnailSize - Sets the size of the displayed thumbnail images
- backButton - `Widget` to display as the back button
- backButtonAlignment - `Alignment` of back button
- text - Text to overlay on top of the image
- textStyle - `TextStyle` to use for text

## Community Support

If you have any suggestions or issues, feel free to open an [issue](https://github.com/sortedstorage/image_gallery_view/issues).

If you would like to contribute, feel free to create a [PR](https://github.com/sortedstorage/image_gallery_view/pulls).
