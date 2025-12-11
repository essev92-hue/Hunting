# Parameter Bug Hunter Pro 🐛

A comprehensive parameter analysis framework for bug bounty hunters and security researchers.

## Features

### 🔍 **Reconnaissance & Discovery**
- Target scope definition
- Subdomain enumeration
- URL collection from multiple sources
- JavaScript analysis
- Wayback Machine integration
- GitHub/GitLab recon

### 📊 **Parameter Analysis**
- Parameter extraction from URLs
- Hidden parameter discovery (Arjun)
- API endpoint discovery
- GraphQL schema analysis
- Parameter classification
- Risk assessment

### ⚔️ **Testing Suite**
- SQL injection testing (sqlmap integration)
- XSS testing (DOM/Reflected/Stored)
- Server-side attacks (LFI/RFI, SSRF, XXE)
- API-specific testing
- Business logic testing

### 📋 **Reporting**
- Vulnerability templates
- Evidence collection
- Multiple export formats (Markdown, PDF, HackerOne)
- Executive summaries

## Installation

```bash
# Clone repository
git clone https://github.com/essev92-hue/Hunting.git
cd Hunting

# Run installation script
chmod +x install.sh
./install.sh

# Install Python dependencies
pip3 install -r requirements.txt
