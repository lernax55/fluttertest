# Gelişmiş Hesap Makinesi Uygulaması

Bu Flutter tabanlı hesap makinesi uygulaması, temel matematiksel işlemlerin yanı sıra gelişmiş hesaplama özellikleri sunar.

## Özellikler

### Temel İşlemler
- Toplama (+)
- Çıkarma (-)
- Çarpma (×)
- Bölme (÷)
- Ondalıklı sayılar (.)

### Gelişmiş İşlemler
- Faktöriyel hesaplama (!)
- Karekök alma (√)
- Yüzde hesaplama (%)
- Üs alma (^)
- Parantezli işlemler ( (, ) )

### Diğer Özellikler
- Tüm girişi temizleme (AC)
- Son girişi silme (⌫)
- Sonuç gösterme (=)
- Negatif sayılar
- Otomatik hesaplama
- Hata kontrolü

## Kullanım Örnekleri

### Temel İşlemler
- Toplama: `123 + 456 = 579`
- Çıkarma: `500 - 123 = 377`
- Çarpma: `12 × 12 = 144`
- Bölme: `100 ÷ 4 = 25`

### Gelişmiş İşlemler
- Faktöriyel: `5! = 120`
- Karekök: `√16 = 4`
- Yüzde: `800% = 8`
- Üs alma: `2^3 = 8`
- Parantezli işlem: `(5+3)×2 = 16`

## Hata Kontrolü

Uygulama aşağıdaki durumlarda "Hata" mesajı gösterir:
- Negatif sayıların faktöriyeli
- Negatif sayıların karekökü
- Sıfıra bölme
- Geçersiz işlemler
- Sonsuz veya tanımsız sonuçlar

## Sınırlamalar

- Faktöriyel hesaplaması 0-20 arası sayılarla sınırlıdır
- Karekök hesaplaması negatif olmayan sayılarla sınırlıdır
- Üs alma işlemi tek bir üs ile sınırlıdır
- Yüzde işlemi tek bir sayı üzerinde çalışır

## Teknik Detaylar

### Kullanılan Paketler
- flutter/material.dart
- math_expressions
- dart:math

### Test Kapsamı
- UI Elemanları Testi
- Temel Matematik İşlemleri Testi
- Özel İşlemler Testi
- Hata Durumları Testi
- Silme ve Düzenleme Testi
- Parantezli İşlem Testi

## Kurulum

1. Flutter'ı yükleyin
2. Projeyi klonlayın
3. Bağımlılıkları yükleyin:
```bash
flutter pub get
```
4. Uygulamayı çalıştırın:
```bash
flutter run
```

## Test

Testleri çalıştırmak için:
```bash
flutter test
```

## Geliştirme

### Proje Yapısı
```
calculator_app/
├── lib/
│   └── main.dart
├── test/
│   └── widget_test.dart
└── pubspec.yaml
```

### Katkıda Bulunma
1. Fork yapın
2. Feature branch oluşturun
3. Değişikliklerinizi commit edin
4. Branch'inizi push edin
5. Pull request açın
