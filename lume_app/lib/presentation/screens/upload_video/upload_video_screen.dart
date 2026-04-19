// lib/presentation/screens/upload_video/upload_video_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/theme/app_colors.dart';
import '../../../data/repositories/video_repository.dart';
import '../../widgets/gradient_button.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({super.key});

  @override
  State<UploadVideoScreen> createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  File? _videoFile;
  File? _thumbnailFile;
  bool _isUploading = false;
  double _progress = 0;
  final _picker = ImagePicker();
  final _videoRepo = VideoRepository();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    final video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) setState(() => _videoFile = File(video.path));
  }

  Future<void> _pickThumbnail() async {
    final img = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (img != null) setState(() => _thumbnailFile = File(img.path));
  }

  Future<void> _upload() async {
    if (_videoFile == null || _thumbnailFile == null || _titleCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and pick video + thumbnail'), backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() { _isUploading = true; _progress = 0.1; });

    try {
      setState(() => _progress = 0.4);
      await _videoRepo.publishVideo(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        videoPath: _videoFile!.path,
        thumbnailPath: _thumbnailFile!.path,
      );
      setState(() => _progress = 1.0);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video uploaded successfully! 🎉'), backgroundColor: AppColors.success),
        );
        context.go('/home');
      }
    } catch (e) {
      setState(() { _isUploading = false; _progress = 0; });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Upload Video'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video picker
            GestureDetector(
              onTap: _pickVideo,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _videoFile != null ? AppColors.primary : AppColors.border, width: 1.5),
                  ),
                  child: _videoFile != null
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            const Icon(Icons.check_circle, color: AppColors.success, size: 48),
                            Positioned(
                              bottom: 12,
                              child: Text(
                                _videoFile!.path.split('/').last,
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.video_call, color: AppColors.primary, size: 52),
                            SizedBox(height: 10),
                            Text('Tap to select video', style: TextStyle(color: AppColors.textSecondary)),
                            Text('MP4, MOV, AVI', style: TextStyle(color: AppColors.textSubtle, fontSize: 12)),
                          ],
                        ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Thumbnail picker
            GestureDetector(
              onTap: _pickThumbnail,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _thumbnailFile != null ? AppColors.primary : AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                        image: _thumbnailFile != null
                            ? DecorationImage(image: FileImage(_thumbnailFile!), fit: BoxFit.cover)
                            : null,
                      ),
                      child: _thumbnailFile == null ? const Icon(Icons.image_outlined, color: AppColors.textSubtle) : null,
                    ),
                    const SizedBox(width: 14),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _thumbnailFile != null ? 'Thumbnail selected ✓' : 'Add Thumbnail',
                          style: TextStyle(
                            color: _thumbnailFile != null ? AppColors.success : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text('Recommended: 1280×720', style: TextStyle(color: AppColors.textSubtle, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: _titleCtrl,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(labelText: 'Title', prefixIcon: Icon(Icons.title)),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _descCtrl,
              style: const TextStyle(color: AppColors.textPrimary),
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description', prefixIcon: Icon(Icons.description_outlined), alignLabelWithHint: true),
            ),

            const SizedBox(height: 24),

            if (_isUploading) ...[
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 10),
              const Center(child: Text('Uploading...', style: TextStyle(color: AppColors.textSecondary))),
              const SizedBox(height: 20),
            ],

            GradientButton(
              text: 'Upload Video',
              onPressed: _isUploading ? null : _upload,
              isLoading: _isUploading,
              icon: Icons.cloud_upload_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
