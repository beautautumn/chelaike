import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { show as showNotification } from 'redux/modules/notification'
import TemplateUploader from './TemplateUploader'
import cx from 'classnames'
import styles from './PriceTag.scss'
import { Segment } from 'components'

@connect(
  state => ({
    user: state.auth.user
  }),
  dispatch => ({
    ...bindActionCreators({ showNotification }, dispatch)
  })
)
export default class PriceTag extends Component {
  static propTypes = {
    user: PropTypes.object.isRequired,
    showNotification: PropTypes.func.isRequired
  }

  handleUploadSuccess = () => {
    this.props.showNotification({
      type: 'success',
      message: '上传成功',
    })
  }

  handleUploadError = () => {
    this.props.showNotification({
      type: 'error',
      message: '上传失败',
    })
  }

  render() {
    return (
      <Segment id="priceTag" className="ui grid segment">
        <div className="sixteen wide column">
          <h3>价签模板</h3>
          <div className="ui form">
            <div className="field">
              <TemplateUploader
                user={this.props.user}
                handleUploadSuccess={this.handleUploadSuccess}
                handleUploadError={this.handleUploadError}
              >
                <div className={cx('ui', 'primary', 'button', styles.button)}>
                  上传模板
                </div>
              </TemplateUploader>
            </div>
          </div>
        </div>
      </Segment>
    )
  }
}
