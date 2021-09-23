#!/usr/bin/python3
# -*- coding: UTF-8 -*-
""" pause current CODE-DEVELOPMENT jobs
# INFO:    暂停代码开发环境中的任务
# VERSION: 1.0.0
# EDITOR:  thomas
# UPDATE:   2021-09-22
"""
import http.client as client
import json
import hashlib
import time
import sys, getopt

TEST_DATAS = {
  "host": "aiarts.apulis.cn",
  "https": "http",
  "web_admin": {"userName":"admin","password":"4owfQN"},
  "token": "",
  "header": {"Content-Type":"application/json;charset=UTF-8", "Accept-Language":"en-US,en;q=0.9,zh-TW;q=0.8,zh;q=0.7", "Accept":"application/json",  "User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36"},
  "cookie":  "",
  "homepage": "/",
  "login": "/custom-user-dashboard-backend/auth/login",
  "logout": "/custom-user-dashboard-backend/auth/logout",
  "get_codeEnv_summary": "/ai_arts/api/common/job/summary?jobType={job_type}&vcName={vc_name}",
  "get_codeEnv_list": "/api/v2/clusters/DLWS/teams/{vc_name}/jobs?user=all&limit=9999",
  "pause_job": "/api/clusters/DLWS/jobs/{job_id}/status"
}

def security_passwd(passwd="DEFAULT"):
    Md5Passwd = hashlib.md5()
    Md5Passwd.update(passwd.encode("utf-8"))
    SecurityPasswd = (Md5Passwd.hexdigest()).lower()
    return SecurityPasswd

def on_start(host="aiarts.apulis.cn", account={"userName":"admin","password":"4owfQN"}):
    platform_host = host if host else client.HTTPConnection(TEST_DATAS["host"])
    admin_account = account if account else TEST_DATAS["web_admin"]["password"]     
    admin_account["password"] = security_passwd(admin_account["password"])
    data = json.dumps(admin_account)
    conn = client.HTTPConnection(platform_host)
    conn.request("POST", TEST_DATAS["login"], data, headers=TEST_DATAS["header"])
    response = json.load(conn.getresponse())   
    try:
        if response["success"]:
            TEST_DATAS["token"] = response["token"]
            TEST_DATAS["currentRole_id"] = response["currentRole"][0]["id"]
            TEST_DATAS["header"]["Authorization"] = "Bearer " + TEST_DATAS["token"]
            TEST_DATAS["header"]["cookie"] = "language=zh-CN; token={}".format(TEST_DATAS["token"])
    except KeyError: 
        response.raise_for_status()
    return conn

def on_stop(conn):
    conn.request("GET", url=TEST_DATAS["logout"])
    conn.close()


def get_codeDev_jobs(conn, vc_name="platform"):
    params = json.dumps({"limit":999,"user":"all",})
    headers = TEST_DATAS["header"]
    url = TEST_DATAS["get_codeEnv_list"].format(vc_name=vc_name)
    conn.request("GET", url, params, headers ) 
    response = json.load(conn.getresponse())
    return [iEnv["jobId"] for iEnv in response if (iEnv["jobType"] == u"codeEnv") and (iEnv["jobStatus"] != u"paused") and (iEnv["jobStatus"] != u"killed")]

def pause_job(conn, job_id):
    params = json.dumps({"status": "pausing"})
    headers = TEST_DATAS["header"]
    url = TEST_DATAS["pause_job"].format(job_id=job_id)
    conn.request("PUT", url, params, headers ) 
    response = json.load(conn.getresponse())
    print("=================================>>> Pause {} {} on time: {}".format(job_id, response["result"], time.asctime( time.localtime(time.time()) )))

def parse_opt(argv):
    try:
        opts, args = getopt.getopt(argv,"?h:u:p:",["host=","username=","passwd="])
    except getopt.GetoptError:
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-?':
            print(
                """
                暂停代码开发环境中的任务
                -h :  设置平台访问地址（域名或IP）
                -u :  设置平台管理员账号
                -p :  设置平台管理员账号
                -? :  显示帮助
            Example：
            python3 ./pause_codeEnv_job.py -h aiarts.apulis.cn -u admin -p 4owfQN
                """
            )
            sys.exit(2)
        elif opt in ("-h", "--host"):
            host = arg
        elif opt in ("-u", "--username"):
            username = arg
        elif opt in ("-p", "--passwd"):
            passwd = arg
        else:
            continue
    return host, {"userName":username,"password":passwd}

def main(argv):  
    host, account = parse_opt(argv)
    conn = on_start(host, account)
    for i in range(5):
        job_list = get_codeDev_jobs(conn)
        if len(job_list):
            for iJob in job_list:
                pause_job(conn, iJob)
            on_stop(conn)
            break
        else:
            time.sleep(3)
            continue

if __name__ == "__main__":
    # 在主机系统设置定时任务
    # chmod +w /etc/crontab
    ## 测试使用每5min备份一次
    ## echo  "*/5 * * * * root python3  /root/ops_env/pause_codeEnv_job.py  -h aiarts.apulis.cn -u admin -p 4owfQN>> /var/log/pause-codeEnv.log" >> /etc/crontab
    # 每天晚上12点执行
    # echo  "59 23 * * * root python3  /root/ops_env/pause_codeEnv_job.py  -h aiarts.apulis.cn -u admin -p 4owfQN>> /var/log/pause-codeEnv.log" >> /etc/crontab
    # chmod -w /etc/crontab
    # service cron restart
    ## python3 ./pause_codeEnv_job.py -h aiarts.apulis.cn -u admin -p 4owfQN
    main(sys.argv[1:])