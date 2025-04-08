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
- **user side**

![WhatsApp Image 2025-04-08 at 9 00 26 AM](https://github.com/user-attachments/assets/67137c97-829d-43ad-a0fd-e7b0753ac573)

![WhatsApp Image 2025-04-08 at 9 00 26 AM (1)](https://github.com/user-attachments/assets/ca20e0bf-1b1b-4e97-8566-985d2958296f)
![WhatsApp Image 2025-04-08 at 9 00 25 AM](https://github.com/user-attachments/assets/b8917353-b505-42d1-9ddb-9f4b6176f139)
![WhatsApp Image 2025-04-08 at 9 00 24 AM](https://github.com/user-attachments/assets/aca5f37a-2850-4c17-b777-39aa9427467d)
![WhatsApp Image 2025-04-08 at 9 00 24 AM (1)](https://github.com/user-attachments/assets/914050ee-b9fa-4ff4-80d6-b59651c7f207)
![Wha![WhatsApp Image 2025-04-08 at 9 00 16 AM (6)](https://github.com/user-atta![WhatsApp Image 202![WhatsApp Image 2025-04-08 at 9 00 16 AM (7)](https://github.com/user-attachments/assets/a8cf884f-dfcc-48a2-b209-6646905f1485)
5-04-08 at 9 00 16 AM (6)](https://github.com/user-attachments/assets/4a71e845-8f1a-4a93-9056-9f848fbe51f5)
chments/assets/6b81b8e5-205f-4363-935c-5177d7dedc5e)
tsApp Image 2025-04-08 at 9 00 16 AM (5)](https://github.com/user-attachments/assets/80ff1378-addd-4bc9-9800-daecfbb3cb8d)
![WhatsApp Image 2025-04-08 at 9 00 16 AM (3)](https://github.com/user-atta![WhatsApp Image 2025-![WhatsApp Image 2025-04-08 at 9 00 17 AM (4)](https://github.com/user-attachments/assets/4d35a532-180e-4b73-aec6-acb9380d2dd8)
04-08 at 9 00 16 AM (4)](https://github.com/user-attachments/assets/a533f110-5fc7-46df-a52e-5ea9731f7c62)
chments/assets/5f6f232e-ed9d-4db5-9c2c-a05d0ea9be09)
![WhatsApp Image 2025-04-08 at 9 00 17 AM (2)](https://github.com/user-![WhatsApp Image 2025-04-08 at 9 00 17 AM (3)](https://github.com/user-attachments/assets/9c7d4dba-fd1f-4ac5-95b0-28bcb9d4780e)
attachments/assets/fca782ad-a527-4d72-89a7-05a8f5fe9ed5)
![WhatsApp Image 2025-04-08 at 9 00 18 AM (2)](https://github.com/user-![WhatsApp Image 2025-04-08 at 9 00 17 AM (1)](https://github.com/user-attachments/assets/ec230f9e-8d8f-4d97-8bdb-642f24f5d66b)
attachments/assets/e60519d1-5276-450e-816a-7e4028d0232d)
![WhatsApp Image 2025-04-08 at 9 00 18 AM (1)](https://github.com/user-attachments/assets/3780a094-4a35-476b-b765-4420ace3f400)
![WhatsApp Image 2025-04-08 at 9 00 16 AM (2)](https://github.com/user-attac![WhatsApp Image !![WhatsApp Image 2025-04-08 at 9 00 18 AM](https://github.com/user-attachments/assets/0905646d-c5fe-423b-a528-9f61e5fcbeca)
[WhatsApp Image 2025-04-08 at 9 00 19 AM (2)](https://github.com/user-attachments/assets/9f14c4ac-4d3c-40b7-90f8-25369046d452)
2025!![WhatsApp Image 2025-04-08 at 9 00 19 AM (1)](https://github.com/user-attachments/assets/44d3b7f2-156d-4fe0-a169-fe1199416522)
[WhatsApp Image 2025-04-08 at 9 00 19 AM](https://github.com/user-attachments/assets/2c0eec69-03e5-4580-9020-12894e1706ff)
-![WhatsApp Image 2025-04-08 at 9 00 15 AM (2)](https://github.com/user-attachments/assets/360d6439-33fd-466e-945e-93754b0765b1)
04-08 at 9 00 15 AM (1)](https://github.com/user-attachments/assets/fb2afb2f-8e37-41b7-b87e-021bf3d24fb3)
hments/assets/da19fab4-3ff1-4b2a-b551-f0eef3971b5a)
![WhatsApp Image 2025-04-08 at 9 00 16 AM (1)](https://github.com/user-attachments/assets/8aee1b0e-d6eb-4499-ac2e-bea7bd6548e6)
![WhatsApp Image 2025-04-08 at 9 00 17 AM](https://github.com/user-attachments/assets/666aca06-5f85-444e-b4fa-8a5670ae6252)
![WhatsApp Image 2025-04-08 at 9 00 16 AM](https://github.com/user-attachments/assets/07a8495c-e29b-4258-b133-bd97cd910100)
!![WhatsA![WhatsApp Image 2025-04-08 at 9 00 15 AM](https://github.com/user-attachments/assets/694ac74c-ec5a-46d0-b943-280346f6ac2c)
pp Image 2025-04-08 at 9 00 20 AM (1)](https://github.com/user-at![WhatsApp Image 2025-04-08 at 9 00 20 AM (2)](https://github.com/user-attachments/assets/dc122687-5dc1-4033-9aeb-5acba7be0291)
tachments/assets/a68d38aa-0d0c-4c85-8c66-91f2584a1d33)
[WhatsApp Image 2025-04-08 at 9 00 20 AM](https://github.com/user-attachments/assets/f5f45b5e-051b-4807-9a95-de9f9217b8ed)
![![WhatsApp Image 2025-04-08 at 9 00 21 AM (2)](https://github.com/user-attachments/assets/1ac90e5f-2813-4a11-b2f6-3880909c778d)
WhatsApp Image 2025-04-08 at 9 00 21 AM (1)](https://github.com/user-![WhatsApp Image 2025-04-08 at 9 00 21 AM (2)](https://github.com/user-attachments/assets/2644caf7-13e3-45e8-90dc-74c7c6cf716a)
attachments/assets/2f227c89-9ec4-44d0-baeb-5943e5a82f7a)
![Wh![WhatsApp Image 2025-04-08 at 9 00 21 AM (1)](https://github.com/user-attachments/assets/311513c1-dc4d-42b6-95ad-2763638c0279)
atsApp Image 2025-04-08 at 9 00 21 AM](https://github.com/user-attachments/assets/5502f2b4-338f-4936-a5bf-628f0c9f515e)
![WhatsApp Image 2025-04-08 at 9 00 22 AM (1)](https://github.com/user-![WhatsApp Image 2025-04-08 at 9 00 22 AM (2)](https://github.com/user-attachments/assets/af8a2f4f-20d3-4cbe-a49f-cab8b3b4be61)
attachments/assets/ed472b8b-c53a-48e5-a68b-f0b2040d2205)
![WhatsApp Image 2025-04-08 at 9 00 23 AM (1)](https://github.com/user-![WhatsApp Image 2025-04-08 at 9 00 22 AM](https://github.com/user-attachments/assets/35536b4e-67c4-4a74-a918-c40f835bb138)
attachments/assets/bb18bb70-58c3-4d2c-93ab-82f5a8302f08)
![WhatsApp Image 2025-04-08 at 9 00 23 AM (1)](https://github.com/user-attachments/assets/d74cd34f-aca5-4e75-aba0-2c8de21aa95c)
![WhatsApp Image 2025-04-08 at 9 00 24 AM (2)](https://github.com/user-![WhatsApp Image 2025-04-08 at 9 00 23 AM](https://github.com/user-attachments/assets/f311f34a-72d5-4df5-a502-8fd952fba535)
attachments/assets/68dac53d-0c2d-4842-a51a-c33fdeddd492)

---
