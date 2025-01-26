use notify_rust::Notification;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::io::{self, Write};
use std::process::{Command, Stdio};

#[derive(Debug, Clone, Serialize, Deserialize)]
struct DeviceInfo {
  label: Option<String>,
  isLuks: Option<bool>,
  mountPath: Option<String>,
  devPath: String,
}

fn main() {
  match run_udiskie_info() {
    Ok(block_devices) => {
      let options = parse_udiskie_info(&block_devices);
      if options.is_empty() {
        notify_if_err("Nothing to unmount / mount".to_string());
        std::process::exit(0);
      }

      match get_selection(pretty_print(&options)) {
        Ok(Some(selected)) => {
          let parsed_selection = parse_selection(&selected, &options);
          for device in parsed_selection {
            process_device(&device);
          }
        }
        Ok(None) => {} // User cancelled input, do nothing
        Err(err) => notify_if_err(err),
      }
    }
    Err(err) => notify_if_err(err),
  }
}

fn run_udiskie_info() -> Result<Vec<DeviceInfo>, String> {
  let output = Command::new("udiskie-info")
    .args(&["-C", "-a", "-o", r#""label":"{ui_label}", "isLuks":"{is_luks}", "mountPath": "{mount_path}""#])
    .output()
    .map_err(|e| e.to_string())?;

  if !output.status.success() {
    return Err(format!(
      "Error running `udiskie-info`: {}",
      String::from_utf8_lossy(&output.stderr)
    ));
  }

  let stdout = String::from_utf8_lossy(&output.stdout);
  parse_udiskie_json(&stdout)
}

fn parse_udiskie_json(json_lines: &str) -> Result<Vec<DeviceInfo>, String> {
  json_lines
    .lines()
    .filter(|line| !line.is_empty())
    .map(|line| {
      let wrapped_line = format!("{{{}}}", line);
      serde_json::from_str(&wrapped_line).map_err(|e| format!("JSON parsing error: {}", e))
    })
    .collect()
}

fn parse_udiskie_info(devices: &[DeviceInfo]) -> HashMap<String, DeviceInfo> {
  let mut options: HashMap<String, DeviceInfo> = HashMap::new();
  for device in devices {
    if device.devPath.starts_with("/dev/loop") {
      // Skip snap packages
      continue;
    }

    let key = device.devPath.clone();
    if let Some(existing) = options.get(&key) {
      if existing.mountPath.is_some() && device.mountPath.is_none() {
        continue;
      }
      if existing.isLuks.unwrap_or(false) && !device.isLuks.unwrap_or(false) {
        continue;
      }
    }

    options.insert(key, device.clone());
  }
  options
}

fn pretty_print(parsed_info: &HashMap<String, DeviceInfo>) -> String {
  let mut output = String::new();
  for (dev_path, device) in parsed_info {
    let dev_path_padded = format!("{: <9}", dev_path);
    let label_or_mount_path = device
      .mountPath
      .clone()
      .or_else(|| device.label.clone())
      .unwrap_or_else(|| "<unknown>".to_string());
    output.push_str(&format!("{}:  {}\n", dev_path_padded, label_or_mount_path));
  }
  output
}

fn get_selection(options: String) -> Result<Option<String>, String> {
  let launcher = std::env::var("UDISKIE_DMENU_LAUNCHER").unwrap_or_else(|_| "dmenu".to_string());

  let mut child = Command::new(launcher)
    .stdin(Stdio::piped())
    .stdout(Stdio::piped())
    .spawn()
    .map_err(|e| e.to_string())?;

  if let Some(stdin) = child.stdin.as_mut() {
    stdin
      .write_all(options.as_bytes())
      .map_err(|e| e.to_string())?;
  }

  let output = child
    .wait_with_output()
    .map_err(|e| e.to_string())?;

  match output.status.code() {
    Some(0) | Some(10) => {
      let selection = String::from_utf8_lossy(&output.stdout).to_string();
      Ok(Some(selection))
    }
    Some(_) | None => Ok(None),
  }
}

fn parse_selection(selection: &str, options: &HashMap<String, DeviceInfo>) -> Vec<DeviceInfo> {
  let mut devices = Vec::new();

  for line in selection.lines() {
    if let Some((dev_path, _label_or_mount)) = line.split_once(":") {
      let trimmed_path = dev_path.trim();
      if let Some(device) = options.get(trimmed_path) {
        devices.push(device.clone());
      }
    }
  }

  devices
}

fn notify_if_err(err: String) {
  Notification::new()
    .summary("Error")
    .body(&err)
    .show()
    .ok();
  eprintln!("{}", err);
}

fn process_device(device: &DeviceInfo) {
  let udiskie_opt = if device.isLuks.unwrap_or(false) {
    "--force"
  } else {
    ""
  };

  if let Some(mount_path) = &device.mountPath {
    run_command(
      &format!("udiskie-umount {} \"{}\"", udiskie_opt, mount_path),
      Some("Failed to unmount device"),
    );
  } else if let Some(label) = &device.label {
    run_command(
      &format!("udiskie-mount {} \"{}\"", udiskie_opt, device.devPath),
      Some(&format!("Failed to mount device: {}", label)),
    );
  } else {
    notify_if_err("Unknown device - aborting".to_string());
  }
}

fn run_command(command: &str, error_msg: Option<&str>) {
  let status = Command::new("sh")
    .arg("-c")
    .arg(command)
    .status()
    .unwrap_or_else(|e| panic!("Failed to execute command: {}", e));

  if !status.success() {
    if let Some(msg) = error_msg {
      notify_if_err(msg.to_string());
    }
  }
}
