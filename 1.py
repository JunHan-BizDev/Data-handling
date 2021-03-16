#!/usr/bin/env python
# coding: utf-8

#1번
from bs4 import BeautifulSoup
import urllib.request as req
import pandas as pd

url = "http://www.kma.go.kr/weather/forecast/mid-term-rss3.jsp"
response = req.urlopen(url)


soup = BeautifulSoup(response, 'html.parser')
print(response)
print(soup)


time = soup.find_all("tmef")
status = soup.find_all("wf")
tmp_min = soup.find_all("tmn")
tmp_max = soup.find_all("tmx")

pass_i = 0
for i_time, i_status, i_tmp_min,i_tmp_max in zip(time,status,tmp_min,tmp_max): 
    if(pass_i == 0):
        pass_i += 1
        continue
    print("time    : " + i_time.getText() + " " +
          "status  : " + i_status.getText() + " " +
          "min temp: " + i_tmp_min.getText() + " " +
          "max temp: " + i_tmp_max.getText())

