import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:core/theme/index.dart';
import '../../blocs/submission_bloc.dart';
import '../../blocs/submission_state.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _openImageGallery(BuildContext context, int initialIndex, List<String> images) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Image ${initialIndex + 1} of ${images.length}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(images[index]),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3.0,
                heroAttributes: PhotoViewHeroAttributes(tag: images[index]),
              );
            },
            itemCount: images.length,
            loadingBuilder: (context, event) => Center(
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            pageController: PageController(initialPage: initialIndex),
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmissionBloc, SubmissionState>(
      builder: (context, state) {
        if (state is SubmissionDataLoaded) {
          final student = state.students[state.currentStudentIndex];
          final images = student.images;
          
          if (images.isEmpty) {
            return const SizedBox.shrink();
          }
          
          return _buildImageCarousel(context, images);
        } else if (state is GradeSubmissionError) {
          // في حالة خطأ التصحيح، نعرض الصور مع البيانات المحفوظة
          final student = state.students[state.currentStudentIndex];
          final images = student.images;
          
          if (images.isEmpty) {
            return const SizedBox.shrink();
          }
          
          return _buildImageCarousel(context, images);
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildImageCarousel(BuildContext context, List<String> images) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark 
                      ? AppColors.darkAccentBlue.withOpacity(0.3)
                      : AppColors.info.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: PageView.builder(
                itemCount: images.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (context, i) => GestureDetector(
                  onTap: () => _openImageGallery(context, i, images),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        images[i],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: isDark ? AppColors.darkCardBackground : AppColors.gray100,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                                    : null,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isDark ? AppColors.darkAccentBlue : AppColors.info,
                                ),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stack) => Container(
                          color: isDark ? AppColors.darkCardBackground : AppColors.gray100,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image,
                                  size: 48,
                                  color: isDark ? AppColors.darkSecondaryText : AppColors.gray400,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Failed to load image',
                                  style: TextStyle(
                                    color: isDark ? AppColors.darkSecondaryText : AppColors.gray500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.zoom_in,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Tap to zoom',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DotsIndicator(
            dotsCount: images.length,
            position: _currentIndex,
            decorator: DotsDecorator(
              activeColor: isDark ? AppColors.darkAccentBlue : AppColors.info,
              color: isDark ? AppColors.darkSecondaryText : AppColors.gray300,
              size: const Size.square(8),
              activeSize: const Size(24, 8),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
          ),
        ],
      ),
    );
  }
} 