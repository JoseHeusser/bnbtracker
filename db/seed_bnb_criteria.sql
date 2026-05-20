-- =============================================================================
-- BNBtracker — Seed Data: BNB Büro- und Verwaltungsgebäude Neubau v2015
-- Fuente: BBSR / bnb-nachhaltigesbauen.de (PDFs en docs/bnb-criteria/)
-- =============================================================================
-- Estructura de scoring BNB:
--   Zielwert (Z) = 100 puntos | Referenzwert (R) = 50 puntos | Grenzwert (G) = 10 puntos
--   weight = Bedeutungszahl (1–3), peso relativo DENTRO del área de calidad
--   Área 6 (Standortmerkmale): max_points = 100 pero NO entra en puntaje total
--
-- Pesos de áreas en puntaje total:
--   Áreas 1–4: 22.5% c/u  |  Área 5: 10%  |  Área 6: informativa
--
-- LP de evaluación (HOAI Leistungsphasen):
--   Evaluación progresiva: criterios se evalúan en múltiples LP
--   LP1=Grundlagenermittlung, LP2=Vorplanung, LP3=Entwurfsplanung,
--   LP4=Genehmigungsplanung, LP5=Ausführungsplanung,
--   LP6=Vorbereitung Vergabe, LP7=Mitwirkung Vergabe, LP8=Objektüberwachung
-- =============================================================================

-- Limpiar datos existentes (solo para desarrollo)
TRUNCATE TABLE bnb_criteria_definitions RESTART IDENTITY CASCADE;

INSERT INTO bnb_criteria_definitions
  (code, variant, quality_area, subcategory, title_de, title_es, title_en,
   description_de, max_points, weight, applicable_lps, is_mandatory, sort_order)
VALUES

-- ===========================================================================
-- ÁREA 1: Ökologische Qualität (Calidad Ecológica) — Peso total: 22.5%
-- Subcategoría 1.1: Wirkungen auf die globale und lokale Umwelt
-- ===========================================================================

('1.1.1', 'büro', 1, '1.1',
 'Treibhauspotenzial (GWP)',
 'Potencial de calentamiento global (GWP)',
 'Global Warming Potential (GWP)',
 'Bewertung der gebäudebezogenen Treibhausgasemissionen über den Lebenszyklus mittels Ökobilanz (LCA). Berücksichtigt Herstellung, Betrieb und Rückbau des Gebäudes.',
 100, 3, ARRAY[3,5,8], false, 10),

('1.1.2', 'büro', 1, '1.1',
 'Ozonschichtabbaupotenzial (ODP)',
 'Potencial de destrucción del ozono (ODP)',
 'Ozone Depletion Potential (ODP)',
 'Bewertung des Potenzials zur Schädigung der stratosphärischen Ozonschicht durch gebäudebezogene Emissionen über den Lebenszyklus.',
 100, 1, ARRAY[3,5,8], false, 20),

('1.1.3', 'büro', 1, '1.1',
 'Ozonbildungspotenzial (POCP)',
 'Potencial de formación de ozono (POCP)',
 'Photochemical Ozone Creation Potential (POCP)',
 'Bewertung des Potenzials zur Bildung von bodennahem Ozon (Sommersmog) durch gebäudebezogene Emissionen über den Lebenszyklus.',
 100, 1, ARRAY[3,5,8], false, 30),

('1.1.4', 'büro', 1, '1.1',
 'Versauerungspotenzial (AP)',
 'Potencial de acidificación (AP)',
 'Acidification Potential (AP)',
 'Bewertung des Beitrags zur Versauerung von Böden und Gewässern durch gebäudebezogene Emissionen über den Lebenszyklus.',
 100, 1, ARRAY[3,5,8], false, 40),

('1.1.5', 'büro', 1, '1.1',
 'Überdüngungspotenzial (EP)',
 'Potencial de eutrofización (EP)',
 'Eutrophication Potential (EP)',
 'Bewertung des Beitrags zur Überdüngung von Böden und Gewässern durch gebäudebezogene Emissionen über den Lebenszyklus.',
 100, 1, ARRAY[3,5,8], false, 50),

