import React, { Component, PropTypes } from 'react'
import styles from './SearchBarActions.scss'
import { Icon } from 'antd'

export default class SearchBarActions extends Component {
  static propTypes = {
    handleClear: PropTypes.func.isRequired,
    handleToggle: PropTypes.func,
  }

  constructor(props) {
    super(props)

    this.state = {
      closed: true,
    }
  }

  handleToggleInner = () => {
    this.props.handleToggle()
    this.setState({ closed: !this.state.closed })
  }

  render() {
    const { handleClear, handleToggle } = this.props
    const { closed } = this.state

    return (
      <span className={styles.bar}>
        <a href="#" onClick={handleClear}>清空</a>
        {handleToggle &&
          <span className={styles.split}> | </span>
        }
        {handleToggle && closed &&
          <a onClick={this.handleToggleInner}>更多<Icon type="down" /></a>
        }
        {handleToggle && !closed &&
          <a onClick={this.handleToggleInner}>收起<Icon type="up" /></a>
        }
      </span>
    )
  }
}
