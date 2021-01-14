import asynchttpserver, asyncdispatch, uri, strutils
import locks, os
import chronicles
import tables





var webserverThread: Thread[void]

proc cb(req: Request) {.async, gcsafe.} =
  # This should come from the settings
  var plugin = initTable[string, Table[string, string]]()
  plugin["pluginX"] = initTable[string, string]()
  plugin["pluginX"]["index.html"] = "<html><head><script src='pluginX/main.js'></script></head><body>Hello World <button onClick='doSomething()'>CLICK</button></body></html>";
  plugin["pluginX"]["main.js"] = "function doSomething() { alert('Hello World'); } "

  let pathParts = req.url.path.split("/")
  if pathParts.len == 1:
    await req.respond(Http403, "Forbidden")
    return

  let pluginId = pathParts[1]
  let resource = if pathParts.len == 2 or pathParts[2] == "": "index.html" else: pathParts[2]

  if not plugin.hasKey(pluginId):
    await req.respond(Http403, "Forbidden")
    return
  else: 
    if not plugin[pluginId].hasKey(resource):
      await req.respond(Http403, "Forbidden")
      return
  
  await req.respond(Http200, plugin[pluginId][resource])
  

proc startWebserver() {.thread.} =
  var server = newAsyncHttpServer()
  waitFor server.serve(Port(8989), cb)
  
proc initWebserver*() =
  debug "Start webserver"
  webserverThread.createThread(startWebserver)
  


