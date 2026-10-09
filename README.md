# Lab 2 - Simple Antivirus Daemon

This project is a simple antivirus system written using Bash scripts. It monitors a directory for changes, scans files for suspicious extensions or keywords, and moves malicious files to a quarantine directory.

## Project Files

The project contains the following files and directories:

```text
9474-lab2/
├── antivirusd.sh
├── restore.sh
├── Makefile
├── README.md
├── dir/
└── malicious_dir/
```
- `antivirusd.sh` - monitors and scans the directory for malicious files.
- `restore.sh` - allows the user to review quarantined files and restore, permanently delete, or leave them unchanged.
- `Makefile` - provides simple commands to run the antivirus and restore tools.
- `dir/` - the directory being monitored.
- `malicious_dir/` - the quarantine directory.
- `directory-info.last` - stores the previous directory state.
- `directory-info.new` - stores the current directory state.

## Prerequisites

The project is designed to run on Ubuntu using Bash.

To install Make if it is not already installed:

```bash
sudo apt update
sudo apt install make
```
## Step-by-Step Instructions

### Run the Antivirus

1. Open the terminal.

2. Move to the project folder:

```bash
cd ~/OS/9474-lab2
```
3. Run the antivirus using:
```bash
make
```
The antivirus can also be run directly using:
```bash
./antivirusd.sh dir malicious_dir 5
```

The antivirus will monitor the `dir` folder and check it for suspicious files.

4. To stop the antivirus, press:
`Ctrl + C`

### Run the Restore Tool

1. Make sure the antivirus is stopped.
2. Run the restore tool using:
```bash
make restore
```

3. The program will show the files currently inside `malicious_dir`.
4. Select a file by entering its number.
5. Choose one of the following options:
- `1` - Restore the file back to `dir`
- `2` - Permanently delete the file
- `3` - Leave the file in `malicious_dir`

The restore tool can also be run directly using:
```bash
./restore.sh dir malicious_dir
```

## Flagged Extensions and Keywords
The suspicious file extensions and keywords are defined near the beginning of `antivirusd.sh`.
The flagged extensions are:
```bash
flagged_extensions=(".exe" ".bat" ".vbs" ".scr" ".ps1")
```

The flagged keywords are:
```bash
flagged_keywords=("virus" "trojan" "malware" "worm" "ransomware")
```
A file is considered malicious if its extension matches one of the flagged extensions or if its contents contain one of the flagged keywords.
Keyword matching is case-insensitive.

## Bonus 1 - Cron Job

The antivirus can also run automatically using a cron job instead of the continuous loop in `antivirusd.sh`.

The cron version uses `antivirus-cron.sh`. It performs one scan and then exits.

### Prerequisites

Cron must be installed and running:

```bash
sudo apt update
sudo apt install cron
sudo systemctl enable --now cron
```

Run:

```bash
rm -f malicious_dir/cron-virus.txt
rm -f cron-directory-info.last cron-directory-info.new cron.log
```
## Bonus 2 - Whitelist

When a quarantined file is restored using option 1 in `restore.sh`, its filename is added to `whitelist.txt`.

The whitelist is saved as a file, so it remains available even after the antivirus is stopped and restarted.

Before scanning a file, both `antivirusd.sh` and `antivirus-cron.sh` check `whitelist.txt`. If the filename is found in the whitelist, the file is skipped even if it has a flagged extension or contains a flagged keyword.
