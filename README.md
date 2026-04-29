# FPO Digital Platform

This Flutter app is an FPO-to-FPO operational platform with a clean green agriculture theme, API-ready services, and a modular architecture.

## What is included

- Authentication flow with login
- 4-step FPO registration flow
- FPO dashboard as the main post-login entry point
- Farmer management
- Contributor management with role and permission controls
- Marketplace without prices or payments
- Chat and communication screens
- Placeholder inventory and reports modules

## Product Rules

- No price fields anywhere in the marketplace
- No payment flow
- Use contact, request, and chat for collaboration
- Keep all data access behind service interfaces

## Navigation Flow

Login -> FPO Dashboard -> Modules

From the dashboard, users can open:

- Farmer Management
- Contributor Management
- Marketplace
- Communication
- Inventory placeholder
- Reports placeholder

Marketplace actions use direct collaboration only:

- Contact FPO
- Send Request
- Chat

## File-by-File Overview

### Core

- [lib/core/constants/app_routes.dart](lib/core/constants/app_routes.dart) defines all route names
- [lib/core/constants/app_strings.dart](lib/core/constants/app_strings.dart) contains shared UI strings
- [lib/core/di/app_services.dart](lib/core/di/app_services.dart) wires the mock services together
- [lib/core/navigation/app_router.dart](lib/core/navigation/app_router.dart) maps routes to screens
- [lib/core/theme/app_theme.dart](lib/core/theme/app_theme.dart) and [lib/core/theme/app_colors.dart](lib/core/theme/app_colors.dart) define the visual system

### Dashboard

- [lib/features/fpo_dashboard/screens/dashboard_screen.dart](lib/features/fpo_dashboard/screens/dashboard_screen.dart) is the operational dashboard
- [lib/features/fpo_dashboard/screens/farmer_management_screen.dart](lib/features/fpo_dashboard/screens/farmer_management_screen.dart) manages farmer records
- [lib/features/fpo_dashboard/screens/farmer_profile_screen.dart](lib/features/fpo_dashboard/screens/farmer_profile_screen.dart) shows farmer details
- [lib/features/fpo_dashboard/screens/module_placeholder_screen.dart](lib/features/fpo_dashboard/screens/module_placeholder_screen.dart) handles inventory and reports placeholders
- [lib/features/fpo_dashboard/models/farmer.dart](lib/features/fpo_dashboard/models/farmer.dart) defines farmer data models
- [lib/features/fpo_dashboard/services/farmer_service.dart](lib/features/fpo_dashboard/services/farmer_service.dart) contains the mock farmer API

### Contributors

- [lib/features/contributors/screens/contributor_management_screen.dart](lib/features/contributors/screens/contributor_management_screen.dart) manages sub-users and permissions
- [lib/features/contributors/models/contributor.dart](lib/features/contributors/models/contributor.dart) defines contributor and permission models
- [lib/features/contributors/services/contributor_service.dart](lib/features/contributors/services/contributor_service.dart) contains the mock contributor API

### Marketplace

- [lib/features/marketplace/screens/marketplace_screen.dart](lib/features/marketplace/screens/marketplace_screen.dart) shows crop listings without prices
- [lib/features/marketplace/screens/add_product_screen.dart](lib/features/marketplace/screens/add_product_screen.dart) adds a new crop listing
- [lib/features/marketplace/models/product_listing.dart](lib/features/marketplace/models/product_listing.dart) defines listing data models
- [lib/features/marketplace/services/marketplace_service.dart](lib/features/marketplace/services/marketplace_service.dart) contains the mock marketplace API

### Chat

- [lib/features/chat/screens/chat_list_screen.dart](lib/features/chat/screens/chat_list_screen.dart) shows conversations
- [lib/features/chat/screens/conversation_screen.dart](lib/features/chat/screens/conversation_screen.dart) shows the chat thread view
- [lib/features/chat/models/chat_models.dart](lib/features/chat/models/chat_models.dart) defines chat thread and message models
- [lib/features/chat/services/chat_service.dart](lib/features/chat/services/chat_service.dart) contains the mock chat API

### Existing Auth Flow

- [lib/features/auth/screens/login_screen.dart](lib/features/auth/screens/login_screen.dart) remains the entry screen
- [lib/features/auth/screens/fpo_registration_flow_screen.dart](lib/features/auth/screens/fpo_registration_flow_screen.dart) contains the registration flow
- [lib/features/auth/screens/success_screen.dart](lib/features/auth/screens/success_screen.dart) shows registration completion

## Mock Data Strategy

The app uses in-memory mock services to keep the UI API-ready without hardcoding business logic into screens. Replace the mock service implementations in the feature service folders when real endpoints are available.

## Run

```bash
flutter run -d chrome
```