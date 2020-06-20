import NimQml
import chronicles
import view
import ../../status/libstatus/wallet as status_wallet
import ../../signals/types

import ../../status/wallet
import ../../status/wallet/account as WalletTypes
import ../../status/status

logScope:
  topics = "keyutil-controller"

type KeyUtilController* = ref object of SignalSubscriber
  status*: Status
  view*: KeyutilView
  variant*: QVariant

proc newController*(status: Status): KeyUtilController =
  result = KeyUtilController()
  result.status = status
  result.view = newKeyUtilView()
  result.variant = newQVariant(result.view)

proc delete*(self: KeyUtilController) =
  delete self.view
  delete self.variant

proc init*(self: KeyUtilController) =
  discard

method onSignal(self: KeyUtilController, data: Signal) =
  debug "New signal received"

