alias Acl.Accessibility.Always, as: AlwaysAccessible
alias Acl.GraphSpec.Constraint.Resource, as: ResourceConstraint
alias Acl.GraphSpec, as: GraphSpec
alias Acl.GroupSpec, as: GroupSpec
alias Acl.GroupSpec.GraphCleanup, as: GraphCleanup

defmodule Acl.UserGroups.Config do
  def user_groups do
    [
      # // PUBLIC
      %GroupSpec{
        name: "public",
        useage: [:read],
        access: %AlwaysAccessible{},
        graphs: [ %GraphSpec{
                    graph: "http://mu.semte.ch/graphs/public",
                    constraint: %ResourceConstraint{
                      resource_types: [
                        # // PERSONEEL
                        "http://lblod.data.gift/vocabularies/employee/EmployeeTimePeriod",
                        "http://lblod.data.gift/vocabularies/employee/UnitMeasure",
                        "http://lblod.data.gift/vocabularies/employee/EducationalLevel",
                        "http://lblod.data.gift/vocabularies/employee/WorkingTimeCategory",
                        "http://lblod.data.gift/vocabularies/employee/LegalStatus",
                        "http://lblod.data.gift/vocabularies/employee/EmployeeDataset",
                        "http://lblod.data.gift/vocabularies/employee/EmployeePeriodSlice",
                        "http://lblod.data.gift/vocabularies/employee/EmployeeObservation",

                        # // LEIDINGGENDEN
                        "http://schema.org/ContactPoint",
                        "http://www.w3.org/ns/locn#Address",
                        "http://data.lblod.info/vocabularies/leidinggevenden/Bestuursfunctie",
                        "http://data.lblod.info/vocabularies/leidinggevenden/Functionaris",
                        "http://data.lblod.info/vocabularies/leidinggevenden/FunctionarisStatusCode",

                        # // MANDATEN
                        "http://data.vlaanderen.be/ns/mandaat#Mandataris",
                        "http://www.w3.org/ns/org#Post",
                        "http://data.vlaanderen.be/ns/mandaat#TijdsgebondenEntiteit",
                        "http://data.vlaanderen.be/ns/mandaat#Fractie",
                        "http://data.vlaanderen.be/ns/persoon#Geboorte",
                        "http://www.w3.org/ns/org#Membership",
                        "http://data.vlaanderen.be/ns/mandaat#Mandaat",
                        "http://mu.semte.ch/vocabularies/ext/MandatarisStatusCode",
                        "http://mu.semte.ch/vocabularies/ext/BeleidsdomeinCode",
                        "http://www.w3.org/ns/org#Organization",
                        "http://schema.org/PostalAddress",
                        "http://www.w3.org/ns/org#Role",
                        "http://www.w3.org/ns/org#Site",

                        # // SHARED
                        "http://data.vlaanderen.be/ns/besluit#Bestuurseenheid",
                        "http://mu.semte.ch/vocabularies/ext/BestuurseenheidClassificatieCode",
                        "http://data.vlaanderen.be/ns/besluit#Bestuursorgaan",
                        "http://mu.semte.ch/vocabularies/ext/BestuursorgaanClassificatieCode",
                        "http://mu.semte.ch/vocabularies/ext/BestuursfunctieCode",
                        "http://www.w3.org/ns/person#Person",
                        "http://www.w3.org/ns/prov#Location",
                        "http://mu.semte.ch/vocabularies/ext/GeslachtCode"
                      ]
                    } } ] },
      # // CLEANUP
      #
      %GraphCleanup{
        originating_graph: "http://mu.semte.ch/application",
        useage: [:write],
        name: "clean"
      }
    ]
  end
end