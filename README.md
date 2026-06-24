# SubTrack GH 📋

A subscription tracker built for Ghana — supports GHS & foreign currencies, MTN/Vodafone MoMo, local date format (DD/MM/YYYY), and offline-first usage.

---

## Tech stack

| Layer    | Choice                        |
|----------|-------------------------------|
| Frontend | React 18 + Vite               |
| Routing  | React Router v6               |
| Backend  | Supabase (Postgres + Auth)    |
| Hosting  | Vercel / Netlify (recommended)|

---

## Quick start

### 1. Clone and install

```bash
git clone https://github.com/your-username/subtrack-gh.git
cd subtrack-gh
npm install
```

### 2. Create a Supabase project

1. Go to [supabase.com](https://supabase.com) and create a free project.
2. In **Project Settings → API**, copy:
   - **Project URL**
   - **anon / public key**

### 3. Configure environment variables

```bash
cp .env.example .env
```

Edit `.env`:

```
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-public-key
```

### 4. Run the database schema

In the Supabase dashboard, open **SQL Editor → New query**, paste the contents of `supabase_schema.sql`, and run it.

### 5. Enable Google OAuth (optional)

In Supabase: **Authentication → Providers → Google** — add your Google OAuth client ID and secret.

### 6. Start the dev server

```bash
npm run dev
```

Open [http://localhost:5173](http://localhost:5173).

---

## Project structure

```
src/
├── components/
│   ├── BottomNav.jsx        # Bottom navigation bar
│   └── SubscriptionCard.jsx # Reusable subscription row card
├── context/
│   ├── AuthContext.jsx      # Supabase auth state + helpers
│   └── AppContext.jsx       # Subscriptions CRUD + prefs (Supabase + offline)
├── data/
│   ├── categories.js        # Categories, billing cycles, payment methods
│   └── mockData.js          # Sample data for development
├── lib/
│   └── supabase.js          # Supabase client
├── pages/
│   ├── Login.jsx            # Sign in (email + Google)
│   ├── Signup.jsx           # Create account
│   ├── Dashboard.jsx        # Home — spend summary + upcoming renewals
│   ├── Subscriptions.jsx    # All subs with search + filter
│   ├── SubscriptionDetail.jsx
│   ├── AddSubscription.jsx  # Add new sub form
│   ├── Reminders.jsx        # Upcoming renewals + budget alerts
│   └── Settings.jsx         # Prefs, notifications, CSV export
├── styles/
│   └── globals.css
├── utils/
│   ├── currency.js          # GHS conversion + formatting
│   └── dates.js             # DD/MM/YYYY formatting + renewal calc
└── App.jsx
```

---

## MVP features

- Add subscriptions manually: name, amount (GHS or foreign), billing cycle, payment method
- Dashboard: total monthly/yearly spend, category breakdown, upcoming renewals
- Reminders: 7-day and 30-day renewal windows with budget alerts
- MoMo support: store MoMo number per subscription
- Ghana date format: DD/MM/YYYY throughout
- Offline mode: all data stored in localStorage, synced to Supabase when online
- CSV export from Settings
- PWA-ready: installable on Android/iOS

## Roadmap (v2)

- [ ] Auto-detection via Plaid / Mono / Stitch bank APIs
- [ ] Cancel help: deep links to cancel Netflix, Spotify, etc.
- [ ] Family/household sharing
- [ ] Price change detection + push notifications
- [ ] SMS reminders via Twilio / Arkesel (Ghana)
- [ ] React Native mobile app

---

## Deploy to Vercel

```bash
npm run build
# push to GitHub, then import the repo in vercel.com
# add VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY as environment variables
```