('1.1.6', 'büro', 1, '1.1',
 'Risiken für die lokale Umwelt',
 'Riesgos para el medio ambiente local',
 'Risks to the Local Environment',
 'Bewertung von Risiken für die lokale Umwelt durch den Einsatz von Baustoffen und gebäudetechnischen Anlagen (Schadstoffe, Emissionen in Boden/Wasser).',
 100, 1, ARRAY[3,5], false, 60),

('1.1.7', 'büro', 1, '1.1',
 'Nachhaltige Materialgewinnung / Holz',
 'Obtención sostenible de materiales / Madera',
 'Sustainable Material Sourcing / Timber',
 'Nachweis der nachhaltigen Gewinnung von Holz und Holzprodukten (FSC, PEFC). Förderung nachhaltiger Forstwirtschaft und Biodiversität.',
 100, 1, ARRAY[3,5,8], false, 70),

-- Subcategoría 1.2: Ressourceninanspruchnahme

('1.2.1', 'büro', 1, '1.2',
 'Primärenergiebedarf nicht erneuerbar (PEne)',
 'Demanda de energía primaria no renovable (PEne)',
 'Non-Renewable Primary Energy Demand (PEne)',
 'Bewertung des Gesamtbedarfs an nicht erneuerbarer Primärenergie über den Lebenszyklus. Umfasst Betriebsenergie und graue Energie der Baustoffe.',
 100, 3, ARRAY[3,5,8], false, 80),

('1.2.3', 'büro', 1, '1.2',
 'Trinkwasserbedarf und Abwasseraufkommen',
 'Demanda de agua potable y generación de aguas residuales',
 'Drinking Water Demand and Wastewater Generation',
 'Bewertung des Trinkwasserbedarfs im Gebäudebetrieb und der Maßnahmen zur Abwasserreduzierung (Regenwassernutzung, Grauwasserrecycling).',
 100, 2, ARRAY[3,5,8], false, 90),

('1.2.4', 'büro', 1, '1.2',
 'Flächeninanspruchnahme',
 'Ocupación del suelo',
 'Land Use',
 'Bewertung der Inanspruchnahme und Versiegelung von Flächen sowie Maßnahmen zur ökologischen Aufwertung (Dachbegrünung, Entsiegelung).',
 100, 1, ARRAY[1,3], false, 100),

-- ===========================================================================
-- ÁREA 2: Ökonomische Qualität (Calidad Económica) — Peso total: 22.5%
-- Subcategoría 2.1: Lebenszykluskosten
-- ===========================================================================

('2.1.1', 'büro', 2, '2.1',
 'Gebäudebezogene Kosten im Lebenszyklus (LCC)',
 'Costos del edificio en el ciclo de vida (LCC)',
 'Building Life Cycle Costs (LCC)',
 'Bewertung der gebäudebezogenen Kosten über den gesamten Lebenszyklus (Herstellungs-, Betriebs- und Rückbaukosten) nach DIN 18960.',
 100, 3, ARRAY[3,5,8], false, 110),

-- Subcategoría 2.2: Wirtschaftlichkeit und Wertstabilität

('2.2.1', 'büro', 2, '2.2',
 'Flächeneffizienz',
 'Eficiencia de superficies',
 'Area Efficiency',
 'Bewertung des Verhältnisses von Nutzfläche zu Brutto-Grundfläche (NUF/BGF). Optimierung der Flächenausnutzung für wirtschaftlichen Gebäudebetrieb.',
 100, 2, ARRAY[3,5], false, 120),

('2.2.2', 'büro', 2, '2.2',
 'Anpassungsfähigkeit',
 'Adaptabilidad (flexibilidad de uso)',
 'Adaptability',
 'Bewertung der Fähigkeit des Gebäudes zur Anpassung an veränderte Nutzungsanforderungen. Umfasst Geometrie, Grundrisse, Konstruktion und technische Ausstattung.',
 100, 2, ARRAY[3,5], false, 130),

-- ===========================================================================
-- ÁREA 3: Soziokulturelle und funktionale Qualität — Peso total: 22.5%
-- Subcategoría 3.1: Gesundheit, Behaglichkeit und Nutzerzufriedenheit
-- ===========================================================================

