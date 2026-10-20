#!/usr/bin/env bash
set -e

if [ ! -d ".venv" ]; then
    python3 -m venv .venv
fi

.venv/bin/python -m pip install -r requirements.txt
.venv/bin/python -m pytest

mkdir -p build
cat > build/hello <<'EOF'
#!/usr/bin/env bash
exec "$(dirname "$0")/../.venv/bin/python" "$(dirname "$0")/../src/hello.py"
EOF
chmod +x build/hello

cat > build/hello.bat <<'EOF'
@echo off
".\.venv\Scripts\python.exe" ".\src\hello.py"
EOF
