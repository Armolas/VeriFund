
;; title: VeriFund
;; version: 1.0.0
;; summary: VeriFund is a decentralized crowdfunding platform built on the Stacks blockchain, designed to make fundraising transparent, trackable, and truly accountable.
;; description:

;; traits
;;

;; token definitions
;;

;; constants
(define-constant ERR-CAMPAIGN-NOT-FOUND u0)
(define-constant ERR-MILESTONE-DOES-NOT-EXIST u1)
(define-constant ERR-MILESTONE-ALREADY-COMPLETED u2)
(define-constant ERR-MILESTONE-ALREADY-APPROVED u3)
(define-constant ERR-NOT-A-FUNDER u4)
(define-constant ERR-NOT-OWNER u5)
(define-constant ERR-CANNOT-ADD-FUNDER u6)
;;


;; data vars
(define-data-var campaign_count uint u0)
;;

;; data maps
(define-map campaigns uint {
    name: (string-ascii 100),
    description: (string-ascii 500),
    goal: uint,
    amount_raised: uint,
    balance: uint,
    owner: principal,
    milestones: (list 10 {
        name: (string-ascii 100),
        amount: uint,
        completed: bool
        }),
    proposal_link: (optional (string-ascii 200)),
    })

(define-map funders {campaign_id: uint, funder: principal} uint)
(define-map funders_by_campaign uint (list 50 principal))
(define-map milestone_approvals {campaign_id: uint, milestone_index: uint} {approvals: uint, voters: (list 50 principal)})
;;

;; public functions
;;
(define-public (create_campaign (name (string-ascii 100)) (description (string-ascii 500)) (goal uint) (milestones (list 10 {name: (string-ascii 100), amount: uint, completed: bool})) (proposal_link (optional (string-ascii 200))))
    (let ((campaign_id (var-get campaign_count)))
        (begin
            (map-set campaigns campaign_id {
                name: name,
                description: description,
                goal: goal,
                amount_raised: u0,
                balance: u0,
                owner: tx-sender,
                milestones: milestones,
                proposal_link: proposal_link
            })
            (var-set campaign_count (+ campaign_id u1))
            (ok campaign_id)
        )
    )
)

(define-public (fund_campaign (campaign_id uint) (amount uint))
    (let (
        (campaign (unwrap! (map-get? campaigns campaign_id) (err ERR-CAMPAIGN-NOT-FOUND)))
        (amount_raised (get amount_raised campaign))
        (balance (get balance campaign))
        (funded_amount (default-to u0 (map-get? funders {campaign_id: campaign_id, funder: tx-sender})))
        (campaign_funders (default-to (list ) (map-get? funders_by_campaign campaign_id)))
    )
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        (map-set funders {campaign_id: campaign_id, funder: tx-sender} (+ funded_amount amount))
        (if (is-none (index-of? campaign_funders tx-sender))
            (map-set funders_by_campaign campaign_id (unwrap! (as-max-len? (append campaign_funders tx-sender) u50) (err ERR-CANNOT-ADD-FUNDER)))
            true
        )
        (ok (map-set campaigns campaign_id (merge campaign {
            amount_raised: (+ amount_raised amount),
            balance: (+ balance amount)
        })))
    )
)

(define-public (approve-milestone (campaign_id uint) (milestone_index uint))
    (let (
        (campaign (unwrap! (map-get? campaigns campaign_id) (err ERR-CAMPAIGN-NOT-FOUND)))
        (milestones (get milestones campaign))
        (milestone (unwrap! (element-at? milestones milestone_index) (err ERR-MILESTONE-DOES-NOT-EXIST)))
        (approvals (default-to {approvals: u0, voters: (list )} (map-get? milestone_approvals {campaign_id: campaign_id, milestone_index: milestone_index})))
        (campaign_funders (default-to (list ) (map-get? funders_by_campaign campaign_id)))
        (amount_funded (default-to u0 (map-get? funders {campaign_id: campaign_id, funder: tx-sender})))
        (voters (get voters approvals))
    )   
        (asserts! (is-some (index-of? campaign_funders tx-sender)) (err ERR-NOT-A-FUNDER))
        (asserts! (not (is-some (index-of? voters tx-sender))) (err ERR-MILESTONE-ALREADY-APPROVED))
        (ok (map-set milestone_approvals {campaign_id: campaign_id, milestone_index: milestone_index} {
            approvals: (+ (get approvals approvals) amount_funded),
            voters: (unwrap! (as-max-len? (append voters tx-sender) u50) (err ERR-MILESTONE-ALREADY-APPROVED))
        }))
    )
)

;; read only functions
;;

(define-read-only (get_campaign (campaign_id uint))
    (let ((campaign (map-get? campaigns campaign_id)))
        (if (is-none campaign)
            (err ERR-CAMPAIGN-NOT-FOUND)
            (ok (unwrap! campaign (err ERR-CAMPAIGN-NOT-FOUND)))
        )
    )
)

(define-read-only (get_campaign_milestone (campaign_id uint) (milestone_index uint))
    (let ((campaign (unwrap! (map-get? campaigns campaign_id) (err ERR-CAMPAIGN-NOT-FOUND)))
          (milestones (get milestones campaign))
          (milestone (element-at? milestones milestone_index)))
                (if (is-none milestone)
                    (err ERR-MILESTONE-DOES-NOT-EXIST)
                    (ok (unwrap! milestone (err ERR-CAMPAIGN-NOT-FOUND)))
                )
            )
        )

;; private functions
;;

