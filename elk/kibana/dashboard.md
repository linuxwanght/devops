## https://www.elastic.co/guide/en/kibana/current/create-a-dashboard-of-panels-with-web-server-data.html


#### 查询规则

Lucene的查询语句解析器支持的语法，Lucene的查询语句解析器是使用JavaCC工具生成的词法解析器，它将查询字串解析为Lucene Query对象。

##### 项（Term）

一条搜索语句被拆分为一些项（term）和操作符（operator）。项有两种类型：单独项和短语。
单独项就是一个单独的单词，例如”test” ， “hello”。
短语是一组被双引号包围的单词，例如”hello dolly”。
多个项可以用布尔操作符连接起来形成复杂的查询语句（AND OR ）。


#####  域（Field）

Lucene支持域。您可以指定在某一个域中搜索，或者就使用默认域。域名及默认域是具体索引器实现决定的。kibana的默认域就是message …. message会包含你所有日志，包括你grok过滤之后的。 
他的搜索语法是：  域名+”:”+搜索的项名。


举个例子，假设某一个Lucene索引包含两个域，title和text，text是默认域。如果您想查找标题为”The Right Way”且含有”don’t go this way”的文章，您可以输入：
title:”The Right Way” AND text:go
或者
title:”Do it right” AND right
因为text是默认域，所以这个域名可以不行。
注意：域名只对紧接于其后的项生效，所以
title:Do it right
只有”Do”属于title域。”it”和”right”仍将在默认域中搜索（这里是text域）。

##### 项修饰符（Term Modifiers）

Lucene支持项修饰符以支持更宽范围的搜索选项。
kibana默认就是lucene搜索的，一些模糊搜索是可以用通配符，Lucene支持单个与多个字符的通配搜索。
使用符号”?”表示单个任意字符的通配。
使用符号”*”表示多个任意字符的通配。
单个任意字符匹配的是所有可能单个字符。例如，搜索”text或者”test”，可以这样：
te?t
多个任意字符匹配的是0个及更多个可能字符。例如，搜索test, tests 或者 tester，可以这样：
test*
您也可以在字符窜中间使用多个任意字符通配符。
te*t
注意：您不能在搜索的项开始使用*或者?符号。



##### 范围查询

有一些需求是range的范围类型的，

```
mod_date:[20020101 TO 20030101]
```



 

##### 模糊查询

Lucene支持基于Levenshtein Distance与Edit Distance算法的模糊搜索。要使用模糊搜索只需要在单独项的最后加上符号”~”。例如搜索拼写类似于”roam”的项这样写：
roam~
这次搜索将找到形如foam和roams的单词。
注意：使用模糊查询将自动得到增量因子（boost factor）为0.2的搜索结果.

##### 邻近搜索(Proximity Searches)

Lucene还支持查找相隔一定距离的单词。邻近搜索是在短语最后加上符号”~”。例如在文档中搜索相隔10个单词的”apache”和”jakarta”，这样写：
“jakarta apache”~10


Boosting a Term
Lucene provides the relevance level of matching documents based on the terms found. To boost a term use the caret, “^”, symbol with a boost factor (a number) at the end of the term you are searching. The higher the boost factor, the more relevant the term will be.
Lucene可以设置在搜索时匹配项的相似度。在项的最后加上符号”^”紧接一个数字（增量值），表示搜索时的相似度。增量值越高，搜索到的项相关度越好。
Boosting allows you to control the relevance of a document by boosting its term. For example, if you are searching for jakarta apache and you want the term “jakarta” to be more relevant boost it using the ^ symbol along with the boost factor next to the term. You would type:
通过增量一个项可以控制搜索文档时的相关度。例如如果您要搜索jakarta apache，同时您想让”jakarta”的相关度更加好，那么在其后加上”^”符号和增量值，也就是您输入：

jakarta^4 apache
This will make documents with the term jakarta appear more relevant. You can also boost Phrase Terms as in the example:
这将使得生成的doucment尽可能与jakarta相关度高。您也可以增量短语，象以下这个例子一样：
“jakarta apache”^4 “jakarta lucene”
By default, the boost factor is 1. Although, the boost factor must be positive, it can be less than 1 (i.e. .2)
默认情况下，增量值是1。增量值也可以小于1（例如0.2），但必须是有效的。

 

##### 布尔操作符

布尔操作符可将项通过逻辑操作连接起来。Lucene支持AND, “+”, OR, NOT 和 “-”这些操作符。（注意：布尔操作符必须全部大写）

##### OR

OR操作符是默认的连接操作符。这意味着如果两个项之间没有布尔操作符，就是使用OR操作符。OR操作符连接两个项，意味着查找含有任意项的文档。这与集合并运算相同。符号||可以代替符号OR。
搜索含有”xiaorui.cc apache” 或者 “xiaorui.cc”的文档，可以使用这样的查询：
“jakarta apache” jakarta

 ```
"xiaorui.cc apache" xiaorui.cc或者"xiaorui.cc apache" OR xiaorui.cc
 ```




##### AND

AND操作符匹配的是两项同时出现的文档。这个与集合交操作相等。符号&&可以代替符号AND。
搜索同时含有”jakarta apache” 与 “jakarta lucene”的文档，使用查询：

```
"jakarta apache" AND "jakarta lucene"
```



##### +

“+”操作符或者称为存在操作符，要求符号”+”后的项必须在文档相应的域中存在。
搜索必须含有”jakarta”，可能含有”lucene”的文档，使用查询：

+jakarta apache

他其实跟AND 是有些像的，直接在lucene query  ==》  A  B的话，意思是 A 或者B的。 这有些蛋疼… …  

 
##### NOT
NOT操作符排除那些含有NOT符号后面项的文档。这和集合的差运算相同。符号！可以代替符号NOT。
搜索含有”jakarta apache”，但是不含有”jakarta lucene”的文档，使用查询：
“jakarta apache” NOT “jakarta lucene”
注意：NOT操作符不能单独与项使用构成查询。例如，以下的查询查不到任何结果：
NOT “jakarta apache”
 

#####  -

“-”操作符或者禁止操作符排除含有”-”后面的相似项的文档。
搜索含有”jakarta apache”，但不是”jakarta lucene”，使用查询：
“jakarta apache” -”jakarta lucene”
 
 

##### 分组（Grouping）

Lucene支持使用圆括号来组合字句形成子查询。这对于想控制查询布尔逻辑的人十分有用。
搜索含有”jakarta”或者”apache”，同时含有”website”的文档，使用查询：
(jakarta OR apache) AND website
这样就消除了歧义，保证website必须存在，jakarta和apache中之一也存在。
 
 

##### 转义特殊字符（Escaping Special Characters）

Lucene支持转义特殊字符，因为特殊字符是查询语法用到的。现在，特殊字符包括
\+ – && || ! ( ) { } [ ] ^ ” ~ * ? : \
转义特殊字符只需在字符前加上符号\,例如搜索(1+1):2，使用查询
\(1\+1\)\:2

 