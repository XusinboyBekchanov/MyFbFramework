#!/usr/bin/env python3
# test-compile-server.py Program.bas Target [Parameter] - the test of Compile of the IDE on the Mac: sends the program to the
# server of the running IDE (VFBE_WEB_SERVER=1, localhost:8001) like the iOS IDE does. Target: macos or ios
import sys, os, time, urllib.request

path, target = sys.argv[1], sys.argv[2]
parameter = sys.argv[3] if len(sys.argv) > 3 else ""
name = os.path.basename(path)
data = open(path, "rb").read()
body = b"VFBE-WEBCOMPILE 1\nid test" + target.encode() + b"\nroot /\nmain " + name.encode() + b"\noptions \ntarget " + target.encode() + b"\n"
if parameter:
    body += b"parameter " + parameter.encode() + b"\n"
body += b"file %d %s\n" % (len(data), name.encode()) + data + b"\nend\n"
for i in range(90):
    try:
        request = urllib.request.Request("http://127.0.0.1:8001/compile", data=body, method="POST")
        answer = urllib.request.urlopen(request, timeout=280).read().decode("utf-8", "replace")
        break
    except OSError as e:
        answer = "result=0\nerror=%s" % e
        if "refused" not in str(e):
            break
        time.sleep(1)
print(answer)
if not answer.startswith("result=1"):
    for line in answer.splitlines()[:25]:
        print("::error::" + line[:220])
    sys.exit(1)