('3.1.1', 'büro', 3, '3.1',
 'Thermischer Komfort im Winter',
 'Confort térmico en invierno',
 'Thermal Comfort in Winter',
 'Bewertung der thermischen Behaglichkeit im Winter: operative Raumtemperatur, Strahlungsasymmetrie, Fußbodentemperatur und Zugluft nach DIN EN 15251.',
 100, 2, ARRAY[3,5,8], false, 140),

('3.1.3', 'büro', 3, '3.1',
 'Innenraumlufthygiene',
 'Higiene del aire interior',
 'Indoor Air Quality',
 'Bewertung der Raumlufthygiene: Lüftungskonzept, Luftwechselraten, Schadstoffemissionen aus Baumaterialien (VOC, Formaldehyd), CO2-Konzentration.',
 100, 2, ARRAY[3,5,8], false, 150),

('3.1.4', 'büro', 3, '3.1',
 'Akustischer Komfort',
 'Confort acústico',
 'Acoustic Comfort',
 'Bewertung des akustischen Komforts: Schallschutz zwischen Nutzungseinheiten, Nachhallzeit in Büroräumen, Außenlärm und haustechnische Geräusche.',
 100, 2, ARRAY[3,5,8], false, 160),

('3.1.5', 'büro', 3, '3.1',
 'Visueller Komfort',
 'Confort visual',
 'Visual Comfort',
 'Bewertung der Tageslichtversorgung (Tageslichtquotient), Blend- und Sonnenschutz sowie Kunstlichtqualität in Büroarbeitsplätzen.',
 100, 2, ARRAY[3,5], false, 170),

('3.1.6', 'büro', 3, '3.1',
 'Einflussnahmemöglichkeiten durch Nutzer',
 'Posibilidades de influencia del usuario',
 'User Control Options',
 'Bewertung der Möglichkeiten zur individuellen Steuerung von Raumtemperatur, Belüftung, Beleuchtung und Sonnenschutz durch die Nutzer.',
 100, 1, ARRAY[3,5], false, 180),

('3.1.7', 'büro', 3, '3.1',
 'Aufenthaltsqualitäten im Außenbereich',
 'Calidad de las áreas exteriores',
 'Quality of Outdoor Spaces',
 'Bewertung der Qualität von Außenaufenthaltsbereichen: Begrünung, Sitzgelegenheiten, Witterungsschutz und Erholungsqualität für Nutzer.',
 100, 1, ARRAY[3,5], false, 190),

('3.1.8', 'büro', 3, '3.1',
 'Sicherheit und Störfallrisiken',
 'Seguridad y riesgos de accidentes',
 'Safety and Incident Risks',
 'Bewertung von Sicherheitsaspekten: Einbruchschutz, Brandschutz, Absturzsicherung sowie Maßnahmen zur Minimierung von Störfallrisiken.',
 100, 1, ARRAY[3,5], false, 200),

-- Subcategoría 3.2: Funktionalität

('3.2.1', 'büro', 3, '3.2',
 'Barrierefreiheit',
 'Accesibilidad (libre de barreras)',
 'Accessibility (Barrier-Free Design)',
 'Bewertung der Barrierefreiheit gemäß DIN 18040: stufenlose Zugänglichkeit, rollstuhlgerechte Ausstattung, taktile und akustische Orientierungshilfen.',
 100, 2, ARRAY[3,5], false, 210),

('3.2.4', 'büro', 3, '3.2',
 'Zugänglichkeit',
 'Accesibilidad general',
 'Accessibility (General)',
 'Bewertung der allgemeinen Zugänglichkeit des Gebäudes: Lage, Erschließung, Orientierung, Eingangssituation und öffentliche Erreichbarkeit.',
 100, 1, ARRAY[3,5], false, 220),

('3.2.5', 'büro', 3, '3.2',
 'Mobilitätsinfrastruktur',
 'Infraestructura de movilidad',
 'Mobility Infrastructure',
 'Bewertung der Infrastruktur für nachhaltige Mobilität: Fahrradabstellanlagen, Ladestationen E-Mobilität, ÖPNV-Anbindung, Carsharing-Angebote.',
 100, 1, ARRAY[1,3], false, 230),

