# BNBtracker — Mockup Log

> Stack HTML: Tailwind CDN + Alpine.js + Lucide Icons
> Propósito: definir estructura visual y lógica de interacción → guía para implementación Next.js

---

## Ruta de creación (orden de prioridad)

| # | Archivo | Pantalla | Estado | Decisiones clave |
|---|---|---|---|---|
| 00 | `00-design-system.html` | Sistema de diseño (colores, componentes) | ✅ | Colores por área, status dots, score bar, layout shell |
| 01 | `01-login.html` | Login / Registro | ✅ | Tabs login/registro, magic link, loading state |
| 02 | `02-dashboard.html` | Dashboard — lista de proyectos | ✅ | Stats row, filtros, cards con score + mini bars, modal nuevo proyecto |
| 03 | `03-project-overview.html` | Vista de proyecto (score cards + LP progress) | ✅ | Score ring, 5 area bars, LP stepper 8 pasos, panel info+team, alerta frist |
| 04 | `04-criteria-matrix.html` | **Matriz criterios × LP** (pantalla principal) | ✅ | Tabla sticky-col, 45 criterios agrupados por área, LP1-8 columns coloreadas, filtros área/estado/LP/search, panel derecho con evaluación+docs+comments |
| 05 | `05-criterion-detail.html` | Detalle de criterio (página completa) | ✅ | Layout 2-col (main+sidebar), 4 tabs: Bewertungen (score slider + historial), Dokumente (upload+tags), Formulare (template JSONB LCA renderizado), Kommentare (hilo interno/externo) |
| 06 | `06-gantt.html` | Gantt LP milestones | ✅ | Barras planned/actual por LP, marcador "Hoy", milestone diamond, modal edición fechas+notas+estado, cálculo % de posición via datePct() |
| 07 | `07-reports.html` | Dashboard de puntaje + exportar | ✅ | Score ring SVG, barras por área Q1-Q6, historial chart, export PDF/Excel (loading state), simulador con sliders por área → nivel proyectado |
| 08 | `08-members.html` | Gestión de miembros del proyecto | ✅ | Lista con roles/scope, modal invitar (rol + áreas para specialist), edición in-line, nota RLS, remove con confirm |
| 09 | `09-admin.html` | Panel admin plataforma (empresas/usuarios) | ✅ | Header dark, sidebar colapsable, tabs: Empresas (stats+tabla+plan badges+impersonar) / Usuarios / Criterios-Def / Activitätslog, modal nueva empresa con plan selector |
| 10 | `10-report-kurzbericht.html` | Kurzbericht (tabla compacta por LP) | ✅ | LP-Auswahl 1/2/3/5/8, portada con score+áreas, tabla criterios con estados+score, "Offener Punkt" flag por criterio con nota editable, imprimir→PDF via browser |
| 11 | `11-report-vollbericht.html` | Vollbericht (tarjetas completas por área) | ✅ | Misma portada+LP-Auswahl, secciones por área, cards por criterio con evaluaciones por LP+notas+docs, flags con notas editables, page-break-inside: avoid |

---

## Sistema de Diseño (definido en 00-design-system.html)

### Colores de Áreas BNB
| Área | Nombre | Color |
|---|---|---|
| 1 | Ökologische Qualität | `green-600` |
| 2 | Ökonomische Qualität | `blue-600` |
| 3 | Soziokulturelle Qualität | `violet-600` |
| 4 | Technische Qualität | `orange-500` |
| 5 | Prozessqualität | `teal-600` |
| 6 | Standortmerkmale | `rose-500` |

### Colores de Estado de Criterios
| Estado | Color |
|---|---|
| completed | `green-500` |
| in_progress | `amber-400` |
| not_started | `slate-200` |
| not_applicable | `slate-400` (tachado) |

### Niveles de Certificación
| Nivel | Umbral | Color |
|---|---|---|
| Bronze | ≥ 50% | `amber-600` |
| Silber | ≥ 65% | `slate-400` |
| Gold | ≥ 80% | `yellow-500` |

### Tipografía
- Font: `Inter` (via Google Fonts CDN)
- Base: `text-sm` para tablas, `text-base` para cuerpo
- Headings: `font-semibold`

### Layout base (sidebar + header)
```
┌─────────────────────────────────────────────────┐
│ Header: [Logo] [Proyecto actual] [...] [Avatar] │
├────────────┬────────────────────────────────────┤
│  Sidebar   │  Main content area                 │
│  w-56      │  flex-1, p-6                       │
│            │                                    │
│  - Projects│                                    │
│  - Criteria│                                    │
│  - Gantt   │                                    │
│  - Reports │                                    │
│  - Members │                                    │
└────────────┴────────────────────────────────────┘
```

---

## Log de cambios

### 2026-05-12 — Sesión 3

#### 04-criteria-matrix.html (revisión mayor) ✅
- Layout rediseñado: full-width con panel lateral redimensionable (drag divider)
- Columna criterio cambia a `flex-1` en lugar de ancho fijo → ocupa espacio libre cuando panel está cerrado
- Botón "Vollständige Detailansicht öffnen" movido entre título y barra de estado; color verde sólido para mayor visibilidad
- LP mini-timeline: todos los círculos son botones — click añade/quita LP del criterio
- LPs inactivos muestran icono "+" al hover con transición CSS (Tailwind CDN no escanea clases dinámicas de Alpine → hover via `<style>`)
- Solo se puede quitar un LP si su estado es `not_started`

#### 05-criterion-detail.html (revisión) ✅
- Tab Bewertungen: añadido bloque Bewertungsstufen (opciones A–E del Steckbrief)
- Muestra punkte, %, descripción por nivel; click fija Erfüllungsgrad del LP activo al valor correspondiente
- Funciona en paralelo con el slider manual

