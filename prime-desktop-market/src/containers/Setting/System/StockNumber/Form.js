import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import RadioGroup from 'react-radio-group'
import { Field, NumberInput } from 'components'
import validation from './validation'

@reduxForm({
  form: 'stockNumber',
  fields: [
    'automatedStockNumber', 'automatedStockNumberPrefix', 'automatedStockNumberStart',
    'stockNumberByVin'
  ],
  validate: validation
})
export default class Form extends Component {
  static propTypes = {
    company: PropTypes.object.isRequired,
    fields: PropTypes.object.isRequired,
    handleSubmit: PropTypes.func.isRequired,
    saving: PropTypes.bool.isRequired
  }

  render() {
    const { fields, handleSubmit, saving } = this.props

    return (
      <div>
        <div className="ui form">
          <div className="field">
            <div className="fields">
              <div className="field">

                <RadioGroup
                  selectedValue={fields.automatedStockNumber.value}
                  {...fields.automatedStockNumber}
                >
                  {Radio => (
                    <div className="fields">
                      <div className="field">
                        <div className="ui radio checkbox">
                          <Radio id="AutomatedStockNumberTrue" value />
                          <label htmlFor="AutomatedStockNumberTrue">自定义</label>
                        </div>
                      </div>
                      <div className="field">
                        <div className="ui radio checkbox">
                          <Radio id="AutomatedStockNumberFalse" value={false} />
                          <label htmlFor="AutomatedStockNumberFalse">系统默认生成</label>
                        </div>
                      </div>
                    </div>
                  )}
                </RadioGroup>

              </div>
              {!fields.automatedStockNumber.value &&
                <div className="field">
                  <div className="ui checkbox">
                    <input id="stockNumberByVin" type="checkbox" {...fields.stockNumberByVin} />
                    <label>自动按车架号后6位生成</label>
                  </div>
                </div>
              }
            </div>
          </div>

          {fields.automatedStockNumber.value &&
            <Field className="required field" {...fields.automatedStockNumberPrefix}>
              <label htmlFor="automatedStockNumberPrefix">库存号前缀</label>
              <div className="inline field">
                <input id="name" type="text" {...fields.automatedStockNumberPrefix} />
                <div className="ui left pointing label">
                  例如：HZTC
                </div>
              </div>
            </Field>
          }
          {fields.automatedStockNumber.value &&
            <div className="field">
              <label htmlFor="automatedStockNumberStart">库存号起始值</label>
              <div className="inline field">
                <NumberInput
                  id="automatedStockNumberStart"
                  {...fields.automatedStockNumberStart}
                />
                <div className="ui left pointing label">
                  例如：100（请填写数字）
                </div>
              </div>
            </div>
          }

          <button className="ui blue button" disabled={saving} onClick={handleSubmit}>
            {saving ? '保存中...' : '保存'}
          </button>
        </div>
      </div>
    )
  }
}
