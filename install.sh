#!/bin/bash

# Parameter Bug Hunter Pro - Installation Script
echo "======================================================================"
echo "              PARAMETER BUG HUNTER PRO - INSTALLATION"
echo "======================================================================"

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "⚠️  Please run as root or with sudo"
    exit 1
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    echo -e "${BLUE}[*]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[+]${NC} $1"
}

print_error() {
    echo -e "${RED}[-]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Update system
print_status "Updating system packages..."
apt-get update -y

# Install basic dependencies
print_status "Installing basic dependencies..."
apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    git \
    curl \
    wget \
    nmap \
    whois \
    dnsutils \
    net-tools

# Install Python tools
print_status "Installing Python tools..."
apt-get install -y \
    sqlmap \
    nikto

# Create virtual environment
print_status "Creating Python virtual environment..."
python3 -m venv venv
source venv/bin/activate

# Install Python packages
print_status "Installing Python packages..."
pip install --upgrade pip
pip install \
    colorama \
    requests \
    pyyaml \
    beautifulsoup4 \
    lxml \
    python-dotenv \
    tabulate \
    progress \
    urllib3 \
    jsbeautifier \
    argparse \
    selenium \
    pillow \
    pymongo \
    redis \
    psycopg2-binary \
    matplotlib \
    pandas \
    numpy \
    scrapy

# Install security tools from GitHub
print_status "Installing security tools from GitHub..."

# Create tools directory
mkdir -p ~/tools
cd ~/tools

# Install Arjun
print_status "Installing Arjun..."
git clone https://github.com/s0md3v/Arjun.git
cd Arjun
python3 setup.py install
cd ..

# Install FFuF
print_status "Installing FFuF..."
wget https://github.com/ffuf/ffuf/releases/download/v2.0.0/ffuf_2.0.0_linux_amd64.tar.gz
tar -xzf ffuf_2.0.0_linux_amd64.tar.gz
chmod +x ffuf
mv ffuf /usr/local/bin/
rm ffuf_2.0.0_linux_amd64.tar.gz

# Install gau
print_status "Installing gau..."
go install github.com/lc/gau/v2/cmd/gau@latest
cp ~/go/bin/gau /usr/local/bin/

# Install waybackurls
print_status "Installing waybackurls..."
go install github.com/tomnomnom/waybackurls@latest
cp ~/go/bin/waybackurls /usr/local/bin/

# Install subfinder
print_status "Installing subfinder..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
cp ~/go/bin/subfinder /usr/local/bin/

# Install httpx
print_status "Installing httpx..."
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
cp ~/go/bin/httpx /usr/local/bin/

# Install nuclei
print_status "Installing nuclei..."
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
cp ~/go/bin/nuclei /usr/local/bin/

# Install katana
print_status "Installing katana..."
go install github.com/projectdiscovery/katana/cmd/katana@latest
cp ~/go/bin/katana /usr/local/bin/

# Install dnsx
print_status "Installing dnsx..."
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
cp ~/go/bin/dnsx /usr/local/bin/

# Install assetfinder
print_status "Installing assetfinder..."
go install github.com/tomnomnom/assetfinder@latest
cp ~/go/bin/assetfinder /usr/local/bin/

# Install amass
print_status "Installing amass..."
go install -v github.com/owasp-amass/amass/v4/...@master
cp ~/go/bin/amass /usr/local/bin/

# Install hakrawler
print_status "Installing hakrawler..."
go install github.com/hakluke/hakrawler@latest
cp ~/go/bin/hakrawler /usr/local/bin/

# Install Go for tools that need it
print_status "Installing Go..."
if ! command -v go &> /dev/null; then
    wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
    rm -rf /usr/local/go && tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
    echo 'export PATH=$PATH:~/go/bin' >> ~/.bashrc
    source ~/.bashrc
    rm go1.21.0.linux-amd64.tar.gz
fi

# Create configuration directory
print_status "Creating configuration directory..."
mkdir -p ~/.parameter_hunter/wordlists
mkdir -p ~/.parameter_hunter/templates
mkdir -p ~/.parameter_hunter/projects

# Download wordlists
print_status "Downloading wordlists..."

# Download from SecLists if available, otherwise use smaller lists
if [ -d "/usr/share/seclists" ]; then
    print_status "SecLists found, creating symlinks..."
    ln -sf /usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt \
        ~/.parameter_hunter/wordlists/parameters.txt
    ln -sf /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt \
        ~/.parameter_hunter/wordlists/subdomains.txt
else
    print_status "SecLists not found, downloading essential wordlists..."
    
    # Download parameter wordlist
    curl -s -L "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/burp-parameter-names.txt" \
        -o ~/.parameter_hunter/wordlists/parameters.txt
    
    # Download subdomain wordlist
    curl -s -L "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top1million-5000.txt" \
        -o ~/.parameter_hunter/wordlists/subdomains.txt
    
    # Download fuzz wordlist
    curl -s -L "https://raw.githubusercontent.com/Bo0oM/fuzz.txt/master/fuzz.txt" \
        -o ~/.parameter_hunter/wordlists/fuzz.txt
    
    # Download LFI wordlist
    curl -s -L "https://raw.githubusercontent.com/emadshanab/LFI-Payload-List/master/LFI%20payloads.txt" \
        -o ~/.parameter_hunter/wordlists/lfi.txt
    
    # Download XSS wordlist
    curl -s -L "https://raw.githubusercontent.com/payloadbox/xss-payload-list/master/Intruder/xss-payload-list.txt" \
        -o ~/.parameter_hunter/wordlists/xss.txt
fi

# Create default configuration
print_status "Creating default configuration..."
cat > ~/.parameter_hunter/config.yaml << 'EOF'
# Parameter Bug Hunter Pro Configuration

tools:
  arjun: /usr/local/bin/arjun
  sqlmap: /usr/bin/sqlmap
  ffuf: /usr/local/bin/ffuf
  gau: /usr/local/bin/gau
  waybackurls: /usr/local/bin/waybackurls
  subfinder: /usr/local/bin/subfinder
  httpx: /usr/local/bin/httpx
  nuclei: /usr/local/bin/nuclei
  katana: /usr/local/bin/katana
  dnsx: /usr/local/bin/dnsx
  assetfinder: /usr/local/bin/assetfinder
  amass: /usr/local/bin/amass
  hakrawler: /usr/local/bin/hakrawler
  nikto: /usr/bin/nikto
  nmap: /usr/bin/nmap

wordlists:
  parameters: ~/.parameter_hunter/wordlists/parameters.txt
  subdomains: ~/.parameter_hunter/wordlists/subdomains.txt
  fuzz: ~/.parameter_hunter/wordlists/fuzz.txt
  lfi: ~/.parameter_hunter/wordlists/lfi.txt
  xss: ~/.parameter_hunter/wordlists/xss.txt

api_keys:
  github: ""
  gitlab: ""
  shodan: ""
  censys_id: ""
  censys_secret: ""
  virustotal: ""
  binaryedge: ""
  hunterio: ""
  securitytrails: ""

proxy:
  http: ""
  https: ""
  socks5: ""

scan_settings:
  threads: 50
  timeout: 10
  retries: 3
  rate_limit: 10
  user_agent: "ParameterBugHunter/2.0"

reporting:
  auto_generate: true
  format: ["markdown", "json"]
  include_poc: true
  include_curl: true
  include_screenshots: false

notifications:
  slack_webhook: ""
  discord_webhook: ""
  telegram_bot_token: ""
  telegram_chat_id: ""
EOF

# Create example workflow template
print_status "Creating example workflow templates..."
cat > ~/.parameter_hunter/templates/quick_scan.yaml << 'EOF'
# Quick Scan Workflow Template

name: "Quick Security Scan"
description: "Basic reconnaissance and vulnerability scan"

steps:
  1:
    name: "Subdomain Enumeration"
    tools: ["subfinder", "assetfinder"]
    output: "subdomains.txt"
    
  2:
    name: "Live Host Detection"
    tools: ["httpx"]
    input: "subdomains.txt"
    output: "live_hosts.txt"
    
  3:
    name: "URL Discovery"
    tools: ["gau", "waybackurls"]
    input: "live_hosts.txt"
    output: "urls.txt"
    
  4:
    name: "Parameter Extraction"
    tools: ["arjun", "custom_extractor"]
    input: "urls.txt"
    output: "parameters.txt"
    
  5:
    name: "Basic Vulnerability Scan"
    tools: ["nuclei"]
    input: "live_hosts.txt"
    output: "vulnerabilities.txt"
    
  6:
    name: "XSS Testing"
    tools: ["custom_xss_tester"]
    input: "parameters.txt"
    output: "xss_findings.txt"
    
  7:
    name: "SQL Injection Testing"
    tools: ["sqlmap"]
    input: "parameters.txt"
    output: "sqli_findings.txt"
EOF

# Create comprehensive workflow template
cat > ~/.parameter_hunter/templates/comprehensive_scan.yaml << 'EOF'
# Comprehensive Security Assessment Template

name: "Full Security Assessment"
description: "Complete security assessment with all tests"

steps:
  1:
    name: "Target Setup"
    module: "target_setup"
    
  2:
    name: "Passive Reconnaissance"
    tools: ["subfinder", "amass", "assetfinder"]
    
  3:
    name: "Active Reconnaissance"
    tools: ["nmap", "httpx", "katana"]
    
  4:
    name: "URL & Endpoint Discovery"
    tools: ["gau", "waybackurls", "hakrawler"]
    
  5:
    name: "JavaScript Analysis"
    module: "javascript_analysis"
    
  6:
    name: "Parameter Extraction"
    tools: ["arjun", "custom_extractor"]
    
  7:
    name: "Parameter Classification"
    module: "parameter_classification"
    
  8:
    name: "Automated Vulnerability Scanning"
    tools: ["nuclei", "nikto"]
    
  9:
    name: "SQL Injection Testing"
    module: "sql_injection_testing"
    
  10:
    name: "XSS Testing"
    module: "xss_testing"
    
  11:
    name: "Server-Side Testing"
    module: "server_side_testing"
    
  12:
    name: "Business Logic Testing"
    module: "business_logic_testing"
    
  13:
    name: "Advanced Techniques"
    module: "advanced_techniques"
    
  14:
    name: "Validation & Verification"
    module: "validation"
    
  15:
    name: "Report Generation"
    module: "reporting"
EOF

# Set permissions
print_status "Setting permissions..."
chmod -R 755 ~/.parameter_hunter
chmod +x parameter_hunter.py

# Create alias for easy access
print_status "Creating bash alias..."
echo "" >> ~/.bashrc
echo "# Parameter Bug Hunter Pro" >> ~/.bashrc
echo "alias pbh='python3 $(pwd)/parameter_hunter.py'" >> ~/.bashrc
echo "alias parameter-hunter='source venv/bin/activate && python3 $(pwd)/parameter_hunter.py'" >> ~/.bashrc

# Create desktop shortcut (if GUI is available)
if [ -d "/usr/share/applications" ]; then
    print_status "Creating desktop shortcut..."
    cat > /usr/share/applications/parameter-hunter.desktop << 'EOF'
[Desktop Entry]
Name=Parameter Bug Hunter Pro
Comment=Comprehensive Parameter Analysis Framework
Exec=python3 /root/menu/parameter_hunter.py
Icon=/usr/share/icons/gnome/32x32/apps/utilities-terminal.png
Terminal=true
Type=Application
Categories=Utility;Security;
Keywords=security;bugbounty;hacking;
EOF
fi

# Create systemd service for background scanning
print_status "Creating systemd service..."
cat > /etc/systemd/system/parameter-hunter.service << 'EOF'
[Unit]
Description=Parameter Bug Hunter Pro Background Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/menu
ExecStart=/root/menu/venv/bin/python3 /root/menu/parameter_hunter.py --daemon
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Create utility scripts
print_status "Creating utility scripts..."

# Update script
cat > update_pbh.sh << 'EOF'
#!/bin/bash
echo "Updating Parameter Bug Hunter Pro..."
cd /root/menu
git pull origin main
pip install -r requirements.txt --upgrade
echo "Update complete!"
EOF
chmod +x update_pbh.sh

# Backup script
cat > backup_pbh.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/root/pbh_backups"
mkdir -p $BACKUP_DIR
BACKUP_FILE="$BACKUP_DIR/pbh_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
tar -czf $BACKUP_FILE ~/.parameter_hunter /root/menu/projects
echo "Backup created: $BACKUP_FILE"
EOF
chmod +x backup_pbh.sh

# Test installation
print_status "Testing installation..."
if python3 -c "import colorama, requests, yaml" &> /dev/null; then
    print_success "Python packages installed successfully"
else
    print_error "Python package installation failed"
fi

# Check tools
print_status "Checking installed tools..."
TOOLS=("sqlmap" "ffuf" "nmap" "nikto")
for tool in "${TOOLS[@]}"; do
    if command -v $tool &> /dev/null; then
        print_success "$tool is installed"
    else
        print_warning "$tool is not installed"
    fi
done

# Final message
echo ""
echo "======================================================================"
echo -e "${GREEN}              INSTALLATION COMPLETE!${NC}"
echo "======================================================================"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Source your bashrc: ${BLUE}source ~/.bashrc${NC}"
echo "2. Activate virtual environment: ${BLUE}source venv/bin/activate${NC}"
echo "3. Run the tool: ${BLUE}python3 parameter_hunter.py${NC}"
echo "4. Or use alias: ${BLUE}pbh${NC}"
echo ""
echo -e "${YELLOW}Configuration:${NC}"
echo "- Edit config: ${BLUE}~/.parameter_hunter/config.yaml${NC}"
echo "- Add API keys for enhanced functionality"
echo "- Check templates: ${BLUE}~/.parameter_hunter/templates/${NC}"
echo ""
echo -e "${YELLOW}Utility scripts:${NC}"
echo "- Update tool: ${BLUE}./update_pbh.sh${NC}"
echo "- Backup data: ${BLUE}./backup_pbh.sh${NC}"
echo ""
echo -e "${GREEN}Happy Hunting!${NC}"
echo "======================================================================"
