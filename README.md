# 🔥 Spark - Coding Helper App

**Spark** is an educational mobile application built with Flutter that helps newcomers learn programming concepts interactively. It features beginner-friendly definitions, category-specific AI chat, and intuitive UI navigation.

## ✨ Features

- 🚀 Splash screen with gradient UI
- 📚 Home page listing core programming concepts:
  - Variable
  - Condition
  - Loop
  - Function
  - Array
  - Pointers
- 🤖 AI-powered interaction (using Gemini API)
- ✅ Category-based input validation
- 🔒 Prevents irrelevant questions outside topic scope
- 📱 Mobile-responsive layout



## 🧠 How It Works

1. The user selects a topic from the home screen.
2. On the detail page, they can input a question or code snippet.
3. Spark checks if the input is relevant to the selected topic.
4. If relevant, the app sends the query to the Gemini API and displays the AI’s response.
5. If not relevant, Spark notifies the user and requests a valid topic-related input.

## 🛠️ Tech Stack

- **Flutter**: UI & Logic
- **Dart**: Programming language
- **Google Gemini API**: AI chat response
- **HTTP Package**: For API calls

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^0.14.0
