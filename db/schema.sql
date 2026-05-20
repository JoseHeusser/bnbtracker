-- =============================================================================
-- BNBtracker — Schema Supabase PostgreSQL
-- Ejecutar en orden: 1) schema.sql  2) seed_bnb_criteria.sql
-- =============================================================================

-- Habilitar extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm"; -- búsqueda de texto

-- =============================================================================
-- TABLA: companies (Tenants)
-- =============================================================================
CREATE TABLE IF NOT EXISTS companies (
  id         uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name       text NOT NULL,
  slug       text UNIQUE NOT NULL,
  plan       text NOT NULL DEFAULT 'starter' CHECK (plan IN ('starter','pro','enterprise')),
  created_at timestamptz NOT NULL DEFAULT now()
);

-- =============================================================================
-- TABLA: profiles (extiende auth.users de Supabase)
-- =============================================================================
CREATE TABLE IF NOT EXISTS profiles (
  id          uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  company_id  uuid REFERENCES companies(id) ON DELETE SET NULL,
  role        text NOT NULL DEFAULT 'coordinator'
                CHECK (role IN ('platform_admin','coordinator','specialist','client')),
  full_name   text,
  avatar_url  text,
  created_at  timestamptz NOT NULL DEFAULT now()
);

-- =============================================================================
-- TABLA: projects
-- =============================================================================
CREATE TABLE IF NOT EXISTS projects (
  id                   uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id           uuid NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  name                 text NOT NULL,
  building_type        text NOT NULL DEFAULT 'büro',
  address              text,
  total_area_m2        numeric,
  client_name          text,
  client_company       text,
  status               text NOT NULL DEFAULT 'active'
                         CHECK (status IN ('active','on_hold','completed','archived')),
  current_lp           int NOT NULL DEFAULT 1 CHECK (current_lp BETWEEN 1 AND 8),
  certification_target text CHECK (certification_target IN ('bronze','silber','gold')),
  start_date           date,
  created_by           uuid REFERENCES profiles(id) ON DELETE SET NULL,
  created_at           timestamptz NOT NULL DEFAULT now()
);

-- =============================================================================
-- TABLA: project_lp_milestones
-- =============================================================================
CREATE TABLE IF NOT EXISTS project_lp_milestones (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id    uuid NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  company_id    uuid NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  lp_number     int NOT NULL CHECK (lp_number BETWEEN 1 AND 8),
  planned_date  date,
  actual_date   date,
  status        text NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending','in_progress','submitted','approved')),
  report_url    text,
  notes         text,
  UNIQUE (project_id, lp_number)
);

-- =============================================================================
-- TABLA: bnb_criteria_definitions (Global, compartida entre tenants)
-- =============================================================================
CREATE TABLE IF NOT EXISTS bnb_criteria_definitions (
  id             uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  code           text UNIQUE NOT NULL,          -- '1.1.1', '3.2.4', etc.
  variant        text NOT NULL DEFAULT 'büro',  -- extensible: 'unterricht', 'labor'
  quality_area   int NOT NULL CHECK (quality_area BETWEEN 1 AND 6),
  subcategory    text NOT NULL,                  -- '1.1', '3.2', etc.
  title_de       text NOT NULL,
  title_es       text,
  title_en       text,
  description_de text,
  max_points     int NOT NULL DEFAULT 100,
  weight         numeric NOT NULL DEFAULT 1,     -- Bedeutungszahl: 0, 1, 2, 3
  applicable_lps int[] NOT NULL DEFAULT ARRAY[3,5,8],
  is_mandatory   bool NOT NULL DEFAULT false,
  sort_order     int NOT NULL DEFAULT 0
);

-- =============================================================================
-- TABLA: project_criteria (Instancia de criterio por proyecto)
-- =============================================================================
CREATE TABLE IF NOT EXISTS project_criteria (
  id               uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id       uuid NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  company_id       uuid NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  criteria_def_id  uuid NOT NULL REFERENCES bnb_criteria_definitions(id),
  assigned_to      uuid REFERENCES profiles(id) ON DELETE SET NULL,
  status           text NOT NULL DEFAULT 'not_started'
                     CHECK (status IN ('not_started','in_progress','completed','not_applicable')),
  is_relevant      bool NOT NULL DEFAULT true,
  notes            text,
  updated_at       timestamptz NOT NULL DEFAULT now(),
  UNIQUE (project_id, criteria_def_id)
);

