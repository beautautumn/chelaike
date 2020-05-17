# 目录结构

```
components/
  Datepicker/
    Datepicker.js
    Datepicker.scss
  Select/
    Select.js
  index.js
containers/
  Car/
    ListPage/
      ListPage.js
    EditPage/
      EditPage.js
    index.js
  Company/
    EditPage/
      EditPage.js
decorators/
  autoId.js
  connectData.js
  index.js
helpers/
  api.js
  car.js
redux/
  middleware/
    analytics.js
  modules/
    enhancers/
      handleCRUD.js
      handleError.js
    cars.js
    companies.js
    reduer.js
  sagas/
    auth.js
    index.js
  selectors/
    enitites.js
    enumValues.js
utils/
  createAsyncAction.js
  enhanceReducer.js
```

## componts

公用的组件。

## containers

用于路由或 modal 的 [Container Components](https://github.com/reactjs/redux/blob/master/docs/basics/UsageWithReact.md#presentational-and-container-components)，第一层目录按业务逻辑划分为`Car`、`Company`、`User`等。第二层目录开始按页面或 modal 划分。命名约定页面为`xxxPage.js`， 比如：`ListPage.js`，modal 为`xxxModal.js`，比如：`EditModal.js`。

## decorators

[HOC](https://medium.com/@dan_abramov/mixins-are-dead-long-live-higher-order-components-94a0d2f9e750#.4pikdl7x7)。

## helpers

业务相关的帮助方法。

## redux

### middleware

redux middleware

### modules

按业务逻辑划分的 [Duck Modules](https://github.com/erikras/ducks-modular-redux)，

#### enhancers

higher oder reducers，用于抽象不同模块 reducer 之间的相同逻辑。

## sagas

sagas 文件，这块目前还没总结出很好的实践，后面再完善。

## selectors

[Selectors](https://github.com/reactjs/reselect)

## utils

与业务无关的工具方法。
