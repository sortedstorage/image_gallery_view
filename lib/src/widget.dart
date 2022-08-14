import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_view/src/cubit/image_gallery_cubit.dart';
import 'package:image_gallery_view/src/cubit/mouse_hover_cubit.dart';

import 'cubit/mouse_hover_state.dart';

/// {@template image_gallery_view.ImageGalleryView}
/// A widget that displays a gallery of images.
/// {@endtemplate}
class ImageGalleryView extends StatefulWidget {
  /// {@macro image_gallery_view.ImageGalleryView}
  const ImageGalleryView({
    Key? key,
    required this.imageUrls,
    required this.thumbnailUrls,
    this.activeIndex = 0,
    this.thumbnailSize = 100,
    this.backButton,
    this.backButtonAlignment = Alignment.topLeft,
  }) : super(key: key);

  /// List of image urls
  final List<String> imageUrls;

  /// {@template image_gallery_view.thumbnailUrls}
  /// List of image thumbnail urls
  /// {@endtemplate}
  final List<String> thumbnailUrls;

  /// {@template image_gallery_view.activeIndex}
  /// Index of the active image.
  /// {@endtemplate}
  final int activeIndex;

  /// {@template image_gallery_view.thumbnailSize}
  /// Size of thumbnail image
  /// {@endtemplate}
  final double thumbnailSize;

  /// Widget to display for the back icon
  final Widget? backButton;

  /// Alignment of back button
  final Alignment backButtonAlignment;

  @override
  State<ImageGalleryView> createState() => _ImageGalleryViewState();
}

class _ImageGalleryViewState extends State<ImageGalleryView> {
  late final ImageGalleryCubit imageGalleryCubit;
  late final MouseHoverCubit mouseHoverCubit;

  @override
  void initState() {
    imageGalleryCubit = ImageGalleryCubit();
    mouseHoverCubit = MouseHoverCubit();

    // Cache images when the index changes
    imageGalleryCubit.stream.listen((index) {
      _cacheImages(context, index);
    });

    super.initState();
  }

  @override
  void dispose() {
    imageGalleryCubit.dispose();
    mouseHoverCubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: StreamBuilder<int>(
          stream: imageGalleryCubit.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }

            final state = snapshot.data!;

            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: widget.thumbnailSize + 75,
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrls[state],
                      placeholder: (context, url) => Stack(
                        children: [
                          Center(
                            child: Image.network(
                              widget.thumbnailUrls[state],
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Container(
                      height: widget.thumbnailSize + 27,
                      width: mediaQuery.size.width * 0.6,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        color: const Color(0xFF2C2C2C),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        child: SizedBox(
                          height: widget.thumbnailSize + 5,
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(
                              dragDevices: {
                                PointerDeviceKind.touch,
                                PointerDeviceKind.mouse,
                              },
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.imageUrls.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () => imageGalleryCubit
                                          .changeActiveImage(index),
                                      child: state == index
                                          ? DecoratedBox(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFF4ED1FF),
                                                  width: 3,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                child: _ThumbnailView(
                                                  index: index,
                                                  thumbnailUrls:
                                                      widget.thumbnailUrls,
                                                  thumbnailSize:
                                                      widget.thumbnailSize,
                                                ),
                                              ),
                                            )
                                          : _ThumbnailView(
                                              index: index,
                                              thumbnailUrls:
                                                  widget.thumbnailUrls,
                                              thumbnailSize:
                                                  widget.thumbnailSize,
                                            ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onHover: (event) =>
                        mouseHoverCubit.toggleLeftSideHover(true),
                    onExit: (event) =>
                        mouseHoverCubit.toggleLeftSideHover(false),
                    child: StreamBuilder<MouseHoverState>(
                        stream: mouseHoverCubit.stream,
                        builder: (context, snapshot) {
                          late final double opacity;

                          if (snapshot.hasData) {
                            opacity = snapshot.data!.isLeftSideHovering ? 1 : 0;
                          } else {
                            opacity = 0;
                          }

                          return AnimatedOpacity(
                            duration: const Duration(milliseconds: 150),
                            opacity: opacity,
                            child: GestureDetector(
                              onTap: imageGalleryCubit.moveToPreviousImage,
                              child: const SizedBox(
                                height: double.infinity,
                                width: 100,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onHover: (event) =>
                        mouseHoverCubit.toggleRightSideHover(true),
                    onExit: (event) =>
                        mouseHoverCubit.toggleRightSideHover(false),
                    child: StreamBuilder<MouseHoverState>(
                        stream: mouseHoverCubit.stream,
                        builder: (context, snapshot) {
                          late final double opacity;

                          if (snapshot.hasData) {
                            opacity =
                                snapshot.data!.isRightSideHovering ? 1 : 0;
                          } else {
                            opacity = 0;
                          }

                          return AnimatedOpacity(
                            duration: const Duration(milliseconds: 150),
                            opacity: opacity,
                            child: GestureDetector(
                              onTap: () => imageGalleryCubit
                                  .moveToNextImage(widget.imageUrls.length),
                              child: const SizedBox(
                                height: double.infinity,
                                width: 100,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                Align(
                  alignment: widget.backButtonAlignment,
                  child: widget.backButton ??
                      InkWell(
                        customBorder: const CircleBorder(),
                        onTap: Navigator.of(context).pop,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 24, left: 24),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                        ),
                      ),
                ),
              ],
            );
          }),
    );
  }

  void _cacheImages(BuildContext context, int activeIndex) {
    if (activeIndex - 1 >= 0) {
      precacheImage(
          CachedNetworkImageProvider(widget.imageUrls[activeIndex - 1]),
          context);
    }
    if (activeIndex + 1 < widget.imageUrls.length) {
      precacheImage(
          CachedNetworkImageProvider(widget.imageUrls[activeIndex + 1]),
          context);
    }
  }
}

class _ThumbnailView extends StatelessWidget {
  const _ThumbnailView({
    Key? key,
    required this.index,
    required this.thumbnailUrls,
    required this.thumbnailSize,
  }) : super(key: key);

  /// {@macro image_gallery_view.activeIndex}
  final int index;

  /// {@macro image_gallery_view.thumbnailUrls}
  final List<String> thumbnailUrls;

  /// {@macro image_gallery_view.thumbnailSize}
  final double thumbnailSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: thumbnailSize,
      width: thumbnailSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF383838),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          thumbnailUrls[index],
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
