import React, { PropTypes } from 'react'
import { Row, Input } from 'antd'
import { FormItem } from 'components'
import { formOptimize } from 'decorators'
import { Element } from 'react-scroll'
import styles from '../../style.scss'

function Description(props) {
  const { interiorNote } = props.fields.car

  return (
    <Element name="description" className={styles.formPanel}>
      <div className={styles.formPanelTitle}>车辆描述</div>
      <Row>
        <FormItem labelCol={{ span: 2 }} wrapperCol={{ span: 21 }} label="瑕疵描述：">
          <Input
            type="textarea"
            autosize
            rows={8}
            placeholder="仅供内部使用"
            {...interiorNote}
          />
        </FormItem>
      </Row>
    </Element>
  )
}

const fields = [
  'car.interiorNote',
]

Description.fields = fields

Description.propTypes = {
  fields: PropTypes.object.isRequired,
}

export default formOptimize(fields)(Description)
