import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { fetch as fetch } from 'redux/modules/serviceAppointments'
import styles from './ToolBar.scss'
import { Button, Icon, Row, Col } from 'antd'
import { Segment } from 'components'

@connect(
  state => ({
    fetchParams: state.serviceAppointments.fetchParams,
    total: state.serviceAppointments.total
  }),
  { fetch }
)
export default class Toolbar extends Component {
  static propTypes = {
    fetchParams: PropTypes.object.isRequired,
    total: PropTypes.number.isRequired,
    fetch: PropTypes.func.isRequired,
  }

  handleSort = () => {
    const { fetchParams, fetch } = this.props
    const orderBy = fetchParams.orderBy === 'desc' ? 'asc' : 'desc'
    fetch({ ...fetchParams, orderBy }, true)
  }

  render() {
    const { fetchParams: { orderBy }, total } = this.props
    const iconType = orderBy === 'desc' ? 'arrow-down' : 'arrow-up'
    return (
      <Segment>
        <Row>
          <Col span="10">
            <Button size="large" type="primary" onClick={this.handleSort}>
              预约时间
              {' '}
              <Icon type={iconType} />
            </Button>
            <span className={styles.total}>
              共{total}条意向
            </span>
          </Col>
        </Row>
      </Segment>
    )
  }
}
