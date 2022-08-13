import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_view/src/cubit/image_gallery_cubit.dart';
import 'package:image_gallery_view/src/cubit/mouse_hover_cubit.dart';

import 'cubit/mouse_hover_state.dart';

class ImageGalleryView extends StatefulWidget {
  const ImageGalleryView({
    Key? key,
    required this.imageUrls,
    required this.thumbnailUrls,
    this.activeIndex = 0,
  }) : super(key: key);

  /// List of image urls
  final List<String> imageUrls;

  /// List of image thumbnail urls
  final List<String> thumbnailUrls;

  /// Index of active image
  final int activeIndex;

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
                Center(
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Container(
                      height: 127,
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
                          height: 105,
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
                                                color: const Color(0xFF4ED1FF),
                                                width: 3,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3),
                                              child: _ThumbnailView(
                                                index: index,
                                                thumbnailUrls:
                                                    widget.thumbnailUrls,
                                              ),
                                            ),
                                          )
                                        : _ThumbnailView(
                                            index: index,
                                            thumbnailUrls: widget.thumbnailUrls,
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
                  alignment: Alignment.topLeft,
                  child: InkWell(
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
                )
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
  }) : super(key: key);
  final int index;
  final List<String> thumbnailUrls;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
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