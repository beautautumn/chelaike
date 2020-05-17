import React from 'react';
import { Modal, Form, Input, Select } from 'antd';
import { Map, Marker } from 'react-amap';
import { StoreSelect } from 'components';
import 'isomorphic-fetch';
import layoutConfig from '../../../utils/formItemLayoutFacory';
import { MAP_KEY } from '../../../utils/constants';
import NumberSelect from '../../NumberSelect/NumberSelect';

const FormItem = Form.Item;
const Option = Select.Option;
const TextArea = Input.TextArea;

class StoreModal extends React.Component {
  constructor() {
    super();

    this.mapPlugins = ['MapType', 'Scale', 'ToolBar'];
  }

  /*componentWillReceiveProps(nextProps) {
    if (
      nextProps.form.getFieldValue('longitude') !==
      this.props.form.getFieldValue('longitude')
    ) {
      let longi = nextProps.form.getFieldValue('longitude');
      let lati = nextProps.form.getFieldValue('latitude');
      console.log('longi', longi);
      this.setState({
        position: {
          longitude: longi,
          latitude: lati
        }
      });
    }
  }*/
  markerEvents = {
    created: instance => {
      console.log(
        'Marker 实例创建成功；如果你需要对原生实例进行操作，可以从这里开始；'
      );
      console.log(instance);
    },
    dragend: e => {
      console.log('你拖动了这个图标；调用参数为：');
      console.log(e.lnglat.lng, e.lnglat.lat);
      var result = fetch(
        'http://restapi.amap.com/v3/geocode/regeo?key=' +
          MAP_KEY +
          '&location=' +
          e.lnglat.lng +
          ',' +
          e.lnglat.lat,
        {
          method: 'GET'
        }
      );
      result
        .then(res => {
          return res.json();
        })
        .then(json => {
          console.log(json.regeocode.formatted_address);
          let address = json.regeocode.formatted_address;
          this.props.form.setFieldsValue({ address: address });
          let position = {
            longitude: e.lnglat.lng,
            latitude: e.lnglat.lat
          };
          this.props.form.setFieldsValue(position);
        });
    }
  };

  handleTextAreaChange = e => {
    console.log('e-----', e.target.value);
    var result = fetch(
      'http://restapi.amap.com/v3/geocode/geo?key=' +
        MAP_KEY +
        '&address=' +
        e.target.value,
      //`${this.props.form.getFieldValue('address')}`,
      {
        method: 'GET'
      }
    );
    result
      .then(res => {
        return res.json();
      })
      .then(json => {
        console.log(json);
        if (json.geocodes && json.geocodes.length > 0) {
          let position = {
            longitude: json.geocodes[0].location.split(',')[0],
            latitude: json.geocodes[0].location.split(',')[1]
          };
          console.log('position', position);
          this.props.form.setFieldsValue(position);
        }
      });
  };

  render() {
    const {
      visible,
      onCancel,
      onOk,
      form,
      confirmLoading,
      inventors,
      debtorId
    } = this.props;

    const { getFieldDecorator, getFieldValue } = form;

    getFieldDecorator('id');
    getFieldDecorator('name');
    getFieldDecorator('address');
    getFieldDecorator('userId');

    getFieldDecorator('debtorId');
    getFieldDecorator('storeId');
    getFieldDecorator('longitude');
    getFieldDecorator('latitude');

    const id = getFieldValue('id');

    const address = getFieldValue('address');
    console.log('address----', address);

    const longi = getFieldValue('longitude') || 116.397499;
    const lati = getFieldValue('latitude') || 39.908722;
    console.log('longi---', longi);
    console.log('lati---', lati);

    const position = {
      longitude: longi,
      latitude: lati
    };

    const modalTitle = id ? '修改门店' : '新增门店';

    return (
      <Modal
        title={modalTitle}
        visible={visible}
        confirmLoading={confirmLoading}
        onOk={onOk}
        onCancel={onCancel}
        maskClosable={false}
      >
        <Form>
          <FormItem {...layoutConfig(5, 12)} label="门店">
            {getFieldDecorator('storeId', {
              rules: [{ required: true, message: '请选择门店' }]
            })(<StoreSelect debtorId={debtorId} placeholder="请选择门店" />)}
          </FormItem>

          <FormItem {...layoutConfig(5, 12)} label="盘库员">
            {getFieldDecorator('userId', {
              rules: [{ required: true, message: '请选择盘库员' }]
            })(
              <NumberSelect placeholder="盘库员">
                <Option value="">不限</Option>
                {inventors &&
                  inventors.map(checker => (
                    <Option key={checker.id}>{checker.name}</Option>
                  ))}
              </NumberSelect>
            )}
          </FormItem>

          <FormItem {...layoutConfig(5, 12)} label="地址">
            {getFieldDecorator('address', {
              rules: [{ required: true, message: '请填写地址' }]
            })(
              <TextArea
                placeholder="请填写地址"
                onChange={this.handleTextAreaChange}
              />
            )}
          </FormItem>
          <div style={{ width: '100%', height: 450, alignItems: 'center' }}>
            <Map plugins={this.mapPlugins} center={position} zoom={12}>
              <Marker
                position={position}
                draggable
                events={this.markerEvents}
              />
            </Map>
          </div>
        </Form>
      </Modal>
    );
  }
}

export default Form.create()(StoreModal);
