import NimQml
import views/account_list
import views/account_item
import ../../status/keyutil

QtObject:
  type
    KeyUtilView* = ref object of QAbstractListModel
      accounts*: AccountList
      currentAccount: AccountItemView

  proc delete(self: KeyUtilView) =
    self.QAbstractListModel.delete

  proc setup(self: KeyUtilView) =
    self.QAbstractListModel.setup

  proc newKeyUtilView*(): KeyUtilView =
    new(result, delete)
    result.accounts = newAccountList()
    result.currentAccount = newAccountItemView()
    result.setup