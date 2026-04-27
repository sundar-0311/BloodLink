# 🩸 BloodLink – Blood Donation App (Prototype)

A Flutter-based mobile application designed to connect blood donors and recipients efficiently.
This project is currently in the **prototype stage** and focuses on core app structure, UI, and initial integrations.

---

## 🚀 Features

* 🔐 User Authentication using Supabase
* 📱 Clean and responsive Flutter UI
* 🤖 AI Chatbot integration (Groq API – WIP)
* 🩸 Donor–Recipient interaction flow (prototype)
* 📊 Multiple app screens (home, profile, requests, history)

---

## ⚠️ Current Status

> 🚧 This project is under development

* Uses **dummy data** for most features
* Some buttons and flows are **not fully implemented**
* AI features are **partially integrated (WIP)**

---

## 🛠 Tech Stack

* **Frontend:** Flutter (Dart)
* **Backend/Auth:** Supabase
* **AI Integration:** Groq API (LLM-based chatbot)

---

## 📂 Project Structure

```
lib/
 ├── pages/
 │   ├── login_page.dart
 │   ├── home_page.dart
 │   ├── chatbot_page.dart
 │   ├── profile_page.dart
 │   ├── request_page.dart
 │   ├── find_donor_page.dart
 │   └── donation_history_page.dart
 └── main.dart
```

---

## ⚙️ Setup Instructions

1. Clone the repository:

   ```
   git clone https://github.com/your-username/BloodLink.git
   cd blood_app
   ```

2. Create a `.env` file in the root directory:

   ```
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   GROQ_API_KEY=your_groq_api_key
   ```

3. Install dependencies:

   ```
   flutter pub get
   ```

4. Run the app:

   ```
   flutter run
   ```

---

## 🔒 Environment Variables

This project uses a `.env` file for API keys.
A `.env.example` file is provided for reference.

---

## 📌 Future Improvements

* 🔄 Replace dummy data with real backend integration
* 🤖 Improve AI-based donor matching system
* 📍 Add location-based donor search
* 🔔 Push notifications for urgent requests
* 🧪 Complete end-to-end user flows

---

## 🙌 Acknowledgements

* Supabase for backend services
* Groq for LLM API access
* Flutter for cross-platform development

---

## 👨‍💻 Author

**Sundar V Srihari**
Aspiring Software Developer | App Dev | ML | LLM

---

⭐ If you like this project, feel free to star the repo!
