import React, { Component, PropTypes } from 'react'
import { Form, Input } from 'antd'
import { Segment, FormItem } from 'components'
import styles from './ImportPage.scss'

export default class SearchBar extends Component {
  static propTypes = {
    handleChange: PropTypes.func.isRequired
  }

  render() {
    const { handleChange } = this.props

    const formItemLayout = {
      labelCol: { span: 2 },
      wrapperCol: { span: 22 },
    }

    return (
      <Segment>
        <Form horizontal>
          <FormItem className={styles.searchItem} {...formItemLayout} label="公司名称：">
            <Input type="text" onChange={handleChange} />
          </FormItem>
        </Form>
      </Segment>
    )
  }
}
