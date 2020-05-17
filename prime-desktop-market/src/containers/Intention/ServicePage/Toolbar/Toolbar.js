import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux-polymorphic'
import { connect } from 'react-redux'
import { show as showModal } from 'redux-modal'
import { show as showNotification } from 'redux/modules/notification'
import { fetch as fetch } from 'redux/modules/intentions'
import { Segment } from 'components'
import styles from './Toolbar.scss'
import { Button, Icon, Menu, Row, Col, Dropdown } from 'antd'
import can from 'helpers/can'

@connect(
  state => ({
    fetchParams: state.intentions.service.fetchParams,
    total: state.intentions.service.total,
    checkedIds: state.intentions.service.checkedIds,
    currentUser: state.auth.user
  }),
  dispatch => ({
    ...bindActionCreators({
      showModal,
      fetch,
      showNotification,
    }, dispatch, 'service')
  })
)
export default class Toolbar extends Component {
  static propTypes = {
    fetchParams: PropTypes.object.isRequired,
    checkedIds: PropTypes.array.isRequired,
    total: PropTypes.number.isRequired,
    showModal: PropTypes.func.isRequired,
    fetch: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    currentUser: PropTypes.object.isRequired
  }

  handleAssign = () => {
    if (this.props.checkedIds.length <= 0) {
      this.props.showNotification({
        type: 'warning',
        message: '请先选择要分配的意向',
      })
    } else {
      this.props.showModal('intentionAssign')
    }
  }

  handleNew = type => () => {
    this.props.showModal('intentionEdit', { type })
  }

  handleSort = () => {
    const { fetchParams, fetch } = this.props
    const orderBy = fetchParams.orderBy === 'desc' ? 'asc' : 'desc'
    fetch('service', { ...fetchParams, orderBy }, true)
  }

  render() {
    const { fetchParams: { orderBy }, total } = this.props
    const iconType = orderBy === 'desc' ? 'arrow-down' : 'arrow-up'

    const menu = (
      <Menu>
        <Menu.Item key="0">
          <a onClick={this.handleNew('seek')}>求购意向</a>
        </Menu.Item>
        <Menu.Divider />
        <Menu.Item key="1">
          <a onClick={this.handleNew('sale')}>出售意向</a>
        </Menu.Item>
      </Menu>
    )

    return (
      <Segment>
        <Row>
          <Col span="10">
            <Button size="large" type="primary" onClick={this.handleSort}>
              创建时间
              {' '}
              <Icon type={iconType} />
            </Button>
            <span className={styles.total}>
              共{total}条意向
            </span>
          </Col>
          <Col span="12" offset="2">
            <Row type="flex" justify="end" className={styles.buttons}>
              {can('坐席录入') &&
                <Dropdown overlay={menu} trigger={['click']}>
                  <Button size="large">添加意向</Button>
                </Dropdown>
              }
            </Row>
          </Col>
        </Row>
      </Segment>
    )
  }
}