-- Trigger: actualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER project_criteria_updated_at
  BEFORE UPDATE ON project_criteria
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- =============================================================================
-- TABLA: criterion_evaluations (Evaluación progresiva por LP)
-- =============================================================================
CREATE TABLE IF NOT EXISTS criterion_evaluations (
  id                   uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_criteria_id  uuid NOT NULL REFERENCES project_criteria(id) ON DELETE CASCADE,
  company_id           uuid NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  lp_number            int NOT NULL CHECK (lp_number BETWEEN 1 AND 8),
  score                numeric CHECK (score BETWEEN 0 AND 100),
  status               text NOT NULL DEFAULT 'draft'
                         CHECK (status IN ('draft','submitted','approved')),
  evaluated_by         uuid REFERENCES profiles(id) ON DELETE SET NULL,
  evaluated_at         timestamptz NOT NULL DEFAULT now(),
  notes                text,
  UNIQUE (project_criteria_id, lp_number)
);

-- =============================================================================
-- TABLA: criterion_comments (Comentarios múltiples por criterio)
-- =============================================================================
CREATE TABLE IF NOT EXISTS criterion_comments (
  id                   uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_criteria_id  uuid NOT NULL REFERENCES project_criteria(id) ON DELETE CASCADE,
  author_id            uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  company_id           uuid NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  content              text NOT NULL,
  is_internal          bool NOT NULL DEFAULT true,  -- false = visible a cliente/especialista
  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now()
);

-- =============================================================================
-- TABLA: criterion_documents (Archivos adjuntos)
-- =============================================================================
CREATE TABLE IF NOT EXISTS criterion_documents (
  id                   uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_criteria_id  uuid NOT NULL REFERENCES project_criteria(id) ON DELETE CASCADE,
  lp_number            int CHECK (lp_number BETWEEN 1 AND 8),
  company_id           uuid NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  file_name            text NOT NULL,
  storage_path         text NOT NULL,  -- path en Supabase Storage bucket
  file_type            text CHECK (file_type IN ('pdf','docx','xlsx','image','other')),
  file_size_kb         int,
  description          text,
  uploaded_by          uuid REFERENCES profiles(id) ON DELETE SET NULL,
  uploaded_at          timestamptz NOT NULL DEFAULT now(),
  is_evidence          bool NOT NULL DEFAULT true  -- true=evidencia, false=doc de trabajo
);

-- =============================================================================
-- TABLA: document_templates (Templates de formulario por criterio)
-- =============================================================================
CREATE TABLE IF NOT EXISTS document_templates (
  id               uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id       uuid REFERENCES companies(id) ON DELETE CASCADE, -- null = template global
  criteria_def_id  uuid REFERENCES bnb_criteria_definitions(id) ON DELETE CASCADE,
  name             text NOT NULL,
  description      text,
  fields           jsonb NOT NULL DEFAULT '[]'::jsonb,
  -- Estructura de campo: [{id, label_de, label_es, label_en, type, required, options}]
  -- types: text | textarea | number | select | date | file | checkbox
  created_by       uuid REFERENCES profiles(id) ON DELETE SET NULL,
  created_at       timestamptz NOT NULL DEFAULT now()
);

-- =============================================================================
-- TABLA: template_submissions (Formularios completados)
-- =============================================================================
CREATE TABLE IF NOT EXISTS template_submissions (
  id                   uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  template_id          uuid NOT NULL REFERENCES document_templates(id) ON DELETE CASCADE,
  project_criteria_id  uuid NOT NULL REFERENCES project_criteria(id) ON DELETE CASCADE,
  company_id           uuid NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  data                 jsonb NOT NULL DEFAULT '{}'::jsonb, -- {field_id: value}
  submitted_by         uuid REFERENCES profiles(id) ON DELETE SET NULL,
  submitted_at         timestamptz NOT NULL DEFAULT now(),
  lp_number            int CHECK (lp_number BETWEEN 1 AND 8)
);

