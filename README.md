# Richele Fashion Mobile Client (Flutter)
### A cross-platform mobile application built with Flutter/Dart focusing on look discovery and fashion inspiration, designed under a decoupled client-server architecture.

---

## 📐 Overview & Architectural Purpose
This repository contains the mobile frontend client designed to interact asynchronously with a dedicated Laravel 10 backend API. 

As a seasoned backend engineer, I built this project to deepen my understanding of client-side execution lifecycles, cross-platform mobile architectures, mobile state management, and real-time state synchronization over HTTP REST layers.

---

## 🚀 Key Implementation Details & Mobile Patterns

- **Secure State & Token Persistence:** Implemented client-side storage mechanisms to securely cache API authentication tokens, ensuring stateful user sessions across application restarts.
- **Social OAuth2 & Registration Flow:** Engineered user registration and authentication workflows, seamlessly integrating native Google Login redirection and secure backend authentication exchanges.
- **Decoupled API Service Layer:** Built an isolated API service client to handle asynchronous network requests, payload serialization, and centralized error parsing for profile updates and account lifecycles.
- **UX & Dynamic Theme Customization:** Designed an extensible component layout featuring a modular Homepage architecture, responsive structures, and fluid layout styling adaptations (such as real-time color transitions).
- **Privacy Operations Implementation:** Wired native alert frameworks and localized triggers for critical account lifecycle events, including automated user data purge confirmations ("Delete Account" workflow).

---

## 💻 Tech Stack & Mobile Ecosystem

- **Framework:** Flutter (Cross-platform UI development)
- **Language:** Dart
- **Architecture:** Client-Server / Service-Oriented (Decoupled Layer)
- **Key Concepts:** Local Storage Persistence, Social Authentication, REST Service Client

---

## 🛠️ Project Iteration History
The client was built incrementally through iterative, feature-based commits mapping out core infrastructure first:
* Setup of structural routing and architecture foundations.
* Implementation of local state persistence, token storage strategy, and API handshake clients.
* Development of interactive user flows (Google Login integration, Profile Upgrades, Account Termination triggers).
