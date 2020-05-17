# connectData(fetchData)

用来在路由切换之前获取数据，必须放在所有修饰器的最前面。

## 参数

1. `fetchData(getState, dispatch, location, params)` 获取数据的方法，这个方法必须返回一个 promise。

## [例子](http://git.che3bao.com/autobots/prime-desktop/blob/cd1ef8fdab42243cb9f2a55808bd2f52de09410b/src%2Fcontainers%2FCompany%2FEditPage%2FEditPage.js#L13-17)