#### 10-report-kurzbericht.html ✅
- Bericht compacto orientado a auditor/cliente externo
- Portada: logo, datos proyecto, score total + barras por área, nota de portada editable
- Tabla criterios agrupados por área: Código | Nombre | BZ | LP cols | Score | Verweis | Flag
- LP-Auswahl: selector para incluir hasta LP 1/2/3/5/8 → columnas visibles y scores calculados acumulativamente
- "Offener Punkt" toggle por criterio → fila amber con input de nota; nota aparece en celda al imprimir
- Print CSS: A4 portrait, márgenes 14mm/18mm, `.no-print { display:none }`
- Generar PDF: Strg+P / Cmd+P → Guardar como PDF (sin librerías externas)

#### 11-report-vollbericht.html ✅
- Bericht completo para entrega formal
- Misma portada y LP-Auswahl que Kurzbericht
- Secciones por área (6 áreas): header coloreado con área, peso, score
- Cards por criterio: timeline LP, score bar, evaluaciones por LP con notas y chips de documentos
- LPs futuros (> reportLP) mostrados como "Ausstehend"
- "Offener Punkt" toggle en cabecera de card → sección amber con nota editable
- `page-break-inside: avoid` en cards; `page-break-after: always` entre portada y secciones
- **Decisión**: dos archivos separados — Kurzbericht para presentaciones rápidas, Vollbericht para entrega formal

### 2026-05-12 — Sesión 3 (correcciones globales)

#### Platin eliminado de todo el proyecto ✅
- BNB Büro solo tiene Bronze ≥50%, Silber ≥65%, Gold ≥80% — Platin no existe
- Archivos corregidos: `00-design-system.html`, `01-login.html`, `02-dashboard.html`, `03-project-overview.html`, `07-reports.html`, `db/schema.sql`, `MOCKUP_LOG.md`

---

### 2026-05-10 — Sesión 2

#### 04-criteria-matrix.html ✅
- Tabla con columna sticky (criterio) + LP1-8 scrollables
- 45 criterios BNB agrupados por área con headers coloreados
- Celdas: ✓ verde (completed), ◑ ámbar (in_progress), ○ gris (not_started), · vacío (no aplica)
- LP3 activo resaltado con azul en columna y header
- Toolbar: chips de área + filtro estado + filtro LP + búsqueda
- Panel derecho deslizable: evaluación por LP + docs + comentarios + link a 05
- Decisión: panel en 04 es preview rápido; 05 es página completa

#### 05-criterion-detail.html ✅
- Criterio ejemplo: 1.1.1 Treibhauspotenzial (GWP), BZ=3, LP=[3,5,8]
- Criterion header bar: código + área + BZ + status select + score + assigned user
- LP mini-timeline: 8 círculos mostrando estado, LP3 activo
- Tab Bewertungen: cards por LP con score slider, notas, historial de versiones
- Tab Dokumente: LP filter + lista de archivos con tipo/tamaño/autor + upload zone + tags (Nachweis/Arbeitsdokument)
- Tab Formulare: template JSONB renderizado realista (método LCA, GWP-Wert, Betrachtungszeitraum, Datenquelle, Software, Lebenszyklusphasen checkboxes, archivo adjunto, observaciones)
- Tab Kommentare: hilo con replies + attach file + toggle interno/externo
- Sidebar: descripción BNB, requirements por LP, BZ+peso, asignación, PDF BBSR link, metadata
- Next.js: app/[locale]/(dashboard)/projects/[id]/criteria/[criteriaId]/page.tsx
- **Decisión resuelta**: criterion detail = página completa (no solo drawer)

### 2026-05-10 — Sesión 1

#### 00-design-system.html ✅
- Definido sistema de colores por área BNB
- Componentes documentados: Badge, StatusDot, ScoreBar, AreaCard, LPBadge
- Decisión: usar `slate-900` como fondo de sidebar, `white` como fondo de content

#### 01-login.html ✅
- Layout: centrado, tarjeta login con logo
- Tabs: Login / Registrar empresa
- Campos: email + password + nombre empresa (registro)
- Decisión: magic link como opción alternativa → botón "Enviar magic link"
- **Next.js**: `app/[locale]/(auth)/login/page.tsx` → Supabase Auth client-side

#### 02-dashboard.html ✅
- Header con nombre de empresa + botón "Nuevo proyecto"
- Cards de proyectos con: nombre, cliente, LP actual, score total, estado
- Filtros: All / Active / On Hold / Completed
- Stats row: total proyectos, en proceso, completados, promedio score
- **Next.js**: `app/[locale]/(dashboard)/page.tsx` → Server Component, datos via Supabase

---

## Notas de implementación Next.js (actualizar con cada mockup)

- El sidebar es un Server Component con datos del usuario (role, nombre)
- La matriz de criterios usa `useCriteria()` hook con Supabase Realtime
- Los filtros de área/LP son estado local (useState/Alpine)
- Los comentarios internos se filtran en la query con RLS (no en cliente)
- El Gantt usa fechas de `project_lp_milestones` + criterios completados por LP

---

## Decisiones globales pendientes

- [ ] ¿Sidebar colapsable en mobile (hamburger) o drawer?
- [ ] ¿Idioma default del mockup? (usar DE para términos técnicos BNB, ES para UI)
- [ ] ¿Score simulador como modal o página separada?
- [x] ¿Criterion detail como side panel (drawer) o página completa? → **Página completa** (05), el drawer en 04 es preview rápido
