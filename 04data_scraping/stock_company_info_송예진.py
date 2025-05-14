#!/usr/bin/env python
# coding: utf-8

# In[3]:


import requests
import pandas as pd
import time
from bs4 import BeautifulSoup as bs


# In[27]:


url="https://kind.krx.co.kr/corpgeneral/corpList.do"
payload={"method":"searchCorpList", "pageIndex":1, "currentPageSize":100,
         "orderMode":3,"orderStat":"D", "searchType":13, "fiscalYearEnd":"all", "location":"all"}


# In[28]:


response=requests.post(url, data=payload)
print(response.status_code)


# In[29]:


soup=bs(response.content,'lxml')
soup


soup.select_one("table")["summary"].split(", ")


total_page = int(soup.select_one(".info.type-00 > em").text.replace(",", "")) // 100 + 1
total_page


# In[77]:


# 컬럼명
columns = soup.select_one("table")["summary"].split(", ")
columns.insert(0, "주식종목")
columns.insert(2, "종목코드")
columns



# In[81]:


company_infos=[]

page = 1
while True:
    url ="https://kind.krx.co.kr/corpgeneral/corpList.do"
    payload = dict(method="searchCorpList", pageIndex=page,
                 currentPageSize=100,
                 orderMode=3, orderStat="D", searchType=13,
                 fiscalYearEnd="all", location="all")
    r = requests.post(url, data=payload)
    soup = bs(r.content, 'lxml')
    # 전체 페이지
    total_page = int(soup.select_one(".info.type-00 > em").text.replace(",", "")) // 100 + 1
    
    for idx, tr in enumerate(soup.select("tbody > tr")):
        print(f'{page}/{total_page}중, {idx}/{len(soup.select("tbody > tr"))} 작업중', end="\r")
        # 주식종목
        stock_type = tr.select_one("td:nth-child(1) > img")['alt']
        # 회사이름
        company_name = tr.select_one("td:nth-child(1) > a")["title"]
        # 종목코드
        stock_code = tr.select_one("td:nth-child(1) > a")["onclick"].split("'")[1]
        # 업종
        business_type = tr.select_one("td:nth-child(2)").text
        # 주요제품
        product = tr.select_one("td:nth-child(3)").text
        # 상장일
        resi_date = tr.select_one("td:nth-child(4)").text
        # 결산월
        settlement = tr.select_one("td:nth-child(5)").text
        # 대표자명
        ceo = tr.select_one("td:nth-child(6)").text
        # 홈페이지(url)
        hompage = tr.select_one("td:nth-child(7) > a")["href"] if tr.select_one("td:nth-child(7) > a") != None else ""
        # 지역
        region = tr.select_one("td:nth-child(8)").text
        company_infos.append((stock_type, company_name, stock_code, business_type,
                            product, resi_date, settlement, ceo, hompage, region))

    if page < total_page:
        page += 1
    else:
        break
    
# 컬럼명
columns = soup.select_one("table")["summary"].split(", ")
columns.insert(0, "주식종목")
columns.insert(2, "종목코드")
print(columns)
df = pd.DataFrame(company_infos, columns=columns)



# In[82]:


from datetime import datetime


# In[84]:


today = datetime.now()
today = f"{today.year}_{today.month:02d}_{today.day:02d}"
df.to_csv(f"./상장기업정보_{today}기준.csv", encoding="utf-8", index=False)


# # DB에 저장

# In[85]:


from sqlalchemy import create_engine, text
import pymysql
pymysql.install_as_MySQLdb()


engine = create_engine("mysql+pymysql://root:1234@127.0.0.1:3306/korean_stock")
conn = engine.connect() 
df.to_sql(name="company_info", con=conn, if_exists='replace', index=False)
conn.close()






