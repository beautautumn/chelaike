import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux-polymorphic'
import { connect } from 'react-redux'
import { show as showModal } from 'redux-modal'
import { show as showNotification } from 'redux/modules/notification'
import { fetch, recive } from 'redux/modules/intentions'
import { Segment, SortButton } from 'components'
import styles from './Toolbar.scss'
import { Popconfirm, Button, Row, Col } from 'antd'

@connect(
  state => ({
    fetchParams: state.intentions.recovery.fetchParams,
    total: state.intentions.recovery.total,
    checkedIds: state.intentions.recovery.checkedIds,
    currentUser: state.auth.user
  }),
  dispatch => ({
    ...bindActionCreators({
      showModal,
      fetch,
      recive,
      showNotification,
    }, dispatch, 'recovery')
  })
)
export default class Toolbar extends Component {
  static propTypes = {
    fetchParams: PropTypes.object.isRequired,
    checkedIds: PropTypes.array.isRequired,
    total: PropTypes.number.isRequired,
    showModal: PropTypes.func.isRequired,
    fetch: PropTypes.func.isRequired,
    recive: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    currentUser: PropTypes.object.isRequired
  }

  handleSort = ({ orderField, orderBy }) => () => {
    const { fetchParams, fetch } = this.props
    fetch('recovery', { ...fetchParams, orderField, orderBy }, true)
  }

  handleRecive = () => {
    if (this.props.checkedIds.length <= 0) {
      return this.props.showNotification({
        type: 'warning',
        message: '请先选择要领取的意向',
      })
    }
    const { recive, checkedIds } = this.props
    recive({ intentionIds: checkedIds })
  }

  renderSortButtons() {
    const fields = [
      { key: 'id', name: '创建时间' },
      { key: 'due_time', name: '下次跟进时间' },
    ]

    const { fetchParams } = this.props

    return fields.map((field) => (
      <SortButton key={field.key} field={field} query={fetchParams} onSort={this.handleSort} />
    ))
  }

  render() {
    const { total, checkedIds } = this.props

    return (
      <Segment>
        <Row>
          <Col span="10">
            <Button.Group>
              {this.renderSortButtons()}
            </Button.Group>
            <span className={styles.total}>
              共{total}条意向
            </span>
          </Col>
          <Col span="12" offset="2">
            <Row type="flex" justify="end" className={styles.buttons}>
              <Popconfirm
                title={'确认领取选中的' + checkedIds.length + '条意向？'}
                onConfirm={this.handleRecive}
              >
                <Button size="large">批量领取</Button>
              </Popconfirm>
            </Row>
          </Col>
        </Row>
      </Segment>
    )
  }
}
