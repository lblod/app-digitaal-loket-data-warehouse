;;;;;;;;;;;;;;;;;;;
;;; delta messenger
(in-package :delta-messenger)

;; (add-delta-logger)
(add-delta-messenger "http://delta-notifier/")

;;;;;;;;;;;;;;;;;
;;; configuration
(in-package :client)
(setf *log-sparql-query-roundtrip* nil)
(setf *backend* "http://triplestore:8890/sparql")

(in-package :server)
(setf *log-incoming-requests-p* t)

;;;;;;;;;;;;;;;;
;;; prefix types
(in-package :type-cache)

(add-type-for-prefix "http://mu.semte.ch/sessions/" "http://mu.semte.ch/vocabularies/session/Session")

;;;;;;;;;;;;;;;;;
;;; access rights
(in-package :acl)

(define-prefixes
  :mon "http://lblod.data.gift/vocabularies/monitoring/"
  :nmo "http://www.semanticdesktop.org/ontologies/2007/03/22/nmo#"
  :nfo "http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#"
  :nie "http://www.semanticdesktop.org/ontologies/2007/01/19/nie#"
  :cogs "http://vocab.deri.ie/cogs#"
  :task "http://redpencil.data.gift/vocabularies/tasks/"
  :oslc "http://open-services.net/ns/core#"
  :ext "http://mu.semte.ch/vocabularies/ext/"
  :besluit "http://data.vlaanderen.be/ns/besluit#"
  :employee "http://lblod.data.gift/vocabularies/employee/"
  :leidinggevenden "http://data.lblod.info/vocabularies/leidinggevenden/"
  :locn "http://www.w3.org/ns/locn#"
  :mandaat "http://data.vlaanderen.be/ns/mandaat#"
  :org "http://www.w3.org/ns/org#"
  :person "http://www.w3.org/ns/person#"
  :persoon "https://data.vlaanderen.be/ns/persoon#"
  :prov "http://www.w3.org/ns/prov#"
  :schema "http://schema.org/"
  :generiek "https://data.vlaanderen.be/ns/generiek#"
  :skos "http://www.w3.org/2004/02/skos/core#"
  :organisatie "http://lblod.data.gift/vocabularies/organisatie/"
  :ere "http://data.lblod.info/vocabularies/erediensten/"
  :ch "http://data.lblod.info/vocabularies/contacthub/"
  :service "http://services.semantic.works/"
  ;; internal use
  :foaf "http://xmlns.com/foaf/0.1/"
  :mu "http://mu.semte.ch/vocabularies/core/"
  :adms "http://www.w3.org/ns/adms#"
  :musession "http://mu.semte.ch/vocabularies/session/"
  :muaccount "http://mu.semte.ch/vocabularies/account/")

