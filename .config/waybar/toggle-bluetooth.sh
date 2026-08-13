#!/usr/bin/env nu

if not (bluetoothctl show | str contains "Powered: yes") {
  bluetoothctl power on
} else {
  bluetoothctl power off
}
