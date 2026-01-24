(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-invalid-treaty (err u102))
(define-constant err-already-exists (err u103))
(define-constant err-not-authorized (err u104))
(define-constant err-amendment-exists (err u105))
(define-constant err-voting-closed (err u106))
(define-constant err-insufficient-votes (err u107))
(define-constant err-paused (err u108))
(define-constant err-violation-not-found (err u109))
(define-constant err-already-inactive (err u110))

(define-data-var next-treaty-id uint u1)
(define-data-var next-validator-id uint u1)
(define-data-var next-amendment-id uint u1)
(define-data-var next-violation-id uint u1)
(define-data-var paused bool false)

(define-map treaties
    { treaty-id: uint }
    {
        title: (string-ascii 100),
        ipfs-hash: (string-ascii 46),
        timestamp: uint,
        creator: principal,
        status: (string-ascii 20),
        validator-count: uint,
        expiration: uint
    }
)

(define-map treaty-validators
    { treaty-id: uint, validator: principal }
    { validated: bool }
)

(define-map validators
    { address: principal }
    {
        reputation: uint,
        validator-id: uint,
        active: bool
    }
)

(define-map translations
    { treaty-id: uint, language: (string-ascii 10) }
    {
        ipfs-hash: (string-ascii 46),
        translator: principal,
        verified: bool
    }
)

(define-map amendments
    { amendment-id: uint }
    {
        treaty-id: uint,
        description: (string-ascii 200),
        new-ipfs-hash: (string-ascii 46),
        proposer: principal,
        votes-for: uint,
        votes-against: uint,
        voting-deadline: uint,
        status: (string-ascii 20)
    }
)

(define-map amendment-votes
    { amendment-id: uint, voter: principal }
    { vote: bool }
)

(define-map violations
    { violation-id: uint }
    {
        treaty-id: uint,
        reporter: principal,
        description: (string-ascii 200),
        status: (string-ascii 20),
        reviewed-by: (optional principal)
    }
)

(define-public (register-validator)
    (begin
        (asserts! (not (var-get paused)) err-paused)
        (let
            ((validator-id (var-get next-validator-id)))
            (asserts! (is-none (map-get? validators {address: tx-sender})) err-already-exists)
            (map-set validators
                {address: tx-sender}
                {
                    reputation: u100,
                    validator-id: validator-id,
                    active: true
                }
            )
            (var-set next-validator-id (+ validator-id u1))
            (ok validator-id)
        )
    )
)

(define-public (deactivate-validator (validator-address principal))
    (begin
        (asserts! (not (var-get paused)) err-paused)
        (asserts! (or (is-eq tx-sender validator-address) (is-eq tx-sender contract-owner)) err-not-authorized)
        (let
            ((validator (unwrap! (map-get? validators {address: validator-address}) err-not-found)))
            (asserts! (get active validator) err-already-inactive)
            (map-set validators
                {address: validator-address}
                (merge validator {active: false})
            )
            (ok true)
        )
    )
)

(define-public (submit-treaty (title (string-ascii 100)) (ipfs-hash (string-ascii 46)) (expiration uint))
    (begin
        (asserts! (not (var-get paused)) err-paused)
        (let
            ((treaty-id (var-get next-treaty-id)))
            (asserts! (is-some (map-get? validators {address: tx-sender})) err-not-authorized)
            (map-set treaties
                {treaty-id: treaty-id}
                {
                    title: title,
                    ipfs-hash: ipfs-hash,
                    timestamp: burn-block-height,
                    creator: tx-sender,
                    status: "pending",
                    validator-count: u0,
                    expiration: expiration
                }
            )
            (var-set next-treaty-id (+ treaty-id u1))
            (ok treaty-id)
        )
    )
)

