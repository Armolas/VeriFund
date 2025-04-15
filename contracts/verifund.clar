
;; title: VeriFund
;; version: 1.0.0
;; summary: VeriFund is a decentralized crowdfunding platform built on the Stacks blockchain, designed to make fundraising transparent, trackable, and truly accountable.
;; description:

;; traits
;;

;; token definitions
;;

;; constants
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
(define-map funders_by_campaign uint (list 10 principal))
(define-map milestone_approvals {campaign_id: uint, milestone_index: uint} {approvals: uint, required_approvals: uint, voters: (list 10 principal)})
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

;; read only functions
;;

;; private functions
;;

