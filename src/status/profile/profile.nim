import json
import ../libstatus/types

type Profile* = ref object
  id*, alias*, username*, identicon*, address*, ensName*, localNickname*: string
  ensVerified*: bool
  identityImage*: IdentityImage
  appearance*: int
  systemTags*: seq[string]

proc isContact*(self: Profile): bool =
  result = self.systemTags.contains(":contact/added") and not self.systemTags.contains(":contact/blocked")

proc isBlocked*(self: Profile): bool =
  result = self.systemTags.contains(":contact/blocked")

proc toProfileModel*(account: Account): Profile =
  result = Profile(
    id: "",
    username: account.name,
    identicon: account.identicon,
    alias: account.name,
    ensName: "",
    ensVerified: false,
    appearance: 0,
    systemTags: @[]
  )

proc toProfileModel*(profile: JsonNode): Profile =
  var systemTags: seq[string] = @[]
  if profile["systemTags"].kind != JNull:
    systemTags = profile["systemTags"].to(seq[string])

  result = Profile(
    id: profile["id"].str,
    username: profile["alias"].str,
    identicon: profile["identicon"].str,
    identityImage: IdentityImage(),
    address: profile["id"].str,
    alias: profile["alias"].str,
    ensName: "",
    ensVerified: profile["ensVerified"].getBool,
    appearance: 0,
    systemTags: systemTags
  )
  
  if profile.hasKey("name"):
    result.ensName = profile["name"].str
  
  if profile.hasKey("localNickname"):
    result.localNickname = profile["localNickname"].str

  if profile.hasKey("images") and profile["images"].kind != JNull:
    if profile["images"].hasKey("thumbnail"):
      result.identityImage.thumbnail = profile["images"]["thumbnail"]["uri"].str
    if profile["images"].hasKey("large"):
      result.identityImage.large = profile["images"]["large"]["uri"].str
