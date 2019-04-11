#!/usr/bin/env python3
import os
from datetime import datetime, time, timedelta
# import subprocess
from sanic import Sanic
from sanic_scheduler import SanicScheduler, task
# from sanic.response import json
import sanic.response as res
from sanic.log import logger
from subprocess import PIPE, run

app = Sanic()
scheduler = SanicScheduler(app)

def dict2obj(in_dict):
    class Struct(object):
        def __init__(self, in_dict):
            for key, value in in_dict.items():
                if isinstance(value, (list, tuple)):
                    setattr(
                        self, key,
                        [Struct(sub_dict) if isinstance(sub_dict, dict)
                         else sub_dict for sub_dict in value])
                else:
                    setattr(
                        self, key,
                        Struct(value) if isinstance(value, dict)
                        else value)
    return [Struct(sub_dict) for sub_dict in in_dict] \
        if isinstance(in_dict, list) else Struct(in_dict)


@task(timedelta(hours=10))
def routine(app):
   pass

@app.route("/")
async def index(req):
    return res.json({"hello": "world"})


@app.post("/status-sshd")
async def s_sshd(req):
    command = ['fail2ban-client', 'status', 'sshd']
    result = run(command, stdout=PIPE, stderr=PIPE, universal_newlines=True)
    # print(result.returncode, result.stdout, result.stderr)
    return res.json(result)

@app.post("/nb-banip")
async def nb_banip(req):
    data = dict2obj(req.json)
    if not ( hasattr(data, 'token') and hasattr(data, 'ip') ):
        return res.text('invalid')
    if os.environ.get('ACCESS_TOKEN') == data.token:
        command = ['fail2ban-client', 'set', 'nb', 'banip', data.ip]
        result = run(command, stdout=PIPE, stderr=PIPE, universal_newlines=True)
        return res.json(result)
    return res.text('invalid')

@app.post('/login-failed')
async def login_failed(req):
    # logger.info(f"{req.json}")    
    data = dict2obj(req.json)
    if not ( hasattr(data, 'token') and hasattr(data, 'ip') ):
        return res.text('invalid')
    if os.environ.get('ACCESS_TOKEN') == data.token:
        logger.info(f"failed_ip: {data.ip}")
    return res.text('POST request - {}'.format(req.json))


if __name__ == "__main__":
    app.run(
        host="0.0.0.0", 
        port=7001, 
        debug=False, 
        access_log=False
    )