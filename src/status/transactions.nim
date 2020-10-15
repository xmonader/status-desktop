import
  options, strutils

import
  stint, web3/ethtypes, chronicles

import
  libstatus/types
from libstatus/utils as status_utils import toUInt64, gwei2Wei, parseAddress

logScope:
  topics = "transactions"

proc buildTransaction*(source: Address, value: Uint256, gas = "", gasPrice = ""): EthSend =
  var
    gasQty = Quantity.none
    gasPriceInt = int.none
  if not gas.isEmptyOrWhitespace:
    try:
      gasQty = Quantity(cast[uint64](parseFloat(gas).toUInt64)).some
    except:
      warn "Error parsing gas value", value=gas
  
  if not gasPrice.isEmptyOrWhitespace:
    try:
      gasPriceInt = gwei2Wei(parseFloat(gasPrice)).truncate(int).some
    except:
      warn "Error parsing gasPrice value", value=gasPrice
    
  result = EthSend(
    source: source,
    value: value.some,
    gas: gasQty,
    gasPrice: gasPriceInt
  )

proc buildTokenTransaction*(source, contractAddress: Address, gas = "", gasPrice = ""): EthSend =
  result = buildTransaction(source, 0.u256, gas, gasPrice)
  result.to = contractAddress.some