import React from 'react';
import { Select } from 'antd';
import callApi from '../../models/services/callApi';
import NumberSelect from '../NumberSelect/NumberSelect';
const Option = Select.Option;

class StoreSelect extends React.Component {
  constructor(props) {
    super(props);
    this.fetchStores(props.debtorId);
  }

  state = {
    data: [],
    value: []
  };

  fetchStores = value => {
    callApi(`/store/chelaike/?debtorId=${value}`).then(({ response }) => {
      const data = response.data.map(c => ({
        id: c.id,
        name: c.name
      }));
      this.setState({ data });
    });
  };

  render() {
    const { data } = this.state;
    return (
      <NumberSelect {...this.props}>
        {data.map(d => (
          <Option key={d.id} name={d.name}>
            {d.name}
          </Option>
        ))}
      </NumberSelect>
    );
  }
}

export default StoreSelect;