-- =============================================================================
-- TABLA: project_members (Control de acceso por proyecto)
-- =============================================================================
CREATE TABLE IF NOT EXISTS project_members (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id      uuid NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  user_id         uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  role            text NOT NULL CHECK (role IN ('coordinator','specialist','client')),
  criteria_scope  uuid[],  -- null = acceso total; array de criteria_def_id para specialists
  invited_by      uuid REFERENCES profiles(id) ON DELETE SET NULL,
  invited_at      timestamptz NOT NULL DEFAULT now(),
  accepted_at     timestamptz,
  UNIQUE (project_id, user_id)
);

-- =============================================================================
-- TABLA: notifications
-- =============================================================================
CREATE TABLE IF NOT EXISTS notifications (
  id          uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  project_id  uuid REFERENCES projects(id) ON DELETE CASCADE,
  type        text NOT NULL
                CHECK (type IN ('deadline_warning','criteria_assigned','comment_added',
                                'lp_due','report_ready','invitation')),
  title       text NOT NULL,
  message     text,
  read        bool NOT NULL DEFAULT false,
  action_url  text,
  created_at  timestamptz NOT NULL DEFAULT now()
);

-- =============================================================================
-- ÍNDICES
-- =============================================================================
CREATE INDEX IF NOT EXISTS idx_projects_company ON projects(company_id);
CREATE INDEX IF NOT EXISTS idx_project_criteria_project ON project_criteria(project_id);
CREATE INDEX IF NOT EXISTS idx_project_criteria_company ON project_criteria(company_id);
CREATE INDEX IF NOT EXISTS idx_criterion_evals_criteria ON criterion_evaluations(project_criteria_id);
CREATE INDEX IF NOT EXISTS idx_criterion_comments_criteria ON criterion_comments(project_criteria_id);
CREATE INDEX IF NOT EXISTS idx_criterion_docs_criteria ON criterion_documents(project_criteria_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id, read);
CREATE INDEX IF NOT EXISTS idx_bnb_criteria_variant ON bnb_criteria_definitions(variant, quality_area);

-- =============================================================================
-- ROW LEVEL SECURITY (RLS)
-- =============================================================================

ALTER TABLE companies              ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles               ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects               ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_lp_milestones  ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_criteria       ENABLE ROW LEVEL SECURITY;
ALTER TABLE criterion_evaluations  ENABLE ROW LEVEL SECURITY;
ALTER TABLE criterion_comments     ENABLE ROW LEVEL SECURITY;
ALTER TABLE criterion_documents    ENABLE ROW LEVEL SECURITY;
ALTER TABLE document_templates     ENABLE ROW LEVEL SECURITY;
ALTER TABLE template_submissions   ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_members        ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications          ENABLE ROW LEVEL SECURITY;
ALTER TABLE bnb_criteria_definitions ENABLE ROW LEVEL SECURITY;

-- bnb_criteria_definitions: lectura pública (datos globales del sistema BNB)
CREATE POLICY "bnb_criteria_public_read"
  ON bnb_criteria_definitions FOR SELECT USING (true);

-- companies: solo miembros de la empresa
CREATE POLICY "companies_own"
  ON companies FOR ALL
  USING (id = (SELECT company_id FROM profiles WHERE id = auth.uid()));

-- profiles: todos en la misma empresa + propio perfil
CREATE POLICY "profiles_same_company"
  ON profiles FOR SELECT
  USING (company_id = (SELECT company_id FROM profiles WHERE id = auth.uid())
         OR id = auth.uid());

CREATE POLICY "profiles_own_update"
  ON profiles FOR UPDATE
  USING (id = auth.uid());

-- projects: coordinadores ven todos los de su empresa; specialists/clients solo los asignados
CREATE POLICY "projects_coordinator_all"
  ON projects FOR ALL
  USING (
    company_id = (SELECT company_id FROM profiles WHERE id = auth.uid())
    AND (SELECT role FROM profiles WHERE id = auth.uid()) IN ('platform_admin','coordinator')
  );

CREATE POLICY "projects_member_select"
  ON projects FOR SELECT
  USING (
    id IN (SELECT project_id FROM project_members WHERE user_id = auth.uid())
    AND (SELECT role FROM profiles WHERE id = auth.uid()) IN ('specialist','client')
  );

-- project_criteria: specialists ven solo criterios en su criteria_scope
CREATE POLICY "criteria_coordinator"
  ON project_criteria FOR ALL
  USING (
    company_id = (SELECT company_id FROM profiles WHERE id = auth.uid())
    AND (SELECT role FROM profiles WHERE id = auth.uid()) IN ('platform_admin','coordinator')
  );

CREATE POLICY "criteria_specialist"
  ON project_criteria FOR SELECT
  USING (
    id IN (
      SELECT pc.id FROM project_criteria pc
      JOIN project_members pm ON pm.project_id = pc.project_id
      WHERE pm.user_id = auth.uid()
        AND (pm.criteria_scope IS NULL OR pc.criteria_def_id = ANY(pm.criteria_scope))
    )
    AND (SELECT role FROM profiles WHERE id = auth.uid()) = 'specialist'
  );

-- criterion_comments: comentarios internos (is_internal=true) solo para coordinador
CREATE POLICY "comments_coordinator"
  ON criterion_comments FOR ALL
  USING (
    company_id = (SELECT company_id FROM profiles WHERE id = auth.uid())
    AND (SELECT role FROM profiles WHERE id = auth.uid()) IN ('platform_admin','coordinator')
  );

CREATE POLICY "comments_external_non_internal"
  ON criterion_comments FOR SELECT
  USING (
    is_internal = false
    AND project_criteria_id IN (
      SELECT pc.id FROM project_criteria pc
      JOIN project_members pm ON pm.project_id = pc.project_id
      WHERE pm.user_id = auth.uid()
    )
    AND (SELECT role FROM profiles WHERE id = auth.uid()) IN ('specialist','client')
  );

-- notifications: solo el usuario destinatario
CREATE POLICY "notifications_own"
  ON notifications FOR ALL
  USING (user_id = auth.uid());

-- =============================================================================
-- FUNCIÓN: clonar criterios BNB al crear un proyecto
-- =============================================================================
CREATE OR REPLACE FUNCTION clone_bnb_criteria_to_project(
  p_project_id  uuid,
  p_company_id  uuid,
  p_variant     text DEFAULT 'büro'
)
RETURNS void AS $$
BEGIN
  INSERT INTO project_criteria (project_id, company_id, criteria_def_id, status)
  SELECT p_project_id, p_company_id, id, 'not_started'
  FROM bnb_criteria_definitions
  WHERE variant = p_variant;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =============================================================================
-- FUNCIÓN: calcular puntaje del proyecto
-- =============================================================================
CREATE OR REPLACE FUNCTION calculate_project_score(p_project_id uuid)
RETURNS TABLE (
  area            int,
  area_score      numeric,
  criteria_count  int,
  completed_count int
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    bcd.quality_area,
    CASE
      WHEN SUM(bcd.weight) = 0 THEN 0
      ELSE ROUND(
        SUM(COALESCE(ce.score, 0) * bcd.weight) / NULLIF(SUM(bcd.weight), 0), 2
      )
    END AS area_score,
    COUNT(*)::int AS criteria_count,
    COUNT(*) FILTER (WHERE pc.status = 'completed')::int AS completed_count
  FROM project_criteria pc
  JOIN bnb_criteria_definitions bcd ON bcd.id = pc.criteria_def_id
  LEFT JOIN (
    SELECT DISTINCT ON (project_criteria_id) project_criteria_id, score
    FROM criterion_evaluations
    WHERE status IN ('submitted','approved')
    ORDER BY project_criteria_id, lp_number DESC
  ) ce ON ce.project_criteria_id = pc.id
  WHERE pc.project_id = p_project_id
    AND pc.is_relevant = true
    AND bcd.weight > 0
  GROUP BY bcd.quality_area;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
