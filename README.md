# MJPANCAKE Origin Pack

## 这是什么

这是一个[松饼麻雀](https://mjpancake.github.io/)的非官方脚本仓库，存放我已经制作而未见于官方发行版本的人物脚本。松饼麻雀是一个致力于比官方游戏更好地呈现 Saki 世界观的麻将游戏（自称麻将模拟器但曾经支持线上游戏）。

新上传的脚本通常只经过我（打得爽就完事了）的简单测试。如果您对角色能力表现、代码逻辑等有何高见，请通过邮件或企鹅告诉我。

## 它报错了

这是由于角色子模块一处已经被修复的 Bug 没有被更新到游戏本体中。并非所有的角色都会涉及到这个 Bug，您可以选择暂时不使用会报错的角色，等待更新。或者，您可以参考官方指导装配 libsaki 库，自行编译到可用的版本。

## 更新说明

### Feb 19, 2019

[高鴨穏乃](#高鴨穏乃)：修改了「深山之主」的算法。

### Feb 19, 2019

[天江衣](#天江衣)：重写了鸣牌控制代码。

### Feb 16, 2019

[天江衣](#天江衣)：暂时移除了一部分有关鸣牌控制的代码。  
新增 [Aislinn Wishart](#aislinn-wishart)。  

### Feb 15, 2019

[天江衣](#天江衣)：加强「海底捞月」。  
新增[妹尾佳織](#妹尾佳織)。

### Feb 14, 2019

[高鴨穏乃](#高鴨穏乃)：调整「深山之主」。  
新增[天江衣](#天江衣)。

### Feb 13, 2019

新增[高鴨穏乃](#高鴨穏乃)。

## 人物列表

+ [高鴨穏乃](#高鴨穏乃)
+ [天江衣](#天江衣)
+ [妹尾佳織](#妹尾佳織)
+ [Aislinn Wishart](#Aislinn_Wishart)

## 高鴨穏乃

> 踏过现实中修行的山路  
> 越过尘世间山谷的深处  
> 在那前方的  
> 是深山幽谷的化身

+ 深山之主
	+ 削弱其他三家能力对本局配牌的影响。随着局数增加，能够影响更强的能力和进行更大幅度的削弱。
	+ 使其他三家进张趋于混沌。随着局数增加和牌山深入，其他三家的摸牌结果将愈发难以预测。
	+ 使自己的进张变好。随着局数增加和牌山深入，这个能力将益发明显。

## 天江衣

> 真舒服的风呢  
> 衣喜欢这个季节  
> 不太冷也不太热  
> 新绿的光辉  对夏天的期待高涨  
> 每年的这个时期好像都在变短  真是遗憾  
> 母亲常常这么说  
> 长期的自我实现得不到幸福和快乐  
> 幸福只存在于刹那之间  
> 想分享这些的心向往着爱和娱乐  
> 但是  麻将做不到这些  
> 麻将未必能让四个人分享快乐  
> 和衣打牌的大家  都露出了是像看到了世界末日一样的表情  
> 衣因此  又独自一人被留下来了 

+ 魑魅魍魉
	+ 使其他三家在手牌达到一向听以后进展停滞。
		+ 岭上和鸣牌不受作用。
	+ 容易在早巡直击和牌。
+ 海底捞月
	+ 听牌的下一巡摸牌前将一枚和牌沉入牌山底部，当有人到达海底时取出。
		+ 可以感知和牌残枚不足的情形。
		+ 完成换听的下一巡摸牌前，重复发动此技能。
			+ 此前被沉入海底的和牌，除非受到他家能力作用，将永远沉底。
	+ 容易以鸣牌控制海底方位，相应的，到达海底方位后，他家不容易以鸣牌错开。

## 妹尾佳織

> 三个一堆，三个一堆……  
> 啊，门清自摸对对和。

+ Beginner's Luck
	+ 向听倒退或长时间没有减少向听数时，牌运变好。

## Aislinn Wishart

> “……”  
> （举起画板）

+ 绘制理想
	+ 每局开始时，确定接下来 13 巡自己的进张。
		+ 如果局中出现鸣牌，确定的进张位置也不会改变。
	+ 如果顺利进张，Aislinn 会快速听牌。