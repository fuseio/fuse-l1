Address Dictator
================





*The AddressDictator (glory to Arstotzka) is a contract that allows us to safely manipulate      many different addresses in the AddressManager without transferring ownership of the      AddressManager to a hot wallet or hardware wallet.*

## Methods

### finalOwner

```solidity
function finalOwner() external view returns (address)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined

### getNamedAddresses

```solidity
function getNamedAddresses() external view returns (struct AddressDictator.NamedAddress[])
```

Returns the full namedAddresses array.




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | AddressDictator.NamedAddress[] | undefined

### manager

```solidity
function manager() external view returns (contract Lib_AddressManager)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract Lib_AddressManager | undefined

### returnOwnership

```solidity
function returnOwnership() external nonpayable
```

Transfers ownership of this contract to the finalOwner. Only callable by the Final Owner, which is intended to be our multisig. This function shouldn&#39;t be necessary, but it gives a sense of reassurance that we can recover if something really surprising goes wrong.




### setAddresses

```solidity
function setAddresses() external nonpayable
```

Called to finalize the transfer, this function is callable by anyone, but will only result in an upgrade if this contract is the owner Address Manager.




* Transactions


This contract was deployed by https://etherscan.io/address/0x0bb2ca5ea700ba04c713008e1a3d198b4e8da7a7 and also setup by the same address.
The transaction below was also called by the deployer.
This is the only transaction there.

![address-dictator](../diagrams/address-dictator-xbabb37235bd38ae5a29717590eedfd9b02f84a12b890b2126feac68f223d7448.png)





