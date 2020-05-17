import test from 'ava'
import sinon from 'sinon'
import app from 'app'
import { mount } from 'enzyme'
import React from 'react'
import Form from 'containers/User/EditPage/Form'

test('Form', t => {
  const props = {
    initialValues: { authorities: [] },
    roles: [],
    onSubmit: sinon.spy(),
    handleCancel() {},
  }

  const wrapper = mount(
    app.mount(<Form {...props} />)
  )

  wrapper.find({ name: 'name' }).simulate('change', { target: { value: 'Meck' } })
  wrapper.find({ name: 'username' }).simulate('change', { target: { value: 'meck' } })
  wrapper.find({ name: 'password' }).simulate('change', { target: { value: 'pa33word' } })
  wrapper.find({ name: 'passwordConfirmation' }).simulate('change', { target: { value: 'pa33word' } }) // eslint-disable-line
  wrapper.find({ name: 'phone' }).simulate('change', { target: { value: '1356789' } })
  wrapper.find({ name: 'email' }).simulate('change', { target: { value: 'meck@meck.com' } })
  wrapper.find({ name: 'note' }).simulate('change', { target: { value: 'enheng' } })
  wrapper.find('form').simulate('submit')

  t.deepEqual(props.onSubmit.firstCall.args[0], {
    id: undefined,
    name: 'Meck',
    username: 'meck',
    password: 'pa33word',
    passwordConfirmation: 'pa33word',
    phone: '1356789',
    email: 'meck@meck.com',
    managerId: undefined,
    state: undefined,
    authorityType: undefined,
    authorityRoleIds: undefined,
    authorities: [],
    note: 'enheng',
  })
})
