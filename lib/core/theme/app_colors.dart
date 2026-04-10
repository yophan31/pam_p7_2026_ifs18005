// lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

/* =========================
   BRAND COLORS (PLANET / SPACE THEME)
   ========================= */

/// Biru antariksa — warna utama
const Color kSpaceBlue = Color(0xFF1A237E);        // Biru gelap angkasa
const Color kSpaceBlueLight = Color(0xFF3949AB);   // Biru lebih terang
const Color kSpaceBlueDark = Color(0xFF0D1257);    // Biru sangat gelap

/// Ungu nebula — aksen sekunder
const Color kNebulaPurple = Color(0xFF7B1FA2);     // Ungu nebula
const Color kNebulaPurpleLight = Color(0xFFAB47BC); // Ungu lebih terang

/// Gold bintang — aksen tersier / highlight
const Color kStarGold = Color(0xFFFFB300);         // Kuning emas bintang
const Color kStarGoldSoft = Color(0xFFFFE082);     // Kuning emas lebih lembut

/* =========================
   LIGHT THEME (PLANET THEME)
   ========================= */
const Color kLightPrimary = kSpaceBlue;
const Color kLightOnPrimary = Colors.white;
const Color kLightPrimaryContainer = Color(0xFFBFC8FF); // Biru muda lembut
const Color kLightOnPrimaryContainer = Color(0xFF00105C);

const Color kLightSecondary = kNebulaPurple;
const Color kLightOnSecondary = Colors.white;
const Color kLightSecondaryContainer = Color(0xFFEDD9F7); // Ungu sangat muda
const Color kLightOnSecondaryContainer = Color(0xFF32004E);

const Color kLightTertiary = kStarGold;
const Color kLightOnTertiary = Color(0xFF2A1F00);

const Color kLightError = Color(0xFFBA1A1A);
const Color kLightOnError = Colors.white;
const Color kLightErrorContainer = Color(0xFFFFDAD6);
const Color kLightOnErrorContainer = Color(0xFF410002);

const Color kLightBackground = Color(0xFFF5F6FF); // Putih kebiruan sangat lembut
const Color kLightOnBackground = Color(0xFF0D0E1A);
const Color kLightSurface = Color(0xFFFAFAFF);    // Putih dengan sentuhan biru
const Color kLightOnSurface = Color(0xFF0D0E1A);
const Color kLightSurfaceVariant = Color(0xFFE1E3F5); // Abu-biru
const Color kLightOnSurfaceVariant = Color(0xFF44465A);
const Color kLightOutline = Color(0xFF74768A);

/* =========================
   DARK THEME (PLANET THEME)
   Dark theme → nuansa deep space: hitam legam + biru galaksi
   ========================= */
const Color kDarkPrimary = kSpaceBlueLight;        // Biru lebih terang agar kontras di dark
const Color kDarkOnPrimary = Colors.white;
const Color kDarkPrimaryContainer = Color(0xFF1A2480); // Biru gelap pekat
const Color kDarkOnPrimaryContainer = Color(0xFFBFC8FF);

const Color kDarkSecondary = kNebulaPurpleLight;
const Color kDarkOnSecondary = Colors.white;
const Color kDarkSecondaryContainer = Color(0xFF4A0070);
const Color kDarkOnSecondaryContainer = Color(0xFFEDD9F7);

const Color kDarkTertiary = kStarGold;
const Color kDarkOnTertiary = Color(0xFF2A1F00);

const Color kDarkError = Color(0xFFFFB4AB);
const Color kDarkOnError = Color(0xFF690005);
const Color kDarkErrorContainer = Color(0xFF93000A);
const Color kDarkOnErrorContainer = Color(0xFFFFDAD6);

const Color kDarkBackground = Color(0xFF06071A); // Hitam angkasa
const Color kDarkOnBackground = Color(0xFFE4E5F5);
const Color kDarkSurface = Color(0xFF0B0D24);    // Hitam sedikit kebiruan
const Color kDarkOnSurface = Color(0xFFE4E5F5);
const Color kDarkSurfaceVariant = Color(0xFF2A2D45); // Abu gelap kebiruan
const Color kDarkOnSurfaceVariant = Color(0xFFC5C6D8);
const Color kDarkOutline = Color(0xFF8E90A4);
