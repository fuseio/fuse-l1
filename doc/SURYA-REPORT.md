 Sūrya's Description Report

 Files Description Table


|  File Name  |  SHA-1 Hash  |
|-------------|--------------|
| /home/henry/fuse/optimism/packages/contracts/contracts/libraries/constants/Lib_DefaultValues.sol | f6569fa923ab5b8c4cbe3202e2477a708b984906 |
| /home/henry/fuse/optimism/packages/contracts/contracts/L1/rollup/ChainStorageContainer.sol | fcecff718fb5f8a46af2f59fa85ff9ee3d0a6dbd |
| /home/henry/fuse/optimism/packages/contracts/contracts/libraries/utils/Lib_Buffer.sol | 05924dbef976465253d50b474b578f8d50da3a90 |
| /home/henry/fuse/optimism/packages/contracts/contracts/libraries/resolver/Lib_AddressResolver.sol | cf20e5988a653d079744c8df50216c94ee0979a8 |
| /home/henry/fuse/optimism/packages/contracts/contracts/libraries/resolver/Lib_AddressManager.sol | a800d9912e132d96d03b8fff3760be510f94a424 |
| /home/henry/fuse/optimism/packages/contracts/contracts/L1/rollup/IChainStorageContainer.sol | 041c609bdbc50a23ecefaade61fb0c0bc4dad364 |
| /home/henry/fuse/optimism/packages/contracts/contracts/L1/rollup/CanonicalTransactionChain.sol | 652d04bffa75c2ae49e61688dccf1d15ca6c76ec |
| /home/henry/fuse/optimism/packages/contracts/contracts/standards/AddressAliasHelper.sol | e05c6cf4d4ee29fa4ef3fb12c5c1220fa36d3073 |
| /home/henry/fuse/optimism/packages/contracts/contracts/libraries/codec/Lib_OVMCodec.sol | a4933caf05f2071c612f21006049d211d1486978 |
| /home/henry/fuse/optimism/packages/contracts/contracts/libraries/rlp/Lib_RLPReader.sol | 86caa0e258ea8dbf769f48dde4db4be24f6d6a5f |
| /home/henry/fuse/optimism/packages/contracts/contracts/libraries/rlp/Lib_RLPWriter.sol | 76c0d36a4b43fb65ef81cb543662409ff419591d |
| /home/henry/fuse/optimism/packages/contracts/contracts/libraries/utils/Lib_BytesUtils.sol | 30ec0dd544bf0618ffadb7a8dfb19293354ca3e3 |
| /home/henry/fuse/optimism/packages/contracts/contracts/libraries/utils/Lib_Bytes32Utils.sol | 209c94d808e4ff92e2160e8a2d36c7cce3cdb8eb |
| /home/henry/fuse/optimism/packages/contracts/contracts/L1/rollup/ICanonicalTransactionChain.sol | fac136f7b920ab8bafc8d38114daaa280d6d6577 |
| /home/henry/fuse/optimism/packages/contracts/contracts/libraries/resolver/Lib_ResolvedDelegateProxy.sol | 3cc0190b6aae66328ab11f87c08480daf64a38d9 |


 Contracts Description Table


|  Contract  |         Type        |       Bases      |                  |                 |
|:----------:|:-------------------:|:----------------:|:----------------:|:---------------:|
|     └      |  **Function Name**  |  **Visibility**  |  **Mutability**  |  **Modifiers**  |
||||||
| **Lib_DefaultValues** | Library |  |||
||||||
| **ChainStorageContainer** | Implementation | IChainStorageContainer, Lib_AddressResolver |||
| └ | <Constructor> | Public ❗️ | 🛑  | Lib_AddressResolver |
| └ | setGlobalMetadata | Public ❗️ | 🛑  | onlyOwner |
| └ | getGlobalMetadata | Public ❗️ |   |NO❗️ |
| └ | length | Public ❗️ |   |NO❗️ |
| └ | push | Public ❗️ | 🛑  | onlyOwner |
| └ | push | Public ❗️ | 🛑  | onlyOwner |
| └ | get | Public ❗️ |   |NO❗️ |
| └ | deleteElementsAfterInclusive | Public ❗️ | 🛑  | onlyOwner |
| └ | deleteElementsAfterInclusive | Public ❗️ | 🛑  | onlyOwner |
||||||
| **Lib_Buffer** | Library |  |||
| └ | push | Internal 🔒 | 🛑  | |
| └ | push | Internal 🔒 | 🛑  | |
| └ | get | Internal 🔒 |   | |
| └ | deleteElementsAfterInclusive | Internal 🔒 | 🛑  | |
| └ | deleteElementsAfterInclusive | Internal 🔒 | 🛑  | |
| └ | getLength | Internal 🔒 |   | |
| └ | setExtraData | Internal 🔒 | 🛑  | |
| └ | getExtraData | Internal 🔒 |   | |
| └ | setContext | Internal 🔒 | 🛑  | |
| └ | getContext | Internal 🔒 |   | |
||||||
| **Lib_AddressResolver** | Implementation |  |||
| └ | <Constructor> | Public ❗️ | 🛑  |NO❗️ |
| └ | resolve | Public ❗️ |   |NO❗️ |
||||||
| **Lib_AddressManager** | Implementation | Ownable |||
| └ | setAddress | External ❗️ | 🛑  | onlyOwner |
| └ | getAddress | External ❗️ |   |NO❗️ |
| └ | _getNameHash | Internal 🔒 |   | |
||||||
| **IChainStorageContainer** | Interface |  |||
| └ | setGlobalMetadata | External ❗️ | 🛑  |NO❗️ |
| └ | getGlobalMetadata | External ❗️ |   |NO❗️ |
| └ | length | External ❗️ |   |NO❗️ |
| └ | push | External ❗️ | 🛑  |NO❗️ |
| └ | push | External ❗️ | 🛑  |NO❗️ |
| └ | get | External ❗️ |   |NO❗️ |
| └ | deleteElementsAfterInclusive | External ❗️ | 🛑  |NO❗️ |
| └ | deleteElementsAfterInclusive | External ❗️ | 🛑  |NO❗️ |
||||||
| **CanonicalTransactionChain** | Implementation | ICanonicalTransactionChain, Lib_AddressResolver |||
| └ | <Constructor> | Public ❗️ | 🛑  | Lib_AddressResolver |
| └ | setGasParams | External ❗️ | 🛑  | onlyBurnAdmin |
| └ | batches | Public ❗️ |   |NO❗️ |
| └ | getTotalElements | Public ❗️ |   |NO❗️ |
| └ | getTotalBatches | Public ❗️ |   |NO❗️ |
| └ | getNextQueueIndex | Public ❗️ |   |NO❗️ |
| └ | getLastTimestamp | Public ❗️ |   |NO❗️ |
| └ | getLastBlockNumber | Public ❗️ |   |NO❗️ |
| └ | getQueueElement | Public ❗️ |   |NO❗️ |
| └ | getNumPendingQueueElements | Public ❗️ |   |NO❗️ |
| └ | getQueueLength | Public ❗️ |   |NO❗️ |
| └ | enqueue | External ❗️ | 🛑  |NO❗️ |
| └ | appendSequencerBatch | External ❗️ | 🛑  |NO❗️ |
| └ | _getBatchContext | Internal 🔒 |   | |
| └ | _getBatchExtraData | Internal 🔒 |   | |
| └ | _makeBatchExtraData | Internal 🔒 |   | |
| └ | _appendBatch | Internal 🔒 | 🛑  | |
||||||
| **AddressAliasHelper** | Library |  |||
| └ | applyL1ToL2Alias | Internal 🔒 |   | |
| └ | undoL1ToL2Alias | Internal 🔒 |   | |
||||||
| **Lib_OVMCodec** | Library |  |||
| └ | encodeTransaction | Internal 🔒 |   | |
| └ | hashTransaction | Internal 🔒 |   | |
| └ | decodeEVMAccount | Internal 🔒 |   | |
| └ | hashBatchHeader | Internal 🔒 |   | |
||||||
| **Lib_RLPReader** | Library |  |||
| └ | toRLPItem | Internal 🔒 |   | |
| └ | readList | Internal 🔒 |   | |
| └ | readList | Internal 🔒 |   | |
| └ | readBytes | Internal 🔒 |   | |
| └ | readBytes | Internal 🔒 |   | |
| └ | readString | Internal 🔒 |   | |
| └ | readString | Internal 🔒 |   | |
| └ | readBytes32 | Internal 🔒 |   | |
| └ | readBytes32 | Internal 🔒 |   | |
| └ | readUint256 | Internal 🔒 |   | |
| └ | readUint256 | Internal 🔒 |   | |
| └ | readBool | Internal 🔒 |   | |
| └ | readBool | Internal 🔒 |   | |
| └ | readAddress | Internal 🔒 |   | |
| └ | readAddress | Internal 🔒 |   | |
| └ | readRawBytes | Internal 🔒 |   | |
| └ | _decodeLength | Private 🔐 |   | |
| └ | _copy | Private 🔐 |   | |
| └ | _copy | Private 🔐 |   | |
||||||
| **Lib_RLPWriter** | Library |  |||
| └ | writeBytes | Internal 🔒 |   | |
| └ | writeList | Internal 🔒 |   | |
| └ | writeString | Internal 🔒 |   | |
| └ | writeAddress | Internal 🔒 |   | |
| └ | writeUint | Internal 🔒 |   | |
| └ | writeBool | Internal 🔒 |   | |
| └ | _writeLength | Private 🔐 |   | |
| └ | _toBinary | Private 🔐 |   | |
| └ | _memcpy | Private 🔐 |   | |
| └ | _flatten | Private 🔐 |   | |
||||||
| **Lib_BytesUtils** | Library |  |||
| └ | slice | Internal 🔒 |   | |
| └ | slice | Internal 🔒 |   | |
| └ | toBytes32 | Internal 🔒 |   | |
| └ | toUint256 | Internal 🔒 |   | |
| └ | toNibbles | Internal 🔒 |   | |
| └ | fromNibbles | Internal 🔒 |   | |
| └ | equal | Internal 🔒 |   | |
||||||
| **Lib_Bytes32Utils** | Library |  |||
| └ | toBool | Internal 🔒 |   | |
| └ | fromBool | Internal 🔒 |   | |
| └ | toAddress | Internal 🔒 |   | |
| └ | fromAddress | Internal 🔒 |   | |
||||||
| **ICanonicalTransactionChain** | Interface |  |||
| └ | setGasParams | External ❗️ | 🛑  |NO❗️ |
| └ | batches | External ❗️ |   |NO❗️ |
| └ | getTotalElements | External ❗️ |   |NO❗️ |
| └ | getTotalBatches | External ❗️ |   |NO❗️ |
| └ | getNextQueueIndex | External ❗️ |   |NO❗️ |
| └ | getQueueElement | External ❗️ |   |NO❗️ |
| └ | getLastTimestamp | External ❗️ |   |NO❗️ |
| └ | getLastBlockNumber | External ❗️ |   |NO❗️ |
| └ | getNumPendingQueueElements | External ❗️ |   |NO❗️ |
| └ | getQueueLength | External ❗️ |   |NO❗️ |
| └ | enqueue | External ❗️ | 🛑  |NO❗️ |
| └ | appendSequencerBatch | External ❗️ | 🛑  |NO❗️ |
||||||
| **Lib_ResolvedDelegateProxy** | Implementation |  |||
| └ | <Constructor> | Public ❗️ | 🛑  |NO❗️ |
| └ | <Fallback> | External ❗️ |  💵 |NO❗️ |


 Legend

|  Symbol  |  Meaning  |
|:--------:|-----------|
|    🛑    | Function can modify state |
|    💵    | Function is payable |

