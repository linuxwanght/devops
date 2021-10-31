'''
Author: your name
Date: 2021-10-31 11:12:29
LastEditTime: 2021-10-31 11:12:29
LastEditors: Please set LastEditors
Description: In User Settings Edit
FilePath: /devops/python/practise_project/test.py
'''

import sys
print('================Python import mode==========================')
print ('命令行参数为:')
for i in sys.argv:
    print (i)
print ('\n python 路径为',sys.path)