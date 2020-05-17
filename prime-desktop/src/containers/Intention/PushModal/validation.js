import { createValidator, required } from 'utils/validation'

export default createValidator({
  state: [required],
  note: [required],
  processingTime: [(value, data) => {
    if (data.state !== 'interviewed') {
      return required(value)
    }
  }],
  interviewedTime: [(value, data) => {
    if (data.state === 'interviewed') {
      return required(value)
    }
  }],
  estimatedPriceWan: [(value, data) => {
    if (data.checked && data.intentionType === 'sale') {
      return required(value)
    }
  }],
  closingCarId: [(value, data) => {
    if (data.state === 'completed' &&
        data.intentionType === 'seek' &&
        !data.manually
       ) {
      return required(value)
    }
  }],
  closingCarName: [(value, data) => {
    if (data.state === 'completed' &&
        data.intentionType === 'seek' &&
        data.manually
       ) {
      return required(value)
    }
  }],
  depositWan: [(value, data) => {
    if (data.state === 'completed' && data.intentionType === 'seek') {
      return required(value)
    }
  }],
  closingCostWan: [(value, data) => {
    if (data.state === 'completed' && data.intentionType === 'seek') {
      return required(value)
    }
  }],
})
