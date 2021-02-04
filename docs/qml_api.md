## API available to QML

### walletModel
| Name          | Type     | Description  |
|-----------------------------------|---------|-------------------------------------|
| `walletModel.accounts*` | `QtObject<AccountList>` | returns list of accounts on the node |
| `walletModel.currentAssetList*` | `QtObject<AssetList>` | returns list of token assets for the currently selected wallet account |
| `walletModel.currentAssetList*` | `QtObject<CollectiblesList>` | returns list of ERC-721 assets for the currently selected wallet account |
| `walletModel.currentAccount*` | `QtObject<AccountItemView>` | returns current wallet account selected in the Wallet |
| `walletModel.focusedAccount*` | `QtObject<AccountItemView>` | returns the focused wallet account selected in the chat transaction modal. |
| `walletModel.dappBrowserAccount*` | `QtObject<AccountItemView>` | returns the wallet account currently used in the dapp browser. |
| `walletModel.currentTransactions*` | `QtObject<TransactionList>` | returns the list of transactions for the currently selected wallet account. |
| `walletModel.defaultTokenList*` | `QtObject<TokenList>` | returns the list of ERC-20 tokens for the currently selected wallet account. |
| `walletModel.customTokenList*` | `QtObject<TokenList>` | returns the list of custom ERC-20 tokens added by the user for the currently selected wallet account. |

#### AccountList
`QAbstractListModel` to expose node accounts.
The following roles are available to the model when bound to a QML control:

| Name          | Description  |
|-----------------------------------|-------------------------------------|
| `name` | account name defined by user |
| `address` | account address |
| `iconColor` | account color chosen by user |
| `balance` | equivalent fiat balance for display, in format `$#.##` |
| `fiatBalance` | the wallet's equivalent fiat balance in the format `#.##` (no currency as in `balance`) |
| `assets` | returns an `AssetList` (see below) |
| `isWallet` | flag indicating whether the asset is a token or a wallet |
| `walletType` | in the case of a wallet, indicates the type of wallet ("key", "seed", "watch", "generated"). See `AccountItemView`for more information on wallet types. |

#### AssetList
`QAbstractListModel` exposes ERC-20 token assets owned by a wallet account.
The following roles are available to the model when bound to a QML control:

| Name          | Description  |
|-----------------------------------|-------------------------------------|
| `name` | token name |
| `symbol` | token ticker symbol |
| `value` | amount of token (in wei or equivalent) |
| `fiatBalanceDisplay` | equivalent fiat balance for display, in format `$#.##` |
| `address` | token contract address |
| `fiatBalance` | equivalent fiat balance (not for display) |

#### CollectiblesList
`QAbstractListModel` exposes ERC-721 assets for a wallet account.
The following roles are available to the model when bound to a QML control:

| Name          | Description  |
|-----------------------------------|-------------------------------------|
| `collectibleType` | the type of collectible ("cryptokitty", "kudo", "ethermon", "stickers") |
| `collectiblesJSON` | JSON representation of all collectibles in the list (schema is different for each type of collectible) |
| `error` | error encountered while fetching the collectibles |

#### TransactionList
`QAbstractListModel` to expose transactions for the currently selected wallet.
The following roles are available to the model when bound to a QML control:

| Name          | Description  |
|-----------------------------------|-------------------------------------|
| `typeValue` | the transaction type |
| `address` | ?? |
| `blockNumber` | the block number the transaction was included in |
| `blockHash` | the hash of the block |
| `timestamp` | Unix timestamp of when the block was created |
| `gasPrice` | gas price used in the transaction |
| `gasLimit` | maximum gas allowed in this block |
| `gasUsed` | amount of gas used in the transaction |
| `nonce` | transaction nonce |
| `txStatus` | transaction status |
| `value` | value (in wei) of the transaction |
| `fromAddress` | address the transaction was sent from |
| `to` | address the transaction was sent to |
| `contract` | ?? likely in a transfer transaction, the token contract interacted with |

#### AccountItemView
This type can be accessed by any of the properties in the `walletModel` that return `QtObject<AccountItemView>`, ie `walletModel.currentAccount.name`. See the `walletModel`table above.

