'''
Author: your name
Date: 2021-10-31 14:17:43
LastEditTime: 2021-12-11 21:52:12
LastEditors: Please set LastEditors
Description: In User Settings Edit
FilePath: /devops/python/base/data_structure.py
'''


#list
a = [2,3,4,5,6]
print(a.count(2),a.count(3))
a.insert(7,8)
print(a)
a.append(9)
print(a)
print(a.index(2))
a.remove(2)
print(a)

a.reverse()
print(a)

a.sort()
print(a)

a.pop()
print(a)