import React, { Component, PropTypes } from 'react'
import { Button, Table, Icon, Tooltip, Alert, message, Spin } from 'antd'
import che168Logo from '../logo/che168.jpg'
import fiveEightLogo from '../logo/58.jpg'
import ganjiLogo from '../logo/ganji.jpg'
import yicheLogo from '../logo/yiche.jpg'
import styles from '../Publisher.scss'
import { UserSelect, Select, CarImage } from 'components'
import { licensedInfoText, price } from 'helpers/car'
import MissingFieldsModal from '../MissingFieldsModal/MissingFieldsModal'

export default class PublisherList extends Component {
  static propTypes = {
    inModal: PropTypes.bool.isRequired,
    car: PropTypes.object.isRequired,
    contacts: PropTypes.object,
    syncStates: PropTypes.array.isRequired,
    showModal: PropTypes.func.isRequired,
    onContactorChange: PropTypes.func.isRequired,
    push: PropTypes.func.isRequired,
    deletePublish: PropTypes.func.isRequired,
    spinning: PropTypes.bool.isRequired,
  }

  constructor(props) {
    super(props)

    const initState = {
      selectedRowKeys: [],
      selectedRows: []
    }
    this.state = initState
  }

  onSelectChange = (selectedRowKeys, selectedRows) => {
    this.setState({ selectedRowKeys, selectedRows })
  }

  handlePublish = () => {
    const id = this.props.car.id
    const platforms = this.state.selectedRowKeys
    const relations = this.state.selectedRows.map((record) => ({
      platform: record.key,
      contactor: record.contactor
    }))
    this.props.showModal('missingFields', { id, platforms, relations })
  }

  handleSinglePublish = (record) => () => {
    const id = this.props.car.id
    const platforms = [record.key]
    const relations = [{
      platform: record.key,
      contactor: record.contactor
    }]
    this.props.showModal('missingFields', { id, platforms, relations })
  }

  handleDeletePublish = (record) => () => {
    const id = this.props.car.id
    const platform = record.key
    this.props.deletePublish({ carId: id, platform }).then(response => {
      if (response.error) {
        message.error(response.error.message)
      } else {
        message.success('保存成功')
      }
    })
  }

  gotoPlatformBinding = () => {
    this.props.push('/setting/publishers_profile')
  }

  renderErrors(errors) {
    return (
      <ul>
        {errors.map((error) => (<li>{error}</li>))}
      </ul>
    )
  }

  render() {
    const { car, inModal, contacts, syncStates, onContactorChange, spinning } = this.props

    const platformNames = {
      che168: '二手车之家',
      ganji: '赶集网',
      com58: '58同城',
      yiche: '易车网',
      official: '官网',
      weshop: '微店',
    }

    const dataSource = syncStates.reduce((pre, item) => {
      if (item.isBindSuccess) {
        const data = {
          key: item.platform,
          name: platformNames[item.platform]
        }
        pre.push({ ...item, ...data })
      }
      return pre
    }, [])

    if (dataSource.length === 0) {
      return (
        <Alert
          message="您还没有已绑定的发车账号，请先在“系统设置－业务设置－绑定账号”中进行账号绑定。"
          description={<a onClick={this.gotoPlatformBinding}>前往绑定</a>}
          type="warning"
          showIcon
        />
      )
    }

    let licensedInfo = licensedInfoText(car)
    if (licensedInfo.length > 4) licensedInfo += '上牌'
    const secondRowInfo = (
      <div>
        <span className={styles.carInfoSpan}>{licensedInfo}</span>
        <span>{car.mileage}万公里</span>
      </div>
    )
    const thirdRowInfo = price(car.onlinePriceWan, '万')

    const logos = {
      ganji: ganjiLogo,
      che168: che168Logo,
      com58: fiveEightLogo,
      yiche: yicheLogo
    }

    const publishState = {
      unsynced: '未发车',
      pending: '开始发车',
      processing: '发车中',
      finished: '发车成功',
      failed: '发车失败',
    }

    const columns = [{
      title: '平台',
      key: 'key',
      dataIndex: 'key',
      width: 100,
      render: (text, record) => {
        const logo = logos[text]
        if (logo) {
          return (
            <img role="presentation" width={120} className="attached" src={logo} />
          )
        }
        return record.name
      }
    }, {
      title: ' 联系人',
      key: 'contactor',
      dataIndex: 'contactor',
      width: 200,
      render: (text, record) => {
        const selectProps = {
          value: text,
          onChange: onContactorChange(record.key)
        }
        if (['com58', 'ganji'].includes(record.key)) {
          return (
            <UserSelect as="all" {...selectProps} />
          )
        }
        if (record.key === 'che168') {
          return (
            <Select
              items={contacts ? contacts.che168 : []}
              size="default"
              {...selectProps}
            />
          )
        }
        if (record.key === 'yiche') {
          return (
            <Select
              items={contacts ? contacts.yiche : []}
              size="default"
              {...selectProps}
            />
          )
        }
        return '-'
      }
    }, {
      title: '状态',
      key: 'status',
      dataIndex: 'status',
      render: (text, record) => {
        if (record.status) {
          return (
            <div>
              {publishState[record.status.state] + ' '}
              {record.forbidden && record.reason &&
                <Tooltip title={record.reason}>
                  <Icon className={styles.red} type="exclamation-circle-o" />
                </Tooltip>
              }
              {record.status.state === 'failed' &&
               record.status.errors.length > 0 &&
                <Tooltip title={this.renderErrors(record.status.errors)}>
                  <Icon className={styles.red} type="question-circle-o" />
                </Tooltip>
              }
            </div>
          )
        }
        return '-'
      }
    }, {
      title: '操作',
      key: 'operation',
      width: 200,
      render: (text, record) => (
        <div className={styles.operationCell}>
          {record.publishedCarUrl &&
            <a href={record.publishedCarUrl} target="_blank">查看</a>}
          {!['official', 'weshop'].includes(record.key) &&
           !record.forbidden &&
           record.contactor &&
            <a onClick={this.handleSinglePublish(record)}>发车</a>}
          {record.status.state !== 'unsynced' &&
           record.key !== 'che168' &&
            <a onClick={this.handleDeletePublish(record)}>删除</a>}
          {record.backendUrl &&
            <a href={record.backendUrl} target="_blank">进入后台</a>}
        </div>
      )
    }]

    const { selectedRowKeys } = this.state

    const rowSelection = {
      selectedRowKeys,
      onChange: this.onSelectChange,
      getCheckboxProps(record) {
        return {
          disabled: ['official', 'weshop'].includes(record.key) ||
                    record.forbidden ||
                    !record.contactor
        }
      }
    }

    const hasSelected = selectedRowKeys.length > 0

    return (
      <div>
        <div className={styles.carInfo}>
          <div className={styles.carImage}>
            <CarImage car={car} width={76} height={51} />
          </div>
          <div className={styles.carDesc}>
            <div><b>{car.systemName}</b></div>
            {secondRowInfo}
            <div>{thirdRowInfo}</div>
          </div>
        </div>
        <Button
          type="primary"
          size="large"
          disabled={!hasSelected}
          onClick={this.handlePublish}
        >
          一键发车
        </Button>
        <Spin spinning={spinning} size="large">
          <Table
            className={styles.publishers}
            rowSelection={rowSelection}
            dataSource={dataSource}
            columns={columns}
            pagination={false}
          />
        </Spin>
        {!inModal && <div className={styles.placeholder}></div>}
        <MissingFieldsModal />
      </div>
    )
  }
}
