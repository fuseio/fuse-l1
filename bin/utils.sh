



seth mktx --rpc-url $(ARB_RINKEBY) \
  --keystore $(KEYSTORE) \
  --from $(WALLET_DISK) --gas $(GAS) \
  0xC0aE9A2c75c79Dd4cAc0a9708154FB4033219014 \
  'adopt(uint)' '5'
