import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import config from 'config'
import { Segment } from 'components'

@connect(
  state => ({
    currentUser: state.auth.user
  })
)
export default class WeChat extends Component {
  static propTypes = {
    currentUser: PropTypes.object
  }

  render() {
    const { currentUser } = this.props

    const url = `${config.serverUrl}${config.basePath}/wechats/authorization?AutobotsToken=${currentUser.token}` // eslint-disable-line

    return (
      <Segment className="ui grid segment">
        <div className="sixteen wide column">
          <h3>微信授权</h3>
          <a href={url} target="_blank">
            <img role="presentation" src="https://open.weixin.qq.com/zh_CN/htmledition/res/assets/res-design-download/icon_button3_1.png" />
          </a>
        </div>
      </Segment>
    )
  }
}
