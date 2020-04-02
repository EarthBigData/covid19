#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import sys,os
import datetime as dt
import subprocess as sp
import glob


# In[2]:


# GET THE DAILY DATA FROM JOHNS HOPKINS
jhu_daily_root='https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/'
outdir='/s/data/covid19/daily'
os.makedirs(outdir,exist_ok=True)
sdate=dt.datetime(2020,3,22).date()
edate=dt.datetime.now().date()
for i in pd.date_range(sdate,edate):
    fname=i.date().strftime('%m-%d-%Y')+'.csv'
    rname = jhu_daily_root+fname
    lname = os.path.join(outdir,fname)
    cmd='wget -c -O {} {}\n'.format(lname,rname)
    sp.call(cmd.split())


# In[10]:


# BUILD THE TIME SERIES FILES FOR THE US FROM THE DAILY DATA
daily=[x for x in glob.glob(os.path.join(outdir,'*.csv')) if os.stat(x).st_size>0]
daily.sort()
# for i in daily:
#     print(i)
# First series
df = pd.read_csv(daily[0])
df=df[df.Country_Region=='US']

try:
    dates = df.Last_Update.str.split(' ').apply(lambda x: dt.datetime.strptime(x[0].strip(),'%Y-%m-%d'))
except ValueError:
    dates = df.Last_Update.str.split(' ').apply(lambda x: dt.datetime.strptime(x[0].strip(),'%m/%d/%y'))
df['Last_Update']=dates

# Add on other dates
for i in daily[1:]:
    df_daily=pd.read_csv(i)
    df_daily=df_daily[df_daily.Country_Region=='US']
    #Filter for US
    df_daily.dropna(inplace=True)  
    try:
        dates = df_daily.Last_Update.str.split(' ').apply(lambda x: dt.datetime.strptime(x[0].strip(),'%Y-%m-%d'))
    except ValueError:
        dates = df_daily.Last_Update.str.split(' ').apply(lambda x: dt.datetime.strptime(x[0].strip(),'%m/%d/%y'))
    
    df_daily['Last_Update']=dates

    df = df.append(df_daily)

df2=df.groupby(['Combined_Key','Last_Update']).sum()


# In[17]:


## Loop over the three types and write CSV
for covid in ['Confirmed','Deaths','Recovered']:
    cv19=df2[covid]
    cv19=cv19.unstack()
    df3  = pd.DataFrame(pd.Series(df[df.Combined_Key==cv19.index[0]].iloc[0,:7]).append(cv19.loc[cv19.index[0]]))
    series=[]
    for i in cv19.index:
        series.append(pd.DataFrame(pd.Series(df[df.Combined_Key==i].iloc[0,:7]).append(cv19.loc[i])))
    df4=pd.concat(series,axis=1)
    df5=df4.T
    df5.drop('Last_Update',1,inplace=True)
#     df5=df5.astype({'FIPS':'int32'})
    df5=df5.set_index('FIPS')
    df5.to_csv('/s/data/covid19/ebd_us_{}.csv'.format(covid))


# In[ ]:


# df10=pd.read_csv('/s/data/covid19/ebd_us_Confirmed.csv')


# In[ ]:


# df10[df10.Admin2=='Sonoma']

