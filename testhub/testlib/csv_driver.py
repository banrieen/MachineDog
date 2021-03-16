"""
# ScriptType：support tools 
# UpdateDate: 2021.03-10
# Matainer: thomas
# Env: Win10 64bit, python3.8
 """
import csv
import re

def csv_reader_as_json(csv_path="",length=100):
    output = []
    num = 0
    with open(csv_path, newline='',encoding='utf-8') as csvfile:
        spamreader = csv.reader(csvfile, delimiter=' ', quotechar='|')
        for row in spamreader:
            num += 1
            if num <= length:
                account = re.split('([\t])', row[0] )  
                output.append({"account":account[0],"passwd":account[2],"md5pwd":account[4],})
            elif not num:
                output.append({"account":account[0],"passwd":account[2],"md5pwd":account[4],})
            else:
                return output
    return  output

def csv_writer(csv_path="",datas="json"):
    with open(csv_path, 'w', newline='') as csvfile: 
        spamwriter  = csv.writer(csvfile, 
                                newline='',
                                delimiter=' ',
                                quotechar='|', 
                                quoting=csv.QUOTE_MINIMAL) 
        for Spam in datas.items():
            spamwriter.writerow(Spam)
    return True


if __name__ == "__main__":
    csv_path = r"users.csv"
    csv_reader_as_json(csv_path,10)