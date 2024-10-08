# krishi_setu

# Assured Contract Farming System for Stable Market Access

## Introduction
The **Assured Contract Farming System** is a software platform designed to mitigate market access uncertainties faced by farmers and provide stable income through secure contract farming. By connecting farmers and buyers (contractors), the system fosters transparent communication, ensures reliable payments, and facilitates efficient contract management. This project empowers farmers with stable market access and predictable income while reducing risks and uncertainties in the agricultural value chain.

## Problem Statement
Farmers often face fluctuating incomes and unpredictable market conditions, making it difficult to sustain a stable livelihood. Contract farming offers a solution by guaranteeing farmers a buyer for their crops. However, traditional contract farming lacks transparency, leading to issues with trust and payment security. The **Assured Contract Farming System** aims to solve this problem by offering an online platform for transparent contract management, secure payments, and real-time monitoring of crop health.

## Key Features
The application provides the following modules for both farmers and contractors:

### 1. User Role Selection
- Users can select their role as either a **Farmer** or a **Contractor** when first accessing the platform. This leads to tailored dashboards and features for each role.

### 2. Authentication System
- A secure login and signup system for both **Farmers** and **Contractors** with role-based access to various features.

### 3. Farmer Dashboard
- **Home**: Overview of active contracts, updates on negotiations, and contract status.
- **Community**: (Farmers only) A section for farmers to interact with regional farmers, share knowledge, and seek advice.
- **Marketplace**: Farmers can search for contractors based on contract requirements, and contractors can find suitable farmers.
- **Mandi System**: Farmers can list and sell their farm produce directly to buyers through the online mandi system.
- **Profile Management**: Farmers can update their profile, add farm details, and view contract history.

### 4. Contractor Dashboard
- **Home**: Overview of active contracts and contractor-specific updates.
- **Marketplace**: Contractors can search for farmers based on crops and region to establish contract agreements.
- **Mandi System**: Similar to farmers, contractors can browse available produce and manage their purchases.
- **Profile Management**: Contractors can update their profile and specify their contract preferences, such as crop types and contract terms.

### 5. Contract Management
- **Smart Contracts**: Blockchain-based smart contracts to ensure transparency and tamper-proof agreements between farmers and contractors.
- **Price Negotiation**: Automated or manual negotiation options for determining fair crop prices.

### 6. Payment Gateway
- **Secure Payment Processing**: A blockchain-backed secure payment system to ensure safe and traceable transactions between farmers and contractors.

### 7. Geo-Mapping & Farm Verification
- **Farm Land Verification**: Uses geo-mapping and satellite data to verify farm locations and sizes, ensuring authenticity and transparency in the contract.

### 8. Bi-Weekly Crop Monitoring
- **AI-Powered Monitoring**: Farmers can upload geo-tagged images of their crops, and AI algorithms analyze these images for crop health updates, which are shared with contractors.

### 9. Soil Fertility Testing
- **IoT-Based Testing**: Regular soil fertility reports are provided using IoT devices, ensuring better crop health management.

## Modules Overview
- **Farmer Side**:
    - Home
    - Community
    - Marketplace
    - Mandi System
    - Profile Management
    - Payment Gateway
    - Contract Management
    - Geo-Mapping
    - Bi-Weekly Crop Monitoring
    - Soil Fertility Testing

- **Contractor Side**:
    - Home
    - Marketplace
    - Mandi System
    - Profile Management
    - Payment Gateway
    - Contract Management
    - Geo-Mapping

## Technology Stack
- **Frontend**: Flutter (Dart)
- **Backend**: Spring Boot (Java)
- **Database**: MongoDB
- **Blockchain**: Ethereum Smart Contracts
- **Payment Gateway**: Custom implementation using blockchain for secure transactions
- **Geo-Mapping**: Google Maps API, Geo-tagging
- **AI & ML**: TensorFlow for crop health analysis
- **IoT Integration**: Soil fertility monitoring with IoT sensors

## Getting Started
To get started with the project, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repository-url.git