-- Subcategoría 3.3: Sicherung der Gestaltungsqualität

('3.3.1', 'büro', 3, '3.3',
 'Gestalterische und städtebauliche Qualität',
 'Calidad arquitectónica y urbanística',
 'Architectural and Urban Design Quality',
 'Sicherung der gestalterischen Qualität durch Wettbewerbsverfahren, Bewerbung um Architekturpreise und städtebauliche Einbindung des Gebäudes.',
 100, 2, ARRAY[3,5], false, 240),

('3.3.2', 'büro', 3, '3.3',
 'Kunst am Bau',
 'Arte en la construcción (Kunst am Bau)',
 'Public Art Integration',
 'Einbindung von Kunst in Bundesbauten gemäß Richtlinien: Wettbewerb, Budget, künstlerische Konzeption und Einbindung in die Architektur.',
 100, 1, ARRAY[5,8], false, 250),

-- ===========================================================================
-- ÁREA 4: Technische Qualität (Calidad Técnica) — Peso total: 22.5%
-- Subcategoría 4.1: Technische Ausführung
-- ===========================================================================

('4.1.1', 'büro', 4, '4.1',
 'Schallschutz',
 'Protección acústica (aislamiento sonoro)',
 'Sound Insulation',
 'Bewertung des Schallschutzes: Luft- und Trittschallschutz zwischen Nutzungseinheiten und gegen Außenlärm gemäß DIN 4109 und VDI 4100.',
 100, 2, ARRAY[3,5,8], false, 260),

('4.1.2', 'büro', 4, '4.1',
 'Wärme- und Tauwasserschutz',
 'Protección térmica y contra condensación',
 'Thermal and Moisture Protection',
 'Bewertung des winterlichen und sommerlichen Wärmeschutzes sowie Maßnahmen zur Vermeidung von Tauwasserbildung in Bauteilen nach DIN 4108.',
 100, 1, ARRAY[3,5,8], false, 270),

('4.1.3', 'büro', 4, '4.1',
 'Reinigung und Instandhaltungsfreundlichkeit',
 'Facilidad de limpieza y mantenimiento',
 'Cleaning and Maintenance Ease',
 'Bewertung der Reinigungsfreundlichkeit von Fassaden, Fußböden und technischen Anlagen sowie der Zugänglichkeit für Instandhaltungsarbeiten.',
 100, 1, ARRAY[3,5], false, 280),

('4.1.4', 'büro', 4, '4.1',
 'Rückbau, Trennung und Verwertung',
 'Deconstrucción, separación y valorización',
 'Deconstruction, Separation and Recycling',
 'Bewertung der Rückbaufreundlichkeit des Gebäudes: lösbare Verbindungen, Trennbarkeit von Materialien, Recyclingfähigkeit und Verwertbarkeit am Lebensende.',
 100, 1, ARRAY[3,5], false, 290),

('4.1.5', 'büro', 4, '4.1',
 'Widerstandsfähigkeit gegen Naturgefahren',
 'Resistencia ante peligros naturales',
 'Resilience to Natural Hazards',
 'Bewertung der Widerstandsfähigkeit des Gebäudes gegen Naturgefahren: Hochwasser, Wind, Schnee, Erdbeben und Starkregen entsprechend dem Standortrisiko.',
 100, 1, ARRAY[1,3], false, 300),

('4.1.6', 'büro', 4, '4.1',
 'Bedienungs- und Instandhaltungsfreundlichkeit der TGA',
 'Facilidad de operación y mantenimiento de instalaciones (TGA)',
 'HVAC/MEP Operation and Maintenance Ease',
 'Bewertung der Bedienungsfreundlichkeit und Zugänglichkeit der technischen Gebäudeausrüstung: Beschriftung, Dokumentation, Gebäudeautomation, Monitoring.',
 100, 1, ARRAY[3,5,8], false, 310),

-- ===========================================================================
-- ÁREA 5: Prozessqualität (Calidad de Proceso) — Peso total: 10%
-- Subcategoría 5.1: Planung
-- ===========================================================================

