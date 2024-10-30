;;;;;;;;;;;;;;;;;;;
;;; delta messenger
(in-package :delta-messenger)

(add-delta-logger)
(add-delta-messenger "http://delta-notifier/")

;;;;;;;;;;;;;;;;;
;;; configuration
(in-package :client)
(setf *log-sparql-query-roundtrip* t)
(setf *backend* "http://triplestore:8890/sparql")

(in-package :server)
(setf *log-incoming-requests-p* t)


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
  :service "http://services.semantic.works/")

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
  :query "PREFIX session: <http://mu.semte.ch/vocabularies/session/>
          PREFIX veeakker: <http://veeakker.be/vocabularies/shop/>
          PREFIX mu: <http://mu.semte.ch/vocabularies/core/>
          SELECT ?id WHERE {
          <SESSION_ID> session:account/^foaf:account ?person.
          GRAPH <http://veeakker.be/graphs/administrators> {
            ?person veeakker:role veeakker:Administrator.
          }
         }"
  :parameters ())

(define-graph session-graph ("http://mu.semte.ch/graphs/sessions/")
  (_ -> _))

(grant (read write)
       :to dwh-reporting
       :for "dwh-m2m")

(supply-allowed-group "public")

(with-scope "service:m2m-login"
  (grant (read write)
         :to session-graph
         :for "public"))
