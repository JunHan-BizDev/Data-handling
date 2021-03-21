#!/usr/bin/env python
# coding: utf-8
#3번
import re
from bs4 import BeautifulSoup

html3 = """
<ul>
    <li><a href="hoge.html">hoge</li>
    <li><a href="https://example.com/fuga">fuga*</li>
    <li><a href="https://example.com/foo">foo*</li>
    <li><a href="https://example.com/aaa">aaa</li>
</ul>
"""

soup3 = BeautifulSoup(html3, 'html.parser')

li = soup3.find_all(href=re.compile(r"^https://"))

for e in li:
    print(e.attrs['href'])




