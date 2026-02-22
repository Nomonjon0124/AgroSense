# 🌾 AgroSense Offline

[![Flutter Version](https://img.shields.io/badge/Flutter-3.24.0+-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.5.0+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**Offline-first agrometeorologik monitoring mobil ilovasi**

---

## 📋 Mundarija

- [Loyiha haqida](#-loyiha-haqida)
- [Asosiy xususiyatlar](#-asosiy-xususiyatlar)
- [Screenshot'lar](#-screenshotlar)
- [Texnologik stek](#-texnologik-stek)
- [Arxitektura](#-arxitektura)
- [O'rnatish](#-ornatish)
- [Loyihani ishga tushirish](#-loyihani-ishga-tushirish)
- [Loyiha tuzilmasi](#-loyiha-tuzilmasi)
- [Offline-first arxitektura](#-offline-first-arxitektura)
- [Testing](#-testing)
- [Deployment](#-deployment)
- [Hissa qo'shish](#-hissa-qoshish)
- [Litsenziya](#-litsenziya)
- [Muallif](#-muallif)

---

## 🌟 Loyiha haqida

**AgroSense Offline** - bu qishloq xo'jaligi mutaxassislari, fermer xo'jaliklari va agronomlar uchun mo'ljallangan zamonaviy mobil ilova bo'lib, dalalarning ob-havo sharoitlarini monitoring qilish, agrometeorologik ma'lumotlarni yig'ish va tahlil qilish imkonini beradi.

### 🎯 Maqsad

Loyihaning asosiy maqsadi - internet aloqasi cheklangan yoki mavjud bo'lmagan qishloq joylarda ham to'liq funksional ishlash imkoniyatini beruvchi **offline-first** arxitektura asosida qurilgan professional agrometeorologik monitoring tizimini yaratish.

### 🎓 Bitiruv malakaviy ishi

Bu loyiha **Toshkent Axborot Texnologiyalari Universiteti** (TATU) Dasturiy injiniring fakulteti 4-kurs talabasi tomonidan bajarilgan bitiruv malakaviy ishi hisoblanadi.

**Mavzu:** "Offline-first" prinsipida ishlovchi agrometeorologik monitoring mobil ilovasini ishlab chiqish

---

## ✨ Asosiy xususiyatlar

### 📊 Dashboard
- **Real-time ob-havo ma'lumotlari**: Joriy harorat, namlik, shamol tezligi, yog'ingarchilik
- **7 kunlik prognoz**: Kunlik ob-havo prognozi vizual ko'rinishda
- **Dala holati monitoring**: Barcha dalalarning real-time holati va ko'rsatkichlari
- **Quick insights**: Tez ma'lumotlar va statistika

### 🗺️ Interaktiv xarita
- **Offline xarita qo'llab-quvvatlash**: Internet yo'qligida ham to'liq funksional
- **Dalalar vizualizatsiyasi**: Har bir dalaning geografik chegaralari va holati
- **Geolokatsiya**: GPS orqali joriy pozitsiya
- **Dala tanlash**: Xaritadan dalani tanlash va batafsil ma'lumotlar olish
- **Layer control**: Turli qatlamlarni yoqish/o'chirish

### 🚨 Ogohlantirishlar tizimi
- **Frost Warning**: Sovuq tushish xavfi haqida ogohlantirish
- **Heavy Rain**: Kuchli yomg'ir prognozi
- **Wind Gusts**: Kuchli shamol ogohlantirish
- **Drought Warning**: Qurg'oqchilik xavfi
- **Disease Risk**: O'simlik kasalliklari xavfi
- **Filtrlash**: All / Critical / Warning filtrlari
- **Real-time notifications**: Push bildirishnomalar

### ⚙️ Sozlamalar
- **Ko'p tillilik**: 🇬🇧 English, 🇷🇺 Russian, 🇺🇿 Uzbek
- **Offline ma'lumotlar menejeri**: Lokal xotira boshqaruvi, kesh tozalash
- **Auto-sync**: Wi-Fi orqali avtomatik sinxronizatsiya
- **Dark mode**: Tungi rejim
- **Bildirishnomalar sozlamalari**: Push notifications boshqaruvi

### 🔄 Offline-first imkoniyatlari
- ✅ Internet yo'qligida to'liq ishlash
- ✅ Lokal ma'lumotlar bazasi
- ✅ Avtomatik sinxronizatsiya (internet mavjud bo'lganda)
- ✅ Conflict resolution
- ✅ Ma'lumotlar navbati tizimi

---

## 📱 Screenshot'lar

> **Eslatma**: Screenshot'lar Figma dizaynidan olingan

<table>
  <tr>
    <td align="center">
      <img src="docs/screenshots/dashboard.png" alt="Dashboard" width="200"/>
      <br />
      <b>Dashboard</b>
    </td>
    <td align="center">
      <img src="docs/screenshots/map.png" alt="Map" width="200"/>
      <br />
      <b>Xarita</b>
    </td>
    <td align="center">
      <img src="docs/screenshots/alerts.png" alt="Alerts" width="200"/>
      <br />
      <b>Ogohlantirishlar</b>
    </td>
    <td align="center">
      <img src="docs/screenshots/settings.png" alt="Settings" width="200"/>
      <br />
      <b>Sozlamalar</b>
    </td>
  </tr>
</table>

---

## 🛠️ Texnologik stek

### Frontend
- **Framework**: Flutter 3.24.0+
- **Language**: Dart 3.5.0+
- **State Management**: Riverpod 2.5.0+
- **Architecture**: Clean Architecture + Feature-first

### Database & Storage
- **Local Database**: Drift (SQLite wrapper)
- **Key-Value Storage**: Hive
- **Caching**: Flutter Cache Manager

### Mapping & Location
- **Map**: flutter_map + OpenStreetMap
- **Geolocation**: geolocator
- **Offline Maps**: flutter_map_tile_caching

### Charts & Visualization
- **Charts**: fl_chart
- **Weather Icons**: weather_icons

### Network & API
- **HTTP Client**: dio
- **Connectivity**: connectivity_plus
- **JSON Serialization**: json_serializable + freezed

### Code Generation
- **freezed**: Immutable models
- **json_serializable**: JSON serialization
- **build_runner**: Code generation

### Additional
- **Localization**: flutter_localizations + intl
- **Environment Config**: flutter_dotenv
- **Logging**: logger

---

## 🏗️ Arxitektura

Loyiha **Clean Architecture** va **Feature-first** prinsiplariga asoslangan.

### Clean Architecture qatlamlari

```
┌─────────────────────────────────────┐
│     Presentation Layer              │
│  (UI, Widgets, State Management)    │
├─────────────────────────────────────┤
│     Domain Layer                    │
│  (Business Logic, Use Cases)        │
├─────────────────────────────────────┤
│     Data Layer                      │
│  (Repositories, Data Sources)       │
└─────────────────────────────────────┘
```

### Dependency Flow

```
Presentation → Domain → Data
     ↑           ↑        ↑
     └───────────┴────────┘
   (Dependencies point inward)
```

---

## 📁 Loyiha tuzilmasi

```
lib/
├── core/                           # Core utilities va shared kod
│   ├── constants/                  # Constants
│   │   ├── app_constants.dart
│   │   ├── api_constants.dart
│   │   └── storage_keys.dart
│   ├── theme/                      # App tema
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   └── app_text_styles.dart
│   ├── utils/                      # Utility funksiyalar
│   │   ├── date_utils.dart
│   │   ├── validation_utils.dart
│   │   └── format_utils.dart
│   ├── network/                    # Network sozlamalari
│   │   ├── dio_client.dart
│   │   ├── api_interceptor.dart
│   │   └── network_info.dart
│   ├── error/                      # Error handling
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   └── localization/               # Localization
│       ├── app_localizations.dart
│       └── l10n/
│           ├── app_en.arb
│           ├── app_ru.arb
│           └── app_uz.arb
│
├── features/                       # Feature modules
│   ├── dashboard/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── weather_local_datasource.dart
│   │   │   │   └── weather_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── weather_model.dart
│   │   │   │   └── forecast_model.dart
│   │   │   └── repositories/
│   │   │       └── weather_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── weather.dart
│   │   │   │   └── forecast.dart
│   │   │   ├── repositories/
│   │   │   │   └── weather_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_current_weather.dart
│   │   │       └── get_forecast.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── weather_provider.dart
│   │       ├── widgets/
│   │       │   ├── weather_card.dart
│   │       │   ├── forecast_list.dart
│   │       │   └── field_status_card.dart
│   │       └── pages/
│   │           └── dashboard_page.dart
│   │
│   ├── map/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── alerts/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── settings/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── auth/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── shared/                         # Shared widgets va utilities
│   ├── widgets/
│   │   ├── custom_app_bar.dart
│   │   ├── loading_indicator.dart
│   │   ├── error_view.dart
│   │   └── custom_button.dart
│   └── providers/
│       └── theme_provider.dart
│
└── main.dart                       # Entry point
```

---

## 🔄 Offline-first arxitektura

### Asosiy prinsiplar

1. **Local-first**: Barcha amallar avval lokal bazada
2. **Sync when available**: Internet bo'lganda sinxronizatsiya
3. **Conflict resolution**: To'qnashuvlarni hal qilish
4. **Queue management**: Offline amallar navbati

### Ma'lumotlar oqimi

```
┌──────────────┐
│   UI Layer   │
└──────┬───────┘
       │
       ↓
┌──────────────┐      ┌─────────────┐
│  Use Cases   │──────→│  Local DB   │
└──────┬───────┘      └─────────────┘
       │                     ↑
       ↓                     │
┌──────────────┐            │
│ Repositories │────────────┘
└──────┬───────┘
       │
       ↓
┌──────────────┐      ┌─────────────┐
│ Data Sources │──────→│  Remote API │
└──────────────┘      └─────────────┘
         ↑                   │
         │                   │
         └───────────────────┘
              (Sync queue)
```

## 📞 Aloqa

Savollar yoki takliflar bo'lsa, bog'laning:

- 📧 Email: nomonojont@gmail.com
- 💬 Telegram: [@nomonjon_toychiyev](https://t.me/nomonjon_toychiyev)
- 🐛 Issue: [GitHub Issues](https://github.com/Nomonjon0124/AgroSense)

---
