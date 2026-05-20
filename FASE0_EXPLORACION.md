# Fase 0 — Exploración BNB + Setup

## Estado: ✅ Extracción completada | ⏳ Pendiente: Setup Supabase + Next.js

---

## ¿Qué se hizo en esta fase?

### 1. Extracción de criterios BNB Büro Neubau v2015

Fuente: [bnb-nachhaltigesbauen.de](https://www.bnb-nachhaltigesbauen.de/bewertungssystem/buerogebaeude/)

Se extrajeron e identificaron los **45 criterios** del sistema BNB para edificios de oficinas (Bürogebäude, Neubau, versión 2015):

| Área | Nombre | Criterios | BZ Total |
|---|---|---|---|
| 1 | Ökologische Qualität | 10 (1.1.1–1.2.4) | 15 |
| 2 | Ökonomische Qualität | 3 (2.1.1–2.2.2) | 7 |
| 3 | Soziokulturelle und funktionale Qualität | 12 (3.1.1–3.3.2) | 18 |
| 4 | Technische Qualität | 6 (4.1.1–4.1.6) | 7 |
| 5 | Prozessqualität | 8 (5.1.1–5.2.3) | 8 |
| 6 | Standortmerkmale (informativa) | 6 (6.1.1–6.1.6) | 0 |
| **Total** | | **45** | |

> **Nota:** Criterios 3.2.2 y 3.2.3 de la versión 2011_1 fueron eliminados/renombrados en v2015. No existen en la versión actual.

### 2. PDFs descargados

```
docs/
├── bnb-criteria/            ← 39 steckbriefe de áreas 1-5 + área 6
│   ├── BNB_BN2015_111.pdf   (1.1.1 Treibhauspotenzial)
│   ├── BNB_BN2015_112.pdf   (1.1.2 ODP)
│   ├── ...                  (todos los criterios)
│   └── BNB_BN2015_616.pdf   (6.1.6 Erschließung)
└── vorbemerkungen/
    └── BNB_BN2015_Allgemeine_Vorbemerkungen.pdf  ← tabla de pesos completa
```

### 3. Archivos de base de datos generados

```
db/
├── schema.sql            ← Todas las tablas + RLS + funciones Supabase
└── seed_bnb_criteria.sql ← 45 criterios BNB con nombres DE/ES/EN, BZ y LP associations
```

---

## Estructura del Scoring BNB

```
Puntaje total = 0.225 × Área1 + 0.225 × Área2 + 0.225 × Área3 + 0.225 × Área4 + 0.10 × Área5

Puntaje de área = SUM(score_criterio × Bedeutungszahl) / SUM(Bedeutungszahl)

Score por criterio:
  Z (Zielwert)    = 100 puntos
  R (Referenzwert) = 50 puntos
  G (Grenzwert)   = 10 puntos
  0               = no cumple

Niveles de certificación:
  Bronze ≥ 50%  |  Silber ≥ 65%  |  Gold ≥ 80%
```

---

## Evaluación progresiva por LP (HOAI Leistungsphasen)

Cada criterio tiene un array `applicable_lps` que indica en qué fases se evalúa:

| Tipo de criterio | LPs típicas | Ejemplo |
|---|---|---|
| LCA (ciclo de vida) | [3, 5, 8] | 1.1.1 GWP |
| Energía | [3, 5, 8] | 1.2.1 Primärenergie |
| Proceso (temprano) | [1, 2] | 5.1.1 Projektvorbereitung |
| Proceso (construcción) | [7, 8] | 5.2.1 Baustelle |
| Emplazamiento | [1] | 6.1.x Standort |
| Diseño arquitectónico | [3, 5] | 3.3.1, 2.2.1 |

---

## Próximos pasos (antes de empezar Next.js)

### A. Setup Supabase (1-2 días)
```bash
# 1. Crear proyecto en supabase.com
# 2. Ejecutar en SQL Editor:
psql -f db/schema.sql
psql -f db/seed_bnb_criteria.sql

# 3. Crear Storage buckets (en Supabase Dashboard):
#    - project-documents  (private)
#    - templates          (private)
#    - exports            (private)

# 4. Generar tipos TypeScript:
npx supabase gen types typescript --project-id YOUR_PROJECT_ID > src/types/database.ts
```

### B. Setup Next.js (siguiente sesión)
```bash
npx create-next-app@latest bnbtracker \
  --typescript \
  --tailwind \
  --app \
  --src-dir \
  --import-alias "@/*"

# Instalar dependencias core:
npm install @supabase/supabase-js @supabase/ssr
npm install next-intl
npm install @radix-ui/react-* lucide-react class-variance-authority clsx
npx shadcn@latest init
```

### C. Variables de entorno (.env.local)
```env
NEXT_PUBLIC_SUPABASE_URL=https://[project].supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=[anon_key]
SUPABASE_SERVICE_ROLE_KEY=[service_role_key]
FASTAPI_URL=http://localhost:8000
RESEND_API_KEY=[resend_key]
```

---

## Tareas pendientes de exploración (marcar al completar)

- [x] Identificar los 45 criterios BNB Büro v2015
- [x] Mapear Bedeutungszahlen (pesos) por criterio
- [x] Mapear LP de evaluación por criterio
- [x] Definir umbrales: Bronze/Silber/Gold
- [x] Crear seed SQL con datos completos (DE/ES/EN)
- [x] Crear schema SQL con tablas, RLS y funciones
- [x] Descargar todos los PDFs de steckbriefe
- [ ] Verificar Bedeutungszahlen contra PDF "Allgemeine Vorbemerkungen" (requiere instalar pdftoppm)
- [ ] Setup proyecto Supabase y ejecutar migrations
- [ ] Crear Storage buckets en Supabase
- [ ] Setup repositorio GitHub + Vercel
- [ ] Inicializar proyecto Next.js

---

## Pendiente: instalar pdftoppm para extraer texto de PDFs

Los PDFs están en `docs/bnb-criteria/` y `docs/vorbemerkungen/`.
Para extraer texto de los PDFs en Windows:

```powershell
# Opción 1: Instalar Poppler para Windows
# https://github.com/oschwartz10612/poppler-windows/releases
# Agregar bin/ al PATH del sistema

# Opción 2: Instalar Python + pdfplumber
winget install Python.Python.3.12
pip install pdfplumber
python -c "import pdfplumber; f=pdfplumber.open('docs/vorbemerkungen/BNB_BN2015_Allgemeine_Vorbemerkungen.pdf'); print(f.pages[0].extract_text())"
```

Una vez instalado, verificar Bedeutungszahlen contra las tablas oficiales en Anlage 1 de las Allgemeine Vorbemerkungen.
