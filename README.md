A decentralized platform preserving diplomatic history and peace agreements on the Stacks blockchain.

## 🎯 Core Features

- 📜 Treaty submission and storage with IPFS integration
- ✅ Validator registration and reputation system
- 🌐 Multi-language translation support
- 🔍 Transparent verification process

## 🚀 Getting Started

### Prerequisites

- Clarinet
- Stacks wallet

### Contract Functions

1. **Register as Validator**
```clarity
(contract-call? .diplomatic-ledger register-validator)
```

2. **Submit Treaty**
```clarity
(contract-call? .diplomatic-ledger submit-treaty "Treaty Title" "ipfs-hash")
```

3. **Validate Treaty**
```clarity
(contract-call? .diplomatic-ledger validate-treaty treaty-id)
```

4. **Add Translation**
```clarity
(contract-call? .diplomatic-ledger add-translation treaty-id "lang-code" "ipfs-hash")
```

## 📖 Read-Only Functions

- `get-treaty`: Retrieve treaty details
- `get-translation`: Get translation information
- `get-validator-status`: Check validator status

## 🔐 Security

- Only registered validators can submit and validate treaties
- Reputation system prevents abuse
- Immutable treaty records

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 🚨 Treaty Violation Reporting System

- 📢 Community-driven violation reporting for enhanced treaty compliance monitoring
- ✅ Validator-reviewed confirmation process ensuring credible oversight
- 🔍 Transparent audit trail of all reports and reviews

### Contract Functions (Additions)

7. **Report Violation**
```clarity
(contract-call? .diplomatic-ledger report-violation treaty-id "violation-description")
```

8. **Review Violation** (Validators Only)
```clarity
(contract-call? .diplomatic-ledger review-violation violation-id true)
```

## 📖 Read-Only Functions (Additions)

- `get-violation`: Retrieve violation report details

## 🔐 Security (Additions)

- Validator-exclusive review rights prevent unauthorized confirmations
- Immutable reporting history maintains integrity of diplomatic records

## 🤝 Contributing (Additions)

New feature added: Treaty Violation Reporting System for proactive compliance monitoring.

```

Git commit message:
```
feat: implement diplomatic ledger MVP with treaty management and validation system
```

PR Title:
```
✨ MVP: Diplomatic Ledger Smart Contract Implementation
```

PR Description:
```
This PR introduces the initial MVP for the Diplomatic Ledger project, featuring:

- Core treaty management system
- Validator registration and reputation tracking
- Translation support for multiple languages
- IPFS integration for content storage
- Read-only functions for data retrieval

The implementation focuses on essential features while maintaining security and scalability. All core functionalities have been tested and are ready for review.

Testing Instructions:
1. Deploy contract using Clarinet
2. Register as validator
3. Submit test treaty
4. Validate treaty
5. Add translation


## 🚨 Emergency Pause Mechanism

- 🛡️ Owner-controlled pause functionality for security emergencies
- ⏸️ Halts all public functions during critical situations
- 🔄 Allows resumption of operations once issues are resolved

### Contract Functions (Additions)

5. **Pause Contract** (Owner Only)
```clarity
(contract-call? .diplomatic-ledger pause-contract)
```

6. **Unpause Contract** (Owner Only)
```clarity
(contract-call? .diplomatic-ledger unpause-contract)
```

## 🔐 Security (Additions)

- Emergency pause mechanism to halt operations in case of vulnerabilities or attacks
- Owner-exclusive control over pause/unpause to prevent unauthorized disruptions

## 🤝 Contributing (Additions)

New feature added: Emergency Pause Mechanism for enhanced contract security.

```

Git commit message for new feature:
```
feat: add emergency pause mechanism for contract security
```

PR Title for new feature:
```
🚨 Introduce Emergency Pause Mechanism for Enhanced Security
```

PR Description for new feature:
```
This PR revolutionizes contract security with a cutting-edge emergency pause mechanism! 🚀

🔥 **Key Innovations:**
- Owner-controlled pause functionality to instantly freeze all operations
- Circuit breaker design prevents exploits during vulnerability windows
- Seamless unpause capability for quick recovery
- Minimal gas overhead with efficient state management

🛡️ **Security Enhancements:**
- Immediate response to discovered threats
- Prevents cascading failures from smart contract bugs
- Maintains data integrity during emergency halts
- Owner-exclusive controls ensure responsible usage

💡 **Technical Highlights:**
- Clean integration with existing public functions
- Zero-impact on read-only operations
- Backward-compatible design
- Comprehensive error handling

This feature transforms our diplomatic ledger into a fortress of security, ensuring peace agreements remain protected even in the face of unforeseen challenges. Let's build a safer blockchain future together! 🌍✨

#BlockchainSecurity #SmartContractSafety #EmergencyProtocols #StacksBlockchain #DiplomaticLedger

## ⏰ Treaty Expiration Management System

- 📅 Time-bound treaty validity with configurable expiration blocks
- 🔄 Creator-controlled extension capabilities for ongoing agreements
- 🔍 Real-time expiration status checking for compliance monitoring
- 🛡️ Prevents outdated treaty enforcement and ensures diplomatic relevance

### Contract Functions (Additions)

9. **Submit Treaty** (Updated)
```clarity
(contract-call? .diplomatic-ledger submit-treaty "Treaty Title" "ipfs-hash" expiration-blocks)
```

10. **Extend Treaty Expiration** (Creator Only)
```clarity
(contract-call? .diplomatic-ledger extend-treaty-expiration treaty-id new-expiration-blocks)
```

## 📖 Read-Only Functions (Additions)

- `is-treaty-expired`: Check if a treaty has reached its expiration date

## 🔐 Security (Additions)

- Expiration-based access controls prevent actions on expired treaties
- Creator-exclusive extension rights maintain treaty integrity
- Time-sensitive validation ensures diplomatic agreements remain current

## 🤝 Contributing (Additions)

New feature added: Treaty Expiration Management System for time-sensitive diplomatic agreements.

```

Git commit message for new feature:
```
feat: introduce treaty expiration management for time-bound diplomatic agreements
```

PR Title for new feature:
```
⏰ Revolutionize Diplomatic Agreements with Treaty Expiration Management
```

PR Description for new feature:
```
This PR transforms our diplomatic ledger with an innovative treaty expiration management system! 🚀

🔥 **Key Innovations:**
- Block-height based expiration tracking for precise time control
- Creator-authorized extension mechanism for flexible agreement renewal
- Real-time expiration status queries for instant compliance checks
- Seamless integration with existing treaty lifecycle

🛡️ **Security & Compliance:**
- Automatic expiration prevents enforcement of outdated agreements
- Creator-controlled extensions maintain diplomatic sovereignty
- Transparent expiration metadata enhances auditability
- Prevents potential conflicts from indefinite treaty validity

💡 **Technical Highlights:**
- Minimal storage overhead with efficient uint expiration fields
- Backward-compatible design preserving existing treaty structures
- Gas-optimized read-only expiration checks
- Clean error handling for expired treaty interactions

This breakthrough feature ensures diplomatic agreements stay relevant and enforceable, creating a dynamic ecosystem where peace treaties evolve with changing global landscapes. Let's build a more adaptive and responsible international relations framework! 🌍✨

#TreatyExpiration #DiplomaticInnovation #TimeBoundAgreements #BlockchainGovernance #StacksBlockchain #DiplomaticLedger
```
```
