import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetch } from 'redux/modules/importTasks'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import date from 'helpers/date'
import { Segment } from 'components'
import Helmet from 'react-helmet'

@connect(
  state => ({
    importTasks: visibleEntitiesSelector('importTasks')(state),
    enumValues: state.enumValues
  }),
  dispatch => ({
    ...bindActionCreators({ fetch }, dispatch)
  })
)
export default class ListPage extends Component {
  static propTypes = {
    importTasks: PropTypes.array.isRequired,
    enumValues: PropTypes.object.isRequired,
    fetch: PropTypes.func.isRequired
  }

  componentDidMount() {
    this.props.fetch()
  }

  render() {
    const { importTasks, enumValues } = this.props

    return (
      <div>
        <Helmet title="导入记录" />
        <h2 className="ui header">导入记录</h2>

        <Segment className="ui grid segment">
          <div className="sixteen wide column">
            <table className="ui celled selectable striped table center aligned">
              <thead>
                <tr>
                  <th>类型</th>
                  <th>状态</th>
                  <th>结果</th>
                  <th>操作人</th>
                  <th>创建时间</th>
                </tr>
              </thead>
              <tbody>
                {importTasks.map((task) => (
                  <tr key={task.id}>
                    <td>{enumValues.import_task.import_task_type[task.importTaskType]}</td>
                    <td>{enumValues.import_task.state[task.state]}</td>
                    <td>
                      {task.state === 'finished' &&
                        <span>
                          成功：{task.info.intentionsImportedCount} 条
                          失败：{task.info.intentionsFailedCount} 条
                          {' '}
                          {task.info.resultFile &&
                            <a href={task.info.resultFile}>下载失败记录</a>
                          }
                        </span>
                      }
                    </td>
                    <td>{task.user && task.user.name}</td>
                    <td>{date(task.createdAt, 'full')}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </Segment>
      </div>
    )
  }
}
