import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetch, destroy } from 'redux/modules/shops'
import { unify, fetchOne as fetchCompany } from 'redux/modules/companies'
import { show as showNotification } from 'redux/modules/notification'
import { show as showModal } from 'redux-modal'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import RadioGroup from 'react-radio-group'
import { EditModal } from '..'
import { connectData } from 'decorators'
import date from 'helpers/date'
import { Table, Popconfirm } from 'antd'
import { Segment } from 'components'
import Helmet from 'react-helmet'

function fetchData(getState, dispatch) {
  return dispatch(fetchCompany())
}

@connectData(fetchData)
@connect(
  state => ({
    shops: visibleEntitiesSelector('shops')(state),
    company: state.companies.currentCompany,
    destroyed: state.shops.destroyed
  }),
  dispatch => ({
    ...bindActionCreators({
      fetch,
      unify,
      destroy,
      showNotification,
      showModal,
    }, dispatch)
  })
)
export default class ListPage extends Component {
  static propTypes = {
    company: PropTypes.object.isRequired,
    shops: PropTypes.array.isRequired,
    fetch: PropTypes.func.isRequired,
    unify: PropTypes.func.isRequired,
    destroy: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    showModal: PropTypes.func.isRequired,
    destroyed: PropTypes.bool,
    history: PropTypes.object
  }

  componentDidMount() {
    this.props.fetch()
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.destroyed && nextProps.destroyed) {
      this.props.showNotification({
        type: 'success',
        message: '删除成功',
      })
    }
  }

  handleDestroy = shop => () => {
    this.props.destroy(shop.id)
  }

  handleUnifiedManagement = (unified) => {
    this.props.unify(unified)
  }

  handleNew = () => {
    this.props.showModal('shopEdit')
  }

  handleEdit = id => event => {
    event.preventDefault()
    this.props.showModal('shopEdit', { id })
  }

  render() {
    const { shops, company } = this.props
    const unifed = company.settings.unifiedManagement

    const columns = [
      { title: '分店名称', dataIndex: 'name', key: 'name' },
      { title: '联系电话', dataIndex: 'phone', key: 'phone' },
      {
        title: '所属城市',
        key: 'city',
        render: (text, record) => (
          <span>
            {`${record.province ? record.province : ''} ${record.city ? record.city : ''}`}
          </span>
        )
      },
      { title: '分店地址', dataIndex: 'address', key: 'address' },
      { title: '创建时间', dataIndex: 'createdAt', key: 'createdAt' },
      {
        title: '操作',
        key: 'operation',
        render: (text, record) => (
          <span>
            <a href="#" onClick={this.handleEdit(record.key)}>编辑</a>
            <span className="ant-divider"></span>
            <Popconfirm title={`删除分店：${record.name}`} onConfirm={this.handleDestroy(record)}>
              <a href="#">删除</a>
            </Popconfirm>
          </span>
        )
      }
    ]

    const data = shops.map((shop) => ({
      key: shop.id,
      id: shop.id,
      province: shop.province,
      city: shop.city,
      address: shop.address,
      name: shop.name,
      phone: shop.phone,
      createdAt: date(shop.createdAt)
    }))

    return (
      <div>
        <Helmet title="分店管理" />
        <EditModal />

        <div className="ui grid">
          <div className="ten wide column">
            <div className="ui blue button" onClick={this.handleNew}>
              新增分店
            </div>
          </div>
        </div>

        <Segment className="ui grid segment">
          <div className="sixteen wide column">
            <h4>分店管理模式</h4>
            <div className="ui form">
              <div className="field">
                <RadioGroup
                  selectedValue={company.settings.unifiedManagement}
                  onChange={this.handleUnifiedManagement}
                >
                  {Radio => (
                    <div className="fields">
                      <div className="field">
                        <div className="ui radio checkbox">
                          <Radio id="UnifiedManagementTrue" value />
                          <label htmlFor="UnifiedManagementTrue">统一管理</label>
                        </div>
                      </div>
                      <div className="field">
                        <div className="ui radio checkbox">
                          <Radio id="UnifiedManagementFalse" value={false} />
                          <label htmlFor="UnifiedManagementFalse">单独管理</label>
                        </div>
                      </div>
                    </div>
                  )}
                </RadioGroup>
              </div>
              {!unifed &&
                <div className="ui info message">
                  开启分店单独管理模式后，不同分店的车辆和员工将会单独管理，
                  请确认员工与车辆所属分店是否已设置好。
                </div>
              }
            </div>
          </div>
        </Segment>

        <Segment className="ui segment">
          <Table columns={columns} dataSource={data} bordered pagination={{ pageSize: 10 }} />
        </Segment>
      </div>
    )
  }
}
