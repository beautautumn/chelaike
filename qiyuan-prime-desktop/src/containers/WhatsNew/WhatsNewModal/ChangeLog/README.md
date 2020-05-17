# 发布流程

如果是比较大的发布，需要写更新说明的，请按以下步骤：

1. 增加`src/constants.js`里的`VERSION`，注意版本号只能是`MAJOR`、`MINOR`、`PATCH`三个数字；
1. 把上一次发布的更新说明从`latest.md`重命名为`x.y.z.md`，如：2.5.0.md；
1. 新建一个`latest.md`来写本次发布的说明。
