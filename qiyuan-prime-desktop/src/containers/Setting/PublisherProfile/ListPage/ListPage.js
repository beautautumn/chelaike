import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetch, destroy } from 'redux/modules/carPublish/profiles'
import { show as showNotification } from 'redux/modules/notification'
import { connectData } from 'decorators'
import { EditModal } from '..'
import { show as showModal } from 'redux-modal'
import date from 'helpers/date'
import { Table, Popconfirm } from 'antd'
import isUndefined from 'lodash/isUndefined'
import { Segment } from 'components'
import Helmet from 'react-helmet'

function fetchData(getState, dispatch) {
  return dispatch(fetch())
}

@connectData(fetchData)
@connect(
  state => ({
    profile: state.carPublish.profiles.platformProfile,
    destroyed: state.carPublish.profiles.destroyed,
  }),
  dispatch => ({
    ...bindActionCreators({
      destroy,
      showNotification,
      showModal
    }, dispatch)
  })
)
export default class ListPage extends Component {
  static propTypes = {
    profile: PropTypes.object,
    destroy: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    showModal: PropTypes.func.isRequired,
    destroyed: PropTypes.bool,
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.destroyed && nextProps.destroyed) {
      this.props.showNotification({
        type: 'success',
        message: '解绑成功',
      })
    }
  }

  handleEdit = (site, siteName) => event => {
    event.preventDefault()
    this.props.showModal('profileEdit', { site, siteName })
  }

  handleDestroy = (site) => () => {
    this.props.destroy(site)
  }

  render() {
    const { profile } = this.props
    const columns = [
      { title: '网站名称', dataIndex: 'name' },
      { title: '绑定账号', dataIndex: 'username' },
      {
        title: '绑定结果',
        dataIndex: 'isSuccess',
        render: (value) => {
          if (isUndefined(value)) return '-'
          return value ? '成功' : '失败'
        }
      },
      { title: '绑定时间', dataIndex: 'bindTime' },
      {
        title: '操作',
        key: 'operation',
        render: (text, record) => (
          <span>
            <a href="#" onClick={this.handleEdit(record.key, record.name)}>编辑</a>
            <span className="ant-divider"></span>
            <Popconfirm title="确认解除账号吗？" onConfirm={this.handleDestroy(record.key)}>
              <a href="#">解除绑定</a>
            </Popconfirm>
          </span>
        )
      }
    ]

    /* {
      key: 'ganji',
      name: '赶集网'
    }, */
    const data = [{
      key: 'che168',
      name: '二手车之家'
    }, {
      key: 'com58',
      name: '58同城'
    }, {
      key: 'yiche',
      name: '易车网'
    }]
    const mergeData = data.map((item) => {
      const site = profile ? profile[item.key] : null
      const ret = { ...item, ...site }
      ret.bindTime = date(ret.bindTime)
      return ret
    })

    return (
      <div>
        <Helmet title="绑定账号" />
        <EditModal />
        <Segment className="ui segment">
          <Table columns={columns} dataSource={mergeData} bordered pagination={false} />
        </Segment>
      </div>
    )
  }
}
