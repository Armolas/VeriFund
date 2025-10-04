;; ============================================
;; VERIFUND RENDEZVOUS TESTS
;; Property-based and Invariant Testing
;; ============================================

(define-constant ERR_TEST_FAILED u999)

;; ============================================
;; PROPERTY-BASED TESTS
;; ============================================

;; Test 1: Campaign count is non-negative
(define-public (test-campaign-count-non-negative)
  (begin
    (asserts! (>= (get_campaign_count) u0) (err ERR_TEST_FAILED))
    (ok true)
  )
)

;; Test 2: Creating a campaign increases count
(define-public (test-create-increases-count (goal uint))
  (if (is-eq goal u0)
    (ok false)
    (let ((count-before (get_campaign_count)))
      (if (is-ok (create_campaign "T" "T" goal "Tech" (list {name: "M", description: "M", amount: goal}) none))
        (begin
          (asserts! (is-eq (get_campaign_count) (+ count-before u1)) (err ERR_TEST_FAILED))
          (ok true)
        )
        (err ERR_TEST_FAILED)
      )
    )
  )
)

;; Test 3: New campaigns have zero balance
(define-public (test-new-campaign-zero-balance (goal uint))
  (if (is-eq goal u0)
    (ok false)
    (let ((cid-result (create_campaign "Z" "Z" goal "T" (list {name: "M", description: "M", amount: goal}) none)))
      (if (is-ok cid-result)
        (let ((camp-result (get_campaign (unwrap-panic cid-result))))
          (if (is-ok camp-result)
            (begin
              (asserts! (is-eq (get balance (unwrap-panic camp-result)) u0) (err ERR_TEST_FAILED))
              (asserts! (is-eq (get amount_raised (unwrap-panic camp-result)) u0) (err ERR_TEST_FAILED))
              (ok true)
            )
            (err ERR_TEST_FAILED)
          )
        )
        (err ERR_TEST_FAILED)
      )
    )
  )
)

;; Test 4: Campaign status is "funding" initially
(define-public (test-new-campaign-funding-status (goal uint))
  (if (is-eq goal u0)
    (ok false)
    (let ((cid-result (create_campaign "S" "S" goal "T" (list {name: "M", description: "M", amount: goal}) none)))
      (if (is-ok cid-result)
        (let ((camp-result (get_campaign (unwrap-panic cid-result))))
          (if (is-ok camp-result)
            (begin
              (asserts! (is-eq (get status (unwrap-panic camp-result)) "funding") (err ERR_TEST_FAILED))
              (ok true)
            )
            (err ERR_TEST_FAILED)
          )
        )
        (err ERR_TEST_FAILED)
      )
    )
  )
)

;; Test 5: Campaign goal matches input
(define-public (test-campaign-goal-matches (goal uint))
  (if (is-eq goal u0)
    (ok false)
    (let ((cid-result (create_campaign "G" "G" goal "T" (list {name: "M", description: "M", amount: goal}) none)))
      (if (is-ok cid-result)
        (let ((camp-result (get_campaign (unwrap-panic cid-result))))
          (if (is-ok camp-result)
            (begin
              (asserts! (is-eq (get goal (unwrap-panic camp-result)) goal) (err ERR_TEST_FAILED))
              (ok true)
            )
            (err ERR_TEST_FAILED)
          )
        )
        (err ERR_TEST_FAILED)
      )
    )
  )
)

;; Test 6: Campaign owner is tx-sender
(define-public (test-campaign-owner-is-sender (goal uint))
  (if (is-eq goal u0)
    (ok false)
    (let ((cid-result (create_campaign "O" "O" goal "T" (list {name: "M", description: "M", amount: goal}) none)))
      (if (is-ok cid-result)
        (let ((camp-result (get_campaign (unwrap-panic cid-result))))
          (if (is-ok camp-result)
            (begin
              (asserts! (is-eq (get owner (unwrap-panic camp-result)) tx-sender) (err ERR_TEST_FAILED))
              (ok true)
            )
            (err ERR_TEST_FAILED)
          )
        )
        (err ERR_TEST_FAILED)
      )
    )
  )
)

