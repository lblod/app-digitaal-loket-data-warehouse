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
  :ext "http://mu.semte.ch/vocabularies/ext/"
  :besluit "http://data.vlaanderen.be/ns/besluit#"
  :employee "http://lblod.data.gift/vocabularies/employee/"
  :leidinggevenden "http://data.lblod.info/vocabularies/leidinggevenden/"
  :locn "http://www.w3.org/ns/locn#"
  :mandaat "http://data.vlaanderen.be/ns/mandaat#"
  :org "http://www.w3.org/ns/org#"
  :person "http://www.w3.org/ns/person#"
  :persoon "http://data.vlaanderen.be/ns/persoon#"
  :prov "http://www.w3.org/ns/prov#"
  :schema "http://schema.org/"
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
   ("ext:GeslachtCode" -> _))

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