(define-public (validate-treaty (treaty-id uint))
    (begin
        (asserts! (not (var-get paused)) err-paused)
        (let
            ((validator (unwrap! (map-get? validators {address: tx-sender}) err-not-authorized))
             (treaty (unwrap! (map-get? treaties {treaty-id: treaty-id}) err-not-found)))
            (asserts! (is-none (map-get? treaty-validators {treaty-id: treaty-id, validator: tx-sender})) err-already-exists)
            (map-set treaty-validators
                {treaty-id: treaty-id, validator: tx-sender}
                {validated: true}
            )
            (map-set treaties
                {treaty-id: treaty-id}
                (merge treaty {validator-count: (+ (get validator-count treaty) u1)})
            )
            (map-set validators
                {address: tx-sender}
                (merge validator {reputation: (+ (get reputation validator) u10)})
            )
            (ok true)
        )
    )
)

(define-public (add-translation (treaty-id uint) (language (string-ascii 10)) (ipfs-hash (string-ascii 46)))
    (begin
        (asserts! (not (var-get paused)) err-paused)
        (let
            ((treaty (unwrap! (map-get? treaties {treaty-id: treaty-id}) err-not-found)))
            (asserts! (is-some (map-get? validators {address: tx-sender})) err-not-authorized)
            (map-set translations
                {treaty-id: treaty-id, language: language}
                {
                    ipfs-hash: ipfs-hash,
                    translator: tx-sender,
                    verified: false
                }
            )
            (ok true)
        )
    )
)

(define-read-only (get-treaty (treaty-id uint))
    (ok (unwrap! (map-get? treaties {treaty-id: treaty-id}) err-not-found))
)

(define-read-only (get-translation (treaty-id uint) (language (string-ascii 10)))
    (ok (unwrap! (map-get? translations {treaty-id: treaty-id, language: language}) err-not-found))
)

(define-read-only (get-validator-status (address principal))
    (ok (unwrap! (map-get? validators {address: address}) err-not-found))
)

(define-public (propose-amendment (treaty-id uint) (description (string-ascii 200)) (new-ipfs-hash (string-ascii 46)) (voting-period uint))
    (begin
        (asserts! (not (var-get paused)) err-paused)
        (let
            ((amendment-id (var-get next-amendment-id))
             (treaty (unwrap! (map-get? treaties {treaty-id: treaty-id}) err-not-found)))
            (asserts! (is-some (map-get? validators {address: tx-sender})) err-not-authorized)
            (map-set amendments
                {amendment-id: amendment-id}
                {
                    treaty-id: treaty-id,
                    description: description,
                    new-ipfs-hash: new-ipfs-hash,
                    proposer: tx-sender,
                    votes-for: u0,
                    votes-against: u0,
                    voting-deadline: (+ burn-block-height voting-period),
                    status: "voting"
                }
            )
            (var-set next-amendment-id (+ amendment-id u1))
            (ok amendment-id)
        )
    )
)

(define-public (vote-amendment (amendment-id uint) (support bool))
    (begin
        (asserts! (not (var-get paused)) err-paused)
        (let
            ((amendment (unwrap! (map-get? amendments {amendment-id: amendment-id}) err-not-found))
             (validator (unwrap! (map-get? validators {address: tx-sender}) err-not-authorized)))
            (asserts! (> (get voting-deadline amendment) burn-block-height) err-voting-closed)
            (asserts! (is-none (map-get? amendment-votes {amendment-id: amendment-id, voter: tx-sender})) err-already-exists)
            (map-set amendment-votes
                {amendment-id: amendment-id, voter: tx-sender}
                {vote: support}
            )
            (if support
                (map-set amendments
                    {amendment-id: amendment-id}
                    (merge amendment {votes-for: (+ (get votes-for amendment) u1)})
                )
                (map-set amendments
                    {amendment-id: amendment-id}
                    (merge amendment {votes-against: (+ (get votes-against amendment) u1)})
                )
            )
            (ok true)
        )
    )
)

