

```python
# In this notebook, we get the weather data for years 2008 - 2016 to put into the model.
```
# FAQ

This is a quick rundown of using the DarkSky api to pull hourly data for New York. The api offers alot more than what is shown here, so feel free to check it out https://linktodarksky.com. 

## 1. Create Date Range

Create a date range that will encompass all of the data. Then we convert it to unix time for use in the dark sky api.


```python
import requests
import pandas as pd
import datetime
date_range = pd.DataFrame(pd.date_range(start='10/11/2008/', 
                                        end='1/1/2016',
                                        dtype='datetime64[ns]', 
                                        freq='D')).rename(columns ={0:'date'})
date_range['unix']= date_range.date.apply(lambda x : (x-datetime.datetime(1970,1,1,0,0)).total_seconds())
date_range.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>date</th>
      <th>unix</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2008-10-11</td>
      <td>1.223683e+09</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2008-10-12</td>
      <td>1.223770e+09</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2008-10-13</td>
      <td>1.223856e+09</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2008-10-14</td>
      <td>1.223942e+09</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2008-10-15</td>
      <td>1.224029e+09</td>
    </tr>
  </tbody>
</table>
</div>



## 2. Retrive Data

Now set up a generic function to get the data. Because there are limits on how free api calls can be made per day, 3 days will be needed to retrieve all the data.



```python
def get_hourly(date):
    
    api_key = 'myKey'
    lat ='40.773110,'
    long = '-73.916259,'
    time = str(int(date))
    end = '?exclude=currently,flags'

    string = 'https://api.darksky.net/forecast/' +api_key +'/' + lat+long+time+ end
    
    response = requests.get(string).json()
    
    df_hourly = pd.DataFrame.from_dict(response['hourly']['data'], orient='columns', dtype=None, columns=None)
    
    df_hourly['full_dates']= pd.to_datetime(df_hourly['time'],unit='s')

    return df_hourly
```

## Call the API
Over several days, call the function with date ranges until all dates from the dataset are accounted for.

```python
#Not sure what columns will come back so create one for first row.
weather = get_hourly(date_range['unix'][0])

for date in date_range['unix'][1:900]: 
    
    test = get_hourly(date)
    weather = pd.concat([weather,test]).reset_index(drop=True)
    
weather.to_csv('weather1.csv')
```


After combining all the data into one file we are left with....

```python
weather.head()
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Unnamed: 0</th>
      <th>apparentTemperature</th>
      <th>cloudCover</th>
      <th>dewPoint</th>
      <th>full_dates</th>
      <th>humidity</th>
      <th>icon</th>
      <th>precipAccumulation</th>
      <th>precipIntensity</th>
      <th>precipProbability</th>
      <th>precipType</th>
      <th>pressure</th>
      <th>summary</th>
      <th>temperature</th>
      <th>time</th>
      <th>uvIndex</th>
      <th>visibility</th>
      <th>windBearing</th>
      <th>windGust</th>
      <th>windSpeed</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>64.30</td>
      <td>0.31</td>
      <td>56.94</td>
      <td>2008-10-10 04:00:00</td>
      <td>0.77</td>
      <td>partly-cloudy-night</td>
      <td>NaN</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>NaN</td>
      <td>1016.19</td>
      <td>Partly Cloudy</td>
      <td>64.30</td>
      <td>1223611200</td>
      <td>0</td>
      <td>9.07</td>
      <td>240</td>
      <td>3.37</td>
      <td>2.27</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>63.21</td>
      <td>0.22</td>
      <td>56.56</td>
      <td>2008-10-10 05:00:00</td>
      <td>0.79</td>
      <td>clear-night</td>
      <td>NaN</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>NaN</td>
      <td>1016.61</td>
      <td>Clear</td>
      <td>63.21</td>
      <td>1223614800</td>
      <td>0</td>
      <td>8.45</td>
      <td>253</td>
      <td>3.22</td>
      <td>2.33</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2</td>
      <td>62.58</td>
      <td>0.22</td>
      <td>55.34</td>
      <td>2008-10-10 06:00:00</td>
      <td>0.77</td>
      <td>clear-night</td>
      <td>NaN</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>NaN</td>
      <td>1017.01</td>
      <td>Clear</td>
      <td>62.58</td>
      <td>1223618400</td>
      <td>0</td>
      <td>8.97</td>
      <td>271</td>
      <td>3.63</td>
      <td>2.56</td>
    </tr>
    <tr>
      <th>3</th>
      <td>3</td>
      <td>61.99</td>
      <td>0.09</td>
      <td>53.85</td>
      <td>2008-10-10 07:00:00</td>
      <td>0.75</td>
      <td>clear-night</td>
      <td>NaN</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>NaN</td>
      <td>1017.48</td>
      <td>Clear</td>
      <td>61.99</td>
      <td>1223622000</td>
      <td>0</td>
      <td>9.37</td>
      <td>304</td>
      <td>4.04</td>
      <td>2.22</td>
    </tr>
    <tr>
      <th>4</th>
      <td>4</td>
      <td>61.17</td>
      <td>0.15</td>
      <td>52.71</td>
      <td>2008-10-10 08:00:00</td>
      <td>0.74</td>
      <td>clear-night</td>
      <td>NaN</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>NaN</td>
      <td>1018.01</td>
      <td>Clear</td>
      <td>61.17</td>
      <td>1223625600</td>
      <td>0</td>
      <td>9.34</td>
      <td>316</td>
      <td>4.62</td>
      <td>2.53</td>
    </tr>
  </tbody>
</table>
</div>


There are alot of columns but not all of them are needed. Our main focus is on **precipitation, temperature and visibility**.
Precipitation needs to be manipulated a little. All types (snow,rain,sleet) are in the same column and and `precipType` indicates which type of weather the numeric precipitation columns represent. In reality each of these should be separated since we will want to scale each based on units relevant to the precepitation type. For instance, the effect of 1 inch of Rain is different from 1 inch of snow, and the overall distribution of these precipitation types will probably be different. (what constitutes alot of sleet is different than rain)

A well tuned model could use indicators or interactions to pick up on these differences, but a more straightforward approach is  to separate each into their own set of columns that can be scaled or normalized appropriately. The spread could be done with pd.pivot() but in the interest of creating  customized names a for loop will suffice. (This approach would not be recommended for a large dataset.)


```python
#pull out columns that are good to go
truncated = weather[['full_dates','temperature','visibility']]
```

Quickly preview the types of precipitation in the dataset. 

```python
#preivew types
weather.precipType.unique()
```


    array([nan, 'rain', 'sleet', 'snow'], dtype=object)




```python
for p_type in ['rain','sleet','snow']:
    for metric in['precipAccumulation','precipIntensity','precipProbability']:
        
        #for each type of precipitation, create a separate column named for each measurement type
        col_name = p_type+metric.split('precip')[1]
        
        print(col_name)
        
        #the values we want are onlyt where precipType is the designated precipitation
        values = weather['precipType']== p_type
        
        #column is valid only where p_type is our target so multiply by values
        truncated[col_name] = values*weather[metric].fillna(0)
        
#Column to double check that NaN was correctly preserved     
truncated['actual']= weather['precipType']
```

    rainAccumulation
    rainIntensity
    rainProbability
    sleetAccumulation
    sleetIntensity
    sleetProbability
    snowAccumulation
    snowIntensity
    snowProbability


```python
truncated.describe()
```


<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>temperature</th>
      <th>visibility</th>
      <th>rainAccumulation</th>
      <th>rainIntensity</th>
      <th>rainProbability</th>
      <th>sleetAccumulation</th>
      <th>sleetIntensity</th>
      <th>sleetProbability</th>
      <th>snowAccumulation</th>
      <th>snowIntensity</th>
      <th>snowProbability</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>63337.000000</td>
      <td>63337.000000</td>
      <td>63337.0</td>
      <td>63337.000000</td>
      <td>63337.000000</td>
      <td>63337.0</td>
      <td>63337.000000</td>
      <td>63337.000000</td>
      <td>63337.000000</td>
      <td>63337.000000</td>
      <td>63337.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>54.583844</td>
      <td>8.985579</td>
      <td>0.0</td>
      <td>0.004375</td>
      <td>0.076781</td>
      <td>0.0</td>
      <td>0.000011</td>
      <td>0.000262</td>
      <td>0.002885</td>
      <td>0.000277</td>
      <td>0.005205</td>
    </tr>
    <tr>
      <th>std</th>
      <td>17.912102</td>
      <td>2.053567</td>
      <td>0.0</td>
      <td>0.021147</td>
      <td>0.211529</td>
      <td>0.0</td>
      <td>0.000664</td>
      <td>0.012301</td>
      <td>0.027603</td>
      <td>0.002653</td>
      <td>0.043683</td>
    </tr>
    <tr>
      <th>min</th>
      <td>1.520000</td>
      <td>0.090000</td>
      <td>0.0</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.0</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>40.290000</td>
      <td>8.920000</td>
      <td>0.0</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.0</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>55.190000</td>
      <td>10.000000</td>
      <td>0.0</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.0</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>69.350000</td>
      <td>10.000000</td>
      <td>0.0</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.0</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>102.020000</td>
      <td>10.000000</td>
      <td>0.0</td>
      <td>0.666700</td>
      <td>1.000000</td>
      <td>0.0</td>
      <td>0.080000</td>
      <td>0.910000</td>
      <td>0.823000</td>
      <td>0.075900</td>
      <td>1.000000</td>
    </tr>
  </tbody>
</table>
</div>



```python
truncated.head()
```


<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>full_dates</th>
      <th>temperature</th>
      <th>visibility</th>
      <th>rainIntensity</th>
      <th>rainProbability</th>
      <th>sleetAccumulation</th>
      <th>sleetIntensity</th>
      <th>sleetProbability</th>
      <th>snowAccumulation</th>
      <th>snowIntensity</th>
      <th>snowProbability</th>
      <th>actual</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2008-10-10 04:00:00</td>
      <td>64.30</td>
      <td>9.07</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2008-10-10 05:00:00</td>
      <td>63.21</td>
      <td>8.45</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2008-10-10 06:00:00</td>
      <td>62.58</td>
      <td>8.97</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2008-10-10 07:00:00</td>
      <td>61.99</td>
      <td>9.37</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2008-10-10 08:00:00</td>
      <td>61.17</td>
      <td>9.34</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>

No need for the rainAccumulation, or sleet accumulation since the max is 0.0.


```python
truncated.drop(columns = ['rainAccumulation','sleetAccumulation'],axis=1,inplace = True)
```
All done! 

In the next post, we will join this weather data to the main dataset and look at the impact of weather on model performance.
[Link to Next Post](linkhere)