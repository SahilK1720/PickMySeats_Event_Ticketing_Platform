<div align="center">

# 🎟️ PickMySeats

### A production-grade event ticketing platform with real-time seat selection, cryptographic QR validation, Razorpay payments, and role-based organizer tooling.

[![Angular](https://img.shields.io/badge/Angular-21-dd0031?logo=angular)](https://angular.dev)
[![Rust](https://img.shields.io/badge/Rust-Axum-f74c00?logo=rust)](https://github.com/tokio-rs/axum)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791?logo=postgresql)](https://www.postgresql.org)
[![Redis](https://img.shields.io/badge/Redis-7-dc382d?logo=redis)](https://redis.io)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker)](https://docs.docker.com/compose)

</div>

---

## What Is PickMySeats?

PickMySeats is a full-stack event ticketing platform built for real-world event scenarios. It handles the complete ticket lifecycle — from event discovery and seat selection, through Razorpay payment, to on-ground QR scanning by staff at entry gates.

The backend is written in Rust for performance and safety. The frontend uses Angular 21 with a polished glass-morphism design system.

---

## ✨ Features

**For Attendees**
- Browse events with city filtering, live-text search, and availability indicators
- Two booking modes: standard quantity selection or interactive seat-map with explicit seat picking
- Razorpay-integrated checkout with live payment verification
- Ticket cancellation with automatic refund processing (policy-aware: 24hr cutoff)
- Peer-to-peer ticket transfer (supports pre-registration transfers)
- View all tickets with event details, seat labels, and QR codes

**For Organizers**
- Full event CRUD with multi-image upload, Google Maps integration, gate/end timing
- Live Sales Analytics dashboard (revenue breakdown, VIP vs standard, occupancy %)
- Staff management — add/revoke scanner access via time-limited access tokens
- Bank payout details management
- Event cancellation with full attendee refund orchestration

**For Staff / Scanners**
- Tokenized scanner URLs — no login required, access controlled by organizer
- ZXing-powered in-browser camera QR scanning
- Server-side ticket validation with HMAC signature verification
- Scan history per staff member, viewable by organizers

**Platform Infrastructure**
- HMAC-SHA256 signed QR payloads — cryptographically tamper-proof
- Redis-backed sliding window rate limiting on purchase endpoints
- Async background jobs: auto-expire seat locks (30s) and ticket holds (60s)
- PostgreSQL transactions for all multi-step booking operations
- Docker Compose for one-command local setup

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| **Frontend** | Angular 21, Standalone Components, TypeScript, Vanilla CSS |
| **UI Effects** | ShinyText, TiltedCard, DecryptedText, ScanTixFocus animations |
| **Charts** | Chart.js |
| **QR Scanning** | ZXing Browser |
| **Backend** | Rust, Axum 0.7, Tokio (async runtime) |
| **Database** | PostgreSQL 16 via SQLx (type-safe queries + migrations) |
| **Cache** | Redis 7 (rate limiting, graceful fallback) |
| **Auth** | JWT (7-day tokens) + Argon2id password hashing |
| **Payments** | Razorpay (order creation + HMAC signature verification + refunds) |
| **Email** | Lettre (SMTP) |
| **DevOps** | Docker Compose, Nginx (frontend serving) |

---

## 📱 Screens & Modules

| Module | Description |
|---|---|
| **Event Listing** | Filterable event grid with city picker, live search, refund policy badges, and sold-out progress bars |
| **Event Detail** | 3D perspective carousel for multi-image events, full event metadata, seat map or quantity picker |
| **Seat Map** | Interactive grid/stadium layout — seats lock for 10 minutes while user checks out |
| **Payment Flow** | Razorpay Checkout modal → signature verification → ticket creation in a DB transaction |
| **My Tickets** | All tickets with QR codes, event details, seat labels, transfer history, and cancellation previews |
| **QR Scanner** | Tokenized public URL that opens a camera-based QR scanner; validates against the API |
| **Sales Analytics** | Live-polling organizer dashboard: gross sales, platform commission, net earnings, VIP/regular breakdown |
| **Staff Management** | Add staff with access tokens, view per-staff scan logs, revoke anytime |
| **Bank Details** | Organizer payout account management with account masking |

---

## 📂 Project Structure

```
PickMySeats/
├── backend/                    # Rust API (Axum)
│   ├── src/
│   │   ├── main.rs             # Server bootstrap, background jobs, CORS
│   │   ├── config.rs           # Environment variable loading
│   │   ├── error.rs            # Typed error → HTTP response mapping
│   │   ├── db.rs               # Database pool initialization & migrations
│   │   ├── handlers/           # One file per API domain
│   │   │   ├── auth.rs         # Register, login, /me
│   │   │   ├── events.rs       # Event CRUD, image upload, stats
│   │   │   ├── tickets.rs      # Purchase, hold, cancel, transfer, QR
│   │   │   ├── payment.rs      # Razorpay order + verification
│   │   │   ├── seats.rs        # Seat generation, locking, batch ops
│   │   │   ├── staff.rs        # Scanner tokens, scan validation
│   │   │   ├── analytics.rs    # SSE sales stream
│   │   │   └── bank_details.rs # Payout account management
│   │   ├── middleware/
│   │   │   ├── auth.rs         # JWT extraction → Claims injection
│   │   │   └── rate_limit.rs   # Redis sliding window (purchase route)
│   │   ├── models/             # SQLx FromRow structs
│   │   ├── routes/mod.rs       # Public / protected / purchase route groups
│   │   └── utils/
│   │       ├── jwt.rs          # Token creation + verification
│   │       ├── qr.rs           # HMAC-signed QR payload + PNG generation
│   │       └── email.rs        # SMTP email dispatch
│   ├── migrations/             # 26 sequential PostgreSQL migrations
│   ├── .env.example            # Environment variable template
│   └── Cargo.toml
│
├── frontend/                   # Angular 21 SPA
│   ├── src/app/
│   │   ├── core/
│   │   │   ├── services/       # auth, event, ticket, seat, payment, staff, analytics
│   │   │   ├── guards/         # authGuard, organizerGuard
│   │   │   └── interceptors/   # authInterceptor (JWT + 401 auto-logout)
│   │   ├── features/           # Page-level components (lazy-loaded)
│   │   │   ├── auth/           # Login, Register
│   │   │   ├── events/         # EventList, EventDetail, EventCreate, EventEdit, MyEvents
│   │   │   ├── analytics/      # SalesDashboard
│   │   │   ├── tickets/        # MyTickets
│   │   │   ├── scanner/        # QrScanner, ScannerPage
│   │   │   ├── staff/          # StaffManagement, StaffDashboard, StaffScans
│   │   │   └── organizer/      # BankDetails
│   │   └── shared/
│   │       ├── components/     # Navbar, ShinyText, TiltedCard, DecryptedText, ScanTixFocus, LightRays, Lanyard
│   │       ├── seat-map/       # Interactive seat selection component
│   │       ├── payment-modal/  # Razorpay checkout wrapper
│   │       └── image-cropper/  # Event image upload utility
│   └── src/styles.css          # Global design system (CSS variables, utilities)
│
├── docker-compose.yml          # Full stack: postgres + redis + backend + frontend
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites

- **Node.js** 18+ and npm 10+
- **Rust** (stable, via [rustup](https://rustup.rs))
- **PostgreSQL** 16+ 
- **Redis** 7+
- **Docker** (optional — for one-command setup)

---

### Option A — Docker Compose (Recommended)

```bash
git clone https://github.com/SahilK1720/PickMySeats_Event_Ticketing_Platform.git
cd PickMySeats_Event_Ticketing_Platform

# Set required secrets (Razorpay keys, SMTP)
cp backend/.env.example backend/.env
# Edit backend/.env with your real values

docker compose up --build
```

| Service | URL |
|---|---|
| Frontend | http://localhost:4200 |
| Backend API | http://localhost:8080 |
| API Health | http://localhost:8080/api/health |

---

### Option B — Local Manual Setup

**1. Clone**
```bash
git clone https://github.com/SahilK1720/PickMySeats_Event_Ticketing_Platform.git
cd PickMySeats_Event_Ticketing_Platform
```

**2. Backend**
```bash
cd backend
cp .env.example .env
# Fill in DATABASE_URL, JWT_SECRET, RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET

# Run migrations
cargo install sqlx-cli --no-default-features --features rustls,postgres
sqlx migrate run

# Start API server
cargo run
# → Listening on http://0.0.0.0:8080
```

**3. Frontend**
```bash
cd ../frontend
npm install
npm start
# → http://localhost:4200
```

---

## 📋 Available Scripts

### Backend (Rust / Cargo)
| Command | Description |
|---|---|
| `cargo run` | Start development server |
| `cargo build --release` | Production binary |
| `cargo test` | Run unit tests (includes QR signing tests) |
| `sqlx migrate run` | Apply pending migrations |
| `sqlx migrate revert` | Rollback last migration |

### Frontend (Angular CLI)
| Command | Description |
|---|---|
| `npm start` | Development server (localhost:4200) |
| `npm run build` | Production build (outputs to `dist/`) |
| `npm test` | Unit tests via Karma |
| `npm run watch` | Build in watch mode |

---

## 🔑 Environment Variables

See [`backend/.env.example`](backend/.env.example) for the full list with descriptions.

Required variables:
- `DATABASE_URL` — PostgreSQL connection string
- `JWT_SECRET` — Random secret for signing JWTs (use `openssl rand -base64 64`)
- `RAZORPAY_KEY_ID` — Razorpay API key
- `RAZORPAY_KEY_SECRET` — Razorpay API secret

---

## 🎨 Design & UX

- **Dark-first design** with a deep `#020202` background and glassmorphism card surfaces
- **Poppins** typeface throughout for clean, modern typography  
- **Gold/amber accent** (`#eab308`) gradient for primary CTAs and highlights
- **3D animated carousel** on event detail pages (CSS `perspective` + `rotateY` transitions)
- **TiltedCard** magnetic hover effect on event list  
- **ShinyText** sweeping highlight for FREE event badges and branding
- **Role-colored user badges** in the navbar (gold for organizer, violet for attendee)
- **Full mobile responsiveness** — hamburger menu, column-stack grids, scroll tables

---

## 🔮 Upcoming Improvements

- [ ] **GitHub Actions CI** — `cargo test` + `ng build` on every push
- [ ] **WebSocket seat broadcasts** — push seat status changes to all viewers in real time  
- [ ] **SSE integration in analytics** — consume the existing `GET /api/analytics/sales/:id` SSE stream instead of polling
- [ ] **OpenAPI / Swagger UI** — auto-generated API docs via `utoipa`
- [ ] **PWA + Service Worker** for scanner offline caching
- [ ] **Ticket PDF export** — downloadable event ticket
- [ ] **Multi-currency support** with regional tax layers

---

## 👤 Author

**Sahil** — [@SahilK1720](https://github.com/SahilK1720)

---

## 📄 License

This project is for portfolio and educational purposes.