| Name          | Type     | Description  |
|-----------------------------------|---------|-------------------------------------|
| `name*` | `string` | display name given to the wallet by the user |
| `address*` | `string` | wallet's ethereum address |
| `iconColor*` | `string` | wallet hexadecimal colour assigned to the wallet by the user |
| `balance*` | `string` | the wallet's fiat balance used for display purposes in the format of `#.## USD` |
| `fiatBalance*` | `string` | the wallet's equivalent fiat balance in the format `#.##` (no currency as in `balance`) |
| `path*` | `string` | the wallet's HD derivation path |
| `walletType*` | `string` | type determined by how the wallet was created. Values include: |
|  | | `"key"` - wallet was created with a private key |
|  | |   `"seed"` - wallet was created with a seed phrase |
|  | |   `"watch"` - wallet was created as to watch an Ethereum address (like a read-only wallet) |
|  | |   `"generated"` - wallet was generated by the app |

#### TokenList
`QAbstractListModel` exposes all displayable ERC-20 tokens.
The following roles are available to the model when bound to a QML control:

| Name          | Description  |
|-----------------------------------|-------------------------------------|
| `name` | token display name |
| `symbol` | token ticker symbol |
| `hasIcon` | flag indicating whether or not the token has an icon |
| `address` | the token's ERC-20 contract address |
| `decimals` | the number of decimals held by the token |
| `isCustom` | flag indicating whether the token was added by the user |


*walletModel.transactions* - list of transactions (list)

each transaction is an object containing:
* typeValue
* address
* blockNumber
* blockHash
* timestamp
* gasPrice
* gasLimit
* gasUsed
* nonce
* txStatus
* value
* fromAddress
* to

*walletModel.assets* - list of assets (list)

each list is an object containing:
* name
* symbol
* value
* fiatValue

*walletModel.totalFiatBalance* - returns total fiat balance of all accounts (string)

*walletModel.accounts* - list of accounts (list)

each account is an object containing:
* name
* address
* iconColor
* balance

*walletModel.defaultCurrency* - get current currency (string)

*walletModel.setDefaultCurrency(currency: string)* - set a new default currency, `currency` should be a symbol like `"USD"`

*walletModel.hasAsset(account: string, symbol: string)* - returns true if token with `symbol` is enabled, false other wise (boolean)

*walletModel.toggleAsset(symbol: string, checked: bool, address: string, name: string, decimals: int, color: string)* - enables a token with `symbol` or disables it it's already enabled

*walletModel.addCustomToken(address: string, name: string, symbol: string, decimals: string)* - add a custom token to the wallet

*walletModel.loadTransactionsForAccount(address: string)* - loads transaction history for an address

*walletModel.onSendTransaction(from_value: string, to: string, value: string, password: string)* - transfer a value in ether from one account to another

*walletModel.deleteAccount(address: string)* - delete an address from the wallet

*generateNewAccount(password: string, accountName: string, color: string)* - 

*addAccountsFromSeed(seed: string, password: string, accountName: string, color: string)* - 

*addAccountsFromPrivateKey(privateKey: string, password: string, accountName: string, color: string)* - 

*addWatchOnlyAccount(address: string, accountName: string, color: string)* - 

*changeAccountSettings(address: string, accountName: string, color: string)* - 

**chatsModel**

*chatsModel.chats* - get channel list (list)

channel object:
* name - 
* timestamp - 
* lastMessage.text - 
* unviewedMessagesCount - 
* identicon - 
* chatType - 
* color - 

*chatsModel.activeChannelIndex* - 
*chatsModel.activeChannel* - return currently active channel (object)

active channel object:
* id - 
* name - 
* color - 
* identicon - 
* chatType - (int)
* members - (list)
  * userName
  * pubKey
  * isAdmin
  * joined
  * identicon
* isMember(pubKey: string) - check if `pubkey` is a group member (bool)
* isAdmin(pubKey: string) - check if `pubkey` is a group admin (bool)

*chatsModel.messageList* - returns messages for the current channel (list)

message object:
* userName - 
* message - 
* timestamp - 
* clock - 
* identicon - 
* isCurrentUser - 
* contentType - 
* sticker - 
* fromAuthor - 
* chatId - 
* sectionIdentifier - 
* messageId - 

*chatsModel.sendMessage(message: string)* - send a message to currently active channel

*chatsModel.joinChat(channel: string, chatTypeInt: int)* - join a channel

*chatsModel.groups.join()* - confirm joining group

*chatsModel.leaveActiveChat()* - leave currently active channel

*chatsModel.clearChatHistory()* - clear chat history of currently active channel

*chatsModel.groups.rename(newName: string)* - rename current active group

*chatsModel.blockContact(id: string)* - block contact

*chatsModel.addContact(id: string)*

*chatsModel.groups.create(groupName: string, pubKeys: string)*

**TODO**: document all exposed APIs to QML

