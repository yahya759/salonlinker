# 💈 Barbershop Booking System (MVP)

## 📌 Project Idea

This project is a minimal viable product (MVP) for a smart barbershop booking system.

Customers book appointments via WhatsApp, and the barber manages all bookings through a Flutter dashboard.

The system is powered by:
- n8n (automation layer)
- Supabase (backend database)
- Flutter (admin dashboard)

---

## 🎯 Problem

Traditional barbershops face:
- Manual booking systems
- Phone-based reservations
- Scheduling confusion
- Double bookings

---

## 💡 Solution

A fully automated booking system where:

- Customers interact via WhatsApp
- They view haircut styles with images
- They select a haircut and book a time
- All data is automatically stored
- The barber manages everything in a Flutter dashboard

---

## ⚙️ Core Architecture

### 1. WhatsApp Bot (n8n)
- Sends haircut styles with images
- Handles user conversation flow
- Collects booking data
- Sends confirmation messages

### 2. Backend (Supabase)
- Stores services (haircuts)
- Stores bookings
- Manages session state

### 3. Flutter Admin App
- Displays bookings in real-time
- Clean and simple dashboard for barber management

---

## 📱 Flutter Architecture (IMPORTANT)

This project MUST follow clean architecture principles:

### 🧱 Architecture Pattern:
- MVVM (Model - View - ViewModel)
- State Management: Cubit (Bloc)

---

## 📂 Project Structure (Flutter)
