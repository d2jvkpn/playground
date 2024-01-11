import schedule
import time
import datetime
#datetime.datetime.now().strftime("%H:%M")

def job():
    print("Scheduling is Working...")
    createfile()

def createfile():
    company = "HELLO USER"
    with open('company.txt', 'w+') as f:
            f.write(str(company))
            print("File Created on:",time.ctime(time.time()))
            f.close()
    return True
# schedule.every(10).minutes.do(job)
# schedule.every().hour.do(job)

#schedule.every().day.at("11.40").do(job)
schedule.every(1).minutes.do(job)

while 1:
    schedule.run_pending()
    time.sleep(1)
