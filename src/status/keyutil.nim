import eventemitter, json, strformat, strutils, chronicles, sequtils
import libstatus/accounts as status_accounts
import libstatus/tokens as status_tokens
import libstatus/settings as status_settings
import libstatus/wallet as status_wallet
import libstatus/accounts/constants as constants
from libstatus/types import GeneratedAccount, DerivedAccount
import wallet/balance_manager
import wallet/account
export account

type KeyUtilModel* = ref object
  events*: EventEmitter
  accounts*: seq[WalletAccount]
  tokens*: JsonNode

proc newKeyUtilModel*(): KeyUtilModel =
  result = KeyUtilModel()
  result.events = createEventEmitter()

proc initAccounts*(self: KeyUtilModel) =
  self.tokens = status_tokens.getCustomTokens()
  let accounts = status_wallet.getWalletAccounts()
  for account in accounts:
    var acc = WalletAccount(account)
    self.accounts.add(acc)

proc delete*(self: KeyUtilModel) =
  discard
