# CineBook - Movie Ticket UI (Flutter Web)

A movie ticket booking UI: browse movies, pick a date and showtime, choose seats, and get a ticket.
No backend and no extra packages are needed. Posters are drawn with gradients and icons, so there are no image files.

## Screens
1. **Home**: search box, genre filter chips, movie cards
2. **Details**: story, cast, 7-day date picker, showtime chips
3. **Seat selection**: 8 rows x 10 seats, Silver / Gold / Platinum prices, booked and selected seats, live total
4. **Ticket**: ticket-style card with notches, booking ID and a decorative QR pattern

## Run locally
```bash
flutter create . --platforms web      # adds the web/ folder (does not overwrite lib/ or pubspec.yaml)
flutter pub get
flutter run -d chrome
```

## Deploy to GitHub Pages
1. Run `flutter create . --platforms web`, then commit everything (including `web/`) and push to `main`.
2. In the repository: Settings -> Pages -> Source -> **GitHub Actions**.
3. The workflow in `.github/workflows/deploy.yml` builds and publishes automatically.
4. Live URL: `https://<your-username>.github.io/<repo-name>/`

## Deploy to Vercel
```bash
flutter build web --release
cd build/web
vercel --prod
```
