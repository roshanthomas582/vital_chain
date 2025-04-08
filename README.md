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

- **User Side**
![user1](https://github.com/user-attachments/assets/04adb6a4-3e22-479a-a6cf-d5b37f6c385f)
![user2](https://github.com/user-attachments/assets/e7d431d9-cdb2-4f97-9f3b-2d32029b8073)
![user3](https://github.com/user-attachments/assets/f42e29ac-15ec-47cd-b065-2c77291b3860)
![user4](https://github.com/user-attachments/assets/e406bfe4-2d6b-4ff5-bfd8-a5af93e93dc4)
![user5](https://github.com/user-attachments/assets/885b8c47-438c-4c20-8750-95da2a681c4b)
![user6](https://github.com/user-attachments/assets/21a5efc8-52cc-490c-8aae-407684901b82)
![user7](https://github.com/user-attachments/assets/140ce239-00d3-43ae-b7a3-cd7cb55ae1af)
![user8](https://github.com/user-attachments/assets/d3c73303-0c23-4775-a3a3-4e7a946c50a1)
![user18](https://github.com/user-attachments/assets/3fa03699-3d37-4eae-a7e1-9fef3c039594)
![user9](https://github.com/user-attachments/assets/80a2473b-5c25-4939-9be6-9135833d7d00)
![user10](https://github.com/user-attachments/assets/a70f71d4-eb4f-4b02-95df-4be626195554)
![user11](https://github.com/user-attachments/assets/b3f7b297-6279-4f27-8b06-b736a6e7c6b1)
![user12](https://github.com/user-attachments/assets/c89abf14-fbd7-49a3-8955-bc9ecbcec2bf)
![user13](https://github.com/user-attachments/assets/cd3b2576-70d5-42bb-8897-a0d20d0259d2)
![user14](https://github.com/user-attachments/assets/fe5ae686-943a-45ff-9555-d12744f18f8c)
![user15](https://github.com/user-attachments/assets/2cccb499-9d90-4b51-981b-41b83e6bd32f)
![user16](https://github.com/user-attachments/assets/dd293e01-d948-4c85-8446-253fefbc753a)
![user17](https://github.com/user-attachments/assets/166b4798-29fe-4781-983a-5a77994f62c8)
![user19](https://github.com/user-attachments/assets/81e26220-358c-4010-9eda-e02c05040656)
![user20](https://github.com/user-attachments/assets/81c34432-07f9-4b74-9403-8e90916c7f92)
![user21](https://github.com/user-attachments/assets/b1e9a19c-5602-4cd7-8f4c-e10f14c6ee39)
![user22](https://github.com/user-attachments/assets/85f09feb-9162-4bc7-82f2-fe9612cdfc6d)

- **Doctor Side**
![doc1](https://github.com/user-attachments/assets/a4a46a98-9cb8-44ce-b0d2-4fd0f6cfafa6)
![doc2](https://github.com/user-attachments/assets/46817507-1fa3-40b8-9f71-1308f252e752)
![doc3](https://github.com/user-attachments/assets/d573f3eb-68d8-4c82-9809-75e69ac8aec0)
![doc4](https://github.com/user-attachments/assets/8faf3938-8831-4057-8187-22f5637906a3)
![doc5](https://github.com/user-attachments/assets/da45ba75-02ee-450c-b872-a85f964b2dd3)
![doc6](https://github.com/user-attachments/assets/faa39bab-cdbd-49e4-baba-b2145e21b7df)
![doc7](https://github.com/user-attachments/assets/734c88f8-8c95-4652-9346-ac99702639b3)
![doc8](https://github.com/user-attachments/assets/183ac6c5-d884-45ec-902f-4bef64393f6a)
![doc9](https://github.com/user-attachments/assets/f55c881d-fd0d-48d6-84bb-5bc72d02ce01)
![doc10](https://github.com/user-attachments/assets/4b9e15c6-0783-4f9e-8939-b4987ae47214)
![doc11](https://github.com/user-attachments/assets/09c4fdac-539b-44b9-bade-faa6642db818)
![doc12](https://github.com/user-attachments/assets/90811569-6c40-43b8-a1c3-2ba7d41479a8)
![doc13](https://github.com/user-attachments/assets/036ab865-643e-4c66-84b2-f15c220e8e6d)
![doc14](https://github.com/user-attachments/assets/4c7163d1-2c4a-432f-9a97-c660d196ce9a)
![doc15](https://github.com/user-attachments/assets/96c4f056-86bb-4ab3-aebf-0677af24ebb5)
![doc16](https://github.com/user-attachments/assets/40014e59-1754-489b-baf8-44fe75ec868b)
---
