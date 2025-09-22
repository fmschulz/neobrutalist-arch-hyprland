# Troubleshooting Guide

## Common Issues and Solutions

### Installation Issues

#### Package Installation Fails
```bash
# Update package databases
sudo pacman -Syu

# Clear package cache if needed
sudo pacman -Scc

# For AUR packages, rebuild yay
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

#### Missing Dependencies
```bash
# Install base development tools
sudo pacman -S base-devel git

# Install missing dependencies manually
sudo pacman -S <package-name>
```

### Hyprland Issues

#### Hyprland Won't Start
1. Check if you're using a compatible GPU driver:
   ```bash
   lspci | grep VGA
   # For AMD: install mesa, vulkan-radeon
   # For NVIDIA: install nvidia, nvidia-utils
   ```

2. Check Hyprland logs:
   ```bash
   journalctl --user -u hyprland -f
   ```

3. Try starting from TTY:
   ```bash
   # Switch to TTY (Ctrl+Alt+F2)
   Hyprland
   ```

#### Hyprland Boots to a Console Login
1. Ensure the graphical target is enabled:
   ```bash
   sudo systemctl set-default graphical.target
   ```
2. Install and enable a display manager (e.g. `greetd`, `sddm`, or `gdm`). Example with greetd:
   ```bash
   sudo pacman -S greetd tuigreet
   sudo systemctl enable --now greetd.service
   ```
   Set the default session to Hyprland by editing `/etc/greetd/config.toml`:
   ```toml
   [terminal]
   vt = 1

   [default_session]
   command = "Hyprland"
   user = "<your-username>"
   ```
3. Prefer starting Hyprland from a display manager rather than `~/.bash_profile` so user services (Waybar, nm-applet, blueman-applet) can launch automatically.
4. If you already ran the setup script, greetd + regreet should be installed and enabled; verify with `sudo systemctl status greetd` and ensure `/etc/greetd/regreet.css` exists.

#### Black Screen on Login
1. Check if all required packages are installed:
   ```bash
   pacman -Q hyprland waybar kitty wofi
   ```

2. Reset Hyprland config:
   ```bash
   mv ~/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf.backup
   cp /path/to/arch-hyprland-setup/configs/hypr/hyprland.conf ~/.config/hypr/
   ```

#### Window Rules Not Working
1. Check window class names:
   ```bash
   hyprctl clients
   ```

2. Update window rules in `~/.config/hypr/hyprland.conf`

### Audio Issues

#### No Audio Output
1. Check PipeWire status:
   ```bash
   systemctl --user status pipewire pipewire-pulse
   ```

2. Restart audio services:
   ```bash
   systemctl --user restart pipewire pipewire-pulse wireplumber
   ```

3. Check audio devices:
   ```bash
   wpctl status
   pactl list sinks
   ```

#### Audio Crackling
1. Increase buffer size in PipeWire config
2. Check for conflicting audio systems:
   ```bash
   pulseaudio --check -v  # Should show "not running"
   ```

### Display Issues

#### Wrong Resolution/Scaling
1. Check available monitors:
   ```bash
   hyprctl monitors
   ```

2. Update monitor config in `~/.config/hypr/hyprland.conf`:
   ```
   monitor = eDP-1,1920x1080@60,0x0,1.0
   ```

#### Multiple Monitor Issues
1. Use monitor connection script:
   ```bash
   ~/.config/scripts/monitor-connect.sh
   ```

2. Check display configuration:
   ```bash
   wlr-randr
   ```

### Theme Issues

#### Kitty Themes Not Working
1. Check if remote control is enabled:
   ```bash
   grep "allow_remote_control" ~/.config/kitty/kitty.conf
   ```

2. Test theme switching manually:
   ```bash
   kitty @ set-colors ~/.config/kitty/themes/Neo-Brutalist-Blue.conf
   ```

#### Waybar Not Showing
1. Check Waybar status:
   ```bash
   pgrep waybar
   ```

2. Restart Waybar:
   ```bash
   pkill waybar && waybar &
   ```

3. Check Waybar logs:
   ```bash
   waybar -l debug
   ```

### Network Issues

#### WiFi Not Working
1. Check NetworkManager status:
   ```bash
   sudo systemctl status NetworkManager
   ```

2. Enable NetworkManager:
   ```bash
   sudo systemctl enable --now NetworkManager
   ```

3. Use nmcli for connection:
   ```bash
   nmcli device wifi list
   nmcli device wifi connect "SSID" password "password"
   ```

#### Bluetooth Issues
1. Check Bluetooth service:
   ```bash
   sudo systemctl status bluetooth
   ```

2. Enable Bluetooth:
   ```bash
   sudo systemctl enable --now bluetooth
   ```

3. Use bluetoothctl:
   ```bash
   bluetoothctl
   power on
   scan on
   ```

### Performance Issues

#### High CPU Usage
1. Check running processes:
   ```bash
   htop
   ```

2. Disable animations temporarily:
   ```bash
   # Add to hyprland.conf
   animations {
       enabled = false
   }
   ```

#### Memory Issues
1. Check memory usage:
   ```bash
   free -h
   ```

2. Enable zram swap:
   ```bash
   sudo systemctl enable --now systemd-zram-setup@zram0.service
   ```

### Application Issues

#### VS Code Theme Switching Not Working
1. Check if jq is installed:
   ```bash
   pacman -Q jq
   ```

2. Check VS Code settings file:
   ```bash
   ls -la ~/.config/Code/User/settings.json
   ```

#### File Manager Issues
1. For Dolphin issues, install KDE de
