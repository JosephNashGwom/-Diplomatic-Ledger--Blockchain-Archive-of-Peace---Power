# 🌍 Diplomatic Ledger: Blockchain Archive of Peace & Power

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

