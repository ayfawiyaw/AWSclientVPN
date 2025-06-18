# 🌐 AWS Client VPN Setup with Terraform

Secure remote access to your AWS VPC with a scalable, managed VPN solution — all defined in code.

## 🚀 Overview

This project sets up an **AWS Client VPN** using **Terraform**, enabling secure, client-based VPN access to your AWS infrastructure. It includes both the infrastructure provisioning scripts and the downloadable client configuration package.

---

## 🛠️ What's Inside

- **`vpc-vpn.tf`**  
  The core Terraform script that defines:
  - The Client VPN endpoint
  - Authorization rules
  - Target networks
  - Route tables
  - Associated VPC/subnets

- **`downloaded-client-config.zip`**  
  Pre-generated OpenVPN configuration files for clients to connect to the VPN. This can be imported directly into OpenVPN or AWS VPN Client.

---

## 📦 Prerequisites

- [Terraform](https://www.terraform.io/) v1.x
- An AWS account with access to IAM, EC2, and VPC services
- AWS CLI configured (`aws configure`)
- OpenVPN or [AWS VPN Client](https://docs.aws.amazon.com/vpn/latest/clientvpn-user/client-vpn-connect.html)

---

## ⚙️ Getting Started

1. **Clone the repository**

   ```bash
   git clone https://github.com/ayfawiyaw/AWSclientVPN.git
   cd aws-client-vpn
