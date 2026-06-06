# PromptWar Challenge 101 🏆

Welcome to the **PromptWar Challenge 101** repository! This repository is dedicated to solving prompt engineering challenges and building competitive LLM prompting strategies.

## 🎯 Challenge Goal

The objective of this challenge is to design, refine, and optimize prompts to achieve the highest performance, accuracy, or specific target behavior from a language model under given constraints.

## 📂 Project Structure

*(Fill this section as you add source code, prompts, and evaluation datasets.)*

- `prompts/` - Directory to store your prompt templates.
- `src/` - Source code for interacting with the LLM APIs and running evaluations.
- `tests/` - Test cases to validate prompt behavior.

## ⚙️ Setup and Installation

1.  **Clone the repository** (if not already done):
    ```bash
    git clone https://github.com/harshit435/promptWar_challange101.git
    cd promptWar_challange101
    ```

2.  **Set up your environment variables**:
    Create a `.env` file at the root of the repository and add your API keys:
    ```env
    OPENAI_API_KEY=your_key_here
    GEMINI_API_KEY=your_key_here
    ```

3.  **Install dependencies**:
    *(Define your dependencies in a requirements.txt or pyproject.toml file.)*
    ```bash
    pip install -r requirements.txt
    ```

## 📈 Evaluation

Detail how to run prompt evaluations and track metrics.

## Firebase Hosting

This app is already configured for Firebase Hosting as a Flutter web app.

1. Create a Firebase project in the Firebase Console.
2. Install the Firebase CLI if you do not already have it:
    ```bash
    npm install -g firebase-tools
    ```
3. Log in and select your project:
    ```bash
    firebase login
    firebase use --add
    ```
4. Build the Flutter web app:
    ```bash
    flutter build web --release
    ```
5. Deploy to Hosting:
    ```bash
    firebase deploy --only hosting
    ```

The Hosting config serves `build/web` and rewrites all routes to `index.html`, which is the standard setup for Flutter single-page apps.

---
Good luck with the challenge! 🚀