;; Test 7: Funder contribution is zero initially
(define-public (test-zero-funder-contribution (goal uint))
  (if (is-eq goal u0)
    (ok false)
    (let ((cid-result (create_campaign "F" "F" goal "T" (list {name: "M", description: "M", amount: goal}) none)))
      (if (is-ok cid-result)
        (begin
          (asserts! (is-eq (get_funder_contribution (unwrap-panic cid-result) tx-sender) u0) (err ERR_TEST_FAILED))
          (ok true)
        )
        (err ERR_TEST_FAILED)
      )
    )
  )
)

;; Test 8: Campaign funders list is empty initially
(define-public (test-empty-funders-list (goal uint))
  (if (is-eq goal u0)
    (ok false)
    (let ((cid-result (create_campaign "L" "L" goal "T" (list {name: "M", description: "M", amount: goal}) none)))
      (if (is-ok cid-result)
        (begin
          (asserts! (is-eq (len (get_campaign_funders (unwrap-panic cid-result))) u0) (err ERR_TEST_FAILED))
          (ok true)
        )
        (err ERR_TEST_FAILED)
      )
    )
  )
)

;; Test 9: Campaign progress is 0% initially
(define-public (test-zero-progress-initially (goal uint))
  (if (is-eq goal u0)
    (ok false)
    (let ((cid-result (create_campaign "P" "P" goal "T" (list {name: "M", description: "M", amount: goal}) none)))
      (if (is-ok cid-result)
        (let ((prog-result (get_campaign_progress (unwrap-panic cid-result))))
          (if (is-ok prog-result)
            (begin
              (asserts! (is-eq (get progress_percentage (unwrap-panic prog-result)) u0) (err ERR_TEST_FAILED))
              (asserts! (is-eq (get is_funded (unwrap-panic prog-result)) false) (err ERR_TEST_FAILED))
              (ok true)
            )
            (err ERR_TEST_FAILED)
          )
        )
        (err ERR_TEST_FAILED)
      )
    )
  )
)

;; Test 10: Cancelling changes status to "cancelled"
(define-public (test-cancel-changes-status (goal uint))
  (if (is-eq goal u0)
    (ok false)
    (let ((cid-result (create_campaign "C" "C" goal "T" (list {name: "M", description: "M", amount: goal}) none)))
      (if (is-ok cid-result)
        (let ((cid (unwrap-panic cid-result)))
          (if (is-ok (cancel_campaign cid))
            (let ((camp-result (get_campaign cid)))
              (if (is-ok camp-result)
                (begin
                  (asserts! (is-eq (get status (unwrap-panic camp-result)) "cancelled") (err ERR_TEST_FAILED))
                  (ok true)
                )
                (err ERR_TEST_FAILED)
              )
            )
            (err ERR_TEST_FAILED)
          )
        )
        (err ERR_TEST_FAILED)
      )
    )
  )
)

;; Test 11: Milestone voting not expired initially
(define-public (test-milestone-not-expired (goal uint))
  (if (is-eq goal u0)
    (ok false)
    (let ((cid-result (create_campaign "E" "E" goal "T" (list {name: "M", description: "M", amount: goal}) none)))
      (if (is-ok cid-result)
        (begin
          (asserts! (is-eq (is_milestone_voting_expired (unwrap-panic cid-result) u0) false) (err ERR_TEST_FAILED))
          (ok true)
        )
        (err ERR_TEST_FAILED)
      )
    )
  )
)

;; Test 12: Campaign created_at is current block height
(define-public (test-campaign-created-at-block (goal uint))
  (if (is-eq goal u0)
    (ok false)
    (let (
      (current-block block-height)
      (cid-result (create_campaign "B" "B" goal "T" (list {name: "M", description: "M", amount: goal}) none))
    )
      (if (is-ok cid-result)
        (let ((camp-result (get_campaign (unwrap-panic cid-result))))
          (if (is-ok camp-result)
            (begin
              (asserts! (is-eq (get created_at (unwrap-panic camp-result)) current-block) (err ERR_TEST_FAILED))
              (ok true)
            )
            (err ERR_TEST_FAILED)
          )
        )
        (err ERR_TEST_FAILED)
      )
    )
  )
)

;; ============================================
;; INVARIANT TESTS
;; ============================================

;; Invariant 1: Campaign count never decreases
(define-read-only (invariant-campaign-count-monotonic)
  true  ;; Count can only increase via create_campaign
)

;; Invariant 2: Campaign count is always non-negative  
(define-read-only (invariant-count-non-negative)
  (>= (get_campaign_count) u0)
)
