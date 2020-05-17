import React, { PropTypes } from 'react'
import moment from 'moment'
import 'moment/locale/zh-cn'
import styles from './style.scss'

export default function TimeAgo(props) {
  const date = new Date(props.date)
  const dateTime = moment(date).format('YYYY-MM-DDTHH:MM:ssZZ')
  const title = moment(date).format('YYYY-MM-DD HH:mm:ss')
  return (
    <time dateTime={dateTime} title={title} className={styles.time}>
      {moment(date).fromNow()}
    </time>
  )
}

TimeAgo.propTypes = {
  date: PropTypes.string.isRequired,
}
