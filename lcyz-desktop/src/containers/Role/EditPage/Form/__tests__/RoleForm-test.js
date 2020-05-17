require('semantic-ui')
import 'babel-polyfill'
import expect, { createSpy } from 'expect'
import React from 'react'
import { renderIntoDocument, Simulate } from 'react-addons-test-utils'
import testUtilsAdditions from 'react-testutils-additions'
import { combineReducers, createStore } from 'redux'
import formReducer from 'redux/modules/form'
import { Provider } from 'react-redux'
import Form from '../Form'

describe('Role > EditPage > Form', () => {
  it('call handleSubmit correctly if everything is ok', () => {
    const mockAuthoritiesReduer = (state = { authorities: [] }) => state

    const mockStore = createStore(combineReducers({
      form: formReducer,
      authorities: mockAuthoritiesReduer
    }))

    const props = {
      roles: [{ id: 1, name: '好人' }],
      onSubmit: createSpy(),
      handleCancel: createSpy(),
    }

    const component = renderIntoDocument(
      <Provider store={mockStore}>
        <Form {...props} />
      </Provider>
    )

    const roleForm = testUtilsAdditions.find(component, 'form')[0]

    const inputs = {}
    inputs.name = testUtilsAdditions.find(component, '#name')[0]
    inputs.note = testUtilsAdditions.find(component, '#note')[0]

    Simulate.change(inputs.name, { target: { value: '坏人' } })
    Simulate.change(inputs.note, { target: { value: '我想做个好人' } })

    Simulate.submit(roleForm)

    expect(props.onSubmit.calls[0].arguments[0]).toEqual(
      {
        id: undefined,
        authorities: undefined,
        name: '坏人',
        note: '我想做个好人',
      }
    )
  })
})
