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
                        "http://lblod.data.gift/vocabularies/employee/EmployeeTimePeriod",
                        "http://lblod.data.gift/vocabularies/employee/UnitMeasure",
                        "http://lblod.data.gift/vocabularies/employee/EducationalLevel",
                        "http://lblod.data.gift/vocabularies/employee/WorkingTimeCategory",
                        "http://lblod.data.gift/vocabularies/employee/LegalStatus",
                        "http://lblod.data.gift/vocabularies/employee/EmployeeDataset",
                        "http://lblod.data.gift/vocabularies/employee/EmployeePeriodSlice",
                        "http://lblod.data.gift/vocabularies/employee/EmployeeObservation",
                        "http://mu.semte.ch/vocabularies/ext/GeslachtCode",
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