;; Dedicated mu-cl-resources configuration for health checks.
;; This service only exposes the seeded pm:Metric instance used by the
;; GET /health/metrics dispatcher route to verify database reachability.
(in-package :mu-cl-resources)

(defparameter *include-count-in-paginated-responses* t)

;; Disable caching: this resource serves a health check, so responses must be
;; fresh on every request (a cached response would mask a database outage).
(defparameter *cache-count-queries* nil)
(defparameter *supply-cache-headers-p* nil)
(setf *cache-model-properties-p* nil)

(define-resource metric ()
  :class (s-prefix "pm:Metric")
  :properties `(
    (:note :string ,(s-prefix "skos:note"))
  )
  :resource-base (s-url "http://data.lblod.info/id/health-checks/metric/")
  :features '(include-uri)
  :on-path "metrics")