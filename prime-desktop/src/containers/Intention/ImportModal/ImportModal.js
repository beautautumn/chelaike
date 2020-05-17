import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux-polymorphic'
import { connect } from 'react-redux'
import { batchImport } from 'redux/modules/intentions'
import { Modal, Alert } from 'antd'
import { connectModal } from 'redux-modal'
import { Link } from 'react-router'

@connectModal({ name: 'intentionImport' })
@connect(
  state => ({
    importing: state.intentions.following.importing,
    imported: state.intentions.following.imported,
    error: state.intentions.following.error
  }),
  dispatch => ({
    ...bindActionCreators({ batchImport }, dispatch, 'following')
  })
)
export default class ImportModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    batchImport: PropTypes.func.isRequired,
    handleHide: PropTypes.func.isRequired,
    error: PropTypes.string,
    importing: PropTypes.bool,
    imported: PropTypes.bool
  }

  constructor(props) {
    super(props)

    this.state = { canSubmit: false }
  }

  handleChange = () => {
    this.setState({ canSubmit: true })
  }

  handleSubmit = () => {
    if (!this.state.canSubmit) { return }
    const formData = new FormData()
    formData.append('file', this.file.files[0])
    this.props.batchImport(formData)
  }

  render() {
    const { imported, error, show, handleHide } = this.props

    return (
      <Modal
        title="批量导入"
        width={760}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleSubmit}
      >
        <div>
          {
            imported &&
              <Alert
                message="表格上传成功"
                description={(
                  <div>
                    请等待系统导入，查看
                    <Link to="/import_tasks">导入进度</Link>
                  </div>
                )}
                type="success"
              />
          }
          {
            !imported && error &&
              <Alert message={error.errors} type="error" />
          }
          <h3>步骤1： 请先下载导入模板</h3>

          <a className="ant-btn ant-btn-primary ant-btn-lg" href="http://asset.chelaike.com/import_intentions/客户导入模板.xls">下载客户导入模板</a>

          <h3>步骤2： 上传已填写完的客户表格</h3>

          <input ref={ref => (this.file = ref)} type="file" onChange={this.handleChange} />
        </div>
      </Modal>
    )
  }
}
