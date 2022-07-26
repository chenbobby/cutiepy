# How to Schedule Jobs

Schedule a job for X time later.

``` python
from datetime import datetime, timedelta, timezone

# Schedule a job to be enqueued after 1 minute.
now_utc = datetime.now(timezone.utc) 
X = timedelta(minutes=1)
dt = now_utc + X
registry.schedule_job(fn, args, kwargs, enqueue_after=dt)
```

See the official Python docs on [timedelta](https://docs.python.org/3/library/datetime.html#timedelta-objects).

:::info
Always include a timezone in your datetime objects.
Timezones are required for CutiePy to enqueue your scheduled jobs at the correct time.
:::

Schedule a job for X days later, at time Y.

``` python
from datetime import datetime, timedelta, timezone

# Schedule a job to be enqueued in 2 days, at 9:15am local time.
now_utc = datetime.now(timezone.utc) 
now_local = now_utc.astimezone()
X = timedelta(days=2)
dt = now_local.replace(hours=9, minutes=15) + X
registry.schedule_job(fn, args, kwargs, enqueue_after=dt)
```

Schedule a job for the next X day of the week, at time Y.

