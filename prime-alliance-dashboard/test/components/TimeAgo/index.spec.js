import test from 'ava'
import React from 'react'
import { shallow } from 'enzyme'
import TimeAgo from 'components/TimeAgo'

test('TimeAgo', t => {
  const wrapper = shallow(<TimeAgo date="2016-06-18" />)

  t.is(wrapper.props().dateTime, '2016-06-18T08:06:00+0800')
  t.is(wrapper.props().title, '2016-06-18 08:00:00')
})
