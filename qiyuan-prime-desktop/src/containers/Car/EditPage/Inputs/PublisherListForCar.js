import React, { Component, PropTypes } from 'react'
import { Button, Table, Alert, Row, Col, Spin } from 'antd'
import che168Logo from 'containers/Publisher/logo/che168.jpg'
import fiveEightLogo from 'containers/Publisher/logo/58.jpg'
import ganjiLogo from 'containers/Publisher/logo/ganji.jpg'
import yicheLogo from 'containers/Publisher/logo/yiche.jpg'
import styles from 'containers/Publisher/Publisher.scss'
import { UserSelect, Select } from 'components'
import MissingFieldsModal from 'containers/Publisher/MissingFieldsModal/MissingFieldsModal'

export default class PublisherListForCar extends Component {
  static propTypes = {
    id: PropTypes.number,
    syncStates: PropTypes.array,
    showModal: PropTypes.func.isRequired,
    profile: PropTypes.object,
    onContactorChange: PropTypes.func.isRequired,
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
    const { id } = this.props
    const platforms = this.state.selectedRowKeys
    const relations = this.state.selectedRows.map((record) => ({
      platform: record.key,
      contactor: record.contactor
    }))
    this.props.showModal('missingFields', { id, platforms, relations })
  }

  renderErrors(errors) {
    return (
      <ul>
        {errors.map((error) => (<li>{error}</li>))}
      </ul>
    )
  }

  render() {
    const { syncStates, onContactorChange, id, profile, spinning } = this.props

    const logos = {
      ganji: ganjiLogo,
      che168: che168Logo,
      com58: fiveEightLogo,
      yiche: yicheLogo
    }

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

    const columns = [{
      title: '平台',
      key: 'key',
      dataIndex: 'key',
      width: 150,
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
      width: 250,
      dataIndex: 'contactor',
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
              items={profile ? profile.che168.contacts : []}
              size="default"
              {...selectProps}
            />
          )
        }
        if (record.key === 'yiche') {
          return (
            <Select
              items={profile ? profile.yiche.contacts : []}
              size="default"
              {...selectProps}
            />
          )
        }
        return '-'
      }
    }, {
      title: '',
      key: 'placeholder',
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
        <Row>
          <Col span="3">
            <Button
              type="primary"
              size="large"
              disabled={!hasSelected || !id}
              onClick={this.handlePublish}
            >
              一键发车
            </Button>
          </Col>
          {!id &&
            <Col span="10">
              <Alert
                message="新增入库车辆还未保存，不允许发车！"
                type="warning"
                showIcon
              />
            </Col>
          }
        </Row>
        <Spin spinning={spinning} size="large">
          <Table
            className={styles.publishers}
            rowSelection={rowSelection}
            dataSource={dataSource}
            columns={columns}
            pagination={false}
          />
        </Spin>
        <div className={styles.placeholder}></div>
        <MissingFieldsModal />
      </div>
    )
  }
}
