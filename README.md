# **cisco-enterprise-gns3-network**

Comprehensive Cisco enterprise network built in GNS3 demonstrating scalable
multi-site architecture incorporating core switching concepts, advanced
routing protocols, integrated security controls, and high-availability design.
Features structured technical documentation, network topology diagrams,
automated connectivity testing, and failover validation complete with
implementation details and validation results.

---

## Table of Contents

1. [Overview](#1-overview)  
&nbsp;&nbsp;1.1 [Network Purpose and Scope](#11-network-purpose-and-scope)  
&nbsp;&nbsp;1.2 [Technologies and Skills Demonstrated](#12-technologies-and-skills-demonstrated)  
2. [Network Architecture and Design](#2-network-architecture-and-design)  
&nbsp;&nbsp;2.1 [IP Addressing Scheme](#21-ip-addressing-scheme)  
&nbsp;&nbsp;2.2 [Network Topology](#22-network-topology)  
&nbsp;&nbsp;2.3 [Device Inventory](#23-device-inventory)  
&nbsp;&nbsp;2.5 [Interface and IP Assignments](#25-interface-and-ip-assignments)  
3. [Implementation](#3-implementation)  
&nbsp;&nbsp;3.1 [Edge Site (Network Perimeter)](#31-edge-site-network-perimeter)  
&nbsp;&nbsp;3.2 [Main Site](#32-main-site)  
&nbsp;&nbsp;3.3 [Server Room](#33-server-room)  
&nbsp;&nbsp;3.4 [Warehouse](#34-warehouse)  
&nbsp;&nbsp;3.5 [Remote Site](#35-remote-site)  
&nbsp;&nbsp;3.6 [Network Device Hardening](#36-network-device-hardening)  
&nbsp;&nbsp;3.7 [External Connectivity and Testing](#37-external-connectivity-and-testing)  
4. [Testing and Validation](#4-testing-and-validation)  
&nbsp;&nbsp;4.1 [Internal Host Connectivity](#41-internal-host-connectivity)  
&nbsp;&nbsp;4.2 [External Host Connectivity](#42-external-host-connectivity)  
&nbsp;&nbsp;4.3 [OSPF Validation](#43-ospf-validation)  
&nbsp;&nbsp;4.4 [HSRP Validation](#44-hsrp-validation)  
5. [Appendices](#appendices)  
&nbsp;&nbsp;A. [Device Configuration Files](#a-device-configuration-files)  
&nbsp;&nbsp;B. [References](#b-references)  
&nbsp;&nbsp;C. [License](#c-license)  

---

## 1. Overview

### 1.1 Network Purpose and Scope

This repository presents more than a collection of configured devices:
it demonstrates enterprise-grade network architecture built for scale,
security, and resilience. The implementation employs VLAN segmentation with
EtherChannel for resilient switching, leverages OSPF and HSRP for redundant
routing paths, and integrates ASA firewalls with ACLs and VPN tunnels to
enforce defense-in-depth security. These integrated technologies, validated
through automated testing and presented with comprehensive documentation,
create an infrastructure designed to support critical business operations.

Developed through a combination of real-world experience, formal CCNA
curriculum through Cisco Networking Academy, self-study, and hands-on
experimentation with Cisco IOS and ASA platforms, this project showcases
my ability to design, configure, and document enterprise network
infrastructure in alignment with industry best practices.

This repository is intended for technical professionals and hiring managers
seeking to evaluate my practical understanding of enterprise networking and
security principles. I invite you to explore the implementation details that
follow, which reflect both my networking expertise and my approach to
engineering production-ready infrastructure.

### 1.2 Technologies and Skills Demonstrated

This section highlights the key technologies and networking concepts
demonstrated throughout the network implementation.

#### Routing and Switching

- Variable Length Subnet Masking (VLSM) for efficient IP allocation
- Open Shortest Path First (OSPF) for dynamic routing
- Hot Standby Router Protocol (HSRP) for gateway redundancy
- Inter-VLAN routing for network segmentation
- Layer 2 switching (access and trunk ports)
- Layer 3 routing (subinterfaces)
- Layer 3 switching using Switched Virtual Interfaces (SVI)
- VLAN Trunking Protocol (VTP) for VLAN synchronization
- EtherChannel with LACP for link aggregation and redundancy
- Rapid PVST+ for loop prevention and per-VLAN spanning tree configuration
- Manual root bridge assignment for VLANs to control traffic paths

#### Security

- Internet Key Exchange version 2 (IKEv2) and IPsec for secure tunneling
- Access Control Lists (ACLs) for traffic filtering and policy enforcement
- Static and dynamic NAT/PAT for address translation
- Port security (MAC limiting, PortFast, BPDU Guard) to prevent unauthorized
  access
- Secure remote access via SSH version 2
- Access control for VTY lines using ACLs
- Disabling of insecure services (Telnet, HTTP, CDP, DTP)

#### Network Services

- Dynamic Host Configuration Protocol (DHCP) for IP address assignment
- Network Time Protocol (NTP) for clock synchronization
- HTTP server deployment for service demonstration
- Static NAT for internal server accessibility

#### Automation and Testing

- Bash scripting for automated network validation
- End-to-end testing of connectivity, NAT, and ACL policies
- Public IP range simulation for external access testing
- External client simulation for validating web service accessibility

#### Simulation and Management

- GNS3 virtualization platform for network simulation
- GNS3 Cloud Appliance for integration with the host network

---

## 2. Network Architecture and Design

### 2.1 IP Addressing Scheme

The network uses private IPv4 address space for internal segmentation and
simulated public ranges to demonstrate external server access, internet
connectivity, and site-to-site VPN operations, with a scheme designed to
ensure segmentation, consistent subnetting, and scalability.

Point-to-point links use `/30` subnets for efficient utilization.
Main Site links range from `172.16.1.0/30` to `172.16.1.24/30`.
The Remote Site uses `172.16.2.0/30`.

User VLANs are assigned `/24` subnets for scalability and manageability.
Main Site VLANs reside in the `10.1.0.0/16` block.
Remote Site VLANs reside in the `10.2.0.0/16` block.
Each VLAN is assigned a network-aligned default gateway.

Public simulation ranges include `172.20.1.0/29` (Main Site),
`172.25.1.0/24` (Remote Site), and `172.30.1.0/24` (simulated external host).
These ranges are used to model NAT and internet access scenarios.

### 2.2 Network Topology

![Network Topology Diagram](topology.png)

### 2.3 Device Inventory

The following virtual appliances were used in the GNS3 simulation environment:

| Device Type | GNS3 Appliance      | Image Type | OS/Version               |
|-------------|---------------------|------------|--------------------------|
| Router      | Cisco IOSv          | QEMU       | Cisco IOS 15.9(3)M9      |
| Switch      | Cisco IOSvL2        | QEMU       | Cisco IOS 15.2(20200924) |
| ASA         | Cisco ASAv          | QEMU       | Cisco ASA 9.22(1)1       |
| End Host    | Alpine Linux        | Docker     | Alpine Linux 3.22.0      |
| Server      | Networkers' Toolbox | Docker     | Ubuntu 20.04.2 LTS       |

### 2.4 VLAN Table

| Location    | VLAN | Name       | Network       |
| ------------| ---- | ---------- | ------------- |
| Server Room | 10   | Server     | 10.1.10.0 /24 |
| Main Site   | 20   | NetAdmin   | 10.1.20.0 /24 |
|             | 30   | Sales      | 10.1.30.0 /24 |
|             | 40   | Marketing  | 10.1.40.0 /24 |
|             | 50   | Accounting | 10.1.50.0 /24 |
|             | 60   | Management | 10.1.60.0 /24 |
| Warehouse   | 70   | Shipping   | 10.1.70.0 /24 |
|             | 80   | Receiving  | 10.1.80.0 /24 |
| Remote Site | 20   | NetAdmin   | 10.2.20.0 /24 |
|             | 30   | Sales      | 10.2.30.0 /24 |
|             | 70   | Shipping   | 10.2.70.0 /24 |

### 2.5 Interface and IP Assignments

| Device       | Interface | Description                   | Address          |
| ------------ | --------- | ------------------------------| ---------------- |
| CLOUD        | G0/0      | Host Network Gateway                             |
|              | G0/1      | Cloud Gateway for ASA-MAIN    | 172.20.1.1 /29   |
|              | G0/2      | Cloud Gateway for ASA-REMOTE  | 172.25.1.1 /24   |
|              | G0/3      | Cloud Gateway for Web-Client  | 172.30.1.1 /24   |
| ASA-MAIN     | G0/0      | Link to CLOUD                 | 172.20.1.2 /29   |
|              | G0/1      | Link to EDGE                  | 172.16.1.1 /30   |
| EDGE         | G0/0      | Link to ASA-MAIN              | 172.16.1.2 /30   |
|              | G0/1      | Link to R1                    | 172.16.1.6 /30   |
|              | G0/2      | Link to R2                    | 172.16.1.10 /30  |
|              | G0/3      | Link to SW-EDGE               | 172.16.1.14 /30  |
| R1           | G0/0      | Link to EDGE                  | 172.16.1.5 /30   |
|              | G0/1      | Link to R2                    | 172.16.1.17 /30  |
|              | G0/2      | Link to SW-WAREHOUSE          | 172.16.1.21 /30  |
|              | G0/3      | Trunk Link to SW-FLOOR-1                         |
|              | G0/3.20   | NetAdmin VLAN 20 Gateway      | 10.1.20.2 /24    |
|              | G0/3.30   | Sales VLAN 30 Gateway         | 10.1.30.2 /24    |
|              | G0/3.40   | Marketing VLAN 40 Gateway     | 10.1.40.2 /24    |
|              | G0/3.50   | Accounting VLAN 50 Gateway    | 10.1.50.2 /24    |
|              | G0/3.60   | Management VLAN 60 Gateway    | 10.1.60.2 /24    |
| R2           | G0/0      | Link to EDGE                  | 172.16.1.9 /30   |
|              | G0/1      | Link to R1                    | 172.16.1.18 /30  |
|              | G0/2      | Trunk Link to SW-FLOOR-1                         |
|              | G0/2.20   | NetAdmin VLAN 20 Gateway      | 10.1.20.1 /24    |
|              | G0/2.30   | Sales VLAN 30 Gateway         | 10.1.30.1 /24    |
|              | G0/2.40   | Marketing VLAN 40 Gateway     | 10.1.40.1 /24    |
|              | G0/2.50   | Accounting VLAN 50 Gateway    | 10.1.50.1 /24    |
|              | G0/2.60   | Management VLAN 60 Gateway    | 10.1.60.1 /24    |
|              | G0/3      | Link to SW-WAREHOUSE          | 172.16.1.25 /30  |
| SW-FLOOR-1   | VLAN 20   | Management SVI                | 10.1.20.11 /24   |
|              | G0/0      | Trunk Link to R2                                 |
|              | G0/1      | Trunk Link to R1                                 |
|              | G3/0-1    | Port Channel 2                                   |
|              | G3/2-3    | Port Channel 1                                   |
|              | Po1       | Trunk Link to SW-FLOOR-2                         |
|              | Po2       | Trunk Link to SW-FLOOR-3                         |
| SW-FLOOR-2   | VLAN 20   | Management SVI                | 10.1.20.12 /24   |
|              | G3/0-1    | Port Channel 3                                   |
|              | G3/2-3    | Port Channel 1                                   |
|              | Po1       | Trunk Link to SW-FLOOR-1                         |
|              | Po3       | Trunk Link to SW-FLOOR-3                         |
| SW-FLOOR-3   | VLAN 20   | Management SVI                | 10.1.20.13 /24   |
|              | G3/0-1    | Port Channel 3                                   |
|              | G3/2-3    | Port Channel 2                                   |
|              | Po2       | Trunk Link to SW-FLOOR-1                         |
|              | Po3       | Trunk Link to SW-FLOOR-2                         |
| SW-EDGE      | VLAN 10   | Server VLAN 10 Gateway        | 10.1.10.1 /24    |
|              | G0/0      | Link to EDGE                  | 172.16.1.13 /30  |
| Server-01    | VLAN 10   | Public Web Server 1           | 10.1.10.10 /24   |
| Server-02    | VLAN 10   | Public Web Server 2           | 10.1.10.20 /24   |
| Server-03    | VLAN 10   | Public Web Server 3           | 10.1.10.30 /24   |
| SW-WAREHOUSE | VLAN 70   | Shipping VLAN 70 Gateway      | 10.1.70.1 /24    |
|              | VLAN 80   | Receiving VLAN 80 Gateway     | 10.1.80.1 /24    |
|              | G0/0      | Link to R1                    | 172.16.1.22 /30  |
|              | G0/1      | Link to R2                    | 172.16.1.26 /30  |
| ASA-REMOTE   | G0/0      | Link to CLOUD                 | 172.25.1.2 /24   |
|              | G0/1      | Link to SW-REMOTE             | 172.16.2.1 /30   |
| SW-REMOTE    | VLAN 20   | NetAdmin VLAN 20 Gateway      | 10.2.20.1 /24    |
|              | VLAN 30   | Sales VLAN 30 Gateway         | 10.2.30.1 /24    |
|              | VLAN 70   | Shipping VLAN 70 Gateway      | 10.2.70.1 /24    |
|              | G0/0      | Link to ASA-REMOTE            | 172.16.2.2 /30   |
| Web-Client             | | Simulated External Web Client | 172.30.1.2 /24   |
| GNS3 Cloud Appliance   | | Host Network Bridge                              |
| HSRP                   | | VLAN 20 Virtual Gateway       | 10.1.20.3 /24    |
|                        | | VLAN 30 Virtual Gateway       | 10.1.30.3 /24    |
|                        | | VLAN 40 Virtual Gateway       | 10.1.40.3 /24    |
|                        | | VLAN 50 Virtual Gateway       | 10.1.50.3 /24    |
|                        | | VLAN 60 Virtual Gateway       | 10.1.60.3 /24    |

---

## 3. Implementation

This section outlines the implementation of the network design, organized
in a logical progression: starting with the network perimeter, followed by
internal sites, then the remote site, and concluding with the devices used
to validate external connectivity and verify security policies.

### 3.1 Edge Site (Network Perimeter)

#### Overview

The **Edge Site** serves as the network perimeter, functioning as the primary
gateway for internet access, external connectivity, and security enforcement.
The two components of this site are the `EDGE` Router and the Cisco Adaptive
Security Appliance `ASA-MAIN`, which ensure controlled and secure
communication between internal and external networks.

#### ASA-MAIN

- **Role:** Acts as the primary network perimeter security device, enforcing
  security policies and controlling internal access to the remote site and
  the internet.

- **Key Features:**
  - **Network Address Translation (NAT/PAT):**
    - Static NAT for internal servers using IPs `172.20.1.3` - `172.20.1.5`.
    - Dynamic PAT for all internal hosts using IP `172.20.1.6`.
  - **Access Control Lists (ACLs):**
    - Extended ACL applied to the `outside` interface to allow external
      HTTP/HTTPS and ICMP traffic to internal servers.
    - Crypto ACL to determine whether outbound traffic is routed via NAT/PAT
      or encapsulated in the site-to-site VPN tunnel.
  - **Stateful Inspection:** Ensures only legitimate, session-aware traffic
    is allowed through the perimeter.
  - **Site-to-Site IKEv2 VPN:** A secure, encrypted tunnel established with
    `ASA-REMOTE` using IP `172.20.1.2` to maintain confidentiality and
    integrity of data transmitted between the main network and the remote site.

- **Connectivity:**
  - **Outside Interface:**
    Connected to the `CLOUD` Router for internet access.
  - **Inside Interface:**
    Connected to `EDGE` Router for internal network access.

#### EDGE Router

- **Role:** Serves as the central aggregation point for internal traffic,
  while also providing DHCP and NTP network services.

- **Key Features:**
  - **Default Route:** Configured to forward all external-bound traffic to
    `ASA-MAIN`.
  - **OSPF Routing:** Participates in the OSPF routing domain to ensure
    dynamic path selection and redundancy within the internal network.
  - **DHCP Server:** Provides dynamic IP address allocation to internal
    clients across the network.
  - **NTP Server:** Functions as the primary NTP master, synchronizing time
    across all network devices for consistency and accurate logging.

- **Connectivity:**
  - Connected to `ASA-MAIN` inside interface for internet access.
  - Connected to `SW-EDGE` for access to the Server Room.
  - Connected to `R1` and `R2` to facilitate internal site routing.

### 3.2 Main Site

#### Overview

The **Main Site** serves as the central operational hub of the network,
hosting end-user devices, departmental VLANs, and core connectivity to
internal and external services. The architecture incorporates redundancy
and segmentation through the use of multiple Layer 2 switches and dual
Layer 3 routers (`R1` and `R2`) to support inter-VLAN routing and failover
capabilities.

#### SW-FLOOR-1, SW-FLOOR-2, SW-FLOOR-3 (Layer 2 Switches)

- **Role:** Provide connectivity for end-user devices across multiple
  departments and physical floors.

- **Key Features:**
  - **VLAN Trunking:** Interfaces configured as trunks to carry traffic for
    multiple VLANs between switches.
  - **VLAN Trunking Protocol (VTP):** `SW-FLOOR-1` operates as the VTP server,
    with `SW-FLOOR-2` and `SW-FLOOR-3` configured as VTP clients to ensure
    consistent VLAN database synchronization.
  - **EtherChannel:** Trunk links between switches utilize LACP-based
    EtherChannel for increased bandwidth, redundancy, and fault tolerance.
  - **Inter-VLAN Routing:** Connected to `R2` for primary inter-VLAN routing,
    with a backup connection to `R1`.
  - **Rapid PVST+ Configuration:**
    - Rapid Per-VLAN Spanning Tree (PVST+) enabled across all VLANs to prevent
      loops and ensure Layer 2 redundancy.
    - **Root Primaries:**
      - `SW-FLOOR-1`: VLANs 20 (NetAdmin), 30 (Sales)
      - `SW-FLOOR-2`: VLANs 40 (Marketing), 50 (Accounting)
      - `SW-FLOOR-3`: VLAN 60 (Management)
    - **Root Secondaries:**
      - `SW-FLOOR-1`: VLAN 60 (Management)
      - `SW-FLOOR-2`: VLANs 20 (NetAdmin), 30 (Sales)
      - `SW-FLOOR-3`: VLANs 40 (Marketing), 50 (Accounting)
    - Bridge priorities have been configured to ensure predictable election of
      root bridges during both normal operation and failover scenarios.

- **Connectivity:**
  - End-user devices connected via access ports assigned to specific VLANs.
  - Trunk links established between switches using EtherChannel.
  - `SW-FLOOR-1` connects to both `R2` and `R1` to ensure routing redundancy.

#### R1 (Layer 3 Router)

- **Role:** Primary router for `SW-WAREHOUSE` and backup inter-VLAN router
  for `SW-FLOOR-1`.

- **Key Features:**
  - **Inter-VLAN Routing:** Configured with subinterfaces to support
    inter-VLAN communication.
  - **OSPF Routing:** Participates in the internal OSPF routing domain with
    an adjusted cost metric to prioritize traffic from `SW-WAREHOUSE`.
  - **HSRP Configuration:** Subinterfaces are configured with HSRP to
    provide redundancy for VLAN routing.

- **Connectivity:**
  - Connected to `EDGE` Router for access to core services and the internet.
  - Primary connection to `SW-WAREHOUSE` for warehouse VLAN traffic.
  - Backup connection to `SW-FLOOR-1` for inter-VLAN routing redundancy.

#### R2 (Layer 3 Router)

- **Role:** Primary inter-VLAN router for `SW-FLOOR-1` and backup router for
  `SW-WAREHOUSE`.

- **Key Features:**
  - **Inter-VLAN Routing:** Configured with subinterfaces to support
    inter-VLAN communication.
  - **OSPF Routing:** Participates in the internal OSPF routing domain with
    an adjusted cost metric to prioritize traffic from `SW-FLOOR-1`.
  - **HSRP Configuration:** Subinterfaces are configured with HSRP to
    provide redundancy for VLAN routing, with priority and preemption enabled.

- **Connectivity:**
  - Connected to `EDGE` Router for access to core services and the internet.
  - Primary connection to `SW-FLOOR-1` for inter-VLAN routing.
  - Backup connection to `SW-WAREHOUSE` for redundancy.

### 3.3 Server Room

#### Overview

The **Server Room** serves as the centralized location for hosting internal
and external network services. In this topology, HTTP servers are used to
demonstrate secure access from both internal users and external clients.
The design is scalable and can be extended to accommodate additional
services such as application or database servers.

#### SW-EDGE (Layer 3 Switch)

- **Role:** Acts as the gateway for the server VLAN and provides connectivity
  to the **Edge Site**.

- **Key Features:**
  - **Switched Virtual Interface (SVI):** Configured on the switch to provide
    Layer 3 reachability for the server VLAN.
  - **OSPF Integration:** Participates in the internal OSPF routing domain to
    ensure seamless communication with other network segments.

- **Connectivity:**
  - Servers are connected to access ports assigned to the dedicated server
    VLAN.
  - Connected to the `EDGE` Router to enable communication with internal
    clients and external internet access via `ASA-MAIN`.

#### Servers

- **Role:** Host internal and externally accessible HTTP services,
  demonstrating secure service delivery and network segmentation.

- **Key Features:**
  - **Dedicated VLAN Assignment:** Servers reside on a separate VLAN to
    enforce network segmentation and enhance security.
  - **Static IP Addressing:** Servers are configured with static IP
    addresses for reliable service access and NAT configuration.
  - **Controlled Accessibility:** Access to these servers from external
    networks is governed by access control rules and facilitated via static
    NAT on `ASA-MAIN`.

- **Connectivity:**
  - **Internal Access:** Connected to `SW-EDGE` for communication with
    internal clients.
  - **External Access:** Enabled through static NAT and ACLs configured on
    `ASA-MAIN`.

### 3.4 Warehouse

#### Overview

The **Warehouse** site functions as a supporting network segment located
adjacent to the **Main Site**. The current topology includes a single Layer 3
switch and is designed to accommodate future expansion, such as the addition
of wireless access points, inventory systems, logistics devices, and other
operational tools used in warehouse management.

#### SW-WAREHOUSE (Layer 3 Switch)

- **Role:** Serves as the central switching and routing point for the
  Warehouse network, supporting both Layer 2 connectivity and inter-VLAN
  communication.

- **Key Features:**
  - **VLAN Segmentation:** Multiple VLANs configured to support different
    types of warehouse devices.
  - **Layer 3 Routing via SVIs:** Switched Virtual Interfaces (SVIs)
    configured to provide Layer 3 connectivity and enable local inter-VLAN
    routing.
  - **OSPF Integration:** Participates in the internal OSPF routing domain to
    maintain dynamic reachability and support seamless integration with the
    rest of the network.

- **Connectivity:**
  - End-user devices connected via access ports assigned to specific VLANs.
  - Connected to `R1` (primary) and `R2` (backup) in the Main Site to ensure
    redundant routing paths and network resilience.

### 3.5 Remote Site

#### Overview

The **Remote Site** represents a geographically separate location such as a
home office, branch office, or satellite facility. It maintains secure
connectivity to the main network via a site-to-site **IKEv2 VPN tunnel** and
provides local network services to remote users. This design supports
secure, scalable, and segmented access to both local and corporate resources.

#### SW-REMOTE (Layer 3 Switch)

- **Role:** Provides integrated Layer 2 access and Layer 3 routing for local
  users and devices.

- **Key Features:**
  - **VLAN Segmentation:** Separate VLANs configured to ensure logical
    separation of user traffic across the site-to-site VPN tunnel.
  - **Layer 3 Routing via SVIs:** Switched Virtual Interfaces (SVIs)
    configured to provide Layer 3 connectivity and enable local inter-VLAN
    routing.

- **Connectivity:**
  - End-user devices connected via access ports assigned to specific VLANs.
  - Connected to `ASA-REMOTE` inside interface for internet access.

#### ASA-REMOTE

- **Role:** Acts as the security gateway for the Remote Site, enforcing access
  control and managing secure connectivity to the Edge Site.

- **Key Features:**
  - **Port Address Translation (PAT):** Enables internal hosts to access the
    internet using a shared public IP address.
  - **Access Control Lists (ACLs):** Crypto ACLs determine whether traffic is
    routed directly to the internet via PAT or encapsulated and sent through
    the site-to-site VPN tunnel.
  - **Stateful Inspection:** Ensures only legitimate, session-aware traffic
    is allowed through the perimeter.
  - **Site-to-Site IKEv2 VPN:** A secure, encrypted tunnel established with
    `ASA-MAIN` to maintain confidentiality and integrity of data transmitted
    between the Remote Site and the main network.

- **Connectivity:**
  - **Outside Interface:** Connected to the `CLOUD` Router for internet
    access.
  - **Inside Interface:** Connected to `SW-REMOTE` for local network access.

### 3.6 Network Device Hardening

In addition to their functional roles, all network devices have been
configured with security best practices in mind:

- **Switchport Security:**
  - All unused switchports have been manually shut down.
  - Switchports are configured by default as access ports and assigned to a
    non-routable VLAN to prevent unauthorized access and mitigate potential
    VLAN hopping attacks.
  - Access ports are configured to dynamically learn MAC addresses,
    permitting a total of two MAC addresses before a security violation occurs.
  - Access ports are configured to use PortFast and BPDU Guard to mitigate STP
    manipulation attacks.

- **Secure Remote Access:**
  - All devices are configured to allow SSH-only remote management.
  - SSH version 2 is enforced with strong encryption and authentication.
  - Access to VTY lines is restricted using ACLs that permit connections only
    from authorized NetAdmin networks.
  - Telnet access is explicitly disabled.

- **Unnecessary Services Disabled:**
  - Cisco Discovery Protocol (CDP) is disabled on all devices to mitigate the
    potential exploitation of network infrastructure vulnerabilities.
  - HTTP and HTTPS server functions are disabled on all devices, as they are
    not required for network operation and pose a potential security risk if
    left enabled.
  - Dynamic Trunking Protocol (DTP) is disabled on all switchports.

> [!NOTE]
> For demonstration and ease of review, the following non-secure settings
> have been intentionally configured:
> - Console and AUX port passwords have been disabled.
> - Privileged EXEC (enable) password has been disabled.
> - `exec-timeout` has been set to `0 0` to prevent session timeouts.
> - `privilege level` has been set to `15` to provide immediate access to
>   privileged EXEC mode.
>
> These configurations are **not suitable for production environments** and are
> applied solely to improve accessibility during evaluation.

### 3.7 External Connectivity and Testing

#### Overview

This section outlines the **external connectivity components** used to
validate the network's behavior under real-world conditions. These elements
are not part of the internal enterprise network but are essential for
testing **NAT policies**, **access control rules**, and **internet access**.
The network uses simulated public IP ranges to represent the **Main Site**,
**Remote Site**, and a test client.

#### CLOUD Router

- **Role:** Functions as a simulated ISP gateway, used to represent external
routing and enable connectivity between public IP ranges.

- **Key Features:**
  - **Static Routing:** Configured with static routes to allow return traffic
    for NAT-translated communications.
  - **Public IP Simulation:** Used to simulate public IP ranges for:
    - **Main Site:** `172.20.1.2` - `172.20.1.6`
    - **Remote Site:** `172.25.1.2`
    - **External Web Client:** `172.30.1.2`
  - **Connectivity Testing:** Enables testing of site-to-site communication,
    NAT policies, and internet access.

- **Connectivity:**
  - Connected to `ASA-MAIN` outside interface.
  - Connected to `ASA-REMOTE` outside interface.
  - Connected to `Web-Client` to simulate an external host.

#### GNS3-CLOUD (GNS3 Cloud Appliance)

- **Role:** Provides a bridge between the GNS3 virtual network and the host
  machine's physical network.

- **Key Features:**
  - **Host Network Integration:** Connected to the host machine's ethernet
    adapter, allowing the virtual network to reach external DNS, web services,
    or perform software updates.
  - **Not Part of Logical Design:** This device is used solely for **testing
    and connectivity purposes** within the simulation environment and does
    not represent a real enterprise network component.

- **Connectivity:**
  - Connected to `CLOUD` Router to provide internet access.
  - Connected to internet via host ethernet adapter.

#### Web-Client (Simulated External Host)

- **Role:** Represents an internet-based client accessing internal
  HTTP services behind `ASA-MAIN`.

- **Key Features:**
  - **Static IP Configuration:** Assigned the IP `172.30.1.2` to simulate an
    external web client.
  - **Testing Capabilities:**
    - Static NAT is correctly translating internal server addresses.
    - ACLs are permitting HTTP/HTTPS and ICMP traffic.
    - Web services are accessible from outside the network.

- **Connectivity:**
  - Connected to `CLOUD` Router for simulated internet access.

---

## 4. Testing and Validation

This section validates the network's core functionality through
four key tests: internal and external host connectivity, OSPF dynamic
routing behavior, and HSRP redundancy and failover. These tests
confirm that the network operates as designed, with proper routing,
access control, redundancy, and service availability.

### 4.1 Internal Host Connectivity

A Bash script is executed from each **internal end host** to verify:

| Test Type | Purpose                                                |
|-----------|--------------------------------------------------------|
| `ping`    | Confirm Layer 3 reachability between VLANs             |
| `curl`    | Verify HTTP access to internal servers                 |
| `dig`     | Validate DNS resolution using DHCP-assigned DNS server |

This script ensures that:
- Hosts are receiving full IP configuration (IP, gateway, DNS)
  via DHCP from `EDGE`
- VLAN segmentation and routing are functioning correctly
- Internal HTTP services are accessible from all internal VLANs
- The Site-to-Site VPN tunnel is active and supports inter-VLAN
  routing and DHCP services

#### Script Location

[scripts/internal-test.sh](scripts/internal-test.sh)

#### Results

Test results from all hosts are included in:  
[results/internal_connectivity_test_output.txt](results/internal_connectivity_test_output.txt)

### 4.2 External Host Connectivity

A Bash script is executed from the **Web-Client (external host)** to verify:

| Test Type | Purpose                                                   |
|-----------|-----------------------------------------------------------|
| `ping`    | Confirm ICMP reachability to internal servers             |
| `curl`    | Validate HTTP access to publicly exposed internal servers |

This script ensures that:
- Servers behind `ASA-MAIN` are accessible via **static NAT** and **ACLs**
- ICMP is explicitly allowed to internal servers only
- `ASA-MAIN` is enforcing **stateful inspection** and **access control**

#### Script Location

[scripts/external-test.sh](scripts/external-test.sh)

#### Results

Test results are included in:  
[results/external_connectivity_test_output.txt](results/external_connectivity_test_output.txt)

### 4.3 OSPF Validation

This test validates the correct operation and redundancy behavior of the OSPF
routing protocol under both normal operation and device failure scenarios.
It confirms that OSPF neighbors form properly, routes are dynamically learned,
and the network converges appropriately when a path becomes unavailable.

#### Commands Used

```
show ip ospf neighbor
show ip route ospf
```

#### Validation Steps

1. Under normal network conditions, OSPF neighbor relationships and
  routing tables were captured from the three participating routers:
  `EDGE`, `R1`, and `R2`.
2. `R1` was administratively shut down to simulate a failure, and
  OSPF neighbor and route information was rechecked on `EDGE` and `R2`.  
3. After restoring `R1` to normal operation, `R2` was shut down,
  and the same OSPF verification steps were repeated on `EDGE` and `R1`.

This test confirms that:

- OSPF neighbors form correctly under normal conditions
- OSPF routes are dynamically learned and maintained across the network
- The network converges successfully during failure conditions
- Redundant paths are automatically selected and used when available

#### Results

All results are included in the following files:

- [results/ospf_status_before.txt](results/ospf_status_before.txt)
- [results/ospf_status_after_r1_down.txt](results/ospf_status_after_r1_down.txt)
- [results/ospf_status_after_r2_down.txt](results/ospf_status_after_r2_down.txt)

### 4.4 HSRP Validation

This test validates the correct operation of HSRP (Hot Standby Router Protocol)
under both normal operation and router failure scenarios. The goal is to
confirm that HSRP is properly configured for first-hop redundancy, and that
failover occurs seamlessly when the active router becomes unavailable.

#### Commands Used

```
traceroute
show standby brief
```

#### Validation Steps

1. A traceroute was initiated from the end host `NetAdmin-PC` to the inside
  interface of `ASA-MAIN` to confirm that traffic was routed through `R2`,
  the designated active HSRP router under normal conditions.
2. The command `show standby brief` was executed on `R1`, the standby HSRP
  router, to verify its current standby status.
3. To simulate a failure, `R2` was administratively shut down.
4. The traceroute from step 1 was repeated to verify that traffic was now
  routed through `R1`, confirming HSRP failover.
5. The `show standby brief` command was executed again on `R1` to verify that
  it had transitioned from standby to active status.

This test confirms that:
- HSRP is configured and functioning correctly under normal conditions
- Failover occurs automatically and seamlessly when the active router
  becomes unavailable
- End hosts experience no disruption in connectivity during the transition
- The standby router assumes the virtual IP and begins forwarding traffic
  as expected

#### Results

All results are included in the following files:
- [results/hsrp_traceroute_before.txt](results/hsrp_traceroute_before.txt)
- [results/hsrp_status_before.txt](results/hsrp_status_before.txt)
- [results/hsrp_traceroute_after.txt](results/hsrp_traceroute_after.txt)
- [results/hsrp_status_after.txt](results/hsrp_status_after.txt)

---

## Appendices

### A. Device Configuration Files

- [configs/CLOUD.txt](configs/CLOUD.txt)
- [configs/ASA-MAIN.txt](configs/ASA-MAIN.txt)
- [configs/EDGE.txt](configs/EDGE.txt)
- [configs/R1.txt](configs/R1.txt)
- [configs/R2.txt](configs/R2.txt)
- [configs/SW-FLOOR-1.txt](configs/SW-FLOOR-1.txt)
- [configs/SW-FLOOR-2.txt](configs/SW-FLOOR-2.txt)
- [configs/SW-FLOOR-3.txt](configs/SW-FLOOR-3.txt)
- [configs/SW-EDGE.txt](configs/SW-EDGE.txt)
- [configs/SW-WAREHOUSE.txt](configs/SW-WAREHOUSE.txt)
- [configs/ASA-REMOTE.txt](configs/ASA-REMOTE.txt)
- [configs/SW-REMOTE.txt](configs/SW-REMOTE.txt)

### B. References

- [Cisco Networking Academy](https://www.netacad.com)
- [Cisco IOS Master Command List](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/mcl/allreleasemcl/all-book.html)
- [Cisco IOS Command References](https://www.cisco.com/c/en/us/support/ios-nx-os-software/ios-15-5m-t/products-command-reference-list.html)
- [Cisco IOS Configuration Guides](https://www.cisco.com/c/en/us/support/ios-nx-os-software/ios-15-5m-t/products-installation-and-configuration-guides-list.html)
- [Cisco Secure Firewall ASA Configuration Guides](https://www.cisco.com/c/en/us/support/security/adaptive-security-appliance-asa-software/products-installation-and-configuration-guides-list.html)
- [GNS3 Official Documentation](https://docs.gns3.com)
- [Alpine Linux Wiki](https://wiki.alpinelinux.org/wiki/Main_Page)
- [Docker Hub | Alpine Linux End Host](https://hub.docker.com/r/gns3/endhost)
- [Docker Hub | Networkers' Toolbox](https://hub.docker.com/r/adosztal/net_toolbox)

### C. License

This project is licensed under the GNU General Public License v3.0.  
A copy of the license is available in the `LICENSE` file.

---

