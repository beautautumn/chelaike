import { computeNewCarFinalPrice } from 'redux/modules/carPrices'

export const normalize = {
  newCarFinalPriceWan: (value, prevValue, values, prevValues) => {
    const deps = ['newCarGuidePriceWan', 'newCarDiscount', 'newCarAdditionalPriceWan']
    let depsChanged = false
    for (const dep of deps) {
      if (prevValues[dep] && values[dep] !== prevValues[dep]) {
        depsChanged = true
        break
      }
    }
    if (depsChanged) {
      return computeNewCarFinalPrice(
        values.newCarDiscount,
        values.newCarGuidePriceWan,
        values.newCarAdditionalPriceWan
      )
    }
    return value
  }
}
