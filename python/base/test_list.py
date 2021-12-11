'''
Author: your name
Date: 2021-10-31 11:36:48
LastEditTime: 2021-10-31 11:41:24
LastEditors: Please set LastEditors
Description: In User Settings Edit
FilePath: /devops/python/base/test_list.py
'''

def reverseWords(input):
    inputWords = input.split(" ")

    inputWords=inputWords[-1::-1]
    print(inputWords)

    output = ' '.join(inputWords)

    print(output)
    return output

if __name__ == "__main__":
    input = "I like python"
    rw = reverseWords(input)
    print(rw)