(define-public (finalize-amendment (amendment-id uint))
    (begin
        (asserts! (not (var-get paused)) err-paused)
        (let
            ((amendment (unwrap! (map-get? amendments {amendment-id: amendment-id}) err-not-found))
             (treaty (unwrap! (map-get? treaties {treaty-id: (get treaty-id amendment)}) err-not-found)))
            (asserts! (<= (get voting-deadline amendment) burn-block-height) err-voting-closed)
            (asserts! (is-eq (get status amendment) "voting") err-voting-closed)
            (if (> (get votes-for amendment) (get votes-against amendment))
                (begin
                    (map-set treaties
                        {treaty-id: (get treaty-id amendment)}
                        (merge treaty {ipfs-hash: (get new-ipfs-hash amendment)})
                    )
                    (map-set amendments
                        {amendment-id: amendment-id}
                        (merge amendment {status: "approved"})
                    )
                    (ok "approved")
                )
                (begin
                    (map-set amendments
                        {amendment-id: amendment-id}
                        (merge amendment {status: "rejected"})
                    )
                    (ok "rejected")
                )
            )
        )
    )
)

(define-public (pause-contract)
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (var-set paused true)
        (ok true)
    )
)

(define-public (unpause-contract)
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (var-set paused false)
        (ok true)
    )
)

(define-public (report-violation (treaty-id uint) (description (string-ascii 200)))
    (begin
        (asserts! (not (var-get paused)) err-paused)
        (let
            ((violation-id (var-get next-violation-id)))
            (asserts! (is-some (map-get? treaties {treaty-id: treaty-id})) err-not-found)
            (map-set violations
                {violation-id: violation-id}
                {
                    treaty-id: treaty-id,
                    reporter: tx-sender,
                    description: description,
                    status: "pending",
                    reviewed-by: none
                }
            )
            (var-set next-violation-id (+ violation-id u1))
            (ok violation-id)
        )
    )
)

(define-public (review-violation (violation-id uint) (confirm bool))
    (begin
        (asserts! (not (var-get paused)) err-paused)
        (let
            ((violation (unwrap! (map-get? violations {violation-id: violation-id}) err-violation-not-found))
             (validator (unwrap! (map-get? validators {address: tx-sender}) err-not-authorized)))
            (asserts! (is-eq (get status violation) "pending") err-already-exists)
            (map-set violations
                {violation-id: violation-id}
                (merge violation
                    {
                        status: (if confirm "confirmed" "rejected"),
                        reviewed-by: (some tx-sender)
                    }
                )
            )
            (ok true)
        )
    )
)

(define-read-only (get-amendment (amendment-id uint))
    (ok (unwrap! (map-get? amendments {amendment-id: amendment-id}) err-not-found))
)

(define-read-only (get-amendment-vote (amendment-id uint) (voter principal))
    (ok (map-get? amendment-votes {amendment-id: amendment-id, voter: voter}))
)

(define-read-only (get-violation (violation-id uint))
    (ok (unwrap! (map-get? violations {violation-id: violation-id}) err-violation-not-found))
)

(define-public (extend-treaty-expiration (treaty-id uint) (new-expiration uint))
    (begin
        (asserts! (not (var-get paused)) err-paused)
        (let
            ((treaty (unwrap! (map-get? treaties {treaty-id: treaty-id}) err-not-found)))
            (asserts! (is-eq (get creator treaty) tx-sender) err-not-authorized)
            (asserts! (> new-expiration (get expiration treaty)) err-invalid-treaty)
            (map-set treaties
                {treaty-id: treaty-id}
                (merge treaty {expiration: new-expiration})
            )
            (ok true)
        )
    )
)

(define-read-only (is-treaty-expired (treaty-id uint))
    (let
        ((treaty (unwrap! (map-get? treaties {treaty-id: treaty-id}) err-not-found)))
        (ok (> burn-block-height (get expiration treaty)))
    )
)
