# Lab 2: Antivirus Daemon

## Overview
This is the submission for the simple antivirus daemon lab. The project has a script that watches a folder and deletes bad files, and another script to restore them if they were deleted by mistake.

### Files included:
- `Makefile`: To run everything easily.
- `README.md`: This file.
- `antivirusd.sh`: The main daemon script.
- `restore.sh`: The interactive restore tool.
- `antivirus-cron.sh`: The script for Bonus 1.

## Requirements
You just need Ubuntu or any standard Linux environment. Make sure you have `make` and `cron` installed.
Command to install them if missing:
`sudo apt update && sudo apt install make cron`

## How to use it
The easiest way is using the Makefile.

1. Open your terminal in the project folder.
2. To run the antivirus daemon: `make run_daemon`
3. To run the restore tool: `make run_restore`

By default, it will create two folders for testing: `monitored_dir` and `quarantined_dir`. 

## Where are the flagged lists?
The bad extensions and keywords are written clearly at the top of the `antivirusd.sh` and `antivirus-cron.sh` files. Look for the variables `EXTENSIONS` and `KEYWORDS`.

## Bonus 1: Cron Job
If you want to use the cron job instead of the while loop:
1. Make the script executable: `chmod +x antivirus-cron.sh`
2. Open crontab: `crontab -e`
3. To run it every minute at second 23, add this line (don't forget to put your real absolute path):
   `* * * * * sleep 23 && /full/path/to/antivirus-cron.sh`

**For the 3rd Friday of the month at 12:31 am:**
Add this exact line:
`31 0 15-21 * * [ "$(date '+\%u')" = "5" ] && /full/path/to/antivirus-cron.sh`

## Bonus 2: Whitelist
I added a whitelist feature so files don't keep getting deleted after you restore them.
- How it works: When you use `restore.sh` to restore a file, the script writes its name in a file called `whitelist.txt`.
- When the daemon scans again, it checks `whitelist.txt` first. If the file name is there, it ignores it.
- This works even if you stop and restart the daemon because the names are saved in the text file on the disk.