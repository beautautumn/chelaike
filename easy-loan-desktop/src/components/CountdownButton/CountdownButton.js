import React from 'react'
import PropTypes from 'prop-types'
import { Button } from 'antd'

class CountdownButton extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      startCountdown: false,
      countdown: props.duration
    }
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.stopCountdown) this.reset()
  }

  componentWillUnmount() {
    this.reset()
  }

  clickHandle = (event) => {
    this.props.onClick(event)
    this.timer = setInterval(this.tick, 1000)
  }

  tick = () => {
    if (this.state.countdown === 0) this.reset()
    this.setState((preState, props) => ({
      startCountdown: true,
      countdown: preState.countdown - 1
    }))
  }

  reset = () => {
    if (this.timer) clearInterval(this.timer)
    this.setState((preState, props) => ({
      startCountdown: false,
      countdown: props.duration
    }))
  }

  render() {
    const { duration, onClick, stopCountdown, children, ...props } = this.props
    const { startCountdown, countdown } = this.state

    const text = `${countdown}秒后再试`
    return (
      <Button {...props} onClick={this.clickHandle} disabled={startCountdown}>
        {startCountdown ? text : children}
      </Button>
    )
  }
}

CountdownButton.defaultProps = {
  duration: 60,
  stopCountdown: false,
}

CountdownButton.propTypes = {
  duration: PropTypes.number.isRequired,
  onClick: PropTypes.func.isRequired,
  stopCountdown: PropTypes.bool.isRequired,
}

export default CountdownButton
