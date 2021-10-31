'''
Author: your name
Date: 2021-10-31 06:38:10
LastEditTime: 2021-10-31 06:38:23
LastEditors: Please set LastEditors
Description: In User Settings Edit
FilePath: /devops/python/practise_project/password_generator.py
'''
import random
import string

total = string.ascii_letters + string.digits + string.punctuation

length = 16

password = "".join(random.sample(total, length))

print(password)