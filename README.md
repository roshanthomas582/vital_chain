# Vital Chain

**Vital Chain** is a mobile application designed to **consolidate and manage a patient's complete health records in one place**. With features that benefit both **patients** and **doctors**, the app creates a seamless, secure, and centralized healthcare experience.

---

## 📱 Key Features

### 🔒 For Patients

- **🏠 Home Page Overview**
  - **Documents Section:** Functions like a personal drive to upload and view any health-related files.
  - **Appointments Section:** View all past and upcoming appointments, with an option to cancel them.
  - **Certificates Section:** Access certificates such as blood tests and vaccination reports uploaded by doctors.
  - **Chronic Disease Tracking:** Log daily readings related to chronic illnesses like diabetes, hypertension, etc.
  - **My Medicine:** Automatically fetches and lists active medications from prescriptions issued by doctors.
  - **Prescription Section:** View all prescriptions issued. Prescriptions are auto-generated in PDF format by the system.
  - **Sort & Filter:** Documents, certificates, chronic logs, and prescriptions can be sorted by date for easy navigation.

- **🔍 Doctor Search**
  - Search for doctors based on **name**, **hospital**, or **location**.
  - Tap a doctor’s name to view their **detailed profile** including:
    - Photo, name, age
    - Specialization, educational qualifications
    - Work history
    - Appointment request button
    - Patient reviews

- **🤖 Smart Chatbot**
  - Get instant information about medicines such as usage, dosage, and potential side effects.

- **👤 Profile & Settings**
  - View and edit your personal profile.
  - Access settings to **change password**, **delete account**, or **logout**.

---

### 🩺 For Doctors

- **🗓 Appointment Management**
  - View appointment requests and approve or reject them.
  - See the list of all appointments, including historical data.

- **📅 Daily Schedule**
  - Access a filtered list of today's appointments.
  - View the profiles of today's patients and:
    - Upload **prescriptions**
    - Upload **certificates**
    - View their **ongoing medications**
    - View their **prescription history**
    - View their **certificates**
    - View their **chronic disease logs**

- **📄 Prescription Upload**
  - Easily enter:
    - Problem
    - Diagnosis
    - Suggestions
    - Medicines
  - The app will automatically generate a **PDF prescription** containing:
    - Doctor's and patient’s information
    - Entered medical details
    - Doctor’s signature
  - Prescriptions are securely stored and visible to the respective patient.

- **⭐ Reviews**
  - View feedback and ratings given by patients.

- **👤 Profile & Settings**
  - View and update doctor profile.
  - Change password, delete account, or logout securely.

---

## 🔐 Security Features

- **Role-Based Access:** 
  - Only doctors can upload **prescriptions** and **certificates**.
  - Patients cannot modify or upload these records.

- **Automated Medication Tracker:** 
  - Active medicines are fetched from prescriptions and shown only if valid for the current day.

- **Restricted Access to Patient Data:** 
  - Doctors can only view and modify **today’s scheduled patients** for added security and privacy.

---

## 📄 Auto-Generated PDF Prescriptions

- Includes:
  - Doctor’s name, photo, hospital, and signature
  - Patient’s name, age, and profile data
  - Medical details: problem, diagnosis, suggestions, and prescribed medicines
- Automatically created and saved for both doctor and patient views.

---

## 🚀 Future Goals

- Centralize healthcare data management for government or institutional deployment.
- Expand chatbot capabilities with AI-based diagnostics and alerts.
- Enhance analytics for chronic disease tracking and medicine effectiveness.
- Add daily medication reminders via notifications to help users take their medicines on time.

---

## 📌 Note

Vital Chain is currently developed and optimized for **mobile platforms**.

---

## 📷 Screenshots



---

## 👨‍💻 Developed With

- Flutter & Dart
- Firebase Authentication
- Firestore Database
- Firebase Storage
- PDF Generation Libraries
- State Management (Provider/Bloc/etc.)

---
