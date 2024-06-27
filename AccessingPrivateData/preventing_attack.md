# Preventive Measures for Attack

## Avoid Storing Sensitive Data On-Chain
- Store only non-sensitive data on the blockchain.
- If sensitive data must be stored, consider encrypting it before storage.

## Encryption
- Encrypt sensitive data off-chain and store only the encrypted data on-chain.
- Decrypt data off-chain when needed.

## Use Hashes
- Store the hash of sensitive data instead of the data itself.
- This can prove the existence or integrity of the data without revealing its content.

## Access Control
- Implement strict access control mechanisms using modifiers like `onlyOwner` or `onlyAuthorized`.
- Use role-based access control (RBAC) to manage permissions more effectively.

## Zero-Knowledge Proofs
- Use zero-knowledge proofs (ZKPs) to verify the correctness of certain statements without revealing the underlying data.
- zk-SNARKs and zk-STARKs are popular ZKP techniques.

## Multi-Sig Wallets
- Use multi-signature wallets to ensure that sensitive operations require multiple approvals, reducing the risk of unauthorized access.

## Example Implementations
- Provide examples of smart contracts implementing these preventive measures.
