import 'package:equatable/equatable.dart';

class OnboardingPageItem extends Equatable {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingPageItem({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [imagePath, title, description];
}