import React, { Component, PropTypes } from 'react'
import { ImageUploader } from 'components'
import styles from '../../style.scss'
import { scale } from 'helpers/image'
import last from 'lodash/last'
import backgroupImg from './logo.png'
import { Button, Icon, Row, Col } from 'antd'

export default class LogoUploader extends Component {
  static propTypes = {
    oss: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired,
    value: PropTypes.string,
    title: PropTypes.string.isRequired,
    children: PropTypes.element,
  }

  handleChange = (images) => {
    if (images) {
      this.props.onChange(last(images).url)
    }
  }

  render() {
    const { oss, value, title, children } = this.props

    const logo = (
      <img
        className={styles.image}
        alt={`联盟${title}`}
        src={value ? scale(value, '250x150') : backgroupImg}
      />
    )

    return (
      <div>
        <label>{`联盟${title}`}</label>
        <Row>
          <Col span="8">{logo}</Col>
          <Col offset="1" span="13">
            <ImageUploader oss={oss} onChange={this.handleChange}>
              <Button className={styles.uploadButton} type="ghost">
                <Icon type="upload" /> 上传{title}
              </Button>
            </ImageUploader>
            {children}
          </Col>
        </Row>
      </div>
    )
  }
}
