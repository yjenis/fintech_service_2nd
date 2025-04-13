#!/usr/bin/env python
# coding: utf-8

# In[2]:


import requests
import time
import pandas as pd
from bs4 import BeautifulSoup as bs


# In[3]:


url ="https://kind.krx.co.kr/corpgeneral/corpList.do"


# In[4]:


payload = dict(method="searchCorpList", pageIndex=1, currentPageSize=100, orderMode=3, orderStat="D", searchType=13, fiscalYearEnd="all", location="all")


# In[5]:


r = requests.post(url, data=payload) #사이트가 post 방식이어서
print(r.status_code)
soup = bs(r.content, 'lxml')
soup


# # 찾을 자료를 1개씩 찾아보기

# In[6]:


soup.select("tbody > tr")


# In[25]:


soup.select("tbody > tr")[0].select_one("td:nth-child(1)")


# In[27]:


# 주식종목
soup.select("tbody > tr")[0].select_one("td:nth-child(1) > img")['alt']


# In[29]:


# 회사이름
soup.select("tbody > tr")[0].select_one("td:nth-child(1) > a")["title"]


# In[38]:


soup.select("tbody > tr")[0].select_one("td:nth-child(1) > a")["onclick"]


# In[7]:


# 종목코드
soup.select("tbody > tr")[0].select_one("td:nth-child(1) > a")["onclick"].split("'")[1]


# In[8]:


# 업종
soup.select("tbody > tr")[0].select_one("td:nth-child(2)").text


# In[39]:


# 주요제품
soup.select("tbody > tr")[0].select_one("td:nth-child(3)").text


# In[40]:


# 상장일
soup.select("tbody > tr")[0].select_one("td:nth-child(4)").text


# In[42]:


# 결산월
soup.select("tbody > tr")[0].select_one("td:nth-child(5)").text


# In[43]:


# 대표자명
soup.select("tbody > tr")[0].select_one("td:nth-child(6)").text


# In[47]:


# 홈페이지(url)
soup.select("tbody > tr")[0].select_one("td:nth-child(7) > a")["href"]


# In[49]:


# 지역
soup.select("tbody > tr")[0].select_one("td:nth-child(8)").text


# In[10]:


# 전체 페이지
total_page = int(soup.select_one(".info.type-00 > em").text.replace(",", "")) // 100 + 1


# In[11]:


# 컬럼명
columns = soup.select_one("table")["summary"].split(", ")
columns.insert(0, "주식종목")
columns.insert(2, "종목코드")
columns


# In[14]:


for idx, tr in enumerate(soup.select("tbody > tr")):
    print(f'{idx}/{len(soup.select("tbody > tr"))} 작업중')
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


# In[ ]:





# In[ ]:





# # 코드 합쳐서 1페이지 정보 모두 추출하기

# In[15]:


import requests
import time
import pandas as pd
from bs4 import BeautifulSoup as bs


# In[16]:


url ="https://kind.krx.co.kr/corpgeneral/corpList.do"
payload = dict(method="searchCorpList", pageIndex=1, currentPageSize=100, orderMode=3, orderStat="D", searchType=13, fiscalYearEnd="all", location="all")
r = requests.post(url, data=payload)
print(r.status_code)
soup = bs(r.content, 'lxml')
company_infos = []
for idx, tr in enumerate(soup.select("tbody > tr")):
    print(f'{idx}/{len(soup.select("tbody > tr"))} 작업중')
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
company_infos    


# In[77]:





# # 전체 페이지 데이터 수집하기

# In[17]:


import requests
import time
import pandas as pd
from bs4 import BeautifulSoup as bs


# In[18]:


company_infos = []
page = 1
while True:
    url ="https://kind.krx.co.kr/corpgeneral/corpList.do"
    payload = dict(method="searchCorpList", pageIndex=page,
                 currentPageSize=100,
                 orderMode=3, orderStat="D", searchType=13,
                 fiscalYearEnd="all", location="all")
    r = requests.post(url, data=payload)
#     print(r.status_code)
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
df  


# # 데이터를 수집한 날짜를 포함해서 파일명을 만들고 저장하기

# In[19]:


from datetime import datetime


# In[20]:


today = datetime.now()
today = f"{today.year}_{today.month:02d}_{today.day:02d}"


# In[22]:


df.to_csv(f"./scraping_results/상장기업정보_{today}기준.csv", encoding="utf-8", index=False)


# In[ ]:





# # 수집한 자료를 데이터베이스에 저장하기

# In[25]:


from sqlalchemy import create_engine, text
import pymysql
pymysql.install_as_MySQLdb()


# In[ ]:


# !pip install sqlalchemy
# !pip install PyMySQL


# * sqlalchemy의 create_engine을 이용해서 mysql 서버에 접속
# engine = create_engine("mysql+pymysql://userid:password@ip주소:port/데이터베이스 이름)

# In[27]:


# engine = create_engine("mysql+pymysql://userid:password@ip주소:port/데이터베이스 이름)
# localhost = 127.0.0.1
engine = create_engine("mysql+pymysql://root:1234@localhost:3306/stock_info")
# engine.connect create_engine에 있는 정보로 DB접속
conn = engine.connect() 


# In[28]:


# 데이터프레임을 DB에 저장하기
# 데이터프레임명.to_sql("테이블명")
df.to_sql(f"stock_company_info_{today}", con=conn, if_exists='replace', index=False)
conn.close()


# In[ ]:





# # 판다스의 read_html를 이용해서 table 자료 한번에 가져오기

# In[29]:


soup.select_one("table")


# In[30]:


from io import StringIO


# In[33]:


# pd.read_html(r.text)[0]

html = StringIO(r.text)  # 문자열을 파일처럼 감싸줌
pd.read_html(html)[0]


# In[ ]:





# In[ ]:





# In[ ]:




