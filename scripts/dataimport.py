# 1.导入pandas模块
import pandas as pd
import sqlite3

# 2.把Excel文件中的数据读入pandas
df = pd.read_excel('test.xlsx', sheet_name='遥信')
print(df)
print(type(df).attrs)
# 3.读取excel的某一个sheet
# df = pd.read_excel('test.xlsx', sheet_name='Sheet1')
# print(df)
# 4.获取列标题
# print(df.columns)
# 5.获取列行标题
# print(df.index)
# 6.制定打印某一列
# print(df["工资水平"])
# 7.描述数据
# print(df.describe())


con = sqlite3.connect("..\.dart_tool\sqflite_common_ffi\databases\logdiff.db")
for index, row in df.iterrows():
    if index < 1:
        # print(row['6号线浦电路遥信点表'], row['Unnamed:1'] , row['Unnamed:2'])
        for i, col in enumerate(row):
            print(col, i, index, '\r')
        print('-------------------\r\n')
    if index > 0:
        con.execute("insert into logdiff (time, value) values (?,?)", (row['time'], row['value']))
        pass
