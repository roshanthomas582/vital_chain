# Vital Chain

**Vital Chain** is a **Flutter mobile application** designed to **consolidate and manage a patient's complete medical health records in one place**. It addresses the critical issue of **fragmented health data** by bringing together all documents, prescriptions, certificates, and chronic disease records into a single, accessible platform. The app also **eliminates the dependency on handwritten paper prescriptions** by automatically generating and storing digital PDF prescriptions issued by doctors.

By providing real-time access to a patient’s **allergies, medical history , ongoing medications , prescreptions , lab results and certificates**, Vital Chain ensures that doctors can make more informed decisions, leading to **safer and more effective treatment**. With features tailored for both **patients** and **doctors**, Vital Chain creates a seamless, secure, and centralized healthcare experience.

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
    - add reviews for the doctor.

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

- **Restricted Access to Patient Data:** 
  - Doctors can only view and modify **today’s scheduled patients** for added security and privacy.
 
- **Firebase Authentication:** 
  - Uses Firebase Authentication for secure login and user verification.
  - Passwords are hashed and securely stored by Firebase.

- **Database Rules:** 
  - Firebase Firestore security rules are applied to allow access only to authenticated users based on roles (patient or doctor).

- **Data Encryption:** 
  - All data in Firebase Firestore and files in Firebase Storage are **encrypted in transit and at rest** by default to ensure confidentiality and integrity.

---

## 📄 Auto-Generated PDF Prescriptions

- Includes:
  - Doctor’s name, hospital, and signature
  - Patient’s name, age, and profile data
  - Medical details: problem, diagnosis, suggestions, and prescribed medicines
- Automatically created and saved for both doctor and patient views.

---

## 🚀 Future Goals

- Centralize healthcare data management for government or institutional deployment.
- Expand chatbot capabilities with AI-based diagnostics and alerts.
- Enhance analytics and display charts/graphs for chronic disease tracking and medicine effectiveness.
- Add daily medication reminders via notifications to help users take their medicines on time.

---

## 📌 Note

Vital Chain is currently developed using Flutter and optimized for **mobile platforms**.

---

## 👨‍💻 Developed With

- Flutter & Dart
- Firebase Authentication
- Firestore Database
- Firebase Storage

---

## 📷 Screenshots


![WhatsApp Image 2025-04-08 at 9 00 26 AM](https://github.com/user-attachments/assets/67137c97-829d-43ad-a0fd-e7b0753ac573)

---
