#!/bin/bash

title_color='\033[0;32m'      # green title
no_color='\033[0m'            # No Color

# Function to print a section
print_section() {
  local title="$1"
  local width=30
  local padding=$(( (width - ${#title}) / 2 )) 
  printf "$title_color%${padding}s%s%${padding}s\n$no_color" "" "$title" ""

}

# Function to print info
print_info() {
  local key=$1
  local value=$2
  printf "%-15s %s\n" "$key" "$value"
}


echo
echo

# --- Server Uptime Info ---
print_section "SERVER INFO"
print_info "Boot At:" "$(uptime -s)"
print_info "Uptime:" "$(uptime -p | sed 's/^up //')"
print_info "OS: " "$(lsb_release -d | cut -d ':' -f 2 | sed 's/^\t//')"
print_info "load avg:" "$(uptime | awk -F 'load average: ' '{print $2}')"
print_info "User(logged):" "$(last | head -n 1 | awk '{printf "%s (From ip: %s)", $1, $3}')"
print_info "Login Failed:" "$(lastb | head -n 1 | awk '{printf "%s (From ip: %s)", $1, $3}')" # require root user
echo

# --- CPU Usage Info ---
print_section "CPU INFO"
print_info "CPU Usage:" "$(top -bn1 | grep "%Cpu(s)" -w | awk '{printf "%s%%", $4}')"
echo

# --- Disk Info ---
print_section "DISK INFO"
print_info "Disk:" "$(df -h / | awk 'NR==2 {print $2}')"
print_info "Used:" "$(df -h / | awk 'NR==2 {print $3 " (" $5 ")"}')"
print_info "Free:" "$(df -h / | awk 'NR==2 {print $4 " (" 100-$5 "%" ")"}')"
echo

# --- Memory Info ---
print_section "MEMORY INFO"
print_info "Size:" "$(free -h | awk '/Mem:/ {print $2}')"
print_info "Used:" "$(free -h | awk '/Mem:/ {printf "%s (%.2f%%)", $3, $3/$2*100}')"
print_info "Free:" "$(free -h | awk '/Mem:/ {printf "%s (%.2f%%)", $4, $4/$2*100}')"
print_info "Cached:" "$(free -h | awk '/Mem:/ {printf "%s (%.2f%%)", $6, $6/$2*100}')" 
echo

# --- Top 5 Processes by CPU Usage --- 
print_section "TOP 5 Processes(By CPU)"
ps aux --sort -%cpu | head -n 6 | awk 'NR==1 {printf "%-10s %-8s %-8s %s\n", $1, $2, $3, $11} NR>1 {printf "%-10s %-8s %-8.1f %s\n", $1, $2, $3, $11}'
echo

# --- Top 5 Processes by memory usage ---
print_section "TOP 5 Processes(By Memory)"
ps aux --sort -%mem | head -n 6 | awk 'NR==1 {printf "%-10s %-8s %-8s %s\n", $1, $2, $4, $11} NR>1 {printf "%-10s %-8s %-8.1f %s\n", $1, $2, $4, $11}'
echo