('5.1.1', 'büro', 5, '5.1',
 'Projektvorbereitung',
 'Preparación del proyecto',
 'Project Preparation',
 'Bewertung der Qualität der Projektvorbereitung: Bedarfsplanung, Nutzeranforderungen, Projekthandbuch, Aufstellung von Qualitätszielen und Nachhaltigkeitsanforderungen.',
 100, 1, ARRAY[1,2], false, 320),

('5.1.2', 'büro', 5, '5.1',
 'Integrale Planung',
 'Planificación integral (integrada)',
 'Integral Planning',
 'Bewertung der integralen Planung: interdisziplinäre Zusammenarbeit, frühe Einbindung aller Fachplaner, Simulationen und Optimierungsschleifen im Entwurfsprozess.',
 100, 1, ARRAY[1,2,3], false, 330),

('5.1.3', 'büro', 5, '5.1',
 'Komplexität und Optimierung der Planung',
 'Complejidad y optimización del diseño',
 'Planning Complexity and Optimization',
 'Bewertung der Planungsoptimierung: Variantenuntersuchungen, Simulationen (Energie, Licht, Akustik), Nachhaltigkeitszertifizierung als Planungsziel.',
 100, 1, ARRAY[3,5], false, 340),

('5.1.4', 'büro', 5, '5.1',
 'Ausschreibung und Vergabe',
 'Licitación y adjudicación',
 'Tendering and Contract Award',
 'Bewertung der Berücksichtigung von Nachhaltigkeitskriterien in Ausschreibungsunterlagen und Vergabeverfahren (ökologische, soziale und ökonomische Anforderungen).',
 100, 1, ARRAY[6,7], false, 350),

('5.1.5', 'büro', 5, '5.1',
 'Voraussetzungen für optimale Bewirtschaftung',
 'Condiciones para la gestión operativa óptima',
 'Prerequisites for Optimal Building Operation',
 'Bewertung der Maßnahmen zur Sicherstellung einer optimalen Bewirtschaftung: Betriebshandbuch, Nutzerhandbuch, Schulungen, Monitoring-Konzept.',
 100, 1, ARRAY[5,8], false, 360),

-- Subcategoría 5.2: Bauausführung

('5.2.1', 'büro', 5, '5.2',
 'Baustelle / Bauprozess',
 'Obra / Proceso de construcción',
 'Construction Site / Construction Process',
 'Bewertung des nachhaltigen Bauprozesses: Umweltmanagement auf der Baustelle, Lärm- und Staubschutz, Abfallmanagement, Ressourceneffizienz auf der Baustelle.',
 100, 1, ARRAY[7,8], false, 370),

('5.2.2', 'büro', 5, '5.2',
 'Qualitätssicherung der Bauausführung',
 'Control de calidad de la ejecución',
 'Construction Quality Assurance',
 'Bewertung der Qualitätssicherungsmaßnahmen während der Bauausführung: Qualitätsprüfungen, Abnahmen, Dokumentation von Abweichungen und Mängelbeseitigung.',
 100, 1, ARRAY[8], false, 380),

('5.2.3', 'büro', 5, '5.2',
 'Systematische Inbetriebnahme',
 'Puesta en marcha sistemática (commissioning)',
 'Systematic Commissioning',
 'Bewertung der systematischen Inbetriebnahme: funktionale Prüfung aller Systeme, Optimierung der Regelung, Messkampagnen und Dokumentation der Inbetriebnahme.',
 100, 1, ARRAY[8], false, 390),

-- ===========================================================================
-- ÁREA 6: Standortmerkmale (Características del Emplazamiento)
-- INFORMATIVA: no entra en puntaje total, max_points = 100 pero weight = 0
-- ===========================================================================

('6.1.1', 'büro', 6, '6.1',
 'Risiken am Mikrostandort',
 'Riesgos en el microemplazamiento',
 'Micro-Location Risks',
 'Erfassung und Bewertung von Risiken am Standort: Altlasten, Hochwassergefährdung, Lärm, Luftbelastung, elektromagnetische Felder und andere Umweltbelastungen.',
 100, 0, ARRAY[1], false, 400),

('6.1.2', 'büro', 6, '6.1',
 'Verhältnisse am Mikrostandort',
 'Condiciones del microemplazamiento',
 'Micro-Location Conditions',
 'Bewertung der natürlichen Verhältnisse am Standort: Besonnung, Verschattung, Windverhältnisse, Boden- und Grundwasserverhältnisse.',
 100, 0, ARRAY[1], false, 410),

