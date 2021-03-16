#!/usr/bin/env python
# coding: utf-8

#2번
from bs4 import BeautifulSoup
import urllib.request as req
import pandas as pd

#url, price path 변수 
finance_url = "https://finance.naver.com/marketindex/"
price_path = "#exchangeList > li.on > a.head.usd > div > span.value"

#
finan_response = req.urlopen(finance_url)
finan_soup = BeautifulSoup(finan_response, 'html.parser')
#parameter 지정
param1 = {
    "class" : "value",
}

    
#첫번째 price 값 추출    
price = finan_soup.select_one(".value")
print(price.get_text())


#모든 price 값 내기 
links = finan_soup.find_all(attrs = param1)

for i in links: 
    text = i.string
    print(text)
