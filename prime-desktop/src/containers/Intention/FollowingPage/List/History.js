import React from 'react'
import get from 'lodash/get'
import { TimeAgo } from 'components'

export default ({ intention, intentionPushHistoriesById, usersById, handleMoreHistory }) => {
  const intentionPushHistory = get(
    intentionPushHistoriesById,
    intention.latestIntentionPushHistory
  )

  if (!intentionPushHistory) return null

  const executor = get(usersById, intentionPushHistory.executor)

  return (
    <div>
      <div>
        最后操作：
        <TimeAgo date={intentionPushHistory.createdAt} />
      </div>
      <div>
        跟进人：{executor && executor.name}
      </div>
      <div>
        {intentionPushHistory.note}
      </div>
      <div>
        <a href="" onClick={handleMoreHistory(intention.id)}>更多</a>
      </div>
    </div>
  )
}
