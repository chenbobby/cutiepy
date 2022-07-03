# CutiePy

CutiePy is an **open source job queue for Python**. CutiePy allows you to:

* [**enqueue a job**](#TODO-enqueue-job-docs) to run immediately
* [**create scheduled jobs**](#TODO-scheduledj-jobs-docs) that will run once at a later time
* [**create recurring jobs**](#TODO-recurring-jobs-docs) that will run periodically at a fixed interval, like a [`cron`](https://en.wikipedia.org/wiki/Cron) job.

CutiePy ships with a **real-time monitoring dashboard** to help you track your jobs and workers.

![CutiePy UI Screenshot](#TODO)

## Development Setup

```bash
python -m venv .venv
source ./.venv/bin/activate
python -m pip install --upgrade pip
python -m pip install --requirement requirements.txt
```