(define-graph dwh-reporting ("http://mu.semte.ch/graphs/datawarehouse")
   ;; PERSONEEL
   ("employee:EmployeeTimePeriod" -> _)
   ("employee:UnitMeasure" -> _)
   ("employee:EducationalLevel" -> _)
   ("employee:WorkingTimeCategory" -> _)
   ("employee:LegalStatus" -> _)
   ("employee:EmployeeDataset" -> _)
   ("employee:EmployeePeriodSlice" -> _)
   ("employee:EmployeeObservation" -> _)

   ;; LEIDINGGEVENDEN
   ("schema:ContactPoint" -> _)
   ("locn:Address" -> _)
   ("leidinggevenden:Bestuursfunctie" -> _)
   ("leidinggevenden:Functionaris" -> _)
   ("leidinggevenden:FunctionarisStatusCode" -> _)

   ;; MANDATEN
   ("mandaat:Mandataris" -> _)
   ("org:Post" -> _)
   ("mandaat:TijdsgebondenEntiteit" -> _)
   ("mandaat:Fractie" -> _)
   ("persoon:Geboorte" -> _)
   ("org:Membership" -> _)
   ("mandaat:Mandaat" -> _)
   ("ext:MandatarisStatusCode" -> _)
   ("ext:BeleidsdomeinCode" -> _)
   ("org:Organization" -> _)
   ("schema:PostalAddress" -> _)
   ("org:Role" -> _)
   ("org:Site" -> _)

   ;; SHARED
   ("besluit:Bestuurseenheid" -> _)
   ("ext:BestuurseenheidClassificatieCode" -> _)
   ("besluit:Bestuursorgaan" -> _)
   ("ext:BestuursorgaanClassificatieCode" -> _)
   ("ext:BestuursfunctieCode" -> _)
   ("person:Person" -> _)
   ("prov:Location" -> _)
   ("ext:GeslachtCode" -> _)
   ("generiek:GestructureerdeIdentificator" -> _)

   ;; CONCEPT SCHEMES (from op-public)
   ("skos:Concept" -> _)
   ("organisatie:TypeEredienst" -> _)
   ("organisatie:Veranderingsgebeurtenis" -> _)
   ("organisatie:OrganisatieStatusCode" -> _)

   ;; EREDIENSTEN (worship services — Loket-specific, not in OP model)
   ("ere:BestuurVanDeEredienst" -> _)
   ("ere:CentraalBestuurVanDeEredienst" -> _)
   ("ere:RepresentatiefOrgaan" -> _)
   ("ere:PositieBedienaar" -> _)
   ("ere:RolBedienaar" -> _)
   ("ere:EredienstMandataris" -> _)
   ("organisatie:EredienstBeroepen" -> _)
   ("organisatie:TypeBetrokkenheid" -> _)
   ("ch:AgentInPositie" -> _))

(define-graph monitoring-graph ("http://mu.semte.ch/graphs/system/monitoring")
  ("mon:MonitoringRun" -> _)
  ("mon:Observation" -> _)
  ("mon:Anomaly" -> _))

(define-graph email-graph ("http://mu.semte.ch/graphs/system/email")
  ("nmo:Email" -> _)
  ("nmo:Mailbox" -> _)
  ("nfo:Folder" -> _))

(define-graph jobs-graph ("http://mu.semte.ch/graphs/system/jobs")
  ("cogs:Job" -> _)
  ("task:Task" -> _)
  ("cogs:ScheduledJob" -> _)
  ("task:ScheduledTask" -> _)
  ("task:CronSchedule" -> _)
  ("oslc:Error" -> _))

(supply-allowed-group "dwh-m2m"
  :query "PREFIX mu: <http://mu.semte.ch/vocabularies/core/>
          PREFIX foaf: <http://xmlns.com/foaf/0.1/>
          PREFIX muSession: <http://mu.semte.ch/vocabularies/session/>
          PREFIX adms: <http://www.w3.org/ns/adms#>
          PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
          SELECT ?claim WHERE {
            GRAPH <http://mu.semte.ch/graphs/sessions/> {
              <SESSION_ID> muSession:account/^foaf:account/adms:identifier/skos:notation ?claim.
            }
          }"
  :parameters ())

(define-graph session-graph ("http://mu.semte.ch/graphs/sessions/")
  ("musession:Session"
   -> "musession:account")
  ("foaf:OnlineAccount"
   -> "rdf:type"
   -> "mu:uuid"
   -> "muaccount:createdAt")
  ("foaf:Agent"
   -> "rdf:type"
   -> "mu:uuid"
   -> "adms:identifier"
   -> "foaf:account")
  ("adms:Identifier"
   -> "rdf:type"
   -> "mu:uuid"
   -> "skos:notation"))

(grant (read write)
       :to dwh-reporting
       :for "dwh-m2m")

(supply-allowed-group "public")

(with-scope "service:m2m-login"
  (grant (read write)
         :to session-graph
         :for "public"))

(with-scope "service:data-monitoring"
  (grant (read)
         :to dwh-reporting
         :for "public")
  (grant (read write)
         :to monitoring-graph
         :for "public")
  (grant (read write)
         :to jobs-graph
         :for "public")
  (grant (read write)
         :to email-graph
         :for "public"))
