# BNB Tracker — Sustainability Scoring for German Federal Buildings

> ⚠️ **Status: Phase 0 — Design & Domain Modeling** (no application code yet)
>
> This repository currently contains the BNB criteria extraction, the Supabase database schema, and 13 interactive HTML mockups of the planned application. The actual web app (Next.js + Supabase) will be built on top of this foundation.

> 🔗 **Live interactive mockups:** <https://bnbtracker-roan.vercel.app>

A planned web application to track and manage compliance with the **BNB (Bewertungssystem Nachhaltiges Bauen)** — the German federal sustainability certification system used for public office buildings ([bnb-nachhaltigesbauen.de](https://www.bnb-nachhaltigesbauen.de/bewertungssystem/buerogebaeude/)).

## Why this project

BNB certification is mandatory for new federal office buildings in Germany. Each project must be scored against **45 criteria** across 5 weighted dimensions (ecological, economic, sociocultural, technical, process quality), each with formal *Zielwert* / *Referenzwert* / *Grenzwert* thresholds. Today this is tracked in fragmented Excel files and PDFs — slow, error-prone, and hard to audit. BNB Tracker is a purpose-built tool to do it properly.

## What's in this repository today

### 1. Full BNB v2015 criteria extraction
- All 45 official criteria (1.1.1 → 5.2.3) with their *Bedeutungszahl* weights and *Lebenszyklusphase* associations
- Trilingual naming (German / Spanish / English)
- Source PDFs (steckbriefe) from the official BNB site

### 2. Supabase database schema ([`db/`](./db))
```
db/
├── schema.sql                Tables, RLS policies, scoring functions
└── seed_bnb_criteria.sql     45 BNB criteria pre-loaded
```
Encodes the official scoring formula:
```
Total = 0.225·Area1 + 0.225·Area2 + 0.225·Area3 + 0.225·Area4 + 0.10·Area5
Area  = Σ(score · BZ) / Σ(BZ)
Score = Z(100) | R(50) | G(10)
```

### 3. Interactive HTML mockups ([`mockups/`](./mockups))
13 fully styled HTML mockups covering the full app flow:

| File | Screen |
|---|---|
| `00-design-system.html` | Design tokens & components |
| `00b-criteria-map.html` | Reference index of all 45 BNB criteria |
| `01-login.html` | Auth |
| `02-dashboard.html` | Multi-project dashboard |
| `03-project-overview.html` | Single project summary |
| `04-criteria-matrix.html` | All criteria × phases grid |
| `05-criterion-detail.html` | Criterion deep-dive with linked steckbrief PDFs |
| `06-gantt.html` | Phase-by-phase Gantt of compliance work |
| `07-reports.html` | Interactive LP charts & area breakdowns |
| `08-members.html` | Team & roles |
| `09-admin.html` | Admin |
| `10-report-kurzbericht.html` | Short certification report |
| `11-report-vollbericht.html` | Full certification report |

### 4. Phase planning ([`FASE0_EXPLORACION.md`](./FASE0_EXPLORACION.md))
Detailed exploration document covering the BNB system structure, scoring math, data model, and next-phase plan.

## Planned stack (Phase 1+)

- **Framework:** Next.js (App Router) + React 19
- **DB & Auth:** Supabase (Postgres + RLS)
- **Language:** TypeScript
- **Styling:** Tailwind CSS + shadcn/ui
- **PDF reports:** server-side rendering of Kurzbericht / Vollbericht
- **AI:** LLM-assisted criterion analysis and document classification
- **Deployment:** Vercel

## Roadmap

- ✅ **Phase 0 — Exploration & domain modeling** (current state)
- ⏳ **Phase 1 — Supabase setup + Next.js scaffolding + auth**
- ⏳ **Phase 2 — Criteria matrix + project CRUD**
- ⏳ **Phase 3 — Scoring engine + reports**
- ⏳ **Phase 4 — AI-assisted criterion evaluation**

---

Built by [Jose Heusser](https://github.com/JoseHeusser) · [Oxidelabs](https://oxidelabs.cl) · AI-assisted development with Claude Code + Cursor.

## License

MIT — see [LICENSE](./LICENSE).
