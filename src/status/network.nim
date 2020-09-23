import chronicles, eventemitter

logScope:
  topics = "network-model"

type
  NetworkModel* = ref object
    peers*: seq[string]
    events*: EventEmitter

proc newNetworkModel*(events: EventEmitter): NetworkModel =
  result = NetworkModel()
  result.events = events
  result.peers = @[]

proc peerSummaryChange*(self: NetworkModel, peers: seq[string]) =
  if peers.len == 0:
    self.events.emit("network:disconnected", Args())
  
  if peers.len > 0:
    self.events.emit("network:connected", Args())

  self.peers = peers

proc peerCount*(self: NetworkModel): int = self.peers.len

proc isConnected*(self: NetworkModel): bool = self.peerCount() > 0
