# Silence the root logger

The geckodriver-autoinstaller package logs using the root logger. The default logger
behaviour is to add a default handler if none has been defined.

This can lead to duplicate log messages. One from the logger defined for the code I am
writing and one from the library code:

```
2022-02-10 09:19:24,362 [INFO] adpClockin: Attempt 1 of 10 to login
INFO:adpClockin:Attempt 1 of 10 to login
2022-02-10 09:19:25,412 [INFO] adpClockin: Attempt 1 of 10 to find clock in with notes widget
INFO:adpClockin:Attempt 1 of 10 to find clock in with notes widget
2022-02-10 09:19:30,544 [INFO] adpClockin: need to change password?
INFO:adpClockin:need to change password?
```

So to silence the root logger I tried:

```
logging.getLogger().setLevel(logging.ERROR)  # did not work
```

But turning off propogation of log messages did work:

```
    logging.getLogger("adpClockin").propagate = False  # this worked
```

Full initialization of the logging looks like:

```
def init_logging():
    # try to silence most of the root logger which geckodriver uses:
    # logging.getLogger().setLevel(logging.ERROR)  # did not work

    # try to keep our logs from propagating to the root locker
    logging.getLogger("adpClockin").propagate = False  # this worked

    log_level = logging.INFO
    formatter = logging.Formatter("%(asctime)s [%(levelname)s] %(name)s: %(message)s")

    handler = logging.StreamHandler()
    handler.setLevel(log_level)
    handler.setFormatter(formatter)

    logger = logging.getLogger("adpClockin")
    logger.setLevel(log_level)
    logger.addHandler(handler)
```
