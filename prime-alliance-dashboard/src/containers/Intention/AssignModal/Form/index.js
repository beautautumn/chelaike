import React, { PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Form as AForm } from 'antd'
import { FormItem, Select } from 'components'

function Form({ count, fields, handleSubmit }) {
  return (
    <AForm horizontal onSubmit={handleSubmit}>
      <FormItem label={`将这${count}条意向分配给：`}>
        <Select.Company {...fields.companyId} />
      </FormItem>
    </AForm>
  )
}

Form.propTypes = {
  count: PropTypes.number.isRequired,
  fields: PropTypes.object.isRequired,
  handleSubmit: PropTypes.func.isRequired,
}

export default reduxForm({
  form: 'intentionAssign',
  fields: ['companyId'],
})(Form)
