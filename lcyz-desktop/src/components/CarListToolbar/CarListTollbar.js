import React from 'react'
import styles from './CarListTollbar.scss'
import SortButton from '../SortButton/SortButton'
import { Button } from 'antd'
import { Segment } from 'components'

export default ({ fields, total, query, onSort }) => (
  <Segment className="ui grid segment">
    <div className="two column row">
      <div className="column">
        <Button.Group>
          {
            fields.map((field) => (
              <SortButton key={field.key} {...{ field, query, onSort }} />
              ))
          }
        </Button.Group>
      </div>

      <div className="column right aligned">
        <p className={styles.total}>找到匹配车辆共 {total} 台</p>
      </div>
    </div>
  </Segment>
)
