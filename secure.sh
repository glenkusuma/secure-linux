#!/bin/bash
# This is a Bash script used to automate server security configuration.

#-----------------------
#-- Required Packages --
# UFW (Uncomplicated Firewall) - used to manage firewall rules.
# Fail2Ban - intrusion prevention software that protects services from brute-force attacks.

# --- Setup UFW rules ---

# Limits SSH access (port 22) to prevent brute force attacks by allowing only a limited rate of connections.
sudo ufw limit 22/tcp

# Allows HTTP traffic (port 80) to access the web server.
sudo ufw allow 80/tcp

# Allows HTTPS traffic (port 443) for secure web server connections.
sudo ufw allow 443/tcp

# Denies all incoming connections by default unless explicitly allowed.
sudo ufw default deny incoming

# Allows all outgoing connections by default.
sudo ufw default allow outgoing

# Enables the UFW firewall with the previously defined rules.
sudo ufw enable

# --- Harden /etc/sysctl.conf ---
# Disables the loading of kernel modules to enhance security.
sudo sysctl kernel.modules_disabled=1

# Prints all the current sysctl settings.
sudo sysctl -a

# Similar to above but displays both the name and values of all settings.
sudo sysctl -A

# Displays the MIB (Management Information Base) settings.
sudo sysctl mib

# Shows the reverse path filtering configuration, which helps prevent IP spoofing.
sudo sysctl net.ipv4.conf.all.rp_filter

# Shows ARP (Address Resolution Protocol) settings for Ethernet and WLAN interfaces.
sudo sysctl -a --pattern 'net.ipv4.conf.(eth|wlan)0.arp'

# --- PREVENT IP SPOOFS ---
# Configures the /etc/host.conf file to prevent IP spoofing by setting name resolution order and enabling multi-query.
cat <<EOF > /etc/host.conf
order bind,hosts
multi on
EOF

# --- Enable fail2ban ---
# Copies the jail.local configuration file for Fail2Ban into the correct directory.
sudo cp jail.local /etc/fail2ban/

# Enables the Fail2Ban service to start at boot.
sudo systemctl enable fail2ban

# Starts the Fail2Ban service to protect against brute force attacks.
sudo systemctl start fail2ban

# Outputs all currently active listening network ports.
echo "listening ports"
sudo netstat -tunlp
