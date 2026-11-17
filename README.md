# env-parity

`env-parity` is an Ansible-based infrastructure automation project designed to provision, configure, and continuously verify baseline infrastructure and web server environments across staging and production targets. It uses modular roles and environment-specific group variables to ensure consistent state and prevent configuration drift.

---

## Project Structure

```text
.
├── inventory/                  # Environment-specific inventories
│   ├── production/             # Production environment configuration
│   │   ├── group_vars/         # Production group variables (e.g., worker processes, server name)
│   │   └── host.ini            # Production target hosts mapping
│   └── staging/                # Staging environment configuration
│       ├── group_vars/         # Staging group variables
│       └── host.ini            # Staging target hosts mapping
├── roles/                      # Reusable Ansible roles
│   ├── common/                 # Base package management (curl, ca-certificates)
│   ├── firewall/               # Baseline firewall package and status checks (iptables)
│   └── nginx/                  # Nginx web server deployment, custom templates, and handlers
├── scripts/                    # Helper scripts for local container lifecycle management
├── site.yml                    # Main infrastructure orchestration playbook
├── verify.yml                  # Infrastructure drift-detection and validation playbook
├── pyproject.toml              # Python project & dependency configuration (Ansible, Lint)
└── uv.lock                     # Locked dependencies

```

---

## Core Components & Roles

1. **`common`**: Prepares the OS environment (targeting Alpine Linux via `apk`), updates package caches, and installs essential utilities (`curl`, `ca-certificates`).
2. **`firewall`**: Ensures baseline security packages (`iptables`) are present and performs read-only checks on active firewall rules.
3. **`nginx`**: Handles Nginx installation, configures web root directories, deploys default index pages, renders custom configurations from templates (`nginx.conf.j2`), handles service reloads, and ensures the Nginx process is active.

---

## Getting Started

### Prerequisites

* Python >= 3.12
* [uv](https://github.com/astral-sh/uv) or standard Python virtual environment tooling
* Docker (if running/testing locally against target containers)

### Setup Virtual Environment

Initialize the environment and install Python dependencies defined in `pyproject.toml`:

```bash
uv sync
source .venv/bin/activate

```

---

## Usage

### 1. Local Testing Environment Lifecycle

Helper scripts are available under `scripts/` to spin up and manage a local Docker-based Alpine target container for testing:

* **Start/Reset Local Target Container:**
```bash
./scripts/run-localhost.sh

```


* **Enter Local Target Container Shell:**
```bash
./scripts/enter-localhost.sh

```


* **Stop Local Target Container:**
```bash
./scripts/stop-localhost.sh

```



---

### 2. Running Playbooks

#### Provisioning / Configuration (`site.yml`)

To configure your target environments, run the main playbook pointing to your desired inventory (`staging` or `production`):

* **Staging:**
```bash
ansible-playbook -i inventory/staging/host.ini site.yml

```


* **Production:**
```bash
ansible-playbook -i inventory/production/host.ini site.yml

```



#### Infrastructure Verification & Drift Detection (`verify.yml`)

To validate that your target nodes match the desired baseline state (checking package presence, process health, and template config values like `worker_processes` and `server_name`), run the verification playbook in check mode:

* **Staging Verification:**
```bash
ansible-playbook -i inventory/staging/host.ini verify.yml

```


* **Production Verification:**
```bash
ansible-playbook -i inventory/production/host.ini verify.yml

```