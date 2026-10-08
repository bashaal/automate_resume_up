# naukri-cv-updater

Logs in to Naukri Gulf and re-uploads a CV, once a day, using Selenium
(`undetected_chromedriver`) on Windows + WSL.

## Files

| File | Purpose |
|---|---|
| `naukri_upload.py` | Selenium script: logs in and uploads the CV |
| `run_naukri.sh` | Wrapper: loads credentials, sets the display, runs the script, logs to `~/naukri.log` |
| `setup_task.ps1` | Creates the daily 06:30 Windows Task Scheduler task |

## Setup (WSL)

```bash
python3 -m venv ~/venv
source ~/venv/bin/activate
pip install undetected-chromedriver selenium

# Credentials (never commit this file)
cat > ~/.naukri_env <<'EOF'
export NAUKRI_EMAIL="your@email.com"
export NAUKRI_PASS="your-password"
EOF
chmod 600 ~/.naukri_env

chmod +x run_naukri.sh
```

Put your resume at `~/Hamedou_bathousha.pdf` (or change `RESUME_PATH` in
`naukri_upload.py`). Do not commit it.

## Test

```bash
./run_naukri.sh && tail -n 12 ~/naukri.log
```

A good run ends with `Upload confirmed (success toast seen).` and `exit code: 0`.

## Schedule (Windows)

Edit the three values at the top of `setup_task.ps1`, then run it in an
Administrator PowerShell. Check the result with:

```powershell
Get-ScheduledTaskInfo -TaskName "NaukriCV"
```

## Notes

- The page has two file inputs. The CV input is `id="resumeSection"`
  (accepts `.doc,.rtf,.docx,.pdf`); the other is a photo upload.
- Success is confirmed only by the "uploaded successfully" toast.
- The laptop must be on (or asleep with wake timers allowed) and signed in at
  06:30. A missed run is caught up when the laptop is next available.
- Run once a day. More frequent logins may get the account flagged.
