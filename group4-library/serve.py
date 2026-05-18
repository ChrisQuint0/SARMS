# serve.py
import http.server
import mimetypes
import sys
import threading

mimetypes.add_type('text/xml', '.xsl')
mimetypes.add_type('text/xml', '.xml')

httpd = http.server.HTTPServer(
    ('localhost', 8080),
    http.server.SimpleHTTPRequestHandler
)
httpd.allow_reuse_address = True

thread = threading.Thread(target=httpd.serve_forever)
thread.daemon = True  # dies automatically when main process exits
thread.start()

print("Serving at http://localhost:8080")
print("Press Ctrl+C to stop.")

try:
    thread.join()
except KeyboardInterrupt:
    print("\nShutting down...")
    httpd.shutdown()
    sys.exit(0)