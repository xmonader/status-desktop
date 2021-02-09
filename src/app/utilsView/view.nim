import NimQml, os, strformat, strutils, parseUtils, chronicles
import stint
import ../../status/status
import ../../status/accounts as status_accounts
import ../../status/stickers
import ../../status/libstatus/accounts/constants as accountConstants
import ../../status/libstatus/tokens
import ../../status/libstatus/types
import ../../status/libstatus/settings
import ../../status/libstatus/wallet as status_wallet
import ../../status/libstatus/utils as status_utils
import ../../status/ens as status_ens
import web3/[ethtypes, conversions]
import stew/byteutils

QtObject:
  type UtilsView* = ref object of QObject
    status*: Status

  proc setup(self: UtilsView) =
    self.QObject.setup

  proc delete*(self: UtilsView) =
    self.QObject.delete

  proc newUtilsView*(status: Status): UtilsView =
    new(result, delete)
    result = UtilsView()
    result.status = status
    result.setup

  proc getDataDir*(self: UtilsView): string {.slot.} =
    result = accountConstants.DATADIR

  proc joinPath*(self: UtilsView, start: string, ending: string): string {.slot.} =
    result = os.joinPath(start, ending)

  proc join3Paths*(self: UtilsView, start: string, middle: string, ending: string): string {.slot.} =
    result = os.joinPath(start, middle, ending)

  proc getSNTAddress*(self: UtilsView): string {.slot.} =
    result = getSNTAddress()

  proc getSNTBalance*(self: UtilsView): string {.slot.} =
    let currAcct = status_wallet.getWalletAccounts()[0]
    result = getSNTBalance($currAcct.address)

  proc eth2Wei*(self: UtilsView, eth: string, decimals: int): string {.slot.} =
    let uintValue = status_utils.eth2Wei(parseFloat(eth), decimals)
    return uintValue.toString()

  proc getStickerMarketAddress(self: UtilsView): string {.slot.} =
    $self.status.stickers.getStickerMarketAddress

  QtProperty[string] stickerMarketAddress:
    read = getStickerMarketAddress

  proc getEnsRegisterAddress(self: UtilsView): QVariant {.slot.} =
    newQVariant($statusRegistrarAddress())

  QtProperty[QVariant] ensRegisterAddress:
    read = getEnsRegisterAddress

  proc stripTrailingZeroes(value: string): string =
    var str = value.strip(leading = false, chars = {'0'})
    if str[str.len - 1] == '.':
      add(str, "0")
    return str

  proc hex2Ascii*(self: UtilsView, value: string): string {.slot.} =
    result = string.fromBytes(hexToSeqByte(value))

  proc ascii2Hex*(self: UtilsView, value: string): string {.slot.} = 
    result = "0x" & toHex(value)

  proc hex2Eth*(self: UtilsView, value: string): string {.slot.} =
    return stripTrailingZeroes(status_utils.wei2Eth(stint.fromHex(StUint[256], value)))

  proc hex2Dec*(self: UtilsView, value: string): string {.slot.} =
    # somehow this value crashes the app
    if value == "0x0":
      return "0"
    return stripTrailingZeroes(stint.toString(stint.fromHex(StUint[256], value)))

  proc urlFromUserInput*(self: UtilsView, input: string): string {.slot.} =
    result = url_fromUserInput(input)

  proc wei2Eth*(self: UtilsView, wei: string, decimals: int): string {.slot.} =
    var weiValue = wei
    if(weiValue.startsWith("0x")):
      weiValue = fromHex(Stuint[256], weiValue).toString()
    return status_utils.wei2Eth(weiValue, decimals)

  proc generateAlias*(self: UtilsView, pk: string): string {.slot.} =
    result = status_accounts.generateAlias(pk)

  proc generateIdenticon*(self: UtilsView, pk: string): string {.slot.} =
    result = status_accounts.generateIdenticon(pk)

  proc getNetworkName*(self: UtilsView): string {.slot.} =
    getCurrentNetworkDetails().name