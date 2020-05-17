import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import Textarea from 'react-textarea-autosize'
import { errorFocus, autoId } from 'decorators'
import { Form, Radio, Upload, Button, Icon, message } from 'antd'
import { FormItem } from 'components'
import config from 'config'
import uuid from 'uuid'

@reduxForm({
  form: 'carDetection',
  fields: [
    'reportType', 'url', 'images'
  ],
})
@errorFocus
@autoId
export default class DetectionEditForm extends Component {
  static propTypes = {
    oss: PropTypes.object.isRequired,
    car: PropTypes.object.isRequired,
    fields: PropTypes.object.isRequired,
  }

  render() {
    const { oss, car, fields } = this.props

    const formItemLayout = {
      labelCol: { span: 5 },
      wrapperCol: { span: 14 },
    }

    const pdfUploaderProps = {
      accept: '.pdf',
      action: config.ossUrl,
      showUploadList: false,
      data: {
        OSSAccessKeyId: oss.ossKey,
        policy: oss.policy,
        Signature: oss.signature,
        success_action_status: 201,
        key: `pdf/${uuid.v4()}.pdf`,
      },
      beforeUpload(file) {
        const isPDF = file.type === 'application/pdf'
        if (!isPDF) {
          message.error('只支持上传PDF文件!')
        }
        return isPDF
      },
      onChange(info) {
        if (info.file.status === 'done') {
          const url = $(info.file.response).find('Location').text() // eslint-disable-line no-undef
          fields.url.onChange(url)
        }
      }
    }

    const imagesList = fields.images.value ?
      fields.images.value
        .filter(img => !img._destroy) // eslint-disable-line
        .map(img => ({
          url: img.url,
          uid: img.id || img.uid,
          id: img.id,
        }))
      : []

    const imagesUploaderProps = {
      action: config.ossUrl,
      listType: 'picture',
      defaultFileList: imagesList,
      data(file) {
        const ext = file.name.split('.').pop()
        return {
          OSSAccessKeyId: oss.ossKey,
          policy: oss.policy,
          Signature: oss.signature,
          success_action_status: 201,
          key: `images/${uuid.v4()}.${ext}`,
        }
      },
      beforeUpload(file) {
        const isImg = file.type.startsWith('image/')
        if (!isImg) {
          message.error('只支持上传图片!')
        }
        return isImg
      },
      onChange(info) {
        const { file } = info
        if (info.file.status === 'removed') {
          fields.images.onChange(fields.images.value.reduce((acc, img) => {
            if (img.id === file.id) {
              img._destroy = true // eslint-disable-line
              acc.push(img)
            } else if (img.uid !== file.uid) {
              acc.push(img)
            }
            return acc
          }, []))
        } else if (info.file.status === 'done') {
          fields.images.onChange(info.fileList.map((file, index) => (
            {
              url: file.url || $(file.response).find('Location').text(), // eslint-disable-line
              sort: index,
              uid: file.uid,
              id: file.id,
            }
          )))
        }
      }
    }

    return (
      <Form horizontal>
        <FormItem {...formItemLayout} label="车辆名称：">
          <p className="ant-form-text">{car.systemName}</p>
        </FormItem>
        <FormItem {...formItemLayout} label="报告类型：">
          <Radio.Group
            {...fields.reportType}
            onChange={event => fields.reportType.onChange(event.target.value)}
          >
            <Radio value="report">外部链接</Radio>
            <Radio value="pdf">PDF报告</Radio>
            <Radio value="image">图片报告</Radio>
          </Radio.Group>
        </FormItem>
        {fields.reportType.value === 'report' && (
          <FormItem {...formItemLayout} label="链接地址：">
            <Textarea rows={2} className="ant-input ant-input-lg" {...fields.url} />
          </FormItem>
        )}
        {fields.reportType.value === 'pdf' && (
          <FormItem {...formItemLayout} label="文件地址：">
            <Upload {...pdfUploaderProps}>
              <Button>
                <Icon type="upload" /> 上传PDF格式检测报告
              </Button>
            </Upload>
            <p>{fields.url.value}</p>
          </FormItem>
        )}
        {fields.reportType.value === 'image' && (
          <FormItem {...formItemLayout} label="图片列表：" >
            <Upload {...imagesUploaderProps}>
              <Button>
                <Icon type="upload" /> 上传图片格式检测报告
              </Button>
            </Upload>
          </FormItem>
        )}
      </Form>
    )
  }
}