('6.1.3', 'büro', 6, '6.1',
 'Quartiersmerkmale',
 'Características del barrio / entorno urbano',
 'Neighbourhood Characteristics',
 'Bewertung der städtebaulichen Qualität des Quartiers: Nutzungsmischung, öffentliche Räume, soziale Infrastruktur und Aufenthaltsqualität im Umfeld.',
 100, 0, ARRAY[1], false, 420),

('6.1.4', 'büro', 6, '6.1',
 'Verkehrsanbindung',
 'Conexión con el transporte público',
 'Transport Connectivity',
 'Bewertung der Anbindung an den öffentlichen Personennahverkehr (ÖPNV): Entfernung zu Haltestellen, Taktfrequenz, Vernetzung verschiedener Verkehrsmittel.',
 100, 0, ARRAY[1], false, 430),

('6.1.5', 'büro', 6, '6.1',
 'Nähe zu nutzungsrelevanten Objekten und Einrichtungen',
 'Proximidad a servicios y equipamientos relevantes',
 'Proximity to Relevant Facilities',
 'Bewertung der Nähe zu nutzungsrelevanten Einrichtungen: Gastronomie, Einkauf, Sport, Grünflächen, Kinderbetreuung und weitere nutzungsabhängige Infrastruktur.',
 100, 0, ARRAY[1], false, 440),

('6.1.6', 'büro', 6, '6.1',
 'Anliegende Medien / Erschließung',
 'Infraestructura de servicios / Acometidas',
 'Site Utilities and Infrastructure',
 'Bewertung der anliegenden Ver- und Entsorgungsinfrastruktur: Fernwärme/-kälte, Erdgas, Trinkwasser, Abwasser, Elektrizität und Potenzial für erneuerbare Energien.',
 100, 0, ARRAY[1], false, 450);

-- ===========================================================================
-- RESUMEN DE PESOS (Bedeutungszahlen) POR ÁREA
-- ===========================================================================
-- Área 1 — Ökologische Qualität (10 criterios):
--   BZ=3: 1.1.1 (GWP), 1.2.1 (Primärenergie)
--   BZ=2: 1.2.3 (Trinkwasser)
--   BZ=1: 1.1.2, 1.1.3, 1.1.4, 1.1.5, 1.1.6, 1.1.7, 1.2.4
--   Suma BZ: 3+1+1+1+1+1+1+3+2+1 = 15
--
-- Área 2 — Ökonomische Qualität (3 criterios):
--   BZ=3: 2.1.1 (LCC)
--   BZ=2: 2.2.1, 2.2.2
--   Suma BZ: 3+2+2 = 7
--
-- Área 3 — Soziokulturelle Qualität (12 criterios):
--   BZ=2: 3.1.1, 3.1.3, 3.1.4, 3.1.5, 3.2.1, 3.3.1
--   BZ=1: 3.1.6, 3.1.7, 3.1.8, 3.2.4, 3.2.5, 3.3.2
--   Suma BZ: 6×2 + 6×1 = 18
--
-- Área 4 — Technische Qualität (6 criterios):
--   BZ=2: 4.1.1 (Schallschutz)
--   BZ=1: 4.1.2, 4.1.3, 4.1.4, 4.1.5, 4.1.6
--   Suma BZ: 2+1+1+1+1+1 = 7
--
-- Área 5 — Prozessqualität (8 criterios):
--   BZ=1: todos
--   Suma BZ: 8
--
-- Área 6 — Standortmerkmale (6 criterios):
--   BZ=0: todos (informativa, no entra en puntaje)
-- ===========================================================================

-- ===========================================================================
-- FUNCIÓN AUXILIAR: cálculo de puntaje por área
-- ===========================================================================
-- Puntaje de área = SUM(score_criterio × BZ) / SUM(BZ) para criterios del área
-- Puntaje total = 0.225×(área1 + área2 + área3 + área4) + 0.10×área5
-- Niveles: Bronze ≥50% | Silber ≥65% | Gold ≥80%
-- ===========================================================================
