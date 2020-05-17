import React, { Component, PropTypes } from 'react'
import Rater from 'react-rater'
import './Rating.scss'

const noop = () => {}

export default class Rating extends Component {
  static propTypes = {
    defaultValue: PropTypes.oneOfType([
      PropTypes.number,
      PropTypes.string,
    ]),
    value: PropTypes.oneOfType([
      PropTypes.number,
      PropTypes.string,
    ]),
    onChange: PropTypes.func
  }

  static defaultProps = {
    onChange: noop
  }

  handleRate = (rating, lastRating) => {
    if (typeof lastRating !== 'undefined') {
      this.props.onChange(rating)
    }
  }

  render() {
    const { defaultValue, value, ...passedProps } = this.props

    const rating = value || defaultValue

    return (
      <Rater {...passedProps} rating={rating} onRate={this.handleRate} />
    )
  }
}
