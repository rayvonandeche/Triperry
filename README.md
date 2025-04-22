# Triperry - AI Travel Assistant App

A Flutter application demonstrating advanced animations and UI techniques for a travel planning assistant.

## Project Overview

Triperry is an AI-powered travel assistant app that helps users plan their trips through a conversational interface. The app features beautiful animations and transitions to create a fluid, engaging user experience.

## Key Features

- **AI Travel Planning**: Conversational interface for trip planning
- **Staged Interactions**: Multi-stage travel planning workflow (interests → destinations → timing → activities)
- **Rich Animations**: Smooth transitions between stages with fade and slide effects
- **Conversation History**: Track and review your planning session
- **Responsive Design**: Adapts to different screen sizes with dynamic layouts

## Animation Techniques Used

- Staggered animations using `AnimationController`
- Fade transitions with `FadeTransition`
- Slide animations with `SlideTransition`
- Custom curved animations using `CurvedAnimation` with `Curves.easeOutCubic`
- Backdrop blur effects using `BackdropFilter` and `ImageFilter`

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio or VS Code with Flutter extensions

### Installation
1. Clone this repository
2. Run `flutter pub get` to install dependencies
3. Connect a device or start an emulator
4. Run `flutter run` to launch the app

## Project Structure

- `lib/screens/ai/` - Core AI assistant interface 
- `lib/screens/ai/widgets/` - UI components for the AI experience
- `lib/screens/ai/animations/` - Animation definitions and utilities
- `lib/screens/ai/models/` - Data models for the travel planning flow
- `lib/screens/ai/services/` - Business logic and conversation handling

## Learn More

For help getting started with Flutter development:
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter Animation Documentation](https://docs.flutter.dev/ui/animations)
