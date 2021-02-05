import NimQml, Tables, chronicles
import ../../../status/chat/[chat, message]
import ../../../status/status
import ../../../status/ens
import ../../../status/accounts
import strutils

type
  CommunityMembershipRequestRoles {.pure.} = enum
    Id = UserRole + 1,
    PublicKey = UserRole + 2
    ChatId = UserRole + 3
    CommunityId = UserRole + 4
    State = UserRole + 5
    Our = UserRole + 6

QtObject:
  type
    CommunityMembershipRequestList* = ref object of QAbstractListModel
      communityMembershipRequests*: seq[CommunityMembershipRequest]

  proc setup(self: CommunityMembershipRequestList) = self.QAbstractListModel.setup

  proc delete(self: CommunityMembershipRequestList) = 
    self.communityMembershipRequests = @[]
    self.QAbstractListModel.delete

  proc newCommunityMembershipRequestList*(): CommunityMembershipRequestList =
    new(result, delete)
    result.communityMembershipRequests = @[]
    result.setup()

  method rowCount*(self: CommunityMembershipRequestList, index: QModelIndex = nil): int = self.communityMembershipRequests.len

  method data(self: CommunityMembershipRequestList, index: QModelIndex, role: int): QVariant =
    if not index.isValid:
      return
    if index.row < 0 or index.row >= self.communityMembershipRequests.len:
      return

    let communityMembershipRequestItem = self.communityMembershipRequests[index.row]
    let communityMembershipRequestItemRole = role.CommunityRoles
    case communityMembershipRequestItemRole:
      of CommunityRoles.Id: result = newQVariant(communityMembershipRequestItem.id.string)
      of CommunityRoles.PublicKey: result = newQVariant(communityMembershipRequestItem.publicKey.string)
      of CommunityRoles.ChatId: result = newQVariant(communityMembershipRequestItem.chatId.string)
      of CommunityRoles.CommunityId: result = newQVariant(communityMembershipRequestItem.communityId.string)
      of CommunityRoles.State: result = newQVariant(communityMembershipRequestItem.state.string)
      of CommunityRoles.Our: result = newQVariant(communityMembershipRequestItem.our.string)

  method roleNames(self: CommunityMembershipRequestList): Table[int, string] =
    {
      CommunityRoles.Id.int: "id",
      CommunityRoles.PublicKey.int: "publicKey",
      CommunityRoles.ChatId.int: "chatId",
      CommunityRoles.CommunityId.int: "communityId",
      CommunityRoles.State.int: "state",
      CommunityRoles.Our.int: "our"
    }.toTable

  proc setNewData*(self: CommunityMembershipRequestList, communityMembershipRequestList: seq[CommunityMembershipRequest]) =
    self.beginResetModel()
    self.communityMembershipRequests = communityMembershipRequestList
    self.endResetModel()

  proc addCommunityMembershipRequestItemToList*(self: CommunityMembershipRequestList, communityMemberphipRequest: CommunityMembershipRequest) =
    self.beginInsertRows(newQModelIndex(), self.communityMembershipRequests.len, self.communityMembershipRequests.len)
    self.communityMembershipRequests.add(communityMemberphipRequest)
    self.endInsertRows()

  proc removeCommunityMembershipRequestItemFromList*(self: CommunityMembershipRequestList, id: string) =
    let idx = self.communityMembershipRequests.findIndexById(id)
    self.beginRemoveRows(newQModelIndex(), idx, idx)
    self.communityMembershipRequests.delete(idx)
    self.endRemoveRows()

  proc getCommunityMembershipRequestById*(self: CommunityMembershipRequestList, communityMembershipRequestId: string): CommunityMembershipRequest =
    for communityMembershipRequest in self.communityMembershipRequests:
      if communityMembershipRequest.id == communityMembershipRequestId:
        return communityMembershipRequest
