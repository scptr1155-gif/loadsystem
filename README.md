# loadsystem

Roblox loader sistemi. Tek bağlantı ile çalışır:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/scptr1155-gif/loadsystem/refs/heads/main/verify"))()
```

## Akış

1. Tüm ekran siyah olur, ortada **LOADING** yazar.
2. `verify-gui` indirilip çalıştırılır → ortada beyaz panel belirir.
3. Beyaz panel açılınca siyah ekran animasyonla kaybolur.
4. Beyaz panelde **LOGIN** ve **CREATE ACCOUNT** butonları çıkar.
5. **CREATE ACCOUNT** → forma geçilir, oyuncunun adı otomatik dolar; takma ad ve şifre istenir.
   Kayıt, GitHub'daki `player` dosyasına otomatik yazılır.
6. Giriş başarılı olunca: beyaz panel kapanır → siyah perde açılır → `main-menu` çalışır →
   main-menu hazır olduğu doğrulanınca siyah perde kalkar.

## Dosyalar

| Dosya | Görev |
|---|---|
| `verify` | Ana giriş noktası: HTTP, GitHub API, şifreleme, akış kontrolü |
| `verify-gui` | Arayüz modülü: beyaz panel, login/kayıt formları, animasyonlar |
| `main-menu` | Ana menü (giriş sonrası çalışır) |
| `player` | Oyuncu listesi — her satır bir hesap |

## `player` dosyası formatı

Her satır bir oyuncudur:

```
player:OYUNCU_ADI/playert:TAKMA_AD/password:SIFRE
```

- Parantez, `/` ve boşluk kullanılmaz.
- Yeni kayıtlar bu dosyaya otomatik eklenir.
- Satırın tamamı `player:` ile başlamalı, yoksa yok sayılır.

## Notlar

- `verify` içindeki GitHub PAT şifrelenmiş olarak durur (`CIPHER` bloğu).
  Yeni PAT almak için: `python3 tools/cipher.py --pat <PAT> --patch src/verify`
- Luau'da native bitwise operatör (`&`, `|`, `~`, `<<`, `>>`) **yoktur**; şifreleme
  katmanı `bit32`/saf Lua ile yazılmıştır.
