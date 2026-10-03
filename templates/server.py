#!/usr/bin/env python3
"""
Lightweight Multi-Threaded Local Development Server
Pocket Developer Toolkit (https://github.com/dahalsandesh/pocket-developer)

Features:
- Multi-threaded HTTP request handling (handles concurrent assets smoothly)
- Explicit CORS headers enabled for cross-origin testing
- Cache-control disabled (no-cache) for instant hot-reload feedback
- Automatic IP detection and formatted terminal banner
"""

import sys
import os
import socket
from http.server import HTTPServer, SimpleHTTPRequestHandler
from socketserver import ThreadingMixIn

class ThreadedHTTPServer(ThreadingMixIn, HTTPServer):
    daemon_threads = True

class DevRequestHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        # Disable browser caching for live mobile development
        self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate, max-age=0')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        # Allow cross-origin requests
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        super().end_headers()

    def log_message(self, format, *args):
        # Clean terminal logging
        sys.stderr.write(f"[{self.log_date_time_string()}] {self.address_string()} - {args[0]} {args[1]}\n")

def get_local_ip():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except Exception:
        return "127.0.0.1"

def run(port=8080, bind="0.0.0.0"):
    directory = os.getcwd()
    local_ip = get_local_ip()

    server_address = (bind, port)
    httpd = ThreadedHTTPServer(server_address, DevRequestHandler)

    print("=" * 60)
    print("  📱 POCKET DEVELOPER LOCAL DEV SERVER")
    print("=" * 60)
    print(f"  Root Directory : {directory}")
    print(f"  Local Access   : http://localhost:{port}")
    if local_ip != "127.0.0.1":
        print(f"  Network Access : http://{local_ip}:{port}")
        print(f"  (Open this on your laptop / tablet on the same Wi-Fi)")
    print("=" * 60)
    print("  Press Ctrl+C to terminate.")
    print("=" * 60 + "\n")

    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n[!] Dev server stopped.")
        sys.exit(0)

if __name__ == '__main__':
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8080
    run(port=port)
