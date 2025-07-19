(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-invalid-treaty (err u102))
(define-constant err-already-exists (err u103))
(define-constant err-not-authorized (err u104))

(define-data-var next-treaty-id uint u1)
(define-data-var next-validator-id uint u1)

(define-map treaties
    { treaty-id: uint }
    {
        title: (string-ascii 100),
        ipfs-hash: (string-ascii 46),
        timestamp: uint,
        creator: principal,
        status: (string-ascii 20),
        validator-count: uint
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

(define-public (register-validator)
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

(define-public (submit-treaty (title (string-ascii 100)) (ipfs-hash (string-ascii 46)))
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
                validator-count: u0
            }
        )
        (var-set next-treaty-id (+ treaty-id u1))
        (ok treaty-id)
    )
)

(define-public (validate-treaty (treaty-id uint))
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

(define-public (add-translation (treaty-id uint) (language (string-ascii 10)) (ipfs-hash (string-ascii 46)))
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

(define-read-only (get-treaty (treaty-id uint))
    (ok (unwrap! (map-get? treaties {treaty-id: treaty-id}) err-not-found))
)

(define-read-only (get-translation (treaty-id uint) (language (string-ascii 10)))
    (ok (unwrap! (map-get? translations {treaty-id: treaty-id, language: language}) err-not-found))
)

(define-read-only (get-validator-status (address principal))
    (ok (unwrap! (map-get? validators {address: address}) err-not-found))
)