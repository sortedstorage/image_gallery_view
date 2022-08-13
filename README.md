# Image Gallery View
Image gallery view makes it easy to view multiple images at once

## Content

- [Installation](#installation)
- [Usage](#usage)
- [Community Support](#community-support)

## Installation
Add Image Gallery View to your pubspec.yaml
```yaml
dependencies:
  image_gallery_view: ^1.0.0
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
  final _imageUrls = [
    'https://images.pexels.com/photos/5720809/pexels-photo-5720809.jpeg',
    'https://images.pexels.com/photos/9428260/pexels-photo-9428260.jpeg',
    'https://images.pexels.com/photos/929778/pexels-photo-929778.jpeg',
    'https://images.pexels.com/photos/4790406/pexels-photo-4790406.jpeg',
    'https://images.pexels.com/photos/10165785/pexels-photo-10165785.jpeg',
  ];

  // Ideally, your thumbnail images are smaller than the original images.
  // In this example, however, I don't have smaller versions of the images,
  // so I just use the same image.
  final _thumbnailUrls = [
    'https://images.pexels.com/photos/5720809/pexels-photo-5720809.jpeg',
    'https://images.pexels.com/photos/9428260/pexels-photo-9428260.jpeg',
    'https://images.pexels.com/photos/929778/pexels-photo-929778.jpeg',
    'https://images.pexels.com/photos/4790406/pexels-photo-4790406.jpeg',
    'https://images.pexels.com/photos/10165785/pexels-photo-10165785.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: ImageGalleryView(
        imageUrls: _imageUrls,
        thumbnailUrls: _thumbnailUrls,
      ),
    );
  }
}

```

## Community Support

If you have any suggestions or issues, feel free to open an [issue](https://github.com/sortedstorage/image_gallery_view/issues).

If you would like to contribute, feel free to create a [PR](https://github.com/sortedstorage/image_gallery_view/pulls).
