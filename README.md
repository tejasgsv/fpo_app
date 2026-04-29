# FPO Digital Platform

This Flutter app is a B2B FPO networking platform with a green agriculture theme, role-aware access, and an in-memory mock service layer that is ready to swap for APIs later.

## Current System Flow

Registration -> Admin Approval -> FPO Activation -> FPO Dashboard -> Farmer Management / Contributor Management / Marketplace / Communication / Inventory / Reports

## What is included

- Role-aware login
- 4-step FPO registration flow
- Super Admin control panel
- FPO approval, activation, suspension, rejection, and correction review
- FPO dashboard with operational modules
- Farmer management
- Contributor management with role and permission controls
- Marketplace without prices or payments
- Chat and communication screens
- Analytics and moderation screens
- Placeholder inventory and reports modules

## Product Rules

- No price fields anywhere in the marketplace
- No payment flow
- Use contact, request, and chat for collaboration
- Keep all data access behind service interfaces

## Navigation Flow

Login -> Admin Dashboard or FPO Access Status or FPO Dashboard

Admin users can open:

- FPO Control
- Marketplace Control
- Communication Control
- Analytics

FPO users can open:

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

## Architecture Notes

- [lib/core/state/platform_store.dart](lib/core/state/platform_store.dart) holds the shared in-memory platform data for FPO approvals, activations, and moderated listings.
- [lib/core/di/app_services.dart](lib/core/di/app_services.dart) wires the shared services together.
- [lib/core/navigation/app_router.dart](lib/core/navigation/app_router.dart) resolves the role-based route tree.
- [lib/features/auth/services/auth_service.dart](lib/features/auth/services/auth_service.dart) returns a role-aware session.
- [lib/features/auth/services/registration_service.dart](lib/features/auth/services/registration_service.dart) writes new FPO registrations into the shared store.
- [lib/features/admin/services/admin_service.dart](lib/features/admin/services/admin_service.dart) exposes the approval and moderation workflow.

## File-by-File Overview

### Core

- [lib/core/constants/app_routes.dart](lib/core/constants/app_routes.dart) defines all route names
- [lib/core/constants/app_strings.dart](lib/core/constants/app_strings.dart) contains shared UI strings
- [lib/core/di/app_services.dart](lib/core/di/app_services.dart) wires the mock services together
- [lib/core/navigation/app_router.dart](lib/core/navigation/app_router.dart) maps routes to screens
- [lib/core/state/platform_store.dart](lib/core/state/platform_store.dart) stores the shared platform state
- [lib/core/theme/app_theme.dart](lib/core/theme/app_theme.dart) and [lib/core/theme/app_colors.dart](lib/core/theme/app_colors.dart) define the visual system

### Admin

- [lib/features/admin/screens/admin_dashboard_screen.dart](lib/features/admin/screens/admin_dashboard_screen.dart) is the super admin control center
- [lib/features/admin/screens/admin_farmer_data_screen.dart](lib/features/admin/screens/admin_farmer_data_screen.dart) lists farmer data across FPOs
- [lib/features/admin/screens/admin_contributor_control_screen.dart](lib/features/admin/screens/admin_contributor_control_screen.dart) monitors contributor roles and permissions
- [lib/features/admin/screens/admin_fpo_management_screen.dart](lib/features/admin/screens/admin_fpo_management_screen.dart) manages FPO registrations and activation
- [lib/features/admin/screens/admin_marketplace_control_screen.dart](lib/features/admin/screens/admin_marketplace_control_screen.dart) moderates listings
- [lib/features/admin/screens/admin_chat_monitoring_screen.dart](lib/features/admin/screens/admin_chat_monitoring_screen.dart) monitors conversations
- [lib/features/admin/screens/admin_analytics_screen.dart](lib/features/admin/screens/admin_analytics_screen.dart) shows operational metrics
- [lib/features/admin/services/admin_service.dart](lib/features/admin/services/admin_service.dart) contains the admin workflow logic

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
- [lib/features/marketplace/models/product_listing.dart](lib/features/marketplace/models/product_listing.dart) defines listing data models and moderation status
- [lib/features/marketplace/services/marketplace_service.dart](lib/features/marketplace/services/marketplace_service.dart) contains the mock marketplace API

### Chat

- [lib/features/chat/screens/chat_list_screen.dart](lib/features/chat/screens/chat_list_screen.dart) shows conversations
- [lib/features/chat/screens/conversation_screen.dart](lib/features/chat/screens/conversation_screen.dart) shows the chat thread view
- [lib/features/chat/models/chat_models.dart](lib/features/chat/models/chat_models.dart) defines chat thread and message models
- [lib/features/chat/services/chat_service.dart](lib/features/chat/services/chat_service.dart) contains the mock chat API

### Existing Auth Flow

- [lib/features/auth/screens/login_screen.dart](lib/features/auth/screens/login_screen.dart) routes users based on role and approval state
- [lib/features/auth/screens/access_status_screen.dart](lib/features/auth/screens/access_status_screen.dart) shows pending, approved, suspended, rejected, or correction states
- [lib/features/auth/screens/fpo_registration_flow_screen.dart](lib/features/auth/screens/fpo_registration_flow_screen.dart) contains the registration flow
- [lib/features/auth/screens/success_screen.dart](lib/features/auth/screens/success_screen.dart) shows registration completion

## Mock Data Strategy

The app uses in-memory mock services so the UI stays API-ready without hardcoding business logic into screens. Replace the service implementations in the feature folders when real endpoints are available.

## Run

```bash
flutter run -d chrome
```

## GitHub Repo

https://github.com/tejasgsv/fpo_app
