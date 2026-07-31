(in-package :mu-cl-resources)

(defparameter *include-count-in-paginated-responses* t)

(define-resource metric ()
  :class (s-prefix "pm:Metric")
  :properties `(
    (:note :string ,(s-prefix "skos:note"))
  )
  :resource-base (s-url "http://data.lblod.info/id/health-checks/metric/")
  :features '(include-uri)
  :on-path "metrics")