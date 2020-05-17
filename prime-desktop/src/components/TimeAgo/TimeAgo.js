import React, { Component, PropTypes } from 'react'
import moment from 'moment'
import 'moment/locale/zh-cn'
import styles from './TimeAgo.scss'

export default class TimeAgo extends Component {
  static propTypes = {
    date: PropTypes.string.isRequired
  }

  render() {
    const date = new Date(this.props.date)
    const dateTime = moment(date).format('YYYY-MM-DDTHH:MM:ssZZ')
    const title = moment(date).format('YYYY-MM-DD HH:mm:ss')
    return (
      <time dateTime={dateTime} title={title} className={styles.time}>
        {moment(date).fromNow()}
      </time>
    )
  }
}